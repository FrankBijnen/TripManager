unit UnitMtpDevice;
// Classes to hold info on MTP Devices

interface

uses
  System.Classes, Vcl.ComCtrls, PortableDeviceApiLib_TLB;

type
  IMTPDevice = IPortableDevice;

  TBASE_Data = class(TObject)
    IsFolder: boolean;
    SortValue: int64;
    ObjectId: string;
    Created: TDateTime;
    IsNotSavedTrip: boolean;
    IsCalculated: boolean;
    ExploreUUID: string;
  public
    constructor Create(const AIsFolder: boolean;
                       const ASortValue: int64;
                       const AObjectId: string;
                       const ACreated: TDateTime);
    procedure UpdateListItem(const AListItem: TListItem;
                             const ASubItems: array of string);
    function CreateListItem(const Alist: TListItems;
                            const ACaption: string;
                            const ASubItems: array of string): TListItem;
  end;

  TMTP_Data = class(TBASE_Data)
  end;

  TFile_Info = record
    ObjName: PWideChar;
    IsFolder: boolean;
    ObjDate: TDateTime;
    DateOriginal: string;
    TimeOriginal: string;
    ObjSize: int64;
  end;

  TMTP_Device = class(TObject)
    ID: integer;
    SerialId: integer;
    Device: string;
    Description: string;
    FriendlyName: string;
    Serial: string;
    Manufacturer: string;
    PortableDev: IMTPDevice;
    function DisplayedDevice: string;
    class function DeviceIdInList(const Device: string; const DeviceList: Tlist): integer;
  end;

implementation

uses
  System.SysUtils;

constructor TBASE_Data.Create(const AIsFolder: boolean;
                              const ASortValue: int64;
                              const AObjectId: string;
                              const ACreated: TDateTime);

begin
  inherited Create;
  IsFolder  := AIsFolder;
  SortValue := ASortValue;
  ObjectId  := AObjectId;
  Created   := ACreated;
end;

procedure TBASE_Data.UpdateListItem(const AListItem: TListItem;
                                    const ASubItems: array of string);
var SubItem: string;
begin
  AListItem.SubItems.Clear;
  for SubItem in ASubItems do
    AListItem.SubItems.Add(SubItem);
end;

function TBASE_Data.CreateListItem(const Alist: TListItems;
                                   const ACaption: string;
                                   const ASubItems: array of string): TListItem;
begin
  result := Alist.Add;

  if (IsFolder) then
    result.ImageIndex := 1
  else
    result.ImageIndex := 0;
  result.Caption := ACaption;
  UpdateListItem(result, ASubItems);

  result.Data := Self;
end;

function TMTP_Device.DisplayedDevice: string;
begin
  result := Format('%s (%s)', [FriendlyName, Description]);
end;

class function TMTP_Device.DeviceIdInList(const Device: string; const DeviceList: Tlist): integer;
var
  Index: integer;
begin
  result := -1;
  if (Device = '') then
    exit;

  for Index := 0 to DeviceList.Count -1 do
  begin
    if (SameText(TMTP_Device(DeviceList[Index]).Device, Device)) then
      exit(Index);
  end;
end;


end.

