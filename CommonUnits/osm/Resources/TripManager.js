/** Globals **/
var glb_Map;
var glb_BaseLayers;
var glb_RoutePointsLayer;
var glb_POILayer;
var glb_AllPoints;
var glb_RoutePoints;
var glb_TrackLayer;
var glb_TrackPoints;
var glb_PoiPoints;
var glb_TimeoutId = null;
var glb_PopUp = null;
var glb_BoundsBounds;
var glb_ProjectionObject;
var glb_Projection;
var glb_CacheWrite, glb_CacheRead;

/**
 * BaseLayers.js. Classes for BaseLayers
 *
 * Taken (and adapted) from http://www.openstreetMap.org/openlayers/OpenStreetMap.js
 */
OpenLayers.Layer.OSM.Mapnik = OpenLayers.Class(OpenLayers.Layer.OSM, {
  initialize: function(name, options) {
    var url = [
      "https://a.tile.openstreetMap.org/${z}/${x}/${y}.png",
      "https://b.tile.openstreetMap.org/${z}/${x}/${y}.png",
      "https://c.tile.openstreetMap.org/${z}/${x}/${y}.png"
    ];
    options = OpenLayers.Util.extend({
      numZoomLevels: 20,
      maxZoom: 20,
      attribution: "&copy; <a href='https://www.openstreetMap.org/copyright'>OpenStreetMap</a> contributors",
      buffer: 1,
      transitionEffect: "resize"
    }, options);
    var newArguments = [name, url, options];
    OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
  },

  CLASS_NAME: "OpenLayers.Layer.OSM.Mapnik"
});

OpenLayers.Layer.XYZ.OpenTopoMap = OpenLayers.Class(OpenLayers.Layer.XYZ, {
  initialize: function(name, options) {
    var url = [
      "https://a.tile.opentopoMap.org/${z}/${x}/${y}.png",
      "https://b.tile.opentopoMap.org/${z}/${x}/${y}.png",
      "https://c.tile.opentopoMap.org/${z}/${x}/${y}.png"
    ];
    options = OpenLayers.Util.extend({
      numZoomLevels: 18,
      maxZoom: 18,
      sphericalMercator: true,
      attribution: "Map data: &copy; <a href='https://www.openstreetMap.org/copyright'>OpenStreetMap</a> contributors, <a href='http://viewfinderpanoramas.org'>SRTM</a> | Map Style: &copy; <a href='https://opentopoMap.org'>OpenTopoMap</a> (<a href='https://creativecommons.org/licenses/by-sa/3.0/'>CC-BY-SA</a>)",
      buffer: 0,
      transitionEffect: "resize"
    }, options);
    var newArguments = [name, url, options];
    OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
  },

  CLASS_NAME: "OpenLayers.Layer.XYZ.OpenTopoMap"
});

OpenLayers.Layer.XYZ.TOPPlusOpen = OpenLayers.Class(OpenLayers.Layer.XYZ, {
  initialize: function(name, options) {
    var url = [
      "https://sgx.geodatenzentrum.de/wmts_topplus_open/tile/1.0.0/web/default/WEBMERCATOR/${z}/${y}/${x}.png"
    ];
    options = OpenLayers.Util.extend({
      numZoomLevels: 18,
      maxZoom: 18,
      sphericalMercator: true,
      attribution: "Map data: &copy; <a href='https://gdz.bkg.bund.de/'>GeoDatenZentrum.de (TopPlusOpen)</a>",
      buffer: 0,
      transitionEffect: "resize"
    }, options);
    var newArguments = [name, url, options];
    OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
  },

  CLASS_NAME: "OpenLayers.Layer.XYZ.TOPPlusOpen"
});

