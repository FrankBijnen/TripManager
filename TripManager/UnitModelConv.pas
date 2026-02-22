unit UnitModelConv;

interface

uses
  System.SysUtils, System.Classes,
  UnitMtpDevice,
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
  GPXPath                           = 'GPX';
  Reg_PrefDevGpxFolder_Val          = InternalStorage + GPXPath;
  Reg_PrefDevPoiFolder_Key          = 'PrefDevicePoiFolder';
  POIPath                           = 'POI';
  Reg_PrefDevPoiFolder_Val          = InternalStorage + POIPath;

  // Device names
  Zumo_Name                         = 'z' + #0363 + 'mo'; // Dont need to save as UTF8

  // XT
  XT_Name                           = Zumo_Name + ' XT';
  XT_PartNumber                     = '006-B3484-00';

  // XT2
  XT2_Name                          = Zumo_Name + ' XT2';
  XT2_VehicleProfileGuid            = 'dbcac367-42c5-4d01-17aa-ecfe025f2d1c';
  XT2_VehicleId                     = '1';
  XT2_VehicleProfileTruckType       = '7';
  XT2_VehicleProfileName            = Zumo_Name + ' Motorcycle';
//TODO Get partnumber
  XT2_PartNumber                    = 'XT2_NOT_EXIST';

  // XT3
  XT3_Name                          = Zumo_Name + ' XT3';
  XT3_PartNumber                    = '006-B4782-00';

  // Tread 2 is almost an XT2
  Tread2_Name                       = 'Tread 2';
  Tread2_PartNumber                 = '006-B4557-00';

  // Generic Garmin & Edge
  Garmin_Name                       = 'Garmin';
  Edge_Name                         = 'Edge';

  // Older models
  Zumo595_Name                      = Zumo_Name + ' 595';
  Zumo595_PartNumber                = '006-B2436-00';

  Zumo590_Name                      = Zumo_Name + ' 590';
  Zumo590_PartNumber                = '006-B1796-00';
  System1Partition                  = 'System1';

  Drive51_Name                      = Garmin_Name + ' Drive 51';
  Drive51_PartNumber                = '006-B2586-00';

  Drive66_Name                      = Garmin_Name + ' DriveSmart 66';
  Drive66_PartNumber                = '006-B3817-00';

  Zumo3x0_Name                      = Zumo_Name + ' 3x0';
  Zumo3x0_PartNumber                = '006-B1473-00';

  Nuvi2595_Name                     = 'n' + #0252 + 'vi 2595';
  Nuvi2595_PartNumber               = '006-B1371-00';

  // Unknown
  Unknown_Name                      = 'Unknown';

  CardPartition                     = 'Card';

type

  TPartitionPrio = (ppLow, ppNorm, ppHigh);

  TModelConv = class
  private
    class function Device2Display(const DeviceName: string): string;
    class function GetDevices(const Default: boolean): TStringList;
    class function GetTripModels: TStringList;
  public
    class procedure SetupKnownDevices;
    class procedure CmbModelDevices(const Devices: TStrings);
    class function GetKnownDevice(const DevIndex: integer): string;
    class function GetDefaultDevice(const DevIndex: integer): string;
    class function GetTripModel(const TripModel: TTripModel): string;
    class procedure CmbTripDevices(const Devices: TStrings);
    class function GetModelFromGarminDevice(const GarminDevice: TGarminDevice): TGarminModel;
    class function GuessGarminOrEdge(const GarminDevice: string): TGarminModel;
    class function GetKnownPath(const GarminDevice: TGarminDevice; const PathId: integer): string; overload;
    class function GetKnownPath(const CurrentDevice: TObject; const DevIndex, PathId: integer): string; overload;
    class function Display2Garmin(const CmbIndex: integer): TGarminModel;
    class function Display2Trip(const CmbIndex: integer): TTripModel;
    class function Garmin2Display(const Garmin: TGarminModel): integer;
    class function SafeModel2Write(const TripModel: TTripModel): boolean;
    class function GetPartitionPrio(const PartitionDesc: string): TPartitionPrio;
    class function IsKnownDevice(const Device: TObject): boolean;
    class function GarminDeviceIndex(const DeviceList: TList; const APartPrio: TPartitionPrio): integer;
    class function KnownDeviceIndex(const DeviceList: TList; const APartPrio: TPartitionPrio): integer; overload;
    class function KnownDeviceIndex(const DeviceList: TList): integer; overload;
    class function PreferedPartition(const SelectedDevice, InsertedDevice: string;
                                     const DeviceList: Tlist): boolean;
  end;

