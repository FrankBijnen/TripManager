unit UnitOSMMap;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.IniFiles,
  Vcl.Edge;

function CreateOSMMapHtml(Home: string = ''; UseOl2Local: boolean = true): boolean; overload;
function CreateOSMMapHtml(HtmlName: string; TrackPoints: TStringList): boolean; overload;
function OSMColor(GPXColor: string): string;
procedure ParseJsonMessage(const Message: string; var Msg, Parm1, Parm2: string);

type TMapLayer = record
  ClassName: string;
  Description: string;
end;

type TMapTilerLayer = record
  Resource: string;
  Style: string;
  Description: string;
end;

const
  Coord_Decimals    = 6;
  Place_Decimals    = 4;
  OSMCtrlClick      = 'Ctrl Click';
  OSMGetBounds      = 'GetBounds';
  OSMGetRoutePoint  = 'GetRoutePoint';
  BaseLayer         = 'BaseLayer';
  OSMMapLayer: TMapLayer
                    =   (ClassName: 'OSM.Mapnik';          Description: 'Mapnik');


  MapTilerLayers:  array[0..3] of TMapTilerLayer
                    = ( (Resource: 'tiles'; Style: 'satellite-v2';  Description: 'Map Tiler Satellite'),
                        (Resource: 'maps';  Style: 'streets-v2';    Description: 'Map Tiler Streets'),
                        (Resource: 'maps';  Style: 'topo-v2';       Description: 'Map Tiler Topo'),
                        (Resource: 'maps';  Style: 'bright-v2';     Description: 'Map Tiler Bright')
                      );

  XYZMapLayers:  array[0..1] of TMapLayer
                    = ( (ClassName: 'XYZ.OpenTopoMap';     Description: 'Open Topo Map'),
                        (ClassName: 'XYZ.TOPPlusOpen';     Description: 'TOP Plus Open')
                      );
  ESRIMapLayers: array[0..0] of TMapLayer
                    = ( (ClassName: 'XYZ.ESRISatellite';   Description: 'ESRI Satellite')
                      );

  Reg_BaseLayer_Key = 'BaseLayer';
  Reg_MapTilerApi_Key = 'MapTilerApiKey';
  Reg_EnableESRI = 'EnableESRI';

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

implementation

uses
  System.Variants, System.JSON, System.NetEncoding, System.Math, System.DateUtils, System.IOUtils,
  Winapi.Windows, Vcl.Dialogs,
  REST.Types, REST.Client, REST.Utils,
  UnitStringUtils, UnitRegistry;

var
  Ol2Installed: boolean;

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
  AMapLayer: TMapLayer;
  AMapTilerLayer: TMapTilerLayer;
  MapTilerKey: string;
