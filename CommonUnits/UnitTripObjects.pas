unit UnitTripObjects;
{.$DEFINE DEBUG_POS}
{.$DEFINE DEBUG_ENUMS}
//TODO RoadSpeed  Make the road speeds configurable
interface

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Winapi.Windows,
  UnitGpxDefs;

const
  XT_Name                           = 'zūmo XT';
  XT2_Name                          = 'zūmo XT2';
  XT2_VehicleProfileGuid            = 'dbcac367-42c5-4d01-17aa-ecfe025f2d1c';
  XT2_VehicleProfileHash            = '135656608'; // Not used
  TmScPosnSize                      = 12;
  XT2_VehicleId                     = '1';
  XT2_VehicleProfileTruckType       = '7';
  XT2_AvoidancesChangedTimeAtSave   = '';
  XT2_VehicleProfileName            = 'z' + #0363 + 'mo Motorcycle';
  // Tread 2 is almost an XT2
  Tread2_Name                       = 'Tread 2';
  Tread2_VehicleProfileName         = 'Tread Profile';
  Tread2_VehicleProfileGuid         = 'c21c922c-553f-4783-85f8-c0a13f52d960';
  Tread2_VehicleProfileHash         = '61578528'; // Not used
  Tread2_TmScPosnSize               = 16;
  Zumo595Name                       = 'zumo 595';
  Drive51Name                       = 'Drive 51';
  Zumo3x0Name                       = 'zūmo 3x0';
  Zumo340_TmScPosnSize              = 8;
  TurnMagic: array[0..3] of byte    = ($47, $4E, $00, $00);

type
  TEditMode         = (emNone, emEdit, emPickList, emButton);
  TTripModel        = (XT, XT2, Tread2, Zumo595, Drive51, Zumo3x0, Nuvi2595, Unknown);
  //Drive 51 = 595
  TRoutePreference  = (rmFasterTime       = $00,
                       rmShorterDistance  = $01,
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
  TTransportMode    = (tmAutoMotive       = 1,
                       tmMotorcycling     = 9,
                       tmOffRoad          = 10);
  TRoutePoint       = (rpVia              = 0,
                       rpShaping          = 1,
                       rpShapingXT2       = 2);
  TUdbDirStatus     = (udsUnchecked, udsRoutePointNOK, udsRoadNOK, UdsRoadOKCoordsNOK, udsCoordsNOK);
  TTripOption       = (ttCalc, ttNoCalc, ttTripTrack, ttTripTrackLoc, ttTripTrackLocPrefs);

{ Elementary data types }
const
  dtByte          = 1;
  dtCardinal      = 3;
  dtSingle        = 4;
  dtBoolean       = 7;
  dtVersion       = 8;
  dtPosn          = 8;
  dt3x0RoutePref  = 8;
  dtLctnPref      = 10;
  dtUdbPref       = 10;
  dtUdbHandle     = 11;
  dtRaw           = 12;
  dtString        = 14;
  dtList          = 128;

  biInitiator: AnsiChar = #$09;

  BooleanMap : array[0..1] of TIdentMapEntry =          ( (Value: Ord(False);               Name: 'False'),
                                                          (Value: Ord(True);                Name: 'True')
                                                        );
  DefRoutePref: word = $0100;
  DefRoutePrefAdv: word = $0101;
  DefRoutePrefHillsAndCurves: word = $0164;
  MinRoutePreferenceUserConfig = 0; // Only these are available to the user.
  MaxRoutePreferenceUserConfig = 3;
  RoutePreferenceAdventurous = 3;
  RoutePreferenceMap : array[0..10] of TIdentMapEntry = ( (Value: Ord(rmFasterTime);        Name: 'FasterTime'),
                                                          (Value: Ord(rmShorterDistance);   Name: 'ShorterDistance'),
                                                          (Value: Ord(rmDirect);            Name: 'Direct'),
                                                          (Value: Ord(rmCurvyRoads);        Name: 'Adventurous'),
                                                          (Value: Ord(rmCurvyRoads);        Name: 'CurvyRoads'),
                                                          (Value: Ord(rmTripTrack);         Name: 'TripTrack'),
                                                          (Value: Ord(rmHills);             Name: 'Hills'),
                                                          (Value: Ord(rmPopular);           Name: 'Popular'),
                                                          (Value: Ord(rmNoShape);           Name: 'No Shape'),
                                                          (Value: Ord(rmScenic);            Name: 'Scenic'),
                                                          (Value: Ord(rmNA);                Name: 'N/A')
                                                        );

  MinAdvLevelUserConfig = 1; // Only theses are available to the user.
  MaxAdvLevelUserConfig = 4;
  AdvLevelMap : array[0..4] of TIdentMapEntry =         ( (Value: Ord(advNA);               Name: 'N/A'),
                                                          (Value: Ord(advLevel1);           Name: 'Faster'),
                                                          (Value: Ord(advLevel2);           Name: 'FastAndAdventurous'),
                                                          (Value: Ord(advLevel3);           Name: 'Adventurous'),
                                                          (Value: Ord(advLevel4);           Name: 'ExtraAdventurous')
                                                        );

  TransportModeMap : array[0..2] of TIdentMapEntry =    ( (Value: Ord(tmAutoMotive);        Name: 'Automotive'),
                                                          (Value: Ord(tmMotorcycling);      Name: 'Motorcycling'),
                                                          (Value: Ord(tmOffRoad);           Name: 'OffRoad')
                                                        );

  RoutePointMap : array[0..2] of TIdentMapEntry =       ( (Value: Ord(rpVia);               Name: 'Via point'),
                                                          (Value: Ord(rpShaping);           Name: 'Shaping point'),
                                                          (Value: Ord(rpShapingXT2);        Name: 'Shaping point XT(2)')
                                                        );
  UdbDirTurn              = 'Turn';
  StringLoaded: word      = $ffff;
  UdbDirMagic:  Cardinal  = $51590469;

// Assign unique sizes for model UNKNOWN to Unknown2Size and Unknown3Size
// Model specific values                              XT        XT2       Tread 2   Zumo 595  Drive 51  Zumo 340  Nuvi 2595 Unknown
  SafeToSave:         array[TTripModel] of boolean  =(true,     true,     true,     true,     false,    false,    false,    false);
  Ucs4Model:          array[TTripModel] of boolean  =(true,     true,     true,     false,    false,    false,    false,    true);
  UdbDirAddressSize:  array[TTripModel] of integer  =(121 * 4,  121 * 4,  121 * 4,  32 * 2,   32 * 2,   66 * 2,   21 * 2,   64 * 2);
  UdbDirUnknown2Size: array[TTripModel] of integer  =(18,       18,       18,       18,       18,       18,       16,       20);
  Unknown2Size:       array[TTripModel] of integer  =(150,      150,      150,      76,       76,       72,       72,       80);
  Unknown3Size:       array[TTripModel] of integer  =(1288,     1448,     1348,     294,      294,      130,      134,      512);
  UdbHandleTrailer:   array[TTripModel] of boolean  =(false,    false,    false,    false,    false,    true,     true,     false);
  CalculationMagic:   array[TTripModel] of Cardinal =($0538feff,$05d8feff,$0574feff,$0170feff,$0170feff,$00000000,$00300030,$ffffffff);
  Unknown3ShapeOffset:array[TTripModel] of Cardinal =($90,      $c0,      $c0,      $8e,      $8e,      $66,      $66,      $90);
  Unknown3DistOffset: array[TTripModel] of integer  =($14,      $14,      $14,      $12,      $12,      $12,      $12,      $14);
  Unknown3TimeOffset: array[TTripModel] of integer  =($18,      $18,      $18,      $16,      $16,      $16,      $16,      $18);
  VersionSize:        array[TTripModel] of integer  =($08,      $08,      $08,      $05,      $05,      $05,      $05,      $08);

type
  TTripList = class;

  TOSMRoutePoint = record
    Name: string;
    MapCoords: string;
  end;

  TBaseItem = class(TPersistent)
  private
    FInitiator:        AnsiChar;                 // $09
    FStartPos:         Cardinal;
    FEndPos:           Cardinal;
    FCalculated:       boolean;
    FTripList:         TTripList;
    procedure Calculate(AStream: TMemoryStream); virtual;
    procedure BeginWrite(AStream: TMemoryStream); virtual;
    procedure WriteValue(AStream: TMemoryStream); virtual; abstract;
    procedure EndWrite(AStream: TMemoryStream); virtual;
    procedure Write(AStream: TMemoryStream); virtual;
    function SubLength: Cardinal; virtual;
    function GetPickList: string; virtual;
    function GetEditMode: TEditMode; virtual;
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); virtual;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); virtual;
    property SelStart: Cardinal read FStartPos;
    property SelEnd: Cardinal read FEndPos;
    property EditMode: TEditMode read GetEditMode;
    property PickList: string read GetPickList;
    property TripList: TTripList read FTripList;
  end;
  TItemList = Tlist<TBaseItem>;

  TBaseDataItem = class(TBaseItem)
  private
    FLenName:          Cardinal;
    FName:             ShortString;
    FLenValue:         Cardinal;
    FDataType:         byte;
    function NameLength: Cardinal;
    function ValueLength: Cardinal;
    procedure BeginWrite(AStream: TMemoryStream); override;
    function GetName: string; virtual;
    function GetValue: string; virtual;
    procedure SetValue(NewValue: string); virtual;
    function GetLenValue: Cardinal; virtual;
    function GetOffSetLenValue: integer;
    function GetOffSetDataType: integer;
    function GetOffSetValue: integer; virtual;
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
    destructor Destroy; override;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    property DisplayName: string read GetName;
    property AsString: string read GetValue write SetValue;
    property LenName: Cardinal read FLenName;
    property Name: ShortString read FName;
    property LenValue: Cardinal read GetLenValue;
    property DataType: byte read FDataType;
    property OffsetLenValue: integer read GetOffSetLenValue;
    property OffsetDataType: integer read GetOffSetDataType;
    property OffsetValue: integer read GetOffSetValue;
  end;

  // Type 01
  TByteItem = class(TBaseDataItem)
  private
    FValue:            byte;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    function GetEditMode: TEditMode; override;
    procedure SetValue(NewValue: string); override;
  public
    constructor Create(AName: ShortString; AValue: byte); reintroduce;
    destructor Destroy; override;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    property AsByte: byte read FValue write FValue;
  end;

  // Type 03
  TCardinalItem = class(TBaseDataItem)
  private
    FValue:            Cardinal;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    function GetEditMode: TEditMode; override;
    procedure SetValue(NewValue: string); override;
  public
    constructor Create(AName: ShortString; AValue: Cardinal); reintroduce;
    destructor Destroy; override;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    property AsCardinal: Cardinal read FValue write FValue;
  end;

  // Type 04
  TSingleItem = class(TBaseDataItem)
  private
    FValue:            single;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    function GetEditMode: TEditMode; override;
    procedure SetValue(NewValue: string); override;
  public
    constructor Create(AName: ShortString; AValue: Single); reintroduce;
    destructor Destroy; override;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    property AsSingle: single read FValue write FValue;
  end;

  // Type 07
  TBooleanItem = class(TBaseDataItem)
  private
    Value:            boolean;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    function GetPickList: string; override;
    function GetEditMode: TEditMode; override;
    procedure SetValue(NewValue: string); override;
  public
    constructor Create(AName: ShortString; AValue: boolean); reintroduce;
    destructor Destroy; override;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    property AsBoolean: boolean read Value write Value;
  end;

  // Type 08 (Version)
  TVersionValue = packed record
    Major:            Cardinal;
    case boolean of
    false:
      (MinorB:        byte);
    true:
      (MinorC:        Cardinal);
  end;
  TmVersionNumber = class(TBaseDataItem)
  private
    FValue:            TVersionValue;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
  public
    constructor Create(AMajor: Cardinal = 4;
                       AMinor: Cardinal = 7); reintroduce;
    destructor Destroy; override;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
  end;

  // Type 08 (ScPosn)
  TPosnValue = packed record
    procedure SwapCardinals;
    case ScnSize: Cardinal of
    Zumo340_TmScPosnSize:         // Zum340
      (
        Lat_8:                    integer;
        Lon_8:                    integer;
      );
    TmScPosnSize:                 // XT, XT2, 595, 590, drive 51
      (
        Unknown1:                 Cardinal;
        Lat:                      integer;
        Lon:                      integer;
      );
    Tread2_TmScPosnSize:          // Tread 2
      (
        Unknown1_16: array[0..1] of Cardinal;
        Lat_16:                     integer;
        Lon_16:                     integer;
      );
  end;
  TmScPosn = class(TBaseDataItem)
  private
    FValue:            TPosnValue;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    function GetEditMode: TEditMode; override;
    function GetOffSetValue: integer; override;
    function GetLenValue: Cardinal; override;
    function GetMapCoords: string;
    function CoordsAsPosnValue(const LatLon: string): TPosnValue;
    procedure SetMapCoords(ACoords: string);
  public
    constructor Create(ALat, ALon: double; AUnknown1: Cardinal; ASize: Cardinal = TmScPosnSize); reintroduce;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    destructor Destroy; override;
    property Unknown1: Cardinal read FValue.Unknown1;
    property MapCoords: string read GetMapCoords write SetMapCoords;
  end;

  // Type 14
  // Note: capable of storing and reading UCS4 and WideChar
  TStringItem = class(TBaseDataItem)
  private
    FByteSize:         word;
    FRawBytes:         TBytes;
    FValue:            string;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    function GetEditMode: TEditMode; override;
    procedure SetValue(NewValue: string); override;
    function AsUCS4: UCS4String;
    procedure ToUCS4RawBytes(AString: string);
    procedure ToWideRawBytes(AString: string);
    procedure ToRawBytes;
  public
    // Create from String
    constructor Create(AName: ShortString; AValue: string); reintroduce; overload;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    destructor Destroy; override;
  end;

{*** Specialized Classes ***}
  TUnixDate = class(TCardinalItem)
  private
    function GetEditMode: TEditMode; override;
    function GetValue: string; override;
    function GetAsUnixDateTime: Cardinal;
    procedure SetAsUnixDateTime(AValue: Cardinal);
  public
    constructor Create(AName: ShortString; AValue: TDateTime = 0);
    property AsUnixDateTime: Cardinal read GetAsUnixDateTime write SetAsUnixDateTime;
    class function DateTimeAsCardinal(ADateTime: TDateTime): Cardinal;
    class function CardinalAsDateTime(ACardinal: Cardinal): TDateTime;
    class function CardinalAsDateTimeString(ACardinal: Cardinal): string;
  end;

{*** Unknown/not Editable ***}
  TRawDataItem = class(TBaseDataItem)
  private
    FBytes:            TBytes;
    procedure WriteValue(AStream: TMemoryStream); override;
  public
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    destructor Destroy; override;
  end;

{*** General Trip info ***}
  TmPreserveTrackToRoute = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = false);
  end;

  TmParentTripId = class(TCardinalItem)
  public
    constructor Create(AValue: Cardinal = 0);
  end;

  TmDayNumber = class(TByteItem)
  public
    constructor Create(AValue: byte = $ff);
  end;

  TmTripDate = class(TCardinalItem)
  public
    constructor Create(AValue: integer = -1);
  end;

  TmIsDisplayable = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = True);
  end;

  TmAvoidancesChanged = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = False);
  end;

  TmIsRoundTrip = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = False);
  end;

  TmParentTripName = class(TStringItem)
  public
    constructor Create(AValue: string);
  end;

  TmExploreUuid = class(TStringItem)
  public
    constructor Create(AValue: string);
  end;

  TmAvoidancesChangedTimeAtSave = class(TUnixDate)
  public
    constructor Create(AValue: TDateTime = 0); overload;
    constructor Create(AValue: cardinal); overload;
  end;

  TmOptimized = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = false);
  end;

  TmTotalTripTime = class(TCardinalItem)
  private
    function GetValue: string; override;
  public
    constructor Create(AValue: Cardinal = 0);
  end;

  TmImported = class(TBooleanItem)
  private
  public
    constructor Create(AValue: boolean = false);
  end;

  TmRoutePreference = class(TByteItem)
  private
    FBytes:            TBytes;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    procedure SetValue(AValue: string); override;
    function GetEditMode: TEditMode; override;
    function GetPickList: string; override;
  public
    constructor Create(AValue: TRoutePreference = rmFasterTime; ALenValue: Cardinal = 1; ADataType: byte = dtByte);
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    class function RoutePreference(AValue: string): TRoutePreference;
    class function AdvLevel(AValue: string): TAdvlevel;
  end;

  TmTransportationMode = class(TByteItem)
  private
    function GetValue: string; override;
    procedure SetValue(AValue: string); override;
    function GetEditMode: TEditMode; override;
    function GetPickList: string; override;
  public
    constructor Create(AValue: TTransportMode = tmMotorcycling);
    class function TransPortMethod(AValue: string): TTransportMode;
  end;

  TmTotalTripDistance = class(TSingleItem)
  private
    function GetValue: string; override;
  public
    constructor Create(AValue: single = 0);
  end;

  TmFileName = class(TStringItem)
  public
    constructor Create(AValue: string);
  end;

  TmPartOfSplitRoute = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = false);
  end;

  TmTripName = class(TStringItem)
  public
    constructor Create(AValue: string);
  end;

  TmAttr = class(TCardinalItem)
  private
    function GetValue: string; override;
    procedure SetValue(AValue: string); override;
    function GetEditMode: TEditMode; override;
    function GetPickList: string; override;
    function GetRoutePoint: TRoutePoint;
  public
    constructor Create(ARoutePoint: TRoutePoint);
    class function RoutePoint(AValue: string): TRoutePoint;
    property AsRoutePoint: TRoutePoint read GetRoutePoint;
  end;

  TmIsDFSPoint = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = false);
  end;

  TmDuration = class(TCardinalItem)
  public
    constructor Create(AValue: integer = -1);
  end;

  TmArrival = class(TUnixDate)
  public
    constructor Create(AValue: TDateTime = 0);
  end;

  TmAddress = class(TStringItem)
  public
    constructor Create(AValue: string);
  end;

  TmisTravelapseDestination = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = false);
  end;

  TmShapingRadius = class(TCardinalItem)
  private
    function GetValue: string; override;
    function GetEditMode: TEditMode; override;
  public
    constructor Create(AValue: Cardinal = $80000000);
  end;

  TmName = class(TStringItem)
  public
    constructor Create(AValue: string);
  end;

  TmPhoneNumber = class(TStringItem)
  public
    constructor Create(AValue: string);
  end;

  TmShaping = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = false);
  end;

{*** XT2 ***}
{*** RoutePreferences ***}
  TBaseRoutePreferences = class(TRawDataItem)
  private
    function GetIntToIdent(const Value: word): string; virtual;
    function GetCount: Cardinal;
  public
    function GetValue: string; override;
    function GetRoutePrefByte(ViaPt: cardinal): byte;
    function GetRoutePrefs(RoutePreference: TObject = nil): string; virtual;
    property Count: Cardinal read GetCount;
  end;

  TmRoutePreferences = class(TBaseRoutePreferences)
  private
    function GetIntToIdent(const Value: word): string; override;
    function GetEditMode: TEditMode; override;
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
    function GetRoutePref(ViaPt: cardinal): TRoutePreference;
  end;
  TmRoutePreferencesAdventurousHillsAndCurves = class(TBaseRoutePreferences)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;
  TmRoutePreferencesAdventurousScenicRoads = class(TBaseRoutePreferences)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;
  TmRoutePreferencesAdventurousMode = class(TBaseRoutePreferences)
  private
    function GetIntToIdent(const Value: word): string; override;
    function GetEditMode: TEditMode; override;
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
    function GetRoutePref(ViaPt: cardinal): TAdvlevel;
  end;
  TmRoutePreferencesAdventurousPopularPaths = class(TBaseRoutePreferences)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;

  TTrackPoint = packed record
    Sizes1:       array[0..1] of cardinal;
    Datatype1:    byte;
    Count1:       cardinal;
    InitLon:      byte;
    KeylenLon:    cardinal;
    KeyNameLon:   array[0..3] of ansichar;
    ValueLenLon:  cardinal;
    DatatypeLon:  byte;
    LonAsInt:     cardinal;
    InitLat:      byte;
    KeylenLat:    cardinal;
    KeyNameLat:   array[0..3] of ansichar;
    ValueLenLat:  cardinal;
    DatatypeLat:  byte;
    LatAsInt:     cardinal;
    function GetMapCoords: string;
    procedure Init;
  end;

  TTrackPoints = packed record
    Inititiator: AnsiChar;
    KeyLen: cardinal;
    KeyName: array[0..11] of AnsiChar;
    ValueLen: cardinal;
    DataType: byte;
    TrkPntCnt: cardinal;
  end;

  TTrackHeader = packed record
    TrkCnt: cardinal;
    SubItems: byte;
    Unknown1: array[0..1] of Cardinal;
    SubLength: cardinal;
    DataType: byte;
    ItemCount: cardinal;
    TrackPoints: TTrackPoints;
  end;

  TmTrackToRouteInfoMap = class(TRawDataItem)
  private
  public
    FTrackHeader: TTrackHeader;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    procedure Clear;
    procedure InitFromGpxxRpt(RtePts: TObject);
    function GetCoords(Color: string = ''): string;
  end;

{*** Header ***}
  THeaderValue = packed record
    Id:               array[0..3] of AnsiChar;  // 'TRPL'
    SubLength:        Cardinal;
    HeaderLength:     byte;                     // 10
    TotalItems:       Cardinal;
    procedure SwapCardinals;
  end;
  THeader = class(TBaseItem)
  private
    FValue:            THeaderValue;
    procedure UpdateFromTripList(ItemCount, ASubLength: Cardinal);
    procedure WriteValue(AStream: TMemoryStream); override;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure Clear;
    property HeaderValue: THeaderValue read FValue;
  end;

