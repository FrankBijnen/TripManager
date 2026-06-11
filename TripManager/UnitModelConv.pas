unit UnitModelConv;

interface

uses
  System.SysUtils, System.Classes,
  UnitBaseMTP, UnitTripDefs, UnitGpxDefs, UnitGarminDevice;

const
  // Device recognition constants
  InternalStorage                   = 'Internal Storage\';
  DefTripsPath                      = 'Trips';
  DefTripsDesc                      = 'Trips';
  SystemPath                        = '.System';
  SystemTripsPath                   = SystemPath + '\' + DefTripsPath;
  NonMTPRoot                        = '?:\';
  DefGarminPath                     = 'Garmin';
  DefSQLitePath                     = '\SQlite';
  SystemDb                          = 'system.db';
  SettingsDb                        = 'settings.db';
  ProfileDb                         = 'vehicle_profile.db';
  ExploreDb                         = 'explore.db';
  GarminDeviceXML                   = 'GarminDevice.xml';
  Reg_UnsafeModels                  = 'UnsafeModels';
  Reg_PrefDev_Key                   = 'PrefDevice';
  Reg_PrefDevTripsFolder_Key        = 'PrefDeviceTripsFolder';
  Reg_PrefDevGpxFolder_Key          = 'PrefDeviceGpxFolder';
  DefGPXPath                        = 'GPX';
  DefGPXDesc                        = 'Gpx';
  Reg_PrefDevPoiFolder_Key          = 'PrefDevicePoiFolder';
  DefPOIPath                        = 'POI';
  DefPOIDesc                        = 'Poi (Gpi)';
  DefCoursesPath                    = 'Courses';
  DefNewFilesPath                   = 'NewFiles';
  DefActivitiesPath                 = 'Activities';
  DefUnusedDesc                     = 'Unused';

  // Device names and part numbers
  Zumo_Name                         = 'z' + #0363 + 'mo'; // Dont need to save as UTF8

  // XT
  XT_Name                           = Zumo_Name + ' XT';
  XT_PartNumber                     = '006-B3484-00';

  // XT2
  XT2_Name                          = Zumo_Name + ' XT2';
  XT2_PartNumber                    = '006-B4299-00';

  // XT3
  XT3_Name                          = Zumo_Name + ' XT3';
  XT3_PartNumber                    = '006-B4782-00';

  // Tread 2 is almost an XT2
  Tread2_Name                       = 'Tread 2';
  Tread2_PartNumber                 = '006-B4557-00';

  // Generic Garmin & Edge & ForeRunner
  Garmin_Name                       = 'Garmin';
  Edge_Name                         = 'Edge';
  ForeRunner_Name                   = 'ForeRunner';

  // Older models
  Zumo346_Name                      = Zumo_Name + ' 346';
  Zumo346_PartNumber                = '006-B3033-00';

  Zumo595_Name                      = Zumo_Name + ' 595';
  Zumo595_PartNumber                = '006-B2436-00';

  Zumo590_Name                      = Zumo_Name + ' 590';
  Zumo590_PartNumber                = '006-B1796-00';

  Drive51_Name                      = Garmin_Name + ' Drive 51';
  Drive51_PartNumber                = '006-B2586-00';

  Drive66_Name                      = Garmin_Name + ' DriveSmart 66';
  Drive66_PartNumber                = '006-B3817-00';

  Zumo3x0_Name                      = Zumo_Name + ' 3x0';
  Zumo3x0_PartNumber                = '006-B1473-00';

  Nuvi2595_Name                     = 'n' + #0252 + 'vi 2595';
  Nuvi2595_PartNumber               = '006-B1371-00';

  Nuvi57_Name                       = 'n' + #0252 + 'vi 57';
  Nuvi57_PartNumber                 = '006-B2087-00';

  // Unknown
  Unknown_Name                      = 'Unknown';

  // Defaults vehicle profile
  DEF_VehicleProfileGuid            = '00000000-0000-0000-0000-000000000000';
  DEF_VehicleId                     = 1;
  DEF_VehicleProfileTruckType       = 7;
  DEF_VehicleProfileName            = Zumo_Name + ' Motorcycle';

