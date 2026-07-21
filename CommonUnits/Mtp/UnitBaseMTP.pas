// Generic data classes for mtp_helper
// Can be extended. See UnitMTPDevice
unit UnitBaseMTP;

interface

uses
  System.Classes,
  Vcl.ComCtrls,
  PortableDeviceApiLib_TLB;

const
  System1Partition    = 'System1';
  CardPartition       = 'Card';
  USB_DISK            = 'usbstor#disk';   // For (Garmin's) in Mass Storage Mode
  USB_BUSENUM         = 'swd#wpdbusenum'; // For (Garmin's) in Mass Storage Mode
  MTP_ID              = 'MTP';
  MSM_ID              = 'MSM';
  NonMTPRoot          = '?:\';
  RelativePath        = '.';

type
  TMediaType = (mtMTP, mtMSM, mtDRV);

  TPartitionPrio = (ppLow, ppNorm, ppHigh);

  TFile_Info = record
    ObjName: string;
    IsFolder: boolean;
    ObjDate: TDateTime;
    DateOriginal: string;
    TimeOriginal: string;
    ObjSize: int64;
  end;

  TBase_Data = class(TPersistent)
  public
    IsFolder: boolean;
    SortValue: int64;
    ObjectId: string;
    Created: TDateTime;
    constructor Create;
    procedure Init(const AIsFolder: boolean;
                       const ASortValue: int64;
                       const AObjectId: string;
                       const ACreated: TDateTime); virtual;
    function CreateListItem(const AList: TListItems;
                            const ACaption: string;
                            const ASubItems: array of string;
                            const AMinSubItems: integer): TListItem;
    class procedure UpdateListItem(const AListItem: TListItem;
                                   const ASubItems: array of string;
                                   const AMinSubItems: integer);
    class function New: TBase_Data;
  end;

  TBase_Device = class(TPersistent)
  protected
    function GetPathId(APath: string): string; virtual;
    function GetFileId(APath, AFile: string): string; virtual;
    function GetFriendlyPath(APath: string): string; virtual;
    function GetMediaDescription: string; virtual;
  public
    ID: integer;
    SerialId: integer;
    Device: string;
    Description: string;
    FriendlyName: string;
    Serial: string;
    Manufacturer: string;
    FMediaType: TMediaType;
    PortableDev: IPortableDevice;
    procedure Init; virtual;
    function CheckDevice: boolean; virtual;
    function DisplayedDevice: string; virtual;
    function GetManufacturer: PWideChar; virtual;
    procedure GetInfoFromDevice(const DeviceList: Tlist); virtual;
    function FileExists(const APath, AFile:string): boolean; virtual;
    function PartitionPrio: TPartitionPrio;
    function GetFileInfo(const APath, AFile: string;
                         var File_Info: TFile_Info): string; virtual;
    function GetListInfo(const APath, AFile: string;
                         const AListItem: TListItem): string; virtual;
    function GetFriendlyIdForPath(const SPath: string;
                                  var FriendlyPath: string): string; virtual;

    function GetFile(const SFile, SSaveTo, NFile: string): boolean; virtual;
    function DelFile(const SFile: string; const Recurse: boolean = false): boolean; virtual;
    function RenameFile(const ObjectId, NewName: string): boolean; virtual;
    function TransferNewFile(const SourceFile, DirOnDev: string): string; virtual;
    function TransferExistingFile(const SourceFile, DirOnDev: string;
                                  const AListItem: TListItem): boolean; virtual;
    function CreatePath(const Parent, DirName: string): boolean; virtual;
    function ReadFiles(const Lst: TListItems;
                       const SParent: string;
                       var CompletePath: WideString): string; overload; virtual;
    procedure ReadFiles(const Lst: TListItems;
                        const SParent: string); overload; virtual;

    function Connect(const Readonly: boolean = false): boolean; virtual;
    procedure Close; virtual;

    class procedure UpdateDeviceList(const DeviceList: TList);
    class procedure GetRemovableDrives(const DeviceList: TList; const DeviceClass: TPersistentClass = nil);
    class function GetDeviceList(const DeviceList: TList;
                                 const DataClass: TPersistentClass = nil;
                                 const MTPClass: TPersistentClass = nil;
                                 const DRVClass: TPersistentClass = nil): boolean;
    class function DeviceIdInList(const Device: string; const DeviceList: Tlist): integer;
    class function New(DeviceClass: TPersistentClass): TBase_Device;

    class function Clone(const ABase_Device: TBase_Device): TBase_Device;
    class function GetMediaType(const DeviceName: string): TMediaType;

    property PathId[APath: string]: string read GetPathId;
    property FileId[APath, AFile: string]: string read GetFileId;
    property FriendlyPath[APath: string]: string read GetFriendlyPath;
    property MediaType: string read GetMediaDescription;
  end;