{*** Locations ***}
  TLocationValue = packed record
    Id:               array[0..3] of AnsiChar;  // 'LCTN'
    Size:             Cardinal;
    DataType:         byte;
    Unknown1:         Word;
    Count:            Word;
    procedure SwapCardinals;
  end;
  TLocation = class(TBaseItem)
  private
    FValue:           TLocationValue;
    FItems: TItemList;
    FRoutePref: TRoutePreference; // Not used for XT
    FAdvLevel: TAdvlevel;         // Not used for XT
    procedure WriteValue(AStream: TMemoryStream); override;
    function LocationTmAttr: TmAttr;
    function LocationTmShaping: TmShaping;
  public
    constructor Create(ARoutePref: TRoutePreference = TRoutePreference.rmNA;
                       AAdvLevel: TAdvlevel = TAdvlevel.advNA); reintroduce;
    destructor Destroy; override;
    procedure Add(ANitem: TBaseItem);
    function IsViaPoint: boolean;
    function LocationTmName: TmName;
    function LocationTmAddress: TmAddress;
    function LocationTmScPosn: TmScPosn;
    function LocationTmArrival: TmArrival;
    property LocationValue: TLocationValue read FValue;
    property LocationItems: TItemList read FItems;
    property RoutePref: TRoutePreference read FRoutePref write FRoutePref;
    property AdvLevel: TAdvlevel read FAdvLevel write FAdvLevel;
  end;

  TmLocations = class(TBaseDataItem)
  private
    FItemCount: Cardinal;
    FItemList: TItemList;
    FLocation: TLocation;
    procedure Calculate(AStream: TMemoryStream); override;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetViaPointCount: integer;
  public
    constructor Create; reintroduce;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    destructor Destroy; override;
    procedure Clear;
    procedure AddLocation(ALocation: TLocation);
    function Add(ANItem: TBaseItem): TBaseItem;
    procedure GetSegmentPoints(ViaPoint: integer; RoutePointList: TList<TLocation>);
    procedure GetRoutePoints(RoutePointList: TList<TLocation>);
    property Locations: TItemList read FItemList;
    property LocationCount: Cardinal read FItemCount;
    property ViaPointCount: integer read GetViaPointCount;
  end;

{*** All routes ***}

  TSubClass = packed record
    MapSegment:       Cardinal;
    RoadId:           Cardinal;
    PointType:        byte;
    procedure Init(const GPXSubClass: string);
    case integer of
    0: (Direction:        byte;
        Unknown1:         array[0..5] of byte);
    1: (ComprLatLon:      array[0..6] of byte);
    2: (B4Lat:            byte;
        B4Lon:            byte;
        Reserved:         byte;
        B2_3Lat:          word;
        B2_3Lon:          word);
    3: (Direction2:       byte;
        Time:             word;
        Unknown2:         array[0..1] of word);
  end;
  TUdbDirFixedValue = packed record
    SubClass:         TSubClass;
    Lat:              integer;
    Lon:              integer;
    Unknown1:         Cardinal;
    Time:             byte;
    Border:           byte;
    procedure SwapCardinals;
  end;
  TUdbDir = class(TBaseItem)
  private
    FValue:            TUdbDirFixedValue;
    FUnknown2:         TBytes;
    FName:             TBytes;
    FUdbDirStatus:     TUdbDirStatus;
    FRoadClass:        string;
    constructor Create(AModel: TTripModel;
                       AName: WideString;
                       ALat: double = 0;
                       ALon: double = 0;
                       APointType: byte = $03); reintroduce; overload;
    constructor Create(AModel: TTripModel; ALocation: TLocation; RouteCnt: Cardinal); reintroduce; overload;
    constructor Create(AModel: TTripModel; GPXSubClass, RoadClass: string; Lat, Lon: double); reintroduce; overload;
    procedure WriteValue(AStream: TMemoryStream); override;
    function SubLength: Cardinal; override;
    function GetName: string;
    function GetDisplayLength: integer;
    function GetNameLength: integer;
    function GetMapCoords: string;
    function GetCoords: TCoords;
    function GetMapSegRoad: string;
    function GetMapSegRoadExclBit: string;
    function GetPointType: string;
    function GetDirection: string;
    procedure FillCompressedLatLon;
    function GetComprLatLon: string;
  public
    function Lat: Double;
    function Lon: Double;
    function IsTurn: boolean;
    procedure ComputeTime(Dist: Double);
    property DisplayName: string read GetName;
    property DisplayLength: integer read GetDisplayLength;
    property NameLength: integer read GetNameLength;
    property UdbDirValue: TUdbDirFixedValue read FValue;
    property Unknown2: TBytes read FUnknown2;
    property Coords: TCoords read GetCoords;
    property MapCoords: string read GetMapCoords;
    property MapSegRoad: string read GetMapSegRoad;
    property MapSegRoadExclBit: string read GetMapSegRoadExclBit;
    property PointType: string read GetPointType;
    property Direction: string read GetDirection;
    property ComprLatLon: string read GetComprLatLon;
    property Status: TUdbDirStatus read FUdbDirStatus write FUdbDirStatus;
    property RoadClass: string read FRoadClass write FRoadClass; // Only valid in SaveCalculated
  end;
  TUdbDirList = Tlist<TUdbDir>;

  TUdbPrefValue = packed record
    Unknown1:         Cardinal;
    PrefixSize:       Cardinal;
    DataType:         byte;
    PrefId:           Cardinal;
    procedure SwapCardinals;
  end;

  TUdbHandleValue = packed record
    UdbHandleSize:    Cardinal;
    CalcStatus:       Cardinal; // See CalculationMagic. Set it to Zeroes, to force recalculation
    Unknown2:         TBytes;
    UDbDirCount:      WORD;
    Unknown3:         TBytes;
    procedure SwapCardinals;
    procedure AllocUnknown2(ASize: Cardinal);
    procedure AllocUnknown3(ASize: Cardinal);
    procedure AllocUnknown(AModel: TTripModel = TTripModel.XT);
    procedure UpdateUnknown3(const Offset: integer; const Value: Cardinal);
    function GetUnknown3(const Offset: integer): Cardinal;
  end;
  TmUdbDataHndl = class(TBaseDataItem)
  private
    FUdbHandleId:      Cardinal;
    FUdbPrefValue:     TUdbPrefValue;
    FValue:            TUdbHandleValue;
    FUdbDirList:       TUdbDirList;
    FTrailer:          TBytes;
    procedure BeginWrite(AStream: TMemoryStream); override;
    procedure WriteValue(AStream: TMemoryStream); override;
    procedure EndWrite(AStream: TMemoryStream); override;
    function ComputeUnknown3Size(AModel: TTripModel): integer;
    function GetModel: TTripModel;
    function GetModelDescription: string;
    function GetDistOffset: integer;
    function GetTimeOffset: integer;
    function GetShapeOffset: integer;
  public
    constructor Create(AHandleId: Cardinal; AModel: TTripModel = TTripModel.XT; ForceRecalc: boolean = true); reintroduce;
    destructor Destroy; override;
    procedure Add(AnUdbDir: TUdbDir);
    property HandleId: Cardinal read FUdbHandleId;
    property PrefValue: TUdbPrefValue read FUdbPrefValue;
    property UdbHandleValue: TUdbHandleValue read FValue;
    property ModelDescription: string read GetModelDescription;
    property Items: TUdbDirList read FUdbDirList;
    property DistOffset: integer read GetDistOffset;
    property TimeOffset: integer read GetTimeOffset;
    property ShapeOffset: integer read GetShapeOffset;
    property Trailer: TBytes read FTrailer;
  end;
  TUdbHandleList = Tlist<TmUdbDataHndl>;

  TmAllRoutesValue = packed record
    UdbHandleCount:   Cardinal;
    procedure SwapCardinals;
  end;
  TmAllRoutes = class(TBaseDataItem)
  private
    FValue:            TmAllRoutesValue;
    FUdBList: TUdbHandleList;
    function ModelFromUnknown3Size(AModel: TTripModel; AnUdbHandle: TmUdbDataHndl; AStream: TStream): TTripModel;
    procedure WriteValue(AStream: TMemoryStream); override;
    procedure EndWrite(AStream: TMemoryStream); override;
  public
    constructor Create; reintroduce;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    destructor Destroy; override;
    procedure AddUdbHandle(AnUdbHandle: TmUdbDataHndl);
    property Items: TUdbHandleList read FUdBList;
    property AllRoutesValue: TmAllRoutesValue read FValue;
  end;

