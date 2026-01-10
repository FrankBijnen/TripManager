unit UnitRegistryKeys;

interface

uses
  System.Classes,
  UnitTripDefs, UnitGpxDefs;

const
  Zumo_Name                         = 'z' + #0363 + 'mo'; // Dont need to save as UTF8

  // XT
  XT_Name                           = Zumo_Name + ' XT';

  // XT2
  XT2_Name                          = Zumo_Name + ' XT2';
  XT2_VehicleProfileGuid            = 'dbcac367-42c5-4d01-17aa-ecfe025f2d1c';
  XT2_VehicleId                     = '1';
  XT2_VehicleProfileTruckType       = '7';
  XT2_VehicleProfileName            = Zumo_Name + ' Motorcycle';

  // Tread 2 is almost an XT2
  Tread2_Name                       = 'Tread 2';

  // Older models
  Zumo595_Name                      = 'zumo 595';
  Zumo590_Name                      = 'zumo 590';
  Drive51_Name                      = 'Drive 51';
  Zumo3x0_Name                      = Zumo_Name + ' 3x0';
  Nuvi2595_Name                     = 'n' + #0252 + 'vi 2595';

  // Generic Garmin & Edge
  Garmin_Name                       = 'Garmin';
  Edge_Name                         = 'Edge';

  // Unknown
  Unknown_Name                      = 'Unknown';

  // Device recognition constants
  InternalStorage                 = 'Internal Storage\';
  TripsPath                       = 'Trips';
  SystemTripsPath                 = '.System\' + TripsPath;
  NonMTPRoot                      = '?:\';
  GarminPath                      = 'Garmin';
  SystemDb                        = 'system.db';
  SettingsDb                      = 'settings.db';
  ProfileDb                       = 'vehicle_profile.db';
  GarminDeviceXML                 = 'GarminDevice.xml';
  Reg_UnsafeModels                = 'UnsafeModels';

  Reg_GPISymbolSize               = 'GPISymbolsSize';
  Reg_GPIProximity                = 'GPIProximity';
  Reg_TrackColor                  = 'TrackColor';         // User preferred track color
  Reg_MinDistTrackPoints_Key      = 'MinDistTrackPoints'; // Used to filter trackpoints

  // XT1 and XT2 and Tread 2
  Reg_ScPosn_Unknown1             = 'ScPosn_Unknown1';
  Reg_AllowGrouping               = 'AllowGrouping';
  Reg_TripOption                  = 'TripOption';
  Reg_DefAdvLevel                 = 'DefAdvLevel';
  Reg_MaxViaPoints_Key            = 'MaxViaPoints';
  Reg_MaxViaPoints_Val            = 31;

  // XT2 and Tread 2
  Reg_VehicleProfileGuid          = 'VehicleProfileGuid';
  Reg_VehicleProfileHash          = 'VehicleProfileHash';
  Reg_VehicleId                   = 'VehicleId';
  Reg_VehicleProfileTruckType     = 'VehicleProfileTruckType';
  Reg_AvoidancesChangedTimeAtSave = 'AvoidancesChangedTimeAtSave';
  Reg_VehicleProfileName          = 'VehicleProfileName';
  Reg_VehicleType                 = 'VehicleType';
  Reg_VehicleTransportMode        = 'VehicleTransportMode';

  Reg_ProcessBegin                = 'ProcessBegin';
  Reg_CurrentModel                = 'CurrentModel';
  Reg_BeginSymbol                 = 'BeginSymbol';
  Reg_BeginStr                    = 'BeginStr';
  Reg_BeginAddress                = 'BeginAddress';

  Reg_ProcessEnd                  = 'ProcessEnd';
  Reg_EndSymbol                   = 'EndSymbol';
  Reg_EndStr                      = 'EndStr';
  Reg_EndAddress                  = 'EndAddress';

  Reg_ProcessWpt                  = 'ProcessWpt';
  Reg_ProcessCategory             = 'ProcessCategory';
  Reg_WayPtAddress                = 'WayPtAddress';

  Reg_ProcessVia                  = 'ProcessVia';
  Reg_ViaAddress                  = 'ViaAddress';

  Reg_ProcessShape                = 'ProcessShape';
  Reg_ShapingName                 = 'ShapingName';
  Reg_DistanceUnit                = 'DistanceUnit';
  Reg_ShapeAddress                = 'ShapeAddress';
  Reg_CompareDistOK_Key           = 'CompareDistOK';
  Reg_CompareDistOK_Val           = 500;
  Reg_MinShapeDist_Key            = 'MinShapeDist';
  Reg_MinShapeDist_Val            = 2500;
  Reg_EnableTripOverview          = 'EnableTripOverview';
  Reg_RoadSpeed_Key               = 'RoadSpeed'; // Multiple

  Reg_PrefFileSysFolder_Key       = 'PrefFileSysFolder';
  Reg_PrefFileSysFolder_Val       = 'rfDesktop';
  Reg_PrefDev_Key                 = 'PrefDevice';
  Reg_PrefDevTripsFolder_Key      = 'PrefDeviceTripsFolder';
  Reg_PrefDevTripsFolder_Val      = InternalStorage + SystemTripsPath;

  Reg_PrefDevGpxFolder_Key        = 'PrefDeviceGpxFolder';
  Reg_PrefDevGpxFolder_Val        = InternalStorage + 'GPX';
  Reg_PrefDevPoiFolder_Key        = 'PrefDevicePoiFolder';
  Reg_PrefDevPoiFolder_Val        = InternalStorage + 'POI';
  Reg_EnableDirFuncs              = 'EnableDirFuncs';
  Reg_EnableFitFuncs              = 'EnableFitFuncs';
  Reg_EnableTripFuncs             = 'EnableTripFuncs';
  Reg_EnableGpxFuncs              = 'EnableGpxFuncs';
  Reg_EnableGpiFuncs              = 'EnableGpiFuncs';
  Reg_ValidGpiSymbols             = 'ValidGpiSymbols';
  Reg_TripColor_Key               = 'TripColor';
  Reg_TripColor_Val               = 'Magenta';
  Reg_Maximized_Key               = 'Maximized';
  Reg_WidthColumns_Key            = 'WidthColumns';
  Reg_WidthColumns_Val            = '145,55,75,100';
  Reg_SortColumn_Key              = 'SortColumn';
  Reg_SortAscending_Key           = 'SortAscending';
  Reg_RoutePointTimeOut_Key       = 'RoutePointTimeOut';
  Reg_RoutePointTimeOut_Val       = '5000';
  Reg_GeoSearchTimeOut_Key        = 'GeoSearchTimeOut';
  Reg_GeoSearchTimeOut_Val        = '8000';

  Reg_SavedMapPosition_Key        = 'SavedMapPosition';
  Reg_DefaultCoordinates          = '48.854918, 2.346558'; // Somewhere in Paris

  Reg_Trk2RtOptions_Key           = 'Trk2RtOptions';
  Reg_Trk2RtOptions_Val           = 'noRelocate NS_ALL';
  Reg_Trk2RtExportPerc_Key        = 'Trk2RtExportPerc';
  Reg_Trk2RtExportPerc_Val        = 10;