type
  TGarminFmt = (gaTrips, gaGPX, gaPOI, gaFit);

  TModelConv = class
  private
    class function Device2Display(const DeviceName: string): string;
    class function GetDevices(const Default: boolean): TStringList;
    class function GetTripModels: TStringList;
    class function KnownDeviceIndex(const DeviceList: TList; const APartPrio: TPartitionPrio): integer;
    class function GetPreferredPrioDevice(const InsertedDevices: TStringList;
                                          const DevicePrio: TPartitionPrio;
                                          const DeviceList: Tlist): TBase_Device;
  public
    class procedure SetupKnownDevices;
    class procedure CmbModelDevices(const Devices: TStrings);
    class function GetKnownDevice(const DevIndex: integer): string;
    class function GetDefaultDevice(const DevIndex: integer): string;
    class function GetTripModel(const TripModel: TTripModel): string;
    class procedure CmbTripDevices(const Devices: TStrings);
    class function GetModelFromGarminDevice(const GarminDevice: TGarminDevice): TGarminModel;
    class function GuessGarminGeneric(const GarminDevice: string): TGarminModel;
    class function GetKnownPath(const GarminDevice: TGarminDevice; const PathId: integer): string; overload;
    class function GetKnownPath(const AGarminModel: TGarminModel; const PathId: integer): string; overload;
    class function GetKnownPath(const CurrentDevice: TObject; const PathId: integer): string; overload;
    class function GetKnownGarminPath(const CurrentDevice: TObject;
                                      const RegKey: string;
                                      const ModelIndex, PathId: integer): string;
    class function Display2Garmin(const CmbIndex: integer): TGarminModel;
    class function Display2Trip(const CmbIndex: integer): TTripModel;
    class function Garmin2Display(const Garmin: TGarminModel): integer;
    class function Garmin2Trip(const Garmin: TGarminModel): TTripModel;
    class function GarminFmtsDesc(const Garmin: TGarminModel): string;
    class function SupportsGarminFormat(const Garmin: TGarminModel; const Fmt: TGarminFmt): boolean;
    class function ReadDeviceDB(const Garmin: TGarminModel): boolean;
    class function ReadVehicleDB(const Garmin: TGarminModel): boolean;
    class function ReadExploreDB(const Garmin: TGarminModel): boolean;
    class function SafeModel2Write(const TripModel: TTripModel): boolean;
    class function SafeGarminModel(const Garmin: TGarminModel): boolean;
    class function DisplayableGarminModel(const Garmin: TGarminModel): boolean;
    class function IsKnownDevice(const Device: TObject): boolean;
    class function FirstKnownDeviceIndex(const DeviceList: TList): integer;
    class function GetPreferredDevice(const InsertedDevices: TStringList;
                                      const DeviceList: Tlist): TBase_Device;
  end;

implementation

uses
  System.StrUtils, System.Masks, System.Types,
  UnitVerySimpleXml, UnitStringUtils,
  UnitProcessOptions, UnitRegistry, UnitRegistryKeys;

type
  TGarminModel_Rec = record
    DeviceName:  string;
    PartNumber:  string;
    TripModel:   TTripModel;
    Safe:        boolean;
    Displayable: boolean;
    DevDB:       boolean;
    VehicleDB:   boolean;
    ExploreDB:   boolean;
    GarminFmts:  string;
  end;
  TGarminFmts = (gfTripsGPXPOI, gfTrips, gfFitGPX, gfGPXPOI);

