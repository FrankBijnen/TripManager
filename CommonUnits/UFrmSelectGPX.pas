unit UFrmSelectGPX;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Buttons, Vcl.Menus,
  UnitGpxDefs, Vcl.Samples.Spin;

type
  TOnGetPreviewInfo = function(GPXFileObj: TObject; UpdateDb: boolean): integer of object;

  TFrmSelectGPX = class(TForm)
    LvTracks: TListView;
    PnlTop: TPanel;
    PnlBot: TPanel;
    BitBtnOK: TBitBtn;
    BitBtnCan: TBitBtn;
    PopupMenu: TPopupMenu;
    CheckAll1: TMenuItem;
    CheckNone1: TMenuItem;
    PnlColor: TPanel;
    CmbOverruleColor: TComboBox;
    lblChangeColor: TLabel;
    PnlPreview: TPanel;
    LblPreview: TLabel;
    SpinPercent: TSpinEdit;
    LblPercent: TLabel;
    PercTimer: TTimer;
    procedure CheckAll1Click(Sender: TObject);
    procedure CheckNone1Click(Sender: TObject);
    procedure CmbOverruleColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LvTracksClick(Sender: TObject);
    procedure SpinPercentChange(Sender: TObject);
    procedure PercTimerTimer(Sender: TObject);
    procedure SpinPercentKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    FOnGetPreviewInfo: TOnGetPreviewInfo;
    FGPXObject: TObject;
    FTagsToShow: TTagsToShow;
    FCheckMask: string;
  public
    { Public declarations }
    AllTracks: TStringList;
    procedure LoadTracks(const TagsToShow: TTagsToShow;
                         const DisplayColor, CheckMask: string;
                         const AGPXObject: TObject;
                         const AGetPreviewInfo: TOnGetPreviewInfo);
    function TrackSelectedColor(const TrackName, RteTrk: string): string;
    function CheckedCount: integer;
  end;

//var FrmSelectGPX: TFrmSelectGPX;

implementation

{$R *.dfm}

uses
  System.Masks,
  UnitGpxObjects, UnitProcessOptions, UnitStringUtils;

const
  TypeColumn = 1;
  TypeSubItem = 0;
  ColorSubItem = 1;

procedure TFrmSelectGPX.LoadTracks(const TagsToShow: TTagsToShow;
                                   const DisplayColor, CheckMask: string;
                                   const AGPXObject: TObject;
                                   const AGetPreviewInfo: TOnGetPreviewInfo);

var
  Indx: integer;
  CanCheck: boolean;
  Name, Color, Points, FromRoute: string;
  LVItem: TListItem;
