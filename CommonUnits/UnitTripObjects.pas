unit UnitTripObjects;
{.$DEFINE DEBUG_POS}

interface

uses
  System.SysUtils, System.Variants, System.Classes, System.Generics.Collections,
  Winapi.Windows,
  UnitVerySimpleXml, UnitTripOverview, UnitTripDefs, UnitGpxDefs;

type

  TTripList = class;

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
    function GetItemEditMode: TItemEditMode; virtual;
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); virtual;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); virtual;
    procedure SetTripList(const ATripList: TTripList);
    class function GetKey: ShortString;
    property SelStart: Cardinal read FStartPos;
    property SelEnd: Cardinal read FEndPos;
    property ItemEditMode: TItemEditMode read GetItemEditMode;
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
    function GetItemEditMode: TItemEditMode; override;
    procedure SetByte(AByte: byte); virtual;
    procedure SetValue(NewValue: string); override;
  public
    constructor Create(AName: ShortString; AValue: byte); reintroduce;
    destructor Destroy; override;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    property AsByte: byte read FValue write SetByte;
  end;

  // Type 03
  TCardinalItem = class(TBaseDataItem)
  private
    FValue:            Cardinal;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
    function GetItemEditMode: TItemEditMode; override;
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
    function GetItemEditMode: TItemEditMode; override;
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
    function GetItemEditMode: TItemEditMode; override;
    procedure SetValue(NewValue: string); override;
  public
    constructor Create(AName: ShortString; AValue: boolean); reintroduce;
    destructor Destroy; override;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    property AsBoolean: boolean read Value write Value;
  end;

  // Type 08 (Version)
  TVersionValue = packed record
    Size:             Cardinal;
    case boolean of
    false:
      (VersionB:      byte);
    true:
      (VersionC:      Cardinal);
  end;
  TmVersionNumber = class(TBaseDataItem)
  private
    FValue:           TVersionValue;
    procedure WriteValue(AStream: TMemoryStream); override;
    function GetValue: string; override;
  public
    constructor Create(ATripVersion: TTripVersion); reintroduce;
    destructor Destroy; override;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
  end;

  // Type 08 (ScPosn)
  TPosnValue = packed record
    procedure SwapCardinals;
    case ScnSize: Cardinal of
    PosnSmall:                    // Zumo 340, 350 and 590
      (
        Lat_8:                    integer;
        Lon_8:                    integer;
      );
    PosnNorm:                     // XT, XT2, 595, drive 51, drive 66
      (
        Unknown1:                 Cardinal;
        Lat:                      integer;
        Lon:                      integer;
      );
    PosnLarge:                    // XT3, Tread 2,
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
    function GetItemEditMode: TItemEditMode; override;
    function GetOffSetValue: integer; override;
    function GetLenValue: Cardinal; override;
    function GetLat: double;
    function GetLon: double;
    function GetMapCoords: string;
    function CoordsAsPosnValue(const LatLon: string): TPosnValue;
    procedure SetMapCoords(ACoords: string);
  public
    constructor Create(ALat, ALon: double; ASize: Cardinal); reintroduce;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    destructor Destroy; override;
    property Unknown1: Cardinal read FValue.Unknown1;
    property MapCoords: string read GetMapCoords write SetMapCoords;
    property Lat: double read GetLat;
    property Lon: double read GetLon;
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
    function GetItemEditMode: TItemEditMode; override;
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
    function GetItemEditMode: TItemEditMode; override;
    function GetValue: string; override;
    function GetAsUnixDateTime: Cardinal;
    procedure SetAsUnixDateTime(AValue: Cardinal);
  public
    constructor Create(AName: ShortString; AValue: TDateTime = 0);
    property AsUnixDateTime: Cardinal read GetAsUnixDateTime write SetAsUnixDateTime;
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

  TmIsDeviceRoute = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = true);
  end;

  TmExploreUuid = class(TStringItem)
  public
    constructor Create(AValue: string);
  end;

  TmVehicleProfileTruckType = class(TByteItem)
    constructor Create(AValue: byte);
  end;

  TmVehicleProfileGuid = class(TStringItem)
    constructor Create(AValue: string);
  end;

  TmVehicleProfileName = class(TStringItem)
    constructor Create(AValue: string);
  end;

  TmVehicleProfileHash = class(TCardinalItem)
    constructor Create(AValue: Cardinal);
  end;

  TmVehicleId = class(TCardinalItem)
    constructor Create(AValue: Cardinal);
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

  TmShowLastStopAsShapingPoint = class(TBooleanItem)
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
    procedure SetByte(AByte: byte); override;
    procedure SetValue(AValue: string); override;
    function GetItemEditMode: TItemEditMode; override;
    function GetPickList: string; override;
  public
    constructor Create(AValue: TRoutePreference = rmFasterTime; ADataType: byte = dtByte);
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    class function RoutePreference(AValue: string; AModel: TTripmodel): TRoutePreference;
    class function AdvLevel(AValue: string): TAdvlevel;
    class function ModelEditMode(AModel: TTripmodel): TItemEditMode;
    class function ModelPickList(AModel: TTripmodel): string;
  end;

  TmTransportationMode = class(TByteItem)
  private
    function GetValue: string; override;
    procedure SetValue(AValue: string); override;
    function GetItemEditMode: TItemEditMode; override;
    function GetPickList: string; override;
  public
    constructor Create(AValue: TTransportMode = tmMotorcycling);
    class function TransPortMethod(AValue: string): TTransportMode;
    class function ModelEditMode(AModel: TTripmodel): TItemEditMode;
    class function ModelPickList(AModel: TTripmodel): string;
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
    function GetItemEditMode: TItemEditMode; override;
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

  TmIsTravelapseDestination = class(TBooleanItem)
  public
    constructor Create(AValue: boolean = false);
  end;

  TmShapingRadius = class(TCardinalItem)
  private
    function GetValue: string; override;
    function GetItemEditMode: TItemEditMode; override;
  public
    constructor Create(AValue: Cardinal = $80000000);
  end;

  TmShapingCenter = class(TRawDataItem)
    constructor Create(ALenValue: Cardinal; ADataType: byte; AStream: TStream); reintroduce;
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
  TBaseAdvRoutePreferences = class(TBaseRoutePreferences)
  private
    function GetIntToIdent(const Value: word): string; override;
    function GetItemEditMode: TItemEditMode; override;
  end;

  TmRoutePreferences = class(TBaseRoutePreferences)
  private
    function GetIntToIdent(const Value: word): string; override;
    function GetItemEditMode: TItemEditMode; override;
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
    function GetRoutePref(ViaPt: cardinal): TRoutePreference;
  end;
  TmRoutePreferencesAdventurousMode = class(TBaseRoutePreferences)
  private
    function GetIntToIdent(const Value: word): string; override;
    function GetItemEditMode: TItemEditMode; override;
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
    function GetRoutePref(ViaPt: cardinal): TAdvlevel;
  end;
  TmRoutePreferencesAdventurousHillsAndCurves = class(TBaseAdvRoutePreferences)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;
  TmRoutePreferencesAdventurousScenicRoads = class(TBaseAdvRoutePreferences)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;
  TmRoutePreferencesAdventurousPopularPaths = class(TBaseAdvRoutePreferences)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;

{*** XT3 ***}
  TmSerializedRoutePrefRoundTripRoadType = class(TRawDataItem)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;
  TmSerializedRoutePrefRoundTripDirection = class(TRawDataItem)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;
  TmSerializedRoutePrefRoundTripMethod  = class(TRawDataItem)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;
  TmSerializedRoutePrefRoundTripUnits = class(TRawDataItem)
  public
    constructor Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0); override;
  end;
  TmSerializedRoutePrefRoundTripLength = class(TRawDataItem)
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
    constructor Create(ALenValue: Cardinal; ADataType: byte; AStream: TStream); reintroduce;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    procedure Clear;
    procedure InitFromGpxxRpt(RtePts: TObject);
    function GetCoords(Color: string = ''): string;
  end;

  TmGreatRidesInfoMap = class(TRawDataItem)
    constructor Create(ALenValue: Cardinal; ADataType: byte; AStream: TStream); reintroduce;
  end;

{*** Header ***}
  THeaderValue = packed record
    Id:               array[0..3] of AnsiChar;  // 'TRPL'
    SubLength:        Cardinal;
    DataType:         byte;                     // 10
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

{*** AllLinks (nuvi2595 ***}
  TLinkValue = packed record
    Id:               array[0..3] of AnsiChar;  // 'Link'
    Size:             Cardinal;
    DataType:         byte;
    Unknown1:         Word;
    Count:            Word;
    procedure SwapCardinals;
  end;
  Tlink = class(TBaseItem)
  private
    FValue:           TLinkValue;
    FItemList: TItemList;
    procedure WriteValue(AStream: TMemoryStream); override;
  public
    constructor Create; reintroduce; overload;
    constructor Create(ARoutePref: TRoutePreference;
                       ATransportMode: TTransportMode); reintroduce; overload;
    destructor Destroy; override;
    procedure Add(ANitem: TBaseItem);
    procedure Clear;
    property Value: TLinkValue read FValue;
    property Items: TItemList read FItemList;
  end;
  TmAllLinks = class(TBaseDataItem)
  private
    FItemCount: Cardinal;
    FItemList: TItemList;
    FLink: Tlink;
    FDefRoutePref: TRoutePreference;
    FDefTransportMode: TTransportMode;
    procedure Calculate(AStream: TMemoryStream); override;
    procedure WriteValue(AStream: TMemoryStream); override;
  public
    constructor Create; reintroduce;
    procedure InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream); override;
    destructor Destroy; override;
    procedure Clear;
    procedure AddLink(ALink: Tlink);
    function Add(ANItem: TBaseItem): TBaseItem;
    property Links: TItemList read FItemList;
    property DefRoutePref: TRoutePreference read FDefRoutePref write FDefRoutePref;
    property DefTransportMode: TTransportMode read FDefTransportMode write FDefTransportMode;
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
    FTransPortMode: TTransportMode;
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
    property TransportMode: TTransportMode read FTransPortMode write FTransPortMode;
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