OpenLayers.Layer.XYZ.MapTiler = OpenLayers.Class(OpenLayers.Layer.XYZ, {
  initialize: function(name, resource, Style, key, options) {
    var url = [
      "https://api.Maptiler.com/" + resource + "/" + Style + "/${z}/${x}/${y}.jpg?key=" + key
    ];
    options = OpenLayers.Util.extend({
      numZoomLevels: 22,
      maxZoom: 22,
      sphericalMercator: true,
      attribution: "<a href='https://www.Maptiler.com/copyright/' target='_blank'>&copy; MapTiler</a><a href='https://www.openstreetMap.org/copyright' target='_blank'>&copy;&nbsp;OpenStreetMap contributors</a>",
      buffer: 0,
      transitionEffect: "resize"
    }, options);
    var newArguments = [name, url, options];
    OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
  },
  CLASS_NAME: "OpenLayers.Layer.XYZ.MapTiler"
});

OpenLayers.Layer.XYZ.ESRISatellite = OpenLayers.Class(OpenLayers.Layer.XYZ, {
  initialize: function(name, options) {
    var url = [
      "https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/${z}/${y}/${x}"
    ];
    options = OpenLayers.Util.extend({
      numZoomLevels: 20,
      maxZoom: 20,
      sphericalMercator: true,
      attribution: "&copy; <a href='https://www.esri.com/en-us/home'>Powered by Esri</a>&nbsp;Source: Esri, DigitalGlobe, GeoEye, i-cubed, USDA FSA, USGS, AEX, GetMapping, Aerogrid, IGN, IGP, swisstopo, and the GIS User Community",
      buffer: 0,
      transitionEffect: "resize"
    }, options);
    var newArguments = [name, url, options];
    OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
  },

  CLASS_NAME: "OpenLayers.Layer.XYZ.ESRISatellite"
});

/** TripManager **/
function initialize() {
  glb_Map = new OpenLayers.Map("map_canvas", {
    controls: [new OpenLayers.Control.Navigation(),
      new OpenLayers.Control.PanZoomBar(),
      new OpenLayers.Control.LayerSwitcher(),
      new OpenLayers.Control.Attribution()
    ],
    maxResolution: 156543.0399,
    numZoomLevels: 10,
    units: "m",
    projection: new OpenLayers.Projection("EPSG:900913"),
    eventListeners: {
      featureover: function(e) {
        e.feature.renderIntent = "select";
        e.feature.layer.drawFeature(e.feature);
        var parm1 = (e.feature.layer.name) ? e.feature.layer.name : "";
        var parm2 = (e.feature.data.tooltip) ? e.feature.data.tooltip :
          (e.feature.url) ? e.feature.url : "";
        SendMessage(osm_GetRoutePoint, parm1, parm2);
      }
    },
    displayProjection: new OpenLayers.Projection("EPSG:4326")
  });

  var defTileSize = glb_Map.tileSize;
  glb_CacheWrite = new OpenLayers.Control.CacheWrite();
  glb_Map.addControl(glb_CacheWrite);
  glb_CacheRead = new OpenLayers.Control.CacheRead();
  glb_Map.addControl(glb_CacheRead);
  glb_BaseLayers = new Array();
  glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.OSM.Mapnik("Mapnik")) - 1]);
  if (osm_MapTilerKey) {
    glb_Map.tileSize = new OpenLayers.Size(512, 512);
    glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.MapTiler("Map Tiler Satellite", "maps", "satellite-v4", osm_MapTilerKey)) - 1]);
    glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.MapTiler("Map Tiler Hybrid", "maps", "hybrid-v4", osm_MapTilerKey)) - 1]);
    glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.MapTiler("Map Tiler Base", "maps", "base-v4", osm_MapTilerKey)) - 1]);
    glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.MapTiler("Map Tiler OpenStreetmap", "maps", "openstreetmap", osm_MapTilerKey)) - 1]);
    glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.MapTiler("Map Tiler Streets", "maps", "streets-v4", osm_MapTilerKey)) - 1]);
    glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.MapTiler("Map Tiler Topo", "maps", "topo-v4", osm_MapTilerKey)) - 1]);
    glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.MapTiler("Map Tiler Bright", "maps", "bright-v2", osm_MapTilerKey)) - 1]);
    glb_Map.tileSize = defTileSize;
  }
  glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.OpenTopoMap("Open Topo Map")) - 1]);
  glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.TOPPlusOpen("TOP Plus Open")) - 1]);
  if (osm_ESRIEnabled) {
    glb_Map.addLayer(glb_BaseLayers[glb_BaseLayers.push(new OpenLayers.Layer.XYZ.ESRISatellite("ESRI Satellite")) - 1]);
  }
  glb_Map.setBaseLayer(glb_Map.getLayersBy("name", osm_BaseLayer)[0]);
  glb_Map.events.register("changebaselayer", glb_Map, function(event) {
    SendMessage(osm_BaseLayerChangedEvent, event.layer.name, "");
  });
  glb_ProjectionObject = glb_Map.getProjectionObject();
  glb_Projection = new OpenLayers.Projection("EPSG:4326");
  glb_Map.events.listeners.mousedown.unshift({
    func: function(e) {
      if (e.ctrlKey) {
        var lonLat = glb_Map.getLonLatFromViewPortPx(e.xy).transform(glb_ProjectionObject, glb_Projection);
        SendMessage(osm_CtrlClickEvent, lonLat.lat, lonLat.lon);
      }
    }
  });
  glb_Map.events.register("moveend", glb_Map, function(evt) { GetBounds(osm_GetBoundsEvent); })
  glb_AllPoints = new Array();
  glb_RoutePoints = new Array();
  glb_TrackPoints = new Array();
  glb_RoutePointsLayer = new Array();
  glb_POILayer = new Array();
  glb_TrackLayer = new Array();
  glb_PoiPoints = new Array();
  glb_BoundsBounds = new Array();

  AddPoints(); // Created by TripManager
  CreateExtent(glb_Map.getNumZoomLevels() * 0.66);
}