{*** Trip List ***}
  TTripList = class(TObject)
  private
    FHeader: THeader;
    FItemList: TItemList;
    FRouteCnt: Cardinal;
    FTripModel: TTripModel;
    FModelDescription: string;
    FIsUcs4: boolean;
    procedure ResetCalculation;
    procedure Calculate(AStream: TMemoryStream);
    function FirstUdbDataHndle: TmUdbDataHndl;
    function GetIsCalculated: boolean;
    function GetTripModel: TTripModel;
    function GetCalculationModel(AModel: TTripModel): TTripModel;
    procedure GetModel;
    function InitAllRoutes: TBaseItem;
    procedure SetPreserveTrackToRoute(const RtePts: TObject);
    procedure UpdateDistAndTime(TotalDist: single; TotalTime: Cardinal);
    procedure AddLocation_XT(Locations: TmLocations;
                             ProcessOptions: TObject;
                             RoutePoint: TRoutePoint;
                             Lat, Lon: double;
                             DepartureDate: TDateTime;
                             Name, Address: string);
    procedure AddLocation_XT2(Locations: TmLocations;
                             ProcessOptions: TObject;
                             RoutePoint: TRoutePoint;
                             RoutePref: TRoutePreference;
                             AdvLevel: TAdvlevel;
                             Lat, Lon: double;
                             DepartureDate: TDateTime;
                             Name, Address: string);
    procedure AddLocation_Tread2(Locations: TmLocations;
                             ProcessOptions: TObject;
                             RoutePoint: TRoutePoint;
                             RoutePref: TRoutePreference;
                             AdvLevel: TAdvlevel;
                             Lat, Lon: double;
                             DepartureDate: TDateTime;
                             Name, Address: string);
    procedure AddLocation_Zumo595(Locations: TmLocations;
                                  ProcessOptions: TObject;
                                  RoutePoint: TRoutePoint;
                                  Lat, Lon: double;
                                  DepartureDate: TDateTime;
                                  Name, Address: string);
    procedure AddLocation_Drive51(Locations: TmLocations;
                                  ProcessOptions: TObject;
                                  RoutePoint: TRoutePoint;
                                  Lat, Lon: double;
                                  DepartureDate: TDateTime;
                                  Name, Address: string);
    procedure AddLocation_Zumo3x0(Locations: TmLocations;
                                  ProcessOptions: TObject;
                                  RoutePoint: TRoutePoint;
                                  Lat, Lon: double;
                                  DepartureDate: TDateTime;
                                  Name, Address: string);
    procedure CreateTemplate_XT(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_XT2(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Tread2(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Zumo595(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Drive51(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Zumo3x0(const TripName, CalculationMode, TransportMode: string);
    procedure SetRoutePref(AKey: ShortString; TmpStream: TMemoryStream);
    procedure UpdLocsFromRoutePrefs;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AddHeader(AHeader: THeader);
    function Add(ANItem: TBaseItem): TBaseItem;
    procedure SaveToStream(AStream: TMemoryStream);
    procedure SaveToFile(AFile: string);
    function LoadFromStream(AStream: TStream): boolean;
    function LoadFromFile(AFile: string): boolean;
    procedure Assign(ATripList: TTripList);
    procedure Recalculate;
    function GetValue(AKey: ShortString): string;
    function GetItem(AKey: ShortString): TBaseItem;
    procedure SetItem(AKey: ShortString; ABaseItem: TBaseItem);
    function GetRoutePointCount: integer;
    function GetRoutePoint(RoutePointId: integer): Tlocation;
    function OSMRoutePoint(RoutePointId: integer): TOSMRoutePoint;
    function GetArrival: TmArrival;
    procedure CreateOSMPoints(const OutStringList: TStringList; const HTMLColor: string);
    procedure AddLocation(Locations: TmLocations;
                          ProcessOptions: TObject;
                          RoutePoint: TRoutePoint;
                          RoutePref: TRoutePreference;
                          AdvLevel: TAdvlevel;
                          Lat, Lon: double;
                          DepartureDate: TDateTime;
                          Name, Address: string);
    procedure SetRoutePrefs_XT2_Tread2(Locations: TmLocations; ProcessOptions: TObject);
    procedure ForceRecalc(const AModel: TTripModel = TTripModel.Unknown; ViaPointCount: integer = 0);
    procedure TripTrack(const AModel: TTripModel;
                        const RtePts: TObject;
                        const SubClasses: TStringList);
    procedure SaveCalculated(const AModel: TTripModel;
                            const RtePts: TObject);
    procedure CreateTemplate(const AModel: TTripModel;
                             const TripName: string;
                             const CalculationMode: string = '';
                             const TransportMode: string = '');
    procedure SaveAsGPX(const GPXFile: string; IncludeTrack: boolean = true);
    property Header: THeader read FHeader;
    property ItemList: TItemList read FItemList;
    property IsCalculated: boolean read GetIsCalculated;
    property TripModel: TTripModel read FTripModel;
    property ModelDescription: string read FModelDescription;
    property IsUcs4: boolean read FIsUcs4;
    property RouteCnt: Cardinal read FRouteCnt write FRouteCnt;
  end;

implementation

uses
  System.Math, System.DateUtils, System.StrUtils, System.TypInfo, System.UITypes,
  Vcl.Dialogs,
  UnitStringUtils, UnitVerySimpleXml, UnitProcessOptions;

const
  Coord_Decimals = '%1.6f';

var
  FloatFormatSettings: TFormatSettings; // for FormatFloat -see Initialization

procedure BreakPoint;
{$IFDEF DEBUG}
asm int 3
{$ELSE}
begin
{$ENDIF}
end;

procedure WriteSwap(AStream: TMemoryStream; I: smallint);
var
  Tmp: smallint;
begin
  Tmp := Swap(I);
  AStream.Write(Tmp, SizeOf(Tmp));
end;

procedure WriteSwap32(AStream: TMemoryStream; I: Cardinal); overload;
var
  Tmp: Cardinal;
begin
  Tmp := Swap32(I);
  AStream.Write(Tmp, SizeOf(Tmp));
end;

procedure WriteSwap32(AStream: TMemoryStream; I: Single); overload;
var
  Tmp: Single;
begin
  Tmp := Swap32(I);
  AStream.Write(Tmp, SizeOf(Tmp));
end;

function CoordAsDec(CoordInt: integer): double; overload;
begin
  result := SimpleRoundTo(CoordInt / 4294967296 * 360, -10);
end;

function CoordAsDec(const ACoord: string): double; overload;
begin
  if not TryStrToFloat(ACoord, result, FloatFormatSettings) then
    result := 0;
end;

function CoordAsInt(CoordDec: double): integer;
begin
  result := Round(SimpleRoundTo(CoordDec, -10) * 4294967296 / 360);
end;

function FormatMapCoords(Lat, Lon: double): string;
begin
  result := Format(Format('%s, %s', [Coord_Decimals, Coord_Decimals]),
                  [Lat, Lon], FloatFormatSettings);
end;

// For some reason the degree character ° is stored on the Zumo as 0xe0b0 and not just 0xb0
// For converting to and from Unicode these 2 functions are used.
function FromPrivate(const AnUCS4String: UCS4String): UCS4String;
var
  Index: integer;
begin
  result := Copy(AnUCS4String);
  for Index := Low(result) to High(result) do
  begin
    case result[Index] of
      $0000e0b0:
        result[Index] := $000000b0;
    end;
  end;
end;

procedure ToPrivate(var AnUCS4String: UCS4String);
var
  Index: integer;
begin
  for Index := Low(AnUCS4String) to High(AnUCS4String) do
  begin
    case AnUCS4String[Index] of
      $000000b0:
        AnUCS4String[Index] := $0000e0b0;
    end;
  end;
end;

procedure WideStringToUCS4Array(AWideString: WideString; var AnUCS4Array: array of UCS4Char);
var
  AUCS4String: UCS4String;
  MaxLen: Cardinal;
begin
  AUCS4String := WideStringToUCS4String(AWideString);
  MaxLen := Min(Length(AWideString), High(AnUCS4Array));
  Move(AUCS4String[0], AnUCS4Array[0], MaxLen * SizeOf(UCS4Char));
end;

function UCS4ByteArrayToString(AnUCS4ByteArray: TBytes): string;
var
  Len: integer;
  AUCS4String: UCS4String;
begin
  Len := Length(AnUCS4ByteArray);
  SetLength(AUCS4String, (Len div SizeOf(UCS4Char)) +1);
  Move(AnUCS4ByteArray[0], AUCS4String[0], Len);
  result := UCS4StringToUnicodeString(AUCS4String);
  SetLength(result, StrLen(PChar(result)));  // Drop trailing zeroes
end;

procedure WideStringToWideArray(AWideString: WideString; AWideArray: TBytes);
var
  MaxLen: Cardinal;
begin
  MaxLen := Min(Length(AWideString) * SizeOf(WideChar), High(AWideArray));
  Move(AWideString[1], AWideArray[0], MaxLen);
end;

procedure GenShapeBitmap(const NumShapes: integer; OBuf: PByte);
var
  Index: integer;
  OrByte: byte;
begin
  OrByte := 2;
  OBuf^ := 0;
  for Index := 1 to NumShapes do
  begin
    OBuf^ := OBuf^ or OrByte;

    if (OrByte <> 128) then
      OrByte := OrByte shl 1
    else
    begin
      OrByte := 1;
      Inc(OBuf);
    end;
  end;
end;

function ReadKeyVAlues(AStream: TStream;
                       var Initiator: AnsiChar;
                       var KeyLen: Cardinal;
                       var KeyName: ShortString;
                       var ValueLen: Cardinal;
                       var DataType: Byte): integer;
begin
  result := AStream.Read(Initiator, SizeOf(Initiator));
  if (result = 0) or
     (Initiator <> biInitiator) then
    exit(0);

  result := AStream.Read(KeyLen, SizeOf(KeyLen));
  if (result = 0) then
    exit(0);
  KeyLen := Swap32(KeyLen);

  result := AStream.Read(KeyName[1], Keylen);
  if (result = 0) then
    exit(0);
  KeyName[0] := AnsiChar(result);

  result := AStream.Read(ValueLen, SizeOf(ValueLen));
  if (result = 0) then
    exit(0);
  ValueLen := Swap32(ValueLen);

  result := AStream.Read(DataType, SizeOf(DataType));
end;

// Create, and Initialize from stream, class by name
function CreateBaseItemByName(ATripList: TTripList;
                              AKeyName: ShortString;
                              AValueLen: Cardinal;
                              ADataType: byte;
                              AStream: TStream): TBaseItem;
var
  RegisteredClassName: string;
  APersistentClass: TPersistentClass;
  AByte: byte;
  ACardinal: Cardinal;
  ASingle: Single;
  ABoolean: boolean;
begin
  RegisteredClassName := Format('T%s', [AKeyName]);
  APersistentClass := GetClass(RegisteredClassName);
  if (Assigned(APersistentClass)) then
  begin
    result := TBaseItem(APersistentClass.Create);
    result.FTripList := ATripList;
    result.InitFromStream(AKeyName, AValueLen, ADataType, AStream);
  end
  else
  begin
    // Create class by known (basic) datatype
    case ADataType of
      dtByte:
        begin
          AStream.Read(AByte, SizeOf(AByte));
          result := TByteItem.Create(AKeyName, AByte);
          result.FTripList := ATripList;
        end;
      dtCardinal:
        begin;
          AStream.Read(ACardinal, SizeOf(ACardinal));
          result := TCardinalItem.Create(AKeyName, Swap32(ACardinal));
          result.FTripList := ATripList;
        end;
      dtSingle:
        begin;
          AStream.Read(ASingle, SizeOf(ASingle));
          result := TSingleItem.Create(AKeyName, Swap32(ASingle));
          result.FTripList := ATripList;
        end;
      dtBoolean:
        begin;
          AStream.Read(ABoolean, SizeOf(ABoolean));
          result := TBooleanItem.Create(AKeyName, ABoolean);
          result.FTripList := ATripList;
        end;
      dtString:
        begin;
          result := TStringItem.Create(AKeyName);
          result.FTripList := ATripList;
          TStringItem(result).InitFromStream(AKeyName, AValueLen, dtString, AStream);
        end;
      else
      begin
        // Create a Raw data item. Only holds bytes
        result := TRawDataItem.Create;
        result.FTripList := ATripList;
        result.InitFromStream(AKeyName, AValueLen, ADataType, AStream);
      end;
    end;
  end;
end;

{*** Baseitem ***}
constructor TBaseItem.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create;
  FInitiator := biInitiator;
  FCalculated := false;
end;

procedure TBaseItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  FInitiator := biInitiator;
  FCalculated := false;
end;

function TBaseItem.GetEditMode: TEditMode;
begin
  result := TEditMode.emNone;
end;

function TBaseItem.GetPickList: string;
begin
  result := '';
end;

procedure TBaseItem.Calculate(AStream: TMemoryStream);
begin
  if not FCalculated then
    Write(AStream);
  FCalculated := true;
{$IFDEF DEBUG_POS}
  if (self is TBaseDataItem) then
  begin
    AllocConsole;
    Writeln(TBaseDataItem(self).Name, ' ', FStartPos, '=', SubLength);
  end;
{$ENDIF}
end;

function TBaseItem.SubLength: Cardinal;
begin
  result := FEndPos - FStartPos;
end;

procedure TBaseItem.BeginWrite(AStream: TMemoryStream);
begin
  if not FCalculated then
    FStartPos := AStream.Position;
end;

procedure TBaseItem.Write(AStream: TMemoryStream);
begin
  BeginWrite(Astream);
  WriteValue(AStream);
  EndWrite(Astream);
  FCalculated := true;
end;

procedure TBaseItem.EndWrite(AStream: TMemoryStream);
begin
  if not FCalculated then
    FEndPos := AStream.Position;
end;

{*** BaseDataItem ***}
constructor TBaseDataItem.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create;

  FName := AName;
  FLenName := NameLength;
  FLenValue := ALenValue;
  FDataType := ADataType;
end;

procedure TBaseDataItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  FName := AName;
  FLenName := NameLength;
  FLenValue := ALenValue;
  FDataType := ADataType;
end;

destructor TBaseDataItem.Destroy;
begin
  inherited Destroy;
end;

function TBaseDataItem.NameLength: Cardinal;
begin
  result := Length(FName);
end;

function TBaseDataItem.ValueLength: Cardinal;
begin
  result := FLenValue;
end;

procedure TBaseDataItem.BeginWrite(AStream: TMemoryStream);
begin
  inherited BeginWrite(AStream);
  AStream.Write(FInitiator, SizeOf(FInitiator));
  WriteSwap32(AStream, FLenName);
  AStream.Write(FName[1], FLenName);
  WriteSwap32(AStream, ValueLength + SizeOf(FInitiator));
  AStream.Write(FDataType, SizeOf(FDataType));
end;

function TBaseDataItem.GetName: string;
begin
  result := string(FName);
end;

function TBaseDataItem.GetValue: string;
begin
  result := Format('DataType: %d Class: %s', [FDataType, ClassName]);
end;

procedure TBaseDataItem.SetValue(NewValue: string);
begin
  // Does nothing. Abstract
end;

function TBaseDataItem.GetLenValue: Cardinal;
begin
  result := FLenValue + SizeOf(FInitiator);
end;

function TBaseDataItem.GetOffSetLenValue: integer;
begin
  result := SizeOf(biInitiator) + SizeOf(LenName) + LenName;
end;

function TBaseDataItem.GetOffSetDataType: integer;
begin
  result := GetOffSetLenValue + SizeOf(LenName);
end;

function TBaseDataItem.GetOffSetValue: integer;
begin
  result := GetOffSetDataType + SizeOf(DataType);
end;

{*** Byte ***}
constructor TByteItem.Create(AName: ShortString; AValue: byte);
begin
  inherited Create(AName, SizeOf(FValue), dtByte);
  FValue := AValue;
end;

destructor TByteItem.Destroy;
begin
  inherited Destroy;
end;

procedure TByteItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  AStream.Read(FValue, SizeOf(FValue));
end;

procedure TByteItem.WriteValue(AStream: TMemoryStream);
begin
  AStream.Write(FValue, SizeOf(FValue));
end;

function TByteItem.GetValue: string;
begin
  result := Format('%d', [FValue]);
end;

function TByteItem.GetEditMode: TEditMode;
begin
  result := TEditMode.emEdit;
end;

procedure TByteItem.SetValue(NewValue: string);
var
  NewVal: integer;
begin
  if TryStrToInt(NewValue, NewVal) and
     (NewVal >= 0) and
     (NewVal <= 255) then
    FValue := NewVal;
end;

{*** Cardinal ***}
constructor TCardinalItem.Create(AName: ShortString; AValue: Cardinal);
begin
  inherited Create(AName, SizeOf(FValue), dtCardinal);
  FValue := AValue;
end;

procedure TCardinalItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  AStream.Read(FValue, SizeOf(FValue));
  FValue := Swap32(FValue);
end;

destructor TCardinalItem.Destroy;
begin
  inherited Destroy;
end;

procedure TCardinalItem.WriteValue(AStream: TMemoryStream);
begin
  WriteSwap32(AStream, FValue);
end;

function TCardinalItem.GetValue: string;
begin
  result := Format('%d', [FValue]);
end;

function TCardinalItem.GetEditMode: TEditMode;
begin
  result := TEditMode.emEdit;
end;

procedure TCardinalItem.SetValue(NewValue: string);
var
  NewVal: integer;
begin
  if TryStrToInt(NewValue, NewVal) then
    FValue := NewVal;
end;

{*** Single ***}
constructor TSingleItem.Create(AName: ShortString; AValue: Single);
begin
  inherited Create(AName, SizeOf(FValue), dtSingle);
  FValue := AValue;
end;

procedure TSingleItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  AStream.Read(FValue, SizeOf(FValue));
  FValue := Swap32(FValue);
end;

destructor TSingleItem.Destroy;
begin
  inherited Destroy;
end;

procedure TSingleItem.WriteValue(AStream: TMemoryStream);
begin
  WriteSwap32(AStream, FValue);
end;

function TSingleItem.GetValue: string;
begin
  result := Format('%f', [FValue]);
end;

function TSingleItem.GetEditMode: TEditMode;
begin
  result := TEditMode.emEdit;
end;

procedure TSingleItem.SetValue(NewValue: string);
var
  NewVal: single;
begin
  if TryStrToFloat(NewValue, NewVal) then
    FValue := NewVal;
end;

{*** Boolean ***}
constructor TBooleanItem.Create(AName: ShortString; AValue: boolean);
begin
  inherited Create(AName, SizeOf(Value), dtBoolean);
  Value := AValue;
end;

destructor TBooleanItem.Destroy;
begin
  inherited Destroy;
end;

procedure TBooleanItem.WriteValue(AStream: TMemoryStream);
begin
  AStream.Write(Value, SizeOf(Value));
end;

procedure TBooleanItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  AStream.Read(Value, SizeOf(Value));
end;

procedure TBooleanItem.SetValue(NewValue: string);
var
  BoolValue: integer;
begin
  if not (IdentToInt(NewValue, BoolValue, BooleanMap)) then
    Value := false
  else
    Value := boolean(BoolValue);
end;

function TBooleanItem.GetValue: string;
begin
  if not IntToIdent(Ord(Value), result, BooleanMap) then
     IntToIdent(Ord(false), result, BooleanMap);
end;

function TBooleanItem.GetEditMode: TEditMode;
begin
  result := TEditMode.emPickList;
end;

function TBooleanItem.GetPickList: string;
begin
  result := 'False' +#10 +
            'True';
end;

{*** Version ***}
constructor TmVersionNumber.Create(AMajor: Cardinal = 4;
                                   AMinor: Cardinal = 7);
begin
  case AMajor of
    1:
      begin
        inherited Create('mVersionNumber', SizeOf(FValue.Major) + SizeOf(FValue.MinorB), dtVersion);
        FValue.Major := Swap32(AMajor);
        FValue.MinorB := AMinor;
      end
    else
    begin
      inherited Create('mVersionNumber', SizeOf(FValue), dtVersion);
      FValue.Major := Swap32(AMajor);
      FValue.MinorC := AMinor;
    end;
  end;
end;

procedure TmVersionNumber.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  AStream.Read(FValue.Major, SizeOf(FValue.Major));
  if (ALenValue = SizeOf(FValue.Major) + SizeOf(FValue.MinorB)) then
    AStream.Read(FValue.MinorB, SizeOf(FValue.MinorB))
  else
    AStream.Read(FValue.MinorC, SizeOf(FValue.MinorC));
end;

destructor TmVersionNumber.Destroy;
begin
  inherited Destroy;
end;

procedure TmVersionNumber.WriteValue(AStream: TMemoryStream);
begin
  AStream.Write(FValue.Major, SizeOf(FValue.Major));
  if (FLenValue = SizeOf(FValue.Major) + SizeOf(FValue.MinorB)) then
    AStream.Write(FValue.MinorB, SizeOf(FValue.MinorB))
  else
    AStream.Write(FValue.MinorC, SizeOf(FValue.MinorC));
end;

function TmVersionNumber.GetValue: string;
begin
  if (FLenValue = SizeOf(FValue.Major) + SizeOf(FValue.MinorB)) then
    result := Format('0x%s / 0x%s', [IntToHex(FValue.Major, 8), IntToHex(FValue.MinorB, 2)])
  else
    result := Format('0x%s / 0x%s', [IntToHex(FValue.Major, 8), IntToHex(FValue.MinorC, 8)]);
end;

{*** ScPosn ***}
procedure TPosnValue.SwapCardinals;
begin
  ScnSize := Swap32(ScnSize);
end;

constructor TmScPosn.Create(ALat, ALon: double; AUnknown1: Cardinal; ASize: Cardinal = TmScPosnSize);
begin
  case ASize of
    Zumo340_TmScPosnSize:
      begin
        inherited Create('mScPosn',
                         SizeOf(FValue.ScnSize) + Sizeof(FValue.Lat) + SizeOf(FValue.Lon),
                         dtPosn);
        FValue.ScnSize := + Sizeof(FValue.Lat_16) + SizeOf(FValue.Lon_16);
        FValue.Lat_8 := (CoordAsInt(ALat));
        FValue.Lon_8 := (CoordAsInt(ALon));
      end;
    Tread2_TmScPosnSize:
      begin
        inherited Create('mScPosn', SizeOf(FValue), dtPosn);
        FValue.ScnSize := SizeOf(FValue.Unknown1_16) + Sizeof(FValue.Lat_16) + SizeOf(FValue.Lon_16);
        FValue.Unknown1_16[0] := AUnknown1;
        FValue.Unknown1_16[1] := $00000000;
        FValue.Lat_16 := (CoordAsInt(ALat));
        FValue.Lon_16 := (CoordAsInt(ALon));
      end;
    else
    begin
      inherited Create('mScPosn',
                       SizeOf(FValue.ScnSize) + SizeOf(FValue.Unknown1) + Sizeof(FValue.Lat) + SizeOf(FValue.Lon),
                       dtPosn);
      FValue.ScnSize      := SizeOf(FValue.Unknown1) + Sizeof(FValue.Lat) + SizeOf(FValue.Lon);
      FValue.Unknown1     := AUnknown1;
      FValue.Lat          := (CoordAsInt(ALat));
      FValue.Lon          := (CoordAsInt(ALon));
    end;
  end;
end;

procedure TmScPosn.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);

  AStream.Read(FValue.ScnSize, SizeOf(FValue.ScnSize));
  FValue.SwapCardinals; // Unknown1, Lat and Lon are not swapped

  case FValue.ScnSize of
    Zumo340_TmScPosnSize:
      begin
        AStream.Read(FValue.Lat_8, SizeOf(FValue.Lat_8));
        AStream.Read(FValue.Lon_8, SizeOf(FValue.Lon_8));
      end;
    Tread2_TmScPosnSize:
      begin
        AStream.Read(FValue.Unknown1_16, SizeOf(FValue.Unknown1_16));
        AStream.Read(FValue.Lat_16, SizeOf(FValue.Lat_16));
        AStream.Read(FValue.Lon_16, SizeOf(FValue.Lon_16));
      end;
    else
      begin
        AStream.Read(FValue.Unknown1, SizeOf(FValue.Unknown1));
        AStream.Read(FValue.Lat, SizeOf(FValue.Lat));
        AStream.Read(FValue.Lon, SizeOf(FValue.Lon));
      end;
  end;
end;

destructor TmScPosn.Destroy;
begin
  inherited Destroy;
end;

procedure TmScPosn.WriteValue(AStream: TMemoryStream);
begin
  case FValue.ScnSize of
    Zumo340_TmScPosnSize:
      begin
        FValue.SwapCardinals;
        AStream.Write(FValue.ScnSize, SizeOf(FValue.ScnSize));
        AStream.Write(FValue.Lat_8, SizeOf(FValue.Lat_8));
        AStream.Write(FValue.Lon_8, SizeOf(FValue.Lon_8));
      end;
    Tread2_TmScPosnSize:
      begin
        FValue.SwapCardinals;
        AStream.Write(FValue, SizeOf(FValue));
      end;
    else
      begin
        FValue.SwapCardinals;
        AStream.Write(FValue.ScnSize, SizeOf(FValue.ScnSize));
        AStream.Write(FValue.Unknown1, SizeOf(FValue.Unknown1));
        AStream.Write(FValue.Lat, SizeOf(FValue.Lat));
        AStream.Write(FValue.Lon, SizeOf(FValue.Lon));
      end;
  end;
  FValue.SwapCardinals;
end;

function TmScPosn.GetEditMode: TEditMode;
begin
  result := TEditMode.emButton;
end;

function TmScPosn.GetValue: string;
begin
  case FValue.ScnSize of
    Zumo340_TmScPosnSize:
      begin
        result := Format('Lat, Lon: %s',
                        [MapCoords]);
      end;
    Tread2_TmScPosnSize:
      begin
        result := Format('Unknown1: 0x%s, Unknown2: 0x%s, Lat, Lon: %s',
                        [IntToHex(FValue.Unknown1_16[0], 8),
                         IntToHex(FValue.Unknown1_16[1], 8),
                         MapCoords]);
      end;
    else
      begin
        result := Format('Unknown: 0x%s, Lat, Lon: %s',
                        [IntToHex(FValue.Unknown1, 8),
                        MapCoords]);
      end;
  end;
end;

function TmScPosn.GetOffSetValue: integer;
begin
  result := inherited GetOffSetValue + SizeOf(FValue.ScnSize);

  case FValue.ScnSize of
    Zumo340_TmScPosnSize:
      ; // Do nothing
    Tread2_TmScPosnSize:
      result := result + SizeOf(FValue.Unknown1_16);
    else
      result := result + SizeOf(FValue.Unknown1);
  end;
end;

function TmScPosn.GetLenValue: Cardinal;
begin
  case FValue.ScnSize of
    Zumo340_TmScPosnSize:
      result := SizeOf(FValue.Lat_8) + SizeOf(FValue.Lon_8);
    Tread2_TmScPosnSize:
      result := SizeOf(FValue.Lat_16) + SizeOf(FValue.Lon_16);
    else
      result := SizeOf(FValue.Lat) + SizeOf(FValue.Lon);
  end;
end;

function TmScPosn.GetMapCoords: string;
begin
  case FValue.ScnSize of
    Zumo340_TmScPosnSize:
      result := FormatMapCoords(CoordAsDec(FValue.Lat_8), CoordAsDec(FValue.Lon_8));
    Tread2_TmScPosnSize:
      result := FormatMapCoords(CoordAsDec(FValue.Lat_16), CoordAsDec(FValue.Lon_16));
    else
      result := FormatMapCoords(CoordAsDec(FValue.Lat), CoordAsDec(FValue.Lon));
  end;
end;

function TmScPosn.CoordsAsPosnValue(const LatLon: string): TPosnValue;
var
  Lat, Lon: string;
begin
  FillChar(result, SizeOf(result), 0);
  result.ScnSize := FValue.ScnSize; // Take ScnSize, from current instance

  ParseLatLon(LatLon, Lat, Lon);
  case result.ScnSize of
    Zumo340_TmScPosnSize:
      begin
        result.Lat_8 := CoordAsInt(CoordAsDec(Lat));
        result.Lon_8 := CoordAsInt(CoordAsDec(Lon));
      end;
    Tread2_TmScPosnSize:
      begin
        result.Lat_16 := CoordAsInt(CoordAsDec(Lat));
        result.Lon_16 := CoordAsInt(CoordAsDec(Lon));
      end;
    else
    begin
      result.Lat := CoordAsInt(CoordAsDec(Lat));
      result.Lon := CoordAsInt(CoordAsDec(Lon));
    end;
  end;
end;

procedure TmScPosn.SetMapCoords(ACoords: string);
begin
  FValue := CoordsAsPosnValue(ACoords);
end;

{*** String ***}
function TStringItem.AsUCS4: UCS4String;
var
  Chars: integer;
begin
  Chars := (FByteSize div SizeOf(UCS4Char)) +1; // Null terminator
  SetLength(result, Chars);
  Move(FRawBytes[0], result[0], FByteSize);
end;

procedure TStringItem.ToUCS4RawBytes(AString: string);
var
  Temp: UCS4String;
begin
  Temp := UnicodeStringToUCS4String(AString);
  FByteSize := High(Temp) * SizeOf(UCS4Char);
  SetLength(FRawBytes, FByteSize +1);
  Move(Temp[0], FRawBytes[0], FByteSize);
end;

procedure TStringItem.ToWideRawBytes(AString: string);
begin
  FByteSize := ByteLength(AString);
  SetLength(FRawBytes, FByteSize +1);
  Move(AString[1], FRawBytes[0], FByteSize);
end;

procedure TStringItem.ToRawBytes;
begin
  if (Assigned(TripList)) and // Need triplist to know UCS4 or WideSring
     (FByteSize = StringLoaded) then
  begin
    if (TripList.IsUcs4) then
      ToUCS4RawBytes(FValue)
    else
      ToWideRawBytes(FValue);
    FLenValue := SizeOf(FByteSize) + FByteSize;
    SetLength(FValue, 0);
  end;
  Assert((FByteSize <> StringLoaded) and
         (Length(FValue) = 0), 'To Internal called, but TripList not assigned');
end;

constructor TStringItem.Create(AName: ShortString; AValue: string);
begin
  // Create with length of the string, not the actual rawbytes length.
  // Will be calculated correctly once we know if UCS4, or WideChar
  Create(AName, Length(AValue), dtString);
  FValue := AValue;
  FByteSize := StringLoaded;
  SetLength(FRawBytes, 0);
end;

procedure TStringItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);

  AStream.Read(FByteSize, SizeOf(FByteSize));
  FByteSize := Swap(FByteSize);
  SetLength(FRawBytes, FByteSize + SizeOf(UCS4Char)); // Null terminator
  AStream.Read(FRawBytes[0], FByteSize);
  SetLength(FValue, 0);
end;

destructor TStringItem.Destroy;
begin
  inherited Destroy;
end;

procedure TStringItem.WriteValue(AStream: TMemoryStream);
begin
  ToRawBytes;

  WriteSwap(AStream, FByteSize);
  AStream.Write(FRawBytes[0], FByteSize);  // Write exactly bytesize.
end;

function TStringItem.GetValue: string;
begin
  if (FByteSize = StringLoaded) then
    exit(FValue);  // GetValue called, but FValue not yet converted to Internal

  if (TripList.IsUcs4) then
    result := UCS4StringToUnicodeString(FromPrivate(AsUCS4))
  else
    result := PWideChar(@FRawBytes[0]);
end;

function TStringItem.GetEditMode: TEditMode;
begin
  result := TEditMode.emEdit;
end;

procedure TStringItem.SetValue(NewValue: string);
begin
  FValue := NewValue;
  FByteSize := StringLoaded;
  SetLength(FRawBytes, 0);
end;

{*** Specialized classes ***}

constructor TUnixDate.Create(AName: ShortString; AValue: TDateTime = 0);
begin
  inherited Create(AName, TUnixDate.DateTimeAsCardinal(AValue));
end;

function TUnixDate.GetEditMode: TEditMode;
begin
  result := TEditMode.emButton;
end;

function TUnixDate.GetValue: string;
begin
  result := TUnixDate.CardinalAsDateTimeString(FValue);
end;

function TUnixDate.GetAsUnixDateTime: Cardinal;
begin
  result := FValue;
end;

procedure TUnixDate.SetAsUnixDateTime(AValue: Cardinal);
begin
  FValue := AValue;
end;

class function TUnixDate.DateTimeAsCardinal(ADateTime: TDateTime): Cardinal;
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

class function TUnixDate.CardinalAsDateTime(ACardinal: Cardinal): TDateTime;
var
  ValueEpoch: int64;
begin
  ValueEpoch := ACardinal + DateTimeToUnix(EncodeDateTime(1989,12,31,0,0,0,0)); // Starts from 1989/12/31
  result := UnixToDateTime(ValueEpoch, false);
end;

class function TUnixDate.CardinalAsDateTimeString(ACardinal: Cardinal): string;
begin
  result := Format('%s', [DateTimeToStr(TUnixDate.CardinalAsDateTime(ACardinal))]);
end;

{*** Raw Data used for unknown
We just keep the data in TBytes
***}
procedure TRawDataItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  SetLength(FBytes, FLenValue);
  AStream.ReadBuffer(FBytes, FLenValue);
end;

destructor TRawDataItem.Destroy;
begin
  SetLength(FBytes, 0);
  inherited Destroy;
end;

procedure TRawDataItem.WriteValue(AStream: TMemoryStream);
begin
  AStream.WriteBuffer(FBytes, FLenValue);
end;

{*** General trip info classes ***}
constructor TmPreserveTrackToRoute.Create(AValue: boolean = false);
begin
  inherited Create('mPreserveTrackToRoute', AValue);
end;

constructor TmParentTripId.Create(AValue: Cardinal = 0);
begin
  inherited Create('mParentTripId', AValue);
end;

constructor TmDayNumber.Create(AValue: byte = $ff);
begin
  inherited Create('mDayNumber', AValue);
end;

constructor TmTripDate.Create(AValue: integer = -1);
begin
  inherited Create('mTripDate', AValue);
end;

constructor TmIsDisplayable.Create(AValue: boolean = true);
begin
  inherited Create('mIsDisplayable', AValue);
end;

constructor TmAvoidancesChanged.Create(AValue: boolean = false);
begin
  inherited Create('mAvoidancesChanged', AValue);
end;

constructor TmIsRoundTrip.Create(AValue: boolean = false);
begin
  inherited Create('mIsRoundTrip', AValue);
end;

constructor TmParentTripName.Create(AValue: string);
begin
  inherited Create('mParentTripName', AValue);
end;

constructor TmExploreUuid.Create(AValue: string);
begin
  inherited Create('mExploreUuid', AValue);
end;

constructor TmAvoidancesChangedTimeAtSave.Create(AValue: TDateTime = 0);
begin
  inherited Create('mAvoidancesChangedTimeAtSave', AValue);
end;

constructor TmAvoidancesChangedTimeAtSave.Create(AValue: cardinal);
begin
  inherited Create('mAvoidancesChangedTimeAtSave', TUnixDate.CardinalAsDateTime(AValue));
end;

constructor TmOptimized.Create(AValue: boolean = false);
begin
  inherited Create('mOptimized', AValue);
end;

constructor TmTotalTripTime.Create(AValue: Cardinal = 0);
begin
  inherited Create('mTotalTripTime', AValue);
end;

function TmTotalTripTime.GetValue: string;
var
  Hour, Min: integer;
begin
  Hour := Trunc(FValue / 60 / 60);
  Min := Trunc(FValue / 60);
  MIn := Min - (Hour * 60);
  result := Format('%d Hour %d Min.', [Hour, Min]);
  result := result + Format(' (%d Seconds)', [FValue]);
end;

constructor TmImported.Create(AValue: boolean = false);
begin
  inherited Create('mImported', AValue);
end;

constructor TmRoutePreference.Create(AValue: TRoutePreference = rmFasterTime; ALenValue: Cardinal = 1; ADataType: byte = dtByte);
begin
  inherited Create('mRoutePreference', Ord(AValue));

  // Zumo 340?
  if (ADataType <> dtByte) then
  begin
    FDataType := ADataType;
    FLenValue := ALenValue;
    SetLength(FBytes, FLenValue);
    FBytes[3] := Ord(AValue);
  end;
end;

procedure TmRoutePreference.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
var
  SavePos: Cardinal;
begin
  SavePos := AStream.Position;
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);

  // Zumo 340?
  if (ADataType = dt3x0RoutePref) then
  begin
    SetLength(FBytes, FLenValue);
    AStream.Seek(SavePos, TSeekOrigin.soBeginning);
    AStream.Read(Fbytes, FLenValue);
    FValue := FBytes[3];
  end;
end;

class function TmRoutePreference.RoutePreference(AValue: string): TRoutePreference;
var
  RoutePreference: integer;
begin
  if not (IdentToInt(AValue, RoutePreference, RoutePreferenceMap)) then
    result := TRoutePreference.rmFasterTime
  else
    result := TRoutePreference(RoutePreference);
end;

class function TmRoutePreference.AdvLevel(AValue: string): TAdvlevel;
var
  AdvLevel: integer;
begin
  if not (IdentToInt(AValue, AdvLevel, AdvLevelMap)) then
    result := TAdvlevel.advNA
  else
    result := TAdvlevel(AdvLevel);
end;

procedure TmRoutePreference.WriteValue(AStream: TMemoryStream);
begin
  // Zumo 340?
  if (FDataType <> dtByte) then
  begin
    AStream.Write(FBytes, FLenValue);
    exit;
  end;

  inherited WriteValue(AStream);
end;

function TmRoutePreference.GetValue: string;
begin
  if not (IntToIdent(FValue, result, RoutePreferenceMap)) then
    result := 'N/A';
{$IFDEF DEBUG_ENUMS}
  result := result + Format(' (%d)', [FValue]);
{$ENDIF}
end;

procedure TmRoutePreference.SetValue(AValue: string);
begin
  FValue := Ord(TmRoutePreference.RoutePreference(AValue));
  if (FDataType = dt3x0RoutePref) then
  begin
    SetLength(FBytes, 5);
    FBytes[3] := FValue;
  end;
end;

function TmRoutePreference.GetEditMode: TEditMode;
begin
  result := TEditMode.emPickList;
end;

function TmRoutePreference.GetPickList: string;
var
  Index: integer;
begin
  result := '';
  for Index := MinRoutePreferenceUserConfig to MaxRoutePreferenceUserConfig do
    result := result + RoutePreferenceMap[index].Name +
{$IFDEF DEBUG_ENUMS}
                       Format(' (%d)', [RoutePreferenceMap[Index].Value]) +
{$ENDIF}
                       #10;
end;

constructor TmTransportationMode.Create(AValue: TTransportMode = tmMotorcycling);
begin
  inherited Create('mTransportationMode', Ord(AValue));
end;

class function TmTransportationMode.TransPortMethod(AValue: string): TTransportMode;
var
  TransPortMethod: integer;
begin
  if not (IdentToInt(AValue, TransPortMethod, TransportModeMap)) then
    result := TTransportMode.tmMotorcycling
  else
    result := TTransportMode(TransPortMethod);
end;

function TmTransportationMode.GetValue: string;
begin
  if not (IntToIdent(FValue, result, TransportModeMap)) then
    result := 'N/A';
{$IFDEF DEBUG_ENUMS}
  result := result + Format(' (%d)', [FValue]);
{$ENDIF}
end;

procedure TmTransportationMode.SetValue(AValue: string);
begin
  FValue := Ord(TmTransportationMode.TransPortMethod(AValue));
end;

function TmTransportationMode.GetEditMode: TEditMode;
begin
  result := TEditMode.emPickList;
end;

function TmTransportationMode.GetPickList: string;
var
  Index: integer;
begin
  result := '';
  for Index := 0 to High(TransportModeMap) do
    result := result + TransportModeMap[Index].Name +
{$IFDEF DEBUG_ENUMS}
                       Format(' (%d)', [TransportModeMap[Index].Value]) +
{$ENDIF}
                       #10;
end;

constructor TmTotalTripDistance.Create(AValue: single = 0);
begin
  inherited Create('mTotalTripDistance', AValue);
end;

function TmTotalTripDistance.GetValue: string;
begin
  result := Format('%f Km.', [FValue / 1000]);
  result := result + Format(' (%f Meters)', [FValue]);
end;

constructor TmFileName.Create(AValue: string);
begin
  inherited Create('mFileName', AValue);
end;

constructor TmPartOfSplitRoute.Create(AValue: boolean = false);
begin
  inherited Create('mPartOfSplitRoute', AValue);
end;

constructor TmTripName.Create(AValue: string);
begin
  inherited Create('mTripName', AValue);
end;

{*** Location Info classes ***}
{ TmAttr }
constructor TmAttr.Create(ARoutePoint: TRoutePoint);
begin
  inherited Create('mAttr', Ord(ARoutePoint));
end;

class function TmAttr.RoutePoint(AValue: string): TRoutePoint;
var
  RoutePoint: integer;
begin
  if not (IdentToInt(AValue, RoutePoint, RoutePointMap)) then
    result := TRoutePoint.rpShaping
  else
    result := TRoutePoint(RoutePoint);
end;

function TmAttr.GetValue: string;
begin
  if not (IntToIdent(FValue, result, RoutePointMap)) then
    result := Inherited GetValue;
end;

procedure TmAttr.SetValue(AValue: string);
begin
  FValue := Ord(TmAttr.RoutePoint(AValue));
end;

function TmAttr.GetEditMode: TEditMode;
begin
  result := TEditMode.emPickList;
end;

function TmAttr.GetPickList: string;
var
  Index: integer;
begin
  result := '';
  for Index := 0 to High(RoutePointMap) do
    result := result + RoutePointMap[Index].Name + #10;
end;

function TmAttr.GetRoutePoint: TRoutePoint;
begin
  result := TRoutePoint(FValue);
end;

{ TmIsDFSPoint }
constructor TmIsDFSPoint.Create(AValue: boolean = false);
begin
  inherited Create('mIsDFSPoint', AValue);
end;

constructor TmDuration.Create(AValue: integer = -1);
begin
  inherited Create('mDuration', AValue);
end;

{ TmArrival }
constructor TmArrival.Create(AValue: TDateTime = 0);
begin
  inherited Create('mArrival', AValue);
end;

{ TmAddress }
constructor TmAddress.Create(AValue: string);
begin
  inherited Create('mAddress', AValue);
end;

{ TmisTravelapseDestination }
constructor TmisTravelapseDestination.Create(AValue: boolean = false);
begin
  inherited Create('mIsTravelapseDestination', AValue);
end;

{ TmShapingRadius }
constructor TmShapingRadius.Create(AValue: Cardinal = $80000000);
begin
  inherited Create('mShapingRadius', AValue);
end;

function TmShapingRadius.GetValue: string;
begin
  result := '0x' + IntTohex(FValue, 8);
end;

function TmShapingRadius.GetEditMode: TEditMode;
begin
  result := TEditMode.emNone;
end;

{ TmName }
constructor TmName.Create(AValue: string);
begin
  inherited Create('mName', AValue);
end;

{ TmPhoneNumber, only for Zumo3X0}
constructor TmPhoneNumber.Create(AValue: string);
begin
  inherited Create('mPhoneNumber', AValue);
end;

{ TmShaping, only for Zumo3X0}
constructor TmShaping.Create(AValue: boolean = false);
begin
  inherited Create('mShaping', AValue);
end;

{ TBaseRoutePreferences }
function TBaseRoutePreferences.GetIntToIdent(const Value: word): string;
begin
  result := Format('TBD (0x%s)', [IntTohex(Value, 4)]);
end;

function TBaseRoutePreferences.GetCount: Cardinal;
var
  Stream: TBytesStream;
begin
  Stream := TBytesStream.Create(FBytes);
  try
    Stream.Read(result, SizeOf(result));
    result := Swap32(result);
  finally
    Stream.Free;
  end;
end;

function TBaseRoutePreferences.GetValue: string;
begin
  result := Format('%d Segments', [GetCount]);
end;

function TBaseRoutePreferences.GetRoutePrefs(RoutePreference: TObject = nil): string;
var
  Stream: TBytesStream;
  SegmentNr: Cardinal;
  RoutePref: Word;
  BaseRoutePrefByte: byte;
begin
  result := '';
  Stream := TBytesStream.Create(FBytes);
  try
    Stream.Seek(SizeOf(Cardinal), TSeekOrigin.soBeginning);
    for SegmentNr := 1 to Count do
    begin
      Stream.Read(RoutePref, SizeOf(RoutePref));
      RoutePref := Swap(RoutePref);
      if (RoutePreference <> nil) then
      begin
        BaseRoutePrefByte := TmRoutePreferences(RoutePreference).GetRoutePrefByte(SegmentNr);
        if (TRoutePreference(BaseRoutePrefByte) <> TRoutePreference.rmCurvyRoads) then
        begin
          result := result + Format('%s (0x%s)', [AdvLevelMap[0].Name, IntTohex(RoutePref, 4)]) + #10;
          continue;
        end;
      end;
      result := result + GetIntToIdent(RoutePref) + #10;
    end;
  finally
    Stream.Free;
  end;
end;

{$HINTS OFF}
function TBaseRoutePreferences.GetRoutePrefByte(ViaPt: cardinal): byte;
var
  Stream: TBytesStream;
  RoutePref: Word;
  RoutePrefLen: cardinal;
begin
  result := Ord(TRoutePreference.rmFasterTime); // Compiler warns. Never used. But for clarity kept.
  Stream := TBytesStream.Create(FBytes);
  try
    Stream.Read(RoutePrefLen, SizeOf(RoutePrefLen));
    RoutePrefLen := Swap32(RoutePrefLen);
    if (ViaPt > RoutePrefLen) then // End point for example
      exit(Ord(TRoutePreference.rmNA));

    Stream.Seek((ViaPt -1) * SizeOf(RoutePref), TSeekOrigin.soCurrent);
    Stream.Read(RoutePref, SizeOf(RoutePref));
    result := Swap(RoutePref) and $ff;
  finally
    Stream.Free;
  end;
end;
{$HINTS ON}

constructor TmRoutePreferences.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create('mRoutePreferences', 0 , $80);
end;

function TmRoutePreferences.GetIntToIdent(const Value: word): string;
begin
  if (IntToIdent(Value and $ff, result, RoutePreferenceMap)) then
    result := result + Format(' (0x%s)', [IntTohex(Value, 4)])
  else
    result := inherited GetIntToIdent(Value);
end;

function TmRoutePreferences.GetEditMode: TEditMode;
begin
  result := TEditMode.emButton;
end;

function TmRoutePreferences.GetRoutePref(ViaPt: cardinal): TRoutePreference;
begin
  result := TRoutePreference(GetRoutePrefByte(ViaPt));
end;

constructor TmRoutePreferencesAdventurousHillsAndCurves.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create('mRoutePreferencesAdventurousHillsAndCurves', 0 , $80);
end;

constructor TmRoutePreferencesAdventurousScenicRoads.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create('mRoutePreferencesAdventurousScenicRoads', 0 , $80);
end;

constructor TmRoutePreferencesAdventurousMode.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create('mRoutePreferencesAdventurousMode', 0 , $80);
end;

function TmRoutePreferencesAdventurousMode.GetIntToIdent(const Value: word): string;
begin
  if (IntToIdent(Value and $ff, result, AdvLevelMap)) then
    result := result + Format(' (0x%s)', [IntTohex(Value, 4)])
  else
    result := inherited GetIntToIdent(Value);
end;

function TmRoutePreferencesAdventurousMode.GetEditMode: TEditMode;
begin
  result := TEditMode.emButton;
end;

function TmRoutePreferencesAdventurousMode.GetRoutePref(ViaPt: cardinal): TAdvlevel;
begin
  result := TAdvlevel(GetRoutePrefByte(ViaPt));
end;

constructor TmRoutePreferencesAdventurousPopularPaths.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create('mRoutePreferencesAdventurousPopularPaths', 0 , $80);
end;

(*** TripTrack ***)

function TTrackPoint.GetMapCoords: string;
begin
  result := FormatMapCoords(CoordAsDec(Swap32(LatAsInt)), CoordAsDec(Swap32(LonAsInt)));
end;

procedure TTrackPoint.Init;
begin
  // Prefix
  Sizes1[0]   := $67000000; // Cant figure this out
  Sizes1[1]   := Swap32(SizeOf(Self) - SizeOf(Sizes1));
  DataType1   := $0a;
  Count1      := $02000000;
  // Lon
  InitLon     := $09;
  KeylenLon   := $04000000;
  KeyNameLon  := 'mLon';
  ValueLenLon := $05000000;
  DataTypeLon := $03;
  LonAsInt    := $0;
  // Lat
  InitLat     := $09;
  KeylenLat   := $04000000;
  KeyNameLat  := 'mLat';
  ValueLenLat := $05000000;
  DataTypeLat := $03;
  LatAsInt    := $0;
end;

procedure TmTrackToRouteInfoMap.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  FillChar(FTrackHeader, SizeOf(FTrackHeader), 0);
  if (Length(FBytes) > SizeOf(FTrackHeader)) then
    Move(FBytes[0], FTrackHeader, SizeOf(FTrackHeader));
end;

function TmTrackToRouteInfoMap.GetCoords(Color: string = ''): string;
var
  Offset: integer;
  Index: integer;
  ATrackPoint: TTrackPoint;
  FmtString: string;
begin
  result := '';
  if (Color <> '') then
    FmtString := '    AddTrkPoint(%s);'
  else
    FmtString := '%s';
  Offset := SizeOf(FTrackHeader);
  for Index := 0 to Swap32(FTrackHeader.TrackPoints.TrkPntCnt) -1 do
  begin
    if (Offset + SizeOf(ATrackPoint) > Length(FBytes)) then
      break;

    Move(FBytes[Offset], ATrackPoint, SizeOf(ATrackPoint));
    if (result <> '') then
      result := result + #10;
    result := result + Format(FmtString, [ATrackPoint.GetMapCoords]);
    Inc(Offset, SizeOf(ATrackPoint));
  end;
  if (Color <> '') then
    result := result + #10 + Format('    CreateTrack(''%s'', ''%s'');', [Name, Color]);
end;

procedure TmTrackToRouteInfoMap.Clear;
begin
  SetLength(FBytes, 0); // Force zeroes
  FLenValue := SizeOf(Cardinal);
  SetLength(FBytes, FLenValue);
end;

procedure TmTrackToRouteInfoMap.InitFromGpxxRpt(RtePts: TObject);
var
  RtePtNode, GpxxRptNode: TXmlVSNode;
  PrevCoords, Coords: TCoords;
  TmpStream: TMemoryStream;
  TrackPoint: TTrackPoint;
  TrkPtCnt: integer;
  TrkPtSize: cardinal;

  procedure WriteCoords;
  begin
    if (Coords.Lon <> PrevCoords.Lon) or
       (Coords.Lat <> PrevCoords.Lat) then
    begin
      Inc(TrkPtCnt);
      TrackPoint.LonAsInt := Swap32(CoordAsInt(Coords.Lon));
      TrackPoint.LatAsInt := Swap32(CoordAsInt(Coords.Lat));
      TmpStream.Write(TrackPoint, SizeOf(TrackPoint));
    end;
    PrevCoords := Coords;
  end;

begin
  TmpStream := TMemoryStream.Create;
  try
    TrkPtCnt := 0;
    TrackPoint.Init;
    FillChar(PrevCoords, SizeOf(PrevCoords), 0);
    RtePtNode := TXmlVSNodeList(RtePts).FirstChild;
    while (RtePtNode <> nil) do
    begin
      Coords.FromAttributes(RtePtNode.AttributeList);
      WriteCoords;

      GpxxRptNode := GetFirstExtensionsNode(RtePtNode);
      while (GpxxRptNode <> nil) do
      begin
        Coords.FromAttributes(GpxxRptNode.AttributeList);
        WriteCoords;

        GpxxRptNode := GpxxRptNode.NextSibling;
      end;
      RtePtNode := RtePtNode.NextSibling;
    end;
    FillChar(FTrackHeader, SizeOf(FTrackHeader), 0);
    FTrackHeader.TrackPoints.Inititiator  := #9;
    FTrackHeader.TrackPoints.KeyLen       := Swap32(Length(FTrackHeader.TrackPoints.KeyName));
    FTrackHeader.TrackPoints.KeyName      := 'mTrackPoints';
    TrkPtSize := TmpStream.Size + SizeOf(FTrackHeader.TrackPoints.DataType) + SizeOf(FTrackHeader.TrackPoints.TrkPntCnt);
    FTrackHeader.TrackPoints.ValueLen     := Swap32(TrkPtSize);
    FTrackHeader.TrackPoints.DataType     := $80;
    FTrackHeader.TrackPoints.TrkPntCnt    := Swap32(TrkPtCnt);

    FTrackHeader.TrkCnt     := Swap32(1);
    FTrackHeader.SubItems   := 3;
    FTrackHeader.SubLength  := Swap32(TrkPtSize +
                                      SizeOf(FTrackHeader.DataType) +
                                      SizeOf(FTrackHeader.ItemCount) +
                                      SizeOf(FTrackHeader.TrackPoints.Inititiator) +
                                      SizeOf(FTrackHeader.TrackPoints.KeyLen) +
                                      SizeOf(FTrackHeader.TrackPoints.KeyName) +
                                      SizeOf(FTrackHeader.TrackPoints.ValueLen));
    FTrackHeader.DataType   := $0a;
    FTrackHeader.ItemCount  := Swap32(1);

    SetLength(FBytes, SizeOf(FTrackHeader) + TmpStream.Size);
    Move(FTrackHeader, FBytes[0], SizeOf(FTrackHeader));
    TmpStream.Position := 0;
    TmpStream.Read(FBytes[SizeOf(FTrackHeader)], TmpStream.Size);
    FLenValue := SizeOf(FTrackHeader) + TmpStream.Size;
  finally
    TmpStream.Free;
  end;
end;

{*** Header ***}
procedure THeaderValue.SwapCardinals;
begin
  SubLength := Swap32(SubLength);
  TotalItems := Swap32(TotalItems);
end;

constructor THeader.Create;
begin
  inherited Create;
  FValue.Id := 'TRPL';
  FValue.SubLength := 0;
  FValue.HeaderLength := SizeOf(FValue) - SizeOf(FValue.Id) + SizeOf(FInitiator);// = 10
  FValue.TotalItems := 0;
end;

destructor THeader.Destroy;
begin
  inherited Destroy;
end;

procedure THeader.Clear;
begin
  FillChar(FValue, SizeOf(FValue), 0);
end;

procedure THeader.UpdateFromTripList(ItemCount, ASubLength: Cardinal);
begin
  FValue.TotalItems := ItemCount;
  FValue.SubLength := ASubLength - SizeOf(FInitiator);
end;

procedure THeader.WriteValue(AStream: TMemoryStream);
begin
  FValue.SwapCardinals;
  AStream.Write(FValue, SizeOf(FValue));
  FValue.SwapCardinals;
end;

{*** Location ***}
procedure TLocationValue.SwapCardinals;
begin
  Count := Swap(Count);
  Size := Swap32(Size);
end;

constructor TLocation.Create(ARoutePref: TRoutePreference = TRoutePreference.rmNA;
                             AAdvLevel: TAdvlevel = TAdvlevel.advNA);
begin
  inherited Create;
  FValue.Id := 'LCTN';
  FValue.DataType := dtLctnPref;
  FValue.Size := SizeOf(FValue) - SizeOf(FValue.Id) - SizeOf(FValue.Size);
  FItems := TItemList.Create;
  FRoutePref := ARoutePref;
  FAdvLevel := AAdvLevel;
end;

destructor TLocation.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TLocation.Add(ANitem: TBaseItem);
begin
  Inc(FValue.Count);
  FValue.Size := FValue.Size + ANitem.SubLength;
  ANitem.FTripList := TripList;
  FItems.Add(ANitem);
end;

function TLocation.LocationTmAttr: TmAttr;
var
  AnItem: TBaseItem;
begin
  result := nil;
  for AnItem in FItems do
  begin
    if (AnItem is TmAttr) then
      exit(TmAttr(AnItem));
  end;
end;

// Zumo 340
function TLocation.LocationTmShaping: TmShaping;
var
  AnItem: TBaseItem;
begin
  result := nil;
  for AnItem in FItems do
  begin
    if (AnItem is TmShaping) then
      exit(TmShaping(AnItem));
  end;
end;

function TLocation.IsViaPoint: boolean;
var
  ViaShapeObject: TObject;
begin
  case (TripList.TripModel) of
    TTripModel.Zumo3x0:
      begin
        ViaShapeObject := LocationTmShaping;
        result := Assigned(ViaShapeObject) and
                  not (TmShaping(ViaShapeObject).AsBoolean);
      end;
    else
      begin
        ViaShapeObject := LocationTmAttr;
        result := Assigned(ViaShapeObject) and
                  (TmAttr(ViaShapeObject).AsRoutePoint = TRoutePoint.rpVia);
      end;
  end;
end;

function TLocation.LocationTmName: TmName;
var
  AnItem: TBaseItem;
begin
  result := nil;
  for AnItem in FItems do
  begin
    if (AnItem is TmName) then
      exit(TmName(AnItem));
  end;
end;

function TLocation.LocationTmAddress: TmAddress;
var
  AnItem: TBaseItem;
begin
  result := nil;
  for AnItem in FItems do
  begin
    if (AnItem is TmAddress) then
      exit(TmAddress(AnItem));
  end;
end;

function TLocation.LocationTmScPosn: TmScPosn;
var
  AnItem: TBaseItem;
begin
  result := nil;
  for AnItem in FItems do
  begin
    if (AnItem is TmScPosn) then
      exit(TmScPosn(AnItem));
  end;
end;

function TLocation.LocationTmArrival: TmArrival;
var
  AnItem: TBaseItem;
begin
  result := nil;
  for AnItem in FItems do
  begin
    if (AnItem is TmArrival) then
      exit(TmArrival(AnItem));
  end;
end;

procedure TLocation.WriteValue(AStream: TMemoryStream);
begin
  FValue.SwapCardinals; // Swap Cardinals
  AStream.Write(FValue, SizeOf(FValue));
  FValue.SwapCardinals; // Swap Cardinals back
end;

{*** LocationList ***}
constructor TmLocations.Create;
begin
  inherited Create('mLocations', SizeOf(FItemCount), dtList); // Will get Length later, Via Calculate
  FItemList := TItemList.Create;
  FItemCount := 0;
end;

procedure TmLocations.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
var
  LocCnt: integer;
  LocItems: integer;
  TmpItemCount: integer;
  ALocationValue: TLocationValue;
  ABaseItem: TBaseItem;
  BytesRead: integer;
  KeyLen: Cardinal;
  KeyName: ShortString;
  SavePos: Cardinal;
  ValueLen: Cardinal;
  DataType: Byte;
  Initiator: AnsiChar;
begin
  inherited InitFromStream(AName, SizeOf(FItemCount), ADataType, AStream);
  FItemList := TItemList.Create;
  FItemCount := 0;

  // Count of locations
  AStream.Read(TmpItemCount, SizeOf(TmpItemCount));
  TmpItemCount := Swap32(TmpItemCount);

  for LocCnt := 0 to TmpItemCount -1 do
  begin
    // To get the count of items for this location
    AStream.Read(ALocationValue, SizeOf(ALocationValue));
    ALocationValue.SwapCardinals;

    AddLocation(TLocation.Create);
    for LocItems := 0 to ALocationValue.Count -1 do
    begin
      BytesRead := ReadKeyVAlues(AStream,
                                 Initiator,
                                 KeyLen,
                                 KeyName,
                                 ValueLen,
                                 DataType);
      if (BytesRead = 0) then
        break;
      SavePos := AStream.Position;
      ABaseItem := CreateBaseItemByName(TripList, KeyName, ValueLen - SizeOf(Initiator), DataType, AStream);
      Add(ABaseItem);
      ABaseItem.FTripList := TripList;

      // Should not occur
      if (AStream.Position <> SavePos + ValueLen - SizeOf(Initiator)) then
      begin
        BreakPoint;
        AStream.Seek(SavePos + ValueLen - SizeOf(Initiator), TSeekOrigin.soBeginning);
      end;

    end;
  end;
end;

destructor TmLocations.Destroy;
begin
  Clear;
  FreeAndNil(FItemList);

  inherited Destroy;
end;

procedure TmLocations.Clear;
var
  AnItem: TBaseItem;
begin
  if (Assigned(FItemList)) then
  begin
    for ANitem in FItemList do
      FreeAndNil(ANitem);
  end;
  FItemList.Clear;
  FItemCount := 0;
end;

procedure TmLocations.AddLocation(ALocation: TLocation);
begin
  ALocation.FTripList := TripList;
  FLocation := ALocation;
  FItemList.Add(ALocation);
  FItemCount := FItemCount +1;
end;

function TmLocations.Add(ANItem: TBaseItem): TBaseItem;
begin
  ANItem.FTripList := TripList;
  FItemList.Add(ANItem);
  FLocation.Add(ANItem);
  result := ANItem;
end;

function TmLocations.GetViaPointCount: Integer;
var
  ALocation: TBaseItem;
begin
  result := 0;
  for ALocation in Locations do
  begin
    if not (ALocation is TLocation) then
      continue;
    if (TLocation(ALocation).IsViaPoint) then
      inc(result);
  end;
end;

// Gets all routepoints (Including shaping) from a via point to the next. (That go in one udbhandle)
procedure TmLocations.GetSegmentPoints(ViaPoint: integer; RoutePointList: TList<TLocation>);
var
  ALocation: TBaseItem;
  ViaCnt: integer;
begin
  RoutePointList.Clear;
  ViaCnt := 0;

  for ALocation in FItemList do
  begin
    if not (ALocation is TLocation) then
      continue;
    if (TLocation(ALocation).IsViaPoint) then
      inc(ViaCnt);

    if (ViaCnt >= ViaPoint) then
      RoutePointList.Add(Tlocation(ALocation));
    if (ViaCnt > ViaPoint) then
      exit;
  end;
end;

procedure TmLocations.GetRoutePoints(RoutePointList: TList<TLocation>);
var
  ALocation: TBaseItem;
begin
  RoutePointList.Clear;

  for ALocation in FItemList do
  begin
    if not (ALocation is TLocation) then
      continue;
    RoutePointList.Add(Tlocation(ALocation));
  end;
end;

procedure TmLocations.Calculate(AStream: TMemoryStream);
var
  ANitem: TBaseItem;
  CurLocation: TLocation;
begin
  inherited Calculate(AStream);

  CurLocation := nil;
  FLenValue := SizeOf(FItemCount);
  for ANitem in FItemList do
  begin
    FLenValue := FLenValue + ANitem.SubLength;
    if (ANitem is TLocation) then
    begin
      CurLocation := TLocation(ANitem);
      CurLocation.FValue.Size := SizeOf(CurLocation.FValue) - SizeOf(CurLocation.FValue.Id) - SizeOf(CurLocation.FValue.Size);
      continue;
    end;
    CurLocation.FValue.Size := CurLocation.FValue.Size + ANitem.SubLength;
  end;
end;

procedure TmLocations.WriteValue(AStream: TMemoryStream);
var
  ANitem: TBaseItem;
begin
  WriteSwap32(AStream, FItemCount);
  for ANitem in FItemList do
    ANitem.Write(AStream);
end;

{*** UdbDir ***}
procedure TSubClass.Init(const GPXSubClass: string);
var
  Indx: integer;
begin
  MapSegment  := Swap32(StrToUInt('$' + Copy(GPXSubClass, 1, 8)));
  RoadId      := Swap32(StrToUInt('$' + Copy(GPXSubClass, 9, 8)));
  PointType   := StrToUInt('$' + Copy(GPXSubClass, 17, 2));
  for Indx := 0 to 6 do
    ComprLatLon[Indx] := StrToUInt('$' + Copy(GPXSubClass, 19 + (Indx * 2), 2));
end;

procedure TUdbDirFixedValue.SwapCardinals;
begin
  Lat := Swap32(Lat);
  Lon := Swap32(Lon);
end;

constructor TUdbDir.Create(AModel: TTripModel;
                           AName: WideString;
                           ALat: double = 0;
                           ALon: double = 0;
                           APointType: byte = $03);

begin
  inherited Create;

  FillChar(FValue, SizeOf(FValue), 0);
  SetLength(FUnknown2, UdbDirUnknown2Size[AModel]);
  SetLength(FName, UdbDirAddressSize[AModel]);
  // Copy Name
  case Ucs4Model[AModel] of
    true:
      WideStringToUCS4Array(AName, UCS4String(FName));
    false:
      WideStringToWideArray(AName, FName);
  end;
  FValue.Lat := Swap32(CoordAsInt(ALat));
  FValue.Lon := Swap32(CoordAsInt(ALon));
  FValue.SubClass.PointType := APointType;
  FUdbDirStatus := TUdbDirStatus.udsUnchecked;
end;

// UdbDir Create for <rtept>
constructor TUdbDir.Create(AModel: TTripModel; ALocation: TLocation; RouteCnt: Cardinal);
var
  AmScPosn: TmScPosn;
begin
  if not Assigned(ALocation) then
  begin
    Create(AModel, '');
    exit;
  end;

  Create(AModel, ALocation.LocationTmName.AsString);

  AmScPosn := ALocation.LocationTmScPosn;
  case AmScPosn.FValue.ScnSize of
    Zumo340_TmScPosnSize:
      begin
        FValue.Lat := Swap32(AmScPosn.FValue.Lat_8);
        FValue.Lon := Swap32(AmScPosn.FValue.Lon_8);
      end;
    Tread2_TmScPosnSize:
      begin
        FValue.Lat := Swap32(AmScPosn.FValue.Lat_16);
        FValue.Lon := Swap32(AmScPosn.FValue.Lon_16);
      end;
    else
    begin
      FValue.Lat := Swap32(AmScPosn.FValue.Lat);
      FValue.Lon := Swap32(AmScPosn.FValue.Lon);
    end;
  end;
  FValue.SubClass.MapSegment := Swap32($00000180);
  FValue.SubClass.RoadId := Swap32($00f0ffff);
  FillCompressedLatLon;
  FValue.Unknown1     := Swap32(UdbDirMagic);
  FValue.Time         := $ff;
  FValue.Border       := $ff;
  FUnknown2[4]        := $80;
  FUnknown2[5]        := $01;
end;

// UdbDir Create for <gpxx:rpt>
constructor TUdbDir.Create(AModel: TTripModel; GPXSubClass, RoadClass: string; Lat, Lon: Double);
begin
  Create(AModel, Format('%s %s %s', [RoadClass, Copy(GPXSubClass, 1, 8), Copy(GPXSubClass, 9, 8)]));

  FValue.Lat := Swap32(CoordAsInt(Lat));
  FValue.Lon := Swap32(CoordAsInt(Lon));
  FValue.SubClass.Init(GPXSubClass);
  FValue.Unknown1 := Swap32(UdbDirMagic);

  FRoadClass := RoadClass; // Not saved in Trip File
end;

procedure TUdbDir.WriteValue(AStream: TMemoryStream);
begin
  FValue.SwapCardinals;
  AStream.Write(FValue, SizeOf(FValue));
  Astream.Write(FUnknown2[0], Length(FUnknown2));
  AStream.Write(FName, Length(FName));
  FValue.SwapCardinals;
end;

function TUdbDir.SubLength: Cardinal;
begin
  result := SizeOf(FValue) + Length(FUnknown2) + Length(FName);
end;

function TUdbDir.Lat: Double;
begin
  result := CoordAsDec(Swap32(FValue.Lat));
end;

function TUdbDir.Lon: Double;
begin
  result := CoordAsDec(Swap32(FValue.Lon));
end;

function TUdbDir.GetName: string;
begin
  if (IsTurn) then
    result := UdbDirTurn
  else
  begin
    case TripList.IsUcs4 of
      true:
        result := UCS4ByteArrayToString(FName);
      false:
        result := PWideChar(FName);
    end;
  end;
end;

function TUdbDir.GetDisplayLength: integer;
begin
  result := ByteLength(GetName);
  if (TripList.IsUcs4) then
    result := result * 2;
end;

function TUdbDir.GetNameLength: integer;
begin
  result := Length(FName);
end;

function TUdbDir.GetMapCoords: string;
begin
  result := FormatMapCoords(Lat, Lon);
end;

function TUdbDir.GetCoords: TCoords;
begin
  result.Lat := Lat;
  result.Lon := Lon;
end;

function TUdbDir.GetMapSegRoad: string;
begin
  result := IntToHex(Swap32(UdbDirValue.SubClass.MapSegment), 8);
  result := result + IntToHex(Swap32(UdbDirValue.SubClass.RoadId), 8);
end;

function TUdbDir.GetMapSegRoadExclBit: string;
begin
  result := IntToHex(Swap32(UdbDirValue.SubClass.MapSegment), 8);
  // Reset bits. Is better, but not 100%, see CompareGpxRoute
  // It it still not confirmed that the RoadId is 32 bits.
  result := result + IntToHex(Swap32(UdbDirValue.SubClass.RoadId) and $ffff7fbf, 8); // $11ff7fbf; ?
end;

function TUdbDir.GetPointType: string;
begin
  case FValue.SubClass.PointType of
    3:
      result := 'Route point';
    31:
      result := 'Intermediate';
    33:
      result := 'Begin or end segment';
    else
     result := 'Unknown';
  end;
  result := Format('%s (0x%s)', [result, IntToHex(FValue.SubClass.PointType, 2)]);
end;

function TUdbDir.GetDirection: string;
begin
  if (FValue.SubClass.PointType = 3) then
    exit(PointType);

  case FValue.SubClass.Direction of
    0:
      result := 'Continue';
    2, 15, 18:
      result := 'Right';
    3:
      result := 'Sharp Right';
    4:
      result := 'U-Turn';
    5:
      result := 'Sharp Left';
    6, 16, 19:
      result := 'Left';
    8, 11, 13, 17, 20, 21:
      result := 'Ahead';
    10:
      result := 'Turn Right';
    12:
      result := 'Ferry';
    14:
      result := 'Roundabout';
    22:
      result := 'Leave route point';
    23:
      result := 'Approach route point';
    24:
      result := 'Turn Left';
    25:
      result := 'Turn Right';
    29, 34, 35, 36:
      result := 'Route point';
    79:
      result := 'Exit Roundabout';
    else
      result := 'Unknown';
  end;
  result := Format('%s (0x%s)', [result, IntToHex(FValue.SubClass.Direction, 2)]);
end;

procedure TUdbDir.FillCompressedLatLon;
begin
  FValue.SubClass.ComprLatLon[0] := T4Bytes(FValue.Lat)[0];
  FValue.SubClass.ComprLatLon[1] := T4Bytes(FValue.Lon)[0];
  FValue.SubClass.ComprLatLon[2] := 0;
  FValue.SubClass.ComprLatLon[3] := T4Bytes(FValue.Lat)[2];
  FValue.SubClass.ComprLatLon[4] := T4Bytes(FValue.Lat)[1];
  FValue.SubClass.ComprLatLon[5] := T4Bytes(FValue.Lon)[2];
  FValue.SubClass.ComprLatLon[6] := T4Bytes(FValue.Lon)[1];
end;

function TUdbDir.GetComprLatLon: string;
begin
  result := '0x' + IntToHex(FValue.SubClass.B4Lat, 2) + ' ' +
            '0x' + IntToHex(FValue.SubClass.B4Lon, 2) + ' ' +
            '0x' + IntToHex(FValue.SubClass.Reserved, 2) + ' ' +
            '0x' + IntToHex(Swap(FValue.SubClass.B2_3Lat), 4) + ' ' +
            '0x' + IntToHex(Swap(FValue.SubClass.B2_3Lon), 4);
end;

function TUdbDir.IsTurn: boolean;
begin
  result := CompareMem(@TurnMagic[0], @FName[4], SizeOf(TurnMagic));
end;

procedure TUdbDir.ComputeTime(Dist: Double);
begin
  // Table taken from default Basecamp Motorcycle profile.
  //TODO RoadSpeed Make configurable
  case (StrToIntDef('$' + RoadClass, 0)) of
    1:  FValue.Time := Round(3600 * Dist / 108);  // Interstate Highway
    2:  FValue.Time := Round(3600 * Dist / 93);   // Major Highway
    3:  FValue.Time := Round(3600 * Dist / 72);   // Other Highway
    4:  FValue.Time := Round(3600 * Dist / 56);   // Arterial Road
    5:  FValue.Time := Round(3600 * Dist / 48);   // Collector Road
    12: FValue.Time := Round(3600 * Dist / 15);   // Round about
    else
        FValue.Time := Round(3600 * Dist / 20);   // Default for all others. EG Residential
  end;
end;

{*** UdbPref *** }
procedure TUdbPrefValue.SwapCardinals;
begin
  PrefixSize := Swap32(PrefixSize);
  PrefId := Swap32(PrefId);
end;

{*** UdbHandle ***}
procedure TUdbHandleValue.SwapCardinals;
begin
  UdbHandleSize := Swap32(UdbHandleSize);
end;

procedure TUdbHandleValue.AllocUnknown2(ASize: cardinal);
begin
  SetLength(Self.Unknown2, ASize);
end;

procedure TUdbHandleValue.AllocUnknown3(ASize: cardinal);
begin
  SetLength(Self.Unknown3, ASize);
end;

procedure TUdbHandleValue.AllocUnknown(AModel: TTripModel = TTripModel.XT);
begin
  AllocUnknown2(Unknown2Size[AModel]);
  AllocUnknown3(Unknown3Size[AModel]);
end;

procedure TUdbHandleValue.UpdateUnknown3(const Offset: integer; const Value: cardinal);
var
  PUpdVal: ^cardinal;
begin
  if (Offset > Length(Self.Unknown3)) then
    exit;

  PUpdVal := @Unknown3[Offset];
  PUpdVal^ := Value;
end;

function TUdbHandleValue.GetUnknown3(const Offset: integer): cardinal;
var
  PUpdVal: ^cardinal;
begin
  if (Offset > Length(Self.Unknown3)) then
    exit(0);

  PUpdVal := @Unknown3[Offset];
  result := PUpdVal^;
end;

constructor TmUdbDataHndl.Create(AHandleId: Cardinal; AModel: TTripModel = TTripModel.XT; ForceRecalc: boolean = true);
begin
  inherited Create('mUdbDataHndl', SizeOf(FValue), dtUdbHandle); // Will get Length later, Via Calculate
  FUdbHandleId := AHandleId; // Only value seen = 1
  FillChar(FValue, SizeOf(FValue), 0);

  FillChar(FUdbPrefValue, SizeOf(FUdbPrefValue), 0);
  FUdbPrefValue.DataType := dtUdbPref;
  FUdbPrefValue.PrefId := FUdbHandleId;

  if not (ForceRecalc) then
    FValue.CalcStatus := CalculationMagic[AModel]; // Leave it to Zeroes, to force recalculation. Note: the 340 has zeroes
  FValue.AllocUnknown(AModel);
  SetLength(FTrailer, 0);
  FUdbDirList := TUdbDirList.Create;
end;

destructor TmUdbDataHndl.Destroy;
var
  AnItem: TUdbDir;
begin
  if (Assigned(FUdbDirList)) then
  begin
    for Anitem in FUdbDirList do
      AnItem.Free;

    FreeAndNil(FUdbDirList);
  end;
  inherited Destroy;
end;

procedure TmUdbDataHndl.Add(AnUdbDir: TUdbDir);
begin
  AnUdbDir.FTripList := TripList;
  FUdbDirList.Add(AnUdbDir);
end;

function TmUdbDataHndl.ComputeUnknown3Size(AModel: TTripModel): integer;
var
  TotalHandleSize: integer;
  UdbDirSize: integer;
begin
  TotalHandleSize := Swap32(integer(FValue.UdbHandleSize)) -
                     (SizeOf(FValue.CalcStatus) + Length(FValue.Unknown2) + SizeOf(FValue.UDbDirCount));
  UdbDirSize := (FValue.UDbDirCount * (SizeOf(TUdbDirFixedValue) + (UdbDirUnknown2Size[AModel]) + UdbDirAddressSize[AModel]));
  result := TotalHandleSize - UdbDirSize;
end;

procedure TmUdbDataHndl.BeginWrite(AStream: TMemoryStream);
begin
  FUdbPrefValue.SwapCardinals;
  AStream.Write(FUdbPrefValue, SizeOf(FUdbPrefValue));
  FUdbPrefValue.SwapCardinals;

  inherited EndWrite(AStream); // EndWrite for UdbPrefValue

  inherited BeginWrite(AStream); // BeginWrite for UdbDataHndle
end;

procedure TmUdbDataHndl.WriteValue(AStream: TMemoryStream);
var
  AnItem: TUdbDir;
begin
  FValue.SwapCardinals;
  AStream.Write(FValue.UdbHandleSize, SizeOf(FValue.UdbHandleSize));
  AStream.Write(FValue.CalcStatus, SizeOf(FValue.CalcStatus));
  AStream.Write(FValue.Unknown2[0], Length(FValue.Unknown2));
  AStream.Write(FValue.UDbDirCount, SizeOf(FValue.UDbDirCount));
  AStream.Write(FValue.Unknown3[0], Length(FValue.Unknown3));
  FValue.SwapCardinals;

  for AnItem in Items do
    ANitem.Write(AStream);

  AStream.Write(FTrailer[0], Length(FTrailer));
end;

procedure TmUdbDataHndl.EndWrite(AStream: TMemoryStream);
begin

  inherited EndWrite(AStream);

  if not FCalculated then
  begin
    FValue.UDbDirCount := FUdbDirList.Count;
    FLenValue := SubLength - SizeOf(FLenName) - FLenName - SizeOf(FLenValue) - SizeOf(FDataType) - SizeOf(FInitiator);
    FValue.UdbHandleSize := FLenValue -4;
    FUdbPrefValue.PrefixSize  := SubLength + SizeOf(FUdbPrefValue.DataType) + SizeOf(FUdbPrefValue.PrefId);
  end;
end;

function TmUdbDataHndl.GetModel: TTripModel;
var
  AModel: TTripModel;
begin
  result := TTripModel.Unknown;

  // Is the CalcStatus known?
  if (FValue.CalcStatus <> 0) then
  begin
    for AModel := Low(TTripModel) to High(TTripModel) do
    begin
      if (FValue.CalcStatus = CalculationMagic[AModel]) then
        exit(AModel);
    end;
  end;

  // Is the size of Unknown3 a known size of a model?
  for AModel := Low(TTripModel) to High(TTripModel) do
  begin
    if (Length(FValue.Unknown3) = Unknown3Size[AModel]) then
      exit(AModel);
  end;
end;

function TmUdbDataHndl.GetModelDescription: string;
begin
  result := GetEnumName(TypeInfo(TTripModel), Ord(GetModel));
end;

function TmUdbDataHndl.GetDistOffset: integer;
begin
  result := Unknown3DistOffset[FTripList.TripModel];
end;

function TmUdbDataHndl.GetTimeOffset: integer;
begin
  result := Unknown3TimeOffset[FTripList.TripModel];
end;

function TmUdbDataHndl.GetShapeOffset: integer;
begin
  result := Unknown3ShapeOffset[FTripList.TripModel];
end;

{*** AllRoutesList ***}
procedure TmAllRoutesValue.SwapCardinals;
begin
  UdbHandleCount := Swap32(UdbHandleCount);
end;

constructor TmAllRoutes.Create;
begin
  inherited Create('mAllRoutes', 0, dtList); // Will get Length later, Via Calculate
  FillChar(FValue, SizeOf(FValue), 0);
  FUdBList := TUdbHandleList.Create;
end;

function TmAllRoutes.ModelFromUnknown3Size(AModel: TTripModel; AnUdbHandle: TmUdbDataHndl; AStream: TStream): TTripModel;
var
  Diff: integer;
  SavePos: int64;
  FirstUdbDir: TUdbDirFixedValue;
begin
  result := AModel;
  AnUdbHandle.FValue.AllocUnknown2(Unknown2Size[AModel]); // Alloc the correct unknown2 size.
  AStream.Read(AnUdbHandle.FValue.Unknown2[0], Length(AnUdbHandle.FValue.Unknown2));
  AStream.Read(AnUdbHandle.FValue.UDbDirCount, SizeOf(AnUdbHandle.FValue.UDbDirCount)); // Need the UdbDirCount to calculate
  AnUdbHandle.FValue.AllocUnknown3(Unknown3Size[AModel]);
  AStream.Read(AnUdbHandle.FValue.Unknown3[0], Length(AnUdbHandle.FValue.Unknown3));

  Diff := AnUdbHandle.ComputeUnknown3Size(AModel) - Unknown3Size[AModel];

  if (UdbHandleTrailer[AModel] = false) then
  begin
    if (Diff <> 0) then
      result := TTripModel.Unknown;
  end
  else
  begin
    SavePos := AStream.Position;
    try
      if (AnUdbHandle.FValue.UDbDirCount > 0) then
      begin
        // Allow a trailer for the 340
        AStream.Read(FirstUdbDir, SizeOf(FirstUdbDir));
        if (Diff < 0) or
           (Diff > SizeOf(TUdbDirFixedValue)) or
           (Swap32(FirstUdbDir.Unknown1) <> UdbDirMagic) then
          exit(TTripModel.Unknown);
      end;
    finally
      AStream.Seek(SavePos, TSeekOrigin.soBeginning);
    end;
  end;
end;

procedure TmAllRoutes.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
var
  UdbHandleCnt: integer;
  AnUdbHandle: TmUdbDataHndl;

  BytesRead: integer;
  KeyLen: Cardinal;
  KeyName: ShortString;
  SavePosUdb, SavePos: Cardinal;
  ValueLen: Cardinal;
  DataType: Byte;
  Initiator: AnsiChar;

  UdbDirCnt: integer;
  AnUdbDir: TUdbDir;
  SelModel, AModel: TTripModel;
  Diff: Int64;
begin
  inherited InitFromStream(AName, SizeOf(FValue), ADataType, AStream);
  FUdBList := TUdbHandleList.Create;

  // Count of Udb's
  AStream.Read(FValue.UdbHandleCount, SizeOf(FValue.UdbHandleCount));
  FValue.UdbHandleCount := Swap32(FValue.UdbHandleCount);

  for UdbHandleCnt := 0 to FValue.UdbHandleCount -1 do
  begin
    AnUdbHandle := TmUdbDataHndl.Create(UdbHandleCnt);

    AStream.Read(AnUdbHandle.FUdbPrefValue, SizeOf(AnUdbHandle.FUdbPrefValue));
    AnUdbHandle.FUdbPrefValue.SwapCardinals;
    AnUdbHandle.FUdbHandleId := Swap32(AnUdbHandle.FUdbPrefValue.PrefId);

    BytesRead := ReadKeyVAlues(AStream,
                               Initiator,
                               KeyLen,
                               KeyName,
                               ValueLen,
                               DataType);
    if (BytesRead = 0) then
      break;
    SavePos := AStream.Position;
    AStream.Read(AnUdbHandle.FValue.UdbHandleSize, SizeOf(AnUdbHandle.FValue.UdbHandleSize));
    AStream.Read(AnUdbHandle.FValue.CalcStatus, SizeOf(AnUdbHandle.FValue.CalcStatus));

    // Alloc Unknown2 and unknown3 blocks
    // Check for known calculation magic
    SelModel := TTripModel.Unknown;               // Default to Unknown
    if (AnUdbHandle.FValue.CalcStatus <> 0) then  // The Zumo 340 has 0, even if calculated.
    begin
      for AModel := Low(TTripModel) to High(TTripModel) do
      begin
        if (AnUdbHandle.FValue.CalcStatus = CalculationMagic[AModel]) then
        begin
          SelModel := ModelFromUnknown3Size(AModel, AnUdbHandle, AStream);
          break;
        end;
      end;
    end;

    // Check for known unknown3 size
    if (SelModel = TTripModel.Unknown) then
    begin
      SavePosUdb :=  AStream.Position;
      for AModel := Low(TTripModel) to High(TTripModel) do
      begin
        AStream.Seek(SavePosUdb, TSeekOrigin.soBeginning);              // reposition to start of UDBDir
        SelModel := ModelFromUnknown3Size(AModel, AnUdbHandle, AStream); // Now we have the UdbDirCount, we can compute the size.
        if (SelModel = AModel) then
          break;
      end;
    end;

    AnUdbHandle.FValue.SwapCardinals;

    for UdbDirCnt := 0 to AnUdbHandle.FValue.UDbDirCount -1 do
    begin
      AnUdbDir := TUdbDir.Create('');
      AStream.Read(AnUdbDir.FValue, SizeOf(AnUdbDir.FValue));
      SetLength(AnUdbDir.FUnknown2, UdbDirUnknown2Size[SelModel]);
      AStream.Read(AnUdbDir.FUnknown2[0], Length(AnUdbDir.FUnknown2));
      SetLength(AnUdbDir.FName, UdbDirAddressSize[SelModel]);
      AStream.Read(AnUdbDir.FName[0], Length(AnUdbDir.FName));
      AnUdbDir.FValue.SwapCardinals;
      AnUdbHandle.FTripList := TripList;
      AnUdbHandle.Add(AnUdbDir);
    end;

    AddUdbHandle(AnUdbHandle);
    Diff := (SavePos + ValueLen - SizeOf(Initiator)) - AStream.Position;
    if (Diff > 0) and
       (UdbHandleTrailer[SelModel]) then // The Zumo 340 and Nuvi 2595 can have trailer bytes.
    begin
      SetLength(AnUdbHandle.FTrailer, Diff);
      AStream.Read(AnUdbHandle.FTrailer[0], Length(AnUdbHandle.FTrailer));
      continue;
    end;

    // Should not occur
    if (Diff <> 0) then
    begin
      BreakPoint;
      AStream.Seek(SavePos + ValueLen - SizeOf(Initiator), TSeekOrigin.soBeginning);
    end;
  end;
end;

destructor TmAllRoutes.Destroy;
var
  AnItem: TmUdbDataHndl;
begin
  if (Assigned(FUdBList)) then
  begin
    for ANitem in FUdBList do
      ANitem.Free;

    FreeAndNil(FUdBList);
  end;
  inherited Destroy;
end;

procedure TmAllRoutes.AddUdbHandle(AnUdbHandle: TmUdbDataHndl);
begin
  AnUdbHandle.FTripList := TripList;
  FUdBList.Add(AnUdbHandle);
end;

procedure TmAllRoutes.EndWrite(AStream: TMemoryStream);
begin
  inherited EndWrite(AStream);

  if not FCalculated then
  begin
    FValue.UdbHandleCount := FUdBList.Count;
    FLenValue := SubLength - SizeOf(FLenName) - FLenName - SizeOf(FLenValue) - SizeOf(FDataType) - SizeOf(FInitiator);
  end;
end;

procedure TmAllRoutes.WriteValue(AStream: TMemoryStream);
var
  ANitem: TmUdbDataHndl;
begin
  FValue.SwapCardinals;
  AStream.Write(FValue, SizeOf(FValue));
  FValue.SwapCardinals;

  for ANitem in FUdBList do
    ANitem.Write(AStream);
end;

{*** TripList ***}
constructor TTripList.Create;
begin
  inherited Create;
  FRouteCnt := 0;
  FItemList := TItemList.Create;
end;

destructor TTripList.Destroy;
begin
  Clear;

  FItemList.Free;
  inherited Destroy;
end;

procedure TTripList.Clear;
var
  ANitem: TBaseItem;
begin
  if (Assigned(ItemList)) then
  begin
    for ANitem in ItemList do
      FreeAndNil(ANitem);

    ItemList.Clear;
  end;

  if (Assigned(Header)) then
    FreeAndNil(Header);
end;

procedure TTripList.AddHeader(AHeader: THeader);
begin
  FHeader := AHeader;
end;

function TTripList.Add(ANItem: TBaseItem): TBaseItem;
begin
  ANItem.FTripList := Self;
  ItemList.Add(ANItem);
  result := ANItem;
end;

procedure TTripList.ResetCalculation;
var
  ANItem: TBaseItem;
  ALocation: TBaseItem;
  AnUdbHandle: TBaseItem;
  AnUdbDir: TbaseItem;
begin
  GetModel;

  for ANItem in ItemList do
  begin
    ANitem.FCalculated := false;
    if (ANItem is TmLocations) then
    begin
      for ALocation in TmLocations(ANItem).Locations do
        ALocation.FCalculated := false;
    end;

    if (ANItem is TmAllRoutes) then
    begin
      for AnUdbHandle in TmAllRoutes(ANItem).Items do
      begin
        AnUdbHandle.FCalculated := false;
        for AnUdbDir in TmUdbDataHndl(AnUdbHandle).Items do
          AnUdbDir.FCalculated := false;
      end;
    end;

  end;
end;

procedure TTripList.Calculate(AStream: TMemoryStream);
var
  ANItem: TBaseItem;
  FSubLength: Cardinal;
begin
  // Be sure to recalculate all items.
  ResetCalculation;

  FSubLength := 6; //We need to add 6, but can't figure out why.
  for ANItem in ItemList do
  begin
    if (ANItem is TBaseItem) then
      ANitem.Calculate(AStream);
    FSubLength := FSubLength + ANItem.SubLength;
  end;

  Header.UpdateFromTripList(ItemList.Count, FSubLength);
{$IFDEF DEBUG_POS}
  AllocConsole;
  Writeln('Total: ', FSubLength);
  Readln;
{$ENDIF}
end;

procedure TTripList.Recalculate;
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    Calculate(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TTripList.UpdLocsFromRoutePrefs;
var
  RoutePreferences: TmRoutePreferences;
  RoutePreferencesAdventurousMode: TmRoutePreferencesAdventurousMode;
  Locations: TmLocations;
  ViaPt: integer;
  RoutePointList: TList<TLocation>;
  Location: TLocation;
begin
  RoutePreferences := GetItem('mRoutePreferences') as TmRoutePreferences;
  if (RoutePreferences = nil) then
    exit;
  RoutePreferencesAdventurousMode := GetItem('mRoutePreferencesAdventurousMode') as TmRoutePreferencesAdventurousMode;
  if (RoutePreferencesAdventurousMode = nil) then
    exit;

  Locations := GetItem('mLocations') as TmLocations;
  if (Locations = nil) then
    exit;
  RoutePointList := TList<TLocation>.Create;
  try
    for ViaPt := 1 to Locations.ViaPointCount do
    begin
      Locations.GetSegmentPoints(ViaPt, RoutePointList);
      Location := RoutePointList[0];
      Location.RoutePref := RoutePreferences.GetRoutePref(ViaPt);
      if (Location.RoutePref = TRoutePreference.rmCurvyRoads) then
        Location.AdvLevel := RoutePreferencesAdventurousMode.GetRoutePref(ViaPt)
      else
        Location.AdvLevel := TAdvlevel.advNA;
    end;
  finally
    RoutePointList.Free;
  end;
end;

procedure TTripList.SaveToStream(AStream: TMemoryStream);
var
  ANitem: TBaseItem;
begin
  AStream.Clear;
  Calculate(AStream);

  AStream.Clear;
  Header.Write(AStream);
  for ANitem in ItemList do
    ANitem.Write(AStream);
end;

procedure TTripList.SaveToFile(AFile: string);
var
  AStream: TMemoryStream;
begin
{$IFNDEF DEBUG}
  if not (SafeToSave[TripModel]) then
    raise Exception.Create(Format('Writing not supported for model: %s', [ModelDescription]));
{$ENDIF}
  AStream := TMemoryStream.Create;
  try
    try
      SaveToStream(AStream);
      AStream.SaveToFile(AFile);
    except on E:exception do
      MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
    end;
  finally
    AStream.Free;
  end;
end;

function TTripList.LoadFromStream(AStream: TStream): boolean;
var
  AHeader: THeaderValue;
  BytesRead: integer;
  KeyLen: Cardinal;
  KeyName: ShortString;
  SavePos: Cardinal;
  ValueLen: Cardinal;
  DataType: Byte;
  Initiator: AnsiChar;
  ABaseItem: TBaseItem;
begin
  Clear;

  AStream.Position := 0;
  BytesRead := AStream.Read(AHeader, SizeOf(AHeader));
  if (BytesRead <> SizeOf(AHeader)) or
     (AHeader.Id <> 'TRPL') then
     exit(false);

  AddHeader(THeader.Create);
  AHeader.SubLength := Swap32(AHeader.SubLength);
  AHeader.TotalItems := Swap32(AHeader.TotalItems);
  Header.FValue := AHeader;

  while true do
  begin
    BytesRead := ReadKeyVAlues(AStream,
                               Initiator,
                               KeyLen,
                               KeyName,
                               ValueLen,
                               DataType);
    if (BytesRead = 0) then
      break;
    SavePos := AStream.Position;
    ABaseItem := CreateBaseItemByName(Self, KeyName, ValueLen - SizeOf(Initiator), DataType, AStream);
    Add(ABaseItem);
    ABaseItem.FTripList := Self;

    // Should not occur
    if (AStream.Position <> SavePos + ValueLen - SizeOf(Initiator)) then
    begin
      BreakPoint;
      AStream.Seek(SavePos + ValueLen - SizeOf(Initiator), TSeekOrigin.soBeginning);
    end;

  end;
  UpdLocsFromRoutePrefs;
  Recalculate;
  result := true;
end;

function TTripList.LoadFromFile(AFile: string): boolean;
var
  AStream: TBufferedFileStream;
begin
  AStream := TBufferedFileStream.Create(AFile, fmOpenRead or fmShareDenyNone);
  try
    result := LoadFromStream(AStream);
    if not result then
      raise Exception.Create(Format('Not a valid trip file: %s', [AFile]));
  finally
    AStream.Free;
  end;
end;

procedure TTripList.Assign(ATripList: TTripList);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    ATripList.SaveToStream(Astream);
    Clear;
    LoadFromStream(AStream);
  finally
    AStream.Free;
  end;
end;

function TTripList.GetValue(AKey: ShortString): string;
var
  AnItem: TBaseItem;
begin
  result := '';
  for AnItem in ItemList do
  begin
    if (AnItem is TBaseDataItem) then
    with TBaseDataItem(AnItem) do
    begin
      if (FName = AKey) then
        exit(AsString);
    end;
  end;
end;

function TTripList.GetItem(AKey: ShortString): TBaseItem;
var
  AnItem: TBaseItem;
begin
  result := nil;
  for AnItem in ItemList do
  begin
    if (AnItem is TBaseDataItem) then
    with TBaseDataItem(AnItem) do
    begin
      if (FName = AKey) then
        exit(AnItem);
    end;
  end;
end;

procedure TTripList.SetItem(AKey: ShortString; ABaseItem: TBaseItem);
var
  Index: integer;
begin
  for Index := 0 to ItemList.Count -1 do
  begin
    if (ItemList[Index] is TBaseDataItem) and
       (TbaseDataItem(ItemList[Index]).Name = AKey) then
      ItemList[Index] := ABaseItem;
  end;
end;

function TTripList.GetRoutePointCount: integer;
var
  ALocations: TmLocations;
  ALocation: TBaseItem;
begin
  result := 0;
  ALocations := TmLocations(GetItem('mLocations'));
  if not (Assigned(ALocations)) then
    exit;
  for ALocation in ALocations.Locations do
  begin
    if (ALocation is TLocation) then
      inc(result);
  end;
end;

function TTripList.GetRoutePoint(RoutePointId: integer): Tlocation;
var
  ALocations: TmLocations;
  ALocation: TBaseItem;
  RoutePointCnt: integer;
begin
  result := nil;
  ALocations := TmLocations(GetItem('mLocations'));
  if not (Assigned(ALocations)) then
    exit;
  RoutePointCnt := -1;
  for ALocation in ALocations.Locations do
  begin
    if (ALocation is TLocation) then
      inc(RoutePointCnt);
    if (RoutePointCnt = RoutePointId) then
      exit(Tlocation(ALocation));
  end;
end;

function TTripList.OSMRoutePoint(RoutePointId: integer): TOSMRoutePoint;
var
  ALocation: TLocation;
  AnItem: TBaseItem;

begin
  FillChar(result, SizeOf(result), #0);
  ALocation := GetRoutePoint(RoutePointId);
  if not (Assigned(ALocation)) then
    exit;

  for AnItem in ALocation.LocationItems do
  begin
    if (AnItem is TmName) then
      result.Name := TmName(AnItem).GetValue;
    if (AnItem is TmScPosn) then
      result.MapCoords := TmScPosn(AnItem).MapCoords;
  end;
end;

function TTripList.GetArrival: TmArrival;
var
  StartLocation: TLocation;
  Arrival: TBaseItem;
begin
  result := nil;

  StartLocation := GetRoutePoint(0);
  if (StartLocation = nil) then
    exit;
  for Arrival in StartLocation.LocationItems do
  begin
    if (Arrival is TmArrival) then
      exit(TmArrival(Arrival));
  end;
end;

procedure TTripList.CreateOSMPoints(const OutStringList: TStringList; const HTMLColor: string);
var
  Coords, Color, LayerName, RoutePointName: string;
  LayerId: integer;
  TripName: TmTripName;
  AllRoutes: TmAllRoutes;
  UdbDataHndl: TmUdbDataHndl;
  UdbDir: TUdbDir;
  Locations: TmLocations;
  Location: TBaseItem;
  ANItem: TBaseItem;
  HasUdbs: boolean;
begin
  OutStringList.Clear;
  TripName := TmTripName(GetItem('mTripName'));
  if (not Assigned(TripName)) then
    exit;

  HasUdbs := false;
  AllRoutes := TmAllRoutes(GetItem('mAllRoutes'));
  if (Assigned(AllRoutes)) then
  begin
    for UdbDataHndl in AllRoutes.Items do
    begin
      HasUdbs := HasUdbs or (UdbDataHndl.Items.Count > 0);
      for UdbDir in UdbDataHndl.Items do
        OutStringList.Add(Format('    AddTrkPoint(%s);', [FormatMapCoords(UdbDir.Lat, UdbDir.Lon)]) );
    end;
  end;

  Locations := TmLocations(GetItem('mLocations'));
  if (Assigned(Locations)) then
  begin
    for Location in Locations.Locations do
    begin
      if (Location is TLocation) then
      begin
        Coords := '';
        RoutePointName := '';
        LayerId := 0;
        LayerName := Format('Shape: %s', [EscapeDQuote(TripName.AsString)]);
        Color := 'blue';

        for ANItem in TLocation(Location).LocationItems do
        begin
          if (ANItem is TmAttr) then
          begin
            if (Pos('Via', TmAttr(ANItem).AsString) = 1) then
            begin
              LayerName := Format('Via: %s', [EscapeDQuote(TripName.AsString)]);
              LayerId := 1;
              Color := 'red';
            end;
          end;
          if (ANItem is TmName) then
            RoutePointName := EscapeDQuote(TmName(ANItem).AsString);

          if (ANItem is TmScPosn) then
            Coords := TmScPosn(ANItem).MapCoords;
        end;

        if not (HasUdbs) then
          OutStringList.Add(Format('    AddTrkPoint(%s);', [Coords], FloatFormatSettings ) );

        OutStringList.Add(Format('    AddRoutePoint(%d, "%s", "%s", %s, "%s");',
                                 [LayerId,
                                  LayerName,
                                  RoutePointName,
                                  Coords,
                                  Color]));
      end;
    end;
    OutStringList.Add(Format('    CreateTrack("%s", ''%s'');', [EscapeDQuote(TripName.AsString), HTMLColor]));

  end;
end;

procedure TTripList.SetRoutePref(AKey: ShortString; TmpStream: TMemoryStream);
var
  RoutePreference: TRawDataItem;
begin
  RoutePreference := TRawDataItem(GetItem(AKey));
  if (RoutePreference <> nil) then
  begin
    TmpStream.Position := 0;
    RoutePreference.InitFromStream(AKey, TmpStream.Size, $80, TmpStream);
  end;
end;

procedure TTripList.SetRoutePrefs_XT2_Tread2(Locations: TmLocations; ProcessOptions: TObject);
var
  ViaPt, SegmentCount: integer;
  RoutePreferences: array of WORD;
  RoutePreferencesAdventurous: array of WORD;
  RoutePreferencesAdventurousHillsAndCurves: array of WORD;
  TmpStream: TMemoryStream;
  RoutePointList: TList<TLocation>;
  Location: TLocation;
begin
  SegmentCount := Locations.ViaPointCount -1;
  if (SegmentCount < 1) then
    exit;

  RoutePointList := TList<TLocation>.Create;
  TmpStream := TMemoryStream.Create;
  try
    SetLength(RoutePreferences, SegmentCount);
    SetLength(RoutePreferencesAdventurous, SegmentCount);
    SetLength(RoutePreferencesAdventurousHillsAndCurves, SegmentCount);

    // Set RoutePrefs from location
    for ViaPt := 0 to SegmentCount -1 do
    begin
      Locations.GetSegmentPoints(ViaPt +1, RoutePointList);
      Location := RoutePointList[0];
      RoutePreferences[ViaPt] := Swap(DefRoutePref + Ord(Location.RoutePref));
      case (Location.RoutePref) of
        TRoutePreference.rmCurvyRoads:
          begin
            if (Location.AdvLevel = TAdvlevel.advNA) then
              Location.AdvLevel := TProcessOptions(ProcessOptions).DefAdvLevel;

            RoutePreferencesAdventurous[ViaPt] := Swap(DefRoutePref + Ord(Location.AdvLevel));
            RoutePreferencesAdventurousHillsAndCurves[ViaPt] := Swap(DefRoutePrefHillsAndCurves);
          end;
        else
          begin
            RoutePreferencesAdventurous[ViaPt] := Swap(DefRoutePrefAdv);
            RoutePreferencesAdventurousHillsAndCurves[ViaPt] := Swap(DefRoutePref);
          end;
      end;
    end;

    PrepStream(TmpStream, SegmentCount, RoutePreferences);
    SetRoutePref('mRoutePreferences',TmpStream);

    // RoutePrefs from Adventurous
    PrepStream(TmpStream, SegmentCount, RoutePreferencesAdventurous);
    SetRoutePref('mRoutePreferencesAdventurousMode', TmpStream);

    // RoutePrefs from Adventurous Hills and Curves
    PrepStream(TmpStream, SegmentCount, RoutePreferencesAdventurousHillsAndCurves);
    SetRoutePref('mRoutePreferencesAdventurousHillsAndCurves', TmpStream);

    // All others
    for ViaPt := 0 to High(RoutePreferences) do
      RoutePreferences[ViaPt] := Swap(DefRoutePref);
    PrepStream(TmpStream, SegmentCount, RoutePreferences);
    SetRoutePref('mRoutePreferencesAdventurousScenicRoads', TmpStream);
    SetRoutePref('mRoutePreferencesAdventurousPopularPaths', TmpStream);
  finally
    TmpStream.Free;
    RoutePointList.Free;
  end;
end;

procedure TTripList.AddLocation_XT(Locations: TmLocations;
                                   ProcessOptions: TObject;
                                   RoutePoint: TRoutePoint;
                                   Lat, Lon: double;
                                   DepartureDate: TDateTime;
                                   Name, Address: string);
begin
  Locations.AddLocation(TLocation.Create);

  Locations.Add(TmAttr.Create(RoutePoint));
  Locations.Add(TmIsDFSPoint.Create);
  Locations.Add(TmDuration.Create);
  Locations.Add(TmArrival.Create(DepartureDate));
  Locations.Add(TmScPosn.Create(Lat, Lon, TProcessOptions(ProcessOptions).ScPosn_Unknown1));
  Locations.Add(TmAddress.Create(Address));
  Locations.Add(TmisTravelapseDestination.Create);
  Locations.Add(TmShapingRadius.Create);
  Locations.Add(TmName.Create(Name));
end;

procedure TTripList.AddLocation_XT2(Locations: TmLocations;
                                    ProcessOptions: TObject;
                                    RoutePoint: TRoutePoint;
                                    RoutePref: TRoutePreference;
                                    AdvLevel: TAdvlevel;
                                    Lat, Lon: double;
                                    DepartureDate: TDateTime;
                                    Name, Address: string);
var
  TmpStream : TMemoryStream;
begin
  TmpStream := TMemoryStream.Create;
  try
    Locations.AddLocation(TLocation.Create(RoutePref, AdvLevel));

    PrepStream(TmpStream, [Swap32($00000008), Swap32($00000080), Swap32($00000080)]);
    Locations.Add(TRawDataItem.Create).InitFromStream('mShapingCenter', TmpStream.Size, $08, TmpStream);
    Locations.Add(TmAttr.Create(RoutePoint));
    Locations.Add(TmIsDFSPoint.Create);
    Locations.Add(TmDuration.Create);
    Locations.Add(TmArrival.Create(DepartureDate));
    Locations.Add(TmScPosn.Create(Lat, Lon, TProcessOptions(ProcessOptions).ScPosn_Unknown1));
    Locations.Add(TmAddress.Create(Address));
    Locations.Add(TmisTravelapseDestination.Create);
    Locations.Add(TmShapingRadius.Create);
    Locations.Add(TmName.Create(Name));
  finally
    TmpStream.Free;
  end;
end;

procedure TTripList.AddLocation_Tread2(Locations: TmLocations;
                                       ProcessOptions: TObject;
                                       RoutePoint: TRoutePoint;
                                       RoutePref: TRoutePreference;
                                       AdvLevel: TAdvlevel;
                                       Lat, Lon: double;
                                       DepartureDate: TDateTime;
                                       Name, Address: string);
var
  TmpStream : TMemoryStream;
begin
  TmpStream := TMemoryStream.Create;
  try
    Locations.AddLocation(TLocation.Create(RoutePref, AdvLevel));

    Locations.Add(TmisTravelapseDestination.Create);
    Locations.Add(TmShapingRadius.Create);
    PrepStream(TmpStream, [Swap32($00000008), Swap32($00000080), Swap32($00000080)]);
    Locations.Add(TRawDataItem.Create).InitFromStream('mShapingCenter', TmpStream.Size, $08, TmpStream);
    Locations.Add(TmDuration.Create);
    Locations.Add(TmArrival.Create(DepartureDate));
    Locations.Add(TmScPosn.Create(Lat, Lon, TProcessOptions(ProcessOptions).ScPosn_Unknown1, Tread2_TmScPosnSize));
    Locations.Add(TmAttr.Create(RoutePoint));
    Locations.Add(TmAddress.Create(Address));
    Locations.Add(TmName.Create(Name));
  finally
    TmpStream.Free;
  end;
end;

procedure TTripList.AddLocation_Zumo595(Locations: TmLocations;
                                        ProcessOptions: TObject;
                                        RoutePoint: TRoutePoint;
                                        Lat, Lon: double;
                                        DepartureDate: TDateTime;
                                        Name, Address: string);
begin
  Locations.AddLocation(TLocation.Create);
  Locations.Add(TmScPosn.Create(Lat, Lon, TProcessOptions(ProcessOptions).ScPosn_Unknown1));
  Locations.Add(TmIsDFSPoint.Create);
  Locations.Add(TmDuration.Create);
  Locations.Add(TmArrival.Create(DepartureDate));
  Locations.Add(TmName.Create(Name));
  Locations.Add(TmAddress.Create(Address));
  Locations.Add(TmAttr.Create(RoutePoint));
  Locations.Add(TmShapingRadius.Create);
end;

procedure TTripList.AddLocation_Drive51(Locations: TmLocations;
                                        ProcessOptions: TObject;
                                        RoutePoint: TRoutePoint;
                                        Lat, Lon: double;
                                        DepartureDate: TDateTime;
                                        Name, Address: string);
begin
  Locations.AddLocation(TLocation.Create);
  Locations.Add(TmAttr.Create(RoutePoint));
  Locations.Add(TmDuration.Create);
  Locations.Add(TmArrival.Create(DepartureDate));
  Locations.Add(TmScPosn.Create(Lat, Lon, TProcessOptions(ProcessOptions).ScPosn_Unknown1));
  Locations.Add(TmAddress.Create(Address));
  Locations.Add(TmisTravelapseDestination.Create);
  Locations.Add(TmShapingRadius.Create);
  Locations.Add(TmName.Create(Name));
end;

procedure TTripList.AddLocation_Zumo3x0(Locations: TmLocations;
                                        ProcessOptions: TObject;
                                        RoutePoint: TRoutePoint;
                                        Lat, Lon: double;
                                        DepartureDate: TDateTime;
                                        Name, Address: string);
begin
  Locations.AddLocation(TLocation.Create);
  Locations.Add(TmAddress.Create(Address));
  Locations.Add(TmArrival.Create(DepartureDate));
  Locations.Add(TmDuration.Create);
  Locations.Add(TmName.Create(Name));
  Locations.Add(TmPhoneNumber.Create(''));
  Locations.Add(TmScPosn.Create(Lat, Lon, TProcessOptions(ProcessOptions).ScPosn_Unknown1, Zumo340_TmScPosnSize));
  Locations.Add(TmShaping.Create(RoutePoint <> TRoutePoint.rpVia));
end;

procedure TTripList.AddLocation(Locations: TmLocations;
                                ProcessOptions: TObject;
                                RoutePoint: TRoutePoint;
                                RoutePref: TRoutePreference;
                                AdvLevel: TAdvlevel;
                                Lat, Lon: double;
                                DepartureDate: TDateTime;
                                Name, Address: string);
begin
  case TProcessOptions(ProcessOptions).TripModel of
    TTripModel.XT2:
      AddLocation_XT2(Locations, ProcessOptions, RoutePoint, RoutePref, AdvLevel, Lat, Lon, DepartureDate, Name, Address);
    TTripModel.Tread2:
      AddLocation_Tread2(Locations, ProcessOptions, RoutePoint, RoutePref, AdvLevel, Lat, Lon, DepartureDate, Name, Address);
    TTripModel.Zumo595:
      AddLocation_Zumo595(Locations, ProcessOptions, RoutePoint, Lat, Lon, DepartureDate, Name, Address);
    TTripModel.Drive51:
      AddLocation_Drive51(Locations, ProcessOptions, RoutePoint, Lat, Lon, DepartureDate, Name, Address);
    TTripModel.Zumo3x0:
      AddLocation_Zumo3x0(Locations, ProcessOptions, RoutePoint, Lat, Lon, DepartureDate, Name, Address);
    else
      // No RoutePref for XT
      AddLocation_XT(Locations, ProcessOptions, RoutePoint, Lat, Lon, DepartureDate, Name, Address);
  end;
end;

procedure TTripList.ForceRecalc(const AModel: TTripModel = TTripModel.Unknown; ViaPointCount: integer = 0);
var
  AllRoutes: TBaseItem;
  Index: integer;
  ViaCount: integer;
  RoutePointList: TList<TLocation>;
  ALocation: TLocation;
  Locations: TBaseItem;
  AnUdbHandle: TmUdbDataHndl;
  ProcessOptions: TProcessOptions;
begin
  // If the model is not supplied, try to get it from the data
  FTripModel := GetCalculationModel(AModel);

  // All Routes
  AllRoutes := InitAllRoutes;

  // Need locations
  Locations := GetItem('mLocations');

  // Count Via points
  ViaCount := ViaPointCount;
  if (ViaCount = 0) then  // Count from already assigned Locations
  begin
    if not Assigned(Locations) then
      exit;
    ViaCount := TmLocations(Locations).ViaPointCount;
  end;

  // At least a begin and end point needed. So at least 1 UdbHandle
  ViaCount := Max(ViaCount, 2);

  ProcessOptions := TProcessOptions.Create;
  RoutePointList := TList<TLocation>.Create;
  try
    // Create Dummy UdbHandles and add to allroutes. Just one entry for every Via.
    // The XT(2) recalculates all.
    for Index := 1 to ViaCount -1 do
    begin
      AnUdbHandle := TmUdbDataHndl.Create(1, TripModel);
      AnUdbHandle.FTripList := Self;
      // Add udb's for all Via and Shaping found in Locations.
      // Will be discarded when recalculated on the Zumo.
      if (Assigned(Locations)) then
      begin
        TmLocations(Locations).GetSegmentPoints(Index, RoutePointList);
        for ALocation in RoutePointList do
          AnUdbHandle.Add(TUdbDir.Create(TripModel, ALocation, RouteCnt));
      end;

      TmAllRoutes(AllRoutes).AddUdbHandle(AnUdbHandle);
    end;

    // Recreate RoutePreferences
    case TripModel of
      TTripModel.XT2,
      TTripModel.Tread2:
        begin
          TmTrackToRouteInfoMap(GetItem('mTrackToRouteInfoMap')).Clear;
          SetRoutePrefs_XT2_Tread2(TmLocations(Locations), ProcessOptions);
        end;
    end;
  finally
    RoutePointList.Free;
    ProcessOptions.Free;
  end;
end;

procedure TTripList.SetPreserveTrackToRoute(const RtePts: TObject);
var
  TrackToRouteInfoMap: TmTrackToRouteInfoMap;
  PreserveTrackToRoute: TmPreserveTrackToRoute;
  DayNumber: TmDayNumber;
begin
  DayNumber := (GetItem('mDayNumber') as TmDayNumber);
  if Assigned(DayNumber) then
    DayNumber.AsByte := 0;

  // Create TrackToRouteInfoMap for XT2 and Tread2
  TrackToRouteInfoMap := GetItem('mTrackToRouteInfoMap') as TmTrackToRouteInfoMap;
  if Assigned(TrackToRouteInfoMap) and
     Assigned(RtePts) then
    TrackToRouteInfoMap.InitFromGpxxRpt(RtePts);

  // For XT
  PreserveTrackToRoute := GetItem('mPreserveTrackToRoute') as TmPreserveTrackToRoute;
  if Assigned(PreserveTrackToRoute) then
    PreserveTrackToRoute.AsBoolean := true;
end;

procedure TTripList.UpdateDistAndTime(TotalDist: single; TotalTime: Cardinal);
var
  TotalTripDistance: TmTotalTripDistance;
  TotalTripTime: TmTotalTripTime;
begin
  TotalTripDistance := (GetItem('mTotalTripDistance') as TmTotalTripDistance);
  if (Assigned(TotalTripDistance)) then
    TotalTripDistance.AsSingle := TotalDist;
  TotalTripTime := (GetItem('mTotalTripTime') as TmTotalTripTime);
  if (Assigned(TotalTripTime)) then
    TotalTripTime.AsCardinal := TotalTime;
end;

procedure TTripList.TripTrack(const AModel: TTripModel;
                              const RtePts: TObject;
                              const SubClasses: TStringList);
var
  Locations: TBaseItem;
  RoutePointList: TList<TLocation>;
  ALocation: TLocation;
  AllRoutes: TBaseItem;
  Index: integer;
  AnUdbHandle: TmUdbDataHndl;
  PrevUdbDir, AnUdbDir: TUdbDir;
  GpxRptNode: TXmlVSNode;
  Coords: TCoords;
  TotalTime: integer;
  TotalDist, CurDist: double;
  ProcessOptions: TProcessOptions;
begin
  // Need locations
  Locations := GetItem('mLocations');
  if not Assigned(Locations) then
    exit;

  // If the model is not supplied, try to get it from the data
  FTripModel := GetCalculationModel(AModel);

  // All Routes
  AllRoutes := InitAllRoutes;
  AnUdbHandle := TmUdbDataHndl.Create(1, TripModel, false);
  AnUdbHandle.FTripList := Self;
  ProcessOptions := TProcessOptions.Create;
  RoutePointList := TList<TLocation>.Create;
  try
    // Add begin
    TmLocations(Locations).GetSegmentPoints(1, RoutePointList);
    ALocation := RoutePointList[0];
    AnUdbHandle.Add(TUdbDir.Create(TripModel, ALocation, RouteCnt));

    TotalTime := 0;
    TotalDist := 0;
    PrevUdbDir := nil;
    // Add intermediates
    for Index := 0 to SubClasses.Count -1 do
    begin
      GpxRptNode := TXmlVSNode(SubClasses.Objects[Index]);
      Coords.FromAttributes(GpxRptNode.AttributeList);
      AnUdbDir := TUdbDir.Create(TripModel,
                                 Copy(SubClasses[Index], 5),    // SubClass to use in UdbDir
                                 Copy(SubClasses[Index], 1, 2), // RoadClass
                                 Coords.Lat, Coords.Lon);
      AnUdbHandle.Add(AnUdbDir);

      if (Assigned(PrevUdbDir)) then
      begin
        // Distance and time from Previous UdbDir
        CurDist := CoordDistance(PrevUdbDir.Coords, AnUdbDir.Coords, TDistanceUnit.duKm);
        PrevUdbDir.ComputeTime(CurDist);

        // Totals for the UdbHdandle
        TotalTime := TotalTime + PrevUdbDir.FValue.Time;
        TotalDist := TotalDist + (CurDist * 1000);
      end;

      PrevUdbDir := AnUdbDir;
    end;

    // Add End
    TmLocations(Locations).GetSegmentPoints(2, RoutePointList);
    ALocation := RoutePointList[0];
    AnUdbHandle.Add(TUdbDir.Create(TripModel, ALocation, RouteCnt));

    // Update Time and Dist
    AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.TimeOffset, TotalTime);
    AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.DistOffset, Round(TotalDist));

    // Add to AllRoutes
    TmAllRoutes(AllRoutes).AddUdbHandle(AnUdbHandle);

    // Update Dist and Time
    UpdateDistAndTime(TotalDist, TotalTime);

    // Mark as TripTrack
    SetPreserveTrackToRoute(RtePts);

    // Recreate RoutePreferences
    case TripModel of
      TTripModel.XT2,
      TTripModel.Tread2:
        SetRoutePrefs_XT2_Tread2(TmLocations(Locations), ProcessOptions);
    end;

  finally
    RoutePointList.Free;
    ProcessOptions.Free;
  end;
end;

procedure TTripList.SaveCalculated(const AModel: TTripModel;
                                   const RtePts: TObject);
var
  AllRoutes: TBaseItem;
  Index: integer;
  ViaCount, RoutePtCount: integer;
  RoutePointList: TList<TLocation>;
  ALocation: TLocation;
  Locations: TBaseItem;
  AnUdbHandle: TmUdbDataHndl;
  AnUdbDir, PrevUdbDir: TUdbDir;
  FirstRtePt, ScanRtePt, ScanGpxxRptNode: TXmlVSNode;
  CMapSegRoad: string;
  PrevCoords, Coords: TCoords;
  TotalDist, UdbDist, CurDist: double;
  TotalTime, UdbTime: cardinal;
  ProcessOptions: TProcessOptions;
begin
  TotalTime := 0;
  TotalDist := 0;
  // If the model is not supplied, try to get it from the data
  FTripModel := GetCalculationModel(AModel);

  // All Routes
  AllRoutes := InitAllRoutes;

  // Need locations
  Locations := GetItem('mLocations');
  if not Assigned(Locations) then
    exit;

  // Count from already assigned Locations
  ViaCount := TmLocations(Locations).ViaPointCount;

  // At least a begin and end point needed. So at least 1 UdbHandle
  if (ViaCount < 2) then
    exit;

  ProcessOptions := TProcessOptions.Create;
  FirstRtePt := TXmlVSNodeList(RtePts).FirstChild;
  RoutePointList := TList<TLocation>.Create;
  try
    for Index := 1 to ViaCount -1 do
    begin
      AnUdbHandle := TmUdbDataHndl.Create(1, TripModel, ProcessOptions.TripOption = TTripOption.ttCalc);
      AnUdbHandle.FTripList := Self;
      UdbDist := 0;
      UdbTime := 0;
      ScanRtePt := FirstRtePt;

      // Add udb's for all Via and Shaping found in Locations.
      // Add Subclasses from <gpxx:rpt>. Will be named RoadClass MapSegment RoadId
      TmLocations(Locations).GetSegmentPoints(Index, RoutePointList);
      GenShapeBitmap(RoutePointList.Count -2, @AnUdbHandle.FValue.Unknown3[AnUdbHandle.ShapeOffset]);
      for RoutePtCount := 0 to RoutePointList.Count -2 do
      begin
        ALocation := RoutePointList[RoutePtCount];
        AnUdbHandle.Add(TUdbDir.Create(TripModel, ALocation, RouteCnt));

        // Lookup the location <rtept> in the GPX
        while (ScanRtePt <> nil) do
        begin
          if (SameText(ALocation.LocationTmName.AsString, FindSubNodeValue(ScanRtePt, 'name'))) then
            break;
          ScanRtePt := ScanRtePt.NextSibling;
        end;
        if (ScanRtePt = nil) then // Should not occur.
        begin
          BreakPoint;
          continue;
        end;
        FirstRtePt := ScanRtePt; // restart next search in GPX here

        // Init PrevCoords
        ScanGpxxRptNode := GetFirstExtensionsNode(ScanRtePt);
        if (ScanGpxxRptNode = nil) then // Should not occur.
        begin
          BreakPoint;
          continue;
        end;
        PrevCoords.FromAttributes(ScanGpxxRptNode.AttributeList);

        CurDist := 0;
        PrevUdbDir := nil;
        while (ScanGpxxRptNode <> nil) do
        begin
          Coords.FromAttributes(ScanGpxxRptNode.AttributeList);

          // Create a UdbDir, for every <SubClass> node.
          CMapSegRoad := FindSubNodeValue(ScanGpxxRptNode, 'gpxx:Subclass');
          if (CMapSegRoad <> '') then
          begin
            AnUdbDir := TUdbDir.Create(TripModel,
                                       Copy(CMapSegRoad, 5),    // SubClass to use in UdbDir
                                       Copy(CMapSegRoad, 1, 2), // RoadClass
                                       Coords.Lat, Coords.Lon);
            AnUdbHandle.Add(AnUdbDir);

            // Compute the time based on the RoadClass of the previous UdbDir
            if (Assigned(PrevUdbDir)) then
            begin
              PrevUdbDir.ComputeTime(CurDist);

              // Totals for the UdbHdandle
              UdbTime := UdbTime + PrevUdbDir.FValue.Time;
              UdbDist := UdbDist + (CurDist * 1000);
            end;

            CurDist := 0;
            PrevUdbDir := AnUdbDir;
          end;

          CurDist := CurDist + CoordDistance(PrevCoords, Coords, TDistanceUnit.duKm);
          PrevCoords := Coords;
          ScanGpxxRptNode := ScanGpxxRptNode.NextSibling;
        end;
      end;

      // Add end route point. Of this segment
      ALocation := RoutePointList[RoutePointList.Count -1];
      AnUdbHandle.Add(TUdbDir.Create(TripModel, ALocation, RouteCnt));

      TotalDist := TotalDist + UdbDist; // Totals for the Trip
      TotalTime := TotalTime + UdbTime;
      AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.TimeOffset, UdbTime);
      AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.DistOffset, Round(UdbDist));

      // Add to Allroutes
      TmAllRoutes(AllRoutes).AddUdbHandle(AnUdbHandle);
    end;

    if (ProcessOptions.TripOption in [TTripOption.ttTripTrackLoc, TTripOption.ttTripTrackLocPrefs]) then
      SetPreserveTrackToRoute(RtePts);

    // Update Dist and Time
    UpdateDistAndTime(TotalDist, TotalTime);

    // Recreate RoutePreferences
    case TripModel of
      TTripModel.XT2,
      TTripModel.Tread2:
        SetRoutePrefs_XT2_Tread2(TmLocations(Locations), ProcessOptions);
    end;

  finally
    RoutePointList.Free;
    ProcessOptions.Free;
  end;
