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
  IdWayPoint        = 2;
  IdStrippedRoute   = 3;
  IdCompleteRoute   = 4;
  IdPOI             = 5;
  TripFilesFor      = 'Trip files (No import required, but will recalculate. Selected model: %s)';
  GPISel            = 'POI (.gpi) files (Points Of Interest). (Selection: %s)';
  WayPointSel       = 'Way points. (Selection: %s)';

procedure TFrmTransferOptions.SetPrefs;
var
  PtsInGpi, AddRoutePoints: string;
begin
  LvSelections.Items[IdTrip].Caption := Format(TripFilesFor, [FrmTripManager.CmbModel.Text]);
  LvSelections.Items[IdTrip].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrip', BooleanValues[true])), BooleanValues[true]);
  LvSelections.Items[IdTrack].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferTrack', BooleanValues[true])), BooleanValues[true]);
  LvSelections.Items[IdWayPoint].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferWayPoint', BooleanValues[false])), BooleanValues[true]);

  AddRoutePoints := '';
  if SameText
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncWayPointWpt', BooleanValues[true]), BooleanValues[true]) then
    AddRoutePoints := AddRoutePoints + ' Original Way points,';
  if SameText
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncWayPointVia', BooleanValues[false]), BooleanValues[true]) then
    AddRoutePoints := AddRoutePoints + ' Via points,';
  if SameText
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncWayPointShape', BooleanValues[false]), BooleanValues[true]) then
    AddRoutePoints := AddRoutePoints + ' Shaping points,';
  if (AddRoutePoints <> '') then
    SetLength(AddRoutePoints, Length(AddRoutePoints) -1)
  else
    AddRoutePoints := ' None';
  LvSelections.Items[IdWayPoint].Caption := Format(WayPointSel, [AddRoutePoints]);

  LvSelections.Items[IdStrippedRoute].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferStrippedRoute', BooleanValues[false])), BooleanValues[true]);
  LvSelections.Items[IdCompleteRoute].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferRoute', BooleanValues[false])), BooleanValues[true]);
  LvSelections.Items[IdPOI].Checked := SameText(
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferGPI', BooleanValues[false])), BooleanValues[true]);

  PtsInGpi := '';
  if SameText
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiWayPt', BooleanValues[true]), BooleanValues[true]) then
    PtsInGpi := PtsInGpi + ' Original Way points,';
  if SameText
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiViaPt', BooleanValues[false]), BooleanValues[true]) then
    PtsInGpi := PtsInGpi + ' Via points,';
  if SameText
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiShpPt', BooleanValues[false]), BooleanValues[true]) then
    PtsInGpi := PtsInGpi + ' Shaping points,';
  if (PtsInGpi <> '') then
    SetLength(PtsInGpi, Length(PtsInGpi) -1)
  else
    PtsInGpi := ' None';
  LvSelections.Items[IdPOI].Caption := Format(GPISel, [PtsInGpi]);

  MemoDestinations.Text :=
    'Files will be transferred to:' + #13 + #10 + #13 + #10 +
    'Trip files: ' + FrmTripManager.DeviceFolder[0] + #13 + #10 +
    'GPX files (Tracks & Routes & Way points): ' + FrmTripManager.DeviceFolder[1] + #13 + #10 +
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

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferWayPoint', BooleanValues[LvSelections.Items[IdWayPoint].Checked]);
  if (LvSelections.Items[IdWayPoint].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateWayPoints];

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferStrippedRoute', BooleanValues[LvSelections.Items[IdStrippedRoute].Checked]);
  if (LvSelections.Items[IdStrippedRoute].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateRoutes];

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TransferRoute', BooleanValues[LvSelections.Items[IdCompleteRoute].Checked]);

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
  SetPrefs;
end;

end.

