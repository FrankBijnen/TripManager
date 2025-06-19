unit UFrmSendTo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList, Vcl.ImgList,
  UnitGpxObjects;

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
    MemoDestinations: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PCTDestinationChange(Sender: TObject);
    procedure TvSelectionsCheckStateChanging(Sender: TCustomTreeView; Node: TTreeNode; NewCheckState, OldCheckState: TNodeCheckState;
      var AllowChange: Boolean);
    procedure PCTDestinationChanging(Sender: TObject; var AllowChange: Boolean);
  private
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
  UnitRegistry, UnitStringUtils;

{$R *.dfm}

procedure TFrmSendTo.SetPrefs;
begin
  case PCTDestination.ActivePageIndex of
    0:begin
        SendToDest := TSendToDest.stDevice;
        TvSelections.Items[IdCompleteRoute].Enabled := true;
        TvSelections.Items[IdKml].Enabled := false;
        TvSelections.Items[IdHtml].Enabled := false;

        MemoDestinations.Text :=
          Format('Files will be sent to device: %s model: %s',
            [GetRegistry(Reg_CurrentDevice, ''), GetRegistry(Reg_ZumoModel, '')]) + #13 + #10 + #13 + #10 +
          Format('Trip files: %s', [GetRegistry(Reg_PrefDevTripsFolder_Key, Reg_PrefDevTripsFolder_Val)]) + #13 + #10 +
          Format('GPX files (Tracks & Routes & Way points): %s', [GetRegistry(Reg_PrefDevGpxFolder_Key, Reg_PrefDevGpxFolder_Val)]) + #13 + #10 +
          Format('GPI files (Points Of Interest): %s', [GetRegistry(Reg_PrefDevPoiFolder_Key, Reg_PrefDevPoiFolder_Val)]);
      end;
    1:begin
        SendToDest := TSendToDest.stWindows;
        TvSelections.Items[IdKml].Enabled := true;
        TvSelections.Items[IdHtml].Enabled := true;
        TvSelections.Items[IdCompleteRoute].Enabled := false;

        MemoDestinations.Text :=
          Format('All files will be created in a sub directory of: %s.',
            [GetRegistry(Reg_PrefFileSysFolder_Key, '')]) + #13 + #10 +
          'The created sub directory will be named as the selected GPX file.';
      end;
  end;
  TvSelections.Repaint;
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

procedure TFrmSendTo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = ID_Ok then
    StorePrefs;
end;

procedure TFrmSendTo.FormShow(Sender: TObject);
begin
  TabDevice.Caption := 'No device connected';
  TabDevice.Font.Style := [];
  TabFolder.Caption := 'Send to folder' + #10 + GetRegistry(Reg_PrefFileSysFolder_Key, '');
  TabDevice.Enabled := HasCurrentDevice;
  if (TabDevice.Enabled) then
  begin
    PCTDestination.ActivePage := TabDevice;
    TabDevice.Caption := 'Send to Device' + #10 + GetRegistry(Reg_CurrentDevice, '');
    TabDevice.Font.Style := [TFontStyle.fsBold];
  end
  else
    PCTDestination.ActivePage := TabFolder;
  SetPrefs;
end;

procedure TFrmSendTo.PCTDestinationChange(Sender: TObject);
begin
  SetPrefs;
end;

procedure TFrmSendTo.PCTDestinationChanging(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange := TabDevice.Enabled;
end;

end.
