unit UnitTripDefs;

interface

uses
  System.Classes;

type

  TTripModel        = (XT,
                       XT2,
                       XT3,
                       Tread2,
                       Zumo346,
                       Zumo595,
                       Zumo590,
                       Zumo3x0, // Works for models 340, 350 and 390
                       Drive51,
                       Drive66,
                       Nuvi2595,
                       Nuvi57,
                       Unknown);

  // Not available to the user:
  // ttTripTrackLoc       = Trip from a track with locations
  // ttTripTrackLocPrefs  = Trip from a track with locations and routepreferences
  TTripOption       = (ttCalc, ttNoCalc, ttTripTrack, ttTripTrackLoc, ttTripTrackLocPrefs);

  // Values in Trip files
  TRoutePreference  = (rmFasterTime           = $00,
                       rmDWordFasterTime      = $00,
                       rmShorterDistance      = $01,
                       rmDWordShorterDistance = $01,
                       rmEco                  = $02,
                       rmDWordOffRoad         = $02,
                       rmDWordDirect          = $02,
                       rmDWordEco             = $03,
                       rmStraight             = $04,
                       rmOffRoad              = $04,
                       rmDirect               = $04,
                       rmCurvyRoads           = $05,
                       rmAdventurous          = $07,
                       rmTripTrack            = $09,
                       rmHills                = $1a,
                       rmNoShape              = $58,
                       rmScenic               = $be,
                       rmPopular              = $ef,
                       rmNA                   = $ff);

  // Supported by device
  TCalcMode         = (cmFasterTime,
                       cmShorterDistance,
                       cmStraight,
                       cmAdventurous,
                       cmOffRoad,
                       cmDirect,
                       cmCurvyRoads,
                       cmEco,
                       cmDWordFasterTime,
                       cmDWordShorterDistance,
                       cmDWordOffRoad,
                       cmDWordEco,
                       cmTripTrack,
                       cmHills,
                       cmNoShape,
                       cmScenic,
                       cmPopular,
                       cmNA);

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
                       rpExtShaping       = 2);
  TUdbDirStatus     = (udsUnchecked, udsRoutePointNOK, udsRoadNOK, UdsRoadOKCoordsNOK, udsCoordsNOK);
  TItemEditMode     = (emNone, emEdit, emPickList, emButton);

  TRoutePrefRec = record
    Sel: boolean;
    DwSize: boolean;
    Rm: TRoutePreference;
    Desc: string;
  end;

  TLocation2Add = record
    TripModel: TTripModel;
    RoutePoint: TRoutePoint;
    RoutePref: TRoutePreference;
    AdvLevel: TAdvlevel;
    Lat, Lon: double;
    DepartureDate: TDateTime;
    Name: string;
    Address: string;
  end;

  TTripVersion = packed record
    Major: Cardinal;
    Minor: Cardinal;
    function IsUcs4: boolean;
    function Unknown2Size: integer;
    function UdbDirUnknown2Size: integer;
    function Unknown3ShapeOffset: cardinal;
    function Unknown3DistOffset: cardinal;
    function Unknown3TimeOffset: cardinal;
    function HandleTrailer: boolean;
    function CanCheckSystemTrips: boolean;
  end;

  TOSMRoutePoint = record
    Name: string;
    MapCoords: string;
  end;

  TUnixDateConv = class
    class function DateTimeAsCardinal(ADateTime: TDateTime): Cardinal;
    class function CardinalAsDateTime(ACardinal: Cardinal): TDateTime;
    class function CardinalAsDateTimeString(ACardinal: Cardinal): string;
  end;

const