end;

function TTripList.FirstUdbDataHndle: TmUdbDataHndl;
var
  AllRoutes: TmAllRoutes;
begin
  // Try to get allroutes
  AllRoutes := TmAllRoutes(GetItem('mAllRoutes'));
  if not Assigned(AllRoutes) or
     not Assigned(AllRoutes.Items) or
     (AllRoutes.Items.Count = 0) then
    exit(nil);

  result := AllRoutes.Items[0];
end;

// Get the model by checking the magic number, or the size.
// This function reports the model even if not calculated.
function TTripList.GetTripModel: TTripModel;
var
  AnUdbHandle: TmUdbDataHndl;
begin
  // Default Unknown
  result := TTripModel.Unknown;

  // Try to get first TmUdbDataHndl
  AnUdbHandle := FirstUdbDataHndle;
  if not Assigned(AnUdbHandle) then
    exit;

  // Get model from UdnHandle
  result := AnUdbHandle.GetModel;

  // 595 and drive5 share the same UDBHandle size, but the drive 51 has no mIsRoundTrip
  if (result = TTripModel.Zumo595) and
     (GetItem('mIsRoundTrip') = nil) then
    result := TTripModel.Drive51;
end;

// Is the TripList calculated? Need UDBdir > 0
function TTripList.GetIsCalculated: boolean;
var
  AnUdbHandle: TmUdbDataHndl;