const
  TripsGPXPOIFmts  = 'Trips,GPX,POI';
  TripsFmts        = 'Trips';
  FitGPXFmts       = 'Fit,GPX';
  GPXPOIFmts       = 'GPX,POI';

  GarminFmtsMap : array[0..3] of TIdentMapEntry = ( (Value: Ord(gfTripsGPXPOI); Name: TripsGPXPOIFmts),
                                                    (Value: Ord(gfTrips);       Name: TripsFmts),
                                                    (Value: Ord(gfFitGPX);      Name: FitGPXFmts),
                                                    (Value: Ord(gfGPXPOI);      Name: GPXPOIFmts)
                                                  );

  Model_Tab: array[TGarminModel] of TGarminModel_Rec =
  (
    (DeviceName: XT_Name;
        PartNumber: XT_PartNumber;
        TripModel: TTripModel.XT;
        Safe: true;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: true;
        GarminFmts: TripsGPXPOIFmts),
    (DeviceName: XT2_Name;
        PartNumber: XT2_PartNumber;
        TripModel: TTripModel.XT2;
        Safe: true;
        Displayable: true;
        DevDB: true;
        VehicleDB: true;
        ExploreDB: true;
        GarminFmts: TripsGPXPOIFmts),
    (DeviceName: XT3_Name;
        PartNumber: XT3_PartNumber;
        TripModel: TTripModel.XT3;
        Safe: true;
        Displayable: true;
        DevDB: true;
        VehicleDB: true;
        ExploreDB: true;
        GarminFmts: TripsGPXPOIFmts),
    (DeviceName: Tread2_Name;
        PartNumber: Tread2_PartNumber;
        TripModel: TTripModel.Tread2;
        Safe: true;
        Displayable: true;
        DevDB: true;
        VehicleDB: true;
        ExploreDB: true;
        GarminFmts: TripsGPXPOIFmts),
    (DeviceName: Zumo346_Name;
        PartNumber: Zumo346_PartNumber;
        TripModel: TTripModel.Zumo346;
        Safe: false;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: TripsFmts),
    (DeviceName: Zumo595_Name;
        PartNumber: Zumo595_PartNumber;
        TripModel: TTripModel.Zumo595;
        Safe: false;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: TripsFmts),
    (DeviceName: Zumo590_Name;
        PartNumber: Zumo590_PartNumber;
        TripModel: TTripModel.Zumo590;
        Safe: false;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: TripsFmts),
    (DeviceName: Zumo3x0_Name;
        PartNumber: Zumo3x0_PartNumber;
        TripModel: TTripModel.Zumo3x0;
        Safe: false;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: TripsGPXPOIFmts),
    (DeviceName: Drive51_Name;
        PartNumber: Drive51_PartNumber;
        TripModel: TTripModel.Drive51;
        Safe: false;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: TripsFmts),
    (DeviceName: Drive66_Name;
        PartNumber: Drive66_PartNumber;
        TripModel: TTripModel.Drive66;
        Safe: false;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: TripsGPXPOIFmts),
    (DeviceName: Nuvi2595_Name;
        PartNumber: Nuvi2595_PartNumber;
        TripModel: TTripModel.Nuvi2595;
        Safe: false;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: TripsGPXPOIFmts),
    (DeviceName: Nuvi57_Name;
        PartNumber: Nuvi57_PartNumber;
        TripModel: TTripModel.Nuvi57;
        Safe: false;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: TripsFmts),
    (DeviceName: Edge_Name;
        TripModel: TTripModel.Unknown;
        Safe: true;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: FitGPXFmts),
    (DeviceName: ForeRunner_Name;
        TripModel: TTripModel.Unknown;
        Safe: true;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: FitGPXFmts),
    (DeviceName: Garmin_Name;
        TripModel: TTripModel.Unknown;
        Safe: true;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false;
        GarminFmts: GPXPOIFmts),
    (DeviceName: Unknown_Name;
        TripModel: TTripModel.Unknown;
        Safe: true;
        Displayable: true;
        DevDB: false;
        VehicleDB: false;
        ExploreDB: false)
  );

var
  DefaultDevices: TStringList;
  KnownDevices: TStringList;
  TripModels: TStringList;

