// Generic data classes for mtp_helper
// Can be extended. See UnitMTPDevice
unit UnitMTPDefs;

interface

uses
  System.Classes,
  Vcl.ComCtrls,
  PortableDeviceApiLib_TLB;

const
  System1Partition    = 'System1';
  CardPartition       = 'Card';
  USB_DISK            = 'usbstor#disk'; // For (Garmin's) in Mass Storage Mode
  USB_BUSENUM         = 'swd#wpdbusenum'; // For (Garmin's) in Mass Storage Mode
  MTP_ID              = 'MTP';
  MSM_ID              = 'MSM';

type
  TPartitionPrio = (ppLow, ppNorm, ppHigh);

  TFile_Info = record
    ObjName: PWideChar;
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
    procedure UpdateListItem(const AListItem: TListItem;
                             const ASubItems: array of string;
                             const AMinSubItems: integer);
    function CreateListItem(const AList: TListItems;
                            const ACaption: string;
                            const ASubItems: array of string;
                            const AMinSubItems: integer): TListItem;
    class function New: TBase_Data;
  end;

  TBase_Device = class(TPersistent)
  protected
    function GetPathId(APath: string): string;
    function GetFileId(APath, AFile: string): string;
    function GetFriendlyPath(APath: string): string;
  public
    ID: integer;
    SerialId: integer;
    Device: string;
    Description: string;
    FriendlyName: string;
    Serial: string;
    Manufacturer: string;
    MSM: string;
    PortableDev: IPortableDevice;
    procedure Init; virtual;
    function CheckDevice: boolean; virtual;
    function DisplayedDevice: string; virtual;
    function GetManufacturer: PWideChar;
    procedure GetInfoFromDevice(const DeviceList: Tlist); virtual;
    function FileExists(const APath, AFile:string): boolean; virtual;
    function PartitionPrio: TPartitionPrio;
    function GetListInfo(const APath, AFile: string;
                         const AListItem: TListItem): string;
    function GetFileInfo(const APath, AFile: string;
                         var File_Info: TFile_Info): string;
    function GetFriendlyIdForPath(const SPath: string;
                                 var FriendlyPath: string): string;

    function GetFile(const SFile, SSaveTo, NFile: string): boolean;
    function DelFile(const SFile: string; const Recurse: boolean = false): boolean;
    function RenameFile(const ObjectId, NewName: string): boolean;
    function TransferNewFile(const SFile, SSaveTo: string;
                             const NewName: WideString = ''): string;
    function TransferExistingFile(const SFile, SSaveTo: string;
                                  const AListItem: TListItem): boolean;
    function CreatePath(const Parent, DirName: string): boolean;
    function ReadFiles(const Lst: TListItems;
                       const SParent: string;
                       var CompletePath: WideString): string; overload;
    procedure ReadFiles(const Lst: TListItems;
                        const SParent: string); overload;

    function Connect(const Readonly: boolean = false): boolean;

    class function GetDeviceList: TList;
    class function DeviceIdInList(const Device: string; const DeviceList: Tlist): integer;
    class procedure GetRegisteredDeviceClasses;
    class function New: TBase_Device;
    class function Clone(const ABase_Device: TBase_Device): TBase_Device;
    class function GetMSM(const DeviceName: string): string;

    property PathId[APath: string]: string read GetPathId;
    property FileId[APath, AFile: string]: string read GetFileId;
    property FriendlyPath[APath: string]: string read GetFriendlyPath;
  end;


implementation

uses
  System.SysUtils, System.StrUtils,
  mtp_helper;

const
  MTP_DEVICE_CLASS = 'TMTP_Device';
  MTP_DATA_CLASS   = 'TMTP_Data';

var
  FPersistentDataClass: TPersistentClass;
  FPersistentDeviceClass: TPersistentClass;

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