(*

 Memory layout UdbDataHndl              Size   Pascal constant
+---------------------------------------------------------------------------------+
|Fixed part UdbHandle                 |     |                                     |
|                                     |     |                                     |
|    Prefix                           |   13|                                     |
|      unknown         Cardinal       |    4|                                     |
|      Size            Cardinal       |    4|                                     |
|      DataType        Byte           |    1| 0x0a                                |
|      HandleId        Cardinal       |    4|                                     |
|    Initiator         Char           |    1| Tab 0x09                            |
|    NameLen           Cardinal       |    4|                                     |
|    Name              string         |   12| 'mUdbDataHndl'                      |
|    Datatype          byte           |    1| 0x0b                                |
|    UdbHandleSize:    Cardinal       |    4|                                     |
|    CalcStatus:       Cardinal       |    4| CalculationMagic[TTripModel]        |
|---------------------------------------------------------------------------------|
|    Unknown2:         TBytes         |     | TripFileVersion.Unknown2Size        |
|---------------------------------------------------------------------------------|
|    UDbDirCount:      WORD           |    2|                                     |
|    Unknown3:         TBytes         |  var| Unknown3Size[TTripModel]            |
|---------------------------------------------------------------------------------|
|Identified fields of Unknown3        |     |                                     |
|       Unknown3Dist:  Cardinal       |    4| TripFileVersion.Unknown3DistOffset  |
|       Unknown3Time:  Cardinal       |    4| TripFileVersion.Unknown3TimeOffset  | 
|       Unknown3Shape: TBytes         |  var| TripFileVersion.Unknown3ShapeOffset |
|---------------------------------------------------------------------------------|
|Variable part UdbHandle              |     |                                     |
|    UdbDir 1                         |     |                                     |
|    UdbDir ..                        |     |                                     |
|    UdbDir UdbDirCount               |     |                                     |
+---------------------------------------------------------------------------------+
|Trailer                TBytes        |  var| Major version 1 can have a          |
|                                     |     | trailer. Usually 4..12 bytes        |
|                                     |     | Must be < size UdbDir               |
+---------------------------------------------------------------------------------+

+---------------------------------------------------------------------------------+
|Fixed part UdbDir                    |     |                                     |
|                                     |     |                                     |
|   TUdbDirFixedValue = packed record |     |                                     |
|     SubClass:         TSubClass     |   30|                                     |
|     Lat:              integer       |    4|                                     |
|     Lon:              integer       |    4|                                     |
|     UdbDirMagic:      Cardinal      |    4| $51590469                           |
|     Time:             WORD          |    2|                                     |
|---------------------------------------------------------------------------------|
|Variable part UdbDir                 |     |                                     |
|                                     |     |                                     |
|     FUnknown2:         TBytes       |  var| TripFileVersion.UdbDirUnknown2Size  |
|     FName:             TBytes       |  var| UdbDirNameSize[TTripModel]          |
+---------------------------------------------------------------------------------+

*)

  TSubClass = packed record
    MapSegment:       Cardinal;
    RoadId:           Cardinal;
    PointType:        byte;
    procedure Init(const GPXSubClass: string);
    function Serialize: string;
    function IsKnownRoutePoint: boolean;
    function IsKnownComprLatLon: boolean;
    function IsKnownStartEndSegment: boolean;
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
        Unknown2:         array[0..1] of byte;
        Unknown3:         word;
        Distance:         word) // multiply by 2.39 to get meters
  end;
  TUdbDirFixedValue = packed record
    SubClass:         TSubClass;
    Lat:              integer;
    Lon:              integer;
    UdbDirMagic:      Cardinal; // Contains $51590469;
    Time:             word;
    procedure SwapCardinals;
  end;
  TUdbDir = class(TBaseItem)
  private
    FValue:            TUdbDirFixedValue;
    FUnknown2:         TBytes;
    FUdbDirName:       TBytes;
    FUdbDirStatus:     TUdbDirStatus;
    FRoadClass:        string;
    constructor Create(AModel: TTripModel;
                       ATripOption:TTripOption;
                       AName: WideString;
                       ALat: double = 0;
                       ALon: double = 0;
                       APointType: byte = $03); reintroduce; overload;
    constructor Create(AModel: TTripModel;
                       ATripOption:TTripOption;
                       ALocation: TLocation); reintroduce; overload;
    constructor Create(AModel: TTripModel;
                       ATripOption:TTripOption;
                       GPXSubClass, RoadClass: string;
                       Lat, Lon: double); reintroduce; overload;
    procedure WriteValue(AStream: TMemoryStream); override;
    function SubLength: Cardinal; override;
    function GetName: string;
    function GetDisplayLength: integer;
    function GetNameLength: integer;
    function GetMapCoords: string;
    function GetCoords: TCoords;
    function GetMapSegRoadFmt(FmtStr: string): string;
    function GetMapSegRoad: string;
    function GetMapSegRoadDisplay: string;
    function GetMapSegRoadExclBit: string;
    function GetPointType: string;
    function GetDirection: string;
    procedure FillCompressedLatLon;
    function GetComprLatLon: string;
    procedure SetLat(ALat: Double);
    procedure SetLon(ALon: Double);
  public
    function GetLat: Double;
    function GetLon: Double;
    function IsTurn: boolean;
    property DisplayName: string read GetName;
    property DisplayLength: integer read GetDisplayLength;
    property NameLength: integer read GetNameLength;
    property UdbDirValue: TUdbDirFixedValue read FValue;
    property Unknown2: TBytes read FUnknown2;
    property Coords: TCoords read GetCoords;
    property MapCoords: string read GetMapCoords;
    property MapSegRoadDisplay: string read GetMapSegRoadDisplay;
    property MapSegRoad: string read GetMapSegRoad;
    property MapSegRoadExclBit: string read GetMapSegRoadExclBit;
    property PointType: string read GetPointType;
    property Direction: string read GetDirection;
    property ComprLatLon: string read GetComprLatLon;
    property Status: TUdbDirStatus read FUdbDirStatus write FUdbDirStatus;
    property RoadClass: string read FRoadClass write FRoadClass; // Only valid in SaveCalculated
    property Lat: Double read GetLat write SetLat;
    property Lon: Double read GetLon write SetLon;
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
    CalcStatus:       Cardinal;
    Unknown2:         TBytes;
    UDbDirCount:      WORD;
    Unknown3:         TBytes;
    procedure SwapCardinals;
    procedure AllocUnknown2(ASize: Cardinal);
    procedure AllocUnknown3(ASize: Cardinal);
    procedure AllocUnknown(AModel: TTripModel = TTripModel.Unknown);
    procedure UpdateUnknown3(const Offset: integer; const Value: Cardinal);
    function GetUnknown3(const Offset: integer): Cardinal;
    function GetAvoidances(const Offset: integer): string;
    function GetShapeBitMapLen(const Offset: integer): integer;
    function GetShapeBitMap(const Offset: integer): string;
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
    function GetBoundsMin: string;
    function GetBoundsMax: string;
    function GetDistOffset: integer;
    function GetTimeOffset: integer;
    function GetShapeOffset: integer;
    function GetMagicOffset: integer;
    function GetAvoidancesOffset: integer;
    function GetBoundsOffset(Index: Integer): integer;
    function GetFloatOffset: integer;
  public
    constructor Create(AHandleId: Cardinal;
                       AModel: TTripModel = TTripModel.Unknown;
                       ForceRecalc: boolean = true); reintroduce;
    destructor Destroy; override;
    procedure Add(AnUdbDir: TUdbDir);
    function GetBoundsTopLeft: string;
    function GetBounds: string;
    function NineFloats: string;
    property HandleId: Cardinal read FUdbHandleId;
    property PrefValue: TUdbPrefValue read FUdbPrefValue;
    property UdbHandleValue: TUdbHandleValue read FValue;
    property Items: TUdbDirList read FUdbDirList;
    property DistOffset: integer read GetDistOffset;
    property TimeOffset: integer read GetTimeOffset;
    property ShapeOffset: integer read GetShapeOffset;
    property MagicOffset: integer read GetMagicOffset;
    property AvoidancesOffset: integer read GetAvoidancesOffset;
    property BoundsOffset[Index: Integer]: integer read GetBoundsOffset;
    property FloatOffset: integer read GetFloatOffset;
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
    FTripFileVersion: TTripVersion;
    FTripInfoList: TTripInfoList;
    procedure ResetCalculation;
    procedure Calculate(AStream: TMemoryStream);
    function FirstUdbDataHndle: TmUdbDataHndl;
    function GetTripName: string;
    function GetIsCalculated: boolean;
    function GetExploreUUID: string;
    function GetVehicleProfileName: string;
    function GetVehicleGUID: string;
    function GetAvoidancesChangedTimeAtSave: cardinal;
    function GetVehicleHash: cardinal;
    function GetTripModelFromUDB: TTripModel;
    function GetTripModel: TTripModel;
    procedure SetTripModel(ATripModel: TTripModel);
    function GetCalculationModel(AModel: TTripModel): TTripModel;
    procedure SetTripFileVersionFromTrip(AStream: TStream);
    procedure SetTripFileVersion(ATripFileVersion: TTripVersion);
    function InitAllLinks: TBaseItem;
    function InitAllRoutes: TBaseItem;
    procedure SetPreserveTrackToRoute(const RtePts: TObject);
    procedure UpdateDistAndTime(TotalDist: single; TotalTime: Cardinal);
    procedure AddUdbDir2Xml(AnUdbDir: TUdbDir; RoutePtRteExt: TXmlVSNode; TimeLst: TObjectlist<TLatLonTime>);
    procedure AddTMExtension(RoutePtRteExt: TXmlVSNode; IsViaPoint: boolean;
                             Dist, Time: Cardinal;
                             TimeLst: TObjectlist<TLatLonTime>);
    procedure Trip2XmlRte(Rte: TObject);
    procedure AddLocation_XT(const Locations: TmLocations;
                             const Location2Add: TLocation2Add);
    procedure AddLocation_XT2(const Locations: TmLocations;
                              const Location2Add: TLocation2Add);
    procedure AddLocation_XT3(const Locations: TmLocations;
                              const Location2Add: TLocation2Add);
    procedure AddLocation_Tread2(const Locations: TmLocations;
                                 const Location2Add: TLocation2Add);
    procedure AddLocation_Zumo346(const Locations: TmLocations;
                                  const Location2Add: TLocation2Add);
    procedure AddLocation_Zumo595(const Locations: TmLocations;
                                  const Location2Add: TLocation2Add);
    procedure AddLocation_Zumo590(const Locations: TmLocations;
                                  const Location2Add: TLocation2Add);
    procedure AddLocation_Drive51(const Locations: TmLocations;
                                  const Location2Add: TLocation2Add);
    procedure AddLocation_Drive66(const Locations: TmLocations;
                                  const Location2Add: TLocation2Add);
    procedure AddLocation_Zumo3x0(const Locations: TmLocations;
                                  const Location2Add: TLocation2Add);
    procedure AddLocation_nuvi2595(const Locations: TmLocations;
                                   const Location2Add: TLocation2Add);
    procedure AddLocation_nuvi2599_57(const Locations: TmLocations;
                                      const Location2Add: TLocation2Add);
    procedure CreateTemplate_XT(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_XT2(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_XT3(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Tread2(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Zumo346(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Zumo595(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Zumo590(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Drive51(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Drive66(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_Zumo3x0(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_nuvi2595(const TripName, CalculationMode, TransportMode: string);
    procedure CreateTemplate_nuvi2599_57(const TripName, CalculationMode, TransportMode: string);
    procedure SetRoutePref(AKey: ShortString; TmpStream: TMemoryStream);
    procedure UpdLocsFromRoutePrefs;
    procedure UpdLocsFromAllLinks;
  public
    constructor Create; overload;
    constructor Create(AModel: TTripModel); overload;
    destructor Destroy; override;
    procedure Clear;
    procedure SetHeader(AHeader: THeader);
    function Add(ANItem: TBaseItem): TBaseItem;
    procedure SaveToStream(AStream: TMemoryStream);
    procedure SaveToFile(AFile: string);
    procedure ExportTripInfo(AFile: string);
    function ScanStream(AStream: TStream; AKeyName: ShortString): TBaseItem;
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
    procedure AddLocation(const Locations: TmLocations; const Location2Add: TLocation2Add); overload;
    procedure SetSegmentRoutePrefs(Locations: TmLocations; ProcessOptions: TObject);
    function GetSegmentInclRoads(var Popular: boolean;
                                  var Scenic: boolean;
                                  var Hills: boolean): boolean;
    procedure SetRoundTripPrefs(Locations: TmLocations; ProcessOptions: TObject);
    procedure ForceRecalc(const AModel: TTripModel = TTripModel.Unknown; ViaPointCount: integer = 0);
    procedure TripTrack(const AModel: TTripModel;
                        const RtePts: TObject;
                        const SubClasses: TStringList;
                        const GpxDist: double = 0);
    procedure SaveCalculated(const AModel: TTripModel;
                            const RtePts: TObject);
    procedure CreateTemplate(const TripName: string;
                             const CalculationMode: string = '';
                             const TransportMode: string = '');
    procedure SaveAsGPX(const GPXFile: string);
    function KurvigerUrl: string;
    property Header: THeader read FHeader;
    property ItemList: TItemList read FItemList;
    property IsCalculated: boolean read GetIsCalculated;
    property TripName: string read GetTripName;
    property ExploreUUID: string read GetExploreUUID;
    property VehicleGUID: string read GetVehicleGUID;
    property VehicleProfileName: string read GetVehicleProfileName;
    property AvoidancesChangedTimeAtSave: cardinal read GetAvoidancesChangedTimeAtSave;
    property VehicleHash: cardinal read GetVehicleHash;
    property TripModel: TTripModel read GetTripModel write SetTripModel;
    property ModelDescription: string read FModelDescription;
    property TripFileVersion: TTripVersion read FTripFileVersion write SetTripFileVersion;
    property RouteCnt: Cardinal read FRouteCnt write FRouteCnt;
  end;

implementation

uses
  System.Math, System.DateUtils, System.StrUtils, System.TypInfo, System.UITypes,
  Vcl.Dialogs,
{$IFDEF OSMMAP}
  UnitOSMMap,
{$ENDIF}
  UnitStringUtils, UnitProcessOptions;

const
  Coord_Decimals                      = '%1.6f';
  StringLoaded: word                  = $ffff;
  TurnMagic: array[0..1] of byte      = ($47, $4E);
  TripFileName                        = '0:/.System/Trips/%s.trip';
  UdbDirTurn                          = 'Turn';
  UdbDirMagic: Cardinal               = $51590469;
  // Override length for Word size route prefs.
  LenDtDWordRoutePref                 = 5;

var
  FloatFormatSettings: TFormatSettings; // for FormatFloat -see Initialization

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
  MaxLen := Min(Length(AWideString) * SizeOf(WideChar), High(AWideArray) +1);
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
    result.SetTripList(ATripList);
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
          result.SetTripList(ATripList);
        end;
      dtCardinal:
        begin;
          AStream.Read(ACardinal, SizeOf(ACardinal));
          result := TCardinalItem.Create(AKeyName, Swap32(ACardinal));
          result.SetTripList(ATripList);
        end;
      dtSingle:
        begin;
          AStream.Read(ASingle, SizeOf(ASingle));
          result := TSingleItem.Create(AKeyName, Swap32(ASingle));
          result.SetTripList(ATripList);
        end;
      dtBoolean:
        begin;
          AStream.Read(ABoolean, SizeOf(ABoolean));
          result := TBooleanItem.Create(AKeyName, ABoolean);
          result.SetTripList(ATripList);
        end;
      dtString:
        begin;
          result := TStringItem.Create(AKeyName);
          result.SetTripList(ATripList);
          TStringItem(result).InitFromStream(AKeyName, AValueLen, dtString, AStream);
        end;
      else
      begin
        // Create a Raw data item. Only holds bytes
        result := TRawDataItem.Create;
        result.SetTripList(ATripList);
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

procedure TBaseItem.SetTripList(const ATripList: TTripList);
begin
  FTripList := ATripList;
end;

function TBaseItem.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emNone;
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

class function TBaseItem.GetKey: ShortString;
begin
  result := ShortString(Copy(ClassName, 2));
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

function TByteItem.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emEdit;
end;

procedure TByteItem.SetByte(AByte: byte);
begin
  FValue := AByte;
end;

procedure TByteItem.SetValue(NewValue: string);
var
  NewVal: integer;
begin
  if TryStrToInt(NewValue, NewVal) and
     (NewVal >= 0) and
     (NewVal <= 255) then
    AsByte := NewVal;
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

function TCardinalItem.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emEdit;
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

function TSingleItem.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emEdit;
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

function TBooleanItem.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emPickList;
end;

function TBooleanItem.GetPickList: string;
begin
  result := 'False' +#10 +
            'True';
end;

{*** Version ***}
constructor TmVersionNumber.Create(ATripVersion: TTripVersion);
begin
  case ATripVersion.Size of
    1:
      begin
        inherited Create(GetKey, SizeOf(FValue.Size) + SizeOf(FValue.VersionB), dtVersion);
        FValue.Size     := Swap32(ATripVersion.Size);
        FValue.VersionB := ATripVersion.Version;
      end
    else
    begin
      inherited Create(GetKey, SizeOf(FValue), dtVersion);
      FValue.Size     := Swap32(ATripVersion.Size);
      FValue.VersionC := ATripVersion.Version;
    end;
  end;
end;

procedure TmVersionNumber.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  AStream.Read(FValue.Size, SizeOf(FValue.Size));
  if (ALenValue = SizeOf(FValue.Size) + SizeOf(FValue.VersionB)) then
    AStream.Read(FValue.VersionB, SizeOf(FValue.VersionB))
  else
    AStream.Read(FValue.VersionC, SizeOf(FValue.VersionC));
end;

destructor TmVersionNumber.Destroy;
begin
  inherited Destroy;
end;

procedure TmVersionNumber.WriteValue(AStream: TMemoryStream);
begin
  AStream.Write(FValue.Size, SizeOf(FValue.Size));
  if (FLenValue = SizeOf(FValue.Size) + SizeOf(FValue.VersionB)) then
    AStream.Write(FValue.VersionB, SizeOf(FValue.VersionB))
  else
    AStream.Write(FValue.VersionC, SizeOf(FValue.VersionC));
end;

function TmVersionNumber.GetValue: string;
begin
  if (FLenValue = SizeOf(FValue.Size) + SizeOf(FValue.VersionB)) then
    result := Format('0x%s / 0x%s', [IntToHex(FValue.Size, 8), IntToHex(FValue.VersionB, 2)])
  else
    result := Format('0x%s / 0x%s', [IntToHex(FValue.Size, 8), IntToHex(FValue.VersionC, 8)]);
end;

{*** ScPosn ***}
procedure TPosnValue.SwapCardinals;
begin
  ScnSize := Swap32(ScnSize);
end;

constructor TmScPosn.Create(ALat, ALon: double; ASize: Cardinal);
begin
  case ASize of
    PosnSmall:
      begin
        inherited Create(GetKey,
                         SizeOf(FValue.ScnSize) + Sizeof(FValue.Lat_8) + SizeOf(FValue.Lon_8),
                         dtPosn);
        FValue.ScnSize := Sizeof(FValue.Lat_8) + SizeOf(FValue.Lon_8);
        FValue.Lat_8 := (CoordAsInt(ALat));
        FValue.Lon_8 := (CoordAsInt(ALon));
      end;
    PosnLarge:
      begin
        inherited Create(GetKey, SizeOf(FValue), dtPosn);
        FValue.ScnSize := SizeOf(FValue.Unknown1_16) + Sizeof(FValue.Lat_16) + SizeOf(FValue.Lon_16);
        FValue.Unknown1_16[0] := $00000000;
        FValue.Unknown1_16[1] := $00000000;
        FValue.Lat_16 := (CoordAsInt(ALat));
        FValue.Lon_16 := (CoordAsInt(ALon));
      end;
    else
    begin
      inherited Create(GetKey,
                       SizeOf(FValue.ScnSize) + SizeOf(FValue.Unknown1) + Sizeof(FValue.Lat) + SizeOf(FValue.Lon),
                       dtPosn);
      FValue.ScnSize      := SizeOf(FValue.Unknown1) + Sizeof(FValue.Lat) + SizeOf(FValue.Lon);
      FValue.Unknown1     := $00000000;
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
    PosnSmall:
      begin
        AStream.Read(FValue.Lat_8, SizeOf(FValue.Lat_8));
        AStream.Read(FValue.Lon_8, SizeOf(FValue.Lon_8));
      end;
    PosnLarge:
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
    PosnSmall:
      begin
        FValue.SwapCardinals;
        AStream.Write(FValue.ScnSize, SizeOf(FValue.ScnSize));
        AStream.Write(FValue.Lat_8, SizeOf(FValue.Lat_8));
        AStream.Write(FValue.Lon_8, SizeOf(FValue.Lon_8));
      end;
    PosnLarge:
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

function TmScPosn.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emButton;
end;

function TmScPosn.GetValue: string;
begin
  case FValue.ScnSize of
    PosnSmall:
      begin
        result := Format('Lat, Lon: %s',
                        [MapCoords]);
      end;
    PosnLarge:
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
    PosnSmall:
      ; // Do nothing
    PosnLarge:
      result := result + SizeOf(FValue.Unknown1_16);
    else
      result := result + SizeOf(FValue.Unknown1);
  end;
end;

function TmScPosn.GetLenValue: Cardinal;
begin
  case FValue.ScnSize of
    PosnSmall:
      result := SizeOf(FValue.Lat_8) + SizeOf(FValue.Lon_8);
    PosnLarge:
      result := SizeOf(FValue.Lat_16) + SizeOf(FValue.Lon_16);
    else
      result := SizeOf(FValue.Lat) + SizeOf(FValue.Lon);
  end;
end;

function TmScPosn.GetLat: double;
begin
  case FValue.ScnSize of
    PosnSmall:
      result := CoordAsDec(FValue.Lat_8);
    PosnLarge:
      result := CoordAsDec(FValue.Lat_16);
    else
      result := CoordAsDec(FValue.Lat);
  end;
end;

function TmScPosn.GetLon: double;
begin
  case FValue.ScnSize of
    PosnSmall:
      result := CoordAsDec(FValue.Lon_8);
    PosnLarge:
      result := CoordAsDec(FValue.Lon_16);
    else
      result := CoordAsDec(FValue.Lon);
  end;
end;

function TmScPosn.GetMapCoords: string;
begin
  case FValue.ScnSize of
    PosnSmall:
      result := FormatMapCoords(CoordAsDec(FValue.Lat_8), CoordAsDec(FValue.Lon_8));
    PosnLarge:
      result := FormatMapCoords(CoordAsDec(FValue.Lat_16), CoordAsDec(FValue.Lon_16));
    else
      result := FormatMapCoords(CoordAsDec(FValue.Lat), CoordAsDec(FValue.Lon));
  end;
end;

function TmScPosn.CoordsAsPosnValue(const LatLon: string): TPosnValue;
var
  Lat, Lon: string;
begin
  result := Default(TPosnValue);
  result.ScnSize := FValue.ScnSize; // Take ScnSize, from current instance

  ParseLatLon(LatLon, Lat, Lon);
  case result.ScnSize of
    PosnSmall:
      begin
        result.Lat_8 := CoordAsInt(CoordAsDec(Lat));
        result.Lon_8 := CoordAsInt(CoordAsDec(Lon));
      end;
    PosnLarge:
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
    if (TripList.TripFileVersion.IsUcs4) then
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

  if (TripList.TripFileVersion.IsUcs4) then
    result := UCS4StringToUnicodeString(FromPrivate(AsUCS4))
  else
    result := PWideChar(FRawBytes);
end;

function TStringItem.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emEdit;
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
  inherited Create(AName, TUnixDateConv.DateTimeAsCardinal(AValue));
end;

function TUnixDate.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emButton;
end;

function TUnixDate.GetValue: string;
begin
  result := TUnixDateConv.CardinalAsDateTimeString(FValue);
end;

function TUnixDate.GetAsUnixDateTime: Cardinal;
begin
  result := FValue;
end;

procedure TUnixDate.SetAsUnixDateTime(AValue: Cardinal);
begin
  FValue := AValue;
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
  inherited Create(GetKey, AValue);
end;

constructor TmParentTripId.Create(AValue: Cardinal = 0);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmDayNumber.Create(AValue: byte = $ff);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmTripDate.Create(AValue: integer = -1);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmIsDisplayable.Create(AValue: boolean = true);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmAvoidancesChanged.Create(AValue: boolean = false);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmIsRoundTrip.Create(AValue: boolean = false);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmParentTripName.Create(AValue: string);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmIsDeviceRoute.Create(AValue: boolean = true);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmExploreUuid.Create(AValue: string);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmVehicleProfileTruckType.Create(AValue: byte);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmVehicleProfileGuid.Create(AValue: string);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmVehicleProfileName.Create(AValue: string);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmVehicleProfileHash.Create(AValue: Cardinal);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmVehicleId.Create(AValue: Cardinal);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmAvoidancesChangedTimeAtSave.Create(AValue: TDateTime = 0);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmAvoidancesChangedTimeAtSave.Create(AValue: cardinal);
begin
  inherited Create(GetKey, TUnixDateConv.CardinalAsDateTime(AValue));
end;

constructor TmOptimized.Create(AValue: boolean = false);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmShowLastStopAsShapingPoint.Create(AValue: boolean = false);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmTotalTripTime.Create(AValue: Cardinal = 0);
begin
  inherited Create(GetKey, AValue);
end;

function TmTotalTripTime.GetValue: string;
begin
  result := TripTimeAsHrMin(FValue);
end;

constructor TmImported.Create(AValue: boolean = false);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmRoutePreference.Create(AValue: TRoutePreference = rmFasterTime; ADataType: byte = dtByte);
begin
  inherited Create(GetKey, Ord(AValue));

  // Zumo 3x0, nuvi2595
  if (ADataType = dtDWordRoutePref) then
  begin
    FDataType := ADataType;
    FLenValue := LenDtDWordRoutePref;
    SetLength(FBytes, FLenValue);
    FBytes[3] := $01;
    FBytes[4] := Ord(AValue);
  end;
end;

procedure TmRoutePreference.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
var
  SavePos: Cardinal;
begin
  SavePos := AStream.Position;
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);

  // Zumo 3x0, nuvi2595
  if (FDataType = dtDWordRoutePref) then
  begin
    SetLength(FBytes, FLenValue);
    AStream.Seek(SavePos, TSeekOrigin.soBeginning);
    AStream.Read(Fbytes, FLenValue);
    FValue := FBytes[4];
  end;
end;

class function TmRoutePreference.RoutePreference(AValue: string; AModel: TTripmodel): TRoutePreference;
begin
  result := Desc2RoutePref(AValue, AModel);
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
  if (FDataType <> dtByte) then
  begin
    AStream.Write(FBytes, FLenValue);
    exit;
  end;

  inherited WriteValue(AStream);
end;

function TmRoutePreference.GetValue: string;
begin
  if (TripList = nil) then
    raise exception.Create('TmRoutePreference.GetValue called, but no Triplist');
  result := RoutePref2Desc(TroutePreference(FValue), TripList.TripModel);
end;

procedure TmRoutePreference.SetByte(AByte: byte);
begin
  FValue := AByte;

  if (FDataType = dtDWordRoutePref) then
  begin
    SetLength(FBytes, 5);
    ZeroMemory(@FBytes[0], Length(FBytes));
    FBytes[3] := $01;
    FBytes[4] := FValue;
  end;
end;

procedure TmRoutePreference.SetValue(AValue: string);
begin
  if (TripList = nil) then
    raise exception.Create('TmRoutePreference.SetValue called, but no Triplist');
  AsByte := Ord(TmRoutePreference.RoutePreference(AValue, TripList.TripModel));
end;

class function TmRoutePreference.ModelEditMode(AModel: TTripmodel): TItemEditMode;
begin
  if (HasAllLinks[AModel]) then // Nuvi 2595
    result := TItemEditMode.emNone
  else
    result := TItemEditMode.emPickList;
end;

function TmRoutePreference.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emNone;
  if (Assigned(TripList)) then
    result := TmRoutePreference.ModelEditMode(TripList.TripModel);
end;

class function TmRoutePreference.ModelPickList(AModel: TTripmodel): string;
var
  ACalcMode: TCalcMode;
begin
  result := '';
  for ACalcMode in CalcModesSuppported[AModel] do
    result := result + RoutePrefRecs[ACalcMode].Desc + #10;
end;

function TmRoutePreference.GetPickList: string;
begin
  result := '';
  if (Assigned(TripList)) then
    result := TmRoutePreference.ModelPickList(Triplist.TripModel);
end;

constructor TmTransportationMode.Create(AValue: TTransportMode = tmMotorcycling);
begin
  inherited Create(GetKey, Ord(AValue));
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
    result := NotApplicable;
end;

procedure TmTransportationMode.SetValue(AValue: string);
begin
  FValue := Ord(TmTransportationMode.TransPortMethod(AValue));
end;

class function TmTransportationMode.ModelEditMode(AModel: TTripmodel): TItemEditMode;
begin
  // EditMode not used for AllLinks (Nuvi 2595)
  if (HasAllLinks[AModel]) then
    result := TItemEditMode.emNone
  else
    result := TItemEditMode.emPickList;
end;

function TmTransportationMode.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emNone;

  if (Assigned(TripList)) then
    result := TmTransportationMode.ModelEditMode(TripList.TripModel);
end;

class function TmTransportationMode.ModelPickList(AModel: TTripmodel): string;
var
  ATransportMode: TTransportMode;
  ATransportIdent: string;
begin
  result := '';
  for ATransportMode in TransportModesSuppported[AModel] do
  begin
    if (IntToIdent(Ord(ATransportMode), ATransportIdent, TransportModeMap)) then
      result := result + ATransportIdent + #10;
  end;
end;

function TmTransportationMode.GetPickList: string;
begin
  result := '';
  if (Assigned(TripList)) then
    result := TmTransportationMode.ModelPickList(Triplist.TripModel);
end;

constructor TmTotalTripDistance.Create(AValue: single = 0);
begin
  inherited Create(GetKey, AValue);
end;

function TmTotalTripDistance.GetValue: string;
begin
  result := Format('%f Km.', [FValue / 1000]);
  result := result + Format(' (%f Meters)', [FValue]);
end;

constructor TmFileName.Create(AValue: string);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmPartOfSplitRoute.Create(AValue: boolean = false);
begin
  inherited Create(GetKey, AValue);
end;

constructor TmTripName.Create(AValue: string);
begin
  inherited Create(GetKey, AValue);
end;

{*** Location Info classes ***}
{ TmAttr }
constructor TmAttr.Create(ARoutePoint: TRoutePoint);
begin
  inherited Create(GetKey, Ord(ARoutePoint));
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

function TmAttr.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emPickList;
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
  inherited Create(GetKey, AValue);
end;

constructor TmDuration.Create(AValue: integer = -1);
begin
  inherited Create(GetKey, AValue);
end;

{ TmArrival }
constructor TmArrival.Create(AValue: TDateTime = 0);
begin
  inherited Create(GetKey, AValue);
end;

{ TmAddress }
constructor TmAddress.Create(AValue: string);
begin
  inherited Create(GetKey, AValue);
end;

{ TmIsTravelapseDestination }
constructor TmIsTravelapseDestination.Create(AValue: boolean = false);
begin
  inherited Create(GetKey, AValue);
end;

{ TmShapingRadius }
constructor TmShapingRadius.Create(AValue: Cardinal = $80000000);
begin
  inherited Create(GetKey, AValue);
end;

function TmShapingRadius.GetValue: string;
begin
  result := '0x' + IntTohex(FValue, 8);
end;

function TmShapingRadius.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emNone;
end;

{ TmShapingCenter }
constructor TmShapingCenter.Create(ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited Create;
  InitFromStream(GetKey, ALenValue, ADataType, AStream);
end;

{ TmName }
constructor TmName.Create(AValue: string);
begin
  inherited Create(GetKey, AValue);
end;

{ TmPhoneNumber, only for Zumo3X0}
constructor TmPhoneNumber.Create(AValue: string);
begin
  inherited Create(GetKey, AValue);
end;

{ TmShaping, only for Zumo3X0}
constructor TmShaping.Create(AValue: boolean = false);
begin
  inherited Create(GetKey, AValue);
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
        if (TRoutePreference(BaseRoutePrefByte) <> TRoutePreference.rmAdventurous) then
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

function TBaseAdvRoutePreferences.GetIntToIdent(const Value: word): string;
begin
  case Value of
    DefRoutePref:
      Result := '';
    DefRoutePrefInclMaps:
      Result := 'Selected';
    else
      result := Format('TBD (0x%s)', [IntTohex(Value, 4)]);
  end;
end;

function TBaseAdvRoutePreferences.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emButton;
end;

constructor TmRoutePreferences.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
end;

function TmRoutePreferences.GetIntToIdent(const Value: word): string;
var
  ARoutePref: TRoutePrefRec;
begin
  for ARoutePref in RoutePrefRecs do
  begin
    if (ARoutePref.DwSize = false) and
       (Ord(ARoutePref.Rm) = (Value and $ff)) then
    exit(ARoutePref.Desc + Format(' (0x%s)', [IntTohex(Value, 4)]));
  end;
  result := inherited GetIntToIdent(Value);
end;

function TmRoutePreferences.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emButton;
end;

function TmRoutePreferences.GetRoutePref(ViaPt: cardinal): TRoutePreference;
begin
  result := TRoutePreference(GetRoutePrefByte(ViaPt));
end;

function TmRoutePreferencesAdventurousMode.GetIntToIdent(const Value: word): string;
begin
  if (IntToIdent(Value and $ff, result, AdvLevelMap)) then
    result := result + Format(' (0x%s)', [IntTohex(Value, 4)])
  else
    result := inherited GetIntToIdent(Value);
end;

function TmRoutePreferencesAdventurousMode.GetItemEditMode: TItemEditMode;
begin
  result := TItemEditMode.emButton;
end;

function TmRoutePreferencesAdventurousMode.GetRoutePref(ViaPt: cardinal): TAdvlevel;
begin
  result := TAdvlevel(GetRoutePrefByte(ViaPt));
end;

constructor TmRoutePreferencesAdventurousHillsAndCurves.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
end;

constructor TmRoutePreferencesAdventurousScenicRoads.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
end;

constructor TmRoutePreferencesAdventurousMode.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
end;

constructor TmRoutePreferencesAdventurousPopularPaths.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
end;

{*** XT3 ***}
constructor TmSerializedRoutePrefRoundTripRoadType.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
end;

constructor TmSerializedRoutePrefRoundTripDirection.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
end;

constructor TmSerializedRoutePrefRoundTripMethod.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
end;

constructor TmSerializedRoutePrefRoundTripUnits.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
end;

constructor TmSerializedRoutePrefRoundTripLength.Create(AName: ShortString = ''; ALenValue: Cardinal = 0; ADataType: byte = 0);
begin
  inherited Create(GetKey, 0 , $80);
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

constructor TmTrackToRouteInfoMap.Create(ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited Create;
  InitFromStream(GetKey, ALenValue, ADataType, AStream);
end;

procedure TmTrackToRouteInfoMap.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited InitFromStream(AName, ALenValue, ADataType, AStream);
  FTrackHeader := Default(TTrackHeader);
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
    PrevCoords := Default(TCoords);
    RtePtNode := TXmlVSNodeList(RtePts).FirstChild;
    while (RtePtNode <> nil) do
    begin
      Coords.FromAttributes(RtePtNode.AttributeList);
      WriteCoords;

      GpxxRptNode := GetFirstGpxxRptNode(RtePtNode);
      while (GpxxRptNode <> nil) do
      begin
        Coords.FromAttributes(GpxxRptNode.AttributeList);
        WriteCoords;

        GpxxRptNode := GpxxRptNode.NextSibling;
      end;
      RtePtNode := RtePtNode.NextSibling;
    end;
    FTrackHeader := Default(TTrackHeader);
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

{*** TmGreatRidesInfoMap ***}
constructor TmGreatRidesInfoMap.Create(ALenValue: Cardinal; ADataType: byte; AStream: TStream);
begin
  inherited Create;
  InitFromStream(GetKey, ALenValue, ADataType, AStream);
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
  FValue.DataType := dtHeaderPref;
  FValue.TotalItems := 0;
end;

destructor THeader.Destroy;
begin
  inherited Destroy;
end;

procedure THeader.Clear;
begin
  FValue := Default(THeaderValue);
end;

procedure THeader.UpdateFromTripList(ItemCount, ASubLength: Cardinal);
begin
  FValue.TotalItems := ItemCount;
  FValue.SubLength := ASubLength + SizeOf(FValue.DataType) + SizeOf(FValue.TotalItems);
end;

procedure THeader.WriteValue(AStream: TMemoryStream);
begin
  FValue.SwapCardinals;
  AStream.Write(FValue, SizeOf(FValue));
  FValue.SwapCardinals;
end;

{*** AllLinks ***}
procedure TLinkValue.SwapCardinals;
begin
  Count := Swap(Count);
  Size := Swap32(Size);
end;

constructor TLink.Create;
begin
  inherited Create;
  FValue.Id := 'Link';
  FValue.DataType := dtLinkPref;
  FValue.Size := SizeOf(FValue) - SizeOf(FValue.Id) - SizeOf(FValue.Size);
  FItemList := TItemList.Create;
end;

constructor TLink.Create(ARoutePref: TRoutePreference;
                         ATransportMode: TTransportMode);
begin
  Create;
  Add(TmRoutePreference.Create(ARoutePref, dtDWordRoutePref));
  Add(TmTransportationMode.Create(ATransportMode));
end;

destructor TLink.Destroy;
begin
  Clear;
  FItemList.Free;
  inherited Destroy;
end;

procedure TLink.Clear;
var
  AnItem: TBaseItem;
begin
  if (Assigned(FItemList)) then
  begin
    for ANitem in FItemList do
      FreeAndNil(ANitem);
    FItemList.Clear;
  end;
  FValue.Count := 0;
end;

procedure TLink.Add(ANitem: TBaseItem);
begin
  Inc(FValue.Count);
  FValue.Size := FValue.Size + ANitem.SubLength;
  ANitem.SetTripList(TripList);
  FItemList.Add(ANitem);
end;

procedure Tlink.WriteValue(AStream: TMemoryStream);
var
  AnItem: TBaseItem;
begin
  FValue.SwapCardinals; // Swap Cardinals
  AStream.Write(FValue, SizeOf(FValue));
  FValue.SwapCardinals; // Swap Cardinals back
  for AnItem in FItemList do
    AnItem.Write(AStream);
end;

constructor TmAllLinks.Create;
begin
  inherited Create(GetKey, SizeOf(FItemCount), dtList); // Will get Length later, Via Calculate
  FItemList := TItemList.Create;
  FItemCount := 0;
  FDefRoutePref := TRoutePreference.rmFasterTime;
  FDefTransportMode := TTransportMode.tmAutoMotive;
end;

procedure TmAllLinks.InitFromStream(AName: ShortString; ALenValue: Cardinal; ADataType: byte; AStream: TStream);
var
  LinkCnt: integer;
  LinkItems: integer;
  TmpItemCount: integer;
  ALink: Tlink;
  ALinkValue: TLinkValue;
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

  // Count of links
  AStream.Read(TmpItemCount, SizeOf(TmpItemCount));
  TmpItemCount := Swap32(TmpItemCount);

  for LinkCnt := 0 to TmpItemCount -1 do
  begin
    ALink := Tlink.Create;

    // To get the count of items for this Link
    AStream.Read(ALinkValue, SizeOf(ALinkValue));
    ALinkValue.SwapCardinals;

    for LinkItems := 0 to ALinkValue.Count -1 do
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
      ALink.Add(ABaseItem);
      ABaseItem.SetTripList(TripList);

      // Should not occur
      if (AStream.Position <> SavePos + ValueLen - SizeOf(Initiator)) then
      begin
        BreakPoint;
        AStream.Seek(SavePos + ValueLen - SizeOf(Initiator), TSeekOrigin.soBeginning);
      end;

    end;
    AddLink(ALink);
  end;
end;

destructor TmAllLinks.Destroy;
begin
  Clear;
  FreeAndNil(FItemList);

  inherited Destroy;
end;

procedure TmAllLinks.Clear;
var
  AnItem: TBaseItem;
begin
  if (Assigned(FItemList)) then
  begin
    for ANitem in FItemList do
      FreeAndNil(ANitem);
    FItemList.Clear;
  end;
  FItemCount := 0;
end;

procedure TmAllLinks.AddLink(ALink: Tlink);
begin
  ALink.SetTripList(TripList);
  FLink := ALink;
  FItemList.Add(ALink);
  FItemCount := FItemCount +1;
end;

function TmAllLinks.Add(ANItem: TBaseItem): TBaseItem;
begin
  ANItem.SetTripList(TripList);
  FItemList.Add(ANItem);
  Flink.Add(ANItem);
  result := ANItem;
end;

procedure TmAllLinks.Calculate(AStream: TMemoryStream);
var
  ANitem, AlinkItem: TBaseItem;
  CurLink: Tlink;
begin
  inherited Calculate(AStream);

  FLenValue := SizeOf(FItemCount);
  for ANitem in FItemList do
  begin
    FLenValue := FLenValue + ANitem.SubLength;
    if (ANitem is TLink) then
    begin
      CurLink := Tlink(ANitem);
      CurLink.FValue.Size := SizeOf(CurLink.FValue) - SizeOf(CurLink.FValue.Id) - SizeOf(CurLink.FValue.Size);
      for AlinkItem in CurLink.FItemList do
        CurLink.FValue.Size := CurLink.FValue.Size + AlinkItem.SubLength;
    end;
  end;
end;

procedure TmAllLinks.WriteValue(AStream: TMemoryStream);
var
  ANitem: TBaseItem;
begin
  WriteSwap32(AStream, FItemCount);
  for ANitem in FItemList do
    ANitem.Write(AStream);
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
  ANitem.SetTripList(TripList);
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

// Zumo 3x0, 590
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
  result := false;

  // Using AllLinks? Nuvi 2595
  if (HasAllLinks[TripList.TripModel]) then
    exit(true);

  // Using TmShaping? Zumo 3x0, 590
  ViaShapeObject := LocationTmShaping;
  if Assigned(ViaShapeObject) and
     not (TmShaping(ViaShapeObject).AsBoolean) then
    exit(true);

  // Using TmAttr? all others
  ViaShapeObject := LocationTmAttr;
  if Assigned(ViaShapeObject) and
    (TmAttr(ViaShapeObject).AsRoutePoint = TRoutePoint.rpVia) then
    exit(true);
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
  inherited Create(GetKey, SizeOf(FItemCount), dtList); // Will get Length later, Via Calculate
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
      ABaseItem.SetTripList(TripList);

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
  ALocation.SetTripList(TripList);
  FLocation := ALocation;
  FItemList.Add(ALocation);
  FItemCount := FItemCount +1;
end;

function TmLocations.Add(ANItem: TBaseItem): TBaseItem;
begin
  ANItem.SetTripList(TripList);
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

function TSubClass.Serialize: string;
var
  Index: integer;
begin
  result := '0000' + // roadclass
            IntToHex(Swap32(MapSegment), 8) +
            IntToHex(Swap32(RoadId), 8) +
            IntToHex(PointType, 2);
  for Index := Low(ComprLatLon) to High(ComprLatLon) do
    result := result + IntToHex(ComprLatLon[Index], 2);
end;

function TSubClass.IsKnownRoutePoint: boolean;
begin
  result := (PointType in RoutePointsKnown);
end;

function TSubClass.IsKnownComprLatLon: boolean;
begin
  result := (PointType in RoutePointComprLatLon);
end;

function TSubClass.IsKnownStartEndSegment: boolean;
begin
  case PointType of
    $21:
      result := true;
    else
      result := false;
  end;
end;

procedure TUdbDirFixedValue.SwapCardinals;
begin
  Lat := Swap32(Lat);
  Lon := Swap32(Lon);
end;

// Common create for UdbDir
constructor TUdbDir.Create(AModel: TTripModel;
                           ATripOption: TTripOption;
                           AName: WideString;
                           ALat: double = 0;
                           ALon: double = 0;
                           APointType: byte = $03);

begin
  inherited Create;
  FValue := Default(TUdbDirFixedValue);
  SetLength(FUnknown2, TripVersion[AModel].UdbDirUnknown2Size);
{$IFDEF TM_EXTENSIONS}
  FUnknown2[6] := Ord('T');
  FUnknown2[7] := Ord('M');
{$ENDIF}
  SetLength(FUdbDirName, UdbDirNameSize[AModel]);

  // Copy Name
  case TripVersion[AModel].IsUcs4 of
    true:
      WideStringToUCS4Array(AName, UCS4String(FUdbDirName));
    false:
      WideStringToWideArray(AName, FUdbDirName);
  end;

  // Init FValue
  FValue.Lat      := Swap32(CoordAsInt(ALat));
  FValue.Lon      := Swap32(CoordAsInt(ALon));
  FValue.UdbDirMagic := Swap32(UdbDirMagic);
  FValue.SubClass.PointType := APointType;

  FUdbDirStatus   := TUdbDirStatus.udsUnchecked;
end;

// UdbDir Create for <rtept>
constructor TUdbDir.Create(AModel: TTripModel;
                           ATripOption: TTripOption;
                           ALocation: TLocation);
var
  AmScPosn: TmScPosn;
begin
  if not Assigned(ALocation) then
  begin
    Create(AModel, ATripOption, '');
    exit;
  end;

  Create(AModel, ATripOption, ALocation.LocationTmName.AsString);

  AmScPosn := ALocation.LocationTmScPosn;
  case AmScPosn.FValue.ScnSize of
    PosnSmall:
      begin
        FValue.Lat := Swap32(AmScPosn.FValue.Lat_8);
        FValue.Lon := Swap32(AmScPosn.FValue.Lon_8);
      end;
    PosnLarge:
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
  FValue.SubClass.MapSegment  := Swap32($00000180);
  FValue.SubClass.RoadId      := Swap32($00f0ffff);
  FillCompressedLatLon;
  FValue.Time                 := $ffff;
  FUnknown2[4]                := $80;
  FUnknown2[5]                := $01;
end;

// UdbDir Create for <gpxx:rpt>
constructor TUdbDir.Create(AModel: TTripModel;
                           ATripOption: TTripOption;
                           GPXSubClass, RoadClass: string;
                           Lat, Lon: Double);
begin
  Create(AModel, ATripOption, Format('%s %s %s', [RoadClass, Copy(GPXSubClass, 1, 8), Copy(GPXSubClass, 9, 8)]));

  FValue.Lat := Swap32(CoordAsInt(Lat));
  FValue.Lon := Swap32(CoordAsInt(Lon));
  if (ATripOption = TTripOption.ttCalc) then
    FValue.SubClass.Init(RecalcSubClass(GPXSubClass))
  else
    FValue.SubClass.Init(GPXSubClass);

  FRoadClass := RoadClass; // Not saved in Trip File
end;

procedure TUdbDir.WriteValue(AStream: TMemoryStream);
begin
  FValue.SwapCardinals;
  AStream.Write(FValue, SizeOf(FValue));
  Astream.Write(FUnknown2[0], Length(FUnknown2));
  AStream.Write(FUdbDirName, Length(FUdbDirName));
  FValue.SwapCardinals;
end;

function TUdbDir.SubLength: Cardinal;
begin
  result := SizeOf(FValue) + Length(FUnknown2) + Length(FUdbDirName);
end;

function TUdbDir.GetLat: Double;
begin
  result := CoordAsDec(Swap32(FValue.Lat));
end;

procedure TUdbDir.SetLat(ALat: Double);
begin
  FValue.Lat := Swap32(CoordAsInt(ALat));
end;

function TUdbDir.GetLon: Double;
begin
  result := CoordAsDec(Swap32(FValue.Lon));
end;

procedure TUdbDir.SetLon(ALon: Double);
begin
  FValue.Lon := Swap32(CoordAsInt(ALon));
end;

function TUdbDir.GetName: string;
const
  WideNullTerminator: TBytes = [0, 0];
begin
  if (IsTurn) then
    result := UdbDirTurn
  else
  begin
    case TripList.TripFileVersion.IsUcs4 of
      true:
        result := UCS4ByteArrayToString(FUdbDirName);
      false:
        result := PWideChar(Concat(FUdbDirName, WideNullTerminator)); // Make sure there ia a null terminator.
    end;
  end;
end;

function TUdbDir.GetDisplayLength: integer;
begin
  result := ByteLength(GetName);
  if (TripList.TripFileVersion.IsUcs4) then
    result := result * 2;
end;

function TUdbDir.GetNameLength: integer;
begin
  result := Length(FUdbDirName);
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

function TUdbDir.GetMapSegRoadFmt(FmtStr: string): string;
begin
  result := Format(FmtStr, [IntToHex(Swap32(UdbDirValue.SubClass.MapSegment), 8),
                            IntToHex(Swap32(UdbDirValue.SubClass.RoadId), 8)]);
end;

function TUdbDir.GetMapSegRoad: string;
begin
  result := GetMapSegRoadFmt('%s%s');
end;

function TUdbDir.GetMapSegRoadDisplay: string;
begin
  result := GetMapSegRoadFmt('%s %s');
end;

function TUdbDir.GetMapSegRoadExclBit: string;
begin
  // It is believed that the RoadId contains Flags. Mask them out for compare.
  result := IntToHex(Swap32(UdbDirValue.SubClass.MapSegment), 8);
  result := result + IntToHex(Swap32(UdbDirValue.SubClass.RoadId) and MapSegRoadMask, 8);
end;

function TUdbDir.GetPointType: string;
begin
  if not (IntToIdent(FValue.SubClass.PointType, result, UdbDirTypeMap)) then
    result := StrUnknown;
  result := Format('%s (0x%s)', [result, IntToHex(FValue.SubClass.PointType, 2)]);
end;

function TUdbDir.GetDirection: string;
begin
  if not (IntToIdent(FValue.SubClass.Direction, result, DirectionMap)) then
    result := StrUnknown;
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
const
  OffsWide = 2;
  OffsUcs4 = 4;
begin
  if (Length(FUdbDirName) < OffsUcs4 + SizeOf(TurnMagic)) then
    exit(false);
  result := CompareMem(@TurnMagic[0], @FUdbDirName[OffsUcs4], SizeOf(TurnMagic)) or
            CompareMem(@TurnMagic[0], @FUdbDirName[OffsWide], SizeOf(TurnMagic));
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

procedure TUdbHandleValue.AllocUnknown(AModel: TTripModel = TTripModel.Unknown);
begin
  AllocUnknown2(TripVersion[AModel].Unknown2Size);
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
  if ((Offset + SizeOf(Cardinal)) > Length(Self.Unknown3)) then
    exit(0);

  PUpdVal := @Unknown3[Offset];
  result := PUpdVal^;
end;

function TUdbHandleValue.GetAvoidances(const Offset: integer): string;
var
  Avoidances: byte;
  Avoidance: integer;
begin
  result := '';
  try
    Avoidances := Unknown3[Offset];
    if ((Avoidances and Ord(avValid)) = 0) then
      exit;

    for Avoidance := Low(AvoidanceMap) to High(AvoidanceMap) do
    begin
      if ((Avoidances and AvoidanceMap[Avoidance].Value) = AvoidanceMap[Avoidance].Value) then
      begin
        if (result <> '') then
          result := result + ', ';
        result := result + AvoidanceMap[Avoidance].Name;
      end;
    end;

  finally
    if (result = '') then
      result := DupeString('-', 10);
  end;
end;

function TUdbHandleValue.GetShapeBitMapLen(const Offset: integer): integer;
var
  Index: integer;
begin
  result := 0;
  Index := Offset;
  while ((Index + SizeOf(byte)) < Length(Self.Unknown3)) do
  begin
    Inc(Index);
    if (Unknown3[Index] = 0) then
      exit(Index - Offset);
  end;
end;

function TUdbHandleValue.GetShapeBitMap(const Offset: integer): string;
var
  Len: integer;
begin
  Len := GetShapeBitMapLen(Offset);
  SetLength(result, Len * 2);
  BinToHex(Unknown3[Offset], PChar(result), Len);
  result := '0x' + result;
end;

constructor TmUdbDataHndl.Create(AHandleId: Cardinal;
                                 AModel: TTripModel = TTripModel.Unknown;
                                 ForceRecalc: boolean = true);
begin
  inherited Create(GetKey, SizeOf(FValue), dtUdbHandle); // Will get Length later, Via Calculate
  FUdbHandleId := AHandleId; // Only value seen = 1
  Fvalue := Default(TUdbHandleValue);

  FUdbPrefValue := Default(TUdbPrefValue);
  FUdbPrefValue.DataType := dtUdbPref;
  FUdbPrefValue.PrefId := FUdbHandleId;

  FValue.CalcStatus := CalculationMagic[AModel];
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
  AnUdbDir.SetTripList(TripList);
  FUdbDirList.Add(AnUdbDir);
end;

// Compute size of Unknown3
// Take the UdbHandleSize
// Substract the fixed part (CalcStatus + Unknown2 + UdbDirCount)
// Substract the UdbDirSize * UdbDirCount
// Must be the length of Unknown3
function TmUdbDataHndl.ComputeUnknown3Size(AModel: TTripModel): integer;
var
  TotalHandleSize: integer;
  UdbDirSize: integer;
begin
  TotalHandleSize := Swap32(integer(FValue.UdbHandleSize)) -
                     (SizeOf(FValue.CalcStatus) + Length(FValue.Unknown2) + SizeOf(FValue.UDbDirCount));
  UdbDirSize := (FValue.UDbDirCount * (SizeOf(TUdbDirFixedValue) + TripVersion[AModel].UdbDirUnknown2Size + UdbDirNameSize[AModel]));
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
  FirstUdbDirNameSize: integer;
begin
  result := TTripModel.Unknown;

  FirstUdbDirNameSize := 0;
  if (Items.Count > 0) then
    FirstUdbDirNameSize := Length(Items[0].FUdbDirName);

  // Does the Calculation Magic match?
  // Is the size of Unknown3 a known size of a model?
  // Is the size of UdbDirNameSize a known size of a model?
  for AModel := Low(TTripModel) to High(TTripModel) do
  begin
    if (CalculationMagic[AModel] <> CalcUndef) and // Dont check zeroes
       (FValue.CalcStatus <> CalcUndef) and
       (FValue.CalcStatus <> CalculationMagic[AModel]) then
      continue;

    if (FirstUdbDirNameSize <> UdbDirNameSize[AModel]) then
      continue;

    if (Length(FValue.Unknown3) = Unknown3Size[AModel]) then
      exit(AModel);
  end;
end;

function TmUdbDataHndl.GetDistOffset: integer;
begin
  result := TripList.TripFileVersion.Unknown3DistOffset;
end;

function TmUdbDataHndl.GetTimeOffset: integer;
begin
  result := TripList.TripFileVersion.Unknown3TimeOffset;
end;

function TmUdbDataHndl.GetShapeOffset: integer;
begin
  result := TripList.TripFileVersion.Unknown3ShapeOffset;
end;

function TmUdbDataHndl.GetMagicOffset: integer;
begin
  result := TripList.TripFileVersion.Unknown3MagicOffset;
end;

function TmUdbDataHndl.GetAvoidancesOffset: integer;
begin
  result := TripList.TripFileVersion.Unknown3MagicOffset + SizeOf(Cardinal);
end;

function TmUdbDataHndl.GetBoundsOffset(Index: Integer): integer;
begin
  result := TripList.TripFileVersion.Unknown3BoundsOffset + (Index * SizeOf(Cardinal));
end;

function TmUdbDataHndl.GetFloatOffset: integer;
begin
  result := TripList.TripFileVersion.Unknown3FloatOffset;
end;

function TmUdbDataHndl.GetBoundsMin: string;
begin
  result := FormatMapCoords(CoordAsDec(FValue.GetUnknown3(BoundsOffset[2])),
                            CoordAsDec(FValue.GetUnknown3(BoundsOffset[3])));
end;

function TmUdbDataHndl.GetBoundsMax: string;
begin
  result := FormatMapCoords(CoordAsDec(FValue.GetUnknown3(BoundsOffset[0])),
                            CoordAsDec(FValue.GetUnknown3(BoundsOffset[1])));
end;

function TmUdbDataHndl.GetBoundsTopLeft: string;
begin
  if (FValue.GetUnknown3(BoundsOffset[0]) = 0) and
     (FValue.GetUnknown3(BoundsOffset[3]) = 0) then
    exit('');

  result := FormatMapCoords(CoordAsDec(FValue.GetUnknown3(BoundsOffset[0])),
                            CoordAsDec(FValue.GetUnknown3(BoundsOffset[3])))
end;

function TmUdbDataHndl.GetBounds: string;
begin
  result := Format('%s, %s', [GetBoundsMin, GetBoundsMax]);
end;

function TmUdbDataHndl.NineFloats: string;
var
  TmpFloats: array[0..8] of single;
  Index: Integer;
  Fmt: string;
begin
  result := '';
  if (Length(FValue.Unknown3) < FloatOffset + SizeOf(TmpFloats)) then
    exit;

  CopyMemory(@TmpFloats[0], @FValue.Unknown3[FloatOffset], SizeOf(TmpFloats));
  Fmt := '%1.6f';
  for Index := Low(TmpFloats) to High(TmpFloats) do
  begin
    result := result + Format(Fmt, [TmpFloats[Index]]);
    if (Index = Low(TmpFloats)) then
      Fmt := ', ' + Fmt;
  end;
end;

{*** AllRoutesList ***}
procedure TmAllRoutesValue.SwapCardinals;
begin
  UdbHandleCount := Swap32(UdbHandleCount);
end;

constructor TmAllRoutes.Create;
begin
  inherited Create(GetKey, 0, dtList); // Will get Length later, Via Calculate
  FValue := Default(TmAllRoutesValue);
  FUdBList := TUdbHandleList.Create;
end;

// This method allocates and reads the data according to the known sizes for the model to check
// The Size of the unknown3 block should match AnUdbHandle.ComputeUnknown3Size, possibly allowing a trailer
// Anyway we should find the UdbDirMagic $51590469
function TmAllRoutes.ModelFromUnknown3Size(AModel: TTripModel; AnUdbHandle: TmUdbDataHndl; AStream: TStream): TTripModel;
var
  Diff: integer;
  SavePos: int64;
  FirstUdbDir: TUdbDirFixedValue;
begin
  result := AModel;
  AnUdbHandle.FValue.AllocUnknown2(TripList.TripFileVersion.Unknown2Size);              // Read the unknown2 size for this TripVersion
  AStream.Read(AnUdbHandle.FValue.Unknown2[0], Length(AnUdbHandle.FValue.Unknown2));
  AStream.Read(AnUdbHandle.FValue.UDbDirCount, SizeOf(AnUdbHandle.FValue.UDbDirCount)); // Need the UdbDirCount to calculate
  AnUdbHandle.FValue.AllocUnknown3(Unknown3Size[AModel]);                               // Read the unknown3 size for this model
  AStream.Read(AnUdbHandle.FValue.Unknown3[0], Length(AnUdbHandle.FValue.Unknown3));

  Diff := AnUdbHandle.ComputeUnknown3Size(AModel) - Unknown3Size[AModel];

  // Diff must be 0, if no trailer allowed.
  if (TripList.TripFileVersion.HandleTrailer = false) then
  begin
    if (Diff <> 0) then
      exit(TTripModel.Unknown);
  end
  else
  begin
    // Allow a trailer for the Zumo 3x0, 590 and nuvi 2595
    if (Diff < 0) or
       (Diff > (SizeOf(TUdbDirFixedValue) +
                TripList.TripFileVersion.Unknown2Size) +
                UdbDirNameSize[AModel]) then
    exit(TTripModel.Unknown);
  end;

  // Check for UdbDirMagic in first UdbDir. If there are UDBdir's!
  if (AnUdbHandle.FValue.UDbDirCount > 0) then
  begin
    SavePos := AStream.Position;
    try
      if (AStream.Read(FirstUdbDir, SizeOf(FirstUdbDir)) <> SizeOf(FirstUdbDir)) then
        exit(TTripModel.Unknown);
      if (Swap32(FirstUdbDir.UdbDirMagic) <> UdbDirMagic) then
        exit(TTripModel.Unknown);
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
  SavePosCalcMagic, SavePos: Cardinal;
  ValueLen: Cardinal;
  DataType: Byte;
  Initiator: AnsiChar;

  UdbDirCnt, RtePtCnt: integer;
  PrevUdbDir, RtePtUdbDir, AnUdbDir: TUdbDir;
  AModel: TTripModel;
  Diff: Int64;
  TripData: TTripInfoData;
  TripKey: TTripInfoKey;
begin
  inherited InitFromStream(AName, SizeOf(FValue), ADataType, AStream);
  FUdBList := TUdbHandleList.Create;

  // Count of Udb's
  AStream.Read(FValue.UdbHandleCount, SizeOf(FValue.UdbHandleCount));
  FValue.UdbHandleCount := Swap32(FValue.UdbHandleCount);

  TripKey := Default(TTripInfoKey);
  RtePtCnt := 0;
  for UdbHandleCnt := 0 to FValue.UdbHandleCount -1 do
  begin
    TripKey.SegmentId := UdbHandleCnt;
    AnUdbHandle := TmUdbDataHndl.Create(UdbHandleCnt);
    AnUdbHandle.SetTripList(TripList);

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

    // Check for Calculation Magic and known unknown3 size
    SavePosCalcMagic := AStream.Position;
    for AModel := Low(TTripModel) to High(TTripModel) do
    begin
      if (CalculationMagic[AModel] <> CalcUndef) and
         (AnUdbHandle.FValue.CalcStatus <> CalcUndef) and
         (AnUdbHandle.FValue.CalcStatus <> CalculationMagic[AModel]) then
        continue;

      // Reposition stream
      AStream.Seek(SavePosCalcMagic, TSeekOrigin.soBeginning);

      // Does the calculation match this model?
      if (AModel = ModelFromUnknown3Size(AModel, AnUdbHandle, AStream)) then
      begin
        if (TripList.TripModel = TTripModel.Unknown) and
           (AModel <> TTripModel.Unknown) then
          TripList.TripModel := AModel;
        break;
      end;
    end;
    AnUdbHandle.FValue.SwapCardinals;

    PrevUdbDir := nil;
    RtePtUdbDir := nil;
    for UdbDirCnt := 0 to AnUdbHandle.FValue.UDbDirCount -1 do
    begin
      TripKey.UdbId := UdbDirCnt;
      AnUdbDir := TUdbDir.Create('');
      AnUdbDir.SetTripList(TripList);
      AStream.Read(AnUdbDir.FValue, SizeOf(AnUdbDir.FValue));
      SetLength(AnUdbDir.FUnknown2, TripList.TripFileVersion.UdbDirUnknown2Size);
      AStream.Read(AnUdbDir.FUnknown2[0], Length(AnUdbDir.FUnknown2));
      SetLength(AnUdbDir.FUdbDirName, UdbDirNameSize[TripList.TripModel]);
      AStream.Read(AnUdbDir.FUdbDirName[0], Length(AnUdbDir.FUdbDirName));
      AnUdbDir.FValue.SwapCardinals;

      AnUdbHandle.Add(AnUdbDir);

      if (PrevUdbDir <> nil) then
      begin
        TripData := Default(TTripInfoData);
        if (PrevUdbDir.FValue.SubClass.IsKnownRoutePoint) then
        begin
          RtePtUdbDir := PrevUdbDir;

          Inc(RtePtCnt);
          TripKey.RoutePointId := RtePtCnt;
        end
        else
        begin
          if (RtePtUdbDir = nil) then // Failsafe.
            RtePtUdbDir := PrevUdbDir;

          TripData.Time := PrevUdbDir.FValue.Time;
          TripData.Dist := CoordDistance(PrevUdbDir.Coords, AnUdbDir.Coords, TDistanceUnit.duKm);
        end;
        TripData.RoutePoint := RtePtUdbDir.GetName;
        TripData.MapSegRoadId := PrevUdbDir.MapSegRoadDisplay;
        TripData.Description := PrevUdbDir.GetName;
        TripData.Coords := PrevUdbDir.MapCoords;

        AddToTripInfo(Triplist.FTripInfoList,
                      TripKey,
                      TripData);
      end;
      PrevUdbDir := AnUdbDir;
    end;

    AddUdbHandle(AnUdbHandle);
    Diff := (SavePos + ValueLen - SizeOf(Initiator)) - AStream.Position;
    if (Diff > 0) and
       (TripList.TripFileVersion.HandleTrailer) then // The Zumo 3x0, 590 and Nuvi 2595 can have trailer bytes.
    begin
      SetLength(AnUdbHandle.FTrailer, Diff);
      AStream.Read(AnUdbHandle.FTrailer[0], Length(AnUdbHandle.FTrailer));
      continue;
    end;

    // Should not occur for known models
    if (Diff <> 0) then
    begin
      BreakPoint;
      // Adjust Unknown3 so the next UdbHandle starts at the expected offset.
      // Model Unknown has zeroes for UdbDirNameSize and Unknown3, so expect > 0
      if (Length(AnUdbHandle.FValue.Unknown3) + Diff > 0) then
        SetLength(AnUdbHandle.FValue.Unknown3, (Length(AnUdbHandle.FValue.Unknown3) + Diff));
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
  AnUdbHandle.SetTripList(TripList);
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
  FTripInfoList := TTripInfoList.Create([doOwnsValues]);

  FHeader := nil;
  TripModel := TTripModel.Unknown;
end;

constructor TTripList.Create(AModel: TTripModel);
begin
  Create;
  TripModel := AModel;
end;

destructor TTripList.Destroy;
begin
  Clear;

  FItemList.Free;
  FTripInfoList.Free;
  inherited Destroy;
end;

procedure TTripList.Clear;
var
  ANitem: TBaseItem;
begin
  FTripInfoList.Clear;

  if (Assigned(ItemList)) then
  begin
    for ANitem in ItemList do
      FreeAndNil(ANitem);

    ItemList.Clear;
  end;

  if (Assigned(Header)) then
    FreeAndNil(Header);

end;

procedure TTripList.SetHeader(AHeader: THeader);
begin
  FHeader := AHeader;
end;

function TTripList.Add(ANItem: TBaseItem): TBaseItem;
begin
  ANItem.SetTripList(Self);
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

  TripModel := GetTripModelFromUDB;

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

  FSubLength := 0;
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
  RoutePreferences := GetItem(TmRoutePreferences.GetKey) as TmRoutePreferences;
  if (RoutePreferences = nil) then
    exit;
  RoutePreferencesAdventurousMode := GetItem(TmRoutePreferencesAdventurousMode.GetKey) as TmRoutePreferencesAdventurousMode;
  if (RoutePreferencesAdventurousMode = nil) then
    exit;

  Locations := GetItem(TmLocations.GetKey) as TmLocations;
  if (Locations = nil) then
    exit;
  RoutePointList := TList<TLocation>.Create;
  try
    for ViaPt := 1 to Locations.ViaPointCount do
    begin
      Locations.GetSegmentPoints(ViaPt, RoutePointList);
      Location := RoutePointList[0];
      Location.RoutePref := RoutePreferences.GetRoutePref(ViaPt);
      if (Location.RoutePref = TRoutePreference.rmAdventurous) then
        Location.AdvLevel := RoutePreferencesAdventurousMode.GetRoutePref(ViaPt)
      else
        Location.AdvLevel := TAdvlevel.advNA;
    end;
  finally
    RoutePointList.Free;
  end;
end;

procedure TTripList.UpdLocsFromAllLinks;
var
  MAllLinks: TmAllLinks;
  Link: Tlink;
  AnItem: TBaseItem;
  Locations: TmLocations;
  ViaPt: integer;
  RoutePointList: TList<TLocation>;
  Location: TLocation;
begin
  MAllLinks := GetItem(TmAllLinks.GetKey) as TmAllLinks;
  if (MAllLinks = nil) then
    exit;

  Locations := GetItem(TmLocations.GetKey) as TmLocations;
  if (Locations = nil) then
    exit;

  RoutePointList := TList<TLocation>.Create;
  try
    for ViaPt := 1 to Locations.ViaPointCount do
    begin
      if (ViaPt > MAllLinks.FItemList.Count) then
        break;
      Link := Tlink(MAllLinks.FItemList[ViaPt -1]);

      Locations.GetSegmentPoints(ViaPt, RoutePointList);
      Location := RoutePointList[0];
      if (Location = nil) then
        break;
      for AnItem in Link.Items do
      begin
        if (AnItem is TmRoutePreference) then
          Location.RoutePref := TmRoutePreference.RoutePreference(TmRoutePreference(AnItem).AsString, TripModel);
        if (AnItem is TmTransportationMode) then
          Location.TransportMode := TmTransportationMode.TransPortMethod(TmTransportationMode(AnItem).AsString);
      end;
      if (ViaPt = 1) then
      begin
        MAllLinks.DefRoutePref := Location.RoutePref;
        MAllLinks.DefTransportMode := Location.TransportMode;
      end;
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
  mLocations: TmLocations;
begin
  if not TProcessOptions.SafeModel2Write(TripModel) then
    raise Exception.Create(Format('Writing not supported for model: %s', [ModelDescription]));

  mLocations := GetItem(TmLocations.GetKey) as TmLocations;
  if (mLocations <> nil) and // No Locations, cant be too many...
     (TProcessOptions.MaxViaPoints > 0) and
     (mLocations.GetViaPointCount > TProcessOptions.MaxViaPoints) then
    MessageDlg(Format('Warning: Too many Via points (%d including Begin/End) in: %s',
                      [mLocations.GetViaPointCount, ExtractFileName(AFile)]),
               TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);

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

procedure TTripList.ExportTripInfo(AFile: string);
begin
  ExportTripInfoToCSV(FTripInfoList, AFile);
end;

// Gets an item scanning the stream. Future use.
function TTripList.ScanStream(AStream: TStream; AKeyName: ShortString): TBaseItem;
var
  AHeader: THeaderValue;
  BytesRead: integer;
  KeyLen: Cardinal;
  KeyName: ShortString;
  SavePos, SaveTripPos: Cardinal;
  ValueLen: Cardinal;
  DataType: Byte;
  Initiator: AnsiChar;
begin
  result := nil;
  SaveTripPos := AStream.Position;
  try
    AStream.Position := 0;
    // Skip header
    BytesRead := AStream.Read(AHeader, SizeOf(AHeader));
    if (BytesRead <> SizeOf(AHeader)) or
       (AHeader.Id <> 'TRPL') then
       exit;

    while true do
    begin
      BytesRead := ReadKeyVAlues(AStream,
                                 Initiator,
                                 KeyLen,
                                 KeyName,
                                 ValueLen,
                                 DataType);
      if (BytesRead = 0) then
        exit;
      SavePos := AStream.Position;

      if (KeyName = AKeyName) then
      begin
        result := CreateBaseItemByName(Self, KeyName, ValueLen - SizeOf(Initiator), DataType, AStream);
        exit;
      end;

      // Point to next item
      AStream.Seek(SavePos + ValueLen - SizeOf(Initiator), TSeekOrigin.soBeginning);
    end;
  finally
    AStream.Position := SaveTripPos;
  end;
end;

procedure TTripList.SetTripFileVersionFromTrip(AStream: TStream);
var
  mVersionNumber: TmVersionNumber;
begin
  FTripFileVersion := TripVersion[TTripModel.Unknown];
  mVersionNumber := TmVersionNumber(ScanStream(AStream, TmVersionNumber.GetKey));
  if not Assigned(mVersionNumber) then
    exit;
  try
    FTripFileVersion.Size     := Swap32(mVersionNumber.FValue.Size);
    FTripFileVersion.Version  := mVersionNumber.FValue.VersionB;
  finally
    mVersionNumber.Free;
  end;
end;

procedure TTripList.SetTripFileVersion(ATripFileVersion: TTripVersion);
begin
  FTripFileVersion := ATripFileVersion;
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
  TripModel := TTripModel.Unknown;

  AStream.Position := 0;
  BytesRead := AStream.Read(AHeader, SizeOf(AHeader));
  if (BytesRead <> SizeOf(AHeader)) or
     (AHeader.Id <> 'TRPL') then
     exit(false);

  SetHeader(THeader.Create);
  AHeader.SubLength := Swap32(AHeader.SubLength);
  AHeader.TotalItems := Swap32(AHeader.TotalItems);
  Header.FValue := AHeader;

  // Scan stream for mVersionNumber. Needed to correctly set UCS4 and Unknown2Size
  SetTripFileVersionFromTrip(AStream);

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
    ABaseItem.SetTripList(Self);

    // Should not occur
    if (AStream.Position <> SavePos + ValueLen - SizeOf(Initiator)) then
    begin
      BreakPoint;
      AStream.Seek(SavePos + ValueLen - SizeOf(Initiator), TSeekOrigin.soBeginning);
    end;

  end;
  UpdLocsFromRoutePrefs;
  UpdLocsFromAllLinks;
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
  ALocations := TmLocations(GetItem(TmLocations.GetKey));
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
  ALocations := TmLocations(GetItem(TmLocations.GetKey));
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
  result := Default(TOSMRoutePoint);
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
{$IFDEF OSMMAP}
var
  Coords, Color, LayerName, RoutePointName: string;
  EscapedTripName: string;
  LayerId: integer;
  AllRoutes: TmAllRoutes;
  UdbDataHndl: TmUdbDataHndl;
  UdbDir: TUdbDir;
  Locations: TmLocations;
  Location: TBaseItem;
  ANItem: TBaseItem;
  HasUdbs: boolean;
  LatMin, LonMin: double;
  LatMax, LonMax: double;
{$ENDIF}
begin
{$IFDEF OSMMAP}
  OutStringList.Clear;
  EscapedTripName := EscapeDQuote(TripName);
  HasUdbs := false;

  AllRoutes := TmAllRoutes(GetItem(TmAllRoutes.GetKey));
  if (Assigned(AllRoutes)) then
  begin
    for UdbDataHndl in AllRoutes.Items do
    begin
      LatMin := CoordAsDec(UdbDataHndl.FValue.GetUnknown3(UdbDataHndl.GetBoundsOffset(0)));
      LonMin := CoordAsDec(UdbDataHndl.FValue.GetUnknown3(UdbDataHndl.GetBoundsOffset(1)));
      LatMax := CoordAsDec(UdbDataHndl.FValue.GetUnknown3(UdbDataHndl.GetBoundsOffset(2)));
      LonMax := CoordAsDec(UdbDataHndl.FValue.GetUnknown3(UdbDataHndl.GetBoundsOffset(3)));
      if (LatMin <> 0) and
         (LonMin <> 0) and
         (LatMax <> 0) and
         (LatMax <> 0) then
      begin
        OutStringList.Add(Format('    AddTrkPoint(%s);', [FormatMapCoords(LatMin, LonMin)]) );
        OutStringList.Add(Format('    AddTrkPoint(%s);', [FormatMapCoords(LatMin, LonMax)]) );
        OutStringList.Add(Format('    AddTrkPoint(%s);', [FormatMapCoords(LatMax, LonMax)]) );
        OutStringList.Add(Format('    AddTrkPoint(%s);', [FormatMapCoords(LatMax, LonMin)]) );
        OutStringList.Add(Format('    AddTrkPoint(%s);', [FormatMapCoords(LatMin, LonMin)]) );
        OutStringList.Add(Format('    CreateTrack("Bounds %s", ''%s'', true);', [EscapedTripName, Bounds_Color]));
      end;
    end;
    for UdbDataHndl in AllRoutes.Items do
    begin
      HasUdbs := HasUdbs or (UdbDataHndl.Items.Count > 0);
      for UdbDir in UdbDataHndl.Items do
        OutStringList.Add(Format('    AddTrkPoint(%s);', [FormatMapCoords(UdbDir.Lat, UdbDir.Lon)]) );
    end;
  end;

  Locations := TmLocations(GetItem(TmLocations.GetKey));
  if (Assigned(Locations)) then
  begin
    for Location in Locations.Locations do
    begin
      if (Location is TLocation) then
      begin
        Coords := '';
        RoutePointName := '';
        LayerId := 0;
        LayerName := Format('Shape: %s', [EscapedTripName]);
        Color := 'blue';

        for ANItem in TLocation(Location).LocationItems do
        begin
          if (ANItem is TmAttr) then
          begin
            if (Pos('Via', TmAttr(ANItem).AsString) = 1) then
            begin
              LayerName := Format('Via: %s', [EscapedTripName]);
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
    OutStringList.Add(Format('    CreateTrack("%s", ''%s'');', [EscapedTripName, HTMLColor]));
  end;
{$ENDIF}
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

procedure TTripList.SetSegmentRoutePrefs(Locations: TmLocations; ProcessOptions: TObject);
var
  ViaPt, SegmentCount: integer;
  RoutePreferences: array of WORD;
  RoutePreferencesAdventurous: array of WORD;
  RoutePreferencesAdventurousInclMap: array of WORD;
  TmpStream, TmpMapStream: TMemoryStream;
  RoutePointList: TList<TLocation>;
  Location: TLocation;
  InclRoadsExists: boolean;
  Popular, Scenic, Hills: boolean;
begin
  if (GetItem(TmRoutePreferences.GetKey) = nil) then
    exit;

  SegmentCount := Locations.ViaPointCount -1;
  if (SegmentCount < 1) then
    exit;
  InclRoadsExists := GetSegmentInclRoads(Popular, Scenic, Hills);
  // If no Including roads exists (CreateTemplate)
  // or setting from FrmEditRoutePref
  if (InclRoadsExists = false) or
     (TProcessOptions(ProcessOptions).AdvSetPrefRoads) then
  begin
    Popular := TProcessOptions(ProcessOptions).AdvInclPopular;
    Scenic := TProcessOptions(ProcessOptions).AdvInclScenic;
    Hills := TProcessOptions(ProcessOptions).AdvInclHills;
  end;

  RoutePointList := TList<TLocation>.Create;
  TmpStream := TMemoryStream.Create;
  TmpMapStream := TMemoryStream.Create;
  try
    SetLength(RoutePreferences, SegmentCount);
    SetLength(RoutePreferencesAdventurous, SegmentCount);
    SetLength(RoutePreferencesAdventurousInclMap, SegmentCount);

    // Set RoutePrefs from location
    for ViaPt := 0 to SegmentCount -1 do
    begin
      Locations.GetSegmentPoints(ViaPt +1, RoutePointList);
      Location := RoutePointList[0];
      RoutePreferences[ViaPt] := Swap(DefRoutePref + Ord(Location.RoutePref));
      case (Location.RoutePref) of
        TRoutePreference.rmAdventurous:
          begin
            if (Location.AdvLevel = TAdvlevel.advNA) then
              Location.AdvLevel := TProcessOptions(ProcessOptions).DefAdvLevel;

            RoutePreferencesAdventurous[ViaPt] := Swap(DefRoutePref + Ord(Location.AdvLevel));
            RoutePreferencesAdventurousInclMap[ViaPt] := Swap(DefRoutePrefInclMaps);
          end;
        else
          begin
            RoutePreferencesAdventurous[ViaPt] := Swap(DefRoutePrefAdv);
            RoutePreferencesAdventurousInclMap[ViaPt] := Swap(DefRoutePref);
          end;
      end;
    end;

    PrepStream(TmpStream, SegmentCount, RoutePreferences);
    SetRoutePref(TmRoutePreferences.GetKey, TmpStream);

    // RoutePrefs AdventurousMode
    PrepStream(TmpStream, SegmentCount, RoutePreferencesAdventurous);
    SetRoutePref(TmRoutePreferencesAdventurousMode.GetKey, TmpStream);

    // RoutePrefs not Included maps
    for ViaPt := 0 to High(RoutePreferences) do
      RoutePreferences[ViaPt] := Swap(DefRoutePref);
    PrepStream(TmpStream, SegmentCount, RoutePreferences);

    // RoutePrefs Included maps
    PrepStream(TmpMapStream, SegmentCount, RoutePreferencesAdventurousInclMap);

    // Popular Paths
    if (Popular) then
      SetRoutePref(TmRoutePreferencesAdventurousPopularPaths.GetKey, TmpMapStream)
    else
      SetRoutePref(TmRoutePreferencesAdventurousPopularPaths.GetKey, TmpStream);

    // Michelin Scenic
    if (Scenic) then
      SetRoutePref(TmRoutePreferencesAdventurousScenicRoads.GetKey, TmpMapStream)
    else
      SetRoutePref(TmRoutePreferencesAdventurousScenicRoads.GetKey, TmpStream);

    // Hills and Curves
    if (Hills) then
      SetRoutePref(TmRoutePreferencesAdventurousHillsAndCurves.GetKey, TmpMapStream)
    else
      SetRoutePref(TmRoutePreferencesAdventurousHillsAndCurves.GetKey, TmpStream);

  finally
    TmpStream.Free;
    TmpMapStream.Free;
    RoutePointList.Free;
  end;

  SetRoundTripPrefs(Locations, ProcessOptions); // XT3
end;

function TTripList.GetSegmentInclRoads(var Popular: boolean;
                                      var Scenic: boolean;
                                      var Hills: boolean): boolean;
var
  Segment, SegmentCount: Cardinal;
  Locations: TmLocations;
  mRoutePrefs: TmRoutePreferences;
  mPopular: TmRoutePreferencesAdventurousPopularPaths;
  mScenic: TmRoutePreferencesAdventurousScenicRoads;
  mHills: TmRoutePreferencesAdventurousHillsAndCurves;
begin
  result := false;
  Popular := false;
  Scenic := false;
  Hills := false;

  Locations := GetItem(TmLocations.GetKey) as TmLocations;
  SegmentCount := Locations.ViaPointCount -1;
  mRoutePrefs := GetItem(TmRoutePreferences.GetKey) as TmRoutePreferences;
  if (mRoutePrefs = nil) then
    exit;

  mPopular := GetItem(TmRoutePreferencesAdventurousPopularPaths.GetKey) as TmRoutePreferencesAdventurousPopularPaths;
  if (mPopular = nil) or
     (mPopular.Count < SegmentCount) then
    exit;
  mScenic := GetItem(TmRoutePreferencesAdventurousScenicRoads.GetKey) as TmRoutePreferencesAdventurousScenicRoads;
  if (mScenic = nil) or
     (mScenic.Count < SegmentCount) then
    exit;
  mHills := GetItem(TmRoutePreferencesAdventurousHillsAndCurves.GetKey) as TmRoutePreferencesAdventurousHillsAndCurves;
  if (mHills = nil) or
     (mHills.Count < SegmentCount) then
    exit;

  for Segment := 1 to SegmentCount do
  begin
    result := result or (mRoutePrefs.GetRoutePref(Segment) = TRoutePreference.rmAdventurous);
    Popular := Popular or (mPopular.GetRoutePrefByte(Segment) <> 0);
    Scenic := Scenic or (mScenic.GetRoutePrefByte(Segment) <> 0);
    Hills := Hills or (mHills.GetRoutePrefByte(Segment) <> 0);
  end;
end;

procedure TTripList.SetRoundTripPrefs(Locations: TmLocations; ProcessOptions: TObject);
const
  DefRoundTripRoadType        = $0201;
  DefRoundTripDirection       = $0501;
  DefRoundTripMethod          = $0301;
  DefRoundTripUnits           = $0201;
  DefRoundTripLengthSize: byte= SizeOf(Single);
  DefRoundTripLength: single  = -1;

var
  ViaPt, SegmentCount, SwapCount: Cardinal;
  RTRoadType:     array of WORD;
  RTDirection:    array of WORD;
  RTMethod:       array of WORD;
  RTUnits:        array of WORD;
  TmpLenStream:   TMemoryStream;
  TmpStream:      TMemoryStream;
  RoutePointList: TList<TLocation>;
begin
  if (GetItem(TmSerializedRoutePrefRoundTripRoadType.GetKey) = nil) then
    exit;

  SegmentCount := Locations.ViaPointCount -1;
  if (SegmentCount < 1) then
    exit;

  RoutePointList := TList<TLocation>.Create;
  TmpStream := TMemoryStream.Create;
  TmpLenStream := TMemoryStream.Create;
  try
    SetLength(RTRoadType,   SegmentCount);
    SetLength(RTDirection,  SegmentCount);
    SetLength(RTMethod,     SegmentCount);
    SetLength(RTUnits,      SegmentCount);

    SwapCount := Swap32(SegmentCount);
    TmpLenStream.Clear;
    TmpLenStream.Write(SwapCount, SizeOf(SwapCount));

    // Set RoundTrip Prefs from location
    for ViaPt := 0 to SegmentCount -1 do
    begin
      Locations.GetSegmentPoints(ViaPt +1, RoutePointList);
      RTRoadType[ViaPt]   := DefRoundTripRoadType;
      RTDirection[ViaPt]  := DefRoundTripDirection;
      RTMethod[ViaPt]     := DefRoundTripMethod;
      RTUnits[ViaPt]      := DefRoundTripUnits;
      TmpLenStream.Write(DefRoundTripLengthSize, SizeOf(DefRoundTripLengthSize));
      WriteSwap32(TmpLenStream, DefRoundTripLength);
    end;

    PrepStream(TmpStream, SegmentCount, RTRoadType);
    SetRoutePref(TmSerializedRoutePrefRoundTripRoadType.GetKey, TmpStream);

    PrepStream(TmpStream, SegmentCount, RTDirection);
    SetRoutePref(TmSerializedRoutePrefRoundTripDirection.GetKey, TmpStream);

    PrepStream(TmpStream, SegmentCount, RTMethod);
    SetRoutePref(TmSerializedRoutePrefRoundTripMethod.GetKey, TmpStream);

    PrepStream(TmpStream, SegmentCount, RTUnits);
    SetRoutePref(TmSerializedRoutePrefRoundTripUnits.GetKey, TmpStream);

    SetRoutePref(TmSerializedRoutePrefRoundTripLength.GetKey, TmpLenStream);

  finally
    TmpStream.Free;
    TmpLenStream.Free;
    RoutePointList.Free;
  end;
end;


procedure TTripList.AddLocation_XT(const Locations: TmLocations;
                                   const Location2Add: TLocation2Add);
begin
  Locations.AddLocation(TLocation.Create);

  Locations.Add(TmAttr.Create(Location2Add.RoutePoint));
  Locations.Add(TmIsDFSPoint.Create);
  Locations.Add(TmDuration.Create);
  Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
  Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
  Locations.Add(TmAddress.Create(Location2Add.Address));
  Locations.Add(TmIsTravelapseDestination.Create);
  Locations.Add(TmShapingRadius.Create);
  Locations.Add(TmName.Create(Location2Add.Name));
{$IFDEF TM_EXTENSIONS}
  Locations.Add(TBooleanItem.Create('mTM_Flag1', true));
{$ENDIF}
end;

procedure TTripList.AddLocation_XT2(const Locations: TmLocations;
                                    const Location2Add: TLocation2Add);
var
  TmpStream : TMemoryStream;
begin
  TmpStream := TMemoryStream.Create;
  try
    Locations.AddLocation(TLocation.Create(Location2Add.RoutePref, Location2Add.AdvLevel));

    PrepStream(TmpStream, [Swap32($00000008), Swap32($00000080), Swap32($00000080)]);
    Locations.Add(TmShapingCenter.Create(TmpStream.Size, $08, TmpStream));
    Locations.Add(TmAttr.Create(Location2Add.RoutePoint));
    Locations.Add(TmIsDFSPoint.Create);
    Locations.Add(TmDuration.Create);
    Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
    Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
    Locations.Add(TmAddress.Create(Location2Add.Address));
    Locations.Add(TmIsTravelapseDestination.Create);
    Locations.Add(TmShapingRadius.Create);
    Locations.Add(TmName.Create(Location2Add.Name));
  finally
    TmpStream.Free;
  end;
end;

procedure TTripList.AddLocation_XT3(const Locations: TmLocations;
                                    const Location2Add: TLocation2Add);
var
  TmpStream : TMemoryStream;
begin
  TmpStream := TMemoryStream.Create;
  try
    Locations.AddLocation(TLocation.Create(Location2Add.RoutePref, Location2Add.AdvLevel));

    Locations.Add(TmIsDFSPoint.Create);
    Locations.Add(TmIsTravelapseDestination.Create);
    Locations.Add(TmShapingRadius.Create);
    PrepStream(TmpStream, [Swap32($00000008), Swap32($00000080), Swap32($00000080)]);
    Locations.Add(TmShapingCenter.Create(TmpStream.Size, $08, TmpStream));
    Locations.Add(TmDuration.Create);
    Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
    Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
    Locations.Add(TmAttr.Create(Location2Add.RoutePoint));
    Locations.Add(TmAddress.Create(Location2Add.Address));
    Locations.Add(TmName.Create(Location2Add.Name));
  finally
    TmpStream.Free;
  end;
end;

procedure TTripList.AddLocation_Tread2(const Locations: TmLocations;
                                       const Location2Add: TLocation2Add);
var
  TmpStream : TMemoryStream;
begin
  TmpStream := TMemoryStream.Create;
  try
    Locations.AddLocation(TLocation.Create(Location2Add.RoutePref, Location2Add.AdvLevel));

    Locations.Add(TmIsTravelapseDestination.Create);
    Locations.Add(TmShapingRadius.Create);
    PrepStream(TmpStream, [Swap32($00000008), Swap32($00000080), Swap32($00000080)]);
    Locations.Add(TmShapingCenter.Create(TmpStream.Size, $08, TmpStream));
    Locations.Add(TmDuration.Create);
    Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
    Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
    Locations.Add(TmAttr.Create(Location2Add.RoutePoint));
    Locations.Add(TmAddress.Create(Location2Add.Address));
    Locations.Add(TmName.Create(Location2Add.Name));
  finally
    TmpStream.Free;
  end;
end;

procedure TTripList.AddLocation_Zumo346(const Locations: TmLocations;
                                        const Location2Add: TLocation2Add);
begin
  Locations.AddLocation(TLocation.Create);

  Locations.Add(TmAttr.Create(Location2Add.RoutePoint));
  Locations.Add(TmIsDFSPoint.Create);
  Locations.Add(TmDuration.Create);
  Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
  Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
  Locations.Add(TmAddress.Create(Location2Add.Address));
  Locations.Add(TmIsTravelapseDestination.Create);
  Locations.Add(TmShapingRadius.Create);
  Locations.Add(TmName.Create(Location2Add.Name));
end;

procedure TTripList.AddLocation_Zumo595(const Locations: TmLocations;
                                        const Location2Add: TLocation2Add);
begin
  Locations.AddLocation(TLocation.Create);
  Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
  Locations.Add(TmIsDFSPoint.Create);
  Locations.Add(TmDuration.Create);
  Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
  Locations.Add(TmName.Create(Location2Add.Name));
  Locations.Add(TmAddress.Create(Location2Add.Address));
  Locations.Add(TmAttr.Create(Location2Add.RoutePoint));
  Locations.Add(TmShapingRadius.Create);
end;

procedure TTripList.AddLocation_Zumo590(const Locations: TmLocations;
                                        const Location2Add: TLocation2Add);
begin
  Locations.AddLocation(TLocation.Create);
  Locations.Add(TmAddress.Create(Location2Add.Address));
  Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
  Locations.Add(TmDuration.Create);
  Locations.Add(TmIsDFSPoint.Create);
  Locations.Add(TmName.Create(Location2Add.Name));
  Locations.Add(TmPhoneNumber.Create(''));
  Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
  Locations.Add(TmShaping.Create(Location2Add.RoutePoint <> TRoutePoint.rpVia));
end;

procedure TTripList.AddLocation_Drive51(const Locations: TmLocations;
                                        const Location2Add: TLocation2Add);
begin
  Locations.AddLocation(TLocation.Create);
  Locations.Add(TmAttr.Create(Location2Add.RoutePoint));
  Locations.Add(TmDuration.Create);
  Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
  Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
  Locations.Add(TmAddress.Create(Location2Add.Address));
  Locations.Add(TmIsTravelapseDestination.Create);
  Locations.Add(TmShapingRadius.Create);
  Locations.Add(TmName.Create(Location2Add.Name));
end;

procedure TTripList.AddLocation_Drive66(const Locations: TmLocations;
                                        const Location2Add: TLocation2Add);

begin
  Locations.AddLocation(TLocation.Create(Location2Add.RoutePref, Location2Add.AdvLevel));
  Locations.Add(TmAttr.Create(Location2Add.RoutePoint));
  Locations.Add(TmDuration.Create);
  Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
  Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
  Locations.Add(TmAddress.Create(Location2Add.Address));
  Locations.Add(TmIsTravelapseDestination.Create);
  Locations.Add(TmShapingRadius.Create);
  Locations.Add(TmName.Create(Location2Add.Name));
end;

procedure TTripList.AddLocation_Zumo3x0(const Locations: TmLocations;
                                        const Location2Add: TLocation2Add);
begin
  Locations.AddLocation(TLocation.Create);
  Locations.Add(TmAddress.Create(Location2Add.Address));
  Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
  Locations.Add(TmDuration.Create);
  Locations.Add(TmName.Create(Location2Add.Name));
  Locations.Add(TmPhoneNumber.Create(''));
  Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
  Locations.Add(TmShaping.Create(Location2Add.RoutePoint <> TRoutePoint.rpVia));
end;

procedure TTripList.AddLocation_nuvi2595(const Locations: TmLocations;
                                         const Location2Add: TLocation2Add);
begin
  Locations.AddLocation(TLocation.Create(Location2Add.RoutePref));
  Locations.Add(TmAddress.Create(Location2Add.Address));
  Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
  Locations.Add(TmDuration.Create);
  Locations.Add(TmName.Create(Location2Add.Name));
  Locations.Add(TmPhoneNumber.Create(''));
  Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
end;

procedure TTripList.AddLocation_nuvi2599_57(const Locations: TmLocations;
                                            const Location2Add: TLocation2Add);
begin
  Locations.AddLocation(TLocation.Create(Location2Add.RoutePref));
  Locations.Add(TmAddress.Create(Location2Add.Address));
  Locations.Add(TmArrival.Create(Location2Add.DepartureDate));
  Locations.Add(TmAttr.Create(Location2Add.RoutePoint));
  Locations.Add(TmDuration.Create);
  Locations.Add(TmName.Create(Location2Add.Name));
  Locations.Add(TmScPosn.Create(Location2Add.Lat, Location2Add.Lon, ScPosnSize[TripModel]));
end;

procedure TTripList.AddLocation(const Locations: TmLocations; const Location2Add: TLocation2Add);
begin
  case TripModel of
    TTripModel.XT:
      AddLocation_XT(Locations, Location2Add);
    TTripModel.XT2:
      AddLocation_XT2(Locations, Location2Add);
    TTripModel.XT3:
      AddLocation_XT3(Locations, Location2Add);
    TTripModel.Tread2:
      AddLocation_Tread2(Locations, Location2Add);
    TTripModel.Zumo346:
      AddLocation_Zumo346(Locations, Location2Add);
    TTripModel.Zumo595:
      AddLocation_Zumo595(Locations, Location2Add);
    TTripModel.Zumo590:
      AddLocation_Zumo590(Locations, Location2Add);
    TTripModel.Drive51:
      AddLocation_Drive51(Locations, Location2Add);
    TTripModel.Drive66:
      AddLocation_Drive66(Locations, Location2Add);
    TTripModel.Zumo3x0:
      AddLocation_Zumo3x0(Locations, Location2Add);
    TTripModel.Nuvi2595:
      AddLocation_nuvi2595(Locations, Location2Add);
    TTripModel.Nuvi2599_57:
      AddLocation_nuvi2599_57(Locations, Location2Add);
    else
      raise exception.Create('AddLocation. Model not supported');
  end;
end;

procedure TTripList.ForceRecalc(const AModel: TTripModel = TTripModel.Unknown; ViaPointCount: integer = 0);
var
  AllRoutes: TBaseItem;
  AllLinks: TBaseItem;
  Index, RoutePntCnt: integer;
  ViaCount: integer;
  RoutePointList: TList<TLocation>;
  ALocation: TLocation;
  Locations: TBaseItem;
  AnUdbHandle: TmUdbDataHndl;
  ProcessOptions: TProcessOptions;
begin
  // TripModel to use
  TripModel := GetCalculationModel(AModel);

  // All Links
  AllLinks := InitAllLinks;

  // All Routes
  AllRoutes := InitAllRoutes;

  // Need locations
  Locations := GetItem(TmLocations.GetKey);

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
    // The Zumo recalculates all.
    for Index := 1 to ViaCount -1 do
    begin
      AnUdbHandle := TmUdbDataHndl.Create(1, TripModel);
      AnUdbHandle.SetTripList(Self);
      // Add udb's for all Via and Shaping found in Locations.
      // Will be discarded when recalculated on the Zumo.
      if (Assigned(Locations)) then
      begin
        TmLocations(Locations).GetSegmentPoints(Index, RoutePointList);

        // AllLinks
        if (Assigned(AllLinks)) then
          TmAllLinks(AllLinks).AddLink(Tlink.Create(TmAllLinks(AllLinks).DefRoutePref, TmAllLinks(AllLinks).DefTransportMode));

        for RoutePntCnt := 0 to RoutePointList.Count -1 do
        begin
          ALocation := RoutePointList[RoutePntCnt];
          AnUdbHandle.Add(TUdbDir.Create(TripModel, ProcessOptions.TripOption, ALocation));
          // Add 1 Dummy UDBdir
          if (RoutePntCnt = 0) then
            AnUdbHandle.Add(TUdbDir.Create(TripModel,
                                           TTripOption.ttCalc,
                                           'Dummy',     // Dummy SubClass with unlikely MapSegment/RoadId
                                           '00',        // RoadClass
                                           ALocation.LocationTmScPosn.Lat, ALocation.LocationTmScPosn.Lon));
        end;
      end;
      TmAllRoutes(AllRoutes).AddUdbHandle(AnUdbHandle);

    end;

    // Recreate RoutePreferences
    if (GetItem(TmTrackToRouteInfoMap.GetKey) <> nil) then
      TmTrackToRouteInfoMap(GetItem(TmTrackToRouteInfoMap.GetKey)).Clear;
    SetSegmentRoutePrefs(TmLocations(Locations), ProcessOptions);
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
  DayNumber := (GetItem(TmDayNumber.GetKey) as TmDayNumber);
  if Assigned(DayNumber) then
    DayNumber.AsByte := 0;

  // Create TrackToRouteInfoMap for XT2, XT3 and Tread2
  TrackToRouteInfoMap := GetItem(TmTrackToRouteInfoMap.GetKey) as TmTrackToRouteInfoMap;
  if Assigned(TrackToRouteInfoMap) and
     Assigned(RtePts) then
    TrackToRouteInfoMap.InitFromGpxxRpt(RtePts);

  // For XT
  PreserveTrackToRoute := GetItem(TmPreserveTrackToRoute.GetKey) as TmPreserveTrackToRoute;
  if Assigned(PreserveTrackToRoute) then
    PreserveTrackToRoute.AsBoolean := true;
end;

procedure TTripList.UpdateDistAndTime(TotalDist: single; TotalTime: Cardinal);
var
  TotalTripDistance: TmTotalTripDistance;
  TotalTripTime: TmTotalTripTime;
  Locations: TmLocations;
  RoutePoints: TList<TLocation>;
  StartLocation, EndLocation: TLocation;
  StartArrival, EndArrival: TmArrival;
begin
  TotalTripDistance := (GetItem(TmTotalTripDistance.GetKey) as TmTotalTripDistance);
  if (Assigned(TotalTripDistance)) then
    TotalTripDistance.AsSingle := TotalDist;
  TotalTripTime := (GetItem(TmTotalTripTime.GetKey) as TmTotalTripTime);
  if (Assigned(TotalTripTime)) then
    TotalTripTime.AsCardinal := TotalTime;

  // Update Arrival time of Destination.
  // Will list the trip as scheduled on the 3x0, 590 and nuvi 2595. (And maybe others)
  Locations := TmLocations(GetItem(TmLocations.GetKey));
  if not Assigned(Locations) then
    exit;

  RoutePoints := TList<TLocation>.Create;
  try
    Locations.GetRoutePoints(RoutePoints);
    if (RoutePoints.Count > 1) then
    begin
      StartLocation := RoutePoints[0];
      StartArrival := StartLocation.LocationTmArrival;
      if (StartArrival = nil) then
        exit;

      if (StartArrival.GetAsUnixDateTime <> 0 ) then
      begin
        EndLocation := RoutePoints[RoutePoints.Count -1];
        EndArrival := EndLocation.LocationTmArrival;
        if (EndArrival = nil) then
          exit;

        EndArrival.SetAsUnixDateTime(StartArrival.GetAsUnixDateTime + TotalTime);
      end;
    end;
  finally
    RoutePoints.Free;
  end;
end;

procedure TTripList.TripTrack(const AModel: TTripModel;
                              const RtePts: TObject;
                              const SubClasses: TStringList;
                              const GpxDist: double = 0);
var
  Locations: TBaseItem;
  RoutePointList: TList<TLocation>;
  ALocation: TLocation;
  AllLinks: TBaseItem;
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
  Locations := GetItem(TmLocations.GetKey);
  if not Assigned(Locations) then
    exit;

  // TripModel to use
  TripModel := GetCalculationModel(AModel);

  // All Links
  AllLinks := InitAllLinks;

  // All Routes
  AllRoutes := InitAllRoutes;
  AnUdbHandle := TmUdbDataHndl.Create(1, TripModel, false);
  AnUdbHandle.SetTripList(Self);
  ProcessOptions := TProcessOptions.Create;
  RoutePointList := TList<TLocation>.Create;
  try
    // Add begin
    TmLocations(Locations).GetSegmentPoints(1, RoutePointList);
    if (RoutePointList.Count = 0) then
      exit;

    ALocation := RoutePointList[0];
    AnUdbHandle.Add(TUdbDir.Create(TripModel, ProcessOptions.TripOption, ALocation));

    // AllLinks
    if (Assigned(AllLinks)) then
      TmAllLinks(AllLinks).AddLink(Tlink.Create(TmAllLinks(AllLinks).DefRoutePref, TmAllLinks(AllLinks).DefTransportMode));

    TotalTime := 0;
    TotalDist := 0;
    PrevUdbDir := nil;
    // Add intermediates
    for Index := 0 to SubClasses.Count -1 do
    begin
      GpxRptNode := TXmlVSNode(SubClasses.Objects[Index]);
      Coords.FromAttributes(GpxRptNode.AttributeList);
      AnUdbDir := TUdbDir.Create(TripModel,
                                 ProcessOptions.TripOption,
                                 Copy(SubClasses[Index], 5),    // SubClass to use in UdbDir
                                 Copy(SubClasses[Index], 1, 2), // RoadClass
                                 Coords.Lat, Coords.Lon);
      AnUdbHandle.Add(AnUdbDir);

      if (Assigned(PrevUdbDir)) then
      begin
        // Distance and time from Previous UdbDir
        CurDist := CoordDistance(PrevUdbDir.Coords, AnUdbDir.Coords, TDistanceUnit.duKm);
        PrevUdbDir.FValue.Time := Min($fffe, Round(ProcessOptions.ComputeTime(PrevUdbDir.RoadClass, CurDist)));

        // Totals for the UdbHdandle
        TotalTime := TotalTime + PrevUdbDir.FValue.Time;
        TotalDist := TotalDist + (CurDist * 1000);
      end;

      PrevUdbDir := AnUdbDir;
    end;

    // Add End
    TmLocations(Locations).GetSegmentPoints(2, RoutePointList);
    if (RoutePointList.Count = 0) then
      exit;

    ALocation := RoutePointList[0];
    AnUdbHandle.Add(TUdbDir.Create(TripModel, ProcessOptions.TripOption, ALocation));

    // Update Time and Dist
    AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.TimeOffset, TotalTime);
    AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.DistOffset, Round(TotalDist));

    // Add to AllRoutes
    TmAllRoutes(AllRoutes).AddUdbHandle(AnUdbHandle);

    // Update Dist and Time
    if (GpxDist <> 0) and
       (TotalDist <> 0) then
    begin
      TotalTime := Round(TotalTime / TotalDist * GpxDist);
      TotalDist := GpxDist;
    end;
    UpdateDistAndTime(TotalDist, TotalTime);

    // Mark as TripTrack
    SetPreserveTrackToRoute(RtePts);

    // Recreate RoutePreferences
    SetSegmentRoutePrefs(TmLocations(Locations), ProcessOptions);

  finally
    RoutePointList.Free;
    ProcessOptions.Free;
  end;
end;

procedure TTripList.SaveCalculated(const AModel: TTripModel;
                                   const RtePts: TObject);
var
  AllLinks: TBaseItem;
  AllRoutes: TBaseItem;
  SegmentId, UdbId: integer;
  ViaCount, RoutePointId: integer;
  RoutePointList: TList<TLocation>;
  ALocation: TLocation;
  Locations: TBaseItem;
  AnUdbHandle: TmUdbDataHndl;
  AnUdbDir, PrevUdbDir, RtePtUdbDir: TUdbDir;
  FirstRtePt, ScanRtePt, ScanGpxxRptNode, TMExtensions, TMRtePt, TMrpt, TMPrevrpt: TXmlVSNode;
  CMapSegRoad: string;
  PrevCoords, Coords: TCoords;
  TotalDist, UdbDist, CurDist: double;
  TotalTime, UdbTime: cardinal;
  ProcessOptions: TProcessOptions;
  TripKey: TTripInfoKey;
  TripData: TTripInfoData;
begin
  TotalTime := 0;
  TotalDist := 0;

  // TripModel to use
  TripModel := GetCalculationModel(AModel);

  // All Routes
  AllLinks := InitAllLinks;

  // All Routes
  AllRoutes := InitAllRoutes;

  // Need locations
  Locations := GetItem(TmLocations.GetKey);
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
  UdbId := 0;
  try
    TripKey := Default(TTripInfoKey);
    for SegmentId := 1 to ViaCount -1 do
    begin
      TripKey.SegmentId := SegmentId;
      AnUdbHandle := TmUdbDataHndl.Create(1, TripModel, ProcessOptions.TripOption = TTripOption.ttCalc);
      AnUdbHandle.SetTripList(Self);
      UdbDist := 0;
      UdbTime := 0;
      ScanRtePt := FirstRtePt;

      // TM Extensions?
      TMExtensions := nil;

      // Add udb's for all Via and Shaping found in Locations.
      // Add Subclasses from <gpxx:rpt>. Will be named RoadClass MapSegment RoadId
      TmLocations(Locations).GetSegmentPoints(SegmentId, RoutePointList);

      // AllLinks
      if (Assigned(AllLinks)) then
      begin
        if (RoutePointList.Count > 0) then
          TmAllLinks(AllLinks).AddLink(Tlink.Create(RoutePointList[0].FRoutePref, TmAllLinks(AllLinks).DefTransportMode))
        else
          TmAllLinks(AllLinks).AddLink(Tlink.Create(TmAllLinks(AllLinks).DefRoutePref, TmAllLinks(AllLinks).DefTransportMode));
      end;

      if (AnUdbHandle.ShapeOffset <> 0) then
        GenShapeBitmap(RoutePointList.Count -2, @AnUdbHandle.FValue.Unknown3[AnUdbHandle.ShapeOffset]);
      for RoutePointId := 0 to RoutePointList.Count -2 do
      begin
        TripKey.RoutePointId := RoutePointId;
        ALocation := RoutePointList[RoutePointId];
        RtePtUdbDir := TUdbDir.Create(TripModel, ProcessOptions.TripOption, ALocation);
        AnUdbHandle.Add(RtePtUdbDir);

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

        // TM Extensions?
        TMrpt := nil;
        TMPrevrpt := nil;
        TMExtensions := GetTMExtensionsNode(FirstRtePt);
        if (Assigned(TMExtensions)) then
          TMrpt := TMExtensions.Find('tm:rpt');

        // Init PrevCoords
        PrevCoords := Default(TCoords);
        ScanGpxxRptNode := GetFirstGpxxRptNode(ScanRtePt);
        if (ScanGpxxRptNode <> nil) then
          PrevCoords.FromAttributes(ScanGpxxRptNode.AttributeList);

        CurDist := 0;
        PrevUdbDir := nil;
        while (ScanGpxxRptNode <> nil) do
        begin
          Coords.FromAttributes(ScanGpxxRptNode.AttributeList);

          // Compute distance from prev udb
          CurDist := CurDist + CoordDistance(PrevCoords, Coords, TDistanceUnit.duKm);
          PrevCoords := Coords;

          // Create a UdbDir, for every <SubClass> node.
          CMapSegRoad := FindSubNodeValue(ScanGpxxRptNode, 'gpxx:Subclass');
          if (CMapSegRoad <> '') then
          begin
            AnUdbDir := TUdbDir.Create(TripModel,
                                       ProcessOptions.TripOption,
                                       Copy(CMapSegRoad, 5),    // SubClass to use in UdbDir
                                       Copy(CMapSegRoad, 1, 2), // RoadClass
                                       Coords.Lat, Coords.Lon);
            AnUdbHandle.Add(AnUdbDir);

            // Update the Time of the previous UdbDir
            if (Assigned(PrevUdbDir)) then
            begin
              Inc(UdbId);
              TripKey.UdbId := UdbId;

              TripData := Default(TTripInfoData);
              TripData.RoutePoint := RtePtUdbDir.GetName;
              TripData.RoadClass := StrToIntDef('$' + PrevUdbDir.RoadClass, 0);
              TripData.MapSegRoadId := PrevUdbDir.MapSegRoadDisplay;
              TripData.Description := TProcessOptions.DescriptionFromRoadClass(TripData.RoadClass);
              TripData.Coords := PrevUdbDir.MapCoords;
              TripData.Speed := ProcessOptions.SpeedFromRoadClass(PrevUdbDir.RoadClass);
              TripData.Dist := CurDist;
              TripData.Time := ProcessOptions.ComputeTime(PrevUdbDir.RoadClass, CurDist);

              PrevUdbDir.FValue.Time := AddToTripInfo(FTripInfoList,
                                                      TripKey,
                                                      TripData);
              // TM Extensions?
              if (Assigned(TMPrevrpt)) then
                PrevUdbDir.FValue.Time := StrToIntDef(TMPrevrpt.Attributes['time'], 0);

              // Totals for the UdbHandle
              UdbTime := UdbTime + PrevUdbDir.FValue.Time;
              UdbDist := UdbDist + (CurDist * 1000);
            end;

            // Reset Distance
            CurDist := 0;
            PrevUdbDir := AnUdbDir;
            // TM Extensions?
            TMPrevrpt := TMrpt;
          end;

          ScanGpxxRptNode := ScanGpxxRptNode.NextSibling;

          // TM Extensions?
          if (Assigned(TMrpt)) then
            TMrpt := TMrpt.NextSibling;
        end;

        // Totals for the UdbHdandle
        if (Assigned(PrevUdbDir)) then
        begin
          UdbTime := UdbTime + PrevUdbDir.FValue.Time;
          UdbDist := UdbDist + (CurDist * 1000);
        end;
      end;

      // Add end route point. Of this segment
      ALocation := RoutePointList[RoutePointList.Count -1];
      RtePtUdbDir := TUdbDir.Create(TripModel, ProcessOptions.TripOption, ALocation);
      AnUdbHandle.Add(RtePtUdbDir);

      TotalDist := TotalDist + UdbDist; // Totals for the Trip
      TotalTime := TotalTime + UdbTime;
      AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.TimeOffset, UdbTime);
      AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.DistOffset, Round(UdbDist));

      // Overrule by TM?
      if (Assigned(TMExtensions)) then
      begin
        TMRtePt := TMExtensions.Find('tm:rtept');
        if Assigned(TMRtePt) then
        begin
          AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.TimeOffset, StrToIntDef(TMRtePt.Attributes['time'], 0));
          AnUdbHandle.FValue.UpdateUnknown3(AnUdbHandle.DistOffset, StrToIntDef(TMRtePt.Attributes['dist'], 0));
        end;
      end;
      // Add to Allroutes
      TmAllRoutes(AllRoutes).AddUdbHandle(AnUdbHandle);

    end;

    if (ProcessOptions.TripOption in [TTripOption.ttTripTrackLoc, TTripOption.ttTripTrackLocPrefs]) then
      SetPreserveTrackToRoute(RtePts);

    // Update Dist and Time
    UpdateDistAndTime(TotalDist, TotalTime);

    // Recreate RoutePreferences
    SetSegmentRoutePrefs(TmLocations(Locations), ProcessOptions);
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
  AllRoutes := TmAllRoutes(GetItem(TmAllRoutes.GetKey));
  if not Assigned(AllRoutes) or
     not Assigned(AllRoutes.Items) or
     (AllRoutes.Items.Count = 0) then
    exit(nil);

  result := AllRoutes.Items[0];
end;

function TTripList.GetTripName: string;
begin
  result := GetValue(TmTripName.GetKey);
end;

// Get the model by checking the magic number, or the size.
// This function reports the model even if not calculated.
function TTripList.GetTripModelFromUDB: TTripModel;
var
  AnUdbHandle: TmUdbDataHndl;
begin
  // Default Unknown
  result := TTripModel.Unknown;

  // Try to get first TmUdbDataHndl
  AnUdbHandle := FirstUdbDataHndle;
  if not Assigned(AnUdbHandle) then
    exit;

  // Get model from UdbHandle
  result := AnUdbHandle.GetModel;

  // Zumo 595 and Drive 51 share the same UDBHandle size, but the Drive 51 has no mIsRoundTrip
  // Tread 2 and SmartDrive 66 share the same UDBHandle size, but the SmartDrive 66 has no mIsRoundTrip
  if (GetItem(TmIsRoundTrip.GetKey) = nil) then
    case result of
      TTripModel.Zumo595:
        result := TTripModel.Drive51;
      TTripModel.Tread2:
        result := TTripModel.Drive66;
    end
  else
    case result of
      TTripModel.Drive51:
        result := TTripModel.Zumo595;
      TTripModel.Drive66:
        result := TTripModel.Tread2;
    end;
end;

procedure TTripList.SetTripModel(ATripModel: TTripModel);
begin
  FTripModel := ATripModel;
  FModelDescription := GetEnumName(TypeInfo(TTripModel), Ord(FTripModel));
  TripFileVersion := TripVersion[FTripModel];
end;

function TTripList.GetTripModel: TTripModel;
begin
  result := FTripModel;
end;

// Is the TripList calculated?
function TTripList.GetIsCalculated: boolean;
var
  AnUdbHandle: TmUdbDataHndl;
  AnUdbDir: TUdbDir;
  DummySubClass: TSubClass;
begin
  result := false;

  AnUdbHandle := FirstUdbDataHndle;
  if not Assigned(AnUdbHandle) then
    exit;

  // Need at least 4 UdbDir's. This is the minimal sequence:
  // Route point 03
  // 2116 Start segment
  // 'Some other udbdir'
  // Route point 03
  if (AnUdbHandle.FValue.UDbDirCount < 4) then
    exit;

  // Check Dummy SubClass in the 2nd UdbDir. Is it the special DummySubClass?
  AnUdbDir :=  AnUdbHandle.Items[1];
  DummySubClass.Init(RecalcSubClass(''));
  if (DummySubClass.MapSegment = AnUdbDir.FValue.SubClass.MapSegment) and
     (DummySubClass.RoadId = AnUdbDir.FValue.SubClass.RoadId) then
    exit;

  result := true;
end;

function TTripList.GetExploreUUID: string;
begin
  result := GetValue(TmExploreUuid.GetKey);
end;

function TTripList.GetVehicleProfileName: string;
begin
  result := GetValue(TmVehicleProfileName.GetKey);
end;

function TTripList.GetVehicleGUID: string;
begin
  result := GetValue(TmVehicleProfileGuid.GetKey);
end;

function TTripList.GetAvoidancesChangedTimeAtSave: cardinal;
var
  AnItem: TmAvoidancesChangedTimeAtSave;
begin
  result := 0;
  AnItem := GetItem(TmAvoidancesChangedTimeAtSave.GetKey) as TmAvoidancesChangedTimeAtSave;
  if (AnItem <> nil) then
    result := AnItem.AsCardinal;
end;

function TTripList.GetVehicleHash: cardinal;
begin
  result := StrToIntDef(GetValue(TmVehicleProfileHash.GetKey), 0);
end;

function TTripList.GetCalculationModel(AModel: TTripModel): TTripModel;
begin
  result := AModel;

  // Is the model Unknown?
  if (result = TTripModel.Unknown) then
  begin
    // Use the current setting
    result := TripModel;

    // Try to get it from the UDB
    if (result = TTripModel.Unknown) then
      result := GetTripModelFromUDB;
  end;
end;

function TTripList.InitAllLinks: TBaseItem;
begin
  if (HasAllLinks[TripModel] = false) then
    exit(nil);

  result := GetItem(TmAllLinks.GetKey);
  if Assigned(result) then
    TmAllLinks(result).Clear;
end;

function TTripList.InitAllRoutes: TBaseItem;
var
  AnUdbHandle:  TmUdbDataHndl;
begin
  result := GetItem(TmAllRoutes.GetKey);
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
  SetHeader(THeader.Create);

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
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel)));
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmTotalTripDistance.Create);
  Add(TmFileName.Create(Format(TripFileName, [TripName])));
  Add(TmLocations.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmVersionNumber.Create(TripFileVersion));
  Add(TmAllRoutes.Create);
  Add(TmTripName.Create(TripName));
{$IFDEF TM_EXTENSIONS}
  Add(TBooleanItem.Create('mTM_Flag1', true));
{$ENDIF}
end;

procedure TTripList.CreateTemplate_XT2(const TripName, CalculationMode, TransportMode: string);
var
  TmpStream: TMemoryStream;
  Uuid: TGuid;
  ProcessOptions: TProcessOptions;
begin
  ProcessOptions := TProcessOptions.Create;
  TmpStream := TMemoryStream.Create;
  try
    SetHeader(THeader.Create);

    PrepStream(TmpStream, [$0000]);
    Add(TmGreatRidesInfoMap.Create(TmpStream.Size, dtRaw, TmpStream));
    Add(TmAvoidancesChangedTimeAtSave.Create(ProcessOptions.AvoidancesChangedTimeAtSave));
    TmpStream.Position := 0;
    Add(TmTrackToRouteInfoMap.Create(TmpStream.Size, dtRaw, TmpStream));
    Add(TmIsDisplayable.Create);
    Add(TmIsDeviceRoute.Create);
    Add(TmDayNumber.Create);
    Add(TmTripDate.Create);
    Add(TmOptimized.Create);
    Add(TmTotalTripTime.Create);
    Add(TmTripName.Create(TripName));
    Add(TmVehicleProfileGuid.Create(ProcessOptions.VehicleProfileGuid));
    Add(TmParentTripId.Create(0));
    Add(TmIsRoundTrip.Create);
    Add(TmVehicleProfileName.Create(ProcessOptions.VehicleProfileName));
    Add(TmAvoidancesChanged.Create);
    Add(TmParentTripName.Create(TripName));
    Add(TmVehicleProfileTruckType.Create(ProcessOptions.VehicleProfileTruckType));
    Add(TmVehicleProfileHash.Create(ProcessOptions.VehicleProfileHash));
    Add(TmRoutePreferences.Create);
    Add(TmImported.Create);
    Add(TmFileName.Create(Format(TripFileName, [TripName])));

    CheckHRGuid(CreateGUID(Uuid));
    Add(TmExploreUuid.Create( ReplaceAll(LowerCase(GuidToString(Uuid)), ['{','}'], ['',''], [rfReplaceAll])));
    Add(TmVersionNumber.Create(TripFileVersion));
    Add(TmRoutePreferencesAdventurousHillsAndCurves.Create);
    Add(TmTotalTripDistance.Create);
    Add(TmVehicleId.Create(ProcessOptions.VehicleId));
    Add(TmRoutePreferencesAdventurousScenicRoads.Create);
    Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
    Add(TmRoutePreferencesAdventurousPopularPaths.Create);
    Add(TmPartOfSplitRoute.Create);
    Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel)));
    Add(TmShowLastStopAsShapingPoint.Create);
    Add(TmRoutePreferencesAdventurousMode.Create);
    Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
    Add(TmLocations.Create);
  finally
    TmpStream.Free;
    ProcessOptions.Free;
  end;
