﻿unit unitTripObjects;
{.$DEFINE DEBUG_POS}
{.$DEFINE DEBUG_ENUMS}
interface

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Winapi.Windows;

const
  XT_Name                           = 'zūmo XT';
  XT2_Name                          = 'zūmo XT2';
  XT2_VehicleProfileGuid            = 'dbcac367-42c5-4d01-17aa-ecfe025f2d1c';
  XT2_VehicleProfileHash            = '135656608';
  XT2_VehicleId                     = '1';
  XT2_VehicleProfileTruckType       = '7';
  XT2_AvoidancesChangedTimeAtSave   = '';
  XT2_VehicleProfileName            = 'z' + #0363 + 'mo Motorcycle';

type
  TEditMode         = (emNone, emEdit, emPickList, emButton);
  TZumoModel        = (XT, XT2, Unknown);
  TRoutePreference  = (rmFasterTime       = $00,
                       rmShorterDistance  = $01,
                       rmDirect           = $04,
                       rmCurvyRoads       = $07,
                       rmHills            = $1a,
                       rmNoShape          = $58,
                       rmScenic           = $be,
                       rmPopular          = $ef);
  TTransportMode    = (tmAutoMotive       = 1,
                       tmMotorcycling     = 9,
                       tmOffRoad          = 10);
  TRoutePoint       = (rpVia              = 0,
                       rpShaping          = 1,
                       rpShapingXT2       = 2);
  TUdbDirStatus     = (udsUnchecked, udsRoutePointNOK, udsRoadNOK, UdsRoadOKCoordsNOK, udsCoordsNOK);

{ Elementary data types }
const
  dtByte          = 1;
  dtCardinal      = 3;
  dtSingle        = 4;
  dtBoolean       = 7;
  dtVersion       = 8;
  dtPosn          = 8;
  dtLctnPref      = 10;
  dtUdbPref       = 10;
  dtUdbHandle     = 11;
  dtString        = 14;
  dtList          = 128;

  biInitiator: AnsiChar = #$09;

  BooleanMap : array[0..1] of TIdentMapEntry =          ( (Value: Ord(False);               Name: 'False'),
                                                          (Value: Ord(True);                Name: 'True')
                                                        );

  RoutePreferenceMap : array[0..7] of TIdentMapEntry =  ( (Value: Ord(rmFasterTime);        Name: 'FasterTime'),
                                                          (Value: Ord(rmShorterDistance);   Name: 'ShorterDistance'),
                                                          (Value: Ord(rmDirect);            Name: 'Direct'),
                                                          (Value: Ord(rmCurvyRoads);        Name: 'CurvyRoads'),
                                                          (Value: Ord(rmHills);             Name: 'Hills'),
                                                          (Value: Ord(rmPopular);           Name: 'Popular'),
                                                          (Value: Ord(rmNoShape);           Name: 'No Shape'),
                                                          (Value: Ord(rmScenic);            Name: 'Scenic'));

  TransportModeMap : array[0..2] of TIdentMapEntry =    ( (Value: Ord(tmAutoMotive);        Name: 'AutoMotive'),
                                                          (Value: Ord(tmMotorcycling);      Name: 'Motorcycling'),
                                                          (Value: Ord(tmOffRoad);           Name: 'OffRoad')
                                                        );

  RoutePointMap : array[0..2] of TIdentMapEntry =       ( (Value: Ord(rpVia);               Name: 'Via point'),
                                                          (Value: Ord(rpShaping);           Name: 'Shaping point'),
                                                          (Value: Ord(rpShapingXT2);        Name: 'Shaping point XT(2)')
                                                        );
  UdbDirTurn  = 'Turn';

type

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
    procedure Calculate(AStream: TMemoryStream); virtual;
    procedure WritePrefix(AStream: TMemoryStream); virtual;
    procedure WriteValue(AStream: TMemoryStream); virtual;
    procedure WriteTerminator(AStream: TMemoryStream); virtual;
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
    procedure WritePrefix(AStream: TMemoryStream); override;
    function GetName: string; virtual;
    function GetValue: string; virtual;
    procedure SetValue(NewValue: string); virtual;
    function GetLenValue: Cardinal; virtual;
    function GetOffSetLenValue: integer;
    function GetOffSetDataType: integer;
    function GetOffSetValue: integer;
    function GetMapCoords: string; virtual;
    procedure SetMapCoords(ACoords: string); virtual;
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
    property MapCoords: string read GetMapCoords write SetMapCoords;
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
    Minor:            Cardinal;
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
    ScnSize:          Cardinal;
    Unknown1:         Cardinal;
    Lat:              integer;
    Lon:              integer;
  end;
  TmScPosn = class(TBaseDataItem)
  private
    FValue:            TPosnValue;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    function GetEditMode: TEditMode; override;
    function GetMapCoords: string; override;
    procedure SetMapCoords(ACoords: string); override;
  public
    constructor Create(ALat, ALon: double; AUnknown1: Cardinal); reintroduce;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    destructor Destroy; override;
    property Unknown1: Cardinal read FValue.Unknown1;
  end;

  // Type 14
  TStringItem = class(TBaseDataItem)
  private
    FByteSize:         Word;
    FValue:            UCS4String;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    function GetEditMode: TEditMode; override;
    procedure SetValue(NewValue: string); override;
    // Only allocates space
    constructor Create(AName: ShortString; Chars: Word); reintroduce; overload;
  public
    // Create from WideString
    constructor Create(AName: ShortString; AValue: WideString); reintroduce; overload;
    // Create from UCS4String
    constructor Create(AName: ShortString; AValue: UCS4String); reintroduce; overload;
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
    procedure WriteValue(AStream: TMemoryStream); override;
  public
    constructor Create(AValue: boolean = false);
  end;

  TmRoutePreference = class(TByteItem)
  private
    function GetValue: string; override;
    procedure SetValue(AValue: string); override;
    function GetEditMode: TEditMode; override;
    function GetPickList: string; override;
  public
    constructor Create(AValue: TRoutePreference = rmFasterTime);
    class function RoutePreference(AValue: string): TRoutePreference;
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

