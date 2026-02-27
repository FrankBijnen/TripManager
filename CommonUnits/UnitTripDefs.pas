unit UnitTripDefs;

interface

type
  TTripModel    = (XT, XT2, XT3, Tread2, Zumo595, Zumo590, Zumo3x0, Drive51, Drive66, Nuvi2595, Unknown);
  TTripOption   = (ttCalc, ttNoCalc, ttTripTrack, ttTripTrackLoc, ttTripTrackLocPrefs);
  TRoutePreference  = (rmFasterTime       = $00,
                       rmShorterDistance  = $01,
                       rmOffRoad          = $02,
                       rmEco              = $03,
                       rmDirect           = $04,
                       rmCurvyRoads       = $07,
                       rmTripTrack        = $09,
                       rmHills            = $1a,
                       rmNoShape          = $58,
                       rmScenic           = $be,
                       rmPopular          = $ef,
                       rmNA               = $ff);
  TAdvlevel         = (advLevel1          = $00,
                       advLevel2          = $01,
                       advLevel3          = $02,
                       advLevel4          = $03,
                       advNA              = $ff);
  TTransportMode    = (tmDriving          = 0,
                       tmAutoMotive       = 1,
                       tmPedestrian       = 2,
                       tmMotorcycling     = 9,
                       tmOffRoad          = 10);
  TRoutePoint       = (rpVia              = 0,
                       rpShaping          = 1,
                       rpShapingXT2       = 2);
  TUdbDirStatus     = (udsUnchecked, udsRoutePointNOK, udsRoadNOK, UdsRoadOKCoordsNOK, udsCoordsNOK);
  TItemEditMode     = (emNone, emEdit, emPickList, emButton);
  TTripVersion      = packed record
                        Major: integer;
                        Minor: integer;
                      end;
  TUnixDateConv = class
    class function DateTimeAsCardinal(ADateTime: TDateTime): Cardinal;
    class function CardinalAsDateTime(ACardinal: Cardinal): TDateTime;
    class function CardinalAsDateTimeString(ACardinal: Cardinal): string;
  end;

const
  TripExtension           = '.trip';
  TripMask                = '*' + TripExtension;
  CalcUndef               = $00000000;
  CalcNA                  = $ffffffff;
  PosnSmall               =  8;
  PosnNorm                = 12;
  PosnLarge               = 16;

// The Nuvi can have Calculation Magic $00300030, $00310030, $00320030 etc. Therefore CalcUndef
// Assign unique sizes for model UNKNOWN to Unknown2Size and Unknown3Size
// Model specific values                              XT        XT2       XT3       Tread 2   Zumo 595  Zumo 590  Zumo 3x0  Drive 51  Drive 66  nuvi 2595 Unknown
  NeedRecreateTrips:  array[TTripModel] of boolean  =(false,    false,    false,    false,    false,    false,    true,     false,    false,    true,     false);
  Ucs4Model:          array[TTripModel] of boolean  =(true,     true,     true,     true,     false,    false,    false,    false,    true,     false,    true);
  UdbDirNameSize:     array[TTripModel] of integer  =(121 * 4,  121 * 4,  121 * 4,  121 * 4,  32 * 2,   32 * 2,   66 * 2,   32 * 2,   121 * 4,  21 * 2,   64 * 2);
  UdbDirUnknown2Size: array[TTripModel] of integer  =(18,       18,       18,       18,       18,       18,       18,       18,       18,       16,       20);
  Unknown2Size:       array[TTripModel] of integer  =(150,      150,      150,      150,      76,       72,       72,       76,       150,      72,       80);
  Unknown3Size:       array[TTripModel] of integer  =(1288,     1448,     1452,     1348,     294,      254,      130,      294,      1348,     134,      512);
  UdbHandleTrailer:   array[TTripModel] of boolean  =(false,    false,    false,    false,    false,    true,     true,     false,    false,    true,     false);
  CalculationMagic:   array[TTripModel] of Cardinal =($0538feff,$05d8feff,$05d8feff,$0574feff,$0170feff,CalcUndef,CalcUndef,$0170feff,$0574feff,CalcUndef,CalcNA);
  Unknown3ShapeOffset:array[TTripModel] of Cardinal =($90,      $c0,      $c0,      $c0,      $8e,      $66,      $66,      $8e,      $c0,      $00,      $c0);
  Unknown3DistOffset: array[TTripModel] of Cardinal =($14,      $14,      $14,      $14,      $12,      $12,      $12,      $12,      $14,      $12,      $14);
  Unknown3TimeOffset: array[TTripModel] of Cardinal =($18,      $18,      $18,      $18,      $16,      $16,      $16,      $16,      $18,      $16,      $18);
  ScPosnSize:         array[TTripModel] of integer  =(PosnNorm, PosnNorm, PosnLarge,PosnLarge,PosnNorm, PosnSmall,PosnSmall,PosnNorm, PosnNorm, PosnSmall,PosnSmall);
  TripVersion:        array[TTripModel] of TTripVersion =
     ((Major:4; Minor:7),    // XT
      (Major:4; Minor:16),   // XT2
      (Major:4; Minor:16),   // XT3
      (Major:4; Minor:16),   // Tread 2
      (Major:1; Minor:6),    // Zumo 595
      (Major:1; Minor:3),    // Zumo 590
      (Major:1; Minor:3),    // Zumo 3x0
      (Major:1; Minor:6),    // Drive 51
      (Major:4; Minor:9),    // Drive 66
      (Major:1; Minor:1),    // Nuvi 2595
      (Major:0; Minor:0));   // Unknown

implementation

uses
  System.SysUtils, System.DateUtils;

class function TUnixDateConv.DateTimeAsCardinal(ADateTime: TDateTime): Cardinal;
var
  ValueEpoch: int64;
  ValueUnix: int64;
begin
  result := 0;
  if (ADateTime <> 0) then
  begin
    ValueUnix := DateTimeToUnix(ADateTime, false);
    ValueEpoch := DateTimeToUnix(EncodeDateTime(1989, 12, 31, 0, 0, 0, 0));
    result := ValueUnix - ValueEpoch;
  end;
end;

class function TUnixDateConv.CardinalAsDateTime(ACardinal: Cardinal): TDateTime;
var
  ValueEpoch: int64;
begin
  ValueEpoch := ACardinal + DateTimeToUnix(EncodeDateTime(1989,12,31,0,0,0,0)); // Starts from 1989/12/31
  result := UnixToDateTime(ValueEpoch, false);
end;

class function TUnixDateConv.CardinalAsDateTimeString(ACardinal: Cardinal): string;
begin
  result := Format('%s', [DateTimeToStr(CardinalAsDateTime(ACardinal))]);
end;

end.