end;

procedure TTripList.CreateTemplate_XT3(const TripName, CalculationMode, TransportMode: string);
var
  TmpStream: TMemoryStream;
  Uuid: TGuid;
  ProcessOptions: TProcessOptions;
begin
  ProcessOptions := TProcessOptions.Create;
  TmpStream := TMemoryStream.Create;
  try
    SetHeader(THeader.Create);

    PrepStream(TmpStream, [$0000]);
    Add(TmGreatRidesInfoMap.Create(TmpStream.Size, dtRaw, TmpStream));
    Add(TmAvoidancesChangedTimeAtSave.Create(ProcessOptions.AvoidancesChangedTimeAtSave));
    TmpStream.Position := 0;
    Add(TmTrackToRouteInfoMap.Create(TmpStream.Size, dtRaw, TmpStream));
    Add(TmIsDisplayable.Create);
    Add(TmShowLastStopAsShapingPoint.Create);
    CheckHRGuid(CreateGUID(Uuid));
    Add(TmExploreUuid.Create(ReplaceAll(LowerCase(GuidToString(Uuid)), ['{','}'], ['',''], [rfReplaceAll])));
    Add(TmOptimized.Create);
    Add(TmDayNumber.Create);
    Add(TmParentTripName.Create(TripName));
    Add(TmTotalTripDistance.Create);
    Add(TmTotalTripTime.Create);
    Add(TmVehicleProfileTruckType.Create(ProcessOptions.VehicleProfileTruckType));
    Add(TmAvoidancesChanged.Create);
    Add(TmVehicleProfileName.Create(ProcessOptions.VehicleProfileName));
    Add(TmVehicleProfileHash.Create(ProcessOptions.VehicleProfileHash));
    Add(TmParentTripId.Create(0));
    Add(TmVehicleId.Create(ProcessOptions.VehicleId));
    Add(TmTripDate.Create);
    Add(TmImported.Create);
    Add(TmSerializedRoutePrefRoundTripRoadType.Create);
    Add(TmSerializedRoutePrefRoundTripDirection.Create);
    Add(TmSerializedRoutePrefRoundTripMethod.Create);
    Add(TmSerializedRoutePrefRoundTripUnits.Create);
    Add(TmIsRoundTrip.Create);
    Add(TmRoutePreferencesAdventurousHillsAndCurves.Create);
    Add(TmSerializedRoutePrefRoundTripLength.Create);
    Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel)));
    Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
    Add(TmFileName.Create(Format(TripFileName, [TripName])));
    Add(TmLocations.Create);
    Add(TmPartOfSplitRoute.Create);
    Add(TmRoutePreferencesAdventurousPopularPaths.Create);
    Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
    Add(TmRoutePreferencesAdventurousScenicRoads.Create);
    Add(TmVehicleProfileGuid.Create(ProcessOptions.VehicleProfileGuid));
    Add(TmIsDeviceRoute.Create);
    Add(TmRoutePreferences.Create);
    Add(TmTripName.Create(TripName));
    Add(TmRoutePreferencesAdventurousMode.Create);
    Add(TmVersionNumber.Create(TripFileVersion));
  finally
    TmpStream.Free;
    ProcessOptions.Free;
  end;