function SendMessage(msg, parm1, parm2) {
  if (window && window.chrome && window.chrome.webview)
    window.chrome.webview.postMessage({
      msg: msg,
      parm1: parm1,
      parm2: parm2
    });
}

function GetLocation(func) {
  var bounds = glb_Map.getExtent();
  var lonLat = bounds.getCenterLonLat().transform(glb_ProjectionObject, glb_Projection);
  SendMessage(func, lonLat.lat, lonLat.lon);
}

function GetBounds(func) {
  var bounds = glb_Map.getExtent();
  bounds.transform(glb_ProjectionObject, glb_Projection);
  var lonLat = bounds.getCenterLonLat();
  SendMessage(func, bounds.toBBOX(osm_PlaceDecimals, true), lonLat.lat + ", " + lonLat.lon);
}

function CreateExtent(maxZoomLevel) {
  glb_AllPoints = glb_AllPoints.concat(glb_TrackPoints);
  glb_AllPoints = glb_AllPoints.concat(glb_RoutePoints);
  glb_AllPoints = glb_AllPoints.concat(glb_PoiPoints);
  var line_string = new OpenLayers.Geometry.LineString(glb_AllPoints);
  glb_AllPoints = new Array();
  line_string.calculateBounds();
  var bounds = new OpenLayers.Bounds();
  bounds.extend(line_string.bounds);
  glb_Map.zoomToExtent(bounds);
  if (glb_Map.getZoom() > maxZoomLevel) {
    glb_Map.zoomTo(maxZoomLevel);
  }
}

function PopupAtPoint(href, pointLat, pointLon, zoomToPoint, popupTimeOut) {
  var lonLat = new OpenLayers.LonLat(pointLon, pointLat).transform(glb_Projection, glb_ProjectionObject);
  if (zoomToPoint) {
    glb_Map.moveTo(lonLat, glb_Map.getNumZoomLevels() - 4, null)
  };
  if (href) {
    glb_PopUp = new OpenLayers.Popup.FramedCloud("Popup", lonLat, null, href, null, true);
    glb_Map.addPopup(glb_PopUp, true);
    if (glb_TimeoutId) {
      clearTimeout(glb_TimeoutId)
    };
    glb_TimeoutId = setTimeout(RemovePopup, popupTimeOut);
  };
}

function RemovePopup() {
  if (glb_PopUp) {
    glb_Map.removePopup(glb_PopUp);
    glb_PopUp = null
  };
  for (let x in glb_TrackLayer) {
    if (glb_TrackLayer[x].features.length > 0 &&
      glb_TrackLayer[x].features[0].style.strokeDashstyle == "dashdot") {
      glb_TrackLayer[x].setVisibility(false);
    }
  }
}

