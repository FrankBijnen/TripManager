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
    IsNotCalcTrip: boolean;
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

  TMTP_Device = class(TObject)
    Device: string;
    Description: string;
    FriendlyName: string;
    PortableDev: IMTPDevice;
  end;

implementation


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

end.