implementation

uses
  System.StrUtils, System.Masks, System.Types,
  UnitVerySimpleXml, UnitStringUtils, UnitMTPDefs,
  UnitProcessOptions, UnitRegistry, UnitRegistryKeys;

type
  TModel_Rec = record
    DeviceName:  string;
    TripModel:   TTripModel;
    Safe:        boolean;
    Displayable: boolean;
  end;
  TParts_Rec = record
    PartNumber:  string;
    DeviceName:  string;
  end;

const
  Model_Tab: array[TGarminModel] of TModel_Rec =
  (
    (DeviceName: XT_Name;       TripModel: TTripModel.XT;       Safe: true;   Displayable: true),
    (DeviceName: XT2_Name;      TripModel: TTripModel.XT2;      Safe: true;   Displayable: true),
    (DeviceName: XT3_Name;      TripModel: TTripModel.XT3;      Safe: true;   Displayable: true),
    (DeviceName: Tread2_Name;   TripModel: TTripModel.Tread2;   Safe: true;   Displayable: true),
    (DeviceName: Edge_Name;     TripModel: TTripModel.Unknown;  Safe: true;   Displayable: true),
    (DeviceName: Garmin_Name;   TripModel: TTripModel.Unknown;  Safe: true;   Displayable: true),
    (DeviceName: Zumo595_Name;  TripModel: TTripModel.Zumo595;  Safe: false;  Displayable: true),
    (DeviceName: Zumo590_Name;  TripModel: TTripModel.Zumo590;  Safe: false;  Displayable: true),
    (DeviceName: Zumo3x0_Name;  TripModel: TTripModel.Zumo3x0;  Safe: false;  Displayable: true),
    (DeviceName: Drive51_Name;  TripModel: TTripModel.Drive51;  Safe: false;  Displayable: true),
    (DeviceName: Drive66_Name;  TripModel: TTripModel.Drive66;  Safe: false;  Displayable: true),
    (DeviceName: Nuvi2595_Name; TripModel: TTripModel.Nuvi2595; Safe: false;  Displayable: true),
    (DeviceName: Unknown_Name;  TripModel: TTripModel.Unknown;  Safe: true;   Displayable: true)
  );

// Mapping from PartNumber to DeviceName
// Used as a fallback when the Description in GarminDevice.XML is not as expected. E.G. Zumo 590 upgraded to Zumo 595

  PartsList: array[0..9] of TParts_Rec =
  (
    (PartNumber: Nuvi2595_PartNumber; DeviceName: Nuvi2595_Name),
    (PartNumber: Drive51_PartNumber;  DeviceName: Drive51_Name),
    (PartNumber: Drive66_PartNumber;  DeviceName: Drive66_Name),
    (PartNumber: Zumo3x0_PartNumber;  DeviceName: Zumo3x0_Name),
    (PartNumber: Zumo590_PartNumber;  DeviceName: Zumo590_Name),
    (PartNumber: Zumo595_PartNumber;  DeviceName: Zumo595_Name),
    (PartNumber: XT_PartNumber;       DeviceName: XT_Name),
    (PartNumber: XT2_PartNumber;      DeviceName: XT2_Name),
    (PartNumber: XT3_PartNumber;      DeviceName: XT3_Name),
    (PartNumber: Tread2_PartNumber;   DeviceName: Tread2_Name)
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
  ModelIndex: integer;
  UnsafeModels: boolean;
begin
  result := TStringList.Create;
  UnsafeModels := TProcessOptions.UnsafeModels;
  ModelIndex := -1;
  for AGarminModel := Low(TGarminModel) to High(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].Displayable) and
       ( (Model_Tab[AGarminModel].Safe) or (UnsafeModels) ) then
    begin
      Inc(ModelIndex);
      if (Default) then
        result.AddObject(Device2Display(Model_Tab[AGarminModel].DeviceName), TObject(AGarminModel))
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

