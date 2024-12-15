unit UFrmAdditional;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList, Vcl.ImgList,
  UnitGpx;

type
  TFrmAdditional = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BitBtn2: TBitBtn;
    MemoPostProcess: TMemo;
    TvSelections: TTreeView;
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
  FrmAdditional: TFrmAdditional;

implementation

uses
  System.TypInfo, UnitStringUtils, UnitGpi, UFrmTripManager;

{$R *.dfm}

const
  IdTrack       = 0;
  IdRoute       = 1;
  IdRoutePoint  = 2;
  IdGpi         = 3;
  IdGpiWayPt    = 4;
  IdGpiViaPt    = 5;
  IdGpiShpPt    = 6;
  IdTrip        = 7;
  IdKml         = 8;
  IdHtml        = 9;
  TripFilesFor  = 'Trip files (Selected model: %s)';

procedure TFrmAdditional.SetPrefs;
begin
  TvSelections.Items[IdTrack].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncTrack', BooleanValues[true]) = BooleanValues[true]);
  TvSelections.Items[IdRoute].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncRoute', BooleanValues[true]) = BooleanValues[true]);
  TvSelections.Items[IdRoutePoint].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncRoutePoint', BooleanValues[true]) = BooleanValues[true]);
  TvSelections.Items[IdGpi].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpi', BooleanValues[true]) = BooleanValues[true]);
    TvSelections.Items[IdGpiWayPt].Checked :=
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiWayPt', BooleanValues[true]) = BooleanValues[true]);
    TvSelections.Items[IdGpiViaPt].Checked :=
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiViaPt', BooleanValues[false]) = BooleanValues[true]);
    TvSelections.Items[IdGpiShpPt].Checked :=
      (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiShpPt', BooleanValues[false]) = BooleanValues[true]);

  TvSelections.Items[IdTrip].Text := Format(TripFilesFor, [FrmTripManager.CmbModel.Text]);
  TvSelections.Items[IdTrip].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncTrip', BooleanValues[true]) = BooleanValues[true]);
  TvSelections.Items[IdKml].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncKml', BooleanValues[true]) = BooleanValues[true]);
  TvSelections.Items[IdHtml].Checked :=
    (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncHtml', BooleanValues[true]) = BooleanValues[true]);

  TvSelections.FullExpand;
end;

procedure TFrmAdditional.StorePrefs;
begin
  SetLength(Funcs, 0);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncTrack', BooleanValues[TvSelections.Items[IdTrack].Checked]);
  if (TvSelections.Items[IdTrack].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateTracks];

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncRoute', BooleanValues[TvSelections.Items[IdRoute].Checked]);
  if (TvSelections.Items[IdRoute].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateRoutes];

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncRoutePoint', BooleanValues[TvSelections.Items[IdRoutePoint].Checked]);
  if (TvSelections.Items[IdRoutePoint].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateRoutePoints];

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpi', BooleanValues[TvSelections.Items[IdGpi].Checked]);
  if (TvSelections.Items[IdGpi].Checked) then
    Funcs := Funcs + [TGPXFunc.CreatePOI];

    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiWayPt', BooleanValues[TvSelections.Items[IdGpiWayPt].Checked]);
    ProcessWayPtsInGpi := (TvSelections.Items[IdGpiWayPt].Checked);

    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiViaPt', BooleanValues[TvSelections.Items[IdGpiViaPt].Checked]);
    ProcessViaPtsInGpi := (TvSelections.Items[IdGpiViaPt].Checked);

    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncGpiShpPt', BooleanValues[TvSelections.Items[IdGpiShpPt].Checked]);
    ProcessShapePtsInGpi := (TvSelections.Items[IdGpiShpPt].Checked);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncTrip', BooleanValues[TvSelections.Items[IdTrip].Checked]);
  if (TvSelections.Items[IdTrip].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateTrips];

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncKml', BooleanValues[TvSelections.Items[IdKml].Checked]);
  if (TvSelections.Items[IdKml].Checked) then
  begin
    Funcs := Funcs + [TGPXFunc.CreateKML];
    FrmTripManager.CheckSupportedModel;
  end;

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'FuncHtml', BooleanValues[TvSelections.Items[IdHtml].Checked]);
  if (TvSelections.Items[IdHtml].Checked) then
    Funcs := Funcs + [TGPXFunc.CreateOSM];
end;

procedure TFrmAdditional.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = ID_Ok then
    StorePrefs;
end;

procedure TFrmAdditional.FormShow(Sender: TObject);
begin
  FrmTripManager.SetFixedPrefs;
  SetPrefs;
end;

end.


