unit UFrmSendTo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList, Vcl.ImgList,
  UnitGpxDefs;

type
  TSendToDest = (stDevice, stWindows);
  TFrmSendTo = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BtnOk: TBitBtn;
    TvSelections: TTreeview;
    LblDestinations: TLabel;
    StatusBar1: TStatusBar;
    GrpModel: TGroupBox;
    LblModel: TLabel;
    GrpDestination: TGroupBox;
    GrpTasks: TGroupBox;
    GrpSelDestination: TGroupBox;
    PCTDestination: TPageControl;
    TabDevice: TTabSheet;
    MemoTransfer: TMemo;
    TabFolder: TTabSheet;
    MemoAdditional: TMemo;
    MemoTasks: TMemo;
    BtnHelp: TBitBtn;
    PnlModel: TPanel;
    CmbTripOption: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PCTDestinationChange(Sender: TObject);
    procedure TvSelectionsCheckStateChanging(Sender: TCustomTreeView; Node: TTreeNode; NewCheckState, OldCheckState: TNodeCheckState;
      var AllowChange: Boolean);
    procedure PCTDestinationChanging(Sender: TObject; var AllowChange: Boolean);
    procedure TvSelectionsHint(Sender: TObject; const Node: TTreeNode; var Hint: string);
    procedure TvSelectionsCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TvSelectionsCheckStateChanged(Sender: TCustomTreeView; Node: TTreeNode; CheckState: TNodeCheckState);
    procedure BtnHelpClick(Sender: TObject);
  private
    GrpDestHeight: integer;
    GrpSelDestHeight: integer;
    FrmHeight: integer;
    ShowHelp: boolean;
    procedure EnableItems;
    procedure UpdateDesign;
    procedure SetPrefs;
    procedure StorePrefs;
    { Private declarations }
  public
    { Public declarations }
    Funcs: TGPXFuncArray;
    SendToDest: TSendToDest;
    CurrentDevice: TObject;
  end;

var
  FrmSendTo: TFrmSendTo;

implementation

uses
  System.TypInfo, System.Math,
  UnitStringUtils, UnitMTPDefs,
  UnitRegistry, UnitRegistryKeys, UnitTripDefs, UnitModelConv;

{$R *.dfm}

const
  SelectionHelp: array[IdTrip..IdFit] of string = (
    'Send .trip files. Immediately available in Trip planner. No import required, recalculation depends on Trip option.',
    'Send tracks created from selected GPX file. Convert to trip, or show on map, on the device.',
    'Send complete unmodified GPX file. No recalculation forced.',
    'Send routes containing only Via and Shaping points. Recalculation forced.',
    'Send .gpx file containing Way points.',
    'Sent .gpx file will contain Way points from selected GPX file.',
    'Sent .gpx file will contain Via points from selected GPX file.',
    'Sent .gpx file will contain Shaping points from selected GPX file.',
    'Send .gpi file containing Points Of Interest (POI).',
    'Sent .gpi file will contain Way points from selected GPX file.',
    'Sent .gpi file will contain Via points from selected GPX file.',
    'Sent .gpi file will contain Shaping points from selected GPX file.',
    'Send a KML file. To display in Google Earth, or other compatible application.',
    'Send a HTML file. To display in a browser.',
    'Send a Fit file. For Edge models');

  TripOptions: string =
    'Recalculation forced'
     + #10 + 'No recalculation forced (BaseCamp calculated GPX only)'
     + #10 + 'Preserve track to route (BaseCamp calculated GPX only)';

