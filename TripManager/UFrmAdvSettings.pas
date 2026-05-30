unit UFrmAdvSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Menus,
  UnitStringGrid;

type
  TFrmAdvSettings = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    PnlBottom: TPanel;
    PctMain: TPageControl;
    TabZumo: TTabSheet;
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
    GridZumoSettings: TStringGrid;
    PopupBuilder: TPopupMenu;
    GridGeoCodeSettings: TStringGrid;
    PnlGeoCodeFuncs: TPanel;
    BtnValidate: TButton;
    BtnClearCoordCache: TButton;
    TabDevice: TTabSheet;
    GridDeviceSettings: TStringGrid;
    PnlZumoFuncs: TPanel;
    BtnVehProfile: TButton;
    TabTripOverview: TTabSheet;
    GridTripOverview: TStringGrid;
    TabKurviger: TTabSheet;
    GridKurviger: TStringGrid;
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
    procedure BtnVehProfileClick(Sender: TObject);
    procedure PctMainResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    SamplePlace: TObject;
    procedure GridModified(Sender: TObject; ACol, ARow: LongInt; var Value: string);
    procedure LookupSamplePlace(UseCache: boolean);
    procedure ValidateApiKey;
    procedure LoadSettings_General;
    procedure LoadSettings_Device;
    procedure LoadSettings_Zumo;
    procedure LoadSettings_Kurviger;
    procedure LoadSettings_TripOverview;
    procedure LoadSettings_GeoCode;
    procedure LoadSettings;
    procedure SaveGrid(AGrid: TStringGrid);
    procedure SaveSettings;
  public
    { Public declarations }
    CurrentDevice: Tobject;
    SampleLat: string;
    SampleLon: string;
  end;

var
  FrmAdvSettings: TFrmAdvSettings;

implementation

uses
  System.UITypes, System.StrUtils, System.Math,
  UnitStringUtils, UnitRegistry, UnitRegistryKeys, UnitModelConv, UnitProcessOptions, UnitTripDefs, UnitTripObjects, UnitGpi,
  UnitGeoCode, UnitOSMMap,
  TripManager_Grid,
  UFrmVehProfiles;

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

procedure TFrmAdvSettings.LoadSettings_General;
var
  CurRow: integer;
begin
  GridGeneralSettings.OnModified := GridModified;
  GridGeneralSettings.RowCount := GridGeneralSettings.FixedRows +1;
  GridGeneralSettings.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridGeneralSettings, CurRow,  '', '', '-Window startup-');
    AddGridLine(GridGeneralSettings, CurRow,  Reg_Maximized_Key,
                                              'False',
                                              'Start TripManager maximized');
    AddGridLine(GridGeneralSettings, CurRow,  '', '');

    AddGridLine(GridGeneralSettings, CurRow,  '', '', '-Tracks-');
    AddGridLine(GridGeneralSettings, CurRow,  Reg_MinDistTrackPoints,
                                              '0',
                                              'Minimum distance track points (meters)');
    AddGridLine(GridGeneralSettings, CurRow,  Reg_MinTimeTrackPoints,
                                              '60',
                                              'Minimum time Auto Stops (seconds)');
    AddGridLine(GridGeneralSettings, CurRow,  '', '');

    AddGridLine(GridGeneralSettings, CurRow,  '', '', '-Compare-');
    AddGridLine(GridGeneralSettings, CurRow,  Reg_CompareDistOK_Key,
                                              IntToStr(Reg_CompareDistOK_Val),
                                              'Compare distance OK (meters)');
    AddGridLine(GridGeneralSettings, CurRow,  Reg_MinShapeDist_Key,
                                              IntToStr(Reg_MinShapeDist_Val),
                                              'Minimum distance added Shaping points (meters)');
    AddGridLine(GridGeneralSettings, CurRow,  '', '');
    AddGridLine(GridGeneralSettings, CurRow,  Reg_Trk2RtOptions_Key,
                                              Reg_Trk2RtOptions_Val,
                                              'Trk2Rt CMDline Options');
    AddGridLine(GridGeneralSettings, CurRow,  '', '');
    AddGridLine(GridGeneralSettings, CurRow,  '', '', '-Map display-');
    AddGridLine(GridGeneralSettings, CurRow,  Reg_MapTilerApi_Key,
                                              '',
                                              'Api-Key for enabling Map Tiler. https://www.maptiler.com');

    AddGridLine(GridGeneralSettings, CurRow,  Reg_HtmlOutput_Key,
                                              Reg_HtmlOutput_Val,
                                              '0=OSM, 1=Kurviger, 2=Both');

    AddGridLine(GridGeneralSettings, CurRow,  Reg_GeoSearchTimeOut_Key,
                                              Reg_GeoSearchTimeOut_Val,
                                              'Time (ms) to show Found place balloon');
    AddGridLine(GridGeneralSettings, CurRow,  Reg_RoutePointTimeOut_Key,
                                              Reg_RoutePointTimeOut_Val,
                                              'Time (ms) to show Route point balloon');
    AddGridLine(GridGeneralSettings, CurRow,  Reg_TripColor_Key,
                                              Reg_TripColor_Val,
                                              'Trip file color on Map. Choose from:');
    AddGridLine(GridGeneralSettings, CurRow,  '', '',
                                              'Black, (Dark)Red, (Dark)Green');
    AddGridLine(GridGeneralSettings, CurRow,  '', '',
                                              '(Dark)Yellow, (Dark)Blue, (Dark)Magenta');
    AddGridLine(GridGeneralSettings, CurRow,  '', '',
                                              '(Dark)Cyan, LightGray, DarkGray, White');

    GridGeneralSettings.RowCount := CurRow;
    AddGridHeader(GridGeneralSettings);

  finally
    GridGeneralSettings.EndUpdate;
  end;