begin
  result := false;

  AnUdbHandle := FirstUdbDataHndle;
  if not Assigned(AnUdbHandle) then
    exit;
  if (AnUdbHandle.FValue.UDbDirCount = 0) then
    exit;

  result := true;
end;

function TTripList.GetCalculationModel(AModel: TTripModel): TTripModel;
begin
  result := AModel;
  if (result < Low(TTripModel)) or
     (result > Pred(High(TTripModel))) then
    result := GetTripModel;
end;

procedure TTripList.GetModel;
begin
  FTripModel := GetTripModel;
  FIsUcs4 := Ucs4Model[FTripModel];
  FModelDescription := GetEnumName(TypeInfo(TTripModel), Ord(FTripModel));
end;

function TTripList.InitAllRoutes: TBaseItem;
var
  AnUdbHandle:  TmUdbDataHndl;
begin
  result := GetItem('mAllRoutes');
  if not Assigned(result) then
  begin
    result := TmAllRoutes.Create;
    Add(result);
  end
  else
  begin
    // Clear all UdbHandles from AllRoutes
    for AnUdbHandle in TmAllRoutes(result).Items do
      FreeAndNil(AnUdbHandle);
    TmAllRoutes(result).Items.Clear;
  end;
end;

// The order of the items may be changed. EG Move mTripName after Theader does also work.
procedure TTripList.CreateTemplate_XT(const TripName, CalculationMode, TransportMode: string);
begin
  AddHeader(THeader.Create);
  Add(TmPreserveTrackToRoute.Create);
  Add(TmParentTripId.Create(0));
  Add(TmDayNumber.Create);
  Add(TmTripDate.Create);
  Add(TmIsDisplayable.Create);
  Add(TmAvoidancesChanged.Create);
  Add(TmIsRoundTrip.Create);
  Add(TmParentTripName.Create(TripName));
  Add(TmOptimized.Create);
  Add(TmTotalTripTime.Create);
  Add(TmImported.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode)));
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmTotalTripDistance.Create);
  Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
  Add(TmLocations.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmVersionNumber.Create);
  Add(TmAllRoutes.Create);
  Add(TmTripName.Create(TripName));

  // Create Dummy AllRoutes, to force recalc on the XT. Just an entry for every Via.
  ForceRecalc(TTripModel.XT, 2);