procedure TFrmSendTo.EnableItems;
begin
  TvSelections.Items[IdTrip].Enabled := GetRegistry(Reg_EnableTripFuncs, false);
  TvSelections.Items[IdTrack].Enabled := GetRegistry(Reg_EnableGpxFuncs, false);
  TvSelections.Items[IdCompleteRoute].Enabled := GetRegistry(Reg_EnableGpxFuncs, false);
  TvSelections.Items[IdStrippedRoute].Enabled := GetRegistry(Reg_EnableGpxFuncs, false);
  TvSelections.Items[IdWayPoint].Enabled := GetRegistry(Reg_EnableGpxFuncs, false) and (GetRegistry(Reg_EnableFitFuncs, false) = false);
  TvSelections.Items[IdWayPointWpt].Enabled := GetRegistry(Reg_EnableGpxFuncs, false) and (GetRegistry(Reg_EnableFitFuncs, false) = false);
  TvSelections.Items[IdWayPointVia].Enabled := GetRegistry(Reg_EnableGpxFuncs, false) and (GetRegistry(Reg_EnableFitFuncs, false) = false);
  TvSelections.Items[IdWayPointShp].Enabled := GetRegistry(Reg_EnableGpxFuncs, false) and (GetRegistry(Reg_EnableFitFuncs, false) = false);
  TvSelections.Items[IdGpi].Enabled := (GetRegistry(Reg_ValidGpiSymbols, false) = true) and
                                       (GetRegistry(Reg_EnableGpiFuncs, false) = true) and
                                       (GetRegistry(Reg_EnableFitFuncs, false) = false);
  TvSelections.Items[IdGpiWayPt].Enabled := GetRegistry(Reg_EnableGpiFuncs, false) and (GetRegistry(Reg_EnableFitFuncs, false) = false);
  TvSelections.Items[IdGpiViaPt].Enabled := GetRegistry(Reg_EnableGpiFuncs, false) and (GetRegistry(Reg_EnableFitFuncs, false) = false);
  TvSelections.Items[IdGpiShpPt].Enabled := GetRegistry(Reg_EnableGpiFuncs, false) and (GetRegistry(Reg_EnableFitFuncs, false) = false);
  TvSelections.Items[IdFit].Enabled := GetRegistry(Reg_EnableFitFuncs, false);

  case PCTDestination.ActivePageIndex of
    0:begin
        TvSelections.Items[IdCompleteRoute].Enabled := GetRegistry(Reg_EnableGpxFuncs, false);
        TvSelections.Items[IdKml].Enabled := false;
        TvSelections.Items[IdHtml].Enabled := false;
      end;
    1:begin
        TvSelections.Items[IdKml].Enabled := true;
        TvSelections.Items[IdHtml].Enabled := true;
        TvSelections.Items[IdCompleteRoute].Enabled := false;
      end;
  end;
end;