const
  IdTrip          = 0;
  IdTrack         = 1;
  IdCompleteRoute = 2; // Only Device
  IdStrippedRoute = 3;
  IdWayPoint      = 4;
    IdWayPointWpt = 5;
    IdWayPointVia = 6;
    IdWayPointShp = 7;
  IdGpi           = 8;
    IdGpiWayPt    = 9;
    IdGpiViaPt    = 10;
    IdGpiShpPt    = 11;
  IdKml           = 12; // Only Windows
  IdHtml          = 13; // Only Windows
  IdFit           = 14; // Edge Fit files

type

  TGarminDevice = record
    GarminModel: TGarminModel;
    ModelDescription: string;
    GpxPath: string;
    GpiPath: string;
    CoursePath: string;
    NewFilesPath: string;
    ActivitiesPath: string;
    procedure Init;
  end;

  TSetProcessOptions = class
  private
  public
    procedure SetFixedPrefs(Sender: Tobject);
    procedure SetPostProcessPrefs(Sender: TObject);
    procedure SetSendToPrefs(Sender: TObject);
    procedure SetCmdLinePrefs(Sender: TObject);
    procedure SetSkipTrackDlgPrefs(Sender: TObject);
    procedure SavePrefs(Sender: TObject);
    class procedure SetPrefs(TvSelections: TObject);
    class function StorePrefs(TvSelections: TObject): TGPXFuncArray;
    class procedure CheckSymbolsDir;
  end;

  TModelConv = class
  private
    class function GetDevices(const Default: boolean): TStringList;
    class function GetDevice(const Default: boolean; const DevIndex: integer): string;
  public
    class function GetKnownDevices: TStringList;
    class procedure CmbModelDevices(const Devices: TStrings);
    class function GetKnownDevice(const DevIndex: integer): string;
    class function GetDefaultDevice(const DevIndex: integer): string;
    class procedure GetTripModels(TripModels: TStrings);
    class function GetModelFromDescription(const ModelDescription: string): TGarminModel;
    class function GetModelFromGarminDevice(const GarminDevice: string): TGarminModel;
    class function GetKnownPath(const DevIndex, PathId: integer): string;
    class function Display2Garmin(const CmbIndex: integer): TGarminModel;
    class function Display2Trip(const CmbIndex: integer): TTripModel;
    class function Garmin2Display(const Garmin: TGarminModel): integer;
    class function SafeModel2Write(const TripModel: TTripModel): boolean;
  end;