// Only keep the last 2 words in the displayed device name
class function TModelConv.Device2Display(const DeviceName: string): string;
var
  Splitted: TStringDynArray;
begin
  result := Devicename;
  Splitted := SplitString(DeviceName, ' ');
  if (High(Splitted) > 0) then
    result := Format('%s %s', [Splitted[High(Splitted) -1], Splitted[High(Splitted)]]);
end;

class function TModelConv.GetDevices(const Default: boolean): TStringList;
var
  AGarminModel: TGarminModel;
  UnsafeModels: boolean;
begin
  result := TStringList.Create;
  UnsafeModels := TProcessOptions.UnsafeModels;
  for AGarminModel := Low(TGarminModel) to High(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].Displayable) and
       ( (Model_Tab[AGarminModel].Safe) or (UnsafeModels) ) then
    begin
      if (Default) then
        result.AddObject(Device2Display(Model_Tab[AGarminModel].DeviceName),
                         TObject(AGarminModel))
      else
        result.AddObject(GetRegistry(Reg_PrefDev_Key, Model_Tab[AGarminModel].DeviceName, Model_Tab[AGarminModel].DeviceName),
                         TObject(AGarminModel));
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

class function TModelConv.GetModelFromGarminDevice(const GarminDevice: TGarminDevice): TGarminModel;
var
  AGarminModel: TGarminModel;
  DevIndex: integer;
begin
  result := TGarminModel.Unknown;

  for DevIndex := 0 to KnownDevices.Count -1 do
  begin
    AGarminModel := TGarminModel(KnownDevices.Objects[DevIndex]);

    // Check possibly overriden Device Name
    if (SameText(GarminDevice.ModelDescription, KnownDevices[DevIndex])) then
      exit(AGarminModel);

    // Check for known PartNumbers
    if (Model_Tab[AGarminModel].PartNumber <> '') and
       (SameText(GarminDevice.PartNumber, Model_Tab[AGarminModel].PartNumber)) then
      exit(AGarminModel);
  end;

  // Check for known Device Name. If the PartNumber did not match.
  // EG: Garmin Generic, Edge, ForeRunner etc.
  // High to Low, because of ContainsText. Dont Identify the XT3, XT2 as XT
  for DevIndex := KnownDevices.Count -1 downto 0 do
  begin
    AGarminModel := TGarminModel(KnownDevices.Objects[DevIndex]);

    if (ContainsText(GarminDevice.ModelDescription, Model_Tab[AGarminModel].DeviceName)) then
      exit(AGarminModel);
  end;

  // Return Unknown
end;

class function TModelConv.GuessGarminGeneric(const GarminDevice: string): TGarminModel;
begin
  result := TGarminModel.GarminGeneric;
  if (ContainsText(GarminDevice, Edge_Name)) then
    exit(TGarminModel.GarminEdge);
  if (ContainsText(GarminDevice, ForeRunner_Name)) then
    exit(TGarminModel.GarminForeRunner);
end;

class function TModelConv.GetKnownPath(const GarminDevice: TGarminDevice; const PathId: integer): string;
var
  GarminFmts: integer;
begin
  result := '';

  IdentToInt(Model_Tab[GarminDevice.GarminModel].GarminFmts, GarminFmts, GarminFmtsMap);
  case TGarminFmts(GarminFmts) of
    gfTripsGPXPOI:
      case PathId of
        0: result := GarminDevice.TripsPath;
        1: result := GarminDevice.GPXPath;
        2: result := GarminDevice.GpiPath;
      end;
    gfTrips:
      case PathId of
        0: result := GarminDevice.TripsPath;
      end;
    gfFitGPX:
      case PathId of
        0: result := GarminDevice.CoursesPath;
        1: result := GarminDevice.NewFilesPath;
        2: result := GarminDevice.ActivitiesPath;
      end;
    else
    begin
      case PathId of
        1: result := GarminDevice.GpxPath;
        2: result := GarminDevice.GpiPath;
      end;
    end;
  end;
end;

