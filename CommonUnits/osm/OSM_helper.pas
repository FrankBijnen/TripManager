unit OSM_helper;

interface

uses System.Classes, System.SysUtils;

type

  TOSMHelper = class
    FPointCnt : integer;
    Html : TStringList;
    FPathName : string;
  public
    procedure WriteHeader(Color: string = '');
    procedure WritePointsStart(const TrackName: string);
    procedure WritePoint(const ALon, ALat, AEle:string);
    procedure WritePointsEnd;
    procedure WritePlacesStart;
    procedure WritePlace(ACoordinates: string;
                         AWayPoint: string;
                         ADescription: string = '');
    procedure WritePlacesEnd;
    procedure WriteFooter;

    var FormatSettings: TFormatSettings;
    constructor Create(APathName: string);
    destructor Destroy; override;
  end;

function OSMColor(GPXColor: string): string;

implementation

uses
  Winapi.ShellAPI, WinApi.Windows, Soap.HTTPUtil,
  UnitStringUtils;

const OSMHtmlName = 'OSM.Html';

function OSMColor(GPXColor: string): string;
begin
  result := '#ff00ff';
  if SameText(GPXColor, 'Black')       then begin result := '#000000'; exit; end;
  if SameText(GPXColor, 'DarkRed')     then begin result := '#8b0000'; exit; end;
  if SameText(GPXColor, 'DarkGreen')   then begin result := '#006400'; exit; end;
  if SameText(GPXColor, 'DarkYellow')  then begin result := '#b5b820'; exit; end;
  if SameText(GPXColor, 'DarkBlue')    then begin result := '#00008b'; exit; end;
  if SameText(GPXColor, 'DarkMagenta') then begin result := '#8b008b'; exit; end;
  if SameText(GPXColor, 'DarkCyan')    then begin result := '#008b8b'; exit; end;
  if SameText(GPXColor, 'LightGray')   then begin result := '#cccccc'; exit; end;
  if SameText(GPXColor, 'DarkGray')    then begin result := '#444444'; exit; end;
  if SameText(GPXColor, 'Red')         then begin result := '#ff0000'; exit; end;
  if SameText(GPXColor, 'Green')       then begin result := '#00ff00'; exit; end;
  if SameText(GPXColor, 'Yellow')      then begin result := '#ffff00'; exit; end;
  if SameText(GPXColor, 'Blue')        then begin result := '#0000ff'; exit; end;
  if SameText(GPXColor, 'Magenta')     then begin result := '#ff00ff'; exit; end;
  if SameText(GPXColor, 'Cyan')        then begin result := '#00ffff'; exit; end;
  if SameText(GPXColor, 'White')       then begin result := '#ffffff'; exit; end;
  if SameText(GPXColor, 'Transparent') then begin result := '#ffffff'; exit; end;
end;

constructor TOSMHelper.Create(APathName: string);
begin
  inherited Create;

  FPathName := APathName;
  Html := TStringList.Create;
end;

destructor TOSMHelper.Destroy;
begin
  FPathName := '';
  Html.Free;

  inherited Destroy;
end;

procedure TOSMHelper.WriteHeader(Color: string = '');
var S: string;
begin
  Html.Clear;

  Html.Add('<Html>');
  Html.Add('<head>');
  Html.Add('<title></title>');
  Html.Add('<script type="text/javascript"  src="http://openlayers.org/api/OpenLayers.js"></script>');
  Html.Add('<script src="http://www.openstreetmap.org/openlayers/OpenStreetMap.js"></script>');
  Html.Add('<script type="text/javascript">');
  Html.Add('');
  Html.Add('var map;');
  Html.Add('var lineLayer ;');
  Html.Add('var points;');
  Html.Add('var style;');
  Html.Add('');
  Html.Add('var lineFeature;');
  Html.Add('var po;');
  Html.Add('var op;');
  Html.Add('var cacheRead, cacheWrite;');
  Html.Add('');
  Html.Add('  function initialize()');
  Html.Add('  {');
  Html.Add('     map = new OpenLayers.Map ("map_canvas", {');
  Html.Add('           controls:         [new OpenLayers.Control.Navigation(),');
  Html.Add('                              new OpenLayers.Control.PanZoomBar(),');
  Html.Add('                              new OpenLayers.Control.LayerSwitcher(),');
  Html.Add('                              new OpenLayers.Control.Attribution()');
  Html.Add('                             ],');
  Html.Add('           maxExtent:        new OpenLayers.Bounds(-20037508.34,-20037508.34,20037508.34,20037508.34),');
  Html.Add('           maxResolution:    156543.0399,');
  Html.Add('           numZoomLevels:    10,');
  Html.Add('           units:            ''m'',');
  Html.Add('           projection:       new OpenLayers.Projection("EPSG:900913"),');
  Html.Add('           displayProjection:new OpenLayers.Projection("EPSG:4326")});');
  Html.Add('');
  Html.Add('     cacheWrite = new OpenLayers.Control.CacheWrite();');
  Html.Add('     map.addControl(cacheWrite);');
  Html.Add('     cacheRead = new OpenLayers.Control.CacheRead();');
  Html.Add('     map.addControl(cacheRead);');
  Html.Add('');
  Html.Add('     map.addLayer(new OpenLayers.Layer.OSM.Mapnik("Mapnik"));');
  Html.Add('     map.addLayer(new OpenLayers.Layer.OSM("Wikimedia",');
  Html.Add('      ["https://maps.wikimedia.org/osm-intl/${z}/${x}/${y}.png"],');
  Html.Add('      {');
  S :=     '        attribution: "&copy; <a href=''http://www.openstreetmap.org/''>OpenStreetMap</a> and contributors,';
  S := S + '                     under an <a href=''http://www.openstreetmap.org/copyright'' title=''ODbL''>open license</a>. <a href=''https://www.mediawiki.org/wiki/Maps''>Wikimedia''s new style (beta)</a>",';
  Html.Add(S);

  Html.Add('        "tileOptions": { "crossOriginKeyword": null }');
  Html.Add('      })');
  Html.Add('    );');
  Html.Add('    // See https://wiki.openstreetmap.org/wiki/Tile_servers for other OSM-based layers');

  Html.Add('     po = map.getProjectionObject();');
  Html.Add('     op = new OpenLayers.Projection("EPSG:4326");');
  Html.Add('');
  Html.Add('     createTrack();');
  Html.Add('     createPopups();');
  Html.Add('  }');
  Html.Add('');
  Html.Add('  function createTrack(){');
  Html.Add('');
  Html.Add('    lineLayer = new OpenLayers.Layer.Vector("Track");');
