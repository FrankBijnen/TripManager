unit UnitProcessOptions;

interface

uses
  System.Classes,
  Winapi.Windows,
{$IFDEF TRIPOBJECTS}
  UnitTripDefs,
{$ENDIF}
{$IFDEF GPI}
  UnitGpi,
{$ENDIF}
  UnitGpxDefs;

const
  Reg_FuncTrip                = 'FuncTrip';
  Reg_FuncTrack               = 'FuncTrack';
  Reg_FuncStrippedRoute       = 'FuncStrippedRoute';
  Reg_FuncCompleteRoute       = 'FuncCompleteRoute';
  Reg_FuncWayPoint            = 'FuncWayPoint';
  Reg_FuncWayPointWpt         = 'FuncWayPointWpt';
  Reg_FuncWayPointVia         = 'FuncWayPointVia';
  Reg_FuncWayPointShape       = 'FuncWayPointShape';
  Reg_FuncGpi                 = 'FuncGpi';
  Reg_FuncGpiWayPt            = 'FuncGpiWayPt';
  Reg_FuncGpiViaPt            = 'FuncGpiViaPt';
  Reg_FuncGpiShpPt            = 'FuncGpiShpPt';
  Reg_FuncKml                 = 'FuncKml';
  Reg_FuncHtml                = 'FuncHtml';
  Reg_FuncFit                 = 'FuncFit';