implementation

uses
  System.SysUtils, System.StrUtils, System.Math, System.Masks,
  Winapi.Windows,
  mtp_helper, UnitStringUtils;

var
  FPersistentDataClass: TPersistentClass;
  FPersistentMTPDeviceClass: TPersistentClass;
  FPersistentDRVDeviceClass: TPersistentClass;

{ TBASE_Data }

constructor TBase_Data.Create;
begin
  inherited Create;
end;

procedure TBase_Data.Init(const AIsFolder: boolean;
                          const ASortValue: int64;
                          const AObjectId: string;
                          const ACreated: TDateTime);
begin
  IsFolder  := AIsFolder;
  SortValue := ASortValue;
  ObjectId  := AObjectId;
  Created   := ACreated;
end;

function TBase_Data.CreateListItem(const AList: TListItems;
                                   const ACaption: string;
                                   const ASubItems: array of string;
                                   const AMinSubItems: integer): TListItem;
begin
  result := AList.Add;

  if (IsFolder) then
    result.ImageIndex := 1
  else
    result.ImageIndex := 0;
  result.Caption := ACaption;
  UpdateListItem(result, ASubItems, AMinSubItems);

  result.Data := Self;
end;

class procedure TBase_Data.UpdateListItem(const AListItem: TListItem;
                                          const ASubItems: array of string;
                                          const AMinSubItems: integer);
var
  SubItem: string;
begin
  AListItem.SubItems.Clear;
  for SubItem in ASubItems do
    AListItem.SubItems.Add(SubItem);

  while (AListItem.SubItems.Count < AMinSubItems) do
    AListItem.SubItems.Add('');
end;

class function TBase_Data.New: TBase_Data;
begin
  if (FPersistentDataClass <> nil) then
    result := TBase_Data(FPersistentDataClass.Create)
  else
    result := TBase_Data.Create;
end;

{ TBase_Device }
procedure TBase_Device.Init;
begin
  {}
end;

function TBase_Device.CheckDevice: boolean;
begin
  result := Assigned(PortableDev) and
            (MTP_FirstStorageIDs(PortableDev) <> nil);
end;

function TBase_Device.DisplayedDevice: string;
begin
  result := Format('%s (%s)', [FriendlyName, Description]);
end;

// This method works more reliable, than IPortableDeviceManager.GetDeviceManufacturer
function TBase_Device.GetManufacturer: PWideChar;
var
  Content: IPortableDeviceContent;
  DevProps: IPortableDeviceProperties;
  DevValues: IPortableDeviceValues;
  Manufacturer_Key: PortableDeviceApiLib_TLB._tagpropertykey;
begin
  result := '';
  if (PortableDev = nil) then
    exit;
  if (PortableDev.Content(Content) <> S_OK) then
    exit;
  if (Content.Properties(DevProps) <> S_OK) then
    exit;
  if (DevProps.GetValues(WPD_DEVICE_OBJECT_ID, nil, DevValues) <> S_OK) then
    exit;
  Manufacturer_Key.fmtid := WPD_DEVICE_MANUFACTURER.fmtid;
  Manufacturer_Key.pid := WPD_DEVICE_MANUFACTURER.pid;
  if (DevValues.GetStringValue(Manufacturer_Key, result) <> S_OK) then
    exit;
end;

procedure TBase_Device.GetInfoFromDevice(const DeviceList: Tlist);
begin
  Manufacturer := GetManufacturer;
end;

function TBase_Device.GetPathId(APath: string): string;
var
  FriendlyName: string;
begin
  result := MTP_GetIdForPath(PortableDev, APath, FriendlyName);
end;

function TBase_Device.GetFileId(APath, AFile: string): string;
begin
  result := MTP_GetIdForFile(PortableDev, APath, AFile);
end;

function TBase_Device.GetFriendlyPath(APath: string): string;
begin
  MTP_GetIdForPath(PortableDev, APath, result);
end;

function TBase_Device.GetMediaDescription: string;
begin
  result := '';
  case (FMediaType) of
    TMediaType.mtMTP:
      result := 'MTP';
    TMediaType.mtMSM:
      result := 'MSM';
  end;
end;

function TBase_Device.FileExists(const APath, AFile:string): boolean;
begin
  result := (FileId[APath, AFile] <> '');
end;

function TBase_Device.PartitionPrio: TPartitionPrio;
begin
  if (ContainsText(Description, System1Partition)) then
    result := TPartitionPrio.ppHigh
  else if (ContainsText(Description, CardPartition)) then
    result := TPartitionPrio.ppLow
  else
    result := TPartitionPrio.ppNorm;
end;

function TBase_Device.GetFileInfo(const APath, AFile: string;
                                  var File_Info: TFile_Info): string;
begin
  result := MTP_GetIdForFile(PortableDev, APath, AFile, File_Info);