end;

procedure TTripList.CreateTemplate_Tread2(const TripName, CalculationMode, TransportMode: string);
var
  TmpStream: TMemoryStream;
  Uuid: TGuid;
  ProcessOptions: TProcessOptions;
begin
  ProcessOptions := TProcessOptions.Create;
  TmpStream := TMemoryStream.Create;
  try
    SetHeader(THeader.Create);

    PrepStream(TmpStream, [$0000]);
    Add(TmGreatRidesInfoMap.Create(TmpStream.Size, dtRaw, TmpStream));
    Add(TmAvoidancesChangedTimeAtSave.Create(ProcessOptions.AvoidancesChangedTimeAtSave));
    TmpStream.Position := 0;
    Add(TmTrackToRouteInfoMap.Create(TmpStream.Size, dtRaw, TmpStream));
    Add(TmIsDisplayable.Create);

    CheckHRGuid(CreateGUID(Uuid));
    Add(TmExploreUuid.Create(ReplaceAll(LowerCase(GuidToString(Uuid)), ['{','}'], ['',''], [rfReplaceAll])));
    Add(TmOptimized.Create);
    Add(TmDayNumber.Create);
    Add(TmParentTripName.Create(TripName));
    Add(TmShowLastStopAsShapingPoint.Create);
    Add(TmTotalTripDistance.Create);
    Add(TmTotalTripTime.Create);
    Add(TmVehicleProfileTruckType.Create(ProcessOptions.VehicleProfileTruckType));
    Add(TmAvoidancesChanged.Create);
    Add(TmVehicleProfileName.Create(ProcessOptions.VehicleProfileName));
    Add(TmVehicleProfileHash.Create(ProcessOptions.VehicleProfileHash));
    Add(TmParentTripId.Create(0));
    Add(TmVehicleId.Create(ProcessOptions.VehicleId));
    Add(TmTripDate.Create);
    Add(TmImported.Create);
    Add(TmRoutePreferencesAdventurousHillsAndCurves.Create);
    Add(TmIsRoundTrip.Create);
    Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel)));
    Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
    Add(TmFileName.Create(Format(TripFileName, [TripName])));
    Add(TmLocations.Create);
    Add(TmPartOfSplitRoute.Create);
    Add(TmRoutePreferencesAdventurousPopularPaths.Create);
    Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
    Add(TmRoutePreferences.Create);
    Add(TmIsDeviceRoute.Create);
    Add(TmRoutePreferencesAdventurousScenicRoads.Create);
    Add(TmVehicleProfileGuid.Create(ProcessOptions.VehicleProfileGuid));
    Add(TmTripName.Create(TripName));
    Add(TmRoutePreferencesAdventurousMode.Create);
    Add(TmVersionNumber.Create(TripFileVersion));
  finally
    TmpStream.Free;
    ProcessOptions.Free;
  end;