type
  TProcessOptions = class
    SkipTrackDialog: boolean;                 // False, For showing fit files.

    HasConsole: boolean;                      // False, CmdLine process
    LookUpWindow: HWND;                       // 0, Window handle
                                              // Used to send progress messages when looking up addresses
    LookUpMessage: UINT;                      // 0, Message Id
                                              // Used to send progress messages when looking up addresses

    ProcessSubClass: boolean;                 // True, Allow clearing the subclass,
                                              // Used in: PostProcess, CreateRoutes
    ProcessFlags: boolean;                    // True, Allow to change the symbol
                                              // Used in: PostProcess, CreateRoutes
    ProcessBegin: boolean;                    // True, Allow RenameNode(BeginStr),
                                              //       ClearSubClass(ProcessSubClass),
                                              //       Change Symbol(ProcessFlags),
                                              //       Lookup Address(ProcessAddrBegin),
      ProcessAddrBegin: boolean;              // False
      BeginStr: string;                       // Begin
                                              // Also used as category
      BeginSymbol: string;                    // Flag, Red
                                              // Also used as category

    ProcessEnd: boolean;                      // True, Allow RenameNode(EndStr),
                                              //       ClearSubClass(ProcessSubClass),
                                              //       Change Symbol(ProcessFlags),
                                              //       Lookup Address(ProcessAddrEnd)
      ProcessAddrEnd: boolean;                // False
      EndStr: string;                         // End
                                              // Also used as category
      EndSymbol: string;                      // Flag, Blue
                                              // Also used as category

    ProcessWpt: boolean;                      // False, Process Way points, add categories

    ProcessShape: boolean;                    // True, Allow Unglitch,
                                              //       ClearSubClass(ProcessSubClass)
                                              //       Change Symbol(ProcessFlags),
                                              //       RenameNode(ShapingPointName),
                                              //       Lookup Address(ProcessAddrShape)
      DefShapePtSymbol: string;               // Waypoint ==> https://www.javawa.nl/bc_waypointsymbool.html.
                                              // Used in: Unglitch
      ProcessAddrShape: boolean;              // False
      ShapingPointName: TShapingPointName;    // Route_Distance, Rename Shaping points automatically
      DefShapingPointSymbol: string;          // Navaid, Blue,
                                              // Only used if there is no custom symbol defined
                                              // Used in: CreateRoutes, and CreateWayPoints
      ShapingPointCategory: string;           // Shape
                                              // Used in: CreateWayPoints, CreatePOI

    ProcessVia: boolean;                      // True, Allow ClearSubClass(ProcessSubClass),
                                              //       Lookup Address(ProcessAddrVia)
     ProcessAddrVia: boolean;                 // False
      DefViaPointSymbol: string;              // Navaid, Red
                                              // Only used if there is no custom symbol defined
                                              // Used in: CreateRoutes, and CreateWayPoints
      ViaPointCategory: string;               // Via
                                              // Used in: CreateWayPoints, CreatePOI
    ProcessCreateRoutePoints: boolean;        // True, Allow adding routepoints to FRouteViaPointList
                                              // Used in: CreateOSM(Points), CreateKml, CreatePoly. Exposed public

    ProcessTracks: boolean;                   // True, Retain tracks, Create tracks from ghost points in routes.
      MinDistTrackPoint: integer;             // 0, Minimum distance between trackpoint. Use as a filter.

    ProcessWayPtsFromRoute: boolean;          // True, Allow adding routepoints to FWayPointFromRouteList for creating WayPoints
                                              // Used in: CreateWayPoints, CreatePOI
    ProcessWayPtsInWayPts: boolean;           // True, Add original Way points to WayPoints_<Gpx_name>.gpx
                                              // Categories are taken from original Way point
    ProcessViaPtsInWayPts: boolean;           // False, Add Via points to WayPoints_<Route_name>.gpx
                                              // Categories 'Symbol:<Begin, End, Via>' and 'Route:<Route_name>'
    ProcessShapePtsInWayPts: boolean;         // False, Add Shaping points to WayPoints_<Route_name>.gpx
                                              // Categories 'Symbol:<Via>' and 'Route:<Route_name>'

                                              // The POIGroup name will be <Gpx_name>.
                                              // The XT will use that as the main category in Custom POI's.
    ProcessWayPtsInGpi: boolean;              // True, Add original Way points to <Gpx_name>.gpi
                                              // Category 'Symbol:<symbol>' from original Way point
    ProcessViaPtsInGpi: boolean;              // True, Add Via points to <Gpx_name>.gpi
                                              // Category 'Route:<Route_name>
    ProcessShapePtsInGpi: boolean;            // False, Add Shaping points to <Gpx_name>.gpi
                                              // Category 'Route:<Route_name>
    DefaultProximityStr: string;              // 500, Default proximity for alerts (meters)
    GPISymbolsDir: UTF8String;                // Symbols\24x24\ Sets the size of the GPI Symbols

    ProcessDistance: boolean;                 // True, Compute distance. Added in KML, and name of shaping points
    DistanceUnit: TDistanceUnit;              // duKm, Kilometers.
    CompareDistanceOK: integer;               // 500, Meters.
    MinShapeDist: integer;                    // 2500, Meters.

    ProcessCategory: set of TProcessCategory; // [pcSymbol, pcGPX], Add Categories to WayPoints
    ProcessAddrWayPt: boolean;                // False
    DefTrackColor: string;                    // Blue, Used if no Displaycolor found in <trk>
    TrackColor: string;                       // '', The Track color possible changed by user. Saved in Registry

    DefWaypointSymbol: string;                // Flag, Green, Default symbol for Via and Shaping points in GPX
    CatSymbol: string;                        // Symbol:, used in created Waypoints/GPI
    CatGPX: string;                           // GPX:, used in created Waypoints/GPI from Original Way points
    CatRoute: string;                         // ROUTE:, used in created Waypoints/GPI from Via/Shaping points

    {$IFDEF TRIPOBJECTS}
    TripModel: TTripModel;                    // XT1 and XT2
    ScPosn_Unknown1: Cardinal;                // XT1 and XT2
    VehicleProfileGuid: string;               // XT2
    VehicleProfileHash: string;               // XT2
    VehicleId: string;                        // XT2
    VehicleProfileTruckType: string;          // XT2
    VehicleProfileName: string;               // XT2
    AvoidancesChangedTimeAtSave: Cardinal;    // XT2
    AllowGrouping: boolean;                   // XT1. (Not used anymore for XT2)
    TripOption: TTripOption;                  // XT1 and XT2
    EnableTripOverview: boolean;              // XT1 and XT2
    DefAdvLevel: TAdvlevel;                   // XT2
    DefRoadSpeed: integer;                    // XT1 and XT2
    RoadSpeedMap: array[0..11] of TIdentMapEntry;
    {$ENDIF}

    FOnSetFuncPrefs: TNotifyEvent;
    FOnSavePrefs: TNotifyEvent;

    constructor Create(OnSetFuncPrefs: TNotifyEvent = nil; OnSavePrefs: TNotifyEvent = nil);
    destructor Destroy; override;
    procedure DoPrefSaved;
    procedure SetProcessCategory(ProcessWpt: boolean; WayPtCat: string);
    function DistanceStr: string;
    function GetDistOKKms: double;
    function GetMinShapeDistKms: double;
    function GetMinTrackDistKms: double;
    {$IFDEF TRIPOBJECTS}
    function TripTrackColor: string;
    function SpeedFromRoadClass(const RoadClass: string): integer;
    function ComputeTime(const RoadClass: string; const Dist: Double): double;
    class function GetMinDistTrackPoints: integer;
    class procedure SetMinDistTrackPoints(AValue: integer);
    class function Trk2RtOptions: string;
    class procedure SetTrk2RtExportPerc(AValue: integer);
    class function GetTrk2RtExportPerc: integer;
    class function DescriptionFromRoadClass(const RoadClass: byte): string;
    class function UnsafeModels: boolean;
    class function SafeModel2Write(ATripModel: TTripModel): boolean;
    class function MaxViaPoints: integer;
    {$ENDIF}

    property DistOKKms: double read GetDistOKKms;
    property MinShapeDistKms: double read GetMinShapeDistKms;
  end;

