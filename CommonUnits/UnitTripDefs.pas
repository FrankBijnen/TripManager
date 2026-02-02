unit UnitTripDefs;

interface

type
  TTripModel    = (XT, XT2, Tread2, Zumo595, Zumo590, Zumo3x0, Drive51, Nuvi2595, Unknown);
  TTripOption   = (ttCalc, ttNoCalc, ttTripTrack, ttTripTrackLoc, ttTripTrackLocPrefs);
  TRoutePreference  = (rmFasterTime       = $00,
                       rmShorterDistance  = $01,
                       rmOffRoad          = $02,
                       rmEco              = $03,
                       rmDirect           = $04,
                       rmCurvyRoads       = $07,
                       rmTripTrack        = $09,
                       rmHills            = $1a,
                       rmNoShape          = $58,
                       rmScenic           = $be,
                       rmPopular          = $ef,
                       rmNA               = $ff);
  TAdvlevel         = (advLevel1          = $00,
                       advLevel2          = $01,
                       advLevel3          = $02,
                       advLevel4          = $03,
                       advNA              = $ff);
  TTransportMode    = (tmDriving          = 0,
                       tmAutoMotive       = 1,
                       tmPedestrian       = 2,
                       tmMotorcycling     = 9,
                       tmOffRoad          = 10);
  TRoutePoint       = (rpVia              = 0,
                       rpShaping          = 1,
                       rpShapingXT2       = 2);
  TUdbDirStatus     = (udsUnchecked, udsRoutePointNOK, udsRoadNOK, UdsRoadOKCoordsNOK, udsCoordsNOK);
  TItemEditMode     = (emNone, emEdit, emPickList, emButton);

implementation

end.
