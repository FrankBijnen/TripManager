unit UnitOSMMap;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.IniFiles,
  Vcl.Edge;

procedure ShowMap(Browser: TEdgeBrowser);
procedure ParseJsonMessage(const Message: string; var Msg, Parm1, Parm2: string);

const
  Coord_Decimals    = 6;
  Place_Decimals    = 4;
  OSMCtrlClick      = 'Ctrl Click';
  OSMGetBounds      = 'GetBounds';
  OSMGetRoutePoint  = 'GetRoutePoint';
  InitialZoom_Point = '15';
  InitialZoom_Out   = '16';
  InitialZoom_In    = '20';
  PopupTimeout      = '3000';

type
  TOSMHelper = class(TObject)
  private
    Scaled: integer;
    OsmFormatSettings: TFormatSettings;
    Html: TStringList;
    FInitialZoom: string;
    FPathName: string;
    procedure WriteHeader;
    procedure WriteTrackPoints;
    procedure WriteFooter;
  public
    constructor Create(const APathName, AInitialZoom: string);
    destructor Destroy; override;
  end;

implementation

uses
  System.Variants, System.JSON,  System.NetEncoding, System.Math, System.DateUtils, System.IOUtils,
  Winapi.Windows, Vcl.Dialogs,
  REST.Types, REST.Client, REST.Utils,
  UnitStringUtils;

constructor TOSMHelper.Create(const APathName, AInitialZoom: string);
begin
  inherited Create;
  OsmFormatSettings.DecimalSeparator := '.'; // The decimal separator is a . PERIOD!
  OsmFormatSettings.NegCurrFormat := 11;
  FPathName := APathName;
  FInitialZoom := AInitialZoom;
  Html := TStringList.Create;
end;

destructor TOSMHelper.Destroy;
begin
  FPathName := '';
  Html.Free;

  inherited Destroy;
end;