end;

function TBase_Device.GetListInfo(const APath, AFile: string;
                                  const AListItem: TListItem): string;
begin
  result := MTP_GetIdForFile(PortableDev, APath, AFile, AListItem);
end;

function TBase_Device.GetFriendlyIdForPath(const SPath: string;
                                           var FriendlyPath: string): string;
begin
  result := MTP_GetIdForPath(PortableDev, SPath, FriendlyPath);
end;

function TBase_Device.GetFile(const SFile, SSaveTo, NFile: string): boolean;
begin
  result := MTP_GetFileFromDevice(PortableDev, SFile, SSaveTo, NFile);
end;

function TBase_Device.DelFile(const SFile: string; const Recurse: boolean = false): boolean;
begin
  result := MTP_DelFromDevice(PortableDev, SFile, Recurse);
end;

function TBase_Device.RenameFile(const ObjectId, NewName: string): boolean;
begin
  CheckSurrogate(NewName);
  result := MTP_RenameDeviceFile(PortableDev, ObjectId, NewName);
end;

function TBase_Device.TransferNewFile(const SourceFile, DirOnDev: string): string;
var
  NameOnDev: string;
begin
  NameOnDev := ExtractFileName(SourceFile);
  CheckSurrogate(NameOnDev);
  result := MTP_TransferNewFileToDevice(PortableDev, SourceFile, DirOnDev, NameOnDev);
end;

function TBase_Device.TransferExistingFile(const SourceFile, DirOnDev: string;
                                           const AListItem: TListItem): boolean;
begin
  if not Assigned(AListItem) then
    raise exception.Create('No item selected.');

  CheckSurrogate(AListItem.Caption);
  result := MTP_TransferExistingFileToDevice(PortableDev, SourceFile, DirOnDev, AListItem);
end;

function TBase_Device.CreatePath(const Parent, DirName: string): boolean;
begin
  CheckSurrogate(DirName);
  result := MTP_CreateDevicePath(PortableDev, Parent, DirName);
end;

function TBase_Device.ReadFiles(const Lst: TListItems;
                                const SParent: string;
                                var CompletePath: WideString): string;
begin
  result := MTP_ReadFilesFromDevice(PortableDev, Lst, Sparent, CompletePath);
end;

procedure TBase_Device.ReadFiles(const Lst: TListItems;
                                 const SParent: string);
var
  CompletePath: WideString;
begin
  ReadFiles(Lst, SParent, CompletePath);
end;

function TBase_Device.Connect(const Readonly: boolean = false): boolean;
begin
  result := MTP_ConnectToDevice(Device, PortableDev, Readonly);
end;

procedure TBase_Device.Close;
begin
  PortableDev := nil;
end;

class function TBase_Device.DeviceIdInList(const Device: string; const DeviceList: Tlist): integer;
var
  Index: integer;
begin
  result := -1;
  if (Device = '') then
    exit;

  for Index := 0 to DeviceList.Count -1 do
  begin
    if (SameText(TBase_Device(DeviceList[Index]).Device, Device)) then
      exit(Index);
  end;
end;

class function TBase_Device.New(DeviceClass: TPersistentClass): TBase_Device;
begin
  if (DeviceClass <> nil) then
    result := TBase_Device(DeviceClass.Create)
  else
    result := TBase_Device.Create;
end;

class function TBase_Device.Clone(const ABase_Device: TBase_Device): TBase_Device;
var
  DeviceClass: TPersistentClass;
begin
  DeviceClass := nil;
  if (Assigned(ABase_Device)) then
    DeviceClass := TPersistentClass(ABase_Device.ClassType);

  result := New(DeviceClass);
  result.Device         := '';    // Documentation purpose

  if not Assigned(ABase_Device) then
    exit;

  result.ID             := ABase_Device.ID;
  result.SerialId       := ABase_Device.SerialId;
  result.Device         := ABase_Device.Device;
  result.Description    := ABase_Device.Description;
  result.FriendlyName   := ABase_Device.FriendlyName;
  result.Serial         := ABase_Device.Serial;
  result.Manufacturer   := ABase_Device.Manufacturer;
  result.FMediaType     := ABase_Device.FMediaType;
  result.PortableDev    := nil;
end;

class function TBase_Device.GetMediaType(const DeviceName: string): TMediaType;
begin
  if (MatchesMask(DeviceName, NonMTPRoot)) then
    result := TMediaType.mtDRV
  else
    result := TMediaType.mtMTP;
  if (ContainsText(DeviceName, USB_DISK)) and
     (ContainsText(DeviceName, USB_BUSENUM)) then
    result := TMediaType.mtMSM;
end;

