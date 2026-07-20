unit UnitGarminDevice;
// Specialized classes to hold info on MTP Devices

interface

uses
  System.Classes, System.JSON,
  Vcl.ComCtrls,
  UnitGpxDefs, UnitBaseMTP;

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
    CoursesPath: string;
    NewFilesPath: string;
    ActivitiesPath: string;
    procedure Init(const AGarminModel: TGarminModel); overload;
    procedure Init(const AModelDescription: string = ''); overload;
    function ReadGarminDevice(const ACurrentDevice: TObject;
                              const AModelDescription: string;
                              const ADeviceList: Tlist;
                              const ReadOnly: boolean): boolean;
  end;

  TGarminMTP_Device = class(TBase_Device)
  private
    procedure ExploreMetaDataCallBack(const JSONMetaData: string);
  public
    GarminDevice: TGarminDevice;
    procedure Init; override;
    destructor Destroy; override;
    function CopyFileToTmp(const AListItem: TListItem): string;
    function CopyDeviceFile(const APath, AFile, DeviceTmp: string): boolean;
    function ReadGarminDevice(const AModelDescription: string;
                              const ADeviceList: Tlist;
                              const SelectManufacturer: string = '*'): boolean;
    function IsGarminDeviceName: boolean;
    procedure GetInfoFromDevice(const DeviceList: Tlist); override;
    procedure ReadDeviceDB(const ExploreList: TStringList);
    function GetDBPath: string;
    function CheckSystemTripsFolder(const SystemTripsPath: string): boolean;
    function RecreateTrips(const SystemTripsPath: string;
                           const LstItems: TListItems): boolean;
  end;

  TGarminDrv_Device = class(TGarminMTP_Device)
  protected
    function GetMediaDescription: string; override;
    function GetPathId(APath: string): string; override;
    function GetFileId(APath, AFile: string): string; override;
    function GetFriendlyPath(APath: string): string; override;
  public
    function CheckDevice: boolean; override;
    function GetManufacturer: PWideChar; override;

    function GetFileInfo(const APath, AFile: string;
                         var File_Info: TFile_Info): string; override;
    function GetListInfo(const APath, AFile: string;
                         const AListItem: TListItem): string; override;
    function GetFriendlyIdForPath(const SPath: string;
                                  var FriendlyPath: string): string; override;
    function FileExists(const APath, AFile:string): boolean; override;
    function GetFile(const SFile, SSaveTo, NFile: string): boolean; override;
    function DelFile(const SFile: string; const Recurse: boolean = false): boolean; override;
    function RenameFile(const ObjectId, NewName: string): boolean; override;
    function TransferNewFile(const SFile, SSaveTo: string;
                             const NewName: WideString = ''): string; override;
    function TransferExistingFile(const SFile, SSaveTo: string;
                                  const AListItem: TListItem): boolean; override;
    function CreatePath(const Parent, DirName: string): boolean; override;
    function Connect(const Readonly: boolean = false): boolean; override;
    procedure Close; override;
    function ReadFiles(const Lst: TListItems;
                       const SParent: string;
                       var CompletePath: WideString): string; overload; override;
  end;

var
  DefaultGarminDevice: TGarminDevice;

implementation

uses
  System.SysUtils, System.StrUtils, System.Masks, System.IOUtils, System.UITypes,
  Winapi.Windows, Winapi.ShellAPI,
  Vcl.Dialogs,
  UnitRegistry, UnitRegistryKeys,
  UnitTripDefs, UnitModelConv, UnitStringUtils, UnitVerySimpleXml, UnitSqlite, UnitVehProfile;

const
// Known Garmin device names in MSM and MTP mode.
// Used when the manufacturer is not reported as 'Garmin'
  MSMVendorGarmin = 'usbstor#disk&ven_garmin&';
  MTPVendorGarmin = 'usb#vid_091e&';
  InstallHelp     = 'https://frankbijnen.github.io/TripManager/1initialtasks.html#showsys';

