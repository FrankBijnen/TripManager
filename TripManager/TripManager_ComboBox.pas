unit TripManager_ComboBox;

// Allow OwnerDraw with edit box
// Full text searching

interface

uses
  System.Classes,
  Winapi.Windows, Winapi.Messages,
  Vcl.Controls, Vcl.StdCtrls, Vcl.Themes;

type
  TColWidths = array of integer;

  TComboBox = class(Vcl.StdCtrls.TComboBox)
  private
    FStyleServices: TCustomStyleServices;
    FFullTextSearch: boolean;
    FFullTextSearchItems: TStringList;
    FColWidths: TColWidths;
    procedure FilterItems;
    procedure SetFullTextSearch(AValue: boolean);
    procedure CNCommand(var AMessage: TWMCommand); message CN_COMMAND;
    function ItemsWidth: integer;
    function DropDownItemsWidth: integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure AddFullTextSearch(ALine: string);
    procedure AdjustWidth;
    procedure AdjustDropDownWidth;
    procedure SetColCount(ACols: integer);
    procedure SetColWidth(AColumnText: string; AColumn: integer);
    procedure DrawLine(ACol: integer; Rect: TRect);
    procedure DrawCol(ACol: integer; AText: string; Rect: Trect);

    procedure HideSelection;
    property ColWidths: TColWidths read FColWidths write FColWidths;
    property FullTextSearch: boolean read FFullTextSearch write SetFullTextSearch;
  end;

implementation

uses
  System.StrUtils,
  Vcl.Graphics;

constructor TComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FFullTextSearch := false;
  FFullTextSearchItems := TStringList.Create;
  SetLength(FColWidths, 0); // Init to zeroes
  FStyleServices := TStyleManager.ActiveStyle;

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
  for ALine in Items do
  begin
    LineWidth := Canvas.TextWidth(ALine) + Margin;
    if (LineWidth > result) then
      result := LineWidth;
  end;
end;

function TComboBox.DropDownItemsWidth: Integer;
var
  LineWidth: integer;
begin
  result := 0;
  for LineWidth in FColWidths do
    result := result + LineWidth;
end;

procedure TComboBox.AdjustWidth;
begin
  Width := ItemsWidth + GetSystemMetrics(SM_CXVSCROLL);
end;

procedure TComboBox.AdjustDropDownWidth;
begin
  DropDownWidth := DropDownItemsWidth + GetSystemMetrics(SM_CXVSCROLL);
end;

procedure TComboBox.SetColCount(ACols: integer);
begin
  SetLength(FColWidths, 0); // Init to zeroes
  SetLength(FColWidths, ACols);
end;

procedure TComboBox.SetColWidth(AColumnText: string; AColumn: integer);
const
  Margin = 6;
var
  TextWidth: integer;
begin
  TextWidth := Canvas.TextWidth(AColumnText) + Margin;
  if (TextWidth > ColWidths[AColumn]) then
    ColWidths[AColumn] := TextWidth;
end;

procedure TComboBox.DrawLine(ACol: integer; Rect: TRect);
var
  Cnt, LinePos: integer;
begin
  if (High(ColWidths) < ACol) then
    exit;

  LinePos := 0;
  for Cnt := 0 to ACol do
    LinePos := LinePos + ColWidths[Cnt];

  Canvas.Pen.Color := FStyleServices.GetStyleFontColor(TStyleFont.sfListItemTextNormal);
  Canvas.MoveTo(LinePos, Rect.Top);
  Canvas.LineTo(LinePos, Rect.Bottom);
end;

procedure TComboBox.DrawCol(ACol: integer; AText: string; Rect: Trect);
const
  Margin = 3;
var
  TextPos, Cnt: integer;
  DrawRect: TRect;
begin
  DrawRect := Rect;

  if (ACol <= High(ColWidths)) then
  begin
    TextPos := 0;
    for Cnt := 0 to ACol -1 do
      TextPos := TextPos + ColWidths[Cnt];

    DrawRect.Left := TextPos + Margin;
    DrawRect.Width := ColWidths[ACol];
  end;

  Canvas.TextRect(DrawRect, AText, [TTextFormats.tfLeft, TTextFormats.tfSingleLine]);
end;

procedure TComboBox.HideSelection;
begin
  PostMessage(Handle, CB_SETEDITSEL, WPARAM(-1), LPARAM(0));
end;

end.