class function TModelConv.GetKnownPath(const AGarminModel: TGarminModel; const PathId: integer): string;
begin
  DefaultGarminDevice.Init(AGarminModel);
  result := GetKnownPath(DefaultGarminDevice, PathId);
end;

class function TModelConv.GetKnownPath(const CurrentDevice: TObject; const PathId: integer): string;
var
  GarminDevice: TGarminDevice;
begin
  result := '';
  if (Assigned(CurrentDevice)) and
     (CurrentDevice is TGarminMTP_Device) then
  begin
    // If we have a device, get the paths from the GarminDevice.xml
    GarminDevice := TGarminMTP_Device(CurrentDevice).GarminDevice;
    result := GetKnownPath(GarminDevice, PathId);
  end;
end;

class function TModelConv.GetKnownGarminPath(const CurrentDevice: TObject;
                                             const RegKey: string;
                                             const ModelIndex, PathId: integer): string;
var
  SubKey: string;
begin
  SubKey := GetDefaultDevice(ModelIndex);

  result  := GetRegistry(RegKey,
                         GetKnownPath(CurrentDevice, PathId),
                         SubKey);
  if (result <> '') and
     (Assigned(CurrentDevice)) and
     (CurrentDevice is TGarminMTP_Device) and
     (TGarminMTP_Device(CurrentDevice).PathId[result] = '') then
      result := GetKnownPath(TGarminMTP_Device(CurrentDevice).GarminDevice, PathId);
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

// Also checks for safe model
class function TModelConv.Garmin2Trip(const Garmin: TGarminModel): TTripModel;
begin
  result := Display2Trip(Garmin2Display(Garmin));
end;

class function TModelConv.GarminFmtsDesc(const Garmin: TGarminModel): string;
begin
  result := Model_Tab[Garmin].GarminFmts;
end;

class function TModelConv.SupportsGarminFormat(const Garmin: TGarminModel; const Fmt: TGarminFmt): boolean;
var
  GaFmt: integer;
  GarminFmt: TGarminFmts;
begin
  result := false;

  IdentToInt(Model_Tab[Garmin].GarminFmts, GaFmt, GarminFmtsMap);
  GarminFmt := TGarminFmts(GaFmt);
  case Fmt of
    gaTrips:  result := (GarminFmt in [gfTripsGPXPOI, gfTrips]);
    gaGPX:    result := (GarminFmt in [gfTripsGPXPOI, gfFitGPX, gfGPXPOI]);
    gaPOI:    result := (GarminFmt in [gfTripsGPXPOI, gfGPXPOI]);
    gaFIT:    result := (GarminFmt in [gfFitGPX]);
  end;
end;

class function TModelConv.ReadDeviceDB(const Garmin: TGarminModel): boolean;
begin
  result := Model_Tab[Garmin].DevDB;
end;

class function TModelConv.ReadVehicleDB(const Garmin: TGarminModel): boolean;
begin
  result := Model_Tab[Garmin].VehicleDB;
end;

class function TModelConv.ReadExploreDB(const Garmin: TGarminModel): boolean;
begin
  result := Model_Tab[Garmin].ExploreDB;
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

class function TModelConv.SafeGarminModel(const Garmin: TGarminModel): boolean;
begin
  result := (Garmin2Trip(Garmin) <> TTripModel.Unknown);
end;

class function TModelConv.DisplayableGarminModel(const Garmin: TGarminModel): boolean;
begin
  result := Model_Tab[Garmin].Displayable;
end;

// When a device is inserted, is it known?
class function TModelConv.IsKnownDevice(const Device: TObject): boolean;
var
  KnownIndex: integer;
begin
  // Dont want Cards, usually they are part of the real device.
  if (TBase_Device(Device).PartitionPrio = TPartitionPrio.ppLow) then
    exit(false);

  // Look in Known devices
  if (KnownDevices.IndexOf(TGarminMTP_Device(Device).FriendlyName) > -1)  then
    exit(true);

  for KnownIndex := KnownDevices.Count -1 downto 0  do
  begin
    if (MatchesMask(TBase_Device(Device).DisplayedDevice, KnownDevices[KnownIndex])) then
      exit(true);
  end;

  // Look for manufacturer Garmin
  result := (SameText(TBase_Device(Device).Manufacturer, Garmin_Name));
