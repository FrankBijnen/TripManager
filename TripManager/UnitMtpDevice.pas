unit UnitMtpDevice;
// Specialized classes to hold info on MTP Devices

interface

uses
  System.Classes,
  UnitGpxDefs, UnitMTPDefs;

type
  TMTP_Data = class(TBase_Data)
  public
    IsNotSavedTrip: boolean;
    IsCalculated: boolean;
    ExploreUUID: string;
  end;

  TGarminDevice = class
  public
    GarminModel: TGarminModel;
    PartNumber: string;
    SoftwareVersion: string;
    ModelDescription: string;
    SerialNumber: string;
    GpxPath: string;
    GpiPath: string;
    CoursePath: string;
    NewFilesPath: string;
    ActivitiesPath: string;
    procedure Init(const AModelDescription: string = '');
    function ReadGarminDevice(const ACurrentDevice: TObject;
                              const AModelDescription: string;
                              const ADeviceList: Tlist): boolean;

  end;

  TMTP_Device = class(TBase_Device)
  public
    GarminDevice: TGarminDevice;
    constructor Create; virtual;
    procedure Init; override;
    destructor Destroy; override;
    function CopyDeviceFile(const APath, AFile, DeviceTmp: string): boolean;
    function ReadGarminDevice(const AModelDescription: string;
                              const ADeviceList: Tlist;
                              const AManufacturer: string = ''): boolean;
    procedure GetInfoFromDevice(DeviceList: Tlist); override;
    procedure ReadDeviceDB(const DBPath: string; const ExploreList: TStringList);
  end;

var
  DefaultGarminDevice: TGarminDevice;

implementation

uses
  System.SysUtils, System.Masks,
  UnitRegistry, UnitRegistryKeys,
  UnitModelConv, UnitStringUtils, UnitVerySimpleXml, UnitSqlite, mtp_helper;

// Default paths. Will be overruled by reading GarminDevice.Xml
procedure TGarminDevice.Init(const AModelDescription: string = '');
begin
  PartNumber        := 'N/A';
  SoftwareVersion   := 'N/A';
  if (AModelDescription <> '') then
  begin
    ModelDescription := AModelDescription;
    GarminModel := TModelConv.GetModelFromGarminDevice(Self);
  end
  else
  begin
    ModelDescription  := Unknown_Name;
    GarminModel       := TGarminModel.Unknown;
  end;
  SerialNumber      := 'N/A';
  CoursePath        := NonMTPRoot + GarminPath + '\Courses';
  NewFilesPath      := NonMTPRoot + GarminPath + '\NewFiles';
  ActivitiesPath    := NonMTPRoot + GarminPath + '\Activities';
  GpxPath           := NonMTPRoot + GarminPath + '\GPX';
  GpiPath           := NonMTPRoot + GarminPath + '\POI';
end;

function TGarminDevice.ReadGarminDevice(const ACurrentDevice: TObject;
                                        const AModelDescription: string;
                                        const ADeviceList: Tlist): boolean;
