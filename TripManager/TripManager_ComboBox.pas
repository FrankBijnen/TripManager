unit TripManager_ComboBox;

// Allow OwnerDraw with edit box
// Full text searching

interface

uses
  System.Classes,
  Winapi.Windows, Winapi.Messages,
  Vcl.Controls, Vcl.StdCtrls;

type
  TColWidths = array of integer;

  TComboBox = class(Vcl.StdCtrls.TComboBox)
  private
    FFullTextSearch: boolean;
    FFullTextSearchItems: TStringList;
    FColWidths: TColWidths;
    procedure FilterItems;
    procedure SetFullTextSearch(AValue: boolean);
    procedure CNCommand(var AMessage: TWMCommand); message CN_COMMAND;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure AddFullTextSearch(ALine: string);
    function ItemsWidth: integer;
    procedure AdjustWidths;
    procedure SetColWidths(ACols: integer);
    property  ColWidths: TColWidths read FColWidths write FColWidths;

    property FullTextSearch: boolean read FFullTextSearch write SetFullTextSearch;
  end;

implementation

uses
  System.StrUtils;

constructor TComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FFullTextSearch := false;
  FFullTextSearchItems := TStringList.Create;
  SetLength(FColWidths, 0); // Init to zeroes
end;

destructor TComboBox.Destroy;
begin
  FFullTextSearchItems.Free;
  inherited;
end;

procedure TComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited;

  if Assigned(OnDrawItem) then
    Params.Style := Params.Style or CBS_OWNERDRAWFIXED
end;

procedure TComboBox.CNCommand(var AMessage: TWMCommand);
begin
  inherited;

  if AMessage.NotifyCode = CBN_EDITUPDATE then
    FilterItems;
end;

procedure TComboBox.FilterItems;
var
  ALine: string;
  Selection: TSelection;
begin
  if not FFullTextSearch then
    exit;

  // store the current combo edit selection
  SendMessage(Handle, CB_GETEDITSEL, WPARAM(@Selection.StartPos), LPARAM(@Selection.EndPos));

  Items.BeginUpdate;
  try
    if Text = '' then
      Items.Assign(FFullTextSearchItems)
    else
    begin
      Items.Clear;
      for ALine in FFullTextSearchItems do
      begin
        if ContainsText(ALine, Text) then
          Items.Add(ALine);
      end;
    end;
  finally
    Items.EndUpdate;
  end;

  SendMessage(Handle, CB_SETEDITSEL, 0, MakeLParam(Selection.StartPos, Selection.EndPos));
end;

procedure TComboBox.SetFullTextSearch(AValue: boolean);
begin
  if (FFullTextSearch <> AValue) then
    FFullTextSearch := AValue;
  AutoComplete := not FFullTextSearch;
end;

procedure TComboBox.AddFullTextSearch(ALine: string);
var
  P: integer;
begin
  if (ALine = '') then
    exit;

  P := FFullTextSearchItems.IndexOf(ALine);
  if (P > -1) then
    FFullTextSearchItems.Delete(P);
  FFullTextSearchItems.Insert(0, Aline);
  FullTextSearch := true;

  if (HandleAllocated) then
  begin
    Items.Text:= FFullTextSearchItems.Text;
    ItemIndex := 0;
  end
  else
    Text := ALine;
end;

function TComboBox.ItemsWidth: Integer;
const
  Margin = 8;
var
  ALine: string;
  LineWidth: integer;
begin
  result := 0;
  if (Length(FColWidths) > 0) then
  begin
    for LineWidth  in FColWidths do
      result := result + LineWidth;
  end
  else
  begin
    for ALine in Items do
    begin
      LineWidth := Canvas.TextWidth(ALine) + Margin;
      if (LineWidth > result) then
        result := LineWidth;
    end;
  end;
end;

procedure TComboBox.AdjustWidths;
begin
  Width := ItemsWidth + GetSystemMetrics(SM_CXVSCROLL);
  DropDownWidth := Width;
end;

procedure TComboBox.SetColWidths(ACols: integer);
begin
  SetLength(FColWidths, 0); // Init to zeroes
  SetLength(FColWidths, ACols);
end;

end.