{*** XT2 ***}
{*** RoutePreferences ***}
  TBaseRoutePreferences = class(TRawDataItem)
  private
    function StandardPrefs: boolean; virtual;
    function GetCount: Cardinal;
  public
    function GetValue: string; override;
    function GetRoutePrefs: string;
    property Count: Cardinal read GetCount;
  end;

  TmRoutePreferences = class(TBaseRoutePreferences)
  private
    function StandardPrefs: boolean; override;
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
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
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;
  TmRoutePreferencesAdventurousPopularPaths = class(TBaseRoutePreferences)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
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
    Value:            TLocationValue;
    FItems: TItemList;
    procedure WriteValue(AStream: TMemoryStream); override;
  public
    constructor Create(ADataType: byte = dtLctnPref); reintroduce;
    destructor Destroy; override;
    procedure Add(ANitem: TBaseItem);
    function LocationTmName: TmName;
    function LocationTmScPosn: TmScPosn;
    property LocationValue: TLocationValue read Value;
    property LocationItems: TItemList read FItems;
  end;

  TmLocations = class(TBaseDataItem)
  private
    FItemCount: Cardinal;
    FItemList: TItemList;
    FLocation: TLocation;
    procedure Calculate(AStream: TMemoryStream); override;
    procedure WritePrefix(AStream: TMemoryStream); override;
    procedure WriteValue(AStream: TMemoryStream); override;
  public
    constructor Create; reintroduce;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    destructor Destroy; override;
    procedure Clear;
    procedure AddLocatIon(ALocation: TLocation);
    function Add(ANItem: TBaseItem): TBaseItem;
    property Locations: TItemList read FItemList;
    property LocationCount: Cardinal read FItemCount;
  end;

{*** All routes ***}
const
  TurnMagic: array[0..3] of byte   = ($47, $4E, $00, $00);

type
  TSubClass = packed record
    MapSegment:       Cardinal;
    RoadId:           Cardinal;
    PointType:        byte;
    Direction:        byte;
    Unknown1:         array[0..5] of byte;
  end;
  TUdbDirValue = packed record
    SubClass:         TSubClass;
    Lat:              integer;
    Lon:              integer;
    Unknown1:         array[0..5] of Cardinal;
    Name:             array[0..120] of UCS4Char;
    procedure SwapCardinals;
  end;
  TUdbDir = class(TBaseItem)
  private
    FValue:            TUdbDirValue;
    FUdbDirStatus:     TUdbDirStatus;
    constructor Create(AName: WideString;
                       ALat: double = 0;
                       ALon: double = 0;
                       APointType: byte = $03;
                       ADirection: byte = $24); reintroduce;

    procedure WritePrefix(AStream: TMemoryStream); override;
    procedure WriteValue(AStream: TMemoryStream); override;
    procedure WriteTerminator(AStream: TMemoryStream); override;
    function SubLength: Cardinal; override;
    function GetName: string;
    function GetMapCoords: string;
    function GetMapSegRoad: string;
    function GetMapSegRoadExclBit: string;
    function GetPointType: string;
    function GetDirection: string;
  public
    function Lat: Double;
    function Lon: Double;
    function IsTurn: boolean;
    property DisplayName: string read GetName;
    property UdbDirValue: TUdbDirValue read FValue;
    property MapCoords: string read GetMapCoords;
    property MapSegRoad: string read GetMapSegRoad;
    property MapSegRoadExclBit: string read GetMapSegRoadExclBit;
    property PointType: string read GetPointType;
    property Direction: string read GetDirection;
    property Status: TUdbDirStatus read FUdbDirStatus write FUdbDirStatus;
  end;
  TUdbDirList = Tlist<TUdbDir>;

  TUdbPrefValue = packed record
    Unknown1:         Cardinal;
    PrefixSize:       Cardinal;
    DataType:         byte;
    PrefId:           Cardinal;
    procedure SwapCardinals;
  end;

const Unknown3Size:     array[TZumoModel] of integer = (1288, 1448, 1288);      // Default unknown to XT size
      CalculationMagic: array[TZumoModel] of Cardinal = ($0538feff, $05d8feff, $00000000);