implementation

uses
  System.SysUtils,
{$IFDEF REGISTRYKEYS}
  UnitRegistry,
  UnitRegistryKeys,
{$ENDIF}
  UnitStringUtils;

var
  FormatSettings: TFormatSettings;

constructor TProcessOptions.Create(OnSetFuncPrefs: TNotifyEvent = nil; OnSavePrefs: TNotifyEvent = nil);
begin
  inherited Create;
  FOnSetFuncPrefs := OnSetFuncPrefs;
  FOnSavePrefs := OnSavePrefs;

  ProcessSubClass := true;
  ProcessFlags := true;

  ProcessBegin := true;
    ProcessAddrBegin := false;
    BeginStr := 'Begin';
    BeginSymbol := 'Flag, Red';

  ProcessEnd := true;
    ProcessAddrEnd := false;
    EndStr := 'End';
    EndSymbol := 'Flag, Blue';

  ProcessShape := true;
    ProcessAddrShape := false;
    ShapingPointName := TShapingPointName.Route_Distance;
    DefShapingPointSymbol := 'Navaid, Blue';
    ShapingPointCategory := 'Shape';
    DefShapePtSymbol := 'Waypoint';

  ProcessWpt := false;

  ProcessVia := true;
    DefViaPointSymbol := 'Navaid, Red';
    ViaPointCategory := 'Via';

  ProcessCreateRoutePoints := true;

  ProcessTracks := true;
  MinDistTrackPoint := 0;

  ProcessWayPtsFromRoute := true; // Create points for GPI and route Points from route
  ProcessWayPtsInWayPts := true;
  ProcessViaPtsInWayPts := false;
  ProcessShapePtsInWayPts := false;

  ProcessWayPtsInGpi := true;
  ProcessViaPtsInGpi := true;
  ProcessShapePtsInGpi := false;
{$IFDEF GPI}
  GPISymbolsDir := DefGpiSmallSymbolsDir;
{$ENDIF}
  DefaultProximityStr := '';

  ProcessCategory := [pcSymbol, pcGPX];

  ProcessAddrVia := false;
  ProcessAddrWayPt := false;

  ProcessDistance := true;
  DistanceUnit := duKm;

  CompareDistanceOK := 500;
  MinShapeDist := 2500;

  DefTrackColor := 'Blue';
  TrackColor := '';

  DefWaypointSymbol := 'Flag, Green';
  CatSymbol := 'Symbol:';
  CatGPX := 'GPX:';
  CatRoute := 'Route:';

  HasConsole := false;
  SkipTrackDialog := false;
  LookUpWindow := 0;
  LookUpMessage := 0;

{$IFDEF TRIPOBJECTS}
  TripModel := TTripModel.XT;
  ScPosn_Unknown1 := 0;
  VehicleProfileGuid := XT2_VehicleProfileGuid;
  VehicleProfileHash := '0';
  VehicleId := XT2_VehicleId;
  VehicleProfileTruckType := XT2_VehicleProfileTruckType;
  VehicleProfileName := XT2_VehicleProfileName;
  AvoidancesChangedTimeAtSave := 0;
  AllowGrouping := true;
  TripOption := TTripOption.ttCalc;

  EnableTripOverview := false;
  RoadSpeedMap[0].Value  := 108; RoadSpeedMap[0].Name  := '01';
  RoadSpeedMap[1].Value  := 72;  RoadSpeedMap[1].Name  := '02';
  RoadSpeedMap[2].Value  := 56;  RoadSpeedMap[2].Name  := '03';
  RoadSpeedMap[3].Value  := 50;  RoadSpeedMap[3].Name  := '04';
  RoadSpeedMap[4].Value  := 48;  RoadSpeedMap[4].Name  := '05';
  RoadSpeedMap[5].Value  := 30;  RoadSpeedMap[5].Name  := '06';
  RoadSpeedMap[6].Value  := 15;  RoadSpeedMap[6].Name  := '07';
  RoadSpeedMap[7].Value  := 50;  RoadSpeedMap[7].Name  := '08';
  RoadSpeedMap[8].Value  := 80;  RoadSpeedMap[8].Name  := '09';
  RoadSpeedMap[9].Value  := 15;  RoadSpeedMap[9].Name  := '0A';
  RoadSpeedMap[10].Value := 25;  RoadSpeedMap[10].Name := '0B';
  RoadSpeedMap[11].Value := 15;  RoadSpeedMap[11].Name := '0C';
  DefRoadSpeed := 25;
  DefAdvLevel := TAdvlevel.advLevel1;
{$ENDIF}

