unit UnitMtpDevice;
// Specialized classes to hold info on MTP Devices

interface

uses
  System.Classes,
  Vcl.ComCtrls,
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
    TripsPath: string;
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
  private
    function GetPathId(APath: string): string;
    function GetFriendlyPath(APath: string): string;
  public
    GarminDevice: TGarminDevice;
    constructor Create; virtual;
    procedure Init; override;
    destructor Destroy; override;
    function CopyFileToTmp(const AListItem: TListItem): string;
    procedure CopyFileFromTmp(const LocalFile, FolderId: string; const AListItem: TListItem);
    function CopyDeviceFile(const APath, AFile, DeviceTmp: string): boolean;
    function ReadGarminDevice(const AModelDescription: string;
                              const ADeviceList: Tlist;
                              const AManufacturer: string = ''): boolean;
    function IsGarminDeviceName: boolean;
    procedure GetInfoFromDevice(const DeviceList: Tlist); override;
    procedure ReadDeviceDB(const ExploreList: TStringList);
    function GetDBPath: string;
    function RecreateTrips(const SystemTripsPath: string;
                           const LstItems: TListItems): boolean;
    property PathId[APath: string]: string read GetPathId;
    property FriendlyPath[APath: string]: string read GetFriendlyPath;
  end;

var
  DefaultGarminDevice: TGarminDevice;

implementation

uses
  System.SysUtils, System.StrUtils, System.Masks, System.IOUtils,
  UnitRegistry, UnitRegistryKeys,
  UnitTripDefs, UnitModelConv, UnitStringUtils, UnitVerySimpleXml, UnitSqlite, mtp_helper;

const
  MSMVendorGarmin = 'usbstor#disk&ven_garmin&';
  MtpVendorGarmin = 'usb#vid_091e&';

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
  GpxPath           := NonMTPRoot + GarminPath + '\GPX';
  GpiPath           := NonMTPRoot + GarminPath + '\POI';
  CoursePath        := NonMTPRoot + GarminPath + '\Courses';
  NewFilesPath      := NonMTPRoot + GarminPath + '\NewFiles';
  ActivitiesPath    := NonMTPRoot + GarminPath + '\Activities';
end;

function TGarminDevice.ReadGarminDevice(const ACurrentDevice: TObject;
                                        const AModelDescription: string;
                                        const ADeviceList: Tlist): boolean;
var
  CurDevId, DevId: integer;
  NFile: string;
  XmlDoc: TXmlVSDocument;
  DeviceNode, ModelNode, MassStorageNode: TXmlVSNode;
  CurrentDevice, TmpDevice: TMTP_Device;

  function GetPath(CheckNode: TXmlVSNode; AName, Direction, AExt: string): string;
  var
    NewPath: string;
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
          if (CurrentDevice.PathId[result] <> '') then
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

  // Path for .System\Trips.
  // Only 2 locations are known to work: ?:\.System\Trips and Internal Storage\.System\Trips
  if (CurrentDevice.PathId[NonMTPRoot + SystemTripsPath] <> '') then
    TripsPath := NonMTPRoot + SystemTripsPath
  else if (CurrentDevice.PathId[InternalStorage + SystemTripsPath] <> '') then
    TripsPath := InternalStorage + SystemTripsPath;

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
        TGarminModel.GarminEdge,
        TGarminModel.GarminGeneric:; // Do Nothing

        TGarminModel.Unknown:
          GarminModel := TModelConv.GuessGarminOrEdge(ModelDescription);
        else
        begin
          if (CurrentDevice.PathId[TModelConv.GetKnownPath(Self, 0)] = '') then
            GarminModel := TGarminModel.GarminGeneric; // No .System\Trips. Use it as a Generic Garmin
        end;
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

function TMTP_Device.GetPathId(APath: string): string;
var
  FriendlyName: string;
begin
  result := GetIdForPath(PortableDev, APath, FriendlyName);
end;

function TMTP_Device.GetFriendlyPath(APath: string): string;
begin
  GetIdForPath(PortableDev, APath, result);
end;

function TMTP_Device.CopyFileToTmp(const AListItem: TListItem): string;
var
  ABASE_Data_File: TBase_Data;
  NFile: string;