function CompareDevice(Item1, Item2: Pointer): Integer;
begin
  Result := CompareValue(TBase_Device(Item1).SerialId, TBase_Device(Item2).SerialId);
  if (Result = 0) then
    Result := CompareText(TBase_Device(Item1).Description, TBase_Device(Item2).Description);
end;

class procedure TBase_Device.UpdateDeviceList(const DeviceList: TList);
var
  Index: Integer;
  AMTP_Device: TBase_Device;
  SerialList: TStringList;
begin
  SerialList := TStringList.Create;
  SerialList.Sorted := True;
  SerialList.Duplicates := TDuplicates.dupIgnore;
  try
    // Assign same serialId to Device storage, and inserted SD cards
    for Index := 0 to DeviceList.Count -1 do
      SerialList.Add(TBase_Device(DeviceList[Index]).Serial);

    for Index := 0 to DeviceList.Count -1 do
    begin
      AMTP_Device := DeviceList[Index];
      AMTP_Device.SerialId := SerialList.IndexOf(AMTP_Device.Serial);
    end;

    DeviceList.Sort(@CompareDevice);

    // renumber Device ID, after sort
    // Get Additional Info from opened device. (Manufacturer, GarminDevice, Root path)
    for Index := 0 to DeviceList.Count -1 do
    begin
      AMTP_Device := DeviceList[Index];
      AMTP_Device.ID := Index;
      AMTP_Device.Init;

      AMTP_Device.Connect(true);
      try
        AMTP_Device.GetInfoFromDevice(DeviceList);
      finally
        AMTP_Device.PortableDev := nil;
      end;

    end;
  finally
    SerialList.Free;
  end;
end;

class procedure TBase_Device.GetRemovableDrives(const DeviceList: TList; const DeviceClass: TPersistentClass = nil);
var
  VolumeName: string;
  DriveLetter: Char;
  WideLetter: WideString;
  VolumeSerialNumber: DWORD;
  Connected, NUL: DWORD;
  ADRV_Device: TBase_Device;
//  WVolumeSerial: array[0..50] of WideChar;
//  VolumeSerial: string;
begin
  Nul := 0;
  Connected := GetLogicalDrives shl 1;
  for DriveLetter := 'A' to 'Z' do
  begin
    // Drive Connected?
    Connected := Connected shr 1;
    if (Connected and $1) = 0 then
      continue;

    // Floppy or Network Share?
    WideLetter := Format('%s:\', [DriveLetter]);
    if not (GetDriveType(PWideChar(WideLetter)) in [DRIVE_REMOVABLE, DRIVE_REMOTE]) then
      continue;

    SetLength(VolumeName, MAX_PATH +1);
    if not GetVolumeInformation(PWideChar(WideLetter),
                                PChar(VolumeName),      // address of name of the volume
                                Length(VolumeName),     // length of lpVolumeNameBuffer
                                @VolumeSerialNumber,    // address of volume serial number
                                Nul,                    // address of system's maximum filename leng
                                Nul,                    // address of file system flags
                                nil,                    // address of name of file system
                                0                       // length of lpFileSystemNameBuffer
                              ) then
      continue;

//    if not GetVolumeNameForVolumeMountPoint(PWideChar(WideLetter), WVolumeSerial, SizeOf(WVolumeSerial)) then
//      continue;

    //  Create device object
    ADRV_Device := TBase_Device.New(DeviceClass);
    ADRV_Device.FriendlyName  := WideLetter;
    ADRV_Device.Description   := PChar(VolumeName);
    ADRV_Device.Device        := WideLetter;
    ADRV_Device.FMediaType    := TMediaType.mtDRV;
(*
not reliable on Wine
    VolumeSerial := WVolumeSerial;
    ADRV_Device.Serial := NextField(VolumeSerial, '-');
    ADRV_Device.Serial := LeftStr(VolumeSerial, 14);
*)
    ADRV_Device.Serial := Format('%d', [VolumeSerialNumber]);
    ADRV_Device.PortableDev   := nil;
    DeviceList.Add(ADRV_Device);
  end;
end;

class function TBase_Device.GetDeviceList(const DeviceList: TList;
                                          const DataClass: TPersistentClass = nil;
                                          const MTPClass: TPersistentClass = nil;
                                          const DRVClass: TPersistentClass = nil): boolean;
begin
  FPersistentDataClass := DataClass;
  FPersistentMTPDeviceClass := MTPClass;
  FPersistentDRVDeviceClass := DRVClass;

  result := MTP_GetDevices(DeviceList, FPersistentMTPDeviceClass);
  if (result = false) and
     Assigned(FPersistentDRVDeviceClass) then
    GetRemovableDrives(DeviceList, FPersistentDRVDeviceClass);

  UpdateDeviceList(DeviceList);
end;

initialization
  FPersistentDataClass := nil;
  FPersistentMTPDeviceClass := nil;
  FPersistentDRVDeviceClass := nil;

end.
