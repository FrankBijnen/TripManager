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
                       Zumo395_595,
                       Zumo590,
                       Zumo3x0, // Works for models 340, 350 and 390
                       Drive51,
                       Drive66,
                       Nuvi2595,
                       Nuvi2599_57,
                       Unknown);

  // Not available to the user:
  // ttTripTrackLoc       = Trip from a track with locations
  TTripOption       = (ttCalc, ttNoCalc, ttTripTrack, ttTripTrackLoc);

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
  TAvoidances       = (avValid = $01, avCarpool = $02, avFerries = $04, avToll = $10, avUnpaved = $20, avU_Turns = $40, avHighWays = $80);

  TRoutePrefRec = record
    Sel: boolean;
    Dt: byte;
    Rm: TRoutePreference;
    Desc: string;
    DescGpx: string;
  end;

  TAdvLevelV6 = packed record
    Curves: byte;
    Hills: byte;
    Highways: byte;
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
    function Unknown2Size: integer;
    function UdbDirUnknown2Size: integer;

    function Unknown3BoundsOffset: integer;
    function Unknown3DistOffset: integer;
    function Unknown3TimeOffset: integer;
    function Unknown3RoutePrefOffset: integer;
    function Unknown3FloatOffset: integer;
    function Unknown3TransportModeOffset: integer;
    function Unknown3MagicOffset: integer;
    function Unknown3AdvLevelV6Offset: integer;
    function Unknown3TimeStampOffset: integer;
    function Unknown3AdvLevelV7Offset: integer;
    function Unknown3ShapeOffset: integer;

    function IsUcs4: boolean;
    function HandleTrailer: boolean;
    function CanCheckSystemTrips: boolean;
  end;

  TOSMRoutePoint = record
    Name: string;
    MapCoords: string;
  end;

  TLatLonTime = class
    Lat:  string;
    Lon:  string;
    Time: string;
  end;

  TUnixDateConv = class
    class function DateTimeAsCardinal(ADateTime: TDateTime): Cardinal;
    class function CardinalAsDateTime(ACardinal: Cardinal): TDateTime;
    class function CardinalAsDateTimeString(ACardinal: Cardinal): string;
  end;

const
{ Constants }
  Trip_StrUnknown                     = 'Unknown';
  Trip_Coord_Decimals                 = '%1.6f';
  Trip_TurnMagic: array[0..1] of byte = ($47, $4E);
  Trip_TripFileName                   = '0:/.System/Trips/%s.trip';
  Trip_UdbDirTurn                     = 'Turn';
  Trip_UdbDirMagic: Cardinal          = $51590469;

