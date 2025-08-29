unit UFrmAdvSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls,
  Vcl.Menus;

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
    BtnCurrent: TButton;
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
    procedure BtnCurrentClick(Sender: TObject);
    procedure PctMainResize(Sender: TObject);
  private
    { Private declarations }
    SamplePlace: TObject;
    function GetSampleDataItem(const ABase: TObject): string;
    function GetSampleItem(const KeyName: ShortString): string;
    function GetSampleLocationItem(const ClassName: string): string;
    procedure LookupSamplePlace(UseCache: boolean);
    procedure ValidateApiKey;
    procedure LoadSettings_General;
    procedure LoadSettings_Device;
    procedure LoadSettings_XT2;
    procedure LoadSettings_GeoCode;
    procedure LoadSettings;
    procedure SaveGrid(AGrid: TStringGrid);
    procedure SaveSettings;
  public
    { Public declarations }
    SampleTrip: TObject;
    SampleLat: string;
    SampleLon: string;
  end;

var
  FrmAdvSettings: TFrmAdvSettings;

implementation

uses
  System.UITypes, System.StrUtils, System.Math,
  UnitStringUtils, UnitRegistry, UnitRegistryKeys, UnitProcessOptions, UnitTripObjects, UnitGeoCode, UnitOSMMap;

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

procedure AddGridHeader(const AGrid: TStringGrid);
begin
  AGrid.FixedRows := 1;
  AGrid.Cells[0, 0] := 'Registry Key';
  AGrid.Cells[1, 0] := 'Description';
  AGrid.Cells[2, 0] := 'Value';
end;

procedure AddGridLine(const AGrid: TStringGrid; var ARow: integer; const AKey: string;
                      DefaultValue: string = ''; ADesc: string = '');
var
  ACardinal: Cardinal;
begin
  AGrid.Cells[0, ARow] := AKey;
  AGrid.Cells[1, ARow] := ADesc;
  AGrid.Cells[2, ARow] := GetRegistry(AKey, DefaultValue);

  if (Startstext('0x', AGrid.Cells[2, ARow])) and
     (Startstext('Date: ', AGrid.Cells[1, ARow])) then
  begin
    ACardinal := StrToIntDef('$' + Copy(AGrid.Cells[2, ARow], 3), 0);
    AGrid.Cells[1, ARow] := 'Date: ' + TUnixDate.CardinalAsDateTimeString(ACardinal);
  end;

  ARow := ARow + 1;
end;

procedure TFrmAdvSettings.LoadSettings_General;
var
  CurRow: integer;
begin
  GridGeneralSettings.RowCount := GridGeneralSettings.FixedRows +1;
  GridGeneralSettings.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Window startup-');
    AddGridLine(GridGeneralSettings, CurRow, Reg_Maximized_Key,       'False', 'Start TripManager maximized');
    AddGridLine(GridGeneralSettings, CurRow, '');

    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Compare-');
    AddGridLine(GridGeneralSettings, CurRow, Reg_CompareDistOK_Key,  IntToStr(Reg_CompareDistOK_Val), 'Compare distance OK (meters)');
    AddGridLine(GridGeneralSettings, CurRow, '');
    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Map display-');
    AddGridLine(GridGeneralSettings, CurRow, Reg_MapTilerApi_Key,         '',   'Api-Key for enabling Map Tiler. https://www.maptiler.com');

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
end;

procedure TFrmAdvSettings.LoadSettings_Device;
var
  CurRow: integer;
