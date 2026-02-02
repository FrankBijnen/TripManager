unit UnitModelConv;

interface

uses
  System.SysUtils, System.Classes,
  UnitTripDefs, UnitGpxDefs;

const
  // Device recognition constants
  InternalStorage                   = 'Internal Storage\';
  TripsPath                         = 'Trips';
  SystemTripsPath                   = '.System\' + TripsPath;
  NonMTPRoot                        = '?:\';
  GarminPath                        = 'Garmin';
  SystemDb                          = 'system.db';
  SettingsDb                        = 'settings.db';
  ProfileDb                         = 'vehicle_profile.db';
  ExploreDb                         = 'explore.db';
  GarminDeviceXML                   = 'GarminDevice.xml';
  Reg_UnsafeModels                  = 'UnsafeModels';
  Reg_PrefDev_Key                   = 'PrefDevice';
  Reg_PrefDevTripsFolder_Key        = 'PrefDeviceTripsFolder';
  Reg_PrefDevTripsFolder_Val        = InternalStorage + SystemTripsPath;

  Reg_PrefDevGpxFolder_Key          = 'PrefDeviceGpxFolder';
  Reg_PrefDevGpxFolder_Val          = InternalStorage + 'GPX';
  Reg_PrefDevPoiFolder_Key          = 'PrefDevicePoiFolder';
  Reg_PrefDevPoiFolder_Val          = InternalStorage + 'POI';

  // Device names
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

type

  TGarminDevice = class
    GarminModel: TGarminModel;
    ModelDescription: string;
    GpxPath: string;
    GpiPath: string;
    CoursePath: string;
    NewFilesPath: string;
    ActivitiesPath: string;
    procedure Init;
  end;

  TModelConv = class
  private
    class function GetDevices(const Default: boolean): TStringList;
    class function GetTripModels: TStringList;
  public
    class procedure SetupKnownDevices;
    class procedure CmbModelDevices(const Devices: TStrings);
    class function GetKnownDevice(const DevIndex: integer): string;
    class function GetDefaultDevice(const DevIndex: integer): string;
    class function GetTripModel(const TripModel: TTripModel): string;
    class procedure CmbTripDevices(const Devices: TStrings);
    class function GetModelFromDescription(const ModelDescription: string): TGarminModel;
    class function GuessGarminOrEdge(const GarminDevice: string): TGarminModel;
    class function GetKnownPath(const DevIndex, PathId: integer): string;
    class function Display2Garmin(const CmbIndex: integer): TGarminModel;
    class function Display2Trip(const CmbIndex: integer): TTripModel;
    class function Garmin2Display(const Garmin: TGarminModel): integer;
    class function SafeModel2Write(const TripModel: TTripModel): boolean;
    class function KnownDeviceIndex(const DeviceList: Tlist): integer;
    class function IsKnownDevice(const DisplayedDevice: string): boolean;
  end;

var
  GarminDevice: TGarminDevice;

implementation

uses
  System.StrUtils,
  UnitMtpDevice, UnitProcessOptions, UnitRegistry, UnitRegistryKeys;

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
    (DeviceName: Nuvi2595_Name; TripModel: TTripModel.Nuvi2595; Safe: false;  Displayable: true),
    (DeviceName: Edge_Name;     TripModel: TTripModel.Unknown;  Safe: true;   Displayable: true),
    (DeviceName: Garmin_Name;   TripModel: TTripModel.Unknown;  Safe: true;   Displayable: true),
    (DeviceName: Unknown_Name;  TripModel: TTripModel.Unknown;  Safe: true;   Displayable: true)
  );

var
  DefaultDevices: TStringList;
  KnownDevices: TStringList;
  TripModels: TStringList;

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

class procedure TModelConv.SetupKnownDevices;
begin
  KnownDevices.Free;
  KnownDevices := GetDevices(false);
end;

class procedure TModelConv.CmbModelDevices(const Devices: TStrings);
begin
  Devices.Assign(DefaultDevices);
end;

class function TModelConv.GetKnownDevice(const DevIndex: integer): string;
begin
  if (DevIndex < 0) or
     (DevIndex > KnownDevices.Count -1) then
    exit('');

  result := KnownDevices[DevIndex];