function AddRoutePoint(idLayer, layerName, routePointName, pointLat, pointLon, color) {
  var lonLat = new OpenLayers.LonLat(pointLon, pointLat).transform(glb_Projection, glb_ProjectionObject);
  var feature = new OpenLayers.Feature.Vector(new OpenLayers.Geometry.Point(lonLat.lon, lonLat.lat));
  feature.url = routePointName;
  if (!glb_RoutePointsLayer[idLayer]) {
    glb_RoutePointsLayer[idLayer] = new OpenLayers.Layer.Vector(layerName, {
      styleMap: new OpenLayers.StyleMap({
        pointRadius: 6,
        fillColor: color,
        fillOpacity: 0.5
      })
    });
  }
  glb_RoutePointsLayer[idLayer].addFeatures(feature);
  glb_RoutePointsLayer[idLayer].displayInLayerSwitcher = true;
  glb_Map.addLayer(glb_RoutePointsLayer[idLayer]);
  glb_RoutePoints.push(new OpenLayers.Geometry.Point(lonLat.lon, lonLat.lat));
}

function AddPOI(poiName, pointLat, pointLon, pngFile, id) {
  var lonLat = new OpenLayers.LonLat(pointLon, pointLat).transform(glb_Projection, glb_ProjectionObject);
  var myLocation = new OpenLayers.Geometry.Point(pointLon, pointLat).transform('EPSG:4326', 'EPSG:3857');
  if (!glb_POILayer[id]) {
    glb_POILayer[id] = new OpenLayers.Layer.Vector(id, {
      styleMap: new OpenLayers.StyleMap({
        externalGraphic: pngFile,
        graphicWidth: 20,
        graphicHeight: 20,
        graphicXOffset: -10,
        graphicYOffset: -10,
        title: id
      })
    });
    glb_POILayer[id].displayInLayerSwitcher = false;
    glb_Map.addLayer(glb_POILayer[id]);
  }

  glb_POILayer[id].addFeatures([new OpenLayers.Feature.Vector(myLocation, { tooltip: poiName })]);
  glb_PoiPoints.push(new OpenLayers.Geometry.Point(lonLat.lon, lonLat.lat));
};

function AddTrkPoint(pointLat, pointLon) {
  var lonLat = new OpenLayers.LonLat(pointLon, pointLat).transform(glb_Projection, glb_ProjectionObject);
  glb_TrackPoints.push(new OpenLayers.Geometry.Point(lonLat.lon, lonLat.lat));
}

function ShowBounds(lineName) {
  glb_Map.zoomToExtent(glb_BoundsBounds[lineName]);
  glb_TrackLayer[lineName].setVisibility(true);
}

function CreateTrack(lineName, color, isBounds = false) {
  var width = osm_TrackWidth;
  var dash = "solid";
  var lineString = new OpenLayers.Geometry.LineString(glb_TrackPoints);
  var lineFeature;
  if (!glb_TrackLayer[lineName]) {
    glb_TrackLayer[lineName] = new OpenLayers.Layer.Vector(lineName);
    glb_Map.addLayer(glb_TrackLayer[lineName]);
  }
  if (isBounds) {
    lineString.calculateBounds();
    if (!glb_BoundsBounds[lineName]) {
      glb_BoundsBounds[lineName] = new OpenLayers.Bounds();
    }
    glb_BoundsBounds[lineName].extend(lineString.bounds);
    glb_TrackLayer[lineName].setVisibility(false);
    glb_TrackLayer[lineName].displayInLayerSwitcher = false;
    width = osm_BoundsWidth;
    dash = "dashdot";
  }
  var style = {
    strokeColor: color,
    strokeDashstyle: dash,
    strokeOpacity: 0.6,
    fillOpacity: 0,
    strokeWidth: width
  };
  lineFeature = new OpenLayers.Feature.Vector(lineString, null, style);
  glb_TrackLayer[lineName].addFeatures([lineFeature]);
  glb_AllPoints = glb_AllPoints.concat(glb_TrackPoints);
  glb_TrackPoints = new Array();
}