// Default paths. Will be overruled by reading GarminDevice.Xml
procedure TGarminDevice.Init(const AGarminModel: TGarminModel);
begin
  GarminModel       := AGarminModel;
  PartNumber        := NotApplicable;
  SoftwareVersion   := NotApplicable;
  SerialNumber      := NotApplicable;
  GpxPath           := NonMTPRoot + DefGarminPath + '\' + DefGPXPath;
  GpiPath           := NonMTPRoot + DefGarminPath + '\' + DefPOIPath;
  CoursesPath       := NonMTPRoot + DefGarminPath + '\' + DefCoursesPath;
  NewFilesPath      := NonMTPRoot + DefGarminPath + '\' + DefNewFilesPath;
  ActivitiesPath    := NonMTPRoot + DefGarminPath + '\' + DefActivitiesPath;
end;

procedure TGarminDevice.Init(const AModelDescription: string = '');
begin
  if (AModelDescription <> '') then
  begin
    ModelDescription := AModelDescription;
    Init(TModelConv.GetModelFromGarminDevice(Self));
  end
  else
  begin
    ModelDescription := StrUnknown;
    Init(TGarminModel.Unknown);
  end;
end;

function TGarminDevice.ReadGarminDevice(const ACurrentDevice: TObject;
                                        const AModelDescription: string;
                                        const ADeviceList: Tlist;
                                        const ReadOnly: boolean): boolean;
var
  CurDevId, DevId: integer;
  SafeGarminModel: boolean;
  NFile: string;
  XmlDoc: TXmlVSDocument;
  DeviceNode, ModelNode, MassStorageNode: TXmlVSNode;
  CurrentDevice, TmpDevice: TGarminMTP_Device;

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

  if not (ACurrentDevice is TGarminMTP_Device) then
    exit;
  // Set defaults based on device description
  Init(AModelDescription);

  // Need a device to check better
  CurrentDevice := TGarminMTP_Device(ACurrentDevice);
  if not (Assigned(CurrentDevice) and (CurrentDevice.CheckDevice)) then
    exit;

  // Path for .System\Trips.
  // Only 2 locations are known to work: ?:\.System\Trips and Internal Storage\.System\Trips
  if (CurrentDevice.PathId[NonMTPRoot + SystemPath] <> '') then
    TripsPath := NonMTPRoot + SystemTripsPath
  else if (CurrentDevice.PathId[InternalStorage + SystemPath] <> '') then
    TripsPath := InternalStorage + SystemTripsPath;

  // Location of GarminDevice.Xml
  NFile := GarminDeviceXML;

  // Copy and read GarminDevice.xml
  CurDevId := CurrentDevice.Id;
  System.SysUtils.DeleteFile(GetDeviceTmp + NFile);

  if not (CurrentDevice.CopyDeviceFile(NonMTPRoot + DefGarminPath, NFile, GetDeviceTmp)) and
     not (CurrentDevice.CopyDeviceFile(InternalStorage + DefGarminPath, NFile, GetDeviceTmp)) then
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
        if (TGarminMTP_Device(ADeviceList[DevId]).Serial = TGarminMTP_Device(ADeviceList[CurDevId]).Serial) then
        begin
          TmpDevice := ADeviceList[DevId];
          try
            if (TmpDevice.Connect(true)) then
            begin
              if (TmpDevice.CopyDeviceFile(NonMTPRoot + DefGarminPath, NFile, GetDeviceTmp)) or
                 (TmpDevice.CopyDeviceFile(InternalStorage + DefGarminPath, NFile, GetDeviceTmp)) then
               break;
            end;
          finally
            TmpDevice.Close;
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
        TGarminModel.GarminForeRunner,
        TGarminModel.GarminGeneric:; // Do Nothing

        TGarminModel.Unknown:
          GarminModel := TModelConv.GuessGarminGeneric(ModelDescription);
        else
        begin
          SafeGarminModel := TModelConv.SafeGarminModel(GarminModel);

          // Need to create Internal Storage\.System\Trips?
          if (SafeGarminModel) and
             not (ReadOnly) then
            CurrentDevice.CheckSystemTripsFolder(TModelConv.GetKnownPath(Self, 0));

          if not (SafeGarminModel) or
             (CurrentDevice.PathId[TModelConv.GetKnownPath(Self, 0)] = '') then
            GarminModel := TGarminModel.GarminGeneric; // No .System\Trips, or Unsafe model. Use it as a Generic Garmin
        end;
      end;

      // Get default paths
      if (Assigned(MassStorageNode)) then
      begin
        GpxPath := GetPath(MassStorageNode, 'GPSData', 'InputToUnit', 'gpx');
        GpiPath := GetPath(MassStorageNode, 'CustomPOI', 'InputToUnit', 'gpi');
        CoursesPath := GetPath(MassStorageNode, 'FIT_TYPE_6', 'OutputFromUnit', 'fit');
        NewFilesPath := GetPath(MassStorageNode, 'FIT_TYPE_6', 'InputToUnit', 'fit');
        ActivitiesPath := GetPath(MassStorageNode, 'FIT_TYPE_4', 'OutputFromUnit', 'fit');
      end;
    finally
      XmlDoc.Free;
    end;
    result := true;
  end;