{ Elementary data types }
  dtByte            = 1;
  dtCardinal        = 3;
  dtSingle          = 4;
  dtBoolean         = 7;
  dtVersion         = 8;
  dtPosn            = 8;
  dtDWordRoutePref  = 8;
  dtHeader          = 10;
  dtUdbHandle       = 11;
  dtRaw             = 12;
  dtString          = 14;
  dtList            = 128;

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

  UdbDirTypeMap : array[0..8] of TIdentMapEntry =       ( (Value: $00;                      Name: 'Coordinates'),
                                                          (Value: $01;                      Name: 'Route point'),
                                                          (Value: $03;                      Name: 'Route point'),
                                                          (Value: $05;                      Name: 'Route point Center'),
                                                          (Value: $0D;                      Name: 'Route point'),
                                                          (Value: $0F;                      Name: 'Route point'),
                                                          (Value: $14;                      Name: 'Point of interest'),
                                                          (Value: $1F;                      Name: 'Intermediate'),
                                                          (Value: $21;                      Name: 'Begin or end segment') // Direction $16=Start or $17=End
                                                        );

  UdbDirTypeRoutePoints     = [$00, $01, $03, $05, $0D, $0F];
  UdbDirTypeComprLatLon     = [$03, $0D, $0F];
  UdbDirTypeIntermediate    = [$1F];
  UdbDirTypeStartEndSegment = [$21];

  RoutePointMap : array[0..2] of TIdentMapEntry =       ( (Value: Ord(rpVia);               Name: 'Via point'),
                                                          (Value: Ord(rpShaping);           Name: 'Shaping point'),
                                                          (Value: Ord(rpExtShaping);        Name: 'Extended Shaping point')
                                                        );

  AvoidanceMap : array[0..5] of TIdentMapEntry =       (  (Value: Ord(avCarpool);           Name: 'Carpool Lanes'),
                                                          (Value: Ord(avFerries);           Name: 'Ferries'),
                                                          (Value: Ord(avToll);              Name: 'Tolls and Fees'),
                                                          (Value: Ord(avUnpaved);           Name: 'Unpaved Roads'),
                                                          (Value: Ord(avU_Turns);           Name: 'U-Turns'),
                                                          (Value: Ord(avHighWays);          Name: 'Highways')
                                                        );

  DirectionMap : array[0..54] of TIdentMapEntry =       ( (Value: $00;                      Name: 'Continue'),
                                                          (Value: $01;                      Name: 'Bear right'),
                                                          (Value: $02;                      Name: 'Right'),
                                                          (Value: $03;                      Name: 'Sharp right'),
                                                          (Value: $04;                      Name: 'U-Turn'),
                                                          (Value: $05;                      Name: 'Sharp left'),
                                                          (Value: $06;                      Name: 'Left'),
                                                          (Value: $07;                      Name: 'Bear left'),
                                                          (Value: $08;                      Name: 'Ahead'),
                                                          (Value: $0A;                      Name: 'Bear right'),
                                                          (Value: $0B;                      Name: 'Merge'),
                                                          (Value: $0C;                      Name: 'Enter ferry'),
                                                          (Value: $0D;                      Name: 'Leave ferry'),
                                                          (Value: $0E;                      Name: 'Enter roundabout'),
                                                          (Value: $0F;                      Name: 'Leave roundabout 1st exit'),
                                                          (Value: $10;                      Name: 'Leave roundabout 1st exit'),  //LHD
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
                                                          (Value: $20;                      Name: 'Separated lanes'),
                                                          (Value: $22;                      Name: 'Turn right'),
                                                          (Value: $23;                      Name: 'Route point'),
                                                          (Value: $24;                      Name: 'Route point'),
                                                          (Value: $26;                      Name: 'Turn left'),
                                                          (Value: $2A;                      Name: 'Take highway ramp right'),
                                                          (Value: $2E;                      Name: 'Enter turbo roundabout'),
                                                          (Value: $2F;                      Name: 'Leave roundabout 1st exit'),
                                                          (Value: $30;                      Name: 'Leave roundabout 1st exit'), //LHD
                                                          (Value: $39;                      Name: 'Keep right'),
                                                          (Value: $4A;                      Name: 'Take ramp left'),
                                                          (Value: $4F;                      Name: 'Leave roundabout at 2nd exit'),
                                                          (Value: $50;                      Name: 'Leave roundabout at 2nd exit'), //LHD
                                                          (Value: $5A;                      Name: 'Leave tunnel'),
                                                          (Value: $6F;                      Name: 'Leave roundabout at 2nd exit'),
                                                          (Value: $70;                      Name: 'Leave roundabout at 2nd exit'), //LHD
                                                          (Value: $7A;                      Name: 'Leave tunnel'),
                                                          (Value: $88;                      Name: 'Take ramp ahead'),
                                                          (Value: $8A;                      Name: 'Take ramp right'),
                                                          (Value: $8F;                      Name: 'Leave roundabout at 3rd exit'),
                                                          (Value: $90;                      Name: 'Leave roundabout at 3rd exit'), //LHD
                                                          (Value: $AA;                      Name: 'Take highway ramp right'),
                                                          (Value: $AF;                      Name: 'Leave roundabout at 3rd exit'),
                                                          (Value: $B0;                      Name: 'Leave roundabout at 3rd exit'), // LHD
                                                          (Value: $CF;                      Name: 'Leave roundabout at 4th exit'),
                                                          (Value: $D0;                      Name: 'Leave roundabout at 4th exit'), // LHD
                                                          (Value: $EF;                      Name: 'Leave roundabout at 4th exit')
                                                        );
  DirectionLeaveRoutePoint    = [$16];
  DirectionApproachRoutePoint = [$17];
  DefRoutePref                = $0100;
  DefRoutePrefAdv             = $0101;
  DefRoutePrefInclMaps        = $0164;
  NotApplicable               = 'N/A';
  ToBeDefined                 = 'TBD';
  InclMapsSelected            = 'Selected';
  InclMapsNotSelected         = 'Not selected';

  MinAdvLevelUserConfig = 1; // Only these are available to the user.
  AdvLevelMap : array[0..4] of TIdentMapEntry =         ( (Value: Ord(advNA);               Name: NotApplicable),
                                                          (Value: Ord(advLevel1);           Name: 'Faster'),
                                                          (Value: Ord(advLevel2);           Name: 'FastAndAdventurous'),
                                                          (Value: Ord(advLevel3);           Name: 'Adventurous'),
                                                          (Value: Ord(advLevel4);           Name: 'ExtraAdventurous')
                                                        );

  TripExtension           = '.trip';
  TripMask                = '*' + TripExtension;
  SubClassDistFact        = 40075017 / $00ffffff; // 2.39 = Earth circumference / 2^24
  // Model specific values
  CalcUndef               = $00000000;
  CalcNA                  = $ffffffff;
  PosnSmall               =  8;
  PosnNorm                = 12;
  PosnLarge               = 16;

  RoutePrefRecs : array[TCalcMode] of TRoutePrefRec
    = (
        (Sel: true;   Dt: dtByte;            Rm: rmFasterTime;           Desc: 'FasterTime';      DescGpx: 'FasterTime'),
        (Sel: true;   Dt: dtByte;            Rm: rmShorterDistance;      Desc: 'ShorterDistance'; DescGpx: 'ShorterDistance'),
        (Sel: true;   Dt: dtByte;            Rm: rmStraight;             Desc: 'Straight';        DescGpx: 'Direct'),
        (Sel: false;  Dt: dtByte;            Rm: rmAdventurous;          Desc: 'Adventurous';     DescGpx: 'CurvyRoads'),

        (Sel: false;  Dt: dtByte;            Rm: rmOffRoad;              Desc: 'OffRoad';         DescGpx: 'Direct'),
        (Sel: false;  Dt: dtByte;            Rm: rmDirect;               Desc: 'Direct'),
        (Sel: false;  Dt: dtByte;            Rm: rmCurvyRoads;           Desc: 'CurvyRoads'),
        (Sel: false;  Dt: dtByte;            Rm: rmEco;                  Desc: 'Eco';             DescGpx: 'CurvyRoads'),

        (Sel: false;  Dt: dtDWordRoutePref;  Rm: rmDWordFasterTime;      Desc: 'FasterTime'),
        (Sel: false;  Dt: dtDWordRoutePref;  Rm: rmDWordShorterDistance; Desc: 'ShorterDistance'),
        (Sel: false;  Dt: dtDWordRoutePref;  Rm: rmDWordOffRoad;         Desc: 'OffRoad'),
        (Sel: false;  Dt: dtDWordRoutePref;  Rm: rmDWordEco;             Desc: 'Eco'),

        (Sel: false;  Dt: dtByte;            Rm: rmTripTrack;            Desc: 'TripTrack'),
        (Sel: false;  Dt: dtByte;            Rm: rmNA;                   Desc: NotApplicable)
      );

  CalcModesExpl2GPX: array[0..3] of TCalcMode = (cmFasterTime, cmShorterDistance, cmStraight, cmAdventurous);

   // Keep 0 for model Unknown
  UdbDirNameSize: array[TTripModel] of integer = (
      121 * 4,              // XT
      121 * 4,              // XT2
      121 * 4,              // XT3
      121 * 4,              // Tread 2
      122 * 2,              // Zumo 346
       32 * 2,              // Zumo 395 595
       32 * 2,              // Zumo 590
       66 * 2,              // Zumo 3x0
       32 * 2,              // Drive 51
      121 * 4,              // Drive 66
       21 * 2,              // Nuvi 2595
       32 * 2,              // Nuvi 2599_57
            0);             // Unknown

  // Keep 0 for model Unknown
  Unknown3Size: array[TTripModel] of integer = (
      1286,                 // XT
      1446,                 // XT2
      1450,                 // XT3
      1346,                 // Tread 2
       292,                 // Zumo 346
       292,                 // Zumo 395 595
       252,                 // Zumo 590
       128,                 // Zumo 3x0
       292,                 // Drive 51
      1346,                 // Drive 66
       132,                 // Nuvi 2595
       256,                 // Nuvi 2599_57
         0);                // Unknown

  // The Nuvi can have Calculation Magic $00300030, $00310030, $00320030 etc. Therefore CalcUndef
  CalculationMagic: array[TTripModel] of Cardinal = (
      $0538feff,            // XT
      $05d8feff,            // XT2
      $05d8feff,            // XT3
      $0574feff,            // Tread 2
      $0170feff,            // Zumo 346
      $0170feff,            // Zumo 395 595
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
      PosnNorm,             // Zumo 395 595
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
      false,                // Zumo 395 595
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
      false,                // Zumo 395 595
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
      true,                 // Zumo 395 595
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
      (Size:1; Version: 6),  // Zumo 395 595
      (Size:1; Version: 3),  // Zumo 590
      (Size:1; Version: 3),  // Zumo 3x0
      (Size:1; Version: 6),  // Drive 51
      (Size:4; Version: 9),  // Drive 66
      (Size:1; Version: 1),  // Nuvi 2595
      (Size:1; Version: 4),  // Nuvi 2599_57
      (Size:0; Version: 0)); // Unknown

  RoutePrefType: array[TTripModel] of byte = (
      dtByte,               // XT
      dtByte,               // XT2
      dtByte,               // XT3
      dtByte,               // Tread 2
      dtByte,               // Zumo 346
      dtByte,               // Zumo 395 595
      dtByte,               // Zumo 590
      dtDWordRoutePref,     // Zumo 3x0
      dtByte,               // Drive 51
      dtByte,               // Drive 66
      dtDWordRoutePref,     // Nuvi 2595
      dtByte,               // Nuvi 2599_57
      dtByte);              // Unknown

  CalcModesSuppported: array[TTripModel] of set of TCalcMode = (
    [cmFasterTime,      cmShorterDistance,      cmStraight,             cmAdventurous],   // XT
    [cmFasterTime,      cmShorterDistance,      cmStraight,             cmAdventurous],   // XT2
    [cmFasterTime,      cmShorterDistance,      cmStraight,             cmAdventurous],   // XT3
    [cmFasterTime,      cmShorterDistance,      cmStraight,             cmAdventurous],   // Tread 2
    [cmFasterTime,      cmShorterDistance,      cmOffRoad,              cmAdventurous],   // Zumo 346
    [cmFasterTime,      cmShorterDistance,      cmOffRoad,              cmAdventurous],   // Zumo 395 595
    [cmFasterTime,      cmShorterDistance,      cmOffRoad,              cmCurvyRoads],    // Zumo 590
    [cmDWordFasterTime, cmDWordOffRoad,         cmDWordShorterDistance],                  // Zumo 3x0
    [cmFasterTime,      cmShorterDistance,      cmOffRoad],                               // Drive 51
    [cmFasterTime,      cmOffRoad],                                                       // Drive 66
    [cmDWordFasterTime, cmDWordShorterDistance, cmDWordEco,             cmDWordOffRoad],  // Nuvi 2595
    [cmFasterTime,      cmShorterDistance,      cmEco,                  cmOffRoad],       // Nuvi 2599 57
    []                                                                                    // Unknown
  );

 TransportModesSuppported: array[TTripModel] of set of TTransportMode = (
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // XT
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // XT2        Profile overrides?
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // XT3        Profile overrides?
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // Tread 2    Profile overrides?
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // Zumo 346
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // Zumo 395 595
    [tmAutoMotive,      tmMotorcycling,      tmOffRoad],    // Zumo 590
    [tmAutoMotive,      tmMotorcycling],                    // Zumo 3x0
    [tmAutoMotive],                                         // Drive 51
    [tmAutoMotive],                                         // Drive 66
    [tmAutoMotive,      tmPedestrian],                      // Nuvi 2595
    [tmAutoMotive],                                         // Nuvi 2599 57
    []                                                      // Unknown
  );