{$IFDEF REGISTRYKEYS}
  if (Assigned(SetProcessOptions)) then
    SetProcessOptions.SetFixedPrefs(Self);
{$ENDIF}

  if (Assigned(FOnSetFuncPrefs)) then
    FOnSetFuncPrefs(Self);
end;

destructor TProcessOptions.Destroy;
begin
// Future use
  inherited Destroy;
end;

procedure TProcessOptions.DoPrefSaved;
begin
  if (Assigned(FOnSavePrefs)) then
    FOnSavePrefs(Self);
end;

procedure TProcessOptions.SetProcessCategory(ProcessWpt: boolean; WayPtCat: string);
var
  WayPtList: TStringList;
  WayPtCatSeq: integer;
begin
  WayPtList := TStringList.Create;
  try
    WayPtList.Text := ProcessCategoryPick;
    ProcessCategory := [];
    WayPtCatSeq := WayPtList.IndexOf(WayPtCat);
    if (ProcessWpt) then
    begin
      case WayPtCatSeq of
        1: Include(ProcessCategory, pcSymbol);
        2: Include(ProcessCategory, pcGPX);
        3: begin
             Include(ProcessCategory, pcSymbol);
             Include(ProcessCategory, pcGPX);
            end;
      end;
    end;
  finally
    WayPtList.Free;
  end;
end;

function TProcessOptions.DistanceStr: string;
begin
  if (DistanceUnit = TDistanceUnit.duMi) then
    result := 'Mi'
  else
    result := 'Km';
end;

function TProcessOptions.GetDistOKKms: double;
begin
  result := CompareDistanceOK / 1000;
end;

function TProcessOptions.GetMinShapeDistKms: double;
begin
  result := MinShapeDist / 1000;
end;

function TProcessOptions.GetMinTrackDistKms: double;
begin
  result := MinDistTrackPoint / 1000;
end;

{$IFDEF TRIPOBJECTS}
function TProcessOptions.TripTrackColor: string;
begin
  result := DefTrackColor;
  if (TrackColor <> '') then
    result := TrackColor;
end;

function TProcessOptions.SpeedFromRoadClass(const RoadClass: string): integer;
begin
  if not (IdentToInt(RoadClass, result, RoadSpeedMap)) then
    result := DefRoadSpeed;
end;

function TProcessOptions.ComputeTime(const RoadClass: string; const Dist: Double): double;
begin
  result := (3600 * Dist) / SpeedFromRoadClass(RoadClass);
end;

class function TProcessOptions.GetMinDistTrackPoints: integer;
begin
  result := GetRegistry(Reg_MinDistTrackPoints_Key, 0);  // No filter
end;

class procedure TProcessOptions.SetMinDistTrackPoints(AValue: integer);
begin
  SetRegistry(Reg_MinDistTrackPoints_Key, AValue);
end;

class function TProcessOptions.Trk2RtOptions: string;
begin
  result := Format('%s exportPercent=%1.2f',
                   [GetRegistry(Reg_Trk2RtOptions_Key, Reg_Trk2RtOptions_Val),
                    TProcessOptions.GetTrk2RtExportPerc / 10], FormatSettings);
end;

class procedure TProcessOptions.SetTrk2RtExportPerc(AValue: integer);
begin
  SetRegistry(Reg_Trk2RtExportPerc_Key, AValue);
end;

class function TProcessOptions.GetTrk2RtExportPerc: integer;
begin
  result := GetRegistry(Reg_Trk2RtExportPerc_Key, Reg_Trk2RtExportPerc_Val);
end;

class function TProcessOptions.DescriptionFromRoadClass(const RoadClass: byte): string;
begin
  case RoadClass of
    0:  result := '';
    1:  result := 'Interstate highway';
    2:  result := 'Major highway';
    3:  result := 'Other highway';
    4:  result := 'Arterial road';
    5:  result := 'Collector road';
    6:  result := 'Residential Street';
    7:  result := 'Private';
    8:  result := 'Highway ramp. Low speed';
    9:  result := 'Highway ramp. High speed';
    10: result := 'Unpaved';
    11: result := 'Major higway connector';
    12: result := 'Round about';
    else
        result := Format('RoadClass: %s', [IntToHex(RoadClass, 2)]);
  end;
end;

class function TProcessOptions.UnsafeModels: boolean;
begin
  result := GetRegistry(Reg_UnsafeModels, false);
end;

class function TProcessOptions.SafeModel2Write(ATripModel: TTripModel): boolean;
begin
  result := UnsafeModels or TModelConv.SafeModel2Write(ATripModel);
end;

class function TProcessOptions.MaxViaPoints: integer;
begin
  result := GetRegistry(Reg_MaxViaPoints_Key, Reg_MaxViaPoints_Val);
end;
{$ENDIF}

initialization
begin
  FormatSettings := GetLocaleSetting;
end;

end.