end;

procedure TFrmAdvSettings.LoadSettings_Device;
var
  CurRow: integer;
  SubKey: string;
begin
  GridDeviceSettings.OnModified := GridModified;
  GridDeviceSettings.RowCount := GridDeviceSettings.FixedRows +1;
  GridDeviceSettings.BeginUpdate;
  try
    SubKey := TModelConv.GetDefaultDevice(GetRegistry(Reg_CurrentModel, 0));

    CurRow := 1;

    AddGridLine(GridDeviceSettings,   CurRow, '', '', '-Device-');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_EnableDirFuncs,
                                      'False',
                                      'Enable creating and deleting folders');

    AddGridLine(GridDeviceSettings,   CurRow, Reg_EnableExploreFuncs,
                                      'False',
                                      'Enable Explore');

    AddGridLine(GridDeviceSettings,   CurRow, '', '');

    AddGridLine(GridDeviceSettings,   CurRow, '', '',
                                      Format('-Preferred folders (Model: %s)-', [SubKey]));
    AddGridLine(GridDeviceSettings,   CurRow, SubKey + '\' + Reg_PrefDev_Key,
                                      '',
                                      'Override device name');
    AddGridLine(GridDeviceSettings,   CurRow, SubKey + '\' + Reg_PrefDevTripsFolder_Key,
                                      TModelConv.GetKnownPath(CurrentDevice, 0),
                                      'Default trips folder');
    AddGridLine(GridDeviceSettings,   CurRow, SubKey + '\' + Reg_PrefDevGpxFolder_Key,
                                      TModelConv.GetKnownPath(CurrentDevice, 1),
                                      'Default GPX folder');
    AddGridLine(GridDeviceSettings,   CurRow, SubKey + '\' + Reg_PrefDevPoiFolder_Key,
                                      TModelConv.GetKnownPath(CurrentDevice, 2),
                                      'Default GPI folder');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_PrefFileSysFolder_Key,
                                      Reg_PrefFileSysFolder_Val,
                                      'Last used Windows folder');
    AddGridLine(GridDeviceSettings,   CurRow, '', '');

    AddGridLine(GridDeviceSettings,   CurRow, '', '',
                                      '-Creating Way point files (*.gpx)-');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_FuncWayPointWpt,
                                      'True',
                                      'Add original Way points');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_FuncWayPointVia,
                                      'False',
                                      'Add Via points from route');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_FuncWayPointShape,
                                      'False',
                                      'Add Shaping points from route');
    AddGridLine(GridDeviceSettings,   CurRow, '', '');

    AddGridLine(GridDeviceSettings,   CurRow, '', '', '-Creating Poi files (*.gpi)-');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_FuncGpiWayPt,
                                      'True',
                                      'Add original Way points');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_FuncGpiViaPt,
                                      'False',
                                      'Add Via points from route');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_FuncGpiShpPt,
                                      'False',
                                      'Add Shaping points from route');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_GPISymbolSize,
                                      '80x80',
                                      'Size of symbols (24x24, 48x48 or 80x80)');
    AddGridLine(GridDeviceSettings,   CurRow, Reg_GPIProximity,
                                      '500',
                                      'Default proximity for alerts in meters');

    GridDeviceSettings.RowCount := CurRow;

    AddGridHeader(GridDeviceSettings);

  finally
    GridDeviceSettings.EndUpdate;
  end;