end;

// Additional objects need to be created here.
procedure TGarminMTP_Device.Init;
begin
  GarminDevice := TGarminDevice.Create;
  GarminDevice.Init;
end;

destructor TGarminMTP_Device.Destroy;
begin
  inherited Destroy;
  GarminDevice.Free;
end;

function TGarminMTP_Device.CopyFileToTmp(const AListItem: TListItem): string;
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
  if not GetFile(ABASE_Data_File.ObjectId, CreatedTempPath, NFile) then
    raise Exception.Create(Format('Copy %s from %s failed', [NFile, Device]));

  result := IncludeTrailingPathDelimiter(CreatedTempPath) + NFile;
end;

function TGarminMTP_Device.CopyDeviceFile(const APath, AFile, DeviceTmp: string): boolean;
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
  CurrentObjectId := FileId[FolderId, AFile];
  if (CurrentObjectId = '') then
    exit;

  ForceDirectories(DeviceTmp);
  if not GetFile(CurrentObjectId, DeviceTmp, AFile) then
    exit;

  result := true;
end;

function TGarminMTP_Device.ReadGarminDevice(const AModelDescription: string;
                                            const ADeviceList: Tlist;
                                            const SelectManufacturer: string = '*'): boolean;
begin
  result := true;
  if (MatchesMask(Manufacturer, SelectManufacturer)) then
    result := GarminDevice.ReadGarminDevice(Self,
                                            AModelDescription,
                                            ADeviceList,
                                            (SelectManufacturer <> '*'))
  else
    GarminDevice.Init(AModelDescription);
end;

function TGarminMTP_Device.IsGarminDeviceName: boolean;
begin
  result := ContainsText(Device, MSMVendorGarmin) or  // Mass Storage Mode Garmin
            ContainsText(Device, MTPVendorGarmin);    // MTP Mode Garmin
end;

procedure TGarminMTP_Device.GetInfoFromDevice(const DeviceList: Tlist);
begin
  inherited GetInfoFromDevice(DeviceList);

  // Hack for 'Generic MTP Device'.
  if (Manufacturer <> Garmin_Name) and
     (IsGarminDeviceName) then
    Manufacturer := Garmin_Name;

  // Get Garmin Device info. Note: The complete DeviceList is needed to identify SD Cards
  ReadGarminDevice(GarminDevice.ModelDescription, DeviceList, Garmin_Name);

  if (FMediaType = TMediaType.mtMSM) and
     (MatchesMask(FriendlyName, NonMTPRoot) = false) then
    // Add the root path to friendlyname. Example: SD Cards of Zumo
    FriendlyName := Format('%s %s', [IncludeTrailingPathDelimiter(FriendlyPath[NonMTPRoot + RelativePath]), FriendlyName]);
end;

function TGarminMTP_Device.GetDbPath: string;
var
  ModelIndex: integer;
  SubKey, DbPath: string;
  LDelim: integer;
