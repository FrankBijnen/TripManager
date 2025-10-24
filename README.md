# TripManager
Manage the trips on the z&#0361;mo XT(2).<br>

This program has been tested on the XT, and the XT2. Thanks to John Heath and Steve Follen for their work on the XT2.<br>

# Download release
[Latest](https://github.com/FrankBijnen/TripManager/releases/latest)<br>

# Changed with V1.5.0.320
- 64 Bits support. This will require you to uninstall a previous 32 bits version first.
- Better MTP device support. Fixed a delay after the first write. Detect connect and disconnect of the device.
- Code reviewed and restructured.
- Added undo CTRL/Z in the Hex Editor.
- Functions <b>Transfer to device</b> and <b>Additional files</b> have been merged and are now available as <b>Send to</b>.
- Added an Import/Export From/To CSV format in the trip editor. Alternatively you can use the clipboard to copy from/to Excel.
- Changed looking up addresses in Trip Editor. If no coordinates are available it will now try to look them up from address.
- Added an automatic compare .trip with .gpx function.
- Enabled deleting and creating folders on the device. Requires enabling <b>EnableDirFuncs</b> in Device settinge.
- Added the trip name in the device file list.
- Added more base layers to the map. Register at www.maptiler.com and add your Api_Key in Advanced Settings to enable the Map Tiler maps, that include satellite images.
- Various bug-fixes. See [Issue list](https://github.com/FrankBijnen/TripManager/issues/15)

# Changed with V1.4.0.162
- Added GeoCoding. To find a location on the map, or find the address of GPS coordinates.
[Using GeoCode](https://github.com/FrankBijnen/TripManager/blob/main/TripManager/docs/WalkThroughs/11%20Using%20GeoCode.pdf)
- Added Trip Editor. To View, Create and Edit trip files directly.
[Using Trip Editor](https://github.com/FrankBijnen/TripManager/blob/main/TripManager/docs/WalkThroughs/12%20Using%20Trip%20Editor.pdf)

# Changed with V1.3.0.147
Creating and modifying trips works for the XT2.<br>
(Un)grouping does not work for the XT2, but that offers Collections.<br>

# Documentation available

 - [Documentation html](https://htmlpreview.github.io/?https://github.com/FrankBijnen/TripManager/blob/main/TripManager/docs/README.md)
 - [Documentation md](TripManager/docs/README.md)
 - [Test](TripManager/docs/Tripmanager%20Overview.pdf)

Frank
