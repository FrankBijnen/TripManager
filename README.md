# TripManager
Manage the trips on the z&#0361;mo XT(2)(3).<br>

This program has been tested on the XT, the XT2, the XT3, and Tread 2. <br>
The XT3 needs additional testing. <br>

# Credits
- John Heath and Steve Follen for their work on the XT2.<br>
- ProofResistant for his work on the Tread 2.<br>
- Ruud Schut (GPS.nl) for supplying sample files of the XT3.<br>
- Members of Zumo User Forums. https://zumouserforums.co.uk/<br>
- Anyone I forgot to mention.

# Download release
[Latest](https://github.com/FrankBijnen/TripManager/releases/latest)<br>

# Changed with V1.7.0.382

  <ul>
     <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  " >
        <div align="left" ></span><font face="Calibri"  size="4" ><span style="font-size:14pt" >Fix for </span></font><a href="https://frankbijnen.github.io/TripManager/vehicleprofilehashxt3.html"></span><font face="Calibri"  color="#0000ff"  size="4" ><span style="font-size:14pt" ><u>VehicleProfileHash </u></span></font></a></span><font face="Calibri"  size="4" ><span style="font-size:14pt" >for
           the XT3.</span></font><font color="#010101" ></font>
        </div>
     </li>
     <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  " ></span><font face="Calibri"  size="4" ><span style="font-size:14pt" >Check .System folder. Create .System\Trips if needed. For MTP
        models.</span></font><font color="#010101" ></font>
     </li>
     <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  " ></span><font face="Calibri"  size="4" ><span style="font-size:14pt" >Get UCS4 and Unknown2Size from VersionNumber.</span></font><font color="#010101" ></font></li>
     <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri;  font-size= 14pt;  " ></span><font face="Calibri"  size="4" ><span style="font-size:14pt" >Enable Extended Shaping points.</span></font><font color="#010101" ></font></li>
  </ul>

# Changed with V1.7.0.380

  <ul>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;">
      <div align="left">
        <font face="Calibri" size="4"><span style="font-size:14pt">The model for inserted SD Cards is now identified.</span></font>
      </div>
    </li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;"><font face="Calibri" size="4"><span style="font-size:14pt">Fixed modified date displayed for some models.</span></font></li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;"><font face="Calibri" size="4"><span style="font-size:14pt">Updated MapTiler base layers to V4.</span></font></li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;"><font face="Calibri" size="4"><span style="font-size:14pt">Load Sqlite3.Dll dynamically for compatibility with CBuilder. Fix order by.</span></font></li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;">
      <font face="Calibri" size="4"><span style="font-size:14pt">Improved time calculation for Trips. Road speeds are now configurable, and optionally a detailed CSV is created. Configuration should be done in</span></font> <a href="https://frankbijnen.github.io/TripManager/1initialtasks.html#tripoverview"><font face="Calibri" color="#0000FF" size="4"><span style="font-size:14pt"><u>Advanced/Settings/Trip Overview</u></span></font></a><font face="Calibri" size="4"><span style="font-size:14pt">.</span></font>
    </li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;"><font face="Calibri" size="4"><span style="font-size:14pt">Fix for creating trip files from MapSource.</span></font></li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;"><font face="Calibri" size="4"><span style="font-size:14pt">Fixes for Tread 2 to prevent recalculation. Thanks proofresistant!</span></font></li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;">
      <font face="Calibri" size="4"><span style="font-size:14pt">Integrated Trk2Rt. Allows for creating routes from tracks. Thanks Steve Follen! See</span></font> <a href="https://github.com/SteveFollen/Trk2Rt?.html" target="_blank"><font face="Calibri" color="#0000FF" size="4"><span style="font-size:14pt"><u>Trk2Rt on GitHub</u></span></font></a>
    </li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;">
      <font face="Calibri" size="4"><span style="font-size:14pt">Added the option to open a GPX, or Trip, in</span></font> <a href="https://www.kurviger.com?" target="_blank"><font face="Calibri" color="#0000FF" size="4"><span style="font-size:14pt"><u>Kurviger.</u></span></font></a> <font face="Calibri" size="4"><span style="font-size:14pt">With permission from Kurviger. Thanks proofresistant!</span></font>
    </li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;">
      <font face="Calibri" size="4"><span style="font-size:14pt">Create a</span></font> <a href="https://frankbijnen.github.io/TripManager/7compareatripwithagpx.html#fix"><font face="Calibri" color="#0000FF" size="4"><span style="font-size:14pt"><u>fixed</u></span></font></a> <font face="Calibri" size="4"><span style="font-size:14pt">trip from the compare Log window. Combined with the <b>Trk2Rt</b> and <b>Kurviger</b> integration this can help in building a</span></font> <a href="https://frankbijnen.github.io/TripManager/theuniversalroute.html"><font face="Calibri" color="#0000FF" size="4"><span style="font-size:14pt"><u>Universal route</u></span></font></a><font face="Calibri" size="4"><span style="font-size:14pt">.</span></font>
    </li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;">
      <font face="Calibri" size="4"><span style="font-size:14pt">Added checks for inconsistencies in</span></font> <a href="https://frankbijnen.github.io/TripManager/checkexploredb.html"><font face="Calibri" color="#0000FF" size="4"><span style="font-size:14pt"><u>Explore.db</u></span></font></a>
    </li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;">
      <font face="Calibri" size="4"><span style="font-size:14pt">Decoded more Trip File formats. Because of limited testing usage is restricted to read only. See</span></font> <a href="https://frankbijnen.github.io/TripManager/modelinfo.html"><font face="Calibri" color="#0000FF" size="4"><span style="font-size:14pt"><u>Model info</u></span></font></a>
    </li>
    <li style="margin-left: 1mm; margin-right: 0mm; padding-left: 0mm; font-family= Calibri; font-size= 14pt;">
      <font face="Calibri" size="4"><span style="font-size:14pt">Added support for the <b>XT3</b>. See</span></font> <a href="https://frankbijnen.github.io/TripManager/modelinfo.html"><font face="Calibri" color="#0000FF" size="4"><span style="font-size:14pt"><u>Model info</u></span></font></a>
    </li>
  </ul><br>


[Complete change history](https://frankbijnen.github.io/TripManager/changehistory.html)

# Documentation available

 - [Index](https://frankbijnen.github.io/TripManager/)
 - [Content](https://frankbijnen.github.io/TripManager/toc.html)



Frank