var
  SetProcessOptions: TSetProcessOptions;
  GarminDevice: TGarminDevice;

implementation

uses
  System.SysUtils,System.StrUtils, System.DateUtils, System.TypInfo,
  Vcl.ComCtrls,
  UnitRegistry, UnitProcessOptions, UnitTripObjects, UnitGpi;

type
  TModel_Rec = record
    DeviceName:  string;
    TripModel:   TTripModel;
    Safe:        boolean;
    Displayable: boolean;
  end;

const
//  TGarminModel  = (XT, XT2, Tread2, Zumo595, Zumo590, Zumo3x0, Drive51, Nuvi2595, GarminEdge, GarminGeneric, Unknown);
  Model_Tab: array[TGarminModel] of TModel_Rec =
  (
    (DeviceName: XT_Name;       TripModel: TTripModel.XT;       Safe: true;   Displayable: true),
    (DeviceName: XT2_Name;      TripModel: TTripModel.XT2;      Safe: true;   Displayable: true),
    (DeviceName: Tread2_Name;   TripModel: TTripModel.Tread2;   Safe: true;   Displayable: true),
    (DeviceName: Zumo595_Name;  TripModel: TTripModel.Zumo595;  Safe: false;  Displayable: true),
    (DeviceName: Zumo590_Name;  TripModel: TTripModel.Zumo590;  Safe: false;  Displayable: true),
    (DeviceName: Zumo3x0_Name;  TripModel: TTripModel.Zumo3x0;  Safe: false;  Displayable: true),
    (DeviceName: Drive51_Name;  TripModel: TTripModel.Drive51;  Safe: false;  Displayable: true),
    (DeviceName: Nuvi2595_Name; TripModel: TTripModel.Nuvi2595; Safe: false;  Displayable: false),
    (DeviceName: Edge_Name;     TripModel: TTripModel.Unknown;  Safe: true;   Displayable: true),
    (DeviceName: Garmin_Name;   TripModel: TTripModel.Unknown;  Safe: true;   Displayable: true),
    (DeviceName: Unknown_Name;  TripModel: TTripModel.Unknown;  Safe: true;   Displayable: true)
  );