end;

procedure TTripList.CreateTemplate_Zumo346(const TripName, CalculationMode, TransportMode: string);
begin
  SetHeader(THeader.Create);

  Add(TmOptimized.Create);
  Add(TmImported.Create);
  Add(TmParentTripId.Create(0));
  Add(TmTripName.Create(TripName));
  Add(TmDayNumber.Create);
  Add(TmTripDate.Create);
  Add(TmVersionNumber.Create(TripFileVersion));
  Add(TmIsRoundTrip.Create);
  Add(TmParentTripName.Create(TripName));
  Add(TmTotalTripTime.Create);
  Add(TmAvoidancesChanged.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel)));
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmFileName.Create(Format(TripFileName, [TripName])));
  Add(TmLocations.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmTotalTripDistance.Create);
  Add(TmAllRoutes.Create);
end;

// The order of the items may be changed. EG Move mTripName after Theader does also work.
procedure TTripList.CreateTemplate_Zumo595(const TripName, CalculationMode, TransportMode: string);
begin
  SetHeader(THeader.Create);

  Add(TmTotalTripDistance.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel)));
  Add(TmAllRoutes.Create);
  Add(TmTripDate.Create);
  Add(TmParentTripId.Create(0));
  Add(TmImported.Create);
  Add(TmFileName.Create(Format(TripFileName, [TripName])));
  Add(TmLocations.Create);
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmPartOfSplitRoute.Create);
  Add(TmTotalTripTime.Create);
  Add(TmDayNumber.Create);
  Add(TmTripName.Create(TripName));
  Add(TmAvoidancesChanged.Create);
  Add(TmParentTripName.Create(TripName));
  Add(TmVersionNumber.Create(TripFileVersion));
  Add(TmIsRoundTrip.Create);
  Add(TmOptimized.Create);