begin
  result := '';

  // Get Id of File
  ABASE_Data_File := TBase_Data(TBase_Data(AListItem.Data));
  if (ABASE_Data_File.IsFolder) then
    exit;

  // Get Name of file
  NFile := AListItem.Caption;

  if not GetFileFromDevice(PortableDev, ABASE_Data_File.ObjectId, CreatedTempPath, NFile) then
    raise Exception.Create(Format('Copy %s from %s failed', [NFile, Device]));

  result := IncludeTrailingPathDelimiter(CreatedTempPath) + NFile;
end;

procedure TMTP_Device.CopyFileFromTmp(const LocalFile, FolderId: string; const AListItem: TListItem);
begin
  if not Assigned(AListItem) then
    raise exception.Create('No item selected.');

  if not TransferExistingFileToDevice(PortableDev, LocalFile, FolderId, AListItem) then
    raise Exception.Create(Format('TransferExistingFileToDevice %s to %s failed', [LocalFile, Device]));
end;

function TMTP_Device.CopyDeviceFile(const APath, AFile, DeviceTmp: string): boolean;
var
  CurrentObjectId, FolderId: WideString;
begin
  result := false;
  if not CheckDevice then
    exit;

  FolderId := PathId[APath];
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

function TMTP_Device.IsGarminDeviceName: boolean;
begin
  result := ContainsText(Device, MSMVendorGarmin) or  // Mass Storage Mode Garmin
            ContainsText(Device, MtpVendorGarmin);    // MTP Mode Garmin
end;

