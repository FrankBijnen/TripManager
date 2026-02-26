unit UnitTripDefs;

interface

type
  TTripModel    = (XT, XT2, XT3, Tread2, Zumo595, Zumo590, Zumo3x0, Drive51, Drive66, Nuvi2595, Unknown);
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

  TUnixDateConv = class
    class function DateTimeAsCardinal(ADateTime: TDateTime): Cardinal;
    class function CardinalAsDateTime(ACardinal: Cardinal): TDateTime;
    class function CardinalAsDateTimeString(ACardinal: Cardinal): string;
  end;

const
  TripExtension           = '.trip';
  TripMask                = '*' + TripExtension;

implementation

uses
  System.SysUtils, System.DateUtils;

class function TUnixDateConv.DateTimeAsCardinal(ADateTime: TDateTime): Cardinal;
var
  ValueEpoch: int64;
  ValueUnix: int64;
begin
  result := 0;
  if (ADateTime <> 0) then
  begin
    ValueUnix := DateTimeToUnix(ADateTime, false);
    ValueEpoch := DateTimeToUnix(EncodeDateTime(1989, 12, 31, 0, 0, 0, 0));
    result := ValueUnix - ValueEpoch;
  end;
end;

class function TUnixDateConv.CardinalAsDateTime(ACardinal: Cardinal): TDateTime;
var
  ValueEpoch: int64;
begin
  ValueEpoch := ACardinal + DateTimeToUnix(EncodeDateTime(1989,12,31,0,0,0,0)); // Starts from 1989/12/31
  result := UnixToDateTime(ValueEpoch, false);
end;

class function TUnixDateConv.CardinalAsDateTimeString(ACardinal: Cardinal): string;
begin
  result := Format('%s', [DateTimeToStr(CardinalAsDateTime(ACardinal))]);
end;

end.