class function TModelConv.GetModelFromGarminDevice(const GarminDevice: TGarminDevice): TGarminModel;
var
  ZumoId: integer;
  AGarminModel: TGarminModel;
  DevIndex: integer;
begin
  result := TGarminModel.Unknown;

  // Device name overridden?
  for DevIndex := 0 to KnownDevices.Count -1 do
    if (SameText(GarminDevice.ModelDescription, KnownDevices[DevIndex])) then
      exit(TGarminModel(KnownDevices.Objects[DevIndex]));

  // Check for known partnumbers
  for ZumoId := Low(PartsList) to High(PartsList) do
  begin
    if (GarminDevice.PartNumber = PartsList[ZumoId].PartNumber) then
    begin
      GarminDevice.ModelDescription := PartsList[ZumoId].DeviceName;
      for DevIndex := 0 to KnownDevices.Count -1 do
        if (SameText(GarminDevice.ModelDescription, KnownDevices[DevIndex])) then
          exit(TGarminModel(KnownDevices.Objects[DevIndex]));
    end;
  end;

  // Look for default Device names
  // High -> Low, XT Contains XT2
  for AGarminModel := High(TGarminModel) downto Low(TGarminModel) do
  begin
    if (Model_Tab[AGarminModel].Displayable) and
       (ContainsText(GarminDevice.ModelDescription, Model_Tab[AGarminModel].DeviceName)) then
      exit(AGarminModel);
  end;

  // Return Unknown
end;

class function TModelConv.GuessGarminOrEdge(const GarminDevice: string): TGarminModel;
begin
  result := TGarminModel.GarminGeneric;
  if (ContainsText(GarminDevice, Edge_Name)) then
    exit(TGarminModel.GarminEdge);
end;

class function TModelConv.GetKnownPath(const GarminDevice: TGarminDevice; const PathId: integer): string;
begin
  result := '';

  case GarminDevice.GarminModel of
    TGarminModel.XT,
    TGarminModel.XT2,
    TGarminModel.XT3,
    TGarminModel.Tread2,
    TGarminModel.Drive66:
      case PathId of
        0: result := GarminDevice.TripsPath;
        1: result := GarminDevice.GPXPath;
        2: result := GarminDevice.GpiPath;
      end;
    TGarminModel.Zumo590,
    TGarminModel.Zumo595,
    TGarminModel.Drive51:
      case PathId of
        0: result := GarminDevice.TripsPath;
      end;
    TGarminModel.Zumo3x0,
    TGarminModel.Nuvi2595:
      case PathId of
        0: result := GarminDevice.TripsPath;
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

class function TModelConv.GetKnownPath(const CurrentDevice: TObject; const DevIndex, PathId: integer): string;
var
  GarminDevice: TGarminDevice;
begin
  result := '';

  if (Assigned(CurrentDevice)) and
     (CurrentDevice is TMTP_Device) then
    // If we have a device, get the paths from the GarminDevice.xml
    GarminDevice := TMTP_Device(CurrentDevice).GarminDevice
  else
  begin
    // Provide some defaults
    GarminDevice := DefaultGarminDevice;
    GarminDevice.Init(Model_Tab[Display2Garmin(DevIndex)].DeviceName);
  end;

  result := GetKnownPath(GarminDevice, PathId);
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