//  Html.Add('    style = {strokeColor: ''#0000ff'', strokeOpacity: 0.6, fillOpacity: 0, strokeWidth: 5};');

  Html.Add(Format('    style = {strokeColor: ''%s'', strokeOpacity: 0.6, fillOpacity: 0, strokeWidth: 5};', [OSMColor(Color)]));

  Html.Add('    points = new Array();');
  Html.Add('');
  Html.Add('    addPoints();');
  Html.Add('');
  Html.Add('    var line_string = new OpenLayers.Geometry.LineString(points);');
  Html.Add('    lineFeature = new OpenLayers.Feature.Vector(line_string, null, style);');
  Html.Add('    lineLayer.addFeatures([lineFeature]);');
  Html.Add('');
  Html.Add('    map.addLayer(lineLayer);');
  Html.Add('');
  Html.Add('    var bounds = new OpenLayers.Bounds();');
  Html.Add('    line_string.calculateBounds();');
  Html.Add('    bounds.extend(line_string.bounds);');
  Html.Add('    map.zoomToExtent(bounds);');
  Html.Add('  }');
  Html.Add('');
end;

procedure TOSMHelper.WritePointsStart(const TrackName: string);
begin
  Html.Add('  function addPoints(){');
  FPointCnt := 0;
end;

procedure TOSMHelper.WritePoint(const ALon, ALat, AEle:string);
begin
  Html.Add(Format('    points[%u] = new OpenLayers.LonLat(%s,%s).transform(op, po);',
           [FPointCnt, ALon, ALat]));
  Html.Add(Format('    points[%0:u] = new OpenLayers.Geometry.Point(points[%0:u].lon,points[%0:u].lat);',
           [FPointCnt]));
  inc(FPointCnt);
end;

procedure TOSMHelper.WritePointsEnd;
begin
  Html.Add('  }');
  Html.Add('');
end;

procedure TOSMHelper.WritePlacesStart;
begin
  Html.Add('  function createPopups(){');
end;

procedure TOSMHelper.WritePlace(ACoordinates: string;
                                AWayPoint: string;
                                ADescription: string = '');
var EscapedWayPoint, EscapedDescription: string;
begin
  EscapedWayPoint := EscapeHtml(AWayPoint); // Single quote left out!
  EscapedDescription := EscapeHtml(ADescription);
  Html.Add(Format('    var vectorLayer = new OpenLayers.Layer.Vector("%s", ' +
                    '{ styleMap: new OpenLayers.StyleMap( { pointRadius: 6, fillColor: "red", fillOpacity: 0.5 } ) });',
                  [EscapedWayPoint]));
  Html.Add(Format('    var feature = new OpenLayers.Feature.Vector(',[]));
  Html.Add(Format('            new OpenLayers.Geometry.Point(%s).transform(op, po),',[ACoordinates]));
  Html.Add(Format('            { description: "%s" } );',[EscapedDescription]));
  Html.Add(Format('    vectorLayer.addFeatures(feature);',[]));
  Html.Add(Format('    map.addLayer(vectorLayer);',[]));
end;

procedure TOSMHelper.WritePlacesEnd;
begin
  Html.Add('  }');
  Html.Add('');
end;

procedure TOSMHelper.WriteFooter;
begin
  Html.Add('</script>');
  Html.Add('</head>');
  Html.Add('<body onload="initialize()" >');
  Html.Add('  <div id="map_canvas" style="width: 100%; height: 100%"></div>');
  Html.Add('</body>');
  Html.Add('</html>');

  Html.SaveToFile(FPathName);
end;


end.