begin
  // Location of SQLite. Normally Internal Storage\.System\SQlite but taken from settings
  ModelIndex := TModelConv.GetCurrentDevice;
  SubKey := TModelConv.GetDefaultDevice(ModelIndex);
  DbPath := ExcludeTrailingPathDelimiter(GetRegistry(Reg_PrefDevTripsFolder_Key,
                                         TModelConv.GetKnownPath(self, 0),
                                         SubKey));
  LDelim := LastDelimiter('\', DbPath) -1;
  DbPath := Copy(DbPath, 1, LDelim) + DefSQLitePath;

  if (GetFriendlyIdForPath(DbPath, result) = '') then
    result := '';
end;

// Save ProfileHashList in registry, from Explore.db
procedure TGarminMTP_Device.ExploreMetaDataCallBack(const JSONMetaData: string);
var
  SubKey: string;
  JSONGuid: string;
  JSONProfileName: string;
  JSONModified: Cardinal;
  JSONHash: Cardinal;
  JSONProfile, JSONVAlue: TJSONValue;
begin
  if (TModelConv.ReadVehicleDB(GarminDevice.GarminModel) = false) then
    exit;

  SubKey := TModelConv.GetDefaultDevice(TModelConv.GetCurrentDevice) + '\' +
              Reg_VehicleProfileHashList + '\' ;
  try
    JSONVAlue := TJSONObject.ParseJSONValue(JSONMetaData);
    try
      JSONProfile := JSONVAlue.FindValue('VehicleProfileData');
      JSONGuid := JSONProfile.FindValue('VehicleProfileGuid').GetValue<string>;
      JSONHash := JSONProfile.FindValue('VehicleProfileHash').GetValue<cardinal>;
      JSONModified := JSONProfile.FindValue('ModifiedDate').GetValue<cardinal>;
      JSONProfileName := JSONProfile.FindValue('VehicleProfileName').GetValue<string>;
    finally
      JSONVAlue.Free;
    end;
  except
    BreakPoint; // Should not occur. Debugger break
    exit;
  end;

  if (JSONHash <> 0) and
     (JSONModified > GetRegistry(Reg_VehicleProfileModifiedDate,
                                 0,
                                 SubKey + JSONGuid)) then
  begin
    SetRegistry(Reg_VehicleProfileHash,
                JSONHash,
                SubKey + JSONGuid);
    SetRegistry(Reg_VehicleProfileName,
                JSONProfileName,
                SubKey + JSONGuid);
    SetRegistry(Reg_VehicleProfileModifiedDate,
                JSONModified,
                SubKey + JSONGuid);
  end;
end;

procedure TGarminMTP_Device.ReadDeviceDB(const ExploreList: TStringList);
var
  NewVehicle_Profile, OldVehicle_Profile: TVehicleProfile;
  ModelIndex, DefAdvLevel: integer;
  SubKey: string;
  DBPath: string;
  LoadActive: boolean;
  GarminModel: TGarminModel;
begin
  // SQLite path
  DBPath := GetDbPath;
  if (DBPath = '') then
    exit;

  // Needed for checking if the connected Device needs reading SQlite
  ModelIndex := TModelConv.GetCurrentDevice;
  SubKey := TModelConv.GetDefaultDevice(ModelIndex);
  GarminModel := TModelConv.Display2Garmin(ModelIndex);

  // Copy settings.db, Update Avoidances changed
  if (TModelConv.ReadSettingsDB(GarminModel)) and
     (CopyDeviceFile(DBPath, SettingsDb, GetDeviceTmp)) then
    SetRegistry(Reg_AvoidancesChangedTimeAtSave, GetAvoidancesChanged(GetDeviceTmp + SettingsDb), SubKey);

  // Copy explore.db
  // Get ProfileHashes from explore.db
  if (GetRegistry(Reg_EnableExploreFuncs, false)) and
     (TModelConv.ReadExploreDB(GarminModel)) and
     (CopyDeviceFile(DBPath, ExploreDb, GetDeviceTmp)) then
  begin
    if (TModelConv.ReadVehicleDB(GarminModel)) then // Need ProfileHash from Explore.db
      GetExploreList(IncludeTrailingPathDelimiter(GetDeviceTmp) + ExploreDb, ExploreList, ExploreMetaDataCallBack)
    else
      GetExploreList(IncludeTrailingPathDelimiter(GetDeviceTmp) + ExploreDb, ExploreList);
  end;

  // Copy vehicle_profile.db
  if (TModelConv.ReadVehicleDB(GarminModel)) and
     (CopyDeviceFile(DBPath, ProfileDb, GetDeviceTmp)) then
  begin
    OldVehicle_Profile.FromRegistry(SubKey);
    LoadActive := GetRegistry(Reg_LoadActiveProfile, true);
    NewVehicle_Profile := GetVehicleProfile(GetDeviceTmp + ProfileDb,
                                            GarminModel,
                                            SubKey,
                                            LoadActive,
                                            GetRegistry(Reg_VehicleProfileName, '', SubKey));

    if (NewVehicle_Profile.Valid) and
       ( (LoadActive) or (NewVehicle_Profile.MustUpdate(OldVehicle_Profile))) then
    begin
      // Update Vehicle profile
      NewVehicle_Profile.ToRegistry(SubKey);

      // Only load Default Adventurous level from profile if invalid
      DefAdvLevel := GetRegistry(Reg_DefAdvLevel, 0);
      if not (DefAdvLevel in [1..4]) then
        SetRegistry(Reg_DefAdvLevel, NewVehicle_Profile.Adventurous_Route_Mode +1, SubKey);
    end;
  end;

end;

function TGarminMTP_Device.CheckSystemTripsFolder(const SystemTripsPath: string): boolean;
var
  SystemPath, SystemPathId,
  SystemTripsPathId: string;
  LDelim: integer;
begin
  result := false;

  if (TripVersion[TModelConv.Garmin2Trip(GarminDevice.GarminModel)].CanCheckSystemTrips = false) then
    exit;

  // .System\Trips exists?
  SystemTripsPathId := PathId[SystemTripsPath];
  if (SystemTripsPathId <> '') then
    exit;

  // Get Id of '.System', by stripping of '\Trips'
  SystemPathId := '';
  if (SystemTripsPath <> '') then
  begin
    LDelim := LastDelimiter('\', SystemTripsPath) -1;
    SystemPath := Copy(SystemTripsPath, 1, LDelim);     // .System
    SystemPathId := PathId[SystemPath];                 // The ID.
  end;

  if (SystemPathId = '') then                           // No .System exists
  begin
    if (MessageDlg(Format('TripManager can not access .System\Trips! %s' +
                          'Trip functions are not enabled. Using %s as Generic Garmin%s' +
                          'Open online help how to ''Show .System''?',
                          [#10, FriendlyName, #10]),
                     TMsgDlgType.mtWarning,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     0, TMsgDlgBtn.mbNo) = MrYes) then
        ShellExecute(0, 'Open', InstallHelp, '','', SW_SHOWNORMAL);
    exit;
  end;

  // Create .System\Trips
  result := CreatePath(SystemPathId, DefTripsPath);

end;

function TGarminMTP_Device.RecreateTrips(const SystemTripsPath: string;
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
  SystemTripsPathId := GetFriendlyIdForPath(SystemTripsPath, FriendlyPath);
  LDelim := LastDelimiter('\', FriendlyPath) -1;
  SystemPath := Copy(FriendlyPath, 1, LDelim);          // .System
  SystemPathId := PathId[SystemPath];                   // The ID. For MSM just .System
  ActualTripsPath := ExtractFileName(FriendlyPath);     // Trips
  if not SameText(ActualTripsPath, DefTripsPath) then   // And the sub folder should be Trips
    exit;

  // DateTime of system.db
  if (GetFileInfo(PathId[GetDbPath], SystemDb, File_Info) = '') then
    exit;

  // Is there a .tmp with this timestamp in trips?
  LastRefreshFile := Format('%10d.tmp', [TUnixDateConv.DateTimeAsCardinal(File_Info.ObjDate)]);
  if (FileId[SystemTripsPathId, LastRefreshFile] <> '') then
    exit;

  // Need to recreate trips. Get directory list
  ReadFiles(LstItems, SystemTripsPathId);

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
  if not DelFile(SystemTripsPathId, true) then
    raise Exception.Create(Format('Could not remove directory: %s',
                                  [SystemTripsPath]));

  // Recreate .System\Trips, and get New Id.
  CreatePath(SystemPathId, DefTripsPath);
  SystemTripsPathId := PathId[SystemTripsPath];

  // Copy Tmp file to device
  if (TransferNewFile(CreatedTempPath + LastRefreshFile, SystemTripsPathId) = '') then
    raise Exception.Create(Format('Could not overwrite file: %s on %s',
                                  [LastRefreshFile, DisplayedDevice]));

  // Copy trip files to device
  Rc := System.SysUtils.FindFirst(CreatedTempPath + TripMask, faAnyFile - faDirectory, Fs);
  while (Rc = 0) do
  begin
    // Transfer
    TempFile := IncludeTrailingPathDelimiter(CreatedTempPath) + Fs.Name;

    // Did the transfer work?
    if (TransferNewFile(TempFile, SystemTripsPathId) = '') then
      raise Exception.Create(Format('Could not overwrite file: %s on %s',
                                    [ExtractFileName(TempFile), DisplayedDevice]));
    Rc := System.SysUtils.FindNext(Fs);
  end;
  System.SysUtils.FindClose(Fs);

  result := true;
end;

procedure FillFileInfo(const AFs: TSearchRec; var AFile_Info: TFile_Info);
begin
  AFile_Info.ObjName := Afs.Name;
  AFile_Info.IsFolder := ((AFs.Attr and faDirectory) <> 0);
  AFile_Info.ObjDate := Afs.TimeStamp;
  AFile_Info.TimeOriginal := FormatDateTime('yyyy-MM-DD"T"hh:mm:ss', AFile_Info.ObjDate);
  AFile_Info.DateOriginal := NextField(AFile_Info.TimeOriginal, 'T');
  AFile_Info.ObjSize := Afs.Size;
end;

function TGarminDrv_Device.GetMediaDescription: string;
begin
  result := 'DRV';
end;

function TGarminDrv_Device.GetPathId(APath: string): string;
begin
  result := ReplaceAll(APath, [NonMTPRoot], [Device]);
  if not System.SysUtils.DirectoryExists(result) then
    result := '';
end;

function TGarminDrv_Device.GetFileId(APath, AFile: string): string;
begin
  result := CombinePath(APath, AFile);
  if not System.SysUtils.FileExists(result) then
    result := '';
end;

function TGarminDrv_Device.GetFriendlyPath(APath: string): string;
begin
  result := GetPathId(APath);
end;

function TGarminDrv_Device.CheckDevice: boolean;
begin
  result := true;
end;

function TGarminDrv_Device.GetManufacturer: PWideChar;
begin
  result := PWideChar(Description);
end;

function TGarminDrv_Device.GetFileInfo(const APath, AFile: string;
                                       var File_Info: TFile_Info): string;
var
  Fs: TSearchRec;
begin
  result := CombinePath(APath, AFile);
  if (System.Sysutils.FindFirst(result, faAnyFile, Fs) = 0) then
  begin
    FillFileInfo(Fs, File_Info);
    System.Sysutils.FindClose(Fs)
  end;
end;

function TGarminDrv_Device.GetListInfo(const APath, AFile: string;
                                       const AListItem: TListItem): string;
var
  AFile_Info: TFile_Info;
  MinSubItems: integer;
begin
  MinSubItems := TListView(AListItem.ListView).Columns.Count -1;
  result := GetFileInfo(APath, AFile, AFile_Info);
  TBase_Data.UpdateListItem(AListItem,
                            [AFile_Info.DateOriginal,
                             AFile_Info.TimeOriginal,
                             ExtractFileExt(AFile_Info.ObjName),
                             SenSize(AFile_Info.ObjSize)],
                            MinSubItems);
end;

function TGarminDrv_Device.GetFriendlyIdForPath(const SPath: string;
                                                var FriendlyPath: string): string;
begin
  FriendlyPath := ReplaceAll(SPath, [NonMTPRoot], [Device]);
  result := FriendlyPath;
end;

function TGarminDrv_Device.FileExists(const APath, AFile:string): boolean;
begin
  result := System.SysUtils.FileExists(CombinePath(APath, AFile));
end;

function TGarminDrv_Device.GetFile(const SFile, SSaveTo, NFile: string): boolean;
begin
  result := CopyFile(Pchar(SFile), PChar(CombinePath(SSaveTo, NFile)), false);
end;

function TGarminDrv_Device.DelFile(const SFile: string; const Recurse: boolean = false): boolean;
begin
  if (Recurse) then
    result := RemovePath(SFile, FOF_NO_UI, 1)
  else
    result := DeleteFile(Pchar(SFile));
end;

function TGarminDrv_Device.RenameFile(const ObjectId, NewName: string): boolean;
begin
  result := RenameFile(Pchar(ObjectId), Pchar(NewName));
end;

function TGarminDrv_Device.TransferNewFile(const SFile, SSaveTo: string;
                                           const NewName: WideString = ''): string;
begin
  result := CombinePath(SSaveTo, ExtractFileName(SFile));
  if not CopyFile(Pchar(SFile), PChar(result), true) then
    exit('');
end;

function TGarminDrv_Device.TransferExistingFile(const SFile, SSaveTo: string;
                                                const AListItem: TListItem): boolean;
var
  OPath: string;
begin
  if not Assigned(AListItem) then
    raise exception.Create('No item selected.');

  OPath := CombinePath(SSaveTo, ExtractFileName(SFile));
  result := CopyFile(Pchar(SFile), PChar(OPath), false);
  if (result) then
    GetListInfo(SSaveTo, ExtractFileName(SFile), AListItem);
end;

function TGarminDrv_Device.CreatePath(const Parent, DirName: string): boolean;
begin
  result := System.SysUtils.CreateDir(CombinePath(Parent, DirName));
end;

function TGarminDrv_Device.Connect(const Readonly: boolean = false): boolean;
begin
  result := true;
end;

procedure TGarminDrv_Device.Close;
begin
// Nothing
end;

function TGarminDrv_Device.ReadFiles(const Lst: TListItems;
                                     const SParent: string;
                                     var CompletePath: WideString): string;
var
  File_Info: TFile_Info;
  Fs: TSearchRec;
  Rc, MinSubItems: integer;
  ABASE_Data: TBase_Data;
begin
  result := ExtractFileDir(SParent);
  CompletePath := SParent;
  Lst.Clear;
  MinSubItems := 0;
  if (Lst.Owner is TListView) then
    MinSubItems := TListView(Lst.Owner).Columns.Count -1;

  // Add .. entry (up)
  ABASE_Data := TBase_Data.New;
  ABASE_Data.Init(true, 0, SParent, 0);
  ABASE_Data.CreateListItem(Lst, '..', [], MinSubItems);

  Rc := System.SysUtils.FindFirst(CombinePath(SParent, '*.*'), faAnyFile, Fs);
  while (Rc = 0) do
  begin
    if (Fs.Name <> '.') and
       (Fs.Name <> '..') then
    begin
      FillFileInfo(Fs, File_Info);
      ABASE_Data := TBase_Data.New;
      ABASE_Data.Init(File_Info.IsFolder, File_Info.ObjSize, CombinePath(SParent,  File_Info.ObjName), File_Info.ObjDate);
      ABASE_Data.CreateListItem(Lst, File_Info.ObjName,
        [File_Info.DateOriginal, File_Info.TimeOriginal, ExtractFileExt(File_Info.ObjName), SenSize(File_Info.ObjSize)],
       MinSubItems);
    end;
    Rc := FindNext(Fs);
  end;
  System.SysUtils.FindClose(Fs);
end;

initialization
  System.Classes.RegisterClasses([TMTP_Data, TGarminMTP_Device, TGarminDrv_Device]);
  DefaultGarminDevice := TGarminDevice.Create;
  DefaultGarminDevice.init;

finalization
  DefaultGarminDevice.Free;

end.