end;

procedure TFrmAdvSettings.LoadSettings_Zumo;
var
  CurRow: integer;
  SubKey: string;
begin
  GridZumoSettings.OnModified := GridModified;
  GridZumoSettings.RowCount := GridZumoSettings.FixedRows +1;
  GridZumoSettings.BeginUpdate;
  try

    SubKey := TModelConv.GetDefaultDevice(GetRegistry(Reg_CurrentModel, 0));

    CurRow := 1;

    AddGridLine(GridZumoSettings, CurRow,   '', '', '-Defaults for creating trips-');
    AddGridLine(GridZumoSettings, CurRow,   '', '');
    AddGridLine(GridZumoSettings, CurRow,   '', '', '-Defaults for creating XT1 trips-');
    AddGridLine(GridZumoSettings, CurRow,   Reg_AllowGrouping,
                                            'True',
                                            'Group trips from the same GPX');
    AddGridLine(GridZumoSettings, CurRow,   '', '');
    AddGridLine(GridZumoSettings, CurRow,   '', '', '-Defaults for creating XT2/XT3 trips-');
    AddGridLine(GridZumoSettings, CurRow,   Reg_AvoidancesChangedTimeAtSave,
                                            '',
                                            'Date: ');
    AddGridLine(GridZumoSettings, CurRow,   '', '');
    if (TModelConv.ReadDeviceDB(TModelConv.Display2Garmin(GetRegistry(Reg_CurrentModel, 0)))) then
    begin
      AddGridLine(GridZumoSettings, CurRow,   Reg_LoadActiveProfile,
                                              'True', 'Load active profile automatically');
      AddGridLine(GridZumoSettings, CurRow,   SubKey + '\' + Reg_VehicleId,
                                              DEF_VehicleId);
      AddGridLine(GridZumoSettings, CurRow,   SubKey + '\' + Reg_VehicleProfileName,
                                              DEF_VehicleProfileName);
      AddGridLine(GridZumoSettings, CurRow,   SubKey + '\' + Reg_VehicleProfileGuid,
                                              DEF_VehicleProfileGuid);
      AddGridLine(GridZumoSettings, CurRow,   SubKey + '\' + Reg_VehicleProfileHash,
                                              '0');
      AddGridLine(GridZumoSettings, CurRow,   SubKey + '\' + Reg_VehicleProfileTruckType,
                                              DEF_VehicleProfileTruckType,
                                              '7=Motorcycle, 11=Car');
      AddGridLine(GridZumoSettings, CurRow,   SubKey + '\' + Reg_DefAdvLevel,
                                              IntToStr(Ord(TAdvlevel.advLevel2)),
                                              'Default Adventurous Level (1-4)');
    end;
    GridZumoSettings.RowCount := CurRow;

    AddGridHeader(GridZumoSettings);

  finally
    GridZumoSettings.EndUpdate;
  end;
end;

procedure TFrmAdvSettings.LoadSettings_Kurviger;
var
  CurRow: integer;