begin
  GridDeviceSettings.RowCount := GridDeviceSettings.FixedRows +1;
  GridDeviceSettings.BeginUpdate;
  try

    CurRow := 1;

    AddGridLine(GridDeviceSettings, CurRow, '', '', '-Device-');
    AddGridLine(GridDeviceSettings, CurRow, Reg_EnableDirFuncs,      'False', 'Enable creating and deleting folders');
    AddGridLine(GridDeviceSettings, CurRow, Reg_TripNameInList,      'True',  'Show TripName in file list');
    AddGridLine(GridDeviceSettings, CurRow, '');

    AddGridLine(GridDeviceSettings, CurRow, '', '', '-Preferred device and folders-');
    AddGridLine(GridDeviceSettings, CurRow, Reg_PrefDev_Key,             XT_Name,                    'Default device to use');
    AddGridLine(GridDeviceSettings, CurRow, Reg_PrefDevTripsFolder_Key,  Reg_PrefDevTripsFolder_Val, 'Default trips folder');
    AddGridLine(GridDeviceSettings, CurRow, Reg_PrefDevGpxFolder_Key,    Reg_PrefDevGPXFolder_Val,   'Default GPX folder');
    AddGridLine(GridDeviceSettings, CurRow, Reg_PrefDevPoiFolder_Key,    Reg_PrefDevPoiFolder_Val,   'Default GPI folder');
    AddGridLine(GridDeviceSettings, CurRow, Reg_PrefFileSysFolder_Key,   Reg_PrefFileSysFolder_Val,  'Last used Windows folder');
    AddGridLine(GridDeviceSettings, CurRow, '');

    AddGridLine(GridDeviceSettings, CurRow, '', '', '-Creating Way point files (*.gpx)-');
    AddGridLine(GridDeviceSettings, CurRow, Reg_FuncWayPointWpt,   'True',  'Add original Way points');
    AddGridLine(GridDeviceSettings, CurRow, Reg_FuncWayPointVia,   'False', 'Add Via points from route');
    AddGridLine(GridDeviceSettings, CurRow, Reg_FuncWayPointShape, 'False', 'Add Shaping points from route');
    AddGridLine(GridDeviceSettings, CurRow, '');

    AddGridLine(GridDeviceSettings, CurRow, '', '', '-Creating Poi files (*.gpi)-');
    AddGridLine(GridDeviceSettings, CurRow, Reg_FuncGpiWayPt,      'True',  'Add original Way points');
    AddGridLine(GridDeviceSettings, CurRow, Reg_FuncGpiViaPt,      'False', 'Add Via points from route');
    AddGridLine(GridDeviceSettings, CurRow, Reg_FuncGpiShpPt,      'False', 'Add Shaping points from route');
    AddGridLine(GridDeviceSettings, CurRow, Reg_GPISymbolSize,     '80x80', 'Size of symbols (24x24 48x48 or 80x80)');
    AddGridLine(GridDeviceSettings, CurRow, Reg_GPIProximity,      '500',   'Default proximity for alerts in meters');

    GridDeviceSettings.RowCount := CurRow;

    AddGridHeader(GridDeviceSettings);

  finally
    GridDeviceSettings.EndUpdate;
  end;
end;

procedure TFrmAdvSettings.LoadSettings_XT2;
var
  CurRow: integer;
begin
  GridZumoSettings.RowCount := GridZumoSettings.FixedRows +1;
  GridZumoSettings.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridZumoSettings, CurRow, '', '', '-Defaults for creating trips-');
    AddGridLine(GridZumoSettings, CurRow, Reg_ScPosn_Unknown1,             '0', '');
    AddGridLine(GridZumoSettings, CurRow, Reg_AddSubClasses,               'True', 'Add <subclass> from GPX');
    AddGridLine(GridZumoSettings, CurRow, Reg_ForceRecalc,                 'True', 'Force recalculation');
    AddGridLine(GridZumoSettings, CurRow, Reg_PreserveTrackToRoute,        'False', 'Create TripTrack');
    AddGridLine(GridZumoSettings, CurRow, '');
    AddGridLine(GridZumoSettings, CurRow, '', '', '-Defaults for creating XT1 trips-');
    AddGridLine(GridZumoSettings, CurRow, Reg_AllowGrouping,               'True', 'Group trips from the same GPX');
    AddGridLine(GridZumoSettings, CurRow, '');
    AddGridLine(GridZumoSettings, CurRow, '', '', '-Defaults for creating XT2 trips-');
    AddGridLine(GridZumoSettings, CurRow, Reg_VehicleProfileGuid,          XT2_VehicleProfileGuid);
    AddGridLine(GridZumoSettings, CurRow, Reg_VehicleProfileHash,          XT2_VehicleProfileHash);
    AddGridLine(GridZumoSettings, CurRow, Reg_VehicleId,                   XT2_VehicleId);
    AddGridLine(GridZumoSettings, CurRow, Reg_VehicleProfileTruckType,     XT2_VehicleProfileTruckType);
    AddGridLine(GridZumoSettings, CurRow, Reg_VehicleProfileName,          XT2_VehicleProfileName);
    AddGridLine(GridZumoSettings, CurRow, Reg_AvoidancesChangedTimeAtSave, XT2_AvoidancesChangedTimeAtSave, 'Date: ');
    GridZumoSettings.RowCount := CurRow;

    AddGridHeader(GridZumoSettings);

  finally
    GridZumoSettings.EndUpdate;
  end;
end;

procedure TFrmAdvSettings.LoadSettings_GeoCode;
var
  CurRow: integer;