{ Elementary data types }
  dtByte          = 1;
  dtCardinal      = 3;
  dtSingle        = 4;
  dtBoolean       = 7;
  dtVersion       = 8;
  dtPosn          = 8;
  dtDWordRoutePref= 8;
  dtLctnPref      = 10;
  dtLinkPref      = 10;
  dtUdbPref       = 10;
  dtUdbHandle     = 11;
  dtRaw           = 12;
  dtString        = 14;
  dtList          = 128;


  biInitiator: AnsiChar = #$09;

  BooleanMap : array[0..1] of TIdentMapEntry =          ( (Value: Ord(False);               Name: 'False'),
                                                          (Value: Ord(True);                Name: 'True')
                                                        );

  TransportModeMap : array[0..4] of TIdentMapEntry =    ( (Value: Ord(tmDriving);           Name: 'Driving'),
                                                          (Value: Ord(tmAutoMotive);        Name: 'Automotive'),
                                                          (Value: Ord(tmPedestrian);        Name: 'Pedestrian'),
                                                          (Value: Ord(tmMotorcycling);      Name: 'Motorcycling'),
                                                          (Value: Ord(tmOffRoad);           Name: 'OffRoad')
                                                        );

  RoutePointMap : array[0..2] of TIdentMapEntry =       ( (Value: Ord(rpVia);               Name: 'Via point'),
                                                          (Value: Ord(rpShaping);           Name: 'Shaping point'),
                                                          (Value: Ord(rpExtShaping);        Name: 'Extended Shaping point')
                                                        );

  DefRoutePref: word                = $0100;
  DefRoutePrefAdv: word             = $0101;
  DefRoutePrefHillsAndCurves: word  = $0164;
  NotApplicable                     = 'N/A';

  MinAdvLevelUserConfig = 1; // Only these are available to the user.
  AdvLevelMap : array[0..4] of TIdentMapEntry =         ( (Value: Ord(advNA);               Name: NotApplicable),
                                                          (Value: Ord(advLevel1);           Name: 'Faster'),
                                                          (Value: Ord(advLevel2);           Name: 'FastAndAdventurous'),
                                                          (Value: Ord(advLevel3);           Name: 'Adventurous'),
                                                          (Value: Ord(advLevel4);           Name: 'ExtraAdventurous')
                                                        );

  TripExtension           = '.trip';
  TripMask                = '*' + TripExtension;

// Model specific values
  CalcUndef               = $00000000;
  CalcNA                  = $ffffffff;
  PosnSmall               =  8;
  PosnNorm                = 12;
  PosnLarge               = 16;

  RoutePrefRecs : array[TCalcMode] of TRoutePrefRec
    = (
        (Sel: true;  DwSize: false;         Rm: rmFasterTime;           Desc: 'FasterTime'),
        (Sel: true;  DwSize: false;         Rm: rmShorterDistance;      Desc: 'ShorterDistance'),
        (Sel: true;  DwSize: false;         Rm: rmStraight;             Desc: 'Straight'),
        (Sel: false; DwSize: false;         Rm: rmAdventurous;          Desc: 'Adventurous'),

        (Sel: false; DwSize: false;         Rm: rmOffRoad;              Desc: 'OffRoad'),
        (Sel: false; DwSize: false;         Rm: rmDirect;               Desc: 'Direct'),
        (Sel: false; DwSize: false;         Rm: rmCurvyRoads;           Desc: 'CurvyRoads'),
        (Sel: false; DwSize: false;         Rm: rmEco;                  Desc: 'Eco'),

        (Sel: false; DwSize: true;          Rm: rmDWordFasterTime;      Desc: 'FasterTime'),
        (Sel: false; DwSize: true;          Rm: rmDWordShorterDistance; Desc: 'ShorterDistance'),
        (Sel: false; DwSize: true;          Rm: rmDWordOffRoad;         Desc: 'OffRoad'),
        (Sel: false; DwSize: true;          Rm: rmDWordEco;             Desc: 'Eco'),

        (Sel: false; DwSize: false;         Rm: rmTripTrack;            Desc: 'TripTrack'),
        (Sel: false; DwSize: false;         Rm: rmHills;                Desc: 'Hills'),
        (Sel: false; DwSize: false;         Rm: rmNoShape;              Desc: 'NoShape'),
        (Sel: false; DwSize: false;         Rm: rmScenic;               Desc: 'Scenic'),
        (Sel: false; DwSize: false;         Rm: rmPopular;              Desc: 'Popular'),
        (Sel: false; DwSize: false;         Rm: rmNA;                   Desc: NotApplicable)
      );

  UdbDirNameSize: array[TTripModel] of integer = (
      121 * 4,              // XT
      121 * 4,              // XT2
      121 * 4,              // XT3
      121 * 4,              // Tread 2
      122 * 2,              // Zumo 346
       32 * 2,              // Zumo 595
       32 * 2,              // Zumo 590
       66 * 2,              // Zumo 3x0
       32 * 2,              // Drive 51
      121 * 4,              // Drive 66
       21 * 2,              // Nuvi 2595
       32 * 2,              // Nuvi 57
            0);             // Unknown

// Keep 0 for model Unknown
  Unknown3Size: array[TTripModel] of integer = (
      1288,                 // XT
      1448,                 // XT2
      1452,                 // XT3
      1348,                 // Tread 2
       294,                 // Zumo 346
       294,                 // Zumo 595
       254,                 // Zumo 590
       130,                 // Zumo 3x0
       294,                 // Drive 51
      1348,                 // Drive 66
       134,                 // Nuvi 2595
       258,                 // Nuvi 57
         0);                // Unknown

