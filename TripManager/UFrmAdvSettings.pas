unit UFrmAdvSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.ValEdit, Vcl.ComCtrls;

const
  TripManagerReg_Key      = 'Software\TDBware\TripManager';
  PrefFileSysFolder_Key   = 'PrefFileSysFolder';
  PrefDev_Key             = 'PrefDevice';
  PrefDevTripsFolder_Key  = 'PrefDeviceTripsFolder';
  PrefDevGpxFolder_Key    = 'PrefDeviceGpxFolder';
  PrefDevPoiFolder_Key    = 'PrefDevicePoiFolder';
  WarnModel_Key           = 'WarnModel';
  TripColor_Key           = 'TripColor';

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
    PnlAddressFormat: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSettings;
    procedure SaveSettings;
  public
    { Public declarations }
    procedure SetFixedPrefs;
  end;

var
  FrmAdvSettings: TFrmAdvSettings;

implementation

uses
  UnitStringUtils, UFrmTripManager, UnitGeoCode, UnitGpx, UnitGpi, UnitTripObjects;

{$R *.dfm}

procedure TFrmAdvSettings.SetFixedPrefs;
var
  ProcessWpt: boolean;
  WayPtCat: integer;
  WayPtList: TStringList;
begin
  EnableBalloon := false;
  EnableTimeout := false;
  TimeOut := 0;
  MaxTries := 0;
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
  ProcessShape := false;
  ShapingPointName := TShapingPointName.Unchanged;

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

procedure TFrmAdvSettings.LoadSettings;

  procedure AddKey(VLEditor: TValueListEditor; AKey: string; DefaultValue: string = '');
  begin
    VLEditor.Strings.AddPair(AKey, GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, AKey, DefaultValue));
  end;

begin
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

procedure TFrmAdvSettings.SaveSettings;
var
  Index: integer;
begin
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

procedure TFrmAdvSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    SaveSettings;
end;

procedure TFrmAdvSettings.FormShow(Sender: TObject);
begin
  LoadSettings;
  PctMain.ActivePage := TabXT2;
end;

end.