begin
  GridGeoCodeSettings.RowCount := GridGeoCodeSettings.FixedRows +1;
  ReadGeoCodeSettings;
  GridGeoCodeSettings.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridGeoCodeSettings, CurRow, '', '', '-GeoCode settings-');
    AddGridLine(GridGeoCodeSettings, CurRow, Reg_GeoCodeUrl,       GeoSettings.GeoCodeUrl,    'Open URL in a browser for more info.');
    AddGridLine(GridGeoCodeSettings, CurRow, Reg_GeoCodeApiKey,    GeoSettings.GeoCodeApiKey, 'Enter your API_Key here and click Validate');
    AddGridLine(GridGeoCodeSettings, CurRow, Reg_ThrottleGeoCode,  IntToStr(GeoSettings.ThrottleGeoCode), 'Minimum time in ms between calls');
    AddGridLine(GridGeoCodeSettings, CurRow, Reg_SelectUniqPlace,  'False',                   'Auto select unique places');
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
  LoadSettings_XT2;
  LoadSettings_GeoCode;
end;

function TFrmAdvSettings.GetSampleDataItem(const ABase: TObject): string;
begin
  result := '';

  if (ABase is TUnixDate) then
    result := '0x' + IntTohex(TUnixDate(ABase).AsUnixDateTime, 8)
  else if (ABase is TmScPosn) then
    result := '0x' + IntTohex(TmScPosn(ABase).Unknown1, 8)
  else if (ABase is TBaseDataItem) then
    result := TBaseDataItem(ABase).AsString;
end;


function TFrmAdvSettings.GetSampleItem(const KeyName: ShortString): string;
var
  ABase: TBaseItem;
begin
  result := '';

  if (SampleTrip <> nil) and
     (SampleTrip is TTripList) then
  begin
    ABase := TTripList(SampleTrip).GetItem('m' + KeyName);
    if (ABase <> nil) then
      result := GetSampleDataItem(ABase);
  end;
end;

function TFrmAdvSettings.GetSampleLocationItem(const ClassName: string): string;
var
  Alocation: Tlocation;
  ANItem: TBaseItem;
begin
  result := '';

  if (SampleTrip <> nil) and
     (SampleTrip is TTripList) then
  begin
    Alocation := TTripList(SampleTrip).GetRoutePoint(0);
    if (Alocation <> nil) then
    begin
      for ANItem in Alocation.LocationItems do
      begin
        if (ANItem is TBaseDataItem) and
           (ANItem.ClassName = ClassName) then
          exit(GetSampleDataItem(ANItem));
      end;
    end;
  end;
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
  Margin: integer;

  procedure AlignGrid(AGrid: TStringGrid);
  var
    Index: integer;
    CurCol: integer;
    LastCol: integer;
    SpaceNeeded: integer;
  begin
    LastCol := SpaceLeft;
    for CurCol := 0 to AGrid.ColCount -2 do
    begin
      SpaceNeeded := 0;
      for Index := 0 to AGrid.RowCount do
        SpaceNeeded := Max(SpaceNeeded, AGrid.Canvas.TextWidth(AGrid.Cells[CurCol, Index]) + Margin);
      AGrid.ColWidths[CurCol] := SpaceNeeded;
      Dec(LastCol, SpaceNeeded);
    end;
    AGrid.ColWidths[AGrid.ColCount -1] := LastCol;
  end;

begin
  Margin := ScaleValue(10);
  SpaceLeft := TPageControl(Sender).ClientWidth - GetSystemMetrics(SM_CXVSCROLL);
  AlignGrid(GridGeneralSettings);
  AlignGrid(GridDeviceSettings);
  AlignGrid(GridZumoSettings);
  AlignGrid(GridGeoCodeSettings);
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
  SaveGrid(GridDeviceSettings);
  SaveGrid(GridZumoSettings);
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

procedure TFrmAdvSettings.BtnCurrentClick(Sender: TObject);
begin
  SetRegistry(Reg_ScPosn_Unknown1,              GetSampleLocationItem(TmScPosn.ClassName));
  SetRegistry(Reg_VehicleProfileGuid,           GetSampleItem(Reg_VehicleProfileGuid));
  SetRegistry(Reg_VehicleProfileHash,           GetSampleItem(Reg_VehicleProfileHash));
  SetRegistry(Reg_VehicleId,                    GetSampleItem(Reg_VehicleId));
  SetRegistry(Reg_VehicleProfileTruckType,      GetSampleItem(Reg_VehicleProfileTruckType));
  SetRegistry(Reg_VehicleProfileName,           GetSampleItem(Reg_VehicleProfileName));
  SetRegistry(Reg_AvoidancesChangedTimeAtSave,  GetSampleItem(Reg_AvoidancesChangedTimeAtSave));

  LoadSettings_XT2;
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