// The Nuvi can have Calculation Magic $00300030, $00310030, $00320030 etc. Therefore CalcUndef
  CalculationMagic: array[TTripModel] of Cardinal = (
      $0538feff,            // XT
      $05d8feff,            // XT2
      $05d8feff,            // XT3
      $0574feff,            // Tread 2
      $0170feff,            // Zumo 346
      $0170feff,            // Zumo 595
      CalcUndef,            // Zumo 590
      CalcUndef,            // Zumo 3x0
      $0170feff,            // Drive 51
      $0574feff,            // Drive 66
      CalcUndef,            // Nuvi 2595
      CalcUndef,            // Nuvi 57
      CalcNA);              // Unknown

  ScPosnSize: array[TTripModel] of integer = (
      PosnNorm,             // XT
      PosnNorm,             // XT2
      PosnLarge,            // XT3
      PosnLarge,            // Tread 2
      PosnNorm,             // Zumo 346
      PosnNorm,             // Zumo 595
      PosnSmall,            // Zumo 590
      PosnSmall,            // Zumo 3x0
      PosnNorm,             // Drive 51
      PosnNorm,             // Drive 66
      PosnSmall,            // Nuvi 2595
      PosnNorm,             // Nuvi 57
      PosnSmall);           // Unknown

// The Zum3x0 and Nuvi2595 need recreating .System\Trips
// Otherwise trips can get duplicated, causing long time to boot up.
  NeedRecreateTrips: array[TTripModel] of boolean = (
      false,                // XT
      false,                // XT2
      false,                // XT3
      false,                // Tread 2
      false,                // Zumo 346
      false,                // Zumo 595
      false,                // Zumo 590
      true,                 // Zumo 3x0
      false,                // Drive 51
      false,                // Drive 66
      true,                 // Nuvi 2595
      false,                // Nuvi 57
      false);               // Unknown

  SupportsGrouping: array[TTripModel] of boolean = (
      true,                 // XT
      false,                // XT2
      false,                // XT3
      false,                // Tread 2
      true,                 // Zumo 346
      true,                 // Zumo 595
      false,                // Zumo 590
      false,                // Zumo 3x0
      false,                // Drive 51
      true,                 // Drive 66
      false,                // Nuvi 2595
      false,                // Nuvi 57
      false);               // Unknown

// The trip version defines many parameters. See record TTripVersion
  TripVersion: array[TTripModel] of TTripVersion = (
      (Major:4; Minor: 7),  // XT
      (Major:4; Minor:16),  // XT2
      (Major:4; Minor:16),  // XT3
      (Major:4; Minor:16),  // Tread 2
      (Major:1; Minor: 6),  // Zumo 346
      (Major:1; Minor: 6),  // Zumo 595
      (Major:1; Minor: 3),  // Zumo 590
      (Major:1; Minor: 3),  // Zumo 3x0
      (Major:1; Minor: 6),  // Drive 51
      (Major:4; Minor: 9),  // Drive 66
      (Major:1; Minor: 1),  // Nuvi 2595
      (Major:1; Minor: 4),  // Nuvi 57
      (Major:0; Minor: 0)); // Unknown

// False TmRoutePreference has dtByte (1)
// True  TmRoutePreference has dtWordRoutePref (8)
  RoutePrefDWordSize: array[TTripModel] of boolean = (
      false,                // XT
      false,                // XT2
      false,                // XT3
      false,                // Tread 2
      false,                // Zumo 346
      false,                // Zumo 595
      false,                // Zumo 590
      true,                 // Zumo 3x0
      false,                // Drive 51
      false,                // Drive 66
      true,                 // Nuvi 2595
      false,                // Nuvi 57
      false);               // Unknown

  CalcModesSuppported: array[TTripModel] of set of TCalcMode = (
    [cmFasterTime,      cmShorterDistance,      cmStraight,             cmAdventurous],   // XT
    [cmFasterTime,      cmShorterDistance,      cmStraight,             cmAdventurous],   // XT2
    [cmFasterTime,      cmShorterDistance,      cmStraight,             cmAdventurous],   // XT3
    [cmFasterTime,      cmShorterDistance,      cmStraight,             cmAdventurous],   // Tread 2
    [cmFasterTime,      cmShorterDistance,      cmOffRoad,              cmAdventurous],   // Zumo 346
    [cmFasterTime,      cmShorterDistance,      cmOffRoad,              cmAdventurous],   // Zumo 595
    [cmFasterTime,      cmShorterDistance,      cmOffRoad,              cmCurvyRoads],    // Zumo 590
    [cmDWordFasterTime, cmDWordOffRoad,         cmDWordShorterDistance],                  // Zumo 3x0
    [cmFasterTime,      cmShorterDistance,      cmOffRoad],                               // Drive 51
    [cmFasterTime,      cmOffRoad],                                                       // Drive 66
    [cmDWordFasterTime, cmDWordShorterDistance, cmDWordEco,             cmDWordOffRoad],  // Nuvi 2595
    [cmFasterTime,      cmShorterDistance,      cmEco,                  cmOffRoad],       // Nuvi 57
    [cmFasterTime]                                                                        // Unknown
  );