begin
  FCheckMask := CheckMask;
  FTagsToShow := TagsToShow;
  FGPXObject := AGPXObject;
  FOnGetPreviewInfo := AGetPreviewInfo;

  PnlColor.Visible := false;
  PnlPreview.Visible := false;
  case FTagsToShow of
    TTagsToShow.WptRte:       // TripEditor. Import from GPX
      begin
        LvTracks.Columns[TypeColumn].Caption := 'Wpt/Rte';
      end;
    TTagsToShow.WptTrk:       // Future use
      begin
        PnlColor.Visible := true;
        LvTracks.Columns[TypeColumn].Caption := 'Wpt/Trk';
      end;
    TTagsToShow.WptRteTrk:    // TripEditor. Trk2Rt + Import from GPX
      begin
        PnlPreview.Visible := Assigned(FOnGetPreviewInfo);
        LvTracks.Columns[TypeColumn].Caption := 'Wpt/Rte/Trk';
      end;
    TTagsToShow.RteTrk:      // FrmTripManager. Track Compare
      begin
        PnlColor.Visible := true;
        LvTracks.Columns[TypeColumn].Caption := 'Rte/Trk';
      end;
    TTagsToShow.Rte:         // FrmTripManager. BC Compare
      begin
        PnlColor.Visible := true;
        LvTracks.Columns[TypeColumn].Caption := 'Rte';
      end;
    TTagsToShow.Trk:         // Future use
      begin
        PnlColor.Visible := true;
        LvTracks.Columns[TypeColumn].Caption := 'Trk';
      end;
  end;

  CanCheck := true;
  LvTracks.Items.Clear;
  for Indx := 0 to AllTracks.Count - 1 do
  begin
    FromRoute := AllTracks[Indx];
    Color := NextField(FromRoute, Chr(9));
    Points := NextField(FromRoute, Chr(9));
    Name := NextField(FromRoute, Chr(9));
    LVItem := LvTracks.Items.Add;
    LVItem.Caption := Name;
    if (CanCheck) then
    begin
      LVItem.Checked := (AllTracks.Count = 1) or
                         MatchesMask(Name, CheckMask);
      if (LVItem.Checked) then
        CanCheck := SameText(CheckMask, '*');
    end;
    LVItem.SubItems.Add(FromRoute);
    if (DisplayColor = '') then
      LVItem.SubItems.Add(Color)
    else
      LVItem.SubItems.Add(DisplayColor);
    LVItem.SubItems.Add(Points);
  end;

  // Init Color
  if (DisplayColor = '') then
    CmbOverruleColor.ItemIndex := 0
  else
    CmbOverruleColor.Text := DisplayColor;

  // Init Percentage
  if (PnlPreview.Visible) then
  begin
    SpinPercent.Value := TProcessOptions.GetTrk2RtExportPerc;
    SpinPercentChange(SpinPercent);
  end;
end;

procedure TFrmSelectGPX.LvTracksClick(Sender: TObject);
begin
  SpinPercentChange(SpinPercent);
end;

procedure TFrmSelectGPX.PercTimerTimer(Sender: TObject);
begin
  PercTimer.Enabled := false;
  if (Assigned(FOnGetPreviewInfo)) and
     (Assigned(FGPXObject)) then
  begin
    TProcessOptions.SetTrk2RtExportPerc(SpinPercent.Value);
{$IFDEF DEBUG}
    LblPreview.Caption := Format('%s; #Route points: %d', [TProcessOptions.Trk2RtOptions, FOnGetPreviewInfo(FGPXObject, false)]);
{$ELSE}
    LblPreview.Caption := Format(' #Route points: %d', [FOnGetPreviewInfo(FGPXObject, false)]);
{$ENDIF}
  end;
end;

procedure TFrmSelectGPX.SpinPercentChange(Sender: TObject);
begin
  PercTimer.Enabled := false;
  PercTimer.Enabled := true;
end;

procedure TFrmSelectGPX.SpinPercentKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_NEXT) then
    with TSpinEdit(Sender) do
      Value := Value - Increment * 10;
  if (Key = VK_PRIOR) then
    with TSpinEdit(Sender) do
      Value := Value + Increment * 10;
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
    LoadTracks(FTagsToShow, '', FCheckMask, FGPXObject, FOnGetPreviewInfo)
  else
  begin
    for AnItem in LvTracks.Items do
    begin
      if (AnItem.Checked) then
        AnItem.SubItems[ColorSubItem] := CmbOverruleColor.Text;
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

function TFrmSelectGPX.TrackSelectedColor(const TrackName, RteTrk: string): string;
var
  LVItem: TListItem;
begin
  result := '';
  for LVItem in LvTracks.Items do
  begin
    if (SameText(LVItem.Caption, TrackName)) and
       (SameText(LVItem.SubItems[TypeSubItem], RteTrk)) and
       (LVItem.Checked) then
      exit(LVItem.SubItems[ColorSubItem]);
  end;
end;

function TFrmSelectGPX.CheckedCount: integer;
var
  LVItem: TListItem;
begin
  result := 0;
  for LVItem in LvTracks.Items do
  begin
    if (LVItem.Checked) then
      inc(result);
  end;
end;

end.