end;

// The order of the items may be changed. EG Move mTripName after Theader does also work.
procedure TTripList.CreateTemplate_Zumo590(const TripName, CalculationMode, TransportMode: string);
begin
  SetHeader(THeader.Create);

  Add(TmAllRoutes.Create);
  Add(TmFileName.Create(Format(TripFileName, [TripName])));
  Add(TmIsRoundTrip.Create);
  Add(TmLocations.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel)));
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmTripName.Create(TripName));
  Add(TmVersionNumber.Create(TripFileVersion));
end;

procedure TTripList.CreateTemplate_Drive51(const TripName, CalculationMode, TransportMode: string);
begin
  SetHeader(THeader.Create);

  Add(TmOptimized.Create);
  Add(TmParentTripId.Create(0));
  Add(TmDayNumber.Create);
  Add(TmTripDate.Create);
  Add(TmParentTripName.Create(TripName));
  Add(TmTotalTripTime.Create);
  Add(TmImported.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmAvoidancesChanged.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel)));
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmFileName.Create(Format(TripFileName, [TripName])));
  Add(TmLocations.Create);
  Add(TmTotalTripDistance.Create);
  Add(TmVersionNumber.Create(TripFileVersion));
  Add(TmAllRoutes.Create);
  Add(TmTripName.Create(TripName));
