unit UnitOSMMap;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  {$IFDEF VER350}
  Winapi.WebView2,
  {$ENDIF}
  Vcl.Edge;

function CreateOSMMapHtml(Home: string = ''; UseOl2Local: boolean = true): boolean; overload;
function CreateOSMMapHtml(HtmlName: string; TrackPoints: TStringList): boolean; overload;
function OSMColor(GPXColor: string): string;
procedure ParseJsonMessage(const Message: string; var Msg, Parm1, Parm2: string);

const
  OSM_Track_Width         = '5';
  OSM_Bounds_Width        = '2';
  OSM_Bounds_Color        = 'Black';
  OSM_Coord_Decimals      = 6;
  OSM_Place_Decimals      = 4;
  OSM_CtrlClick           = 'Ctrl Click';
  OSM_GetBounds           = 'GetBounds';
  OSM_GetRoutePoint       = 'GetRoutePoint';
  OSM_Base_Layer          = 'BaseLayer';
  OSM_Base_Layer_Changed  = 'BaseLayer_Changed';
  Reg_BaseLayer_Key       = 'BaseLayer';
  Reg_BaseLayer_Value     = 'Mapnik';
  Reg_MapTilerApi_Key     = 'MapTilerApiKey';
  Reg_EnableESRI          = 'EnableESRI';

type
  TOSMHelper = class(TObject)
  private
    HasData: boolean;
    OsmFormatSettings: TFormatSettings;
    Html: TStringList;
    FPathName: string;
    FHome: string;
    FTrackPoints: TStringList;
    procedure WriteHeader(const UseOl2Local: boolean);
    procedure WriteTrackPoints;
    procedure WriteFooter;
  public
    constructor Create(const APathName, AHome: string); overload;
    constructor Create(const APathName: string; ATrackPoints: TStringList); overload;
    destructor Destroy; override;
  end;

  {$IFDEF VER350}
  ICoreWebView2Settings2 = interface(ICoreWebView2Settings)
    ['{EE9A0F68-F46C-4E32-AC23-EF8CAC224D2A}']
    function Get_UserAgent(out UserAgent: PWideChar): HResult; stdcall;
    function Set_UserAgent(UserAgent: PWideChar): HResult; stdcall;
  end;
 {$ENDIF}

implementation

uses
  System.Variants, System.JSON, System.NetEncoding, System.Math, System.DateUtils, System.IOUtils,
  Winapi.Windows, Vcl.Dialogs,
  REST.Types, REST.Client, REST.Utils,
  UnitStringUtils, UnitRegistry;

var
  Ol2Installed: boolean;
  FTripManager_JS: TStringList;

function TripManager_JS: TStrings;
const
  Ol2BaseLayers = 'OL2_TripManager_JS';
var
  ResStream: TResourceStream;
begin
  if not Assigned(FTripManager_JS) then
  begin
    FTripManager_JS := TStringList.Create;

    ResStream := TResourceStream.Create(hInstance, Ol2BaseLayers, RT_RCDATA);
    try
      FTripManager_JS.LoadFromStream(ResStream);
    finally
      ResStream.Free;
    end;
  end;
  result := FTripManager_JS;
end;

function InstallOpenLayers2: boolean;
const
  Ol2Files: array[0..13,0..1] of string  = (
    ('OL2_OpenLayers',      'OpenLayers.js'),
    ('OL2_img_cpr',         'img\cloud-popup-relative.png'),
    ('OL2_img_em',          'img\east-mini.png'),
    ('OL2_img_lsmax',       'img\layer-switcher-maximize.png'),
    ('OL2_img_lsmin',       'img\layer-switcher-minimize.png'),
    ('OL2_img_nm',          'img\north-mini.png'),
    ('OL2_img_s',           'img\slider.png'),
    ('OL2_img_sm',          'img\south-mini.png'),
    ('OL2_img_wm',          'img\west-mini.png'),
    ('OL2_img_zmm',         'img\zoom-minus-mini.png'),
    ('OL2_img_zpm',         'img\zoom-plus-mini.png'),
    ('OL2_img_zb',          'img\zoombar.png'),
    ('OL2_thm_def_close',   'theme\default\img\close.gif'),
    ('OL2_thm_def_style',   'theme\default\style.css')
  );

var
  ResStream: TResourceStream;
  Index: integer;
begin
  result := false;
  try
    ForceDirectories(IncludeTrailingPathDelimiter(GetOSMTemp) + 'img');
    ForceDirectories(IncludeTrailingPathDelimiter(GetOSMTemp) + 'theme\default\img');
    for Index := 0 to High(Ol2Files) do
    begin
      ResStream := TResourceStream.Create(hInstance, Ol2Files[Index, 0], RT_RCDATA);
      try
        ResStream.SaveToFile(IncludeTrailingPathDelimiter(GetOSMTemp) + Ol2Files[Index, 1]);
      finally
        ResStream.Free;
      end;
    end;
    result := true;
  except on E:Exception do
    ShowMessage(E.Message);
  end;
end;

constructor TOSMHelper.Create(const APathName, AHome: string);
begin
  inherited Create;
  OsmFormatSettings.DecimalSeparator := '.'; // The decimal separator is a . PERIOD!
  OsmFormatSettings.NegCurrFormat := 11;
  FPathName := APathName;
  FHome := AHome;
  Html := TStringList.Create;
  HasData := false;
  FTrackPoints := nil;
end;