end;

class function TModelConv.GetDefaultDevice(const DevIndex: integer): string;
begin
  if (DevIndex < 0) or
     (DevIndex > DefaultDevices.Count -1) then
    exit('');
  result := DefaultDevices[DevIndex];
end;

class function TModelConv.GetTripModel(const TripModel: TTripModel): string;
begin
  if (Ord(TripModel) < 0) or
     (Ord(TripModel) > TripModels.Count -1) then
    exit(Unknown_Name);
  result := TripModels[Ord(TripModel)];
end;

class function TModelConv.GetTripModels: TStringList;
var
  AGarminModel: TGarminModel;
begin
  result := TStringList.Create;
  for AGarminModel := Low(TGarminModel) to High(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].TripModel <> TTripModel.Unknown) then
      result.Add(Model_Tab[AGarminModel].DeviceName)
  end;
  result.Add(Unknown_Name);
end;

class procedure TModelConv.CmbTripDevices(const Devices: TStrings);
begin
  Devices.Assign(TripModels);
end;

class function TModelConv.GetModelFromDescription(const ModelDescription: string): TGarminModel;
var
  AGarminModel: TGarminModel;
  DevIndex: integer;
begin
  result := TGarminModel.Unknown;

  // Device name overridden?
  for DevIndex := 0 to KnownDevices.Count -1 do
    if (SameText(ModelDescription, KnownDevices[DevIndex])) then
      exit(TGarminModel(KnownDevices.Objects[DevIndex]));


  // Look for default Device names
  // High -> Low, XT Contains XT2
  for AGarminModel := High(TGarminModel) downto Low(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].Displayable) and
       (ContainsText(ModelDescription, Model_Tab[AGarminModel].DeviceName)) then
      exit(AGarminModel);
  end;

end;

class function TModelConv.GuessGarminOrEdge(const GarminDevice: string): TGarminModel;
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
    TGarminModel.Nuvi2595:
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
begin
  if (CmbIndex < 0) or
     (CmbIndex > DefaultDevices.Count -1) then
    exit(TGarminModel.Unknown);
  result := TGarminModel(DefaultDevices.Objects[CmbIndex]);
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

class function TModelConv.KnownDeviceIndex(const DeviceList: Tlist): integer;
var
  KnownIndex, DevIndex: integer;
begin
  result := -1;
  for KnownIndex := KnownDevices.Count -1 downto 0 do
  begin
    for DevIndex := 0 to DeviceList.Count -1 do
    begin
      if (StartsText(KnownDevices[KnownIndex], TMTP_Device(DeviceList[DevIndex]).DisplayedDevice)) then
        exit(DevIndex);
    end;
  end;
end;

class function TModelConv.IsKnownDevice(const DisplayedDevice: string): boolean;
var
  KnownIndex: integer;
begin
  result := false;
  for KnownIndex := KnownDevices.Count -1 downto 0  do
  begin
    if (StartsText(KnownDevices[KnownIndex], DisplayedDevice)) then
      exit(true);
  end;
end;

// Default paths. Will be overruled by GarminDevice.Xml
procedure TGarminDevice.Init;
begin
  GarminModel       := TGarminModel.Unknown;
  ModelDescription  := Unknown_Name;
  CoursePath        := NonMTPRoot + GarminPath + '\Courses';
  NewFilesPath      := NonMTPRoot + GarminPath + '\NewFiles';
  ActivitiesPath    := NonMTPRoot + GarminPath + '\Activities';
  GpxPath           := NonMTPRoot + GarminPath + '\GPX';
  GpiPath           := NonMTPRoot + GarminPath + '\POI';
end;

initialization
  // Load default device names
  DefaultDevices := TModelConv.GetDevices(true);

  // Load overridden device names
  KnownDevices := TStringList.Create;
  TModelConv.SetupKnownDevices;

  // Load TripModels
  TripModels := TModelConv.GetTripModels;

  GarminDevice := TGarminDevice.Create;

finalization
  DefaultDevices.Free;
  KnownDevices.Free;
  TripModels.Free;

  GarminDevice.Free;

end.