procedure TSetProcessOptions.SetFixedPrefs(Sender: Tobject);
begin
  with Sender as TProcessOptions do
  begin
    ProcessBegin := false;
    ProcessEnd := false;
    ProcessVia := false;
    ProcessShape := false;

    TrackColor := GetRegistry(Reg_TrackColor, '');
    MinDistTrackPoint := GetRegistry(Reg_MinDistTrackPoints_Key, 0);  // No filter

    // CurrentModel has entries not valid for Trips. UnitTripObjects should check, and correct.
    TripModel := TModelConv.Display2Trip(GetRegistry(Reg_CurrentModel, 0));
    EnableTripOverview := GetRegistry(Reg_EnableTripOverview, false);
    DefRoadSpeed := GetRegistry(Reg_RoadSpeed_Key, 25);
    RoadSpeedMap[0].Value := GetRegistry(Reg_RoadSpeed_Key + '_01', 108);
    RoadSpeedMap[1].Value := GetRegistry(Reg_RoadSpeed_Key + '_02',  72);
    RoadSpeedMap[2].Value := GetRegistry(Reg_RoadSpeed_Key + '_03',  56);
    RoadSpeedMap[3].Value := GetRegistry(Reg_RoadSpeed_Key + '_04',  50);
    RoadSpeedMap[4].Value := GetRegistry(Reg_RoadSpeed_Key + '_05',  48);
    RoadSpeedMap[5].Value := GetRegistry(Reg_RoadSpeed_Key + '_0C',  15);

    // XT1 and XT2 Defaults
    ScPosn_Unknown1 := StrToIntDef('$' + Copy(GetRegistry(Reg_ScPosn_Unknown1, ''), 3), 0);
    AllowGrouping := GetRegistry(Reg_AllowGrouping, true);
    TripOption := TTripOption(GetRegistry(Reg_TripOption, Ord(TTripOption.ttCalc)));

    // XT2, Tread 2 Defaults
    VehicleProfileGuid := GetRegistry(Reg_VehicleProfileGuid, XT2_VehicleProfileGuid);
    VehicleProfileHash := GetRegistry(Reg_VehicleProfileHash, '0');
    VehicleId := GetRegistry(Reg_VehicleId, XT2_VehicleId);
    VehicleProfileTruckType := GetRegistry(Reg_VehicleProfileTruckType, XT2_VehicleProfileTruckType);
    VehicleProfileName := GetRegistry(Reg_VehicleProfileName, XT2_VehicleProfileName);
    AvoidancesChangedTimeAtSave := StrToIntDef('$' + Copy(GetRegistry(Reg_AvoidancesChangedTimeAtSave, ''), 3),
                                                                      TUnixDate.DateTimeAsCardinal(IncYear(Now, -1)));
    DefAdvLevel := TAdvLevel(GetRegistry(Reg_DefAdvLevel, Ord(TAdvlevel.advLevel2)) -1);

    // GPI defaults
    GpiSymbolsDir := Utf8String(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + DefGpiSymbolsDir +
                       GetRegistry(Reg_GPISymbolSize, '80x80') + '\');
    DefaultProximityStr := GetRegistry(Reg_GPIProximity, '500');
    CompareDistanceOK := GetRegistry(Reg_CompareDistOK_Key, Reg_CompareDistOK_Val);
    MinShapeDist := GetRegistry(Reg_MinShapeDist_Key, Reg_MinShapeDist_Val);

    ProcessCategory := [];
  end;
end;

procedure TSetProcessOptions.SetPostProcessPrefs(Sender: TObject);
var
  WayPtList: TStringList;
begin
  WayPtList := TStringList.Create;
  try
    WayPtList.Text := ProcessCategoryPick;
    with Sender as TProcessOptions do
    begin
      ProcessBegin := GetRegistry(Reg_ProcessBegin, false);
      BeginSymbol := GetRegistry(Reg_BeginSymbol, BeginSymbol);
      BeginStr := GetRegistry(Reg_BeginStr, BeginStr);
      ProcessAddrBegin := GetRegistry(Reg_BeginAddress, false);

      ProcessEnd := GetRegistry(Reg_ProcessEnd, false);
      EndSymbol := GetRegistry(Reg_EndSymbol, EndSymbol);
      EndStr := GetRegistry(Reg_EndStr, EndStr);
      ProcessAddrEnd := GetRegistry(Reg_EndAddress, false);

      ProcessWpt := GetRegistry(Reg_ProcessWpt, false);
      SetProcessCategory(ProcessWpt,
                         GetRegistry(Reg_ProcessCategory, WayPtList[WayPtList.Count -1]));

      ProcessWayPtsInWayPts := GetRegistry(Reg_FuncWayPointWpt, true);
      ProcessViaPtsInWayPts := GetRegistry(Reg_FuncWayPointVia, false);
      ProcessShapePtsInWayPts := GetRegistry(Reg_FuncWayPointShape, false);
      ProcessAddrWayPt := GetRegistry(Reg_WayPtAddress, false);

      ProcessVia := GetRegistry(Reg_ProcessVia, false);
      ProcessAddrVia := GetRegistry(Reg_ViaAddress, false);

      ProcessShape := GetRegistry(Reg_ProcessShape, false);
      ShapingPointName := TShapingPointName(GetRegistry(Reg_ShapingName, Ord(ShapingPointName), TypeInfo(TShapingPointName)));
      DistanceUnit := TDistanceUnit(GetRegistry(Reg_DistanceUnit, Ord(DistanceUnit), TypeInfo(TDistanceUnit)));
      ProcessAddrShape := GetRegistry(Reg_ShapeAddress, false);
    end;
  finally
    WayPtList.Free;
  end;
end;

procedure TSetProcessOptions.SetSendToPrefs(Sender: TObject);
begin
// For creating Waypoints from routes, transferred as Waypoint<name>.gpx, or <name>.gpx
  with Sender as TProcessOptions do
  begin
    ProcessWayPtsInWayPts := GetRegistry(Reg_FuncWayPointWpt, true);
    ProcessViaPtsInWayPts := GetRegistry(Reg_FuncWayPointVia, false);
    ProcessShapePtsInWayPts := GetRegistry(Reg_FuncWayPointShape, false);

    ProcessWayPtsInGpi := GetRegistry(Reg_FuncGpiWayPt, true);
    ProcessViaPtsInGpi := GetRegistry(Reg_FuncGpiViaPt, false);
    ProcessShapePtsInGpi := GetRegistry(Reg_FuncGpiShpPt, false);
  end;
end;

procedure TSetProcessOptions.SetCmdLinePrefs(Sender: TObject);
begin
  SetPostProcessPrefs(Sender);
  SetSendToPrefs(Sender);

  with Sender as TProcessOptions do
    HasConsole := true;
end;

procedure TSetProcessOptions.SetSkipTrackDlgPrefs(Sender: TObject);
begin
  with Sender as TProcessOptions do
    SkipTrackDialog := true;
end;

procedure TSetProcessOptions.SavePrefs(Sender: TObject);
begin
  with Sender as TProcessOptions do
    SetRegistry(Reg_TrackColor, TrackColor);
end;

class procedure TSetProcessOptions.SetPrefs(TvSelections: TObject);
var
  SavedStateChanging: TTVCheckStateChangingEvent;
begin
  with TTreeview(TvSelections) do
  begin
    // Cant uncheck when node is not enabled
    SavedStateChanging := OnCheckStateChanging;
    OnCheckStateChanging := nil;
    try
      Items[IdTrip].Checked := Items[IdTrip].Enabled and GetRegistry(Reg_FuncTrip, true);

      Items[IdTrack].Checked := Items[IdTrack].Enabled and GetRegistry(Reg_FuncTrack, true);

      Items[IdStrippedRoute].Checked := Items[IdStrippedRoute].Enabled and GetRegistry(Reg_FuncStrippedRoute, true);
      Items[IdCompleteRoute].Checked := Items[IdCompleteRoute].Enabled and GetRegistry(Reg_FuncCompleteRoute, false);
      Items[IdWayPoint].Checked := Items[IdWayPoint].Enabled and GetRegistry(Reg_FuncWayPoint, false);
        Items[IdWayPointWpt].Checked := Items[IdWayPointWpt].Enabled and GetRegistry(Reg_FuncWayPointWpt, true);
        Items[IdWayPointVia].Checked := Items[IdWayPointVia].Enabled and GetRegistry(Reg_FuncWayPointVia, false);
        Items[IdWayPointShp].Checked := Items[IdWayPointShp].Enabled and GetRegistry(Reg_FuncWayPointShape, false);

      Items[IdGpi].Checked := Items[IdGpi].Enabled and GetRegistry(Reg_FuncGpi, true);
        Items[IdGpiWayPt].Checked := Items[IdGpiWayPt].Enabled and GetRegistry(Reg_FuncGpiWayPt, true);
        Items[IdGpiViaPt].Checked := Items[IdGpiViaPt].Enabled and GetRegistry(Reg_FuncGpiViaPt, false);
        Items[IdGpiShpPt].Checked := Items[IdGpiShpPt].Enabled and GetRegistry(Reg_FuncGpiShpPt, false);

      Items[IdKml].Checked := Items[IdKml].Enabled and GetRegistry(Reg_FuncKml, true);
      Items[IdHtml].Checked := Items[IdHtml].Enabled and GetRegistry(Reg_FuncHtml, true);

      Items[IdFit].Checked := Items[IdFit].Enabled and GetRegistry(Reg_FuncFit, true);
    finally
      OnCheckStateChanging := SavedStateChanging;
      FullExpand;
    end;
  end;
end;

class function TSetProcessOptions.StorePrefs(TvSelections: TObject): TGPXFuncArray;
begin
  with TTreeView(TvSelections) do
  begin
    if (Items[IdStrippedRoute].Checked) and
       (Items[IdCompleteRoute].Checked) then
      raise Exception.Create('Only one route option can be selected!');

    SetLength(result, 0);

    if (Items[IdTrip].Enabled) then
    begin
      SetRegistry(Reg_FuncTrip, Items[IdTrip].Checked);
      if (Items[IdTrip].Checked) then
        result := result + [TGPXFunc.CreateTrips];
    end;

    if (Items[IdTrack].Enabled) then
    begin
      SetRegistry(Reg_FuncTrack, Items[IdTrack].Checked);
      if (Items[IdTrack].Checked) then
        result := result + [TGPXFunc.CreateTracks];
    end;

    if (Items[IdStrippedRoute].Enabled) then
    begin
      SetRegistry(Reg_FuncStrippedRoute, Items[IdStrippedRoute].Checked);
      if (Items[IdStrippedRoute].Checked) then
        result := result + [TGPXFunc.CreateRoutes];
    end;

    if (Items[IdCompleteRoute].Enabled) then
    begin
      SetRegistry(Reg_FuncCompleteRoute, Items[IdCompleteRoute].Checked);
      if (Items[IdCompleteRoute].Checked) then
        result := result + [TGPXFunc.CreateCompleteRoutes];
    end;

    if (Items[IdWayPoint].Enabled) then
    begin
      SetRegistry(Reg_FuncWayPoint, Items[IdWayPoint].Checked);
      if (Items[IdWayPoint].Checked) then
      begin
        result := result + [TGPXFunc.CreateWayPoints];
        if (Items[IdWayPointWpt].Checked = false) and
           (Items[IdWayPointVia].Checked = false) and
           (Items[IdWayPointShp].Checked = false) then
          raise Exception.Create(Format('Select at least one of: %s %s %s %s %s %s!',
           [#10, Items[IdWayPointWpt].Text,
            #10, Items[IdWayPointVia].Text,
            #10, Items[IdWayPointShp].Text]));
      end;
        SetRegistry(Reg_FuncWayPointWpt, Items[IdWayPointWpt].Checked);
        SetRegistry(Reg_FuncWayPointVia, Items[IdWayPointVia].Checked);
        SetRegistry(Reg_FuncWayPointShape, Items[IdWayPointShp].Checked);
    end;

    if (Items[IdGpi].Enabled) then
    begin
      SetRegistry(Reg_FuncGpi, Items[IdGpi].Checked);
      if (Items[IdGpi].Checked) then
      begin
        result := result + [TGPXFunc.CreatePOI];
        if (Items[IdGpiWayPt].Checked = false) and
           (Items[IdGpiViaPt].Checked = false) and
           (Items[IdGpiShpPt].Checked = false) then
          raise Exception.Create(Format('Select at least one of: %s %s %s %s %s %s!',
           [#10, Items[IdGpiWayPt].Text,
            #10, Items[IdGpiViaPt].Text,
            #10, Items[IdGpiShpPt].Text]));
      end;
        SetRegistry(Reg_FuncGpiWayPt, Items[IdGpiWayPt].Checked);
        SetRegistry(Reg_FuncGpiViaPt, Items[IdGpiViaPt].Checked);
        SetRegistry(Reg_FuncGpiShpPt, Items[IdGpiShpPt].Checked);
    end;

    if (Items[IdKml].Enabled) then
    begin
      SetRegistry(Reg_FuncKml, Items[IdKml].Checked);
      if (Items[IdKml].Checked) then
        result := result + [TGPXFunc.CreateKML];
    end;

    if (Items[IdHtml].Enabled) then
    begin
      SetRegistry(Reg_FuncHtml, Items[IdHtml].Checked);
      if (Items[IdHtml].Checked) then
        result := result + [TGPXFunc.CreateHTML];
    end;

    if (Items[IdFit].Enabled) then
    begin
      SetRegistry(Reg_FuncFit, Items[IdFit].Checked);
      if (Items[IdFit].Checked) then
        result := result + [TGPXFunc.CreateFITPoints];
    end;
  end;
end;

class procedure TSetProcessOptions.CheckSymbolsDir;
var
  SymbolsDir: string;
begin
  SymbolsDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + DefGpiSymbolsDir + GetRegistry(Reg_GPISymbolSize, '');
  SetRegistry(Reg_ValidGpiSymbols, DirectoryExists(SymbolsDir));
end;

class function TModelConv.GetDevices(const Default: boolean): TStringList;
var
  AGarminModel: TGarminModel;
  ModelIndex: integer;
  UnsafeModels: boolean;
begin
  result := TStringList.Create;
  UnsafeModels := TProcessOptions.UnsafeModels;
  ModelIndex := -1;
  for AGarminModel := Low(TGarminModel) to High(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].Displayable) and
       ( (Model_Tab[AGarminModel].Safe) or
          (UnsafeModels) ) then
    begin
      Inc(ModelIndex);
      if (Default) then
        result.AddObject(Model_Tab[AGarminModel].DeviceName, TObject(AGarminModel))
      else
        result.AddObject(GetRegistry(Reg_PrefDev_Key, Model_Tab[AGarminModel].DeviceName, IntToStr(ModelIndex)), TObject(AGarminModel));
    end;
  end;
end;

class function TModelConv.GetKnownDevices: TStringList;
begin
  result := GetDevices(false);
end;

class procedure TModelConv.CmbModelDevices(const Devices: TStrings);
var
  TempDev: TStringList;
begin
  TempDev := GetDevices(true);
  try
    Devices.Assign(TempDev);
  finally
    TempDev.Free;
  end;
end;

class function TModelConv.GetDevice(const Default: boolean; const DevIndex: integer): string;
var
  Devices: TStringList;
begin
  result := '';
  Devices := GetDevices(Default);
  try
    if (DevIndex >= 0) and
       (DevIndex < Devices.Count) then
      result := Devices[DevIndex];
  finally
    Devices.Free;
  end;
end;

class function TModelConv.GetKnownDevice(const DevIndex: integer): string;
begin
  result := GetDevice(false, DevIndex);
end;

class function TModelConv.GetDefaultDevice(const DevIndex: integer): string;
begin
  result := GetDevice(true, DevIndex);
end;

class procedure TModelConv.GetTripModels(TripModels: TStrings);
var
  AGarminModel: TGarminModel;
begin
  TripModels.Clear;

  for AGarminModel := Low(TGarminModel) to High(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].TripModel <> TTripModel.Unknown) then
      TripModels.Add(Model_Tab[AGarminModel].DeviceName)
  end;
  TripModels.Add(Unknown_Name);
end;

class function TModelConv.GetModelFromDescription(const ModelDescription: string): TGarminModel;
var
  AGarminModel: TGarminModel;
  Devices: TStringList;
  DevIndex: integer;
begin
  result := TGarminModel.Unknown;

  // Device name overridden?
  Devices := GetKnownDevices;
  try
    for DevIndex := 0 to Devices.Count -1 do
      if (SameText(ModelDescription, Devices[DevIndex])) then
        exit(TGarminModel(Devices.Objects[DevIndex]));
  finally
    Devices.Free;
  end;

  // Look for default Device names
  // High -> Low, XT Contains XT2
  for AGarminModel := High(TGarminModel) downto Low(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].Displayable) and
       (ContainsText(ModelDescription, Model_Tab[AGarminModel].DeviceName)) then
      exit(AGarminModel);
  end;

end;

class function TModelConv.GetModelFromGarminDevice(const GarminDevice: string): TGarminModel;
begin
  result := TGarminModel.GarminGeneric;
  if (ContainsText(GarminDevice, Edge_Name)) then
    exit(TGarminModel.GarminEdge);
end;

class function TModelConv.GetKnownPath(const DevIndex, PathId: integer): string;
begin
  result := '';
  case Display2Garmin(DevIndex) of
    TGarminModel.XT,
    TGarminModel.XT2,
    TGarminModel.Tread2:
      case PathId of
        0: result := Reg_PrefDevTripsFolder_Val;
        1: result := Reg_PrefDevGpxFolder_Val;
        2: result := Reg_PrefDevPoiFolder_Val;
      end;
    TGarminModel.Zumo595,
    TGarminModel.Drive51:
      case PathId of
        0: result := NonMTPRoot + SystemTripsPath;
      end;
    TGarminModel.Zumo590,
    TGarminModel.Zumo3x0:
      case PathId of
        0: result := NonMTPRoot + SystemTripsPath;
        1: result := GarminDevice.GpxPath;
        2: result := GarminDevice.GpiPath;
      end;
    TGarminModel.GarminEdge:
      case PathId of
        0: result := GarminDevice.CoursePath;
        1: result := GarminDevice.NewFilesPath;
        2: result := GarminDevice.ActivitiesPath;
      end;
    else
      case PathId of
        1: result := GarminDevice.GpxPath;
        2: result := GarminDevice.GpiPath;
      end;
  end;
end;

class function TModelConv.Display2Garmin(const CmbIndex: integer): TGarminModel;
var
  UnsafeModels: boolean;
  ModelIndex: integer;
  AGarminModel: TGarminModel;
begin
  result := TGarminModel.Unknown;
  UnsafeModels := TProcessOptions.UnsafeModels;
  ModelIndex := -1;
  for AGarminModel := Low(TGarminModel) to High(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].Displayable) and
       ( (Model_Tab[AGarminModel].Safe) or
         (UnsafeModels)) then
      Inc(ModelIndex);
    if (ModelIndex = CmbIndex) then
      exit(AGarminModel);
  end;
end;

class function TModelConv.Display2Trip(const CmbIndex: integer): TTripModel;
begin
  result := Model_Tab[Display2Garmin(CmbIndex)].TripModel;
end;

class function TModelConv.Garmin2Display(const Garmin: TGarminModel): integer;
var
  UnsafeModels: boolean;
  AGarminModel: TGarminModel;
  SafeGarmin: TGarminModel;
begin
  UnsafeModels := TProcessOptions.UnsafeModels;

  SafeGarmin := Garmin;
  if (UnsafeModels = false) and
     (Model_Tab[SafeGarmin].Safe = false) then
    SafeGarmin := TGarminModel.GarminGeneric;

  result := -1;
  for AGarminModel := Low(TGarminModel) to High(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].Displayable) and
       ( (Model_Tab[AGarminModel].Safe) or
         (UnsafeModels)) then
      Inc(result);
    if (AGarminModel = SafeGarmin) then
      exit;
  end;
end;

class function TModelConv.SafeModel2Write(const TripModel: TTripModel): boolean;
var
  AGarminModel: TGarminModel;
begin
  result := false;
  for AGarminModel := Low(TGarminModel) to High(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].TripModel = TripModel) then
      exit(Model_Tab[AGarminModel].Safe);
  end;
end;

// Default paths. Can be overruled by GarminDevice.Xml
procedure TGarminDevice.Init;
begin
  CoursePath      := NonMTPRoot + GarminPath + '\Courses';
  NewFilesPath    := NonMTPRoot + GarminPath + '\NewFiles';
  ActivitiesPath  := NonMTPRoot + GarminPath + '\Activities';
  GpxPath         := NonMTPRoot + GarminPath + '\GPX';
  GpiPath         := NonMTPRoot + GarminPath + '\POI';
end;

initialization
  SetProcessOptions := TSetProcessOptions.Create;
  GarminDevice.Init;

finalization
  SetProcessOptions.Free;

end.