constructor TOSMHelper.Create(const APathName: string; ATrackPoints: TStringList);
begin
  Create(APathName, '');
  FTrackPoints := ATrackPoints;
end;

destructor TOSMHelper.Destroy;
begin
  FPathName := '';
  Html.Free;

  inherited Destroy;
end;

procedure TOSMHelper.WriteHeader(const UseOl2Local: boolean);
var
  ScriptLocation: string;
begin
  ScriptLocation := 'https://openlayers.org/api/';
  if (UseOl2Local) then
    ScriptLocation := '';

  HasData := false;
  Html.Clear;

  Html.Add('<html>');
  Html.Add('<head>');
  Html.Add('<title></title>');
  Html.Add(Format('<script type="text/javascript" src="%sOpenLayers.js"></script>', [ScriptLocation]));

  Html.Add('<script type="text/javascript">');
  Html.Add('');
  Html.Add('/** Parameters passed by TripManager **/');
  Html.Add(Format('var osm_MapTilerKey             = "%s";', [GetRegistry(Reg_MapTilerApi_Key, '')]));
  Html.Add(Format('var osm_ESRIEnabled             = "%s";', [GetRegistry(Reg_EnableESRI, '')]));
  Html.Add(Format('var osm_BaseLayer               = "%s";', [GetRegistry(Reg_BaseLayer_Key, Reg_BaseLayer_Value)]));
  Html.Add(Format('var osm_PlaceDecimals           = "%d";', [OSM_Place_Decimals]));
  Html.Add(Format('var osm_BoundsWidth             = "%s";', [OSM_Bounds_Width]));
  Html.Add(Format('var osm_TrackWidth              = "%s";', [OSM_Track_Width]));
  Html.Add(Format('var osm_BaseLayerChangedEvent   = "%s";', [OSM_Base_Layer_Changed]));
  Html.Add(Format('var osm_CtrlClickEvent          = "%s";', [OSM_CtrlClick]));
  Html.Add(Format('var osm_GetBoundsEvent          = "%s";', [OSM_GetBounds]));
  Html.Add(Format('var osm_GetRoutePoint           = "%s";', [OSM_GetRoutePoint]));

  Html.Add('');

  Html.Add(TripManager_JS.Text);
end;

procedure TOSMHelper.WriteTrackPoints;
var
  F: TStringList;
  Fs: TSearchRec;
  Rc: integer;
begin
  Html.Add('  function AddTrackPoints(){');
  if (FHome <> '') then
  begin
    Html.Add('  AddTrkPoint(' + FHome + ');');
    HasData := true;
  end;
  if (FTrackPoints <> nil) then
  begin
    Html.AddStrings(FTrackPoints);
  end
  else
  begin
    Rc := System.SysUtils.FindFirst(GetTracksTmp, faAnyFile - faDirectory, Fs);
    while (Rc = 0) do
    begin
      F := TStringList.Create;
      try
        F.LoadFromFile(IncludeTrailingPathDelimiter(ExtractFileDir(GetTracksTmp)) + Fs.Name);
        if (F.Count > 0) then
        begin
          HasData := true;
          Html.AddStrings(F);
        end;
      finally
        F.Free;
      end;
      Rc := System.SysUtils.FindNext(Fs);
    end;
  end;
  Html.Add('  }');
end;

procedure TOSMHelper.WriteFooter;
begin
  WriteTrackPoints;

  Html.Add('</script>');
  Html.Add('</head>');
  Html.Add('<body onload="initialize()">');
  Html.Add('<div id="map_canvas" style="width: 100%; height: 100%"></div>');
  Html.Add('</body>');
  Html.Add('</html>');

  Html.SaveToFile(FPathName, TEncoding.UTF8);
end;

function CreateOSMMapHtml(Home: string = ''; UseOl2Local: boolean = true): boolean;
var
  OsmHelper: TOSMHelper;
begin
  if (UseOl2Local) then
  begin
    if not Ol2Installed then
      Ol2Installed := InstallOpenLayers2;
    if not Ol2Installed then
      UseOl2Local := false;
  end;

  OsmHelper := TOSMHelper.Create(GetHtmlTmp, Home);
  try
    OsmHelper.WriteHeader(UseOl2Local);
    OsmHelper.WriteFooter;
    result := OsmHelper.HasData;
  finally
    OsmHelper.Free;
  end;
end;

function CreateOSMMapHtml(HtmlName: string; TrackPoints: TStringList): boolean; overload;
var
  OsmHelper: TOSMHelper;
begin
  OsmHelper := TOSMHelper.Create(HtmlName, TrackPoints);
  try
    OsmHelper.WriteHeader(false);
    OsmHelper.WriteFooter;
    result := OsmHelper.HasData;
  finally
    OsmHelper.Free;
  end;
end;

function OSMColor(GPXColor: string): string;
begin
  result := Format('#%s', [GPX2HTMLColor(GPXColor)]);
end;

procedure ParseJsonMessage(const Message: string; var Msg, Parm1, Parm2: string);
var
  JSONValue: TJSONValue;
begin
  JSONValue := TJSonObject.ParseJSONValue(Message);
  try
    Msg := JSONValue.GetValue<string>('msg');
    Parm1 := JSONValue.GetValue<string>('parm1');
    Parm2 := JSONValue.GetValue<string>('parm2');
  finally
    JSONValue.Free;
  end;
end;

initialization
begin
  Ol2Installed := false;
  FTripManager_JS := nil;
end;

finalization
begin
  FTripManager_JS.Free;
end;

end.