begin
  HasData := false;
  Html.Clear;

  Html.Add('<html>');
  Html.Add('<head>');
  Html.Add('<title></title>');
  if (UseOl2Local) then
  begin
    Html.Add('<script type="text/javascript" src="OpenLayers.js"></script>');
    Html.Add('<script type="text/javascript" src="BaseLayers.js"></script>');
  end
  else
  begin
    Html.Add('<script type="text/javascript" src="https://openlayers.org/api/OpenLayers.js"></script>');
    Html.Add('<script type="text/javascript" src="https://www.openstreetmap.org/openlayers/OpenStreetMap.js"></script>');
  end;
  Html.Add('<script type="text/javascript">');
  Html.Add('var map;');
  Html.Add('var BaseLayers;');
  Html.Add('var RoutePointsLayer;');
  Html.Add('var POILayer;');
  Html.Add('var allpoints;');       // Needed for CreateExtent
  Html.Add('var routepoints;');     // All route points
  Html.Add('var trackpoints;');     // Trackpoints
  Html.Add('var poipoints;');       // All POIs
  Html.Add('var timeoutId = null;');
  Html.Add('var popup = null;');
  Html.Add('var style;');

  Html.Add('var po;');
  Html.Add('var op;');
  Html.Add('var cacheWrite, cacheRead;');

  Html.Add('');
  Html.Add('  function initialize()');
  Html.Add('  {');
  Html.Add('     map = new OpenLayers.Map ("map_canvas", {');
  Html.Add('           controls:         [new OpenLayers.Control.Navigation(),');
  Html.Add('                              new OpenLayers.Control.PanZoomBar(),');
  Html.Add('                              new OpenLayers.Control.LayerSwitcher(),');
  Html.Add('                              new OpenLayers.Control.Attribution()');
  Html.Add('                             ],');
  Html.Add('           maxResolution:    156543.0399,');
  Html.Add('           numZoomLevels:    10,');
  Html.Add('           units:            "m",');
  Html.Add('           projection:       new OpenLayers.Projection("EPSG:900913"),');

  Html.Add('           eventListeners: {');
  Html.Add('              featureover: function(e) {');
  Html.Add('              e.feature.renderIntent = "select";');
  Html.Add('              e.feature.layer.drawFeature(e.feature);');
  Html.Add('              var parm1 = (e.feature.layer.name) ? e.feature.layer.name : "";');
  Html.Add('              var parm2 = (e.feature.url) ? e.feature.url : "";');
  Html.Add('              SendMessage("' + OSMGetRoutePoint + '", parm1, parm2);');
  Html.Add('              }');
  Html.Add('           },');
  Html.Add('           displayProjection:new OpenLayers.Projection("EPSG:4326")});');
  Html.Add('');

  Html.Add('     cacheWrite = new OpenLayers.Control.CacheWrite();');
  Html.Add('     map.addControl(cacheWrite);');
  Html.Add('     cacheRead = new OpenLayers.Control.CacheRead();');
  Html.Add('     map.addControl(cacheRead);');

  // Add Mapnik layer
  Html.Add('     var BaseLayers = new Array();');
  Html.Add(Format('     map.addLayer(BaseLayers[BaseLayers.push(new OpenLayers.Layer.%s("%s")) -1]);',
           [OSMMapLayer.ClassName, OSMMapLayer.Description]));

  if (UseOl2Local) then
  begin
    // Add Map Tiler layers
    MapTilerKey := GetRegistry(Reg_MapTilerApi_Key, '');
    if (MapTilerKey <> '') then
      for AMapTilerLayer in MapTilerLayers do
        Html.Add(Format('     map.addLayer(BaseLayers[BaseLayers.push(new OpenLayers.Layer.XYZ.MapTiler("%s", "%s", "%s", "%s")) -1]);',
                 [AMapTilerLayer.Description, AMapTilerLayer.Resource, AMapTilerLayer.Style, MapTilerKey]));

    // Add Undocumented ESRI Base layers
    if (GetRegistry(Reg_EnableESRI, '') <> '') then
      for AMapLayer in ESRIMapLayers do
      Html.Add(Format('     map.addLayer(BaseLayers[BaseLayers.push(new OpenLayers.Layer.%s("%s")) -1]);',
               [AMapLayer.ClassName, AMapLayer.Description]));

    // Add 'Open' Base layers
    for AMapLayer in XYZMapLayers do
      Html.Add(Format('     map.addLayer(BaseLayers[BaseLayers.push(new OpenLayers.Layer.%s("%s")) -1]);',
               [AMapLayer.ClassName, AMapLayer.Description]));

    // Select Base layer
    Html.Add(Format('     map.setBaseLayer(map.getLayersBy("name", "%s")[0]);',
                    [GetRegistry(Reg_BaseLayer_Key, OSMMapLayer.Description)]));

    // base layer changed event
    Html.Add('     map.events.register("changebaselayer", map, function(event) {');
    Html.Add('       SendMessage("' + BaseLayer + '", event.layer.name, "");');
    Html.Add('     });');
  end;

  Html.Add('     po = map.getProjectionObject();');
  Html.Add('     op = new OpenLayers.Projection("EPSG:4326");');

  Html.Add('     map.events.listeners.mousedown.unshift({');
  Html.Add('        func: function(e){');
  Html.Add('           if (e.ctrlKey) {');
  Html.Add('              var lonlat = map.getLonLatFromViewPortPx(e.xy).transform(po, op);');
  Html.Add('              SendMessage("' + OSMCtrlClick + '", lonlat.lat, lonlat.lon);');
  Html.Add('            }');
  Html.Add('        }');
  Html.Add('     });');

  Html.Add('     map.events.register(''moveend'', map, function(evt) {');
  Html.Add('       GetBounds("' + OSMGetBounds + '");');
  Html.Add('     })');

  Html.Add('     allpoints = new Array();');
  Html.Add('     routepoints = new Array();');
  Html.Add('     trackpoints = new Array();');
  Html.Add('     RtePts = new Array();');
  Html.Add('     RoutePointsLayer = new Array();');
  Html.Add('     POILayer = new Array();');
  Html.Add('     poipoints = new Array();');
  Html.Add('');
  Html.Add('     AddTrackPoints();');
  Html.Add('     CreateExtent(map.getNumZoomLevels() * 0.66);');
  Html.Add('  }');

  Html.Add('  function SendMessage(msg, parm1, parm2){');
  Html.Add('     if (window && window.chrome)');
  Html.Add('        window.chrome.webview.postMessage({ msg: msg, parm1: parm1, parm2: parm2});');
  Html.Add('  }');

  Html.Add('  function GetLocation(Func){');
  Html.Add('     var bounds = map.getExtent();');
  Html.Add('     var lonlat = bounds.getCenterLonLat().transform(po, op);');
  Html.Add('     SendMessage(Func, lonlat.lat, lonlat.lon);');
  Html.Add('  }');

  Html.Add('  function GetBounds(Func){');
  Html.Add('     var bounds = map.getExtent();');
  Html.Add('     bounds.transform(po, op);');
  Html.Add('     var lonlat = bounds.getCenterLonLat();');
  Html.Add('     SendMessage(Func, bounds.toBBOX(' + IntToStr(Place_Decimals) + ', true), lonlat.lat + ", " + lonlat.lon);');
  Html.Add('  }');

  Html.Add('  function CreateExtent(MaxZoomLevel){');
  Html.Add('     allpoints = allpoints.concat(trackpoints);');
  Html.Add('     allpoints = allpoints.concat(routepoints);');
  Html.Add('     allpoints = allpoints.concat(poipoints);');
  Html.Add('     var line_string = new OpenLayers.Geometry.LineString(allpoints);');
  Html.Add('     allpoints = new Array();'); // Remove from memory
  Html.Add('     var bounds = new OpenLayers.Bounds();');
  Html.Add('     line_string.calculateBounds();');
  Html.Add('     bounds.extend(line_string.bounds);');
  Html.Add('     map.zoomToExtent(bounds);');
  Html.Add('     if (map.getZoom() > MaxZoomLevel){');
  Html.Add('       map.zoomTo(MaxZoomLevel);');
  Html.Add('     }');
  Html.Add('  }');

  // OpenLayers uses LonLat, not LatLon. Confusing maybe,
  Html.Add('  function PopupAtPoint(Href, PointLat, PointLon, ZoomToPoint, PopupTimeOut){');
  Html.Add('     var lonlat = new OpenLayers.LonLat(PointLon, PointLat).transform(op, po);');
  Html.Add('     if (ZoomToPoint) { map.moveTo(lonlat, map.getNumZoomLevels() -4, null) };');
  Html.Add('     if (Href) {');
  Html.Add('       popup = new OpenLayers.Popup.FramedCloud("Popup", lonlat, null, Href, null, true);');
  Html.Add('       map.addPopup(popup, true);');
  Html.Add('       if (timeoutId) { clearTimeout(timeoutId) };');
  Html.Add('       timeoutId = setTimeout(RemovePopup, PopupTimeOut);');
  Html.Add('     };');
  Html.Add('  }');

  Html.Add('  function RemovePopup(){');
  Html.Add('     if (popup) { map.removePopup(popup); popup = null};');
  Html.Add('  }');

  Html.Add('  function AddRoutePoint(IdLayer, LayerName, RoutePointName, PointLat, PointLon, Color){');
  Html.Add('     var lonlat = new OpenLayers.LonLat(PointLon, PointLat).transform(op, po);');
  Html.Add('     var feature = new OpenLayers.Feature.Vector(');
  Html.Add('         new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat))');
  Html.Add('     feature.url = RoutePointName;'); // Use URL for routepoint name
  Html.Add('     if (!RoutePointsLayer[IdLayer]) {');
  Html.Add('        RoutePointsLayer[IdLayer] = new OpenLayers.Layer.Vector(LayerName,');
  Html.Add('            { styleMap: new OpenLayers.StyleMap( { pointRadius: 6, fillColor: Color, fillOpacity: 0.5 } ) }); ');
  Html.Add('     }');
  Html.Add('     RoutePointsLayer[IdLayer].addFeatures(feature);');
  Html.Add('     RoutePointsLayer[IdLayer].displayInLayerSwitcher = true;');
  Html.Add('     map.addLayer(RoutePointsLayer[IdLayer]);');
  // routepoints needed for CreateExtent
  Html.Add('     routepoints[IdLayer] = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);');
  Html.Add('  }');

  Html.Add('  function AddPOI(Id, PoiName, PointLat, PointLon, ImageFile){');
  Html.Add('     var lonlat = new OpenLayers.LonLat(PointLon, PointLat).transform(op, po);');
  Html.Add('     POILayer[Id] = new OpenLayers.Layer.Vector(PoiName, {');
  Html.Add('         styleMap: new OpenLayers.StyleMap({');
  Html.Add('             externalGraphic: ImageFile,');
  Html.Add('             graphicWidth: 20, graphicHeight: 20, graphicXOffset: -10, graphicYOffset: -10,');
  Html.Add('             title: PoiName');
  Html.Add('         })');
  Html.Add('     });');
  Html.Add('     POILayer[Id].displayInLayerSwitcher = false;');

  Html.Add('');
  Html.Add('     var myLocation = new OpenLayers.Geometry.Point(PointLon, PointLat)');
  Html.Add('         .transform(''EPSG:4326'', ''EPSG:3857'');');
  Html.Add('');
  Html.Add('     POILayer[Id].addFeatures([new OpenLayers.Feature.Vector(myLocation, {tooltip: ''OpenLayers''})]);');
  Html.Add('     map.addLayer(POILayer[Id]);');

  // poipoints needed for CreateExtent
  Html.Add('     poipoints[Id] = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);');
  Html.Add('  };');

  Html.Add('  function AddTrkPoint(Id, PointLat, PointLon){');
  Html.Add('     var lonlat = new OpenLayers.LonLat(PointLon, PointLat).transform(op, po);');
  Html.Add('     trackpoints[Id] = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);');
  Html.Add('  }');

  Html.Add('  function CreateTrack(linename, color){');
  Html.Add('     linelayer = new OpenLayers.Layer.Vector(linename);');
  Html.Add('     style = {strokeColor: color, strokeOpacity: 0.6, fillOpacity: 0, strokeWidth: 5};');
  Html.Add('     var line_string = new OpenLayers.Geometry.LineString(trackpoints);');
  Html.Add('     var linefeature = new OpenLayers.Feature.Vector(line_string, null, style);');
  Html.Add('     linelayer.addFeatures([linefeature]);');
  Html.Add('     map.addLayer(linelayer);');

  // Add trackpoints to allpoints. Needed for CreateExtent
  Html.Add('     allpoints = allpoints.concat(trackpoints);');
  Html.Add('     trackpoints = new Array();');
  Html.Add('  }');
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
    Html.Add('  AddTrkPoint(1, ' + FHome + ');');
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

function InstallOpenLayers2: boolean;
const
  Ol2Files: array[0..14,0..1] of string  = (
    ('OL2_OpenLayers',      'OpenLayers.js'),
    ('OL2_BaseLayers',      'BaseLayers.js'),
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
end;

end.