end;

procedure TTripList.CreateTemplate_XT2(const TripName, CalculationMode, TransportMode: string);
var
  TmpStream: TMemoryStream;
  Uid: TGuid;
  ProcessOptions: TProcessOptions;
begin
  ProcessOptions := TProcessOptions.Create;
  TmpStream := TMemoryStream.Create;
  try
    AddHeader(THeader.Create);
    PrepStream(TmpStream, [$0000]);
    Add(TRawDataItem.Create).InitFromStream('mGreatRidesInfoMap', TmpStream.Size, dtRaw, TmpStream);
    Add(TmAvoidancesChangedTimeAtSave.Create(ProcessOptions.AvoidancesChangedTimeAtSave));
    TmpStream.Position := 0;
    Add(TmTrackToRouteInfoMap.Create).InitFromStream('mTrackToRouteInfoMap', TmpStream.Size, dtRaw, TmpStream);
    Add(TmIsDisplayable.Create);
    Add(TBooleanItem.Create('mIsDeviceRoute', true));
    Add(TmDayNumber.Create);
    Add(TmTripDate.Create);
    Add(TmOptimized.Create);
    Add(TmTotalTripTime.Create);
    Add(TmTripName.Create(TripName));
    Add(TStringItem.Create('mVehicleProfileGuid', ProcessOptions.VehicleProfileGuid));
    Add(TmParentTripId.Create(0));
    Add(TmIsRoundTrip.Create);
    Add(TStringItem.Create('mVehicleProfileName', ProcessOptions.VehicleProfileName));
    Add(TmAvoidancesChanged.Create);
    Add(TmParentTripName.Create(TripName));
    Add(TByteItem.Create('mVehicleProfileTruckType', StrToInt(ProcessOptions.VehicleProfileTruckType) ));
    Add(TCardinalItem.Create('mVehicleProfileHash', StrToInt(ProcessOptions.VehicleProfileHash)));
    Add(TmRoutePreferences.Create);
    Add(TmImported.Create);
    Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));

    CheckHRGuid(CreateGUID(Uid));
    Add(TStringItem.Create('mExploreUuid',
                            ReplaceAll(LowerCase(GuidToString(Uid)), ['{','}'], ['',''], [rfReplaceAll])));
    Add(TmVersionNumber.Create(4, $10));
    Add(TmRoutePreferencesAdventurousHillsAndCurves.Create);
    Add(TmTotalTripDistance.Create);
    Add(TCardinalItem.Create('mVehicleId', StrToInt(ProcessOptions.VehicleId)));
    Add(TmRoutePreferencesAdventurousScenicRoads.Create);
    Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
    Add(TmRoutePreferencesAdventurousPopularPaths.Create);
    Add(TmPartOfSplitRoute.Create);
    Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode)));
    Add(TBooleanItem.Create('mShowLastStopAsShapingPoint', false));
    Add(TmRoutePreferencesAdventurousMode.Create);
    Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
    Add(TmLocations.Create);

    // Create dummy AllRoutes, and complete RoutePreferences
    ForceRecalc(TTripModel.XT2, 2);
  finally
    TmpStream.Free;
    ProcessOptions.Free;
  end;
