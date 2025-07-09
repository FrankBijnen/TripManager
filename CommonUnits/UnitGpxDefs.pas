unit UnitGpxDefs;

interface

const
  ProcessCategoryPick: string = 'None' + #10 + 'Symbol' + #10 + 'GPX filename' + #10 + 'Symbol + GPX filename';
  LatLonFormat = '%1.5f';

type
  TDistanceUnit = (duKm, duMi);
  TProcessCategory = (pcSymbol, pcGPX);
  TProcessPointType = (pptNone, pptWayPt, pptViaPt, pptShapePt);
  TShapingPointName = (Unchanged, Route_Sequence, Route_Distance, Sequence_Route, Distance_Route);
  TCoord = record
    Lat: double;
    Lon: double;
    procedure FormatLatLon(var OLat: string; var OLon: string);
  end;
  TGPXFunc = (PostProcess, CreateTracks, CreateWayPoints, CreatePOI, CreateKML,
              CreateHTML, CreatePoly, CreateRoutes, CreateTrips, CreateOSMPoints);
  TGPXFuncArray = Array of TGPXFunc;

implementation

uses
  System.SysUtils,
  UnitStringUtils;
var
  FormatSettings: TFormatSettings;

procedure TCoord.FormatLatLon(var OLat: string; var OLon: string);
begin
  OLat := Format(LatLonFormat, [Lat], FormatSettings);
  OLon := Format(LatLonFormat, [Lon], FormatSettings);
end;

initialization
begin
  FormatSettings := GetLocaleSetting;
end;

end.