resourcestring
  TRP_ERR_Not_Supported   = 'Writing not supported for model: %s';
  TRP_WRN_Too_Many_Points = 'Warning: Too many Via points (%d including Begin/End) in: %s';
  TRP_ERR_No_Valid_Trip   = 'Not a valid trip file: %s';
  TRP_ERR_Model_Not_Supp  = 'Model not supported';

function RoutePref2Desc(ARoutePref: TRoutePreference;
                        AModel: TTripModel;
                        OnlySupported: boolean = true): string;
function Desc2RoutePref(ADesc: string;
                        AModel: TTripModel;
                        OnlySupported: boolean = true): TRoutePreference;
function Expl2GpxDesc(const ARoutePreference: TRoutePreference): string;

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

{*** TTripVersion ***}
function TTripVersion.Unknown2Size: integer;
begin
  case (Version) of
    1..4:
      result := 72;     // Nuvi 2595, 2599 57, 3x0, 590
    5..6:
      result := 76;     // Drive 51, 346, 395, 595
    else
      result := 150;    // Drive 66, XT, XT2, XT3, Tread 2
  end;
end;

function TTripVersion.UdbDirUnknown2Size: integer;
begin
  case (Version) of
    1..2:
      result := 16;     // Nuvi 2595
    else
      result := 18;     // Nuvi 2599_57, Drive 51, Drive 66, 3x0, 590, 346, 395, 595, XT, XT2, XT3, Tread 2
  end;
