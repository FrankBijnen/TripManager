unit UFrmAdvSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.ValEdit, Vcl.ComCtrls,
  UnitGeoCode, Vcl.Menus;

const
  TripManagerReg_Key      = 'Software\TDBware\TripManager';
  PrefFileSysFolder_Key   = 'PrefFileSysFolder';
  PrefDev_Key             = 'PrefDevice';
  PrefDevTripsFolder_Key  = 'PrefDeviceTripsFolder';
  PrefDevGpxFolder_Key    = 'PrefDeviceGpxFolder';
  PrefDevPoiFolder_Key    = 'PrefDevicePoiFolder';
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
    VlXT2Settings: TValueListEditor;
    TabGeoCode: TTabSheet;
    VlGeoCodeSettings: TValueListEditor;
    MemoAddressFormat: TMemo;
    PnlResult: TPanel;
    MemoResult: TMemo;
    PnlAddressFormatTop: TPanel;
    Splitter1: TSplitter;
    PnlAddressFormat: TPanel;
    BtnClearCoordCache: TButton;
    BtnBuilder: TButton;
    PopupBuilder: TPopupMenu;
    Clear1: TMenuItem;
    N1: TMenuItem;
    StatePlaceRoadnr1: TMenuItem;
    NrRoadPlaceState1: TMenuItem;
    N2: TMenuItem;
    Housenbr1: TMenuItem;
    Road1: TMenuItem;
    Smallestplace1: TMenuItem;
    Largestplace1: TMenuItem;
    State1: TMenuItem;
    Countrycode1: TMenuItem;
    Countrycode2: TMenuItem;
    N3: TMenuItem;
    Debug1: TMenuItem;
    Hamlet1: TMenuItem;
    Village1: TMenuItem;
    N4: TMenuItem;
    City1: TMenuItem;
    postalcode1: TMenuItem;
    City2: TMenuItem;
    municipality1: TMenuItem;
    N5: TMenuItem;
    TabGeneral: TTabSheet;
    VlGeneralSettings: TValueListEditor;
    Coords1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure MemoAddressFormatChange(Sender: TObject);
    procedure VlGeoCodeSettingsStringsChange(Sender: TObject);
    procedure BtnClearCoordCacheClick(Sender: TObject);
    procedure BtnBuilderMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Clear1Click(Sender: TObject);
    procedure StatePlaceRoadnr1Click(Sender: TObject);
    procedure NrRoadPlaceState1Click(Sender: TObject);
    procedure Smallestplace1Click(Sender: TObject);
    procedure Largestplace1Click(Sender: TObject);
    procedure AddTag(Sender: TObject);
  private
    { Private declarations }
    SamplePlace: TPlace;
    procedure LoadSettings;
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

procedure TFrmAdvSettings.VlGeoCodeSettingsStringsChange(Sender: TObject);
begin
  if (GeoSettings.GeoCodeApiKey <> VlGeoCodeSettings.Values[GeoCodeApiKey]) then
  begin
    GeoSettings.GeoCodeApiKey := VlGeoCodeSettings.Values[GeoCodeApiKey];
    MemoAddressFormat.Enabled := (GeoSettings.GeoCodeApiKey <> '');
    SamplePlace := nil;
    MemoAddressFormatChange(MemoAddressFormat);
  end;
end;

procedure TFrmAdvSettings.Largestplace1Click(Sender: TObject);
begin
  MemoAddressFormat.Lines.Add('municipality,city,town,village,hamlet');
end;

procedure TFrmAdvSettings.LoadSettings;

  procedure AddKey(VLEditor: TValueListEditor; AKey: string; DefaultValue: string = '');
  begin
    VLEditor.Strings.AddPair(AKey, GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, AKey, DefaultValue));
  end;

