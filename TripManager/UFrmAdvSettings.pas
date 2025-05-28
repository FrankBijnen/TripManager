unit UFrmAdvSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls,
  UnitGeoCode, Vcl.Menus;

const
  TripManagerReg_Key      = 'Software\TDBware\TripManager';
  PrefFileSysFolder_Key   = 'PrefFileSysFolder';
  PrefFileSysFolder_Val   = 'rfDesktop';
  PrefDev_Key             = 'PrefDevice';
  PrefDevTripsFolder_Key  = 'PrefDeviceTripsFolder';
  PrefDevTripsFolder_Val  = 'Internal Storage\.System\Trips';
  PrefDevGpxFolder_Key    = 'PrefDeviceGpxFolder';
  PrefDevGpxFolder_Val    = 'Internal Storage\GPX';
  PrefDevPoiFolder_Key    = 'PrefDevicePoiFolder';
  PrefDevPoiFolder_Val    = 'Internal Storage\POI';
  WarnModel_Key           = 'WarnModel';
  TripColor_Key           = 'TripColor';
  Maximized_Key           = 'Maximized';
  WidthColumns_Key        = 'WidthColumns';
  SortColumn_Key          = 'SortColumn';
  SortAscending_Key       = 'SortAscending';

  BooleanValues: array[boolean] of string = ('False', 'True');

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
    procedure SetFixedPrefs;
  end;

var
  FrmAdvSettings: TFrmAdvSettings;

implementation

uses
  System.UITypes,
  UnitStringUtils, UFrmTripManager, UnitGpx, UnitGpi, UnitTripObjects;

{$R *.dfm}

procedure TFrmAdvSettings.SetFixedPrefs;
var
  ProcessWpt: boolean;
  WayPtCat: integer;
  WayPtList: TStringList;
begin
  DebugComments := 'False';

  TrackColor := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'TrackColor', '');
  KMLTrackColor := '';
  OSMTrackColor := 'Magenta';
  GpiSymbolsDir := Utf8String(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))) + 'Symbols\80x80\';
  IniProximityStr := '500';

  ProcessTracks := true;
  ProcessSubClass := true;
  ProcessBegin := false;
  ProcessEnd := false;
  ProcessVia := false;
  ProcessViaPts := true;
  ProcessShape := false;
  ShapingPointName := TShapingPointName.Unchanged;

  ProcessAddrBegin := false;
  ProcessAddrEnd := false;
  ProcessAddrVia := false;
  ProcessAddrShape := false;
  ProcessAddrWayPt := false;

  // Lookup Messages
  LookUpWindow := FrmTripManager.Handle;
  LookUpMessage := UFrmTripManager.WM_ADDRLOOKUP;

  // XT2 Defaults
  ExploreUuid := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ExploreUuid', ExploreUuid);
  VehicleProfileGuid := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'VehicleProfileGuid', XT2_VehicleProfileGuid);
  VehicleProfileHash := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'VehicleProfileHash', XT2_VehicleProfileHash);
  VehicleId := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'VehicleId', XT2_VehicleId);

  WayPtList := TStringList.Create;
  try
    WayPtList.Text := ProcessCategoryPick;
    ProcessWpt := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessWpt', BooleanValues[true]) = BooleanValues[true]);
    WayPtCat := WayPtList.IndexOf(GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessCategory', WayPtList[WayPtList.Count -1]));
    ProcessCategory := [];
    if (ProcessWpt) then
    begin
      case WayPtCat of
        1: Include(ProcessCategory, pcSymbol);
        2: Include(ProcessCategory, pcGPX);
        3: begin
             Include(ProcessCategory, pcSymbol);
             Include(ProcessCategory, pcGPX);
            end;
      end;
    end;
  finally
    WayPtList.Free;
  end;
end;

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
    AGrid.Cells[2, ARow] := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, AKey, DefaultValue);
    ARow := ARow + 1;
  end;

begin
  GridGeneralSettings.RowCount := GridGeneralSettings.FixedRows +1;
  GridGeneralSettings.BeginUpdate;
  try

    CurRow := 1;
    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Window startup-');
    AddGridLine(GridGeneralSettings, CurRow, Maximized_Key,       'False', 'Start TripManager maximized');
    AddGridLine(GridGeneralSettings, CurRow, '');

    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Preferred device and folders-');
    AddGridLine(GridGeneralSettings, CurRow, PrefDev_Key,             XTName,                 'Default device to use');
    AddGridLine(GridGeneralSettings, CurRow, PrefDevTripsFolder_Key,  PrefDevTripsFolder_Val, 'Default trips folder');
    AddGridLine(GridGeneralSettings, CurRow, PrefDevGpxFolder_Key,    PrefDevGPXFolder_Val,   'Default GPX folder');
    AddGridLine(GridGeneralSettings, CurRow, PrefDevPoiFolder_Key,    PrefDevPoiFolder_Val,   'Default GPI folder');
    AddGridLine(GridGeneralSettings, CurRow, PrefFileSysFolder_Key,   PrefFileSysFolder_Val,  'Last used Windows folder');
    AddGridLine(GridGeneralSettings, CurRow, '');

    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Creating Way point files (*.gpx)-');
    AddGridLine(GridGeneralSettings, CurRow, 'FuncWayPointWpt',   'True',  'Add original Way points');
    AddGridLine(GridGeneralSettings, CurRow, 'FuncWayPointVia',   'False', 'Add Via points from route');
    AddGridLine(GridGeneralSettings, CurRow, 'FuncWayPointShape', 'False', 'Add Shaping points from route');
    AddGridLine(GridGeneralSettings, CurRow, '');

    AddGridLine(GridGeneralSettings, CurRow, '', '', '-Creating Poi files (*.gpi)-');
    AddGridLine(GridGeneralSettings, CurRow, 'FuncGpiWayPt',      'True', 'Add original Way points');
    AddGridLine(GridGeneralSettings, CurRow, 'FuncGpiViaPt',      'False', 'Add Via points from route');
    AddGridLine(GridGeneralSettings, CurRow, 'FuncGpiShpPt',      'False', 'Add Shaping points from route');
    GridGeneralSettings.RowCount := CurRow;

    AddGridHeader(GridGeneralSettings);

  finally
    GridGeneralSettings.EndUpdate;
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
    AddGridLine(GridGeoCodeSettings, CurRow, GeoCodeUrl,       GeoSettings.GeoCodeUrl,    'Open URL in a browser for more info.');
    AddGridLine(GridGeoCodeSettings, CurRow, GeoCodeApiKey,    GeoSettings.GeoCodeApiKey, 'Enter your API_Key here and click Validate');
    AddGridLine(GridGeoCodeSettings, CurRow, ThrottleGeoCode,  IntToStr(GeoSettings.ThrottleGeoCode), 'Minimum time in ms between calls');
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
    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key,
                     AGrid.Cells[0, Index], AGrid.Cells[2, Index]);
  end;
end;

procedure TFrmAdvSettings.SaveSettings;
begin
  SaveGrid(GridGeneralSettings);
  SaveGrid(GridXT2Settings);
  SaveGrid(GridGeoCodeSettings);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, AddressFormat,
                   ReplaceAll(MemoAddressFormat.Lines.Text, [#13#10], ['|'], [rfReplaceAll]));

  ReadGeoCodeSettings;
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

