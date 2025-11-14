# TripManager
Manage the trips on the z&#0361;mo XT(2).<br>

This program has been tested on the XT, the XT2 and Tread 2. <br>

# Credits
- John Heath and Steve Follen for their work on the XT2.<br>
- ProofResistant for his work on the Tread 2.<br>
- Members of Zumo User Forums. https://zumouserforums.co.uk/<br>
- Anyone I forgot to mention.

# Download release
[Latest](https://github.com/FrankBijnen/TripManager/releases/latest)<br>

# Changed with V1.6.0.345
- Create trips that dont require calculation. The GPX file must contain routes calculated by BaseCamp. See [Trip create options](https://frankbijnen.github.io/TripManager/17createtripoptions.html)
- Add support for the Tread 2 device
- Add experimental support for FIT file type. Used by Garmin Edge devices.
- Add support for Generic Garmin devices. (Zumo 220, 660, 39x, 59x etc)
- Review the device selection. A supported device should be selected automatically.
- Add support for route preferences per segment. (XT2 and Tread 2 only) See [Send to device](https://frankbijnen.github.io/TripManager/6sendtodevice.html) and [Trip Window](https://frankbijnen.github.io/TripManager/tripwindow.html).
- Add 'User-Agent' to internal Web Browser. Fix possible blocking by OpenStreetMap tile server.
- Add option to filter tracks by a minimum distance between trackpoints.
- Read GarminDevice.xml and SQlite db files to get variables needed for creation of trips. eg. AvoidcancesChangedTime and Vehicle profile.
- Documentation reviewed. Added option to install locally to Compiled HTML format. (CHM) Online documentation converted to HTML and deployed using GitHub pages.

[Complete change history](https://frankbijnen.github.io/TripManager/changehistory.html)

# Documentation available

 - [Index](https://frankbijnen.github.io/TripManager/)
 - [Content](https://frankbijnen.github.io/TripManager/toc.html)



Frank