begin
  GridKurviger.OnModified := GridModified;
  GridKurviger.RowCount := GridTripOverview.FixedRows +1;
  GridKurviger.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridKurviger, CurRow,  '', '', '-Kurviger parameters-');
    AddGridLine(GridKurviger, CurRow,  '', '');
    AddGridLine(GridKurviger, CurRow,  Reg_KurvigerUrl_Key,
                                       Reg_KurvigerUrl_Val,
                                       'Kurviger URL');
    AddGridLine(GridKurviger, CurRow,  '', '', 'en=English, de=Deutsch, nl=Nederlands');
    AddGridLine(GridKurviger, CurRow,  '', '', 'fr=Français, es=Español, it=Italiano');
    AddGridLine(GridKurviger, CurRow,  '', '');
    AddGridLine(GridKurviger, CurRow,  Reg_KurvigerCurvature,
                                       IntToStr(3),
                                       'Default Curvature Level (1-4)');
    AddGridLine(GridKurviger, CurRow,  '', '', '1=Fastest, 2=Fast and curvy, 3=Curvy, 4=Extra curvy');
    AddGridLine(GridKurviger, CurRow,  '', '', '5=All curvy route modes (Not implemented)');
    AddGridLine(GridKurviger, CurRow,  '', '');

    AddGridLine(GridKurviger, CurRow,  '', '', '-Avoidances-');
    AddGridLine(GridKurviger, CurRow,  Reg_KurvigerAvoidSame,
                                       'False',
                                       'Same road twice');
    AddGridLine(GridKurviger, CurRow,  Reg_KurvigerAvoidToll,
                                       'False',
                                       'Toll');
    AddGridLine(GridKurviger, CurRow,  Reg_KurvigerAvoidMotorways,
                                       'False',
                                       'Motorways');
    AddGridLine(GridKurviger, CurRow,  Reg_KurvigerAvoidMain,
                                       'False',
                                       'Main roads');
    AddGridLine(GridKurviger, CurRow,  Reg_KurvigerAvoidNarrow,
                                       'False',
                                       'Narrow roads');
    AddGridLine(GridKurviger, CurRow,  Reg_KurvigerAvoidUnpaved,
                                       'False',
                                       'Unpaved roads');

    AddGridLine(GridKurviger, CurRow,  '', '');
    GridKurviger.RowCount := CurRow;
    AddGridHeader(GridKurviger);

  finally
    GridKurviger.EndUpdate;
  end;
end;

procedure TFrmAdvSettings.LoadSettings_TripOverview;
var
  CurRow: integer;
begin
  GridTripOverview.OnModified := GridModified;
  GridTripOverview.RowCount := GridTripOverview.FixedRows +1;
  GridTripOverview.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridTripOverview, CurRow,  '', '', '-Trip Overview-');
    AddGridLine(GridTripOverview, CurRow,  Reg_EnableTripOverview,
                                              'False',
                                              'Create detailed CSV (Only for BC calculated GPX)');
    AddGridLine(GridTripOverview, CurRow,  '', '');
    AddGridLine(GridTripOverview, CurRow,  '', '', '-Road Speeds (kmh)-');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_01',
                                              '108',
                                              'Interstate highway');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_02',
                                              '72',
                                              'Major highway');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_03',
                                              '56',
                                              'Other highway');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_04',
                                              '50',
                                              'Arterial road');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_05',
                                              '48',
                                              'Collector road');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_06',
                                              '30',
                                              'Residential Street');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_07',
                                              '15',
                                              'Private');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_08',
                                              '50',
                                              'Highway ramp. Low speed');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_09',
                                              '80',
                                              'Highway ramp. High speed');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_0A',
                                              '15',
                                              'Unpaved');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_0B',
                                              '25',
                                              'Major higway connector');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key + '_0C',
                                              '15',
                                              'Round about');
    AddGridLine(GridTripOverview, CurRow,   Reg_RoadSpeed_Key,
                                              '25',
                                              'All others');
    AddGridLine(GridTripOverview, CurRow,  '', '');

    GridTripOverview.RowCount := CurRow;
    AddGridHeader(GridTripOverview);

  finally
    GridTripOverview.EndUpdate;
  end;
end;

procedure TFrmAdvSettings.LoadSettings_GeoCode;
var
  CurRow: integer;
