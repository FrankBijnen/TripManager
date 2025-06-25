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
    MemoTransfer: TMemo;
    TvSelections: TTreeview;
    PnlTop: TPanel;
    PCTDestination: TPageControl;
    TabDevice: TTabSheet;
    TabFolder: TTabSheet;
    MemoAdditional: TMemo;
    LblDestinations: TLabel;
    StatusBar1: TStatusBar;
    GrpModel: TGroupBox;
    LblModel: TLabel;
    GrpDestination: TGroupBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PCTDestinationChange(Sender: TObject);
    procedure TvSelectionsCheckStateChanging(Sender: TCustomTreeView; Node: TTreeNode; NewCheckState, OldCheckState: TNodeCheckState;
      var AllowChange: Boolean);
    procedure PCTDestinationChanging(Sender: TObject; var AllowChange: Boolean);
    procedure TvSelectionsHint(Sender: TObject; const Node: TTreeNode; var Hint: string);
    procedure TvSelectionsCollapsing(Sender: TObject; Node: TTreeNode; var AllowCollapse: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    GrpDestHeight: integer;
    FrmHeight: integer;
    procedure UpdateDesign;
    procedure SetPrefs;
    procedure StorePrefs;
    { Private declarations }
  public
    { Public declarations }
    Funcs: TGPXFuncArray;
    SendToDest: TSendToDest;
    HasCurrentDevice: boolean;
  end;

var
  FrmSendTo: TFrmSendTo;

implementation

uses
  UnitProcessOptions, UnitRegistry, UnitStringUtils;

{$R *.dfm}

const
  SelectionHelp: array[IdTrip..IdHtml] of string = (
    'Send .trip files. Immediately available in Trip planner. No import required, but will recalculate.',
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
    'Send a HTML file. To display in a browser.');

procedure TFrmSendTo.UpdateDesign;
begin
  LblModel.Caption := GetRegistry(Reg_ZumoModel, '');
  case PCTDestination.ActivePageIndex of
    0:begin
        SendToDest := TSendToDest.stDevice;
        TvSelections.Items[IdCompleteRoute].Enabled := true;
        TvSelections.Items[IdKml].Enabled := false;
        TvSelections.Items[IdHtml].Enabled := false;

        LblDestinations.Caption :=
          Format('.trip files:%s %s%s', [#9, GetRegistry(Reg_PrefDevTripsFolder_Key, Reg_PrefDevTripsFolder_Val), #10]) +
          Format('.gpx files:%s %s%s',  [#9, GetRegistry(Reg_PrefDevGpxFolder_Key, Reg_PrefDevGpxFolder_Val), #10]) +
          Format('.gpi files:%s %s',    [#9, GetRegistry(Reg_PrefDevPoiFolder_Key, Reg_PrefDevPoiFolder_Val)]);
      end;
    1:begin
        SendToDest := TSendToDest.stWindows;
        TvSelections.Items[IdKml].Enabled := true;
        TvSelections.Items[IdHtml].Enabled := true;
        TvSelections.Items[IdCompleteRoute].Enabled := false;

        LblDestinations.Caption :=
          Format('%s%s', [GetRegistry(Reg_PrefFileSysFolder_Key, ''), #10#10]) +
          'The GPX file name, without extension, will be used for the sub directory name.';
      end;
  end;
  GrpDestination.ClientHeight := GrpDestHeight + LblDestinations.Height;
  Height := FrmHeight + LblDestinations.Height;
  TvSelections.Repaint;
end;

procedure TFrmSendTo.SetPrefs;
begin
  TProcessOptions.SetPrefs(TvSelections);
end;

procedure TFrmSendTo.StorePrefs;
begin
  Funcs := TProcessOptions.StorePrefs(TvSelections);
end;

procedure TFrmSendTo.TvSelectionsCheckStateChanging(Sender: TCustomTreeView; Node: TTreeNode; NewCheckState,
  OldCheckState: TNodeCheckState; var AllowChange: Boolean);
begin
  AllowChange := Node.Enabled;
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

procedure TFrmSendTo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = ID_Ok then
    StorePrefs;
end;

procedure TFrmSendTo.FormCreate(Sender: TObject);
begin
  // Constant size of GroupBox
  GrpDestHeight := GrpDestination.Height;
  // Design Height
  FrmHeight := Height;
end;

procedure TFrmSendTo.FormShow(Sender: TObject);
begin
  TabDevice.Caption := 'No device connected';
  TabDevice.Font.Style := [];
  TabFolder.Caption :=  Format('Send to folder%s%s',
                               [#10, GetRegistry(Reg_PrefFileSysFolder_Key, '')]);

  TabDevice.Enabled := HasCurrentDevice;
  if (TabDevice.Enabled) then
  begin
    PCTDestination.ActivePage := TabDevice;
    TabDevice.Caption :=  Format('Send to Device%s%s',
                                 [#10, GetRegistry(Reg_CurrentDevice, '')]);
    TabDevice.Font.Style := [TFontStyle.fsBold];
  end
  else
    PCTDestination.ActivePage := TabFolder;
  UpdateDesign;
  SetPrefs;
end;

procedure TFrmSendTo.PCTDestinationChange(Sender: TObject);
begin
  UpdateDesign;
  SetPrefs;
end;

procedure TFrmSendTo.PCTDestinationChanging(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange := TabDevice.Enabled;
end;

end.