end;

procedure TTripList.CreateTemplate_Tread2(const TripName, CalculationMode, TransportMode: string);
var
  TmpStream: TMemoryStream;
  Uid: TGuid;
  ProcessOptions: TProcessOptions;
begin
  ProcessOptions := TProcessOptions.Create;
  TmpStream := TMemoryStream.Create;
  try
    AddHeader(THeader.Create);
    PrepStream(TmpStream, [$0000]);
    Add(TRawDataItem.Create).InitFromStream('mGreatRidesInfoMap', TmpStream.Size, dtRaw, TmpStream);
    Add(TmAvoidancesChangedTimeAtSave.Create(ProcessOptions.AvoidancesChangedTimeAtSave));
    TmpStream.Position := 0;
    Add(TmTrackToRouteInfoMap.Create).InitFromStream('mTrackToRouteInfoMap', TmpStream.Size, dtRaw, TmpStream);
    Add(TmIsDisplayable.Create);

    CheckHRGuid(CreateGUID(Uid));
    Add(TStringItem.Create('mExploreUuid',
                            ReplaceAll(LowerCase(GuidToString(Uid)), ['{','}'], ['',''], [rfReplaceAll])));
    Add(TmOptimized.Create);
    Add(TmDayNumber.Create);
    Add(TmParentTripName.Create(TripName));
    Add(TBooleanItem.Create('mShowLastStopAsShapingPoint', false));
    Add(TmTotalTripDistance.Create);
    Add(TmTotalTripTime.Create);
    Add(TByteItem.Create('mVehicleProfileTruckType', StrToInt(ProcessOptions.VehicleProfileTruckType) ));
    Add(TmAvoidancesChanged.Create);
    Add(TStringItem.Create('mVehicleProfileName', ProcessOptions.VehicleProfileName));
    Add(TCardinalItem.Create('mVehicleProfileHash', StrToInt(ProcessOptions.VehicleProfileHash)));
    Add(TmParentTripId.Create(0));
    Add(TCardinalItem.Create('mVehicleId', StrToInt(ProcessOptions.VehicleId)));
    Add(TmTripDate.Create);
    Add(TmImported.Create);
    Add(TmRoutePreferencesAdventurousHillsAndCurves.Create);
    Add(TmIsRoundTrip.Create);
    Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode)));
    Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
    Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
    Add(TmLocations.Create);
    Add(TmPartOfSplitRoute.Create);
    Add(TmRoutePreferencesAdventurousPopularPaths.Create);
    Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
    Add(TmRoutePreferences.Create);
    Add(TBooleanItem.Create('mIsDeviceRoute', true));
    Add(TmRoutePreferencesAdventurousScenicRoads.Create);
    Add(TStringItem.Create('mVehicleProfileGuid', Tread2_VehicleProfileGuid));
    Add(TmTripName.Create(TripName));
    Add(TmRoutePreferencesAdventurousMode.Create);
    Add(TmVersionNumber.Create(4, $10));

    // Create dummy AllRoutes, and complete RoutePreferences
    ForceRecalc(TTripModel.Tread2, 2);
  finally
    TmpStream.Free;
    ProcessOptions.Free;
  end;