end;

function TTripVersion.Unknown3BoundsOffset: integer;
begin
  case (Version) of
    1..6:
      result := $00;    // Nuvi 2595, 2599_57, Drive 51, 3x0, 346, 590, 395, 595
    else
      result := $02;    // Drive 66, XT, XT2, XT3, Tread 2
  end;
end;

function TTripVersion.Unknown3DistOffset: integer;
begin
  case (Version) of
    1..6:
      result := $10;    // Nuvi 2595, 2599_57, Drive 51, 3x0, 346, 590, 395, 595
    else
      result := $12;    // Drive 66, XT, XT2, XT3, Tread 2
  end;
end;

function TTripVersion.Unknown3TimeOffset: integer;
begin
  case (Version) of
    1..6:
      result := $14;    // Nuvi 2595, 2599_57, Drive 51, 3x0, 346, 590, 395, 595
    else
      result := $16;    // Drive 66, XT, XT2, XT3, Tread 2
  end;
end;

function TTripVersion.Unknown3RoutePrefOffset: integer;
begin
  case (Version) of
    1:
        result := $1c;  // Nuvi 2595
    2,3:
        result := $18;  // 590, 3x0
    4:
        result := $1c;  // Nuvi 2599_57
    5..6:
        result := $18;  // 346, 395, 595, Drive 51
    else
        result := $1a;  // XT, XT2, XT3, Tread2, Drive 66
  end;
