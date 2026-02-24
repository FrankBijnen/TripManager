// Generic data classes for mtp_helper
// Can be extended. See UnitMTPDevice
unit UnitMTPDefs;

interface

uses
  System.Classes,
  Vcl.ComCtrls,
  PortableDeviceApiLib_TLB;

type
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
//TODO Add more methods. Eliminating need for 'uses mtp_helper'
    function FileExists(const APath, AFile:string): boolean; virtual;
    class function DeviceIdInList(const Device: string; const DeviceList: Tlist): integer;
    class procedure GetRegisteredDeviceClasses;
    class function New: TBase_Device;
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

function TBase_Device.FileExists(const APath, AFile:string): boolean;
begin
  result := (GetIdForFile(PortableDev, WideString(APath), WideString(AFile)) <> '');
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

class procedure TBase_Device.GetRegisteredDeviceClasses;
begin
  FPersistentDataClass := GetClass(MTP_DATA_CLASS);
  FPersistentDeviceClass := GetClass(MTP_DEVICE_CLASS);
end;

initialization
  FPersistentDataClass := nil;
  FPersistentDeviceClass := nil;

end.
