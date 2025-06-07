unit UFrmTransferOptions;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList, Vcl.ImgList,
  UnitGpxObjects;

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
  private
    procedure SetPrefs;
    procedure StorePrefs;
    { Private declarations }
  public
    { Public declarations }
    Funcs: array of TGPXFunc;
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

  IdWayPoint        = 4;
    IdWayPointWpt   = 5;
    IdWayPointVia   = 6;
    IdWayPointShp   = 7;

  IdGPI             = 8;
    IdGpiWayPt      = 9;
    IdGpiViaPt      = 10;
    IdGpiShpPt      = 11;

  TripFilesFor      = 'Trip files (No import required, but will recalculate. Selected model: %s)';

procedure TFrmTransferOptions.SetPrefs;
begin
  TvSelections.Items[IdTrip].Text := Format(TripFilesFor, [FrmTripManager.CmbModel.Text]);
  TvSelections.Items[IdTrip].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrip', BooleanValues[true])), BooleanValues[true]);
  TvSelections.Items[IdTrack].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrack', BooleanValues[true])), BooleanValues[true]);
  TvSelections.Items[IdStrippedRoute].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferStrippedRoute', BooleanValues[false])), BooleanValues[true]);
  TvSelections.Items[IdCompleteRoute].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferRoute', BooleanValues[false])), BooleanValues[true]);

  TvSelections.Items[IdWayPoint].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferWayPoint', BooleanValues[false])), BooleanValues[true]);
    TvSelections.Items[IdWayPointWpt].Checked := SameText
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncWayPointWpt', BooleanValues[true]), BooleanValues[true]);
    TvSelections.Items[IdWayPointVia].Checked := SameText
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncWayPointVia', BooleanValues[false]), BooleanValues[true]);
    TvSelections.Items[IdWayPointShp].Checked := SameText
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncWayPointShape', BooleanValues[false]), BooleanValues[true]);

  TvSelections.Items[IdGPI].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferGPI', BooleanValues[false])), BooleanValues[true]);

    TvSelections.Items[IdGpiWayPt].Checked := SameText
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiWayPt', BooleanValues[true]), BooleanValues[true]);
    TvSelections.Items[IdGpiViaPt].Checked := SameText
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiViaPt', BooleanValues[false]), BooleanValues[true]);
    TvSelections.Items[IdGpiShpPt].Checked := SameText
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiShpPt', BooleanValues[false]), BooleanValues[true]);

  MemoDestinations.Text :=
    'Files will be transferred to:' + #13 + #10 + #13 + #10 +
    'Trip files: ' + FrmTripManager.DeviceFolder[0] + #13 + #10 +
    'GPX files (Tracks & Routes & Way points): ' + FrmTripManager.DeviceFolder[1] + #13 + #10 +
    'GPI files (Points Of Interest): ' + FrmTripManager.DeviceFolder[2];

  TvSelections.FullExpand;

end;

procedure TFrmTransferOptions.StorePrefs;
begin
  if (TvSelections.Items[IdStrippedRoute].Checked) and
     (TvSelections.Items[IdCompleteRoute].Checked) then
    raise exception.Create('Only one route option can be selected!');

  SetLength(Funcs, 0);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrip', BooleanValues[TvSelections.Items[IdTrip].Checked]);
  if (TvSelections.Items[IdTrip].Checked) then
  begin
    Funcs := Funcs + [TGPXFunc.CreateTrips];
    FrmTripManager.CheckSupportedModel;
  end;

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrack', BooleanValues[TvSelections.Items[IdTrack].Checked]);
  if (TvSelections.Items[IdTrack].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateTracks];

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferWayPoint', BooleanValues[TvSelections.Items[IdWayPoint].Checked]);
  if (TvSelections.Items[IdWayPoint].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateWayPoints];

    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncWayPointWpt', BooleanValues[TvSelections.Items[IdWayPointWpt].Checked]);

    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncWayPointVia', BooleanValues[TvSelections.Items[IdWayPointVia].Checked]);

    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncWayPointShape', BooleanValues[TvSelections.Items[IdWayPointShp].Checked]);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferStrippedRoute', BooleanValues[TvSelections.Items[IdStrippedRoute].Checked]);
  if (TvSelections.Items[IdStrippedRoute].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateRoutes];

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferRoute', BooleanValues[TvSelections.Items[IdCompleteRoute].Checked]);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferGPI', BooleanValues[TvSelections.Items[IdGPI].Checked]);
  if (TvSelections.Items[IdGPI].Checked) then
    Funcs := Funcs + [TGPXFunc.CreatePOI];

    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiWayPt', BooleanValues[TvSelections.Items[IdGpiWayPt].Checked]);

    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiViaPt', BooleanValues[TvSelections.Items[IdGpiViaPt].Checked]);

    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiShpPt', BooleanValues[TvSelections.Items[IdGpiShpPt].Checked]);



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
