unit UFrmAdvSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls,
  Vcl.Menus,
  UnitGeoCode;

type
  TFrmAdvSettings = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    PnlBottom: TPanel;
    PctMain: TPageControl;
    TabXT2: TTabSheet;
    TabGeoCode: TTabSheet;
    MemoAddressFormat: TMemo;
    PnlResult: TPanel;
    MemoResult: TMemo;
    PnlAddressFormatTop: TPanel;
    Splitter1: TSplitter;
    PnlAddressFormat: TPanel;
    BtnBuilder: TButton;
    TabGeneral: TTabSheet;
    GridGeneralSettings: TStringGrid;
    GridXT2Settings: TStringGrid;
    PopupBuilder: TPopupMenu;
    GridGeoCodeSettings: TStringGrid;
    Panel1: TPanel;
    BtnValidate: TButton;
    BtnClearCoordCache: TButton;
    TabTransferDevice: TTabSheet;
    GridTransferDevice: TStringGrid;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MemoAddressFormatChange(Sender: TObject);
    procedure BtnBuilderMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Clear1Click(Sender: TObject);
    procedure StatePlaceRoadnr1Click(Sender: TObject);
    procedure NrRoadPlaceState1Click(Sender: TObject);
    procedure Smallestplace1Click(Sender: TObject);
    procedure Largestplace1Click(Sender: TObject);
    procedure AddTag(Sender: TObject);
    procedure BtnValidateClick(Sender: TObject);
    procedure BtnClearCoordCacheClick(Sender: TObject);
  private
    { Private declarations }
    SamplePlace: TPlace;
    procedure LookupSamplePlace(UseCache: boolean);
    procedure ValidateApiKey;
    procedure LoadSettings;
    procedure SaveGrid(AGrid: TStringGrid);
    procedure SaveSettings;
  public
    { Public declarations }
    SampleLat: string;
    SampleLon: string;
  end;

var
  FrmAdvSettings: TFrmAdvSettings;

implementation

uses
  System.UITypes,
  UnitStringUtils, UnitRegistry, UnitRegistryKeys, UnitProcessOptions, UnitTripObjects;

{$R *.dfm}

procedure TFrmAdvSettings.Smallestplace1Click(Sender: TObject);
begin
  MemoAddressFormat.Lines.Add('hamlet,village,town,city,municipality');
end;

procedure TFrmAdvSettings.StatePlaceRoadnr1Click(Sender: TObject);
begin
  MemoAddressFormat.Lines.Text := DefState + #10 + DefCity + #10 + DefRoadHouse;
end;

procedure TFrmAdvSettings.Largestplace1Click(Sender: TObject);
begin
  MemoAddressFormat.Lines.Add('municipality,city,town,village,hamlet');
end;

procedure TFrmAdvSettings.LoadSettings;
var
  CurRow: integer;

  procedure AddGridHeader(const AGrid: TStringGrid);
  begin
    AGrid.FixedRows := 1;
    AGrid.Cells[0, 0] := 'Registry Key';
    AGrid.Cells[1, 0] := 'Description';
    AGrid.Cells[2, 0] := 'Value';
    AGrid.ColWidths[0] := 120;  // Less room for the Key
  end;

  procedure AddGridLine(const AGrid: TStringGrid; var ARow: integer; const AKey: string;
                        DefaultValue: string = ''; ADesc: string = '');
  begin
    AGrid.Cells[0, ARow] := AKey;
    AGrid.Cells[1, ARow] := ADesc;
    AGrid.Cells[2, ARow] := GetRegistry(AKey, DefaultValue);
    ARow := ARow + 1;
  end;