end;

// Get first known device in connected list, for this prio
class function TModelConv.KnownDeviceIndex(const DeviceList: TList; const APartPrio: TPartitionPrio): integer;
var
  KnownIndex, DevIndex: integer;
begin
  result := -1;

  // First check known devices
  for DevIndex := 0 to DeviceList.Count -1 do
  begin
    // Check PartitionPrio
    if (TBase_Device(DeviceList[DevIndex]).PartitionPrio <> APartPrio) then
      continue;

    // Check known devices
    if (KnownDevices.IndexOf(TGarminMTP_Device(DeviceList[DevIndex]).FriendlyName) > -1)  then
      exit(DevIndex);

    // Check overridden device names
    for KnownIndex := KnownDevices.Count -1 downto 0 do
    begin
      // Allow wildcards for mass storage devices. EG ?:\Garmin
      if (MatchesMask(TBase_Device(DeviceList[DevIndex]).DisplayedDevice, KnownDevices[KnownIndex])) then
        exit(DevIndex);
    end;
  end;

  // Check manufacturer Garmin. Generic support GPX/POI
  for DevIndex := 0 to DeviceList.Count -1 do
  begin
    if (TBase_Device(DeviceList[DevIndex]).PartitionPrio <> APartPrio) then
      continue;
    if (SameText(TBase_Device(DeviceList[DevIndex]).Manufacturer, Garmin_Name)) then
      exit(DevIndex);
  end;

end;

// Device selection order.
// Note: Cards are not selected
class function TModelConv.FirstKnownDeviceIndex(const DeviceList: Tlist): integer;
begin
  result := -1;
  if (TProcessOptions.UnsafeModels) then
    result := KnownDeviceIndex(DeviceList, TPartitionPrio.ppHigh);
  if (result < 0) then
    result := KnownDeviceIndex(DeviceList, TPartitionPrio.ppNorm);
end;

class function TModelConv.GetPreferredPrioDevice(const InsertedDevices: TStringList;
                                                 const DevicePrio: TPartitionPrio;
                                                 const DeviceList: Tlist): TBase_Device;
var
  CurIndex: integer;
  TmpDev: string;
begin
  result := nil;
  for TmpDev in InsertedDevices do
  begin
    CurIndex := TBase_Device.DeviceIdInList(TmpDev, DeviceList);
    if (CurIndex > -1) and
       (TModelConv.IsKnownDevice(TBase_Device(DeviceList[CurIndex]))) and
       (TBase_Device(DeviceList[CurIndex]).PartitionPrio = DevicePrio) then
      exit(TBase_Device(DeviceList[CurIndex]));
  end;
end;

// The 590/595 in MassStorage mode and RWFS enabled have at least 2 partitions:
// System. No trips
// System1. That has the trips. Prefer that from InsertedDevices.
class function TModelConv.GetPreferredDevice(const InsertedDevices: TStringList;
                                             const DeviceList: Tlist): TBase_Device;
begin
  result := nil;
  if (TProcessOptions.UnsafeModels) then
    result := GetPreferredPrioDevice(InsertedDevices, TPartitionPrio.ppHigh, DeviceList);
  if (result = nil) then
    result := GetPreferredPrioDevice(InsertedDevices, TPartitionPrio.ppNorm, DeviceList);
end;

initialization
  // Load default device names
  DefaultDevices := TModelConv.GetDevices(true);

  // Load overridden device names
  KnownDevices := TStringList.Create;
  TModelConv.SetupKnownDevices;

  // Load TripModels
  TripModels := TModelConv.GetTripModels;

finalization
  DefaultDevices.Free;
  KnownDevices.Free;
  TripModels.Free;

end.
