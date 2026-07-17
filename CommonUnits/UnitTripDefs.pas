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
                       Nuvi2599_57,
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
  TAvoidances       = (avValid = $01, avCarpool = $02, avFerries = $04, avUnpaved = $20, avU_Turns = $40, avHighWays = $80);
  PAvoidances       = ^ TAvoidances;

  TRoutePrefRec = record
    Sel: boolean;
    DwSize: boolean;
    Rm: TRoutePreference;
    Desc: string;
  end;

  TLocation2Add = record
    RoutePoint: TRoutePoint;
    RoutePref: TRoutePreference;
    AdvLevel: TAdvlevel;
    Lat, Lon: double;
    DepartureDate: TDateTime;
    Name: string;
    Address: string;
  end;

  TTripVersion = packed record
    Size: Cardinal;
    Version: Cardinal;
    function IsUcs4: boolean;
    function Unknown2Size: integer;
    function UdbDirUnknown2Size: integer;
    function Unknown3BoundsOffset: integer;
    function Unknown3MagicOffset: integer;
    function Unknown3ShapeOffset: integer;
    function Unknown3DistOffset: integer;
    function Unknown3TimeOffset: integer;
    function Unknown3FloatOffset: integer;
    function HandleTrailer: boolean;
    function CanCheckSystemTrips: boolean;
  end;

  TOSMRoutePoint = record
    Name: string;
    MapCoords: string;
  end;

  TLatLonDist = class
    Lat:  string;
    Lon:  string;
    Dist: string;
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
  dtHeaderPref    = 10;
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

  AvoidanceMap : array[0..4] of TIdentMapEntry =       (  (Value: Ord(avCarpool);           Name: 'Carpool Lanes'),
                                                          (Value: Ord(avFerries);           Name: 'Ferries'),
                                                          (Value: Ord(avUnpaved);           Name: 'Unpaved Roads'),
                                                          (Value: Ord(avU_Turns);           Name: 'U-Turns'),
                                                          (Value: Ord(avHighWays);          Name: 'Highways')
                                                        );

  DirectionMap : array[0..39] of TIdentMapEntry =       ( (Value: $00;                      Name: 'Continue'),
                                                          (Value: $02;                      Name: 'Right'),
                                                          (Value: $03;                      Name: 'Sharp right'),
                                                          (Value: $04;                      Name: 'U-Turn'),
                                                          (Value: $05;                      Name: 'Sharp left'),
                                                          (Value: $06;                      Name: 'Left'),
                                                          (Value: $07;                      Name: 'Bear to the left'),
                                                          (Value: $08;                      Name: 'Ahead'),
                                                          (Value: $0A;                      Name: 'Bear to the right'),
                                                          (Value: $0B;                      Name: 'Merge'),
                                                          (Value: $0C;                      Name: 'Enter ferry'),
                                                          (Value: $0D;                      Name: 'Leave ferry'),
                                                          (Value: $0E;                      Name: 'Enter roundabout'),
                                                          (Value: $0F;                      Name: 'Leave roundabout 1st exit'),
                                                          (Value: $10;                      Name: 'Take left lane'),
                                                          (Value: $11;                      Name: 'Ahead'),
                                                          (Value: $12;                      Name: 'Right'),
                                                          (Value: $13;                      Name: 'Left'),
                                                          (Value: $14;                      Name: 'Ahead (Next segment)'),
                                                          (Value: $15;                      Name: 'Ahead'),
                                                          (Value: $16;                      Name: 'Leave route point'),
                                                          (Value: $17;                      Name: 'Approach route point'),
                                                          (Value: $18;                      Name: 'Keep left'),
                                                          (Value: $19;                      Name: 'Keep right'),
                                                          (Value: $1A;                      Name: 'Enter tunnel'),
                                                          (Value: $1D;                      Name: 'Route point'),
                                                          (Value: $1F;                      Name: 'Leave roundabout 1st exit'),
                                                          (Value: $22;                      Name: 'Route point'),
                                                          (Value: $23;                      Name: 'Route point'),
                                                          (Value: $24;                      Name: 'Route point'),
                                                          (Value: $2F;                      Name: 'Leave roundabout 1st exit'),
                                                          (Value: $4A;                      Name: 'Take ramp turning left'),
                                                          (Value: $4F;                      Name: 'Leave roundabout at 2nd exit'),
                                                          (Value: $5A;                      Name: 'Leave tunnel'),
                                                          (Value: $6F;                      Name: 'Leave roundabout at 2nd exit'),
                                                          (Value: $88;                      Name: 'Take ramp ahead'),
                                                          (Value: $8A;                      Name: 'Take ramp turning right'),
                                                          (Value: $8F;                      Name: 'Leave roundabout at 3rd exit'),
                                                          (Value: $AF;                      Name: 'Leave roundabout at 3rd exit'),
                                                          (Value: $CF;                      Name: 'Leave roundabout at 4th exit')
                                                        );

  DefRoutePref                = $0100;
  DefRoutePrefAdv             = $0101;
  DefRoutePrefInclMaps        = $0164;
  NotApplicable               = 'N/A';

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
        (Sel: false; DwSize: false;         Rm: rmNA;                   Desc: NotApplicable)
      );

  // Keep 0 for model Unknown
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
       32 * 2,              // Nuvi 2599_57
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
       258,                 // Nuvi 2599_57
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
      CalcUndef,            // Nuvi 2599_57
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
      PosnNorm,             // Nuvi 2599_57
      PosnSmall);           // Unknown

  // The Zumo 3x0 and Nuvi 2595 need recreating .System\Trips
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
      false,                // Nuvi 2599_57
      false);               // Unknown

  // Only seen on the nuvi 2595.
  HasAllLinks: array[TTripModel] of boolean = (
      false,                // XT
      false,                // XT2
      false,                // XT3
      false,                // Tread 2
      false,                // Zumo 346
      false,                // Zumo 595
      false,                // Zumo 590
      false,                // Zumo 3x0
      false,                // Drive 51
      false,                // Drive 66
      true,                 // Nuvi 2595
      false,                // Nuvi 2599_57
      false);               // Unknown

  // Need mParentTripId and mParentTripName.
  // Not avail if using Collections
  SupportsGrouping: array[TTripModel] of boolean = (
      true,                 // XT
      false,                // XT2
      false,                // XT3
      false,                // Tread 2
      true,                 // Zumo 346
      true,                 // Zumo 595
      false,                // Zumo 590
      false,                // Zumo 3x0
      true,                 // Drive 51
      true,                 // Drive 66
      false,                // Nuvi 2595
      false,                // Nuvi 2599_57
      false);               // Unknown

  // The trip version defines many parameters. See record TTripVersion
  TripVersion: array[TTripModel] of TTripVersion = (
      (Size:4; Version: 7),  // XT
      (Size:4; Version:16),  // XT2
      (Size:4; Version:16),  // XT3
      (Size:4; Version:16),  // Tread 2
      (Size:1; Version: 6),  // Zumo 346
      (Size:1; Version: 6),  // Zumo 595
      (Size:1; Version: 3),  // Zumo 590
      (Size:1; Version: 3),  // Zumo 3x0
      (Size:1; Version: 6),  // Drive 51
      (Size:4; Version: 9),  // Drive 66
      (Size:1; Version: 1),  // Nuvi 2595
      (Size:1; Version: 4),  // Nuvi 2599_57
      (Size:0; Version: 0)); // Unknown

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
      false,                // Nuvi 2599_57
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
    []                                                                                    // Unknown
  );

  TransportModesSuppported: array[TTripModel] of set of TTransportMode = (
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // XT
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // XT2        Profile overrides?
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // XT3        Profile overrides?
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // Tread 2    Profile overrides?
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // Zumo 346
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // Zumo 595
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // Zumo 590
    [tmAutoMotive,      tmMotorcycling],                    // Zumo 3x0
    [tmAutoMotive],                                         // Drive 51
    [tmAutoMotive],                                         // Drive 66
    [tmAutoMotive,      tmPedestrian],                      // Nuvi 2595
    [tmAutoMotive],                                         // Nuvi 2599_57
    []                                                      // Unknown
  );