var
  CurDevId, DevId: integer;
  NFile, FriendlyPath: string;
  XmlDoc: TXmlVSDocument;
  DeviceNode, ModelNode, MassStorageNode: TXmlVSNode;
  CurrentDevice, TmpDevice: TMTP_Device;

  function GetPath(CheckNode: TXmlVSNode; AName, Direction, AExt: string): string;
  var
    NewPath, FriendlyPath: string;
    DataTypeNode, FileNode, LocationNode: TXmlVSNode;
  begin
    result := '';
    for DataTypeNode in CheckNode.ChildNodes do
    begin
      if not (SameText(FindSubNodeValue(DataTypeNode, 'Name'), AName)) then
        continue;
      for FileNode in DataTypeNode.ChildNodes do
      begin
        if (FindSubNodeValue(FileNode, 'TransferDirection') <> Direction) then
          continue;
        LocationNode := FileNode.Find('Location');
        if (Assigned(LocationNode)) and
           (SameText(FindSubNodeValue(LocationNode, 'FileExtension'), AExt)) then
        begin
          NewPath := ReplaceAll(FindSubNodeValue(LocationNode, 'Path'), ['/'], ['\']);
          result := Format('%s%s', [NonMTPRoot, NewPath]);
          if (GetIdForPath(CurrentDevice.PortableDev, result, FriendlyPath) <> '') then
            exit
          else
            exit(Format('%s%s', [InternalStorage, NewPath]));
        end;
      end;
    end;
  end;

begin
  result := false;

  if not (ACurrentDevice is TMTP_Device) then
    exit;
  // Set defaults based on device description
  Init(AModelDescription);

  // Need a device to check better
  CurrentDevice := TMTP_Device(ACurrentDevice);
  if not (Assigned(CurrentDevice) and (CurrentDevice.CheckDevice)) then
    exit;

  // Location of GarminDevice.Xml
  NFile := GarminDeviceXML;

  // Copy and read GarminDevice.xml
  CurDevId := CurrentDevice.Id;
  DeleteFile(GetDeviceTmp + NFile);

  if not (CurrentDevice.CopyDeviceFile(NonMTPRoot + GarminPath, NFile, GetDeviceTmp)) and
     not (CurrentDevice.CopyDeviceFile(InternalStorage + GarminPath, NFile, GetDeviceTmp)) then
  begin
    // There is no garmindevice in ?:\Garmin, or Internal Storage\Garmin
    // Check other devices with the same serialId.
    // It could be the SD Card, or a hidden MTP partition as found with the 595
    if (Assigned(ADeviceList)) then
    begin
      for DevId := 0 to ADeviceList.Count -1 do
      begin
        if DevId = CurDevId then
          continue;
        if (TMTP_Device(ADeviceList[DevId]).Serial = TMTP_Device(ADeviceList[CurDevId]).Serial) then
        begin
          TmpDevice := ADeviceList[DevId];
          try
            if (ConnectToDevice(TmpDevice.Device, TmpDevice.PortableDev, true)) then
            begin
              if (TmpDevice.CopyDeviceFile(NonMTPRoot + GarminPath, NFile, GetDeviceTmp)) or
                 (TmpDevice.CopyDeviceFile(InternalStorage + GarminPath, NFile, GetDeviceTmp)) then
               break;
            end;
          finally
            TmpDevice.PortableDev.Close;
          end;
        end;
      end;
    end;
  end;

  // Do we have the XML?
  if (FileExists(GetDeviceTmp + NFile)) then
  begin
    XmlDoc := TXmlVSDocument.Create;
    try
      XmlDoc.LoadFromFile(GetDeviceTmp + NFile);
      DeviceNode := XmlDoc.ChildNodes.Find('Device');
      if (DeviceNode = nil) then
        exit;
      SerialNumber := FindSubNodeValue(DeviceNode, 'Id');
      ModelNode := DeviceNode.Find('Model');
      if (ModelNode = nil) then
        exit;
      MassStorageNode := DeviceNode.Find('MassStorageMode');

      // Update model from GarminDevice.xml
      PartNumber := FindSubNodeValue(ModelNode, 'PartNumber');
      SoftwareVersion := FindSubNodeValue(ModelNode, 'SoftwareVersion');
      ModelDescription := FindSubNodeValue(ModelNode, 'Description');
      GarminModel := TModelConv.GetModelFromGarminDevice(Self);

      case GarminModel of
        TGarminModel.Zumo595,
        TGarminModel.Zumo590,
        TGarminModel.Drive51,
        TGarminModel.Zumo3x0,
        TGarminModel.Nuvi2595:
          if (GetIdForPath(CurrentDevice.PortableDev, NonMTPRoot + SystemTripsPath, FriendlyPath) = '') then
            GarminModel := TGarminModel.GarminGeneric; // No .System\Trips. Use it as a Generic Garmin
        TGarminModel.Unknown:
          GarminModel := TModelConv.GuessGarminOrEdge(ModelDescription);
      end;

      // Get default paths
      if (Assigned(MassStorageNode)) then
      begin
        GpxPath := GetPath(MassStorageNode, 'GPSData', 'InputToUnit', 'gpx');
        GpiPath := GetPath(MassStorageNode, 'CustomPOI', 'InputToUnit', 'gpi');
        CoursePath := GetPath(MassStorageNode, 'FIT_TYPE_6', 'OutputFromUnit', 'fit');
        NewFilesPath := GetPath(MassStorageNode, 'FIT_TYPE_6', 'InputToUnit', 'fit');
        ActivitiesPath := GetPath(MassStorageNode, 'FIT_TYPE_4', 'OutputFromUnit', 'fit');
      end;
    finally
      XmlDoc.Free;
    end;
    result := true;
  end;
end;

constructor TMTP_Device.Create;
begin
  inherited Create;
end;

procedure TMTP_Device.Init;
begin
  GarminDevice := TGarminDevice.Create;
  GarminDevice.Init;
end;

destructor TMTP_Device.Destroy;
begin
  inherited Destroy;
  GarminDevice.Free;
end;

function TMTP_Device.CopyDeviceFile(const APath, AFile, DeviceTmp: string): boolean;
var
  CurrentObjectId, FolderId: widestring;
  FriendlyPath: string;
begin
  result := false;
  if not CheckDevice then
    exit;

  FolderId := GetIdForPath(PortableDev, APath, FriendlyPath);
  if (FolderId = '') then
    exit;

  // Get Id of File
  CurrentObjectId := GetIdForFile(PortableDev, FolderId, AFile);
  if (CurrentObjectId = '') then
    exit;

  ForceDirectories(DeviceTmp);
  if not GetFileFromDevice(PortableDev, CurrentObjectId, DeviceTmp, AFile) then
    exit;

  result := true;
end;

function TMTP_Device.ReadGarminDevice(const AModelDescription: string;
                                      const ADeviceList: Tlist;
                                      const AManufacturer: string = ''): boolean;
begin
  result := true;
  if (AManufacturer = '') or
     (AManufacturer = Manufacturer) then
    result := GarminDevice.ReadGarminDevice(Self, AModelDescription, ADeviceList)
  else
    GarminDevice.Init(AModelDescription);
end;

procedure TMTP_Device.GetInfoFromDevice(DeviceList: TList);
var
  FriendlyPath: string;
begin
  // Requires opening and closing device.
  if not (ConnectToDevice(Device, PortableDev, true) ) then
    exit;
  try
    // Get Garmin Device info
    // The complete DeviceList is needed to identify SD Cards
    if (Manufacturer = Garmin_Name) then
      ReadGarminDevice(GarminDevice.ModelDescription, DeviceList, Manufacturer);

    if (MSM = 'MSM') then
    begin
      // For wpdbusenum add to the root path to friendlyname
      // Example Sd Cards of Zumo
      if not (MatchesMask(FriendlyName, '?:\')) then
      begin
        GetIdForPath(PortableDev, '?:\.', FriendlyPath);
        FriendlyName := Format('%s %s', [IncludeTrailingPathDelimiter(FriendlyPath), FriendlyName]);
      end;
    end;

  finally
    PortableDev := nil;
  end;
end;

procedure TMTP_Device.ReadDeviceDB(const DBpath: string; const ExploreList: TStringList);
var
  NewVehicle_Profile, OldVehicle_Profile: TVehicleProfile;
  ModelIndex, DefAdvLevel: integer;
begin
  // SQLite path
  if (DBPath = '') then
    exit;

  // Needed for checking if the connected Device needs reading SQlite
  ModelIndex := GetRegistry(Reg_CurrentModel, 0);

  // Copy settings.db, Update Avoidances changed
  if (TModelConv.Display2Garmin(ModelIndex) in [TGarminModel.XT2, TGarminModel.Tread2]) and
     (CopyDeviceFile(DBPath, SettingsDb, GetDeviceTmp)) then
    SetRegistry(Reg_AvoidancesChangedTimeAtSave, GetAvoidancesChanged(GetDeviceTmp + SettingsDb));

  // Copy vehicle_profile.db
  if (TModelConv.Display2Garmin(ModelIndex) in [TGarminModel.XT2, TGarminModel.Tread2]) and
     (CopyDeviceFile(DBPath, ProfileDb, GetDeviceTmp)) then
  begin
    OldVehicle_Profile.GUID             := UTF8String(GetRegistry(Reg_VehicleProfileGuid, ''));
    OldVehicle_Profile.Vehicle_Id       := GetRegistry(Reg_VehicleId, 0);
    OldVehicle_Profile.TruckType        := GetRegistry(Reg_VehicleProfileTruckType, 0);
    OldVehicle_Profile.Name             := UTF8String(GetRegistry(Reg_VehicleProfileName, ''));
    OldVehicle_Profile.VehicleType      := GetRegistry(Reg_VehicleType, 0);
    OldVehicle_Profile.TransportMode    := GetRegistry(Reg_VehicleTransportMode, 0);

    NewVehicle_Profile := GetVehicleProfile(GetDeviceTmp + ProfileDb, TModelConv.Display2Garmin(ModelIndex));

    if (NewVehicle_Profile.Valid) and
       (NewVehicle_Profile.Changed(OldVehicle_Profile)) then
    begin
      // Update Vehicle profile
      SetRegistry(Reg_VehicleProfileGuid,       string(NewVehicle_Profile.GUID));
      SetRegistry(Reg_VehicleId,                NewVehicle_Profile.Vehicle_Id);
      SetRegistry(Reg_VehicleProfileTruckType,  NewVehicle_Profile.TruckType);
      SetRegistry(Reg_VehicleProfileName,       string(NewVehicle_Profile.Name));
      SetRegistry(Reg_VehicleType,              NewVehicle_Profile.VehicleType);
      SetRegistry(Reg_VehicleTransportMode,     NewVehicle_Profile.TransportMode);

      // Changed Vehicle profile. Set hash to 0
      SetRegistry(Reg_VehicleProfileHash, 0);

      // Only load Default Adventurous level from profile if invalid
      DefAdvLevel := GetRegistry(Reg_DefAdvLevel, 0);
      if not (DefAdvLevel in [1..4]) then
        SetRegistry(Reg_DefAdvLevel, NewVehicle_Profile.AdventurousLevel +1);
    end;
  end;

  // Copy explore.db
  if (GetRegistry(Reg_EnableExploreFuncs, false)) and
     (TModelConv.Display2Garmin(ModelIndex) in [TGarminModel.XT, TGarminModel.XT2, TGarminModel.Tread2]) and
     (CopyDeviceFile(DBPath, ExploreDb, GetDeviceTmp)) then
    GetExploreList(IncludeTrailingPathDelimiter(GetDeviceTmp) + ExploreDb, ExploreList);
end;

initialization
  System.Classes.RegisterClasses([TMTP_Data, TMTP_Device]);
  DefaultGarminDevice := TGarminDevice.Create;
  DefaultGarminDevice.init;

finalization
  DefaultGarminDevice.Free;

end.