type
  TUdbHandleValue = packed record
    UdbHandleSize:    Cardinal;
    CalcStatus:       Cardinal; // Only value seen for XT: 0538feff, for XT2 05d8feff. Set it to Zeroes, to force recalculation
    Unknown2:         array[0..149] of byte;
    UDbDirCount:      WORD;
    Unknown3:         array of byte;
    procedure SwapCardinals;
    procedure AllocUnknown3(AModel: TZumoModel = TZumoModel.XT); overload;
    procedure AllocUnknown3(ASize: cardinal); overload;

  end;
  TmUdbDataHndl = class(TBaseDataItem)
  private
    FUdbHandleId:      Cardinal;
    FUdbPrefValue:     TUdbPrefValue;
    FValue:            TUdbHandleValue;
    FUdbDirList:       TUdbDirList;
    FSubLength: Cardinal;
    function ComputeUnknown3Size: Cardinal;
    procedure WritePrefix(AStream: TMemoryStream); override;
    procedure WriteValue(AStream: TMemoryStream); override;
    procedure WriteTerminator(AStream: TMemoryStream); override;
  public
    constructor Create(AHandleId: Cardinal; AModel: TZumoModel = TZumoModel.XT); reintroduce;
    destructor Destroy; override;
    procedure Add(AnUdbDir: TUdbDir);
    property HandleId: Cardinal read FUdbHandleId;
    property PrefValue: TUdbPrefValue read FUdbPrefValue;
    property UdbHandleValue: TUdbHandleValue read FValue;
    property Items: TUdbDirList read FUdbDirList;
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
    procedure Calculate(AStream: TMemoryStream); override;
    procedure WritePrefix(AStream: TMemoryStream); override;
    procedure WriteValue(AStream: TMemoryStream); override;
    procedure WriteTerminator(AStream: TMemoryStream); override;
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
    procedure ResetCalculation;
    procedure Calculate(AStream: TMemoryStream);
    function GetZumoModel: TZumoModel;
    procedure CreateTemplate_XT(const TripName: string);
    procedure CreateTemplate_XT2(const TripName: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AddHeader(AHeader: THeader);
    function Add(ANItem: TBaseItem): TBaseItem;
    procedure SaveToStream(AStream: TMemoryStream);
    procedure SaveToFile(AFile: string);
    function LoadFromStream(AStream: TBufferedFileStream): boolean;
    function LoadFromFile(AFile: string): boolean;
    function GetValue(AKey: ShortString): string;
    function GetItem(AKey: ShortString): TBaseItem;
    procedure SetItem(AKey: ShortString; ABaseItem: TBaseItem);
    function GetRoutePointCount: integer;
    function GetRoutePoint(RoutePointId: integer): Tlocation;
    function OSMRoutePoint(RoutePointId: integer): TOSMRoutePoint;
    function GetArrival: TmArrival;
    procedure CreateOSMPoints(const OutStringList: TStringList; const HTMLColor: string);
    procedure ForceRecalc(const AModel: TZumoModel = TZumoModel.Unknown; ViaPointCount: integer = 0);
    procedure CreateTemplate(const AModel: TZumoModel; TripName: string);
    procedure SaveAsGPX(const GPXFile: string);
    property Header: THeader read FHeader;
    property ItemList: TItemList read FItemList;
    property ZumoModel: TZumoModel read GetZumoModel;
  end;

implementation

uses
  System.Math, System.DateUtils, System.StrUtils, System.TypInfo,
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

procedure WriteSwap32(AStream: TMemoryStream; I: Cardinal); overload;
var
  Tmp: Cardinal;
begin
  Tmp := Swap32(I);
  AStream.Write(Tmp, SizeOf(Tmp));
end;

function CoordAsDec(CoordInt: integer): double;
begin
  result := SimpleRoundTo(CoordInt / 4294967296 * 360, -10);
end;

function CoordAsInt(CoordDec: double): integer;
begin
  result := Round(SimpleRoundTo(CoordDec, -10) * 4294967296 / 360);
end;

function CoordsAsPosn(const LatLon: string): TPosnValue;
var
  Lat, Lon: string;
begin
  FillChar(result, SizeOf(result), 0);
  result.ScnSize := Swap32(SizeOf(result.Unknown1) + Sizeof(result.Lat) + SizeOf(result.Lon));
  ParseLatLon(LatLon, Lat, Lon);
  result.Lat := CoordAsInt(UnitStringUtils.CoordAsDec(Lat));
  result.Lon := CoordAsInt(UnitStringUtils.CoordAsDec(Lon));
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

function UCS4ArrayToString(AnUCS4Array: array of UCS4Char; Length: integer): string;
var
  AUCS4String: UCS4String;
begin
  SetLength(AUCS4String, Length);
  Move(AnUCS4Array[0], AUCS4String[0], Length * SizeOf(UCS4Char));
  result := UCS4StringToUnicodeString(AUCS4String);
  SetLength(result, StrLen(PChar(result)));  // Drop trailing zeroes
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
function CreateBaseItemByName(AKeyName: ShortString;
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
        end;
      dtCardinal:
        begin;
          AStream.Read(ACardinal, SizeOf(ACardinal));
          result := TCardinalItem.Create(AKeyName, Swap32(ACardinal));
        end;
      dtSingle:
        begin;
          AStream.Read(ASingle, SizeOf(ASingle));
          result := TSingleItem.Create(AKeyName, Swap32(ASingle));
        end;
      dtBoolean:
        begin;
          AStream.Read(ABoolean, SizeOf(ABoolean));
          result := TBooleanItem.Create(AKeyName, ABoolean);
        end;
      dtString:
        begin;
          result := TStringItem.Create(AKeyName);
          TStringItem(result).InitFromStream(AKeyName, AValueLen, dtString, AStream);
        end;
      else
      begin
        // Create a Raw data item. Only holds bytes
        result := TRawDataItem.Create;
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
    Writeln(TBaseDataItem(self).Name, ' ', self.StartPos, '=', self.SubLength);
  end;
{$ENDIF}
end;

function TBaseItem.SubLength: Cardinal;
begin
  result := FEndPos - FStartPos;
end;

procedure TBaseItem.WritePrefix(AStream: TMemoryStream);
begin
  if not FCalculated then
    FStartPos := AStream.Position;
end;

procedure TBaseItem.WriteValue(AStream: TMemoryStream);
begin
  {}
end;

procedure TBaseItem.Write(AStream: TMemoryStream);
begin
  WritePrefix(Astream);
  WriteValue(AStream);
  WriteTerminator(Astream);
  FCalculated := true;
end;

procedure TBaseItem.WriteTerminator(AStream: TMemoryStream);
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

procedure TBaseDataItem.WritePrefix(AStream: TMemoryStream);
begin
  inherited WritePrefix(AStream);
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
{}
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

function TBaseDataItem.GetMapCoords: string;
begin
  result := '';
end;

procedure TBaseDataItem.SetMapCoords(ACoords: string);
begin
  {}
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
  inherited WriteValue(AStream);
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
  inherited WriteValue(AStream);
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
  FValue := Swap32(AValue);
end;

procedure TSingleItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  AStream.Read(FValue, SizeOf(FValue));
end;

destructor TSingleItem.Destroy;
begin
  inherited Destroy;
end;

procedure TSingleItem.WriteValue(AStream: TMemoryStream);
begin
  inherited WriteValue(AStream);
  AStream.Write(FValue, SizeOf(FValue));
end;

function TSingleItem.GetValue: string;
begin
  result := Format('%f', [Swap32(FValue)]);
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
  inherited WriteValue(AStream);
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
  inherited Create('mVersionNumber', SizeOf(FValue), dtVersion);
  FValue.Major := Swap32(AMajor);
  FValue.Minor := AMinor;
end;

procedure TmVersionNumber.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  AStream.Read(FValue.Major, SizeOf(FValue.Major));
  AStream.Read(FValue.Minor, SizeOf(FValue.Minor));
end;

destructor TmVersionNumber.Destroy;
begin
  inherited Destroy;
end;

procedure TmVersionNumber.WriteValue(AStream: TMemoryStream);
begin
  inherited WriteValue(AStream);
  AStream.Write(FValue, SizeOf(FValue));
end;

function TmVersionNumber.GetValue: string;
begin
  result := Format('0x%s / 0x%s', [IntToHex(FValue.Major, 8), IntToHex(FValue.Minor, 8)]);
end;

{*** ScPosn ***}
constructor TmScPosn.Create(ALat, ALon: double; AUnknown1: Cardinal);
begin
  inherited Create('mScPosn', Sizeof(FValue), dtPosn);
  FValue.ScnSize := Swap32(SizeOf(FValue.Unknown1) + Sizeof(FValue.Lat) + SizeOf(FValue.Lon));
  FValue.Unknown1 := AUnknown1;
  FValue.Lat := (CoordAsInt(ALat));
  FValue.Lon := (CoordAsInt(ALon));
end;

procedure TmScPosn.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  AStream.Read(FValue.ScnSize, SizeOf(FValue.ScnSize));
  AStream.Read(FValue.Unknown1, SizeOf(FValue.Unknown1));
  AStream.Read(FValue.Lat, SizeOf(FValue.Lat));
  AStream.Read(FValue.Lon, SizeOf(FValue.Lon));
end;

destructor TmScPosn.Destroy;
begin
  inherited Destroy;
end;

procedure TmScPosn.WriteValue(AStream: TMemoryStream);
begin
  inherited WriteValue(AStream);
  AStream.Write(FValue, SizeOf(FValue));
end;

function TmScPosn.GetEditMode: TEditMode;
begin
  result := TEditMode.emButton;
end;

function TmScPosn.GetValue: string;
begin
  result := Format(Format('Unknown: 0x%%s, Lat: %s, Lon: %s', [Coord_Decimals, Coord_Decimals]),
                  [IntToHex(FValue.Unknown1, 8),
                   CoordAsDec(FValue.Lat),
                   CoordAsDec(FValue.Lon)], FloatFormatSettings);
end;

function TmScPosn.GetMapCoords: string;
begin
  result := Format(Format('%s, %s', [Coord_Decimals, Coord_Decimals]),
                   [CoordAsDec(FValue.Lat), CoordAsDec(FValue.Lon)], FloatFormatSettings);
end;

procedure TmScPosn.SetMapCoords(ACoords: string);
begin
  FValue := CoordsAsPosn(ACoords);
end;

{*** String ***}
constructor TStringItem.Create(AName: ShortString; Chars: Word);
begin
  inherited Create(AName,
                   SizeOf(Chars) + (Chars * SizeOf(UCS4Char)),
                   dtString);

  FByteSize := Swap(Chars * SizeOf(UCS4Char));
end;

constructor TStringItem.Create(AName: ShortString; AValue: WideString);
begin
  Create(AName, Length(AValue));

  FValue := WideStringToUCS4String(AValue);
  ToPrivate(FValue);
end;

constructor TStringItem.Create(AName: ShortString; AValue: UCS4String);
begin
  //Note AValue has a null terminator. Doesn't count
  Create(AName, High(AValue));

  FValue := Copy(AValue, 0, Length(AValue));
end;

procedure TStringItem.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
var
  Chars: integer;
  ByteLength: word;
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  // Length of UCS4 string (swapped)
  AStream.Read(FByteSize, SizeOf(FByteSize));
  // Compute Sizes
  ByteLength := Swap(FByteSize);
  Chars := (ByteLength div SizeOf(UCS4Char)) +1; // Null terminator
  // Read from stream
  SetLength(FValue, Chars);
  AStream.Read(FValue[0], ByteLength);
end;

destructor TStringItem.Destroy;
begin
  inherited Destroy;
end;

procedure TStringItem.WriteValue(AStream: TMemoryStream);
begin
  inherited WriteValue(AStream);
  AStream.Write(FByteSize, SizeOf(FByteSize));
  AStream.Write(FValue[0], High(FValue) * SizeOf(UCS4Char));  // Dont write last
end;

function TStringItem.GetValue: string;
begin
  result := UCS4StringToUnicodeString(FromPrivate(FValue));
end;

function TStringItem.GetEditMode: TEditMode;
begin
  result := TEditMode.emEdit;
end;

procedure TStringItem.SetValue(NewValue: string);
begin
  FValue := UnicodeStringToUCS4String(NewValue);
  ToPrivate(FValue);
  FByteSize := Swap(Length(NewValue) * SizeOf(UCS4Char));
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

procedure TmImported.WriteValue(AStream: TMemoryStream);
begin
  inherited WriteValue(AStream);
end;

constructor TmRoutePreference.Create(AValue: TRoutePreference = rmFasterTime);
begin
  inherited Create('mRoutePreference', Ord(AValue));
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
  for Index := 0 to High(RoutePreferenceMap) do
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
  result := Format('%f Km.', [Swap32(FValue) / 1000]);
  result := result + Format(' (%f Meters)', [Swap32(FValue)]);
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

{ TBaseRoutePreferences }
function TBaseRoutePreferences.StandardPrefs: boolean;
begin
  result := false;
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

function TBaseRoutePreferences.GetRoutePrefs: string;
var
  Stream: TBytesStream;
  SegmentNr: Cardinal;
  RoutePref: Word;
  RoutePreferenceByte: byte;
  RoutePreferenceString: string;
begin
  result := '';
  Stream := TBytesStream.Create(FBytes);
  try
    Stream.Seek(SizeOf(Cardinal), TSeekOrigin.soBeginning);
    for SegmentNr := 1 to Count do
    begin
      Stream.Read(RoutePref, SizeOf(RoutePref));
      RoutePref := Swap(RoutePref);
      RoutePreferenceByte := RoutePref;// and $0f;
      if (not StandardPrefs) or
         (not IntToIdent(RoutePreferenceByte, RoutePreferenceString, RoutePreferenceMap)) then
        RoutePreferenceString := 'TBD';
      result := result + Format('%s (0x%s)%s', [RoutePreferenceString, IntTohex(RoutePref, 4), #10]);
    end;
  finally
    Stream.Free;
  end;
end;

constructor TmRoutePreferences.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create('mRoutePreferences', 0 , $80);
end;

function TmRoutePreferences.StandardPrefs: boolean;
begin
  result := true;
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

constructor TmRoutePreferencesAdventurousPopularPaths.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create('mRoutePreferencesAdventurousPopularPaths', 0 , $80);
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
  inherited WriteValue(AStream);
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

constructor TLocation.Create(ADataType: byte = dtLctnPref);
begin
  inherited Create;
  Value.Id := 'LCTN';
  Value.DataType := ADataType;
  Value.Size := SizeOf(Value) - SizeOf(Value.Id) - SizeOf(Value.Size);
  FItems := TItemList.Create;
end;

destructor TLocation.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TLocation.Add(ANitem: TBaseItem);
begin
  Inc(Value.Count);
  Value.Size := Value.Size + ANitem.SubLength;
  FItems.Add(ANitem);
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

procedure TLocation.WriteValue(AStream: TMemoryStream);
begin
  inherited WriteValue(AStream);

  Value.SwapCardinals; // Swap Cardinals
  AStream.Write(Value, SizeOf(Value));
  Value.SwapCardinals; // Swap Cardinals back
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

    AddLocatIon(TLocation.Create(ALocationValue.DataType));
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
      ABaseItem := CreateBaseItemByName(KeyName, ValueLen - SizeOf(Initiator), DataType, AStream);
      Add(ABaseItem)
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

procedure TmLocations.AddLocatIon(ALocation: TLocation);
begin
  FLocation := ALocation;
  FItemList.Add(ALocation);
  FItemCount := FItemCount +1;
end;

function TmLocations.Add(ANItem: TBaseItem): TBaseItem;
begin
  FItemList.Add(ANItem);
  FLocation.Add(ANItem);
  result := ANItem;
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
      CurLocation.Value.Size := SizeOf(CurLocation.Value) - SizeOf(CurLocation.Value.Id) - SizeOf(CurLocation.Value.Size);
      continue;
    end;
    CurLocation.Value.Size := CurLocation.Value.Size + ANitem.SubLength;
  end;
end;

procedure TmLocations.WritePrefix(AStream: TMemoryStream);
begin
  inherited WritePrefix(AStream);
end;

procedure TmLocations.WriteValue(AStream: TMemoryStream);
var
  ANitem: TBaseItem;
begin
  inherited WriteValue(AStream);
  WriteSwap32(AStream, FItemCount);
  for ANitem in FItemList do
    ANitem.Write(AStream);
end;

{*** UdbDir ***}
procedure TUdbDirValue.SwapCardinals;
begin
  Lat := Swap32(Lat);
  Lon := Swap32(Lon);
end;

constructor TUdbDir.Create(AName: WideString;
                           ALat: double = 0;
                           ALon: double = 0;
                           APointType: byte = $03;
                           ADirection: byte = $24);
begin
  inherited Create;
  FillChar(FValue, SizeOf(FValue), 0);
  WideStringToUCS4Array(AName, FValue.Name); // Copy Name
  FValue.Lat := Swap32(CoordAsInt(ALat));
  FValue.Lon := Swap32(CoordAsInt(ALon));
  FValue.SubClass.PointType := APointType;
  FValue.SubClass.Direction := ADirection;
  FUdbDirStatus := TUdbDirStatus.udsUnchecked;
end;

procedure TUdbDir.WritePrefix(AStream: TMemoryStream);
begin
  inherited WritePrefix(AStream);
end;

procedure TUdbDir.WriteValue(AStream: TMemoryStream);
begin
  inherited WriteValue(AStream);
  FValue.SwapCardinals;
  AStream.Write(FValue, SizeOf(FValue));
  FValue.SwapCardinals;
end;

procedure TUdbDir.WriteTerminator(AStream: TMemoryStream);
begin
  inherited WriteTerminator(AStream);
end;

function TUdbDir.SubLength: Cardinal;
begin
  result := SizeOf(FValue);
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
    result := UCS4ArrayToString(FValue.Name, Length(FValue.Name));
end;

function TUdbDir.GetMapCoords: string;
begin
  result := Format(Format('%s, %s', [Coord_Decimals, Coord_Decimals]),
                  [Lat, Lon], FloatFormatSettings);
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

function TUdbDir.IsTurn: boolean;
begin
  result := CompareMem(@TurnMagic[0], @FValue.Name[1], SizeOf(TurnMagic));
end;

{*** UdbPref *** }
procedure TUdbPrefValue.SwapCardinals;
begin
  PrefixSize := Swap32(PrefixSize);
  PrefId := Swap32(PrefId);
end;

{*** UdbHandle ***}
procedure TudbHandleValue.SwapCardinals;
begin
  UdbHandleSize := Swap32(UdbHandleSize);
end;

procedure TudbHandleValue.AllocUnknown3(AModel: TZumoModel = TZumoModel.XT);
begin
  SetLength(Self.Unknown3, Unknown3Size[AModel]);
end;

procedure TudbHandleValue.AllocUnknown3(ASize: cardinal);
begin
  SetLength(Self.Unknown3, ASize);
end;

constructor TmUdbDataHndl.Create(AHandleId: Cardinal; AModel: TZumoModel = TZumoModel.XT);
begin
  inherited Create('mUdbDataHndl', SizeOf(FValue), dtUdbHandle); // Will get Length later, Via Calculate
  FUdbHandleId := AHandleId; // Only value seen = 1
  FillChar(FValue, SizeOf(FValue), 0);
// Leaving it to Zeroes, to force recalculation
//  FValue.CalcStatus := CalculationMagic[AModel];
  FValue.AllocUnknown3(AModel);
  FSubLength := 0;
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
  FUdbDirList.Add(AnUdbDir);
end;

function TmUdbDataHndl.ComputeUnknown3Size: Cardinal;
begin
  result := // SizeOf UDbHandle
            Swap32(FValue.UdbHandleSize) -
            // SizeOf fixed part (excluding Unknown3)
            (SizeOf(FValue) - SizeOf(FValue.Unknown3) - SizeOf(FValue.CalcStatus)) -
            // SizeOf UdbDir's
            (FValue.UDbDirCount * SizeOf(TUdbDirValue));

(* Bug fixes for enabling Win64
SizeOf(FValue.Unknown3) = 4 for 32 bits, 8 for 64 bits
SizeOf(TUdbDir) = 4 for 32 bits, 8 for 64 bits. But should be the size of the record.
Because Unnoticed until now, because this function gets called when a trip is not calculated and UDbDirCount=0.

  result := // SizeOf UDbHandle
            Swap32(FValue.UdbHandleSize) -
            // SizeOf fixed part (excluding Unknown3)
            (SizeOf(FValue) - SizeOf(FValue.UdbHandleSize) - Sizeof(FValue.CalcStatus)) -
            // SizeOf UdbDir's
            (FValue.UDbDirCount * SizeOf(TUdbDir));
*)
end;

procedure TmUdbDataHndl.WritePrefix(AStream: TMemoryStream);
begin
  FillChar(FUdbPrefValue, Sizeof(FUdbPrefValue), 0);
  FUdbPrefValue.PrefixSize := SubLength + SizeOf(FUdbPrefValue.DataType) + SizeOf(FUdbPrefValue.PrefId);
  FUdbPrefValue.DataType := dtUdbPref;
  FUdbPrefValue.PrefId := FUdbHandleId;

  FUdbPrefValue.SwapCardinals;
  AStream.Write(FUdbPrefValue, SizeOf(FUdbPrefValue));
  FUdbPrefValue.SwapCardinals;

  inherited WriteTerminator(AStream);

  inherited WritePrefix(AStream);
end;

procedure TmUdbDataHndl.WriteValue(AStream: TMemoryStream);
var
  AnItem: TUdbDir;
begin
  inherited WriteValue(AStream);
  FValue.UDbDirCount := FUdbDirList.Count;
  FValue.SwapCardinals;
  AStream.Write(FValue.UdbHandleSize, SizeOf(FValue.UdbHandleSize));
  AStream.Write(FValue.CalcStatus, SizeOf(FValue.CalcStatus));
  AStream.Write(FValue.Unknown2[0], SizeOf(FValue.Unknown2));
  AStream.Write(FValue.UDbDirCount, SizeOf(FValue.UDbDirCount));
  AStream.Write(FValue.Unknown3[0], Length(FValue.Unknown3));
  FValue.SwapCardinals;
  for AnItem in FUdbDirList do
    ANitem.Write(AStream);
end;

procedure TmUdbDataHndl.WriteTerminator(AStream: TMemoryStream);
begin
  if not FCalculated then
  begin
    FEndPos := AStream.Position;
    FLenValue := SubLength - SizeOf(FLenName) - FLenName - SizeOf(FLenValue) - SizeOf(FDataType) - SizeOf(FInitiator);
    FValue.UdbHandleSize := FLenValue -4;
  end;
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

procedure TmAllRoutes.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
var
  UdbHandleCnt: integer;
  AnUdbHandle: TmUdbDataHndl;

  BytesRead: integer;
  KeyLen: Cardinal;
  KeyName: ShortString;
  ValueLen: Cardinal;
  DataType: Byte;
  Initiator: AnsiChar;

  UdbDirCnt: integer;
  AnUdbDir: TUdbDir;
  AModel: TZumoModel;

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
    AnUdbHandle.FUdbHandleId := Swap32(AnUdbHandle.FUdbPrefValue.PrefId);

    BytesRead := ReadKeyVAlues(AStream,
                               Initiator,
                               KeyLen,
                               KeyName,
                               ValueLen,
                               DataType);
    if (BytesRead = 0) then
      break;

    AStream.Read(AnUdbHandle.FValue.UdbHandleSize, SizeOf(AnUdbHandle.FValue.UdbHandleSize));
    AStream.Read(AnUdbHandle.FValue.CalcStatus, SizeOf(AnUdbHandle.FValue.CalcStatus));
    AStream.Read(AnUdbHandle.FValue.Unknown2[0], SizeOf(AnUdbHandle.FValue.Unknown2));
    AStream.Read(AnUdbHandle.FValue.UDbDirCount, SizeOf(AnUdbHandle.FValue.UDbDirCount));

    AnUdbHandle.FValue.AllocUnknown3; // Default to XT
    for AModel := Low(TZumoModel) to High(TZumoModel) do  // Future use
    begin
      if (AnUdbHandle.FValue.CalcStatus = CalculationMagic[AModel]) then
      begin
        if (AModel = TZumoModel.Unknown) then
          AnUdbHandle.FValue.AllocUnknown3(AnUdbHandle.ComputeUnknown3Size)
        else
          AnUdbHandle.FValue.AllocUnknown3(AModel);
        break;
      end;
    end;

    AStream.Read(AnUdbHandle.FValue.Unknown3[0], Length(AnUdbHandle.FValue.Unknown3));
    AnUdbHandle.FValue.SwapCardinals;

    for UdbDirCnt := 0 to AnUdbHandle.FValue.UDbDirCount -1 do
    begin
      AnUdbDir := TUdbDir.Create('');
      AStream.Read(AnUdbDir.FValue, SizeOf(AnUdbDir.FValue));
      AnUdbDir.FValue.SwapCardinals;
      AnUdbHandle.Add(AnUdbDir);
    end;

    AddUdbHandle(AnUdbHandle);
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
  FUdBList.Add(AnUdbHandle);
end;

procedure TmAllRoutes.Calculate(AStream: TMemoryStream);
begin
  inherited Calculate(AStream);

  FValue.UdbHandleCount := FUdBList.Count;
  FLenValue := SubLength - SizeOf(FLenName) - FLenName - SizeOf(FLenValue) - SizeOf(FDataType) - SizeOf(FInitiator);
end;

procedure TmAllRoutes.WritePrefix(AStream: TMemoryStream);
begin
  inherited WritePrefix(AStream);
end;

procedure TmAllRoutes.WriteTerminator(AStream: TMemoryStream);
begin
  inherited WriteTerminator(AStream);
end;

procedure TmAllRoutes.WriteValue(AStream: TMemoryStream);
var
  ANitem: TmUdbDataHndl;
begin
  inherited WriteValue(AStream);

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
  for ANItem in ItemList do
  begin
    if (ANItem is TBaseItem) then
      ANitem.FCalculated := false
    else if (ANItem is TmLocations) then
    begin
      for ALocation in TmLocations(ANItem).Locations do
        ALocation.FCalculated := false;
    end
    else if (ANItem is TmAllRoutes) then
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

  FSubLength := 6; //We need to add 6, but can figure out why.
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
  AStream := TMemoryStream.Create;
  try
    SaveToStream(AStream);
    AStream.SaveToFile(AFile);
  finally
    AStream.Free;
  end;
end;

function TTripList.LoadFromStream(AStream: TBufferedFileStream): boolean;
var
  AHeader: THeaderValue;
  BytesRead: integer;
  KeyLen: Cardinal;
  KeyName: ShortString;
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
    ABaseItem := CreateBaseItemByName(KeyName, ValueLen - SizeOf(Initiator), DataType, AStream);
    Add(ABaseItem);

  end;
  result := true;
end;

function TTripList.LoadFromFile(AFile: string): boolean;
var
  AStream: TBufferedFileStream;
begin
  AStream := TBufferedFileStream.Create(AFile, fmOpenRead);
  try
    result := LoadFromStream(AStream);
    if not result then
      raise Exception.Create(Format('Not a valid trip file: %s', [AFile]));
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
      result.MapCoords := TmScPosn(AnItem).GetMapCoords;
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
  TrackPoints: integer;
  LayerId: integer;
  TripName: TmTripName;
  AllRoutes: TmAllRoutes;
  UdbDataHndl: TmUdbDataHndl;
  UdbDir: TUdbDir;
  Locations: TmLocations;
  Location: TBaseItem;
  ANItem: TBaseItem;
  IsCalculated: boolean;
begin
  OutStringList.Clear;
  TripName := TmTripName(GetItem('mTripName'));
  if (not Assigned(TripName)) then
    exit;

  TrackPoints := 0;
  AllRoutes := TmAllRoutes(GetItem('mAllRoutes'));
  if (Assigned(AllRoutes)) then
  begin
    for UdbDataHndl in AllRoutes.Items do
    begin
      for UdbDir in UdbDataHndl.Items do
      begin
        OutStringList.Add(Format('AddTrkPoint(%d,%.7g,%.7g);', [TrackPoints, UdbDir.Lat, UdbDir.Lon], FloatFormatSettings ) );
        Inc(TrackPoints);
      end;
    end;
  end;
  IsCalculated := (TrackPoints > 0);

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
            Coords := TmScPosn(ANItem).GetMapCoords;
        end;

        if (IsCalculated = false) then
        begin
          OutStringList.Add(Format('AddTrkPoint(%d,%s);', [TrackPoints, Coords], FloatFormatSettings ) );
          Inc(TrackPoints);
        end;

        OutStringList.Add(Format('AddRoutePoint(%d, "%s", "%s", %s, "%s");',
                                 [LayerId,
                                  LayerName,
                                  RoutePointName,
                                  Coords,
                                  Color]));
      end;
    end;
    OutStringList.Add(Format('CreateTrack("%s", ''%s'');', [EscapeDQuote(TripName.AsString), HTMLColor]));

  end;
end;

procedure TTripList.ForceRecalc(const AModel: TZumoModel = TZumoModel.Unknown; ViaPointCount: integer = 0);
var
  CalcModel: TZumoModel;
  AllRoutes: TBaseItem;
  Index: integer;
  ViaCount: integer;
  Locations: TBaseItem;
  RoutePreferences: array of WORD;
  TmpStream: TMemoryStream;

  Location: TBaseItem;
  AnUdbHandle: TmUdbDataHndl;

  procedure SetRoutePref(AKey: ShortString);
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

begin
  // If the model is not supplied, try to get it from the data
  CalcModel := AModel;
  if (CalcModel = TZumoModel.Unknown) then
    CalcModel := GetZumoModel;

  AllRoutes := GetItem('mAllRoutes');
  if not Assigned(AllRoutes) then
  begin
    AllRoutes := TmAllRoutes.Create;
    Add(AllRoutes);
  end
  else
  begin
    // Clear all UdbHandles from AllRoutes
    for AnUdbHandle in TmAllRoutes(AllRoutes).Items do
      FreeAndNil(AnUdbHandle);
    TmAllRoutes(AllRoutes).Items.Clear;
  end;

  // Count Via points
  ViaCount := ViaPointCount;
  if (ViaCount = 0) then  // Count from already assigned Locations
  begin
    Locations := GetItem('mLocations');
    if not Assigned(Locations) then
      exit;

    for Location in TmLocations(Locations).Locations do
    begin
      if (Location is TmAttr) and
         (TmAttr(Location).AsRoutePoint = TRoutePoint.rpVia) then
        Inc(ViaCount);
    end;
  end;
  // At least a begin and end point needed. So at least 1 UdbHandle
  ViaCount := Max(ViaCount, 2);

  TmpStream := TMemoryStream.Create;
  try
    // Create Dummy UdbHandles and add to allroutes. Just one entry for every Via.
    // The XT(2) recalculates all.
    for Index := 1 to ViaCount -1 do
    begin
      AnUdbHandle := TmUdbDataHndl.Create(1, CalcModel);
      TmAllRoutes(AllRoutes).AddUdbHandle(AnUdbHandle);
    end;

    // The RoutePreferences need to be resized? For XT2.
    if (CalcModel = TZumoModel.XT2) then
    begin
      SetLength(RoutePreferences, ViaCount -1);
      for Index := 0 to High(RoutePreferences) do
        RoutePreferences[Index] := Swap($0100);
      PrepStream(TmpStream, ViaCount -1, RoutePreferences);

      SetRoutePref('mRoutePreferences');
      SetRoutePref('mRoutePreferencesAdventurousHillsAndCurves');
      SetRoutePref('mRoutePreferencesAdventurousScenicRoads');
      SetRoutePref('mRoutePreferencesAdventurousPopularPaths');
      SetRoutePref('mRoutePreferencesAdventurousMode');
    end;
  finally
    TmpStream.Free;
  end;
end;

function TTripList.GetZumoModel: TZumoModel;
var
  AllRoutes: TmAllRoutes;
  AnUdbHandle: TmUdbDataHndl;
  AModel: TZumoModel;
begin
  // Default XT
  result := TZumoModel.XT;

  // Try to get allroutes
  AllRoutes := TmAllRoutes(GetItem('mAllRoutes'));
  if not Assigned(AllRoutes) or
     not Assigned(AllRoutes.Items) or
     (AllRoutes.Items.Count = 0) then
    exit;

  // Is the size of the first Unknown3 known to be from an XT or XT2?
  AnUdbHandle := AllRoutes.Items[0];
  for AModel := Low(TZumoModel) to High(TZumoModel) do  // Future use
  begin
    if (Length(AnUdbHandle.FValue.Unknown3) = Unknown3Size[AModel]) then
      exit(AModel);
  end;
end;

procedure TTripList.CreateTemplate_XT(const TripName: string);
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
  Add(TmRoutePreference.Create(TRoutePreference.rmFasterTime));
  Add(TmTransportationMode.Create(TTransportMode.tmMotorcycling));
  Add(TmTotalTripDistance.Create);
  Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
  Add(TmLocations.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmVersionNumber.Create);
  Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
  Add(TmTripName.Create(TripName));

  // Create Dummy AllRoutes, to force recalc on the XT. Just an entry for every Via.
  ForceRecalc(TZumoModel.XT, 2);
end;

procedure TTripList.CreateTemplate_XT2(const TripName: string);
var
  TmpStream: TMemoryStream;
  Uid: TGuid;
  GpxProcessOptions: TProcessOptions;
begin
  GpxProcessOptions := TProcessOptions.Create;
  TmpStream := TMemoryStream.Create;
  try
    AddHeader(THeader.Create);
    PrepStream(TmpStream, [$0000]);
    Add(TRawDataItem.Create).InitFromStream('mGreatRidesInfoMap', TmpStream.Size, $0c, TmpStream);
    Add(TmAvoidancesChangedTimeAtSave.Create(GpxProcessOptions.AvoidancesChangedTimeAtSave));
    TmpStream.Position := 0;
    Add(TRawDataItem.Create).InitFromStream('mTrackToRouteInfoMap', TmpStream.Size, $0c, TmpStream);
    Add(TmIsDisplayable.Create);
    Add(TBooleanItem.Create('mIsDeviceRoute', true));
    Add(TmDayNumber.Create);
    Add(TmTripDate.Create);
    Add(TmOptimized.Create);
    Add(TmTotalTripTime.Create);
    Add(TmTripName.Create(TripName));
    Add(TStringItem.Create('mVehicleProfileGuid', GpxProcessOptions.VehicleProfileGuid));
    Add(TmParentTripId.Create(0));
    Add(TmIsRoundTrip.Create);
    Add(TStringItem.Create('mVehicleProfileName', GpxProcessOptions.VehicleProfileName));
    Add(TmAvoidancesChanged.Create);
    Add(TmParentTripName.Create(TripName));
    Add(TByteItem.Create('mVehicleProfileTruckType', StrToInt(GpxProcessOptions.VehicleProfileTruckType) ));
    Add(TCardinalItem.Create('mVehicleProfileHash', StrToInt(GpxProcessOptions.VehicleProfileHash)));
    Add(TmRoutePreferences.Create);
    Add(TmImported.Create);
    Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
    if (GpxProcessOptions.ExploreUuid <> '') then
      Add(TStringItem.Create('mExploreUuid', GpxProcessOptions.ExploreUuid))
    else
    begin
      CheckHRGuid(CreateGUID(Uid));
      Add(TStringItem.Create('mExploreUuid',
                              ReplaceAll(LowerCase(GuidToString(Uid)), ['{','}'], ['',''], [rfReplaceAll])));
    end;
    Add(TmVersionNumber.Create(4, $10));
    Add(TmRoutePreferencesAdventurousHillsAndCurves.Create);
    Add(TmTotalTripDistance.Create);
    Add(TByteItem.Create('mVehicleId', 1));
    Add(TmRoutePreferencesAdventurousScenicRoads.Create);
    Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
    Add(TmRoutePreferencesAdventurousPopularPaths.Create);
    Add(TmPartOfSplitRoute.Create);
    Add(TmRoutePreference.Create(TRoutePreference.rmFasterTime));
    Add(TBooleanItem.Create('mShowLastStopAsShapingPoint', false));
    Add(TmRoutePreferencesAdventurousMode.Create);
    Add(TmTransportationMode.Create(TTransportMode.tmMotorcycling));
    Add(TmLocations.Create);

    // Create dummy AllRoutes, and complete RoutePreferences
    ForceRecalc(TZumoModel.XT2, 2);
  finally
    TmpStream.Free;
    GpxProcessOptions.Free;
  end;
end;

procedure TTripList.CreateTemplate(const AModel: TZumoModel; TripName: string);
begin
  Clear;
  case AModel of
    TZumoModel.XT:
      CreateTemplate_XT(TripName);
    TZumoModel.XT2:
      CreateTemplate_XT2(TripName);
    else
      CreateTemplate_XT(TripName);
  end;
end;

procedure TTripList.SaveAsGPX(const GPXFile: string);
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
        ViaPointType := 'trp:ShapingPoint';
        PointName := '';
        Lat := '';
        Lon := '';
        Address := '';
        for ANItem in TLocation(Location).LocationItems do
        begin

          if (ANItem is TmAttr) then
          begin
            if (Pos('Via', TmAttr(ANItem).AsString) = 1) then
              ViaPointType := 'trp:ViaPoint'
            else
              ViaPointType := 'trp:ShapingPoint';
          end;

          if (ANItem is TmName) then
            PointName := TmName(ANItem).AsString;

          if (ANItem is TmScPosn) then
          begin
            Lon := TmScPosn(ANItem).MapCoords;
            Lat := Trim(NextField(Lon, ','));
            Lon := Trim(Lon);
          end;

          if (ANItem is TmAddress) then
            Address := TmAddress(ANItem).AsString;

        end;
        RtePt.Attributes['lat'] := Lat;
        RtePt.Attributes['lon'] := Lon;
        RtePt.AddChild('name').NodeValue := PointName;
        RtePt.AddChild('cmt').NodeValue := Address;
        RtePt.AddChild('desc').NodeValue := Address;
        RtePt.AddChild('extensions').AddChild(ViaPointType);
      end;
    end;

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
    TmRoutePreferencesAdventurousPopularPaths
    ]);
end;

end.