end;

// The order of the items may be changed. EG Move mTripName after Theader does also work.
procedure TTripList.CreateTemplate_Zumo595(const TripName, CalculationMode, TransportMode: string);
begin
  AddHeader(THeader.Create);
  Add(TmTotalTripDistance.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode)));
  Add(TmAllRoutes.Create);
  Add(TmTripDate.Create);
  Add(TmParentTripId.Create(0));
  Add(TmImported.Create);
  Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
  Add(TmLocations.Create);
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmPartOfSplitRoute.Create);
  Add(TmTotalTripTime.Create);
  Add(TmDayNumber.Create);
  Add(TmTripName.Create(TripName));
  Add(TmAvoidancesChanged.Create);
  Add(TmParentTripName.Create(TripName));
  Add(TmVersionNumber.Create(1, 6));
  Add(TmIsRoundTrip.Create);
  Add(TmOptimized.Create);

  // Create Dummy AllRoutes, to force recalc on the Zumo. Just an entry for every Via.
  ForceRecalc(TTripModel.Zumo595, 2);
end;

procedure TTripList.CreateTemplate_Drive51(const TripName, CalculationMode, TransportMode: string);
begin
  AddHeader(THeader.Create);
  Add(TmOptimized.Create);
  Add(TmParentTripId.Create(0));
  Add(TmDayNumber.Create);
  Add(TmTripDate.Create);
  Add(TmParentTripName.Create(TripName));
  Add(TmTotalTripTime.Create);
  Add(TmImported.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmAvoidancesChanged.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode)));
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
  Add(TmLocations.Create);
  Add(TmTotalTripDistance.Create);
  Add(TmVersionNumber.Create(1, 6));
  Add(TmAllRoutes.Create);
  Add(TmTripName.Create(TripName));

  // Create Dummy AllRoutes, to force recalc on the Zumo. Just an entry for every Via.
  ForceRecalc(TTripModel.Drive51, 2);
end;


procedure TTripList.CreateTemplate_Zumo3x0(const TripName, CalculationMode, TransportMode: string);
begin
  AddHeader(THeader.Create);
  Add(TmAllRoutes.Create);
  Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
  Add(TmLocations.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode), 5, dt3x0RoutePref));
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmTripName.Create(TripName));
  Add(TmVersionNumber.Create(1, 3));

  // Create Dummy AllRoutes, to force recalc on the Zumo. Just an entry for every Via.
  ForceRecalc(TTripModel.Zumo3x0, 2);
end;

procedure TTripList.CreateTemplate(const AModel: TTripModel;
                                   const TripName: string;
                                   const CalculationMode: string = '';
                                   const TransportMode: string = '');
begin
  Clear;

  case AModel of
    TTripModel.XT2:
      CreateTemplate_XT2(TripName, CalculationMode, TransportMode);
    TTripModel.Tread2:
      CreateTemplate_Tread2(TripName, CalculationMode, TransportMode);
    TTripModel.Zumo595:
      CreateTemplate_Zumo595(TripName, CalculationMode, TransportMode);
    TTripModel.Drive51:
      CreateTemplate_Drive51(TripName, CalculationMode, TransportMode);
    TTripModel.Zumo3x0:
      CreateTemplate_Zumo3x0(TripName, CalculationMode, TransportMode);
    else
      CreateTemplate_XT(TripName, CalculationMode, TransportMode);
  end;
end;

procedure TTripList.SaveAsGPX(const GPXFile: string; IncludeTrack: boolean = true);
var
  Xml: TXmlVSDocument;
  XMLRoot: TXmlVSNode;
  Rte, RtePt, Trk, TrkSeg, TrkPt: TXmlVSNode;
  Locations: TmLocations;
  AllRoutes: TmAllRoutes;
  AnUdbHandle: TmUdbDataHndl;
  ANUdbDir: TUdbDir;
  Location, ANItem: TBaseItem;
  ViaPointType, PointName, Lat, Lon, Address: string;
begin
  XML := TXmlVSDocument.Create;
  try
    XMLRoot := InitGarminGpx(XML);
    Rte := XMLRoot.AddChild('rte');
    Rte.AddChild('name').NodeValue := TBaseDataItem(GetItem('mTripName')).AsString;

    Locations := TmLocations(GetItem('mLocations'));
    if not (Assigned(Locations)) then
      exit;

    for Location in Locations.Locations do
    begin
      if (Location is TLocation) then
      begin
        RtePt := Rte.AddChild('rtept');
        // Point Type
        ViaPointType := 'trp:ShapingPoint';
        if (TLocation(Location).IsViaPoint) then
          ViaPointType := 'trp:ViaPoint';
        // Point Name
        PointName := '';
        ANItem := TLocation(Location).LocationTmName;
        if (Assigned(ANItem)) then
           PointName := TmName(ANItem).AsString;
        // Lat Lon
        Lat := '';
        Lon := '';
        ANItem := TLocation(Location).LocationTmScPosn;
        if (Assigned(ANItem)) then
        begin
          Lon := TmScPosn(ANItem).MapCoords;
          Lat := Trim(NextField(Lon, ','));
          Lon := Trim(Lon);
        end;
        // Address
        Address := '';
        ANItem := TLocation(Location).LocationTmAddress;
        if (Assigned(ANItem)) then
          Address := TmAddress(ANItem).AsString;

        // Write to XML
        RtePt.Attributes['lat'] := Lat;
        RtePt.Attributes['lon'] := Lon;
        RtePt.AddChild('name').NodeValue := PointName;
        RtePt.AddChild('cmt').NodeValue := Address;
        RtePt.AddChild('desc').NodeValue := Address;
        RtePt.AddChild('extensions').AddChild(ViaPointType);
      end;
    end;

    if IncludeTrack then
    begin
      AllRoutes := TmAllRoutes(GetItem('mAllRoutes'));
      if Assigned(AllRoutes) then
      begin
        Trk := XMLRoot.AddChild('trk');
        Trk.AddChild('name').NodeValue := TBaseDataItem(GetItem('mTripName')).AsString;
        for AnUdbHandle in AllRoutes.Items do
        begin
          TrkSeg := Trk.AddChild('trkseg');
          for ANUdbDir in AnUdbHandle.Items do
          begin
            TrkPt := TrkSeg.AddChild('trkpt');
            Lon := ANUdbDir.MapCoords;
            Lat := Trim(NextField(Lon, ','));
            Lon := Trim(Lon);
            TrkPt.Attributes['lat'] := Lat;
            TrkPt.Attributes['lon'] := Lon;
          end;
        end;
      end;
    end;

    XML.SaveToFile(GPXFile);
  finally
    Xml.Free;
  end;
end;


initialization

begin
  FloatFormatSettings.ThousandSeparator := ',';
  FloatFormatSettings.DecimalSeparator := '.';

  System.Classes.RegisterClasses([
  // TByteItem
     TmDayNumber, TmRoutePreference, TmTransportationMode,
  // TBooleanitem
    TmPreserveTrackToRoute, TmIsDisplayable, TmAvoidancesChanged, TmIsRoundTrip, TmOptimized,
    TmImported, TmPartOfSplitRoute, TmIsDFSPoint, TmisTravelapseDestination, TmPreserveTrackToRoute,
  // TCardinalItem
    TmParentTripId, TmTripDate, TmTotalTripTime, TmAttr, TmDuration, TmArrival, TmShapingRadius,
  // TSingleItem,
    TmTotalTripDistance,
  // Specialized Type 08
    TmVersionNumber, TmScPosn,
  // TStringItem
    TmParentTripName, TmFileName, TmTripName, TmAddress, TmName,
  // TmLocations
    TmLocations,
  // TmAllRoutes
    TmAllRoutes,
  // XT2
    TmExploreUuid,
    TmAvoidancesChangedTimeAtSave,
    TmRoutePreferences,
    TmRoutePreferencesAdventurousHillsAndCurves,
    TmRoutePreferencesAdventurousScenicRoads,
    TmRoutePreferencesAdventurousMode,
    TmRoutePreferencesAdventurousPopularPaths,
    TmTrackToRouteInfoMap,
  // Zumo340
    TmShaping, TmPhoneNumber
    ]);
end;

end.
