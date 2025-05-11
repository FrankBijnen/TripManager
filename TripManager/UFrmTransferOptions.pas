unit UFrmTransferOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList, Vcl.ImgList,
  UnitGpx;

type
  TFrmTransferOptions = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BitBtn2: TBitBtn;
    MemoTransfer: TMemo;
    LvSelections: TListView;
    MemoDestinations: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure SetPrefs;
    procedure StorePrefs;
    { Private declarations }
  public
    { Public declarations }
    Funcs: array of TGPXFunc;
    CompleteRoute: boolean;
  end;

var
  FrmTransferOptions: TFrmTransferOptions;

implementation

uses
  UnitStringUtils, UFrmAdvSettings, UFrmTripManager;

{$R *.dfm}

const
  IdTrip            = 0;
  IdTrack           = 1;
  IdStrippedRoute   = 2;
  IdCompleteRoute   = 3;
  IdPOI             = 4;
  TripFilesFor      = 'Trip files (No import required, but will recalculate. Selected model: %s)';
  GPISel            = 'POI (.gpi) files (Points Of Interest). Selection:%s';

procedure TFrmTransferOptions.SetPrefs;
var
  PtsInGpi: string;
begin
  LvSelections.Items[IdTrip].Caption := Format(TripFilesFor, [FrmTripManager.CmbModel.Text]);
  LvSelections.Items[IdTrip].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrip', BooleanValues[true]) = BooleanValues[true]);
  LvSelections.Items[IdTrack].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrack', BooleanValues[true]) = BooleanValues[true]);
  LvSelections.Items[IdStrippedRoute].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferStrippedRoute', BooleanValues[false]) = BooleanValues[true]);
  LvSelections.Items[IdCompleteRoute].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferRoute', BooleanValues[false]) = BooleanValues[true]);
  LvSelections.Items[IdPOI].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferGPI', BooleanValues[false]) = BooleanValues[true]);

  PtsInGpi := '';
  ProcessWayPtsInGpi :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiWayPt', BooleanValues[true]) = BooleanValues[true]);
  if ProcessWayPtsInGpi then
    PtsInGpi := PtsInGpi + ' WayPoints,';
  ProcessViaPtsInGpi :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiViaPt', BooleanValues[false]) = BooleanValues[true]);
  if ProcessViaPtsInGpi then
    PtsInGpi := PtsInGpi + ' Via Points,';
  ProcessShapePtsInGpi :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiShpPt', BooleanValues[false]) = BooleanValues[true]);
  if ProcessShapePtsInGpi then
    PtsInGpi := PtsInGpi + ' Shaping Points,';
  if (PtsInGpi <> '') then
    SetLength(PtsInGpi, Length(PtsInGpi) -1)
  else
    PtsInGpi := ' None';

  LvSelections.Items[IdPOI].Caption := Format(GPISel, [PtsInGpi]);

  MemoDestinations.Text :=
    'Files will be transferred to:' + #13 + #10 + #13 + #10 +
     'Trip files: ' + FrmTripManager.DeviceFolder[0] + #13 + #10 +
     'GPX files (Tracks & Routes): ' + FrmTripManager.DeviceFolder[1] + #13 + #10 +
     'GPI files (Points Of Interest): ' + FrmTripManager.DeviceFolder[2];
end;

procedure TFrmTransferOptions.StorePrefs;
begin
  if (LvSelections.Items[IdStrippedRoute].Checked) and
     (LvSelections.Items[IdCompleteRoute].Checked) then
    raise exception.Create('Only one route option can be selected!');

  SetLength(Funcs, 0);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrip', BooleanValues[LvSelections.Items[IdTrip].Checked]);
  if (LvSelections.Items[IdTrip].Checked) then
  begin
    Funcs := Funcs + [TGPXFunc.CreateTrips];
    FrmTripManager.CheckSupportedModel;
  end;

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrack', BooleanValues[LvSelections.Items[IdTrack].Checked]);
  if (LvSelections.Items[IdTrack].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateTracks];

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferStrippedRoute', BooleanValues[LvSelections.Items[IdStrippedRoute].Checked]);
  if (LvSelections.Items[IdStrippedRoute].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateRoutes];

  CompleteRoute := LvSelections.Items[IdCompleteRoute].Checked;
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferRoute', BooleanValues[CompleteRoute]);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferGPI', BooleanValues[LvSelections.Items[IdPOI].Checked]);
  if (LvSelections.Items[IdPOI].Checked) then
    Funcs := Funcs + [TGPXFunc.CreatePOI];

end;

procedure TFrmTransferOptions.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = ID_Ok then
    StorePrefs;
end;

procedure TFrmTransferOptions.FormShow(Sender: TObject);
begin
  FrmAdvSettings.SetFixedPrefs;
  SetPrefs;
end;

end.

