# TripManager
Manage the trips on the z&#0361;mo XT(2)(3).<br>

This program has been tested on the XT, the XT2, the XT3, and Tread 2. <br>

# Credits
- John Heath and Steve Follen for their work on the XT2.<br>
- ProofResistant for his work on the Tread 2.<br>
- Ruud Schut (GPS.nl) for supplying sample files of the XT3.<br>
- Herbert Oppman for decoding more info in trip files.<br>
- Members of Zumo User Forums. https://zumouserforums.co.uk/<br>
- Anyone I forgot to mention.

# Download release
[Latest](https://github.com/FrankBijnen/TripManager/releases/latest)<br>

# Changed with V1.8.0.402
<html>
<body bgcolor="#FFFFFF">
  <hr>
<ul>
<li>
<span style="font-size:14pt">Add function to export Explore.db to GPX format. </span></font><a href="https://frankbijnen.github.io/TripManager/checkexploredb.html">
  <font face="Calibri" color="#0000ff" size="4"><span style="font-size:14pt"><u>Check Explore.db</u></span></font>
</a>
<font color="#010101"></font>
</div>
</li>
<li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
  <font face="Calibri" size="4"><span style="font-size:14pt">With help from </span></font><a href="https://www.memotech.franken.de/FileFormats/?" target="_blank">
    <font face="Calibri" color="#0000ff" size="4"><span style="font-size:14pt"><u>Herbert Oppman</u></span></font>
  </a>
  <font face="Calibri" size="4"><span style="font-size:14pt">, more data is identified from trip
      and gpi files and displaying them has improved.</span></font>
  <font color="#010101"></font>
</li>
<li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
  <font face="Calibri" size="4"><span style="font-size:14pt">The Window layout is saved and optionally restored. See </span></font><a href="https://frankbijnen.github.io/TripManager/1initialtasks.html#general">
    <font face="Calibri" color="#0000ff" size="4"><span style="font-size:14pt"><u>Settings/General</u></span></font>
  </a>
  <font color="#010101"></font>
</li>
<li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
  <font face="Calibri" size="4"><span style="font-size:14pt">Add base-layers TopPlusOpen and MapTiler Hybrid. Fix scaling issue
      for MapTiler base-layers.</span></font>
  <font color="#010101"></font>
</li>
<li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
  <font face="Calibri" size="4"><span style="font-size:14pt">More models supported.</span></font>
  <font color="#010101"></font>
  <ul>
    <font color="#010101"></font>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font color="#010101"></font>
      <font face="Calibri" size="4"><span style="font-size:14pt">Nuvi 2599 and Nuvi 57</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">Zumo 346 and Zumo 395</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">ForeRunner (170 and 255 tested)</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">Explore 2</span></font>
      <font color="#010101"></font>
    </li>
  </ul>
</li>
<li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
  <font face="Calibri" size="4"><span style="font-size:14pt">Review code. There could be small functional changes.</span></font>
  <font color="#010101"></font>
  <ul>
    <font color="#010101"></font>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font color="#010101"></font>
      <font face="Calibri" size="4"><span style="font-size:14pt">Displaying and creating POI (.gpi) files.</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">Route preferences and transportation modes.</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">Move function names to resource.</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">USB Connect and Disconnect code used by MTP devices. More
          error checking.</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">Better implementation of 'Force recalculation'.</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">Route preferences (calculation modes) and Transportation mode.</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">Get more parameters from mVersionNumber. EG sizes of memory
          blocks. To simplify adding more models.</span></font>
      <font color="#010101"></font>
    </li>
  </ul>
</li>
<li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
  <font face="Calibri" size="4"><span style="font-size:14pt">Allow save to GPX for FIT and POI files.</span></font>
  <font color="#010101"></font>
</li>
<li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
  <font face="Calibri" size="4"><span style="font-size:14pt">Request: </span></font><a href="https://frankbijnen.github.io/TripManager/devicefilelisttopleft.html#process_track_logs">
    <font face="Calibri" color="#0000ff" size="4"><span style="font-size:14pt"><u>PostProcess
          CurrentTrackLog</u></span></font>
  </a>
  <font face="Calibri" size="4"><span style="font-size:14pt">. Allows to create tracklogs per
      day and automatically create way points from stops.</span></font>
  <font color="#010101"></font>
</li>
<li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
  <font face="Calibri" size="4"><span style="font-size:14pt">Prevent <b>Avoidances changed</b>/<b>Profile out of date</b> warnings.</span></font>
  <font color="#010101"></font>
  <ul>
    <font color="#010101"></font>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font color="#010101"></font>
      <font face="Calibri" size="4"><span style="font-size:14pt">For the XT3 the calculation of&nbsp; </span></font><a href="https://frankbijnen.github.io/TripManager/vehicleprofilehashxt3.html">
        <font face="Calibri" color="#0000ff" size="4"><span style="font-size:14pt"><u>VehicleProfileHash </u></span></font>
      </a>
      <font face="Calibri" size="4"><span style="font-size:14pt">has been
          extended.</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">Hashes found in calculated trips are stored in the registry.
          Preventing possible duplication of profiles on the XT3 and Tread 2.</span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">New function to </span></font><a href="https://frankbijnen.github.io/TripManager/tripfunctions.html#reset_avoid_veh_profile">
        <font face="Calibri" color="#0000ff" size="4"><span style="font-size:14pt"><u>reset </u></span></font>
      </a>
      <font face="Calibri" size="4"><span style="font-size:14pt">the trip files, to prevent the 'avoidances
          changed' message when opening trip files. </span></font>
      <font color="#010101"></font>
    </li>
    <li style="margin-left: 2mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
      <font face="Calibri" size="4"><span style="font-size:14pt">More options and info when </span></font><a href="https://frankbijnen.github.io/TripManager/1initialtasks.html#setup_profile">
        <font face="Calibri" color="#0000ff" size="4"><span style="font-size:14pt"><u>Setting
              up profiles.</u></span></font>
      </a>
      <font color="#010101"></font>
    </li>
  </ul>
</li>
<li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  ">
  <font face="Calibri" size="4"><span style="font-size:14pt">Check .System folder. Create .System\Trips if needed. For MTP
      models.</span></font>
  <font color="#010101"></font>
</li>
</ul>
</body>
</html>

[Complete change history](https://frankbijnen.github.io/TripManager/changehistory.html)

# Documentation available

 - [Index](https://frankbijnen.github.io/TripManager/)
 - [Content](https://frankbijnen.github.io/TripManager/toc.html)


Frank
