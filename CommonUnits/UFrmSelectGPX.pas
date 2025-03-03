unit UFrmSelectGPX;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus;

type
  TFrmSelectGPX = class(TForm)
    LvTracks: TListView;
    PnlTop: TPanel;
    PnlBot: TPanel;
    BitBtnOK: TBitBtn;
    BitBtnCan: TBitBtn;
    PopupMenu1: TPopupMenu;
    CheckAll1: TMenuItem;
    CheckNone1: TMenuItem;
    PnlClear: TPanel;
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
  public
    { Public declarations }
    AllTracks: TStringList;
    procedure LoadTracks(DisplayColor: string);
    function TrackSelectedColor(const TrackName: string): string;
  end;

var FrmSelectGPX: TFrmSelectGPX;

implementation

uses UnitStringUtils;

{$R *.dfm}

procedure TFrmSelectGPX.LoadTracks(DisplayColor: string);
var Indx: integer;
    Name, Color, Points: string;
    LVItem: TListItem;
begin
  LvTracks.Items.Clear;
  for Indx := 0 to AllTracks.Count - 1 do
  begin
    Name := AllTracks[Indx];
    Color := NextField(Name, Chr(9));
    Points := NextField(Name, Chr(9));
    LVItem := LvTracks.Items.Add;
    LVItem.Caption := Name;
    LVItem.Checked := true;
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
    LoadTracks('')
  else
  begin
    for AnItem in LvTracks.Items do
    begin
      if (AnItem.Checked) then
        AnItem.SubItems[0] := CmbOverruleColor.Text;
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
      exit(LVItem.SubItems[0]);
  end;
end;

end.