begin
  GridGeneralSettings.RowCount := GridGeneralSettings.FixedRows +1;
  GridGeneralSettings.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Window startup-');
    AddGridLine(GridGeneralSettings, CurRow, Reg_Maximized_Key,       'False', 'Start TripManager maximized');
    AddGridLine(GridGeneralSettings, CurRow, Reg_EnableSendTo,        'True',  'Enable Send to');
    AddGridLine(GridGeneralSettings, CurRow, Reg_EnableDirFuncs,      'False', 'Enable creating and deleting folders');
    AddGridLine(GridGeneralSettings, CurRow, '');

    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Preferred device and folders-');
    AddGridLine(GridGeneralSettings, CurRow, Reg_PrefDev_Key,             XTName,                     'Default device to use');
    AddGridLine(GridGeneralSettings, CurRow, Reg_PrefDevTripsFolder_Key,  Reg_PrefDevTripsFolder_Val, 'Default trips folder');
    AddGridLine(GridGeneralSettings, CurRow, Reg_PrefDevGpxFolder_Key,    Reg_PrefDevGPXFolder_Val,   'Default GPX folder');
    AddGridLine(GridGeneralSettings, CurRow, Reg_PrefDevPoiFolder_Key,    Reg_PrefDevPoiFolder_Val,   'Default GPI folder');
    AddGridLine(GridGeneralSettings, CurRow, Reg_PrefFileSysFolder_Key,   Reg_PrefFileSysFolder_Val,  'Last used Windows folder');
    AddGridLine(GridGeneralSettings, CurRow, '');

    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Map display-');
    AddGridLine(GridGeneralSettings, CurRow, Reg_GeoSearchTimeOut_Key,    Reg_GeoSearchTimeOut_Val,   'Time (ms) to show Found place balloon');
    AddGridLine(GridGeneralSettings, CurRow, Reg_RoutePointTimeOut_Key,   Reg_RoutePointTimeOut_Val,  'Time (ms) to show Route point balloon');
    AddGridLine(GridGeneralSettings, CurRow, Reg_TripColor_Key,           Reg_TripColor_Val,          'Trip file color on Map. Choose from:');
    AddGridLine(GridGeneralSettings, CurRow, '',                          '',                         'Black, (Dark)Red, (Dark)Green');
    AddGridLine(GridGeneralSettings, CurRow, '',                          '',                         '(Dark)Yellow, (Dark)Blue, (Dark)Magenta');
    AddGridLine(GridGeneralSettings, CurRow, '',                          '',                         '(Dark)Cyan, LightGray, DarkGray, White');

    GridGeneralSettings.RowCount := CurRow;
    AddGridHeader(GridGeneralSettings);

  finally
    GridGeneralSettings.EndUpdate;
  end;

  GridTransferDevice.RowCount := GridTransferDevice.FixedRows +1;
  GridTransferDevice.BeginUpdate;
  try

    CurRow := 1;

    AddGridLine(GridTransferDevice, CurRow, '', '', '-Creating Way point files (*.gpx)-');
    AddGridLine(GridTransferDevice, CurRow, Reg_FuncWayPointWpt,   'True',  'Add original Way points');
    AddGridLine(GridTransferDevice, CurRow, Reg_FuncWayPointVia,   'False', 'Add Via points from route');
    AddGridLine(GridTransferDevice, CurRow, Reg_FuncWayPointShape, 'False', 'Add Shaping points from route');
    AddGridLine(GridTransferDevice, CurRow, '');

    AddGridLine(GridTransferDevice, CurRow, '', '', '-Creating Poi files (*.gpi)-');
    AddGridLine(GridTransferDevice, CurRow, Reg_FuncGpiWayPt,      'True',  'Add original Way points');
    AddGridLine(GridTransferDevice, CurRow, Reg_FuncGpiViaPt,      'False', 'Add Via points from route');
    AddGridLine(GridTransferDevice, CurRow, Reg_FuncGpiShpPt,      'False', 'Add Shaping points from route');
    AddGridLine(GridTransferDevice, CurRow, Reg_GPISymbolSize,     '80x80', 'Size of symbols (24x24 48x48 or 80x80)');
    AddGridLine(GridTransferDevice, CurRow, Reg_GPIProximity,      '500',   'Default proximity for alerts in meters');

    GridTransferDevice.RowCount := CurRow;

    AddGridHeader(GridTransferDevice);

  finally
    GridTransferDevice.EndUpdate;
  end;


  GridXT2Settings.RowCount := GridXT2Settings.FixedRows +1;
  GridXT2Settings.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridXT2Settings, CurRow, '', '', '-Defaults for creating XT2 trips-');
    AddGridLine(GridXT2Settings, CurRow, 'ExploreUuid',           '', 'Leave blank to generate unique GUID''s');
    AddGridLine(GridXT2Settings, CurRow, 'VehicleProfileGuid',    XT2_VehicleProfileGuid);
    AddGridLine(GridXT2Settings, CurRow, 'VehicleProfileHash',    XT2_VehicleProfileHash);
    AddGridLine(GridXT2Settings, CurRow, 'VehicleId',             XT2_VehicleId);
    GridXT2Settings.RowCount := CurRow;

    AddGridHeader(GridXT2Settings);

  finally
    GridXT2Settings.EndUpdate;
  end;

  GridGeoCodeSettings.RowCount := GridGeoCodeSettings.FixedRows +1;
  ReadGeoCodeSettings;
  GridGeoCodeSettings.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridGeoCodeSettings, CurRow, '', '', '-GeoCode settings-');
    AddGridLine(GridGeoCodeSettings, CurRow, Reg_GeoCodeUrl,       GeoSettings.GeoCodeUrl,    'Open URL in a browser for more info.');
    AddGridLine(GridGeoCodeSettings, CurRow, Reg_GeoCodeApiKey,    GeoSettings.GeoCodeApiKey, 'Enter your API_Key here and click Validate');
    AddGridLine(GridGeoCodeSettings, CurRow, Reg_ThrottleGeoCode,  IntToStr(GeoSettings.ThrottleGeoCode), 'Minimum time in ms between calls');
    GridGeoCodeSettings.RowCount := CurRow;

    AddGridHeader(GridGeoCodeSettings);
  finally
    GridGeoCodeSettings.EndUpdate;
  end;
  MemoAddressFormat.Lines.Text := ReplaceAll(GeoSettings.AddressFormat, ['|'], [#13#10], [rfReplaceAll]);
end;

procedure TFrmAdvSettings.LookupSamplePlace(UseCache: boolean);
begin
  if (SamplePlace = nil) and
     (GeoSettings.GeoCodeApiKey <> '') and
     (ValidLatLon(SampleLat, SampleLon)) then
    SamplePlace := GetPlaceOfCoords(SampleLat, SampleLon, 0, 0, UseCache);
end;

procedure TFrmAdvSettings.ValidateApiKey;
begin
  GeoSettings.GeoCodeUrl := GridGeoCodeSettings.Cells[2, 2];
  if (Trim(GeoSettings.GeoCodeUrl) = '') then
    raise Exception.Create('Need a GeoCode URL');
  GeoSettings.GeoCodeApiKey := GridGeoCodeSettings.Cells[2, 3];
  if (Trim(GeoSettings.GeoCodeApiKey) = '') then
    raise Exception.Create('Need a GeoCode API_Key');
  if not(ValidLatLon(SampleLat, SampleLon)) then
    raise Exception.Create(Format('Your current map position (%s, %s) is not valid.', [SampleLat, SampleLon]));

  MemoAddressFormat.Enabled := (GeoSettings.GeoCodeApiKey <> '');
  SamplePlace := nil;
  LookupSamplePlace(false);
  MemoAddressFormatChange(MemoAddressFormat);
end;

procedure TFrmAdvSettings.MemoAddressFormatChange(Sender: TObject);
begin
  LookupSamplePlace(true);
  GeoSettings.AddressFormat := ReplaceAll(MemoAddressFormat.Lines.Text, [#13#10], ['|'], [rfReplaceAll]);
  if (SamplePlace <> nil) then
    MemoResult.lines.Text := SamplePlace.DisplayPlace;
end;

procedure TFrmAdvSettings.NrRoadPlaceState1Click(Sender: TObject);
begin
    MemoAddressFormat.Lines.Text := DefHouseRoad + #10 + DefCity + #10 + DefState;
end;

procedure TFrmAdvSettings.SaveGrid(AGrid: TStringGrid);
var
  Index: integer;
begin
  for Index := AGrid.FixedRows to AGrid.RowCount do
  begin
    if (AGrid.Cells[0, Index] = '') then
      continue;
    SetRegistry(AGrid.Cells[0, Index], AGrid.Cells[2, Index]);
  end;
end;

procedure TFrmAdvSettings.SaveSettings;
begin
  SaveGrid(GridGeneralSettings);
  SaveGrid(GridTransferDevice);
  SaveGrid(GridXT2Settings);
  SaveGrid(GridGeoCodeSettings);

  SetRegistry(Reg_AddressFormat, ReplaceAll(MemoAddressFormat.Lines.Text, [#13#10], ['|'], [rfReplaceAll]));
end;

procedure TFrmAdvSettings.BtnBuilderMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Pt: TPoint;
begin
  Pt.X := X;
  Pt.Y := Y;
  Pt := TButton(Sender).ClientToScreen(Pt);
  PopupBuilder.Popup(Pt.X, Pt.Y);
end;

procedure TFrmAdvSettings.BtnClearCoordCacheClick(Sender: TObject);
begin
  if (MessageDlg('Clear the cache?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> idOK) then
    exit;

  ClearCoordCache;
end;

procedure TFrmAdvSettings.BtnValidateClick(Sender: TObject);
begin
  ValidateApiKey;
end;

procedure TFrmAdvSettings.Clear1Click(Sender: TObject);
begin
  MemoAddressFormat.Lines.Clear;
  MemoResult.Lines.Clear;
end;

procedure TFrmAdvSettings.AddTag(Sender: TObject);
begin
  MemoAddressFormat.lines.Add(ReplaceAll(TMenuItem(Sender).Caption, ['&'], ['']));
end;

procedure TFrmAdvSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    SaveSettings;
end;

procedure TFrmAdvSettings.FormShow(Sender: TObject);
begin
  SamplePlace := nil;
  MemoResult.Lines.Clear;

  LoadSettings;
  MemoAddressFormat.Enabled := (GeoSettings.GeoCodeApiKey <> '');
  PctMain.ActivePage := TabGeneral;
  MemoAddressFormatChange(MemoAddressFormat);
end;

end.