function RoutePref2Desc(ARoutePref: TRoutePreference; AModel: TTripModel): string;
function Desc2RoutePref(ADesc: string; AModel: TTripModel): TRoutePreference;

implementation

uses
  System.SysUtils, System.DateUtils, System.StrUtils;

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
  case (Version) of
    1..6:
      result := false;
    else
      result := true;
  end;
end;

function TTripVersion.Unknown2Size: integer;
begin
  case (Version) of
    1..4:
      result := 72;
    5..6:
      result := 76;
    else
      result := 150;
  end;
end;

function TTripVersion.UdbDirUnknown2Size: integer;
begin
  case (Version) of
    1..2:
      result := 16;
    else
      result := 18;
  end;
end;

function TTripVersion.Unknown3BoundsOffset: integer;
begin
  case (Version) of
    1..6:
      result := $02;
    else
      result := $04;
  end;
end;

//TODO. Not always in Trip files
function TTripVersion.Unknown3MagicOffset: integer;
begin
  case (Version) of
    1:
      result := $00;  // Nuvi 2595
    2..3:
      result := $56;  // 590, 3x0
    4:
      result := $5a;  // Nuvi 2599_57
    5..6:
      result := $56;  // 346, 595, Drive 51
    else
      result := $58;  // XT, XT2, XT3, Tread2, Drive 66
  end;
end;

function TTripVersion.Unknown3ShapeOffset: integer;
begin
  case (Version) of
    1..3:
      result := $66;
    4:
      result := $6a;
    5..6:
      result := $8e;
    7..8:
      result := $90;
    else
      result := $c0;
  end;
end;

function TTripVersion.Unknown3DistOffset: integer;
begin
  case (Version) of
    1..6:
      result := $12;
    else
      result := $14;
  end;
end;

function TTripVersion.Unknown3TimeOffset: integer;
begin
  case (Version) of
    1..6:
      result := $16;
    else
      result := $18;
  end;
end;

function TTripVersion.Unknown3FloatOffset: integer;
begin
  case (Version) of
    1:
        result := $22; // Nuvi 2595
    2,3:
        result := $1e; // 590, 3x0
    4:
        result := $22; // Nuvi 2599_57
    5..6:
        result := $1e; // 346, 595, Drive 51
    else
        result := $20; // XT, XT2, XT3, Tread2, Drive 66
  end;
end;

function TTripVersion.HandleTrailer: boolean;
begin
  case (Version) of
    1..6:
      result := true; // Haven't see trailers for all these devices. But shouldn't hurt.
    else
      result := false;
  end;
end;

function TTripVersion.CanCheckSystemTrips: boolean;
begin
  case (Version) of
    1..6:
      result := false;
    else
      result := true;
  end;
end;

function RoutePref2Desc(ARoutePref: TRoutePreference; AModel: TTripModel): string;
var
  ModelCalcMode: TCalcMode;
begin
  if (ARoutePref = TRoutePreference.rmNA) then
    result := RoutePrefRecs[cmNA].Desc
  else
    result := Format('TBD (0x%s)', [IntTohex(Ord(ARoutePref), 2)]);
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