end;

procedure TTripList.CreateTemplate_Drive66(const TripName, CalculationMode, TransportMode: string);
var
  TmpStream: TMemoryStream;
  ProcessOptions: TProcessOptions;
begin
  ProcessOptions := TProcessOptions.Create;
  TmpStream := TMemoryStream.Create;
  try
    SetHeader(THeader.Create);

    Add(TmIsDeviceRoute.Create);
    Add(TmPreserveTrackToRoute.Create);
    Add(TmParentTripId.Create(0));
    Add(TmDayNumber.Create);
    Add(TmTripDate.Create);
    Add(TmAvoidancesChanged.Create);
    Add(TmParentTripName.Create(TripName));
    Add(TmShowLastStopAsShapingPoint.Create);
    Add(TmOptimized.Create);
    Add(TmTotalTripTime.Create);
    Add(TmRoutePreferences.Create);
    Add(TmImported.Create);
    Add(TmRoutePreferencesAdventurousMode.Create);
    Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
    Add(TmTotalTripDistance.Create);
    Add(TmFileName.Create(Format(TripFileName, [TripName])));
    Add(TmLocations.Create);
    Add(TmPartOfSplitRoute.Create);
    Add(TmVersionNumber.Create(TripFileVersion));
    Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
    Add(TmTripName.Create(TripName));
  finally
    TmpStream.Free;
    ProcessOptions.Free;
  end;