begin
  GridGeoCodeSettings.OnModified := GridModified;
  GridGeoCodeSettings.RowCount := GridGeoCodeSettings.FixedRows +1;
  ReadGeoCodeSettings;
  GridGeoCodeSettings.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridGeoCodeSettings, CurRow,  '', '', '-GeoCode settings-');
    AddGridLine(GridGeoCodeSettings, CurRow,  Reg_GeoCodeUrl,
                                              GeoSettings.GeoCodeUrl,
                                              'Open URL in a browser for more info.');
    AddGridLine(GridGeoCodeSettings, CurRow,  Reg_GeoCodeApiKey,
                                              GeoSettings.GeoCodeApiKey,
                                              'Enter your API_Key here and click Validate');
    AddGridLine(GridGeoCodeSettings, CurRow,  Reg_ThrottleGeoCode,
                                              IntToStr(GeoSettings.ThrottleGeoCode),
                                              'Minimum time in ms between calls');
    AddGridLine(GridGeoCodeSettings, CurRow,  Reg_SelectUniqPlace,
                                              'False',
                                              'Auto select unique places');
    GridGeoCodeSettings.RowCount := CurRow;

    AddGridHeader(GridGeoCodeSettings);
  finally
    GridGeoCodeSettings.EndUpdate;
  end;
  MemoAddressFormat.Lines.Text := ReplaceAll(GeoSettings.AddressFormat, ['|'], [#13#10], [rfReplaceAll]);
end;

procedure TFrmAdvSettings.LoadSettings;
begin
  LoadSettings_General;
  LoadSettings_Device;
  LoadSettings_Zumo;
  LoadSettings_Kurviger;
  LoadSettings_TripOverview;
  LoadSettings_GeoCode;
end;

procedure TFrmAdvSettings.GridModified(Sender: TObject; ACol, ARow: LongInt; var Value: string);
begin
  if (TStringGrid(Sender).Cells[0, Arow] = '') then
    TStringGrid(Sender).Cells[2, Arow] := ''
  else if (Copy(TStringGrid(Sender).Cells[0, Arow], 1, 1) <> '*') then
    TStringGrid(Sender).Cells[0, Arow] := '*' + TStringGrid(Sender).Cells[0, Arow];
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
    MemoResult.lines.Text := TPlace(SamplePlace).DisplayPlace;
end;

procedure TFrmAdvSettings.NrRoadPlaceState1Click(Sender: TObject);
begin
  MemoAddressFormat.Lines.Text := DefHouseRoad + #10 + DefCity + #10 + DefState;
end;

procedure TFrmAdvSettings.PctMainResize(Sender: TObject);
var
  SpaceLeft: integer;

begin
  SpaceLeft := TPageControl(Sender).ClientWidth - GetSystemMetrics(SM_CXVSCROLL);
  AlignGrid(GridGeneralSettings, SpaceLeft);
  AlignGrid(GridDeviceSettings, SpaceLeft);
  AlignGrid(GridZumoSettings, SpaceLeft);
  AlignGrid(GridKurviger, SpaceLeft);
  AlignGrid(GridTripOverview, SpaceLeft);
  AlignGrid(GridGeoCodeSettings, SpaceLeft);
end;

procedure TFrmAdvSettings.SaveGrid(AGrid: TStringGrid);
var
  Index: integer;
  AKey, ASubKey: string;
begin
  for Index := AGrid.FixedRows to AGrid.RowCount do
  begin
    if (Copy(AGrid.Cells[0, Index], 1, 1) <> '*') then
      continue;
    AKey := Copy(AGrid.Cells[0, Index], 2);
    if (Pos('\', AKey) > 0) then
      ASubKey := NextField(AKey, '\')
    else
      ASubKey := '';
    SetRegistry(AKey, AGrid.Cells[2, Index], ASubKey);
  end;
end;

procedure TFrmAdvSettings.SaveSettings;
begin
  SaveGrid(GridGeneralSettings);
  SaveGrid(GridDeviceSettings);
  SaveGrid(GridZumoSettings);
  SaveGrid(GridKurviger);
  SaveGrid(GridTripOverview);
  SaveGrid(GridGeoCodeSettings);

  TSetProcessOptions.CheckSymbolsDir;
  if (GetRegistry(Reg_ValidGpiSymbols, false) = false) then
    MessageDlg(Format('Selected symbol size: (%s) is not installed.%sGPI functions disabled.', [GetRegistry(Reg_GPISymbolSize, ''), #10]),
               TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);

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

procedure TFrmAdvSettings.BtnVehProfileClick(Sender: TObject);
var
  F: TFrmVehProfiles;
begin
  SaveSettings;

  F := TFrmVehProfiles.Create(nil);
  try
    F.SubKey := TModelConv.GetDefaultDevice(GetRegistry(Reg_CurrentModel, 0));
    if (F.ShowModal = idOK) then
    begin
      F.VehicleProfile.ToRegistry(F.SubKey);
    end;
 finally
    F.Free;
  end;
  LoadSettings_Zumo;
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

procedure TFrmAdvSettings.FormCreate(Sender: TObject);
begin
  PctMain.ActivePage := TabGeneral;
end;

procedure TFrmAdvSettings.FormShow(Sender: TObject);
begin
  SamplePlace := nil;
  MemoResult.Lines.Clear;

  LoadSettings;
  MemoAddressFormat.Enabled := (GeoSettings.GeoCodeApiKey <> '');
  MemoAddressFormatChange(MemoAddressFormat);

  BtnVehProfile.Enabled := TModelConv.ReadVehicleDB(TModelConv.Display2Garmin(GetRegistry(Reg_CurrentModel, 0))) and
                           FileExists(GetDeviceTmp + ProfileDb);

end;

end.