procedure TBase_Data.UpdateListItem(const AListItem: TListItem;
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
            (FirstStorageIds(PortableDev) <> nil);
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
  result := GetIdForPath(PortableDev, APath, FriendlyName);
end;

function TBase_Device.GetFileId(APath, AFile: string): string;
begin
  result := GetIdForFile (PortableDev, APath, AFile);
end;

function TBase_Device.GetFriendlyPath(APath: string): string;
begin
  GetIdForPath(PortableDev, APath, result);
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

function TBase_Device.GetListInfo(const APath, AFile: string;
                                  const AListItem: TListItem): string;

begin
  result := GetIdForFile(PortableDev, APath, AFile, AListItem);
end;

function TBase_Device.GetFileInfo(const APath, AFile: string;
                                  var File_Info: TFile_Info): string;
begin
  result := GetIdForFile(PortableDev, APath, AFile, File_Info);
end;

function TBase_Device.GetFriendlyIdForPath(const SPath: string;
                                           var FriendlyPath: string): string;
begin
  result := GetIdForPath(PortableDev, SPath, FriendlyPath);
end;

function TBase_Device.GetFile(const SFile, SSaveTo, NFile: string): boolean;
begin
  result := GetFileFromDevice(PortableDev, SFile, SSaveTo, NFile);
end;

function TBase_Device.DelFile(const SFile: string; const Recurse: boolean = false): boolean;
begin
  result := DelFromDevice(PortableDev, SFile, Recurse);
end;

function TBase_Device.RenameFile(const ObjectId, NewName: string): boolean;
begin
  result := RenameDeviceFile(PortableDev, ObjectId, NewName);
end;

function TBase_Device.TransferNewFile(const SFile, SSaveTo: string;
                                      const NewName: WideString = ''): string;
begin
  result := TransferNewFileToDevice(PortableDev, SFile, SSaveTo, NewName);
end;

function TBase_Device.TransferExistingFile(const SFile, SSaveTo: string;
                                           const AListItem: TListItem): boolean;
begin
  if not Assigned(AListItem) then
    raise exception.Create('No item selected.');

  result := TransferExistingFileToDevice(PortableDev, SFile, SSaveTo, AListItem);
end;

function TBase_Device.CreatePath(const Parent, DirName: string): boolean;
begin
  result := CreateDevicePath(PortableDev, Parent, DirName);
end;

function TBase_Device.ReadFiles(const Lst: TListItems;
                                const SParent: string;
                                var CompletePath: WideString): string;
begin
  result := ReadFilesFromDevice(PortableDev, Lst, Sparent, CompletePath);
end;

procedure TBase_Device.ReadFiles(const Lst: TListItems;
                                 const SParent: string);
begin
  ReadFilesFromDevice(PortableDev, Lst, SParent);
end;

function TBase_Device.Connect(const Readonly: boolean = false): boolean;
begin
  result := ConnectToDevice(Device, PortableDev, Readonly);
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

class function TBase_Device.New: TBase_Device;
begin
  if (FPersistentDeviceClass <> nil) then
    result := TBase_Device(FPersistentDeviceClass.Create)
  else
    result := TBase_Device.Create;
end;

class function TBase_Device.Clone(const ABase_Device: TBase_Device): TBase_Device;
begin
  result := New;
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
  result.MSM            := ABase_Device.MSM;
  result.PortableDev    := nil;
end;

class function TBase_Device.GetMSM(const DeviceName: string): string;
begin
  result := MTP_ID;
  if (ContainsText(DeviceName, USB_DISK)) and
     (ContainsText(DeviceName, USB_BUSENUM)) then
    result := MSM_ID;
end;

class procedure TBase_Device.GetRegisteredDeviceClasses;
begin
  FPersistentDataClass := GetClass(MTP_DATA_CLASS);
  FPersistentDeviceClass := GetClass(MTP_DEVICE_CLASS);
end;

class function TBase_Device.GetDeviceList: TList;
begin
  result := GetDevices;
end;

initialization
  FPersistentDataClass := nil;
  FPersistentDeviceClass := nil;

end.