function RoutePref2Desc(ARoutePref: TRoutePreference; AModel: TTripModel): string;
function Desc2RoutePref(ADesc: string; AModel: TTripModel): TRoutePreference;

implementation

uses
  System.SysUtils, System.DateUtils, System.StrUtils,
  UnitRegistry;

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

function TTripVersion.IsUcs4: boolean;
begin
  result := (Major >= 4);
end;

function TTripVersion.Unknown2Size: integer;
begin
  result := 0;    // Dummy value
  case (Major) of
   1: begin
        if (Minor < 5) then
          result := 72
        else
          result := 76;
      end;
   4: result := 150;
  end;
end;

function TTripVersion.UdbDirUnknown2Size: integer;
begin
  result := 18;
  if (Major = 1) and
     (Minor < 3) then
    result := 16;
end;

function TTripVersion.Unknown3ShapeOffset: cardinal;
begin
  result := 0;
  case (Major) of
    1:begin
        if (Minor < 4) then
          result := $66
        else if (Minor < 5) then
          result := $6a
        else
          result := $8e;
      end;
    4:begin
        if (Minor < 9) then
          result := $90
        else
          result := $c0;
      end;
  end;
end;

function TTripVersion.Unknown3DistOffset: cardinal;
begin
  result := 0;
  case (Major) of
    1: result := $12;
    4: result := $14;
  end;
end;

function TTripVersion.Unknown3TimeOffset: cardinal;
begin
  result := 0;
  case (Major) of
    1: result := $16;
    4: result := $18;
  end;
end;

function TTripVersion.HandleTrailer: boolean;
begin
  result := false;
  if (Major <= 1) then // Haven't see trailers for all Major=1 devices. But shouldn't hurt.
    result := true;
end;

function TTripVersion.CanCheckSystemTrips: boolean;
begin
  result := (Major >= 4);
end;

function RoutePref2Desc(ARoutePref: TRoutePreference; AModel: TTripModel): string;
var
  ModelCalcMode: TCalcMode;
begin
  result := RoutePrefRecs[cmNA].Desc;
  for ModelCalcMode in CalcModesSuppported[AModel] do
  begin
    if (RoutePrefRecs[ModelCalcMode].DwSize <> RoutePrefDWordSize[AModel]) then
      continue;
    if (RoutePrefRecs[ModelCalcMode].Rm = ARoutePref) then
      exit(RoutePrefRecs[ModelCalcMode].Desc);
  end;
end;

function GpxDesc2TripDesc(ADesc: string): string;
begin
  result := '';
  if (SameText(ADesc, 'Direct')) then
    result := #9 + 'Straight' + #9 + 'OffRoad';
  if (SameText(ADesc, 'CurvyRoads')) then
    result := #9 + 'Adventurous' + #9 + 'Eco';
end;

function Desc2RoutePref(ADesc: string; AModel: TTripModel): TRoutePreference;
var
  ModelCalcMode: TCalcMode;
  Aliases: string;
begin
  // Default to FasterTime
  if (RoutePrefDWordSize[AModel]) then
    result := TRoutePreference.rmDWordFasterTime
  else
    result := TRoutePreference.rmFasterTime;

  Aliases := GpxDesc2TripDesc(ADesc);
  for ModelCalcMode in CalcModesSuppported[AModel] do
  begin
    if (SameText(RoutePrefRecs[ModelCalcMode].Desc, ADesc)) or
       (ContainsText(Aliases, #9 + RoutePrefRecs[ModelCalcMode].Desc)) then
      exit(RoutePrefRecs[ModelCalcMode].Rm);
  end;
end;

end.