procedure TFrmSendTo.UpdateDesign;
var
  SubKey: string;
  ModelIndex: integer;
{$IFDEF ALLTRIPTRACKS}
  RegModelValue: string;
{$ENDIF}
begin
  // Show/hide
  if (ShowHelp) then
    BtnHelp.Caption := '&Hide help'
  else
    BtnHelp.Caption := '&Show help';
  GrpTasks.Visible := ShowHelp;
  MemoTransfer.Visible := ShowHelp;
  MemoAdditional.Visible := ShowHelp;
  GrpModel.Visible := TvSelections.Items[IdTrip].Checked;

  // Update texts
  LblModel.Caption := TModelConv.GetTripModel(TModelConv.Display2Trip(GetRegistry(Reg_CurrentModel, 0)));
  CmbTripOption.Items.Text := TripOptions;
  CmbTripOption.ItemIndex := Min(CmbTripOption.Items.Count -1, Ord(GetRegistry(Reg_TripOption, Ord(TTripOption.ttCalc))));

  case PCTDestination.ActivePageIndex of
    0:begin
        SendToDest := TSendToDest.stDevice;
        ModelIndex := GetRegistry(Reg_CurrentModel, 0);
        SubKey := IntToStr(ModelIndex);
        LblDestinations.Caption :=
          Format('Device:%s %s%s',        [#9, TBase_Device(CurrentDevice).DisplayedDevice, #10#10]);
        if GetRegistry(Reg_EnableTripFuncs, false) then
          LblDestinations.Caption := LblDestinations.Caption +
            Format('.trip files:%s %s%s', [#9, GetRegistry(Reg_PrefDevTripsFolder_Key,
                    TModelConv.GetKnownPath(CurrentDevice, ModelIndex, 0), SubKey), #10])
        else if GetRegistry(Reg_EnableFitFuncs, false) then
          LblDestinations.Caption := LblDestinations.Caption +
            Format('.fit files:%s %s%s',  [#9, GetRegistry(Reg_PrefDevTripsFolder_Key,
                    TModelConv.GetKnownPath(CurrentDevice, ModelIndex, 1), SubKey), #10]);

        if GetRegistry(Reg_EnableGpxFuncs, false) then
          LblDestinations.Caption := LblDestinations.Caption +
            Format('.gpx files:%s %s%s',    [#9, GetRegistry(Reg_PrefDevGpxFolder_Key,
                      TModelConv.GetKnownPath(CurrentDevice, ModelIndex, 1), SubKey), #10]);

        if (GetRegistry(Reg_EnableGpiFuncs, false)) and
           (GetRegistry(Reg_EnableFitFuncs, false) = false) then
          LblDestinations.Caption := LblDestinations.Caption +
            Format('.gpi files:%s %s',    [#9,  GetRegistry(Reg_PrefDevPoiFolder_Key,
                    TModelConv.GetKnownPath(CurrentDevice, ModelIndex, 2), SubKey), #10]);
      end;
    1:begin
        SendToDest := TSendToDest.stWindows;

        LblDestinations.Caption :=
          Format('Sub folder(s) of: %s%s',  [GetRegistry(Reg_PrefFileSysFolder_Key, ''), #10#10]) +
          'The GPX file name, without extension, will be used for the sub folder name.';
      end;
  end;
  // Resize form
  GrpDestination.ClientHeight := GrpDestHeight + LblDestinations.Height;
  Height := FrmHeight + LblDestinations.Height;
  if (GrpModel.Visible = false) then
    Height := Height - GrpModel.Height;

  GrpSelDestination.ClientHeight := GrpSelDestHeight;
  if (ShowHelp = false) then
  begin
    GrpSelDestination.ClientHeight := GrpSelDestination.ClientHeight - MemoTransfer.Height;
    Height := Height - GrpTasks.Height - (GrpSelDestHeight - GrpSelDestination.ClientHeight);
  end;

  // Repaint Treeview. Needed for disabled items
  TvSelections.Repaint;
  BtnOk.SetFocus;
end;

procedure TFrmSendTo.SetPrefs;
begin
  EnableItems;
  TSetProcessOptions.SetPrefs(TvSelections);
end;

procedure TFrmSendTo.StorePrefs;
begin
  SetRegistry(Reg_TripOption, CmbTripOption.ItemIndex);

  Funcs := TSetProcessOptions.StorePrefs(TvSelections);
end;

procedure TFrmSendTo.TvSelectionsCheckStateChanging(Sender: TCustomTreeView; Node: TTreeNode; NewCheckState,
  OldCheckState: TNodeCheckState; var AllowChange: Boolean);
begin
  AllowChange := Node.Enabled;
end;

procedure TFrmSendTo.TvSelectionsCheckStateChanged(Sender: TCustomTreeView; Node: TTreeNode; CheckState: TNodeCheckState);
begin
  if (Node.AbsoluteIndex = IdTrip) then
  begin
    GrpModel.Visible := Node.Checked;
    UpdateDesign;
  end;
end;

procedure TFrmSendTo.TvSelectionsCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
begin
  AllowCollapse := false;
end;

// Dont want the standard hint. Display in statusbar
procedure TFrmSendTo.TvSelectionsHint(Sender: TObject; const Node: TTreeNode; var Hint: string);
begin
  StatusBar1.SimpleText := SelectionHelp[Node.AbsoluteIndex];
  Hint := '';
end;

procedure TFrmSendTo.BtnHelpClick(Sender: TObject);
begin
  ShowHelp := not ShowHelp;
  UpdateDesign;
end;

procedure TFrmSendTo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = ID_Ok then
    StorePrefs;
end;

procedure TFrmSendTo.FormCreate(Sender: TObject);
begin
  // Constant size of GroupBox
  GrpDestHeight := GrpDestination.Height;
  GrpSelDestHeight := GrpSelDestination.Height;
  // Design Height
  FrmHeight := Height;
  // Dont bother
  ShowHelp := false;
end;

procedure TFrmSendTo.FormShow(Sender: TObject);
begin
  TabDevice.Caption := 'No device connected';
  TabDevice.Font.Style := [];
  TabDevice.Enabled := Assigned(CurrentDevice);
  if (TabDevice.Enabled) then
  begin
    PCTDestination.ActivePage := TabDevice;
    TabDevice.Caption := 'Send to Device';
    TabDevice.Font.Style := [TFontStyle.fsBold];
  end
  else
    PCTDestination.ActivePage := TabFolder;
  PCTDestinationChange(PCTDestination);
end;

procedure TFrmSendTo.PCTDestinationChange(Sender: TObject);
begin
  SetPrefs;
  UpdateDesign;
end;

procedure TFrmSendTo.PCTDestinationChanging(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange := TabDevice.Enabled;
end;

end.
