unit UFrmTransferOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList, Vcl.ImgList,
  UnitGpxDefs;

type
  TFrmTransferOptions = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BitBtn2: TBitBtn;
    MemoTransfer: TMemo;
    MemoDestinations: TMemo;
    TvSelections: TTreeview;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TvSelectionsCheckStateChanging(Sender: TCustomTreeView; Node: TTreeNode; NewCheckState, OldCheckState: TNodeCheckState;
      var AllowChange: Boolean);
  private
    procedure SetPrefs;
    procedure StorePrefs;
    { Private declarations }
  public
    { Public declarations }
    Funcs: TGPXFuncArray;
  end;

var
  FrmTransferOptions: TFrmTransferOptions;

implementation

uses
  UnitProcessOptions, UnitStringUtils, UnitRegistry, UnitRegistryKeys, UnitTripObjects, UFrmAdvSettings, UFrmTripManager;

{$R *.dfm}

procedure TFrmTransferOptions.SetPrefs;
begin
  TvSelections.Items[IdTrip].Text := Format(TripFilesFor, [GetRegistry(Reg_ZumoModel, XT_Name)]);
  TvSelections.Items[IdKml].Enabled := false;
  TvSelections.Items[IdHtml].Enabled := false;
  TProcessOptions.SetPrefs(TvSelections);

  MemoDestinations.Text :=
    'Files will be transferred to:' + #13 + #10 + #13 + #10 +
    'Trip files: ' + FrmTripManager.DeviceFolder[0] + #13 + #10 +
    'GPX files (Tracks & Routes & Way points): ' + FrmTripManager.DeviceFolder[1] + #13 + #10 +
    'GPI files (Points Of Interest): ' + FrmTripManager.DeviceFolder[2];
end;

procedure TFrmTransferOptions.StorePrefs;
begin
  Funcs := TProcessOptions.StorePrefs(TvSelections);
end;

procedure TFrmTransferOptions.TvSelectionsCheckStateChanging(Sender: TCustomTreeView; Node: TTreeNode; NewCheckState,
  OldCheckState: TNodeCheckState; var AllowChange: Boolean);
begin
  AllowChange := Node.Enabled;
end;

procedure TFrmTransferOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = ID_Ok then
    StorePrefs;
end;

procedure TFrmTransferOptions.FormShow(Sender: TObject);
begin
  SetPrefs;
end;

end.
