unit UFrmSelectGPX;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus;

type
  TTagsToShow = (WptRte = 1, RteTrk = 10, Rte = 20, Trk = 30);

  TFrmSelectGPX = class(TForm)
    LvTracks: TListView;
    PnlTop: TPanel;
    PnlBot: TPanel;
    BitBtnOK: TBitBtn;
    BitBtnCan: TBitBtn;
    PopupMenu1: TPopupMenu;
    CheckAll1: TMenuItem;
    CheckNone1: TMenuItem;
    PnlColor: TPanel;
    CmbOverruleColor: TComboBox;
    lblChangeColor: TLabel;
    procedure CheckAll1Click(Sender: TObject);
    procedure CheckNone1Click(Sender: TObject);
    procedure CmbOverruleColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FTagsToShow: TTagsToShow;
    FCheckMask: string;
  public
    { Public declarations }
    AllTracks: TStringList;
    procedure LoadTracks(DisplayColor: string; TagsToShow: TTagsToShow; CheckMask: string);
    function TrackSelectedColor(const TrackName: string): string;
  end;

//var FrmSelectGPX: TFrmSelectGPX;

implementation

{$R *.dfm}

uses
  System.Masks,
  UnitStringUtils;

const
  TypeColumn = 1;
  ColorColumn = 1;

procedure TFrmSelectGPX.LoadTracks(DisplayColor: string; TagsToShow: TTagsToShow; CheckMask: string);
var
  Indx: integer;
  Name, Color, Points, FromRoute: string;
  LVItem: TListItem;
begin
  FCheckMask := CheckMask;
  FTagsToShow := TagsToShow;
  case FTagsToShow of
    TTagsToShow.WptRte:
      begin
        PnlColor.Visible := false;
        LvTracks.Columns[TypeColumn].Caption := 'Wpt/Rte';
      end;
    TTagsToShow.RteTrk:
      begin
        PnlColor.Visible := true;
        LvTracks.Columns[TypeColumn].Caption := 'Rte/Trk';
      end;
  end;

  LvTracks.Items.Clear;
  for Indx := 0 to AllTracks.Count - 1 do
  begin
    FromRoute := AllTracks[Indx];
    Color := NextField(FromRoute, Chr(9));
    Points := NextField(FromRoute, Chr(9));
    Name := NextField(FromRoute, Chr(9));
    LVItem := LvTracks.Items.Add;
    LVItem.Caption := Name;
    LVItem.Checked := MatchesMask(Name, CheckMask);
    LVItem.SubItems.Add(FromRoute);
    if (DisplayColor = '') then
      LVItem.SubItems.Add(Color)
    else
      LVItem.SubItems.Add(DisplayColor);
    LVItem.SubItems.Add(Points);
  end;
  if (DisplayColor = '') then
    CmbOverruleColor.ItemIndex := 0
  else
    CmbOverruleColor.Text := DisplayColor;
end;

procedure TFrmSelectGPX.CheckAll1Click(Sender: TObject);
var LVItem: TListItem;
begin
  for LVItem in LvTracks.Items do
    LVItem.Checked := true;
end;

procedure TFrmSelectGPX.CheckNone1Click(Sender: TObject);
var LVItem: TListItem;
begin
  for LVItem in LvTracks.Items do
    LVItem.Checked := false;
end;

procedure TFrmSelectGPX.CmbOverruleColorClick(Sender: TObject);
var
  AnItem: TlistItem;
begin
  if (CmbOverruleColor.ItemIndex = 0) then
    LoadTracks('', FTagsToShow, FCheckMask)
  else
  begin
    for AnItem in LvTracks.Items do
    begin
      if (AnItem.Checked) then
        AnItem.SubItems[ColorColumn] := CmbOverruleColor.Text;
    end;
  end;
end;

procedure TFrmSelectGPX.FormCreate(Sender: TObject);
begin
  AllTracks := TStringList.Create;
end;

procedure TFrmSelectGPX.FormDestroy(Sender: TObject);
begin
  AllTracks.Free;
end;

procedure TFrmSelectGPX.FormShow(Sender: TObject);
begin
  if (LvTracks.Items.Count > 0) then
    LvTracks.Items[0].Selected := true;
end;

function TFrmSelectGPX.TrackSelectedColor(const TrackName: string): string;
var LVItem: TListItem;
begin
  result := '';
  for LVItem in LvTracks.Items do
  begin
    if (LVItem.Caption = TrackName) and
       (LVItem.Checked) then
      exit(LVItem.SubItems[ColorColumn]);
  end;
end;

end.