procedure TMTP_Device.GetInfoFromDevice(const DeviceList: Tlist);
begin
  inherited GetInfoFromDevice(DeviceList);

  // Hack for 'Generic MTP Device'
  if (Manufacturer <> Garmin_Name) and
     (IsGarminDeviceName) then
    Manufacturer := Garmin_Name;

  // Get Garmin Device info
  // The complete DeviceList is needed to identify SD Cards
  if (Manufacturer = Garmin_Name) then
    ReadGarminDevice(GarminDevice.ModelDescription, DeviceList, Manufacturer);

  if (MSM = MSM_ID) and
     (MatchesMask(FriendlyName, '?:\') = false) then
    // Add the root path to friendlyname. Example Sd Cards of Zumo
    FriendlyName := Format('%s %s', [IncludeTrailingPathDelimiter(FriendlyPath['?:\.']), FriendlyName]);
end;

function TMTP_Device.GetDbPath: string;
var
  ModelIndex: integer;
  SubKey, DbPath: string;
  LDelim: integer;
begin
  // Location of SQLite. Normally Internal Storage\.System\SQlite but taken from settings
  ModelIndex := GetRegistry(Reg_CurrentModel, 0);
  SubKey := TModelConv.GetDefaultDevice(ModelIndex);
  DbPath := ExcludeTrailingPathDelimiter(GetRegistry(Reg_PrefDevTripsFolder_Key,
                                         TModelConv.GetKnownPath(self, 0),
                                         SubKey));
  LDelim := LastDelimiter('\', DbPath) -1;
  DbPath := Copy(DbPath, 1, LDelim) + '\SQlite';
  if (GetIdForPath(PortableDev, DbPath, result) = '') then
    result := '';
end;

procedure TMTP_Device.ReadDeviceDB(const ExploreList: TStringList);
var
  NewVehicle_Profile, OldVehicle_Profile: TVehicleProfile;
  ModelIndex, DefAdvLevel: integer;
  DBPath: string;
begin
  // SQLite path
  DBPath := GetDbPath;
  if (DBPath = '') then
    exit;

  // Needed for checking if the connected Device needs reading SQlite
  ModelIndex := GetRegistry(Reg_CurrentModel, 0);

  // Copy settings.db, Update Avoidances changed
  if (TModelConv.ReadDeviceDB(TModelConv.Display2Garmin(ModelIndex))) and
     (CopyDeviceFile(DBPath, SettingsDb, GetDeviceTmp)) then
    SetRegistry(Reg_AvoidancesChangedTimeAtSave, GetAvoidancesChanged(GetDeviceTmp + SettingsDb));

  // Copy vehicle_profile.db
  if (TModelConv.ReadVehicleDB(TModelConv.Display2Garmin(ModelIndex))) and
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
     (TModelConv.ReadExploreDB(TModelConv.Display2Garmin(ModelIndex))) and
     (CopyDeviceFile(DBPath, ExploreDb, GetDeviceTmp)) then
    GetExploreList(IncludeTrailingPathDelimiter(GetDeviceTmp) + ExploreDb, ExploreList);
end;

function TMTP_Device.RecreateTrips(const SystemTripsPath: string;
                                   const LstItems: TListItems): boolean;
var
  FriendlyPath, LastRefreshFile, TempFile,
  SystemPath, SystemPathId,
  ActualTripsPath, SystemTripsPathId: string;
  Rc: integer;
  Fs: TSearchRec;
  AListItem: TListItem;
  File_Info: TFile_Info;
  LDelim: integer;
begin
  result := false;

  // Checks
  SystemTripsPathId := GetIdForPath(PortableDev, SystemTripsPath, FriendlyPath);
  LDelim := LastDelimiter('\', FriendlyPath) -1;
  SystemPath := Copy(FriendlyPath, 1, LDelim);          // .System
  SystemPathId := PathId[SystemPath];                   // The ID. For MSM just .System
  ActualTripsPath := ExtractFileName(FriendlyPath);     // Trips
  if not SameText(ActualTripsPath, DefTripsPath) then   // And the sub folder should be Trips
    exit;

  // DateTime of system.db
  if (GetIdForFile(PortableDev, PathId[GetDbPath], SystemDb, File_Info) = '') then
    exit;

  // Is there a .tmp with this timestamp in trips?
  LastRefreshFile := Format('%10d.tmp', [TUnixDateConv.DateTimeAsCardinal(File_Info.ObjDate)]);
  if (GetIdForFile(PortableDev, SystemTripsPathId, LastRefreshFile) <> '') then
    exit;

  // Need to recreate trips. Get directory list
  ReadFilesFromDevice(PortableDev, LstItems, SystemTripsPathId);

  // Clean temp
  DeleteTempFiles(CreatedTempPath, '*.*');

  // Create lastrefresh file
  TFile.WriteAllText(CreatedTempPath + LastRefreshFile, '');

  // Copy Trip Files to Temp directory
  for AListItem in LstItems do
  begin
    if (ContainsText(AListItem.SubItems[2], TripExtension) = false) then
      continue;

    if (CopyFileToTmp(AListItem) = '') then
      raise Exception.Create(Format('Could not copy file: %s to %s',
                                    [AListItem.Caption, CreatedTempPath]));
  end;

  // Delete .System\Trips
  DelFromDevice(PortableDev, SystemTripsPathId, true);

  // Recreate .System\Trips, and get New Id.
  CreatePath(PortableDev, SystemPathId, DefTripsPath);
  SystemTripsPathId := PathId[SystemTripsPath];

  // Copy Tmp file to device
  if (TransferNewFileToDevice(PortableDev, CreatedTempPath + LastRefreshFile, SystemTripsPathId) = '') then
    raise Exception.Create(Format('Could not overwrite file: %s on %s',
                                  [LastRefreshFile, DisplayedDevice]));

  // Copy trip files to device
  Rc := FindFirst(CreatedTempPath + TripMask, faAnyFile - faDirectory, Fs);
  while (Rc = 0) do
  begin
    // Transfer
    TempFile := IncludeTrailingPathDelimiter(CreatedTempPath) + Fs.Name;

    // Did the transfer work?
    if (TransferNewFileToDevice(PortableDev, TempFile, SystemTripsPathId) = '') then
      raise Exception.Create(Format('Could not overwrite file: %s on %s',
                                    [ExtractFileName(TempFile), DisplayedDevice]));
    Rc := FindNext(Fs);
  end;
  FindClose(Fs);

  result := true;
end;

initialization
  System.Classes.RegisterClasses([TMTP_Data, TMTP_Device]);
  DefaultGarminDevice := TGarminDevice.Create;
  DefaultGarminDevice.init;

finalization
  DefaultGarminDevice.Free;

end.