begin
  VlGeneralSettings.Strings.BeginUpdate;
  try
    VlGeneralSettings.Strings.Clear;
    AddKey(VlGeneralSettings, '-Window startup-');
    AddKey(VlGeneralSettings, Maximized_Key,    'False');
    AddKey(VlGeneralSettings, '-');

    AddKey(VlGeneralSettings, '-Creating Way point files (*.gpx)-');
    AddKey(VlGeneralSettings, 'FuncWayPointWpt',    'True');
    AddKey(VlGeneralSettings, 'FuncWayPointVia',    'False');
    AddKey(VlGeneralSettings, 'FuncWayPointShape',  'False');
    AddKey(VlGeneralSettings, '-');

    AddKey(VlGeneralSettings, '-Creating Poi files (*.gpi)-');
    AddKey(VlGeneralSettings, 'FuncGpiWayPt',       'False');
    AddKey(VlGeneralSettings, 'FuncGpiViaPt',       'False');
    AddKey(VlGeneralSettings, 'FuncGpiShpPt',       'False');
    AddKey(VlGeneralSettings, '-');
  finally
    VlGeneralSettings.Strings.EndUpdate;
  end;

  VlXT2Settings.Strings.BeginUpdate;
  try
    VlXT2Settings.Strings.Clear;
    AddKey(VlXT2Settings, 'ExploreUuid');       // No default
    AddKey(VlXT2Settings, 'VehicleProfileGuid', XT2_VehicleProfileGuid);
    AddKey(VlXT2Settings, 'VehicleProfileHash', XT2_VehicleProfileHash);
    AddKey(VlXT2Settings, 'VehicleId',          XT2_VehicleId);
  finally
    VlXT2Settings.Strings.EndUpdate;
  end;

  ReadGeoCodeSettings;
  VlGeoCodeSettings.Strings.BeginUpdate;
  try
    VlGeoCodeSettings.Strings.Clear;
    AddKey(VlGeoCodeSettings, GeoCodeUrl,       GeoSettings.GeoCodeUrl);
    AddKey(VlGeoCodeSettings, GeoCodeApiKey,    GeoSettings.GeoCodeApiKey);
    AddKey(VlGeoCodeSettings, ThrottleGeoCode,  IntToStr(GeoSettings.ThrottleGeoCode));
  finally
    VlGeoCodeSettings.Strings.EndUpdate;
  end;
  MemoAddressFormat.Lines.Text := ReplaceAll(GeoSettings.AddressFormat, ['|'], [#13#10], [rfReplaceAll]);
end;

procedure TFrmAdvSettings.MemoAddressFormatChange(Sender: TObject);
begin
  if (SamplePlace = nil) and
     (GeoSettings.GeoCodeApiKey <> '') and
     (ValidLatLon(SampleLat, SampleLon)) then
    SamplePlace := GetPlaceOfCoords(SampleLat, SampleLon);

  GeoSettings.AddressFormat := ReplaceAll(MemoAddressFormat.Lines.Text, [#13#10], ['|'], [rfReplaceAll]);
  if (SamplePlace <> nil) then
    MemoResult.lines.Text := SamplePlace.DisplayPlace;
end;

procedure TFrmAdvSettings.NrRoadPlaceState1Click(Sender: TObject);
begin
    MemoAddressFormat.Lines.Text := DefHouseRoad + #10 + DefCity + #10 + DefState;
end;

procedure TFrmAdvSettings.SaveSettings;
var
  Index: integer;
begin
  for Index := 0 to VlGeneralSettings.Strings.Count -1 do
  begin
    if (Copy(VlGeneralSettings.Strings.KeyNames[Index], 1, 1) = '-') then
      continue;
    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key,
                     VlGeneralSettings.Strings.KeyNames[Index], VlGeneralSettings.Strings.ValueFromIndex[Index]);
  end;

  for Index := 0 to VlXT2Settings.Strings.Count -1 do
  begin
    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key,
                     VlXT2Settings.Strings.KeyNames[Index], VlXT2Settings.Strings.ValueFromIndex[Index]);
  end;

  for Index := 0 to VlGeoCodeSettings.Strings.Count -1 do
  begin
    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key,
                     VlGeoCodeSettings.Strings.KeyNames[Index], VlGeoCodeSettings.Strings.ValueFromIndex[Index]);
  end;
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
  if (MessageDlg('Clear the cache?', TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> MB_OK) then
    exit;

  ClearCoordCache;
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

