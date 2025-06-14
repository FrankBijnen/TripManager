// Holds a reference to the TripList objects associated with the Grid
unit TripManager_GridSelItem;

interface

uses
  UnitTripObjects,
  Vcl.ValEdit;

type
  TGridSelItem = class(TObject)
  private
    FBaseItem: TBaseItem;
    FSelStart: integer;
    FSelLength: integer;
  public
    constructor Create(ABaseItem: TBaseItem;
                       ASelLength: integer = -1;
                       ASelStart: integer = -1); overload;
    constructor Create(ASelLength, ASelStart: integer); overload;
    property BaseItem: TBaseItem read FBaseItem;
    property SelStart: integer read FSelStart;
    property SelLength: integer read FSelLength;
    class function GridSelItem(AValueListEditor: TValueListEditor; ARow: integer): TGridSelItem;
    class function BaseDataItem(AValueListEditor: TValueListEditor; ARow: integer): TBaseDataItem;
  end;

implementation

constructor TGridSelItem.Create(ABaseItem: TBaseItem;
                                ASelLength: integer = -1;
                                ASelStart: integer = -1);
begin
  inherited Create;
  FBaseItem := ABaseItem;

  FSelStart := integer(FBaseItem.SelStart);
  if (ASelStart <> -1) then
    FSelStart := FSelStart + ASelStart;

  FSelLength := ASelLength;
  if (FSelLength = -1) then
    FSelLength := integer(FBaseItem.SelEnd) - FSelStart;
end;

constructor TGridSelItem.Create(ASelLength, ASelStart: integer);
begin
  inherited Create;
  FBaseItem := nil;
  FSelStart := ASelStart;
  FSelLength := ASelLength;
end;

class function TGridSelItem.GridSelItem(AValueListEditor: TValueListEditor; ARow: integer): TGridSelItem;
begin
  result := nil;

  if (ARow < 0) or
     (ARow > AValueListEditor.Strings.Count -1) then
    exit;

  if (AValueListEditor.Strings.Objects[ARow] <> nil) and
     (AValueListEditor.Strings.Objects[ARow] is TGridSelItem)  then
    result := TGridSelItem(AValueListEditor.Strings.Objects[ARow]);
end;

class function TGridSelItem.BaseDataItem(AValueListEditor: TValueListEditor; ARow: integer): TBaseDataItem;
var
  AGridSel: TGridSelItem;
begin
  result := nil;
  AGridSel := TGridSelItem.GridSelItem(AValueListEditor, ARow);
  if not Assigned(AGridSel) then
    exit;

  if (AGridSel.FBaseItem <> nil) and
     (AGridSel.FBaseItem is TBaseDataItem) then
    result := TBaseDataItem(AGridSel.FBaseItem);
end;

end.