class function TModelConv.GetPartitionPrio(const PartitionDesc: string): TPartitionPrio;
begin
  if (ContainsText(PartitionDesc, System1Partition)) then
  begin
    if (TProcessOptions.UnsafeModels) then
      result := TPartitionPrio.ppHigh
    else
      result := TPartitionPrio.ppLow;
  end
  else if (ContainsText(PartitionDesc, CardPartition)) then
    result := TPartitionPrio.ppLow
  else
    result := TPartitionPrio.ppNorm;
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

// When a device is inserted, is it known?
class function TModelConv.IsKnownDevice(const Device: TObject): boolean;
var
  KnownIndex: integer;
begin
  // Dont want Cards, usually they are part of the real device.
  if (GetPartitionPrio(TBase_Device(Device).Description) = TPartitionPrio.ppLow) then
    exit(false);

  // Look in Known devices
  if (KnownDevices.IndexOf(TMTP_Device(Device).FriendlyName) > -1)  then
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
  
  for DevIndex := 0 to DeviceList.Count -1 do
  begin
    if (GetPartitionPrio(TBase_Device(DeviceList[DevIndex]).Description) <> APartPrio) then
      continue;

    // Look in Known devices
    if (KnownDevices.IndexOf(TMTP_Device(DeviceList[DevIndex]).FriendlyName) > -1)  then
      exit(DevIndex);

    for KnownIndex := KnownDevices.Count -1 downto 0 do
    begin
      // Allow wildcards for mass storage devices. EG ?:\Garmin
      if (MatchesMask(TBase_Device(DeviceList[DevIndex]).DisplayedDevice, KnownDevices[KnownIndex])) then
        exit(DevIndex);
    end;
  end;

end;

// Get first Garmin device in connected list, for this prio. used as fallback
class function TModelConv.GarminDeviceIndex(const DeviceList: Tlist; const APartPrio: TPartitionPrio): integer;
var
  DevIndex: integer;
begin
  result := -1;

  for DevIndex := 0 to DeviceList.Count -1 do
  begin
    if (GetPartitionPrio(TBase_Device(DeviceList[DevIndex]).Description) <> APartPrio) then
      continue;
    if (SameText(TBase_Device(DeviceList[DevIndex]).Manufacturer, Garmin_Name)) then
      exit(DevIndex);
  end;
end;

// Device selection order.
// Note: Cards are not selected
class function TModelConv.KnownDeviceIndex(const DeviceList: Tlist): integer;
begin
  result := KnownDeviceIndex(DeviceList, TPartitionPrio.ppHigh);
  if (result < 0) then
    result := GarminDeviceIndex(DeviceList, TPartitionPrio.ppHigh);
  if (result < 0) then
    result := KnownDeviceIndex(DeviceList, TPartitionPrio.ppNorm);
  if (result < 0) then
    result := GarminDeviceIndex(DeviceList, TPartitionPrio.ppNorm);
end;

// The 590/595 in MassStorage mode and RWFS enabled has 2 partitions:
// System. No trips
// System. That has the trips.
// If the System is connected first, allow connecting the System1 partition
class function TModelConv.PreferedPartition(const SelectedDevice, InsertedDevice: string;
                                            const DeviceList: Tlist): boolean;
var
  Index: integer;
  Selected, Inserted: TBase_Device;
  SelectedPrio, InsertedPrio: TPartitionPrio;
begin
  Index := TBase_Device.DeviceIdInList(SelectedDevice, DeviceList);
  if (Index < 0) then
    exit(false);
  Selected := TBase_Device(DeviceList[Index]);
  SelectedPrio := GetPartitionPrio(Selected.Description);

  Index := TBase_Device.DeviceIdInList(InsertedDevice, DeviceList);
  if (Index < 0) then
    exit(false);
  Inserted := TBase_Device(DeviceList[Index]);
  InsertedPrio := GetPartitionPrio(Inserted.Description);

  result := (Selected.Serial = Inserted.Serial) and
            (SelectedPrio < InsertedPrio);
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