end;

function TTripVersion.Unknown3FloatOffset: integer;
begin
  case (Version) of
    1:
        result := $20;  // Nuvi 2595
    2,3:
        result := $1c;  // 590, 3x0
    4:
        result := $20;  // Nuvi 2599_57
    5..6:
        result := $1c;  // 346, 395, 595, Drive 51
    else
        result := $1e;  // XT, XT2, XT3, Tread2, Drive 66
  end;
end;

function TTripVersion.Unknown3TransportModeOffset: integer;
begin
  case (Version) of
    1:
        result := $54;  // Nuvi 2595
    2,3:
        result := $50;  // 590, 3x0
    4:
        result := $54;  // Nuvi 2599_57
    5..6:
        result := $50;  // 346, 395, 595, Drive 51
    else
        result := $52;  // XT, XT2, XT3, Tread2, Drive 66
  end;
end;

function TTripVersion.Unknown3MagicOffset: integer;
begin
  case (Version) of
    1:
      result := $00;    // Nuvi 2595
    2..3:
      result := $54;    // 590, 3x0
    4:
      result := $58;    // Nuvi 2599_57
    5..6:
      result := $54;    // 346, 395, 595, Drive 51
    else
      result := $56;    // XT, XT2, XT3, Tread2, Drive 66
  end;
end;

function TTripVersion.Unknown3AdvLevelV6Offset: integer;
begin
  case (Version) of
    6:
      result := $60;    // 346, 395, 595 (Drive 51 has no adventurous)
    else
      result := $0;
  end;
end;

function TTripVersion.Unknown3TimeStampOffset: integer;
begin
  case (Version) of
    0..5:
      result := $0;
    6:
      result := $68;    // 346, 395, 595, Drive 51
    else
      result := $6a;    // XT, XT2, XT3, Tread2, Drive 66
  end;
