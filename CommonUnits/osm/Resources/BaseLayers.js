/**
 * BaseLayers.js. Classes for BaseLayers
 *
 * Taken (and adapted) from http://www.openstreetmap.org/openlayers/OpenStreetMap.js
 */
OpenLayers.Layer.OSM.Mapnik = OpenLayers.Class(OpenLayers.Layer.OSM, {
    initialize: function(name, options) {
        var url = [
            "https://a.tile.openstreetmap.org/${z}/${x}/${y}.png",
            "https://b.tile.openstreetmap.org/${z}/${x}/${y}.png",
            "https://c.tile.openstreetmap.org/${z}/${x}/${y}.png"
        ];
        options = OpenLayers.Util.extend({
            numZoomLevels: 20,
            maxZoom: 20,
            attribution: "&copy; <a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a> contributors",
            buffer: 1,
            transitionEffect: "resize"
        }, options);
        var newArguments = [name, url, options];
        OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
    },

    CLASS_NAME: "OpenLayers.Layer.OSM.Mapnik"
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
            attribution: "&copy; <a href='https://www.esri.com/en-us/home'>Powered by Esri</a>&nbsp;Source: Esri, DigitalGlobe, GeoEye, i-cubed, USDA FSA, USGS, AEX, Getmapping, Aerogrid, IGN, IGP, swisstopo, and the GIS User Community",
            buffer: 1,
            transitionEffect: "resize"
        }, options);
        var newArguments = [name, url, options];
        OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
    },

    CLASS_NAME: "OpenLayers.Layer.XYZ.ESRISatellite"
});

OpenLayers.Layer.XYZ.ESRIWorldStreet = OpenLayers.Class(OpenLayers.Layer.XYZ, {
    initialize: function(name, options) {
        var url = [
            "https://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer/tile/${z}/${y}/${x}"
        ];
        options = OpenLayers.Util.extend({
            numZoomLevels: 20,
            maxZoom: 20,
            sphericalMercator: true,
            attribution: "&copy; <a href='https://www.esri.com/en-us/home'>Powered by Esri</a>&nbsp;Source: Esri, DeLorme, NAVTEQ, USGS, Intermap, iPC, NRCAN, Esri Japan, METI, Esri China (Hong Kong), Esri (Thailand), TomTom, 2012",
            buffer: 1,
            transitionEffect: "resize"
        }, options);
        var newArguments = [name, url, options];
        OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
    },

    CLASS_NAME: "OpenLayers.Layer.XYZ.ESRIWorldStreet"
});

OpenLayers.Layer.XYZ.OpenTopoMap = OpenLayers.Class(OpenLayers.Layer.XYZ, {
    initialize: function(name, options) {
        var url = [
            "https://tile.opentopomap.org/${z}/${x}/${y}.png"
        ];
        options = OpenLayers.Util.extend({
            numZoomLevels: 18,
            maxZoom: 18,
            sphericalMercator: true,
            attribution: "Map data: &copy; <a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a> contributors, <a href='http://viewfinderpanoramas.org'>SRTM</a> | Map style: &copy; <a href='https://opentopomap.org'>OpenTopoMap</a> (<a href='https://creativecommons.org/licenses/by-sa/3.0/'>CC-BY-SA</a>)",
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

OpenLayers.Layer.XYZ.CartoDB = OpenLayers.Class(OpenLayers.Layer.XYZ, {
    initialize: function(name, options) {
        var url = [
            "https://${s}.basemaps.cartocdn.com/rastertiles/voyager/${z}/${x}/${y}${r}.png"
        ];
        options = OpenLayers.Util.extend({
            numZoomLevels: 20,
            maxZoom: 20,
            sphericalMercator: true,
            attribution: "&copy; <a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a> contributors &copy; <a href='https://carto.com/attributions'>CARTO</a>",
            subdomains: "abcd",
            buffer: 1,
            transitionEffect: "resize"
        }, options);
        var newArguments = [name, url, options];
        OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
    },

    CLASS_NAME: "OpenLayers.Layer.XYZ.CartoDB"
});

OpenLayers.Layer.XYZ.CyclOSM = OpenLayers.Class(OpenLayers.Layer.XYZ, {
    initialize: function(name, options) {
        var url = [
            "https://a.tile-cyclosm.openstreetmap.fr/cyclosm/${z}/${x}/${y}.png",
            "https://b.tile-cyclosm.openstreetmap.fr/cyclosm/${z}/${x}/${y}.png",
            "https://c.tile-cyclosm.openstreetmap.fr/cyclosm/${z}/${x}/${y}.png"
        ];
        options = OpenLayers.Util.extend({
            numZoomLevels: 19,
            maxZoom: 19,
            sphericalMercator: true,
            attribution: "<a href='https://github.com/cyclosm/cyclosm-cartocss-style/releases' title='CyclOSM - Open Bicycle render'>CyclOSM</a> | Map data: &copy; <a href='https://www.openstreetmap.org/copyright'>OpenStreetMap</a> contributors",
            buffer: 1,
            transitionEffect: "resize"
        }, options);
        var newArguments = [name, url, options];
        OpenLayers.Layer.OSM.prototype.initialize.apply(this, newArguments);
    },

    CLASS_NAME: "OpenLayers.Layer.XYZ.CyclOSM"
});