procedure TOSMHelper.WriteHeader;
begin
  Html.Clear;

  Html.Add('<Html>');
  Html.Add('<head>');
  Html.Add('<title></title>');
  Html.Add('<script type="text/javascript"  src="https://openlayers.org/api/OpenLayers.js"></script>');
  Html.Add('<script src="https://www.openstreetmap.org/openlayers/OpenStreetMap.js"></script>');
  Html.Add('<script type="text/javascript">');
  Html.Add('var map;');
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
  Html.Add('              SendMessage("' + OSMGetRoutePoint + '", e.feature.layer.name, e.feature.layer.displayInLayerSwitcher);');
  Html.Add('              }');
  Html.Add('           },');
  Html.Add('           displayProjection:new OpenLayers.Projection("EPSG:4326")});');
  Html.Add('');

  Html.Add('     cacheWrite = new OpenLayers.Control.CacheWrite();');
  Html.Add('     map.addControl(cacheWrite);');
  Html.Add('     cacheRead = new OpenLayers.Control.CacheRead();');
  Html.Add('     map.addControl(cacheRead);');

  Html.Add('     map.addLayer(new OpenLayers.Layer.OSM.Mapnik("Mapnik"));');
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
  Html.Add('     CreateExtent(' + FInitialZoom + ');');
  Html.Add('  }');

  Html.Add('  function SendMessage(msg, parm1, parm2){');
  Html.Add('     window.chrome.webview.postMessage({ msg: msg, parm1: parm1, parm2: parm2});');
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

  Html.Add('  function CreateExtent(ZoomLevel){');
  Html.Add('     allpoints = allpoints.concat(trackpoints);');
  Html.Add('     allpoints = allpoints.concat(routepoints);');
  Html.Add('     allpoints = allpoints.concat(poipoints);');
  Html.Add('     var line_string = new OpenLayers.Geometry.LineString(allpoints);');
  Html.Add('     allpoints = new Array();'); // Remove from memory

  Html.Add('     var bounds = new OpenLayers.Bounds();');
  Html.Add('     line_string.calculateBounds();');
  Html.Add('     bounds.extend(line_string.bounds);');
  Html.Add('     map.zoomToExtent(bounds);');
  Html.Add('     if (map.getZoom() > ZoomLevel){');
  Html.Add('       map.zoomTo(ZoomLevel);');
  Html.Add('     }');
  Html.Add('  }');

  // OpenLayers uses LonLat, not LatLon. Confusing maybe,
  Html.Add('  function PopupAtPoint(Href, PointLat, PointLon){');
  Html.Add('     var lonlat = new OpenLayers.LonLat(PointLon, PointLat).transform(op, po);');
  Html.Add('     var line_string = new OpenLayers.Geometry.LineString(new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat));');
  Html.Add('     line_string.calculateBounds();');
  Html.Add('     var bounds = new OpenLayers.Bounds();');
  Html.Add('     bounds.extend(line_string.bounds);');
  Html.Add('     map.zoomToExtent(bounds);');
  Html.Add('     map.zoomTo(' + InitialZoom_Point + ');');
  Html.Add('     if (Href) {');
  Html.Add('       popup = new OpenLayers.Popup.FramedCloud("Popup", lonlat, null, Href, null, true);');
  Html.Add('       map.addPopup(popup, true);');
  Html.Add('       if (timeoutId) { clearTimeout(timeoutId) };');
  Html.Add('       timeoutId = setTimeout(RemovePopup, ' + PopupTimeout + ');');
  Html.Add('     };');
  Html.Add('  }');

  Html.Add('  function RemovePopup(){');
  Html.Add('     if (popup) { map.removePopup(popup); popup = null};');
  Html.Add('  }');

  Html.Add('  function AddRoutePoint(Id, RoutePoint, PointLat, PointLon, Color){');
  Html.Add('     var lonlat = new OpenLayers.LonLat(PointLon, PointLat).transform(op, po);');
  Html.Add('     var feature = new OpenLayers.Feature.Vector(');
  Html.Add('         new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat))');
  Html.Add('     RoutePointsLayer[Id] = new OpenLayers.Layer.Vector(RoutePoint,');
  Html.Add('         { styleMap: new OpenLayers.StyleMap( { pointRadius: 6, fillColor: Color, fillOpacity: 0.5 } ) }); ');
  Html.Add('     RoutePointsLayer[Id].addFeatures(feature);');
  Html.Add('     RoutePointsLayer[Id].displayInLayerSwitcher = false;');
  Html.Add('     map.addLayer(RoutePointsLayer[Id]);');

  // routepoints needed for CreateExtent
  Html.Add('     routepoints[Id] = new OpenLayers.Geometry.Point(lonlat.lon, lonlat.lat);');
  Html.Add('  }');

  Html.Add('  function AddPOI(Id, PoiName, PointLat, PointLon, ImageFile){');
  Html.Add('     var lonlat = new OpenLayers.LonLat(PointLon, PointLat).transform(op, po);');
  Html.Add('     POILayer[Id] = new OpenLayers.Layer.Vector(PoiName, {');
  Html.Add('         styleMap: new OpenLayers.StyleMap({');
  Html.Add('             externalGraphic: ImageFile,');
  Html.Add('             graphicWidth: 20, graphicHeight: 20, graphicYOffset: -20,');
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

  Rc := System.SysUtils.FindFirst(GetTracksTmp, faAnyFile - faDirectory, Fs);
  while (Rc = 0) do
  begin
    F := TStringList.Create;
    try
      F.LoadFromFile(IncludeTrailingPathDelimiter(ExtractFileDir(GetTracksTmp)) + Fs.Name);
      Html.AddStrings(F);
    finally
      F.Free;
    end;
    Rc := System.SysUtils.FindNext(Fs);
  end;
  Html.Add('  }');
end;

procedure TOSMHelper.WriteFooter;
begin
  WriteTrackPoints;

  Html.Add('</script>');
  Html.Add('</head>');
  Html.Add('<body onload="initialize()" >');
  Html.Add('  <div id="map_canvas" style="width: 100%; height: 100%"></div>');
  Html.Add('</body>');
  Html.Add('</html>');

  Html.SaveToFile(FPathName, TEncoding.UTF8);
end;

procedure ShowMap(Browser: TEdgeBrowser);
var
  OsmHelper: TOSMHelper;
begin
  OsmHelper := TOSMHelper.Create(GetHtmlTmp, InitialZoom_Out);
  try
    OsmHelper.Scaled := Browser.ScaleValue(100);
    OsmHelper.WriteHeader;
    OsmHelper.WriteFooter;
  finally
    OsmHelper.Free;
  end;
  Browser.Navigate(GetHtmlTmp);
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

end.