end;

function TTripVersion.Unknown3AdvLevelV7Offset: integer;
begin
  case (Version) of
    0..6:
      result := $0;
    else
      result := $6f;    // XT, XT2, XT3, Tread2 (Drive 66 has no adventurous)
  end;
end;

function TTripVersion.Unknown3ShapeOffset: integer;
begin
  case (Version) of
    1:
      result := $00;    // Nuvi 2595
    2..3:
      result := $64;    // 590, 3x0
    4:
      result := $68;    // Nuvi 2599_57
    5..6:
      result := $8c;    // 346, 395, 595, Drive 51
    7..8:
      result := $8e;    // XT
    else
      result := $be;    // XT2, XT3, Tread2, Drive 66
  end;
end;

function TTripVersion.HandleTrailer: boolean;
begin
  case (Version) of
    1..6:               // Haven't see trailers for all these devices. But shouldn't hurt.
      result := true;   // Nuvi 2595, 2599_57, Drive 51, 3x0, 346, 590, 395, 595
    else
      result := false;  // Drive 66, XT, XT2, XT3, Tread 2
  end;
end;

function TTripVersion.IsUcs4: boolean;
begin
  case (Version) of
    1..6:
      result := false;  // Nuvi 2595, 2599_57, Drive 51, 3x0, 346, 590, 395, 595
    else
      result := true;   // Drive 66, XT, XT2, XT3, Tread 2
  end;
end;

function TTripVersion.CanCheckSystemTrips: boolean;
begin
  case (Version) of
    1..6:
      result := false;  // Nuvi 2595, 2599_57, Drive 51, 3x0, 346, 590, 395, 595
    else
      result := true;   // Drive 66, XT, XT2, XT3, Tread 2
  end;
end;

function DefRoutePref2Desc(ARoutePref: TRoutePreference): string;
begin
  if (ARoutePref = TRoutePreference.rmNA) then
    result := RoutePrefRecs[cmNA].Desc
  else
    result := Format('%s (0x%s)', [ToBeDefined, IntTohex(Ord(ARoutePref), 2)]);
end;

function RoutePref2Desc(ARoutePref: TRoutePreference;
                        AModel: TTripModel;
                        OnlySupported: boolean = true): string;
var
  ModelCalcMode: TCalcMode;
begin
  result := DefRoutePref2Desc(ARoutePref);

  for ModelCalcMode := Low(TCalcMode) to High(TCalcMode) do
  begin
    if (OnlySupported) and
       not (ModelCalcMode in CalcModesSuppported[AModel]) then
      continue;

    if (RoutePrefRecs[ModelCalcMode].Dt = RoutePrefType[AModel]) and
       (RoutePrefRecs[ModelCalcMode].Rm = ARoutePref) then
      exit(RoutePrefRecs[ModelCalcMode].Desc);
  end;
end;

function Desc2RoutePref(ADesc: string;
                        AModel: TTripModel;
                        OnlySupported: boolean = true): TRoutePreference;
var
  ModelCalcMode: TCalcMode;
begin
  // Default to FasterTime
  if (RoutePrefType[AModel] = dtDWordRoutePref) then
    result := TRoutePreference.rmDWordFasterTime
  else
    result := TRoutePreference.rmFasterTime;

  for ModelCalcMode in CalcModesSuppported[AModel] do
  begin
    if (OnlySupported) and
       not (ModelCalcMode in CalcModesSuppported[AModel]) then
      continue;

    if (SameText(RoutePrefRecs[ModelCalcMode].Desc, ADesc)) or
       (SameText(RoutePrefRecs[ModelCalcMode].DescGpx, ADesc)) then
      exit(RoutePrefRecs[ModelCalcMode].Rm);
  end;
end;

function Expl2GpxDesc(const ARoutePreference: TRoutePreference): string;
var
  ACalcMode: TCalcMode;
  ARoutePrefRec: TRoutePrefRec;
begin
  result := '';
  for ACalcMode in CalcModesExpl2GPX do
  begin
    ARoutePrefRec := RoutePrefRecs[ACalcMode];
    if (ARoutePrefRec.Rm = ARoutePreference) then
      exit(ARoutePrefRec.DescGpx);
  end;
end;

end.