end;

procedure TTripList.CreateTemplate_Zumo3x0(const TripName, CalculationMode, TransportMode: string);
begin
  SetHeader(THeader.Create);

  Add(TmAllRoutes.Create);
  Add(TmFileName.Create(Format(TripFileName, [TripName])));
  Add(TmLocations.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel), dtDWordRoutePref));
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmTripName.Create(TripName));
  Add(TmVersionNumber.Create(TripFileVersion));
end;

procedure TTripList.CreateTemplate_nuvi2595(const TripName, CalculationMode, TransportMode: string);
begin
  SetHeader(THeader.Create);

  Add(TmAllLinks.Create);
  Add(TmAllRoutes.Create);
  Add(TmFileName.Create(Format(TripFileName, [TripName])));
  Add(TmLocations.Create);
  Add(TmTripName.Create(TripName));
  Add(TmVersionNumber.Create(TripFileVersion));
end;

procedure TTripList.CreateTemplate_nuvi2599_57(const TripName, CalculationMode, TransportMode: string);
begin
  SetHeader(THeader.Create);
  Add(TmAllRoutes.Create);
  Add(TmAvoidancesChanged.Create);
  Add(TmFileName.Create(Format(TripFileName, [TripName])));
  Add(TmLocations.Create);
  Add(TmPartOfSplitRoute.Create);
  Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode, TripModel)));
  Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  Add(TmTripName.Create(TripName));
  Add(TmVersionNumber.Create(TripFileVersion));
end;

procedure TTripList.CreateTemplate(const TripName: string;
                                   const CalculationMode: string = '';
                                   const TransportMode: string = '');
begin
  Clear;
  case TripModel of
    TTripModel.XT:
      CreateTemplate_XT(TripName, CalculationMode, TransportMode);
    TTripModel.XT2:
      CreateTemplate_XT2(TripName, CalculationMode, TransportMode);
    TTripModel.XT3:
      CreateTemplate_XT3(TripName, CalculationMode, TransportMode);
    TTripModel.Tread2:
      CreateTemplate_Tread2(TripName, CalculationMode, TransportMode);
    TTripModel.Zumo595:
      CreateTemplate_Zumo595(TripName, CalculationMode, TransportMode);
    TTripModel.Zumo346:
      CreateTemplate_Zumo346(TripName, CalculationMode, TransportMode);
    TTripModel.Zumo590:
      CreateTemplate_Zumo590(TripName, CalculationMode, TransportMode);
    TTripModel.Drive51:
      CreateTemplate_Drive51(TripName, CalculationMode, TransportMode);
    TTripModel.Drive66:
      CreateTemplate_Drive66(TripName, CalculationMode, TransportMode);
    TTripModel.Zumo3x0:
      CreateTemplate_Zumo3x0(TripName, CalculationMode, TransportMode);
    TTripModel.Nuvi2595:
      CreateTemplate_nuvi2595(TripName, CalculationMode, TransportMode);
    TTripModel.Nuvi2599_57:
      CreateTemplate_nuvi2599_57(TripName, CalculationMode, TransportMode);
    else
      raise exception.Create('Create template. Model not supported');
  end;

  // Create dummy AllRoutes, and complete RoutePreferences
  ForceRecalc(TripModel, 2);
end;

procedure TTripList.AddUdbDir2Xml(AnUdbDir: TUdbDir; RoutePtRteExt: TXmlVSNode; TimeLst: TObjectlist<TLatLonTime>);
var
  GpxxRpt, GpxxSubClass: TXmlVSNode;
  Coords: TCoords;
  LatLonTime: TLatLonTime;
begin
  LatLonTime := TLatLonTime.Create;
  Coords := AnUdbDir.Coords;
  Coords.FormatLatLon(LatLonTime.Lat, LatLonTime.Lon, Coord_Decimals);
  GpxxRpt := RoutePtRteExt.AddChild('gpxx:rpt');
  GpxxRpt.AttributeList.Add('lat').Value := LatLonTime.Lat;
  GpxxRpt.AttributeList.Add('lon').Value := LatLonTime.Lon;
  GpxxSubClass := GpxxRpt.AddChild('gpxx:Subclass');
  GpxxSubClass.NodeValue := AnUdbDir.FValue.SubClass.Serialize;
  LatLonTime.Time := IntToStr(AnUdbDir.FValue.Time);
  TimeLst.Add(LatLonTime);
end;

procedure TTripList.AddTMExtension(RoutePtRteExt: TXmlVSNode; IsViaPoint: boolean;
                                   Dist, Time: Cardinal;
                                   TimeLst: TObjectlist<TLatLonTime>);
var
  RoutePtRteTMExt, RoutePtRteTMrpt: TXmlVSNode;
  LatLonTime: TLatLonTime;
begin
  RoutePtRteTMExt := RoutePtRteExt.AddChild('gpxx:Extensions');
  if (IsViaPoint) then
  begin
    RoutePtRteTMrpt := RoutePtRteTMExt.AddChild('tm:rtept');
    RoutePtRteTMrpt.AttributeList.Add('dist').Value := IntToStr(Dist);
    RoutePtRteTMrpt.AttributeList.Add('time').Value := IntToStr(Time);
  end;

  for LatLonTime in TimeLst do
  begin
    RoutePtRteTMrpt := RoutePtRteTMExt.AddChild('tm:rpt');
    RoutePtRteTMrpt.AttributeList.Add('lat').Value := LatLonTime.Lat;
    RoutePtRteTMrpt.AttributeList.Add('lon').Value := LatLonTime.Lon;
    RoutePtRteTMrpt.AttributeList.Add('time').Value := LatLonTime.Time;
  end;

  TimeLst.Clear;
end;

procedure TTripList.Trip2XmlRte(Rte: TObject);
var
  RtePt, RoutePt, RoutePtExt, RoutePtRteExt: TXmlVSNode;
  Locations: TmLocations;
  Location, ANItem: TBaseItem;
  ViaPointType, Arrival, TransportMode, CalculationMode, PointName, Lat, Lon, Address: string;
  IsViaPoint, WriteTMExtensions: boolean;
  AllRoutes: TmAllRoutes;
  AnUdbHandle: TmUdbDataHndl;
  UdbHndleCnt: integer;
  UdbDirCnt: integer;
  TimeLst: TObjectlist<TLatLonTime>;
begin
  TimeLst := TObjectlist<TLatLonTime>.Create(true);
  try
    IntToIdent(Ord(TTransportMode.tmMotorcycling), TransportMode, TransportModeMap);
    ANItem := GetItem(TmTransportationMode.GetKey);
    if (Assigned(ANItem)) then
      TransportMode := TmTransportationMode(ANItem).AsString;

    CalculationMode := RoutePrefRecs[cmFasterTime].Desc;
    ANItem := GetItem(TmRoutePreference.GetKey);
    if (Assigned(ANItem)) then
      CalculationMode := TmRoutePreference(ANItem).AsString;

    TXmlVSNode(Rte).AddChild('name').NodeValue := TripName;
    TXmlVSNode(Rte).AddChild('extensions').AddChild('trp:Trip').AddChild('trp:TransportationMode').NodeValue := TransportMode;

    Locations := TmLocations(GetItem(TmLocations.GetKey));
    if not (Assigned(Locations)) then
      exit;

    UdbHndleCnt := -1;
    UdbDirCnt := -1;
    AllRoutes := GetItem(TmAllRoutes.GetKey) as TmAllRoutes;
    WriteTMExtensions := Assigned(AllRoutes) and // Can we write the TM Extensions. <time> <dist>
                         IsCalculated;

    for Location in Locations.Locations do
    begin
      if (Location is TLocation) then
      begin
        RtePt := TXmlVSNode(Rte).AddChild('rtept');

        // Point Type
        IsViaPoint := TLocation(Location).IsViaPoint;
        Arrival := '';
        ViaPointType := 'trp:ShapingPoint';
        if (IsViaPoint) then
        begin
          ViaPointType := 'trp:ViaPoint';

          // Arrival
          ANItem := TLocation(Location).LocationTmArrival;
          if (Assigned(ANItem)) and
             (TmArrival(ANItem).AsCardinal <> 0) then
            Arrival := DateToISO8601(TUnixDateConv.CardinalAsDateTime(TmArrival(ANItem).AsCardinal), false);

          // Counters for TM Extensions
          Inc(UdbHndleCnt);
          UdbDirCnt := 0;
        end;

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
        RoutePtExt := RtePt.AddChild('extensions');
        RoutePt := RoutePtExt.AddChild(ViaPointType);

        if (IsViaPoint) then
        begin
          if (Arrival <> '') then
            RoutePt.AddChild('trp:DepartureTime').NodeValue := Arrival;
          RoutePt.AddChild('trp:CalculationMode').NodeValue := CalculationMode;
        end;

        // Write RoutePointExtension
        if (WriteTMExtensions) then
        begin
          RoutePtRteExt := RoutePtExt.AddChild('gpxx:RoutePointExtension');
          RoutePtRteExt.AddChild('gpxx:Subclass').NodeValue := DirectRoutingClass;
          if (UdbHndleCnt > -1) and
             (UdbHndleCnt < AllRoutes.Items.Count) then // Dont write TM extensions for last RtePt
          begin
            AnUdbHandle := AllRoutes.Items[UdbHndleCnt];

            // Need to skip the First, last and RoutePoint Udb. Have time=$ffff
            Inc(UdbDirCnt);
            while (UdbDirCnt < AnUdbHandle.Items.Count) and
                  (AnUdbHandle.Items[UdbDirCnt].FValue.SubClass.IsKnownRoutePoint = false) do
            begin
              AddUdbDir2Xml(AnUdbHandle.Items[UdbDirCnt], RoutePtRteExt, TimeLst);
              Inc(UdbDirCnt);
            end;

            AddTMExtension(RoutePtRteExt,
                           IsViaPoint,
                           AnUdbhandle.UdbHandleValue.GetUnknown3(AnUdbhandle.DistOffset),
                           AnUdbhandle.UdbHandleValue.GetUnknown3(AnUdbhandle.TimeOffset),
                           TimeLst);
          end;
        end;
      end;
    end;
  finally
    TimeLst.Free;
  end;
end;


procedure TTripList.SaveAsGPX(const GPXFile: string);
var
  Xml: TXmlVSDocument;
  XMLRoot: TXmlVSNode;
begin
  XML := TXmlVSDocument.Create;
  try
    XMLRoot := InitGarminGpx(XML);
    Trip2XmlRte(XMLRoot.AddChild('rte'));

    XML.SaveToFile(GPXFile);
  finally
    Xml.Free;
  end;
end;

function TTripList.KurvigerUrl: string;
var
  Rte: TXmlVSNode;
  ProcessOptions: TProcessOptions;
begin
  ProcessOptions := TProcessOptions.Create;
  Rte := TXmlVSNode.Create;
  Trip2XmlRte(Rte);
  try
    result := ProcessOptions.GetKurvigerUrl(Rte);
  finally
    Rte.Free;
    ProcessOptions.Free;
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
    TmPreserveTrackToRoute, TmIsDisplayable, TmAvoidancesChanged, TmIsRoundTrip,
    TmOptimized, TmImported, TmPartOfSplitRoute,
    TmIsDFSPoint, TmIsTravelapseDestination, TmPreserveTrackToRoute,
  // TCardinalItem
    TmParentTripId, TmTripDate, TmTotalTripTime, TmAttr, TmDuration, TmArrival,
    TmShapingRadius,
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
  // XT2, XT3, Tread 2
    TmShowLastStopAsShapingPoint,
    TmVehicleProfileTruckType,
    TmVehicleProfileHash,
    TmVehicleId,
    TmVehicleProfileGuid,
    TmVehicleProfileName,
    TmIsDeviceRoute,
    TmExploreUuid,
    TmShapingCenter,
    TmAvoidancesChangedTimeAtSave,
    TmRoutePreferences,
    TmRoutePreferencesAdventurousHillsAndCurves,
    TmRoutePreferencesAdventurousScenicRoads,
    TmRoutePreferencesAdventurousMode,
    TmRoutePreferencesAdventurousPopularPaths,
    TmTrackToRouteInfoMap,
    TmGreatRidesInfoMap,
  // XT3
    TmSerializedRoutePrefRoundTripRoadType,
    TmSerializedRoutePrefRoundTripDirection,
    TmSerializedRoutePrefRoundTripMethod,
    TmSerializedRoutePrefRoundTripUnits,
    TmSerializedRoutePrefRoundTripLength,
  // Zumo3x0, 590
    TmShaping, TmPhoneNumber,
  // Nuvi2595
    TmAllLinks
  ]);
end;

end.
