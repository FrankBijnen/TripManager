unit UnitGpxDefs;

interface
uses
  UnitVerySimpleXml;

const
  ProcessCategoryPick: string = 'None' + #10 + 'Symbol' + #10 + 'GPX filename' + #10 + 'Symbol + GPX filename';
  LatLonFormat = '%1.5f';

type
  TDistanceUnit = (duKm, duMi);
  TProcessCategory = (pcSymbol, pcGPX);
  TProcessPointType = (pptNone, pptWayPt, pptViaPt, pptShapePt);
  TShapingPointName = (Unchanged, Route_Sequence, Route_Distance, Sequence_Route, Distance_Route);
  TCoords = record
    Lat: double;
    Lon: double;
    procedure FormatLatLon(var OLat: string; var OLon: string);
    procedure FromAttributes(Attributes: TObject);
  end;
  TGPXFunc = (PostProcess, CreateTracks, CreateWayPoints, CreatePOI, CreateKML,
              CreateHTML, CreatePoly, CreateRoutes, CreateTrips, CreateOSMPoints);
  TGPXFuncArray = Array of TGPXFunc;
  TSubClassType = set of (scCompare, scFirst, ScLast);

function GetFirstExtensionsNode(const ARtePt: TXmlVSNode): TXmlVSNode;
function GetLastExtensionsNode(const ARtePt: TXmlVSNode): TXmlVSNode;

implementation

uses
  System.SysUtils,
  UnitStringUtils;

var
  FormatSettings: TFormatSettings;

procedure TCoords.FormatLatLon(var OLat: string; var OLon: string);
begin
  OLat := Format(LatLonFormat, [Lat], FormatSettings);
  OLon := Format(LatLonFormat, [Lon], FormatSettings);
end;

procedure TCoords.FromAttributes(Attributes: TObject);
begin
  with TXmlVSAttributeList(Attributes) do
  begin
    Lat := StrToFloat(Find('lat').Value, FormatSettings);
    Lon := StrToFloat(Find('lon').Value, FormatSettings);
  end;
end;

function GetExtensionsNode(const ARtePt: TXmlVSNode; const LastChild: boolean): TXmlVSNode;
var
  ExtensionsNode, RoutePointExtensionNode: TXmlVSNode;
begin
  ExtensionsNode := ARtePt.Find('extensions');
  if (ExtensionsNode = nil) then
    exit(nil);

  RoutePointExtensionNode := ExtensionsNode.Find('gpxx:RoutePointExtension');
  if (RoutePointExtensionNode = nil) then
    exit(nil);

  if (LastChild) then
    exit(RoutePointExtensionNode.LastChild);  // Should be a 'gpxx:rpt'. Need to check?

  result := RoutePointExtensionNode.Find('gpxx:rpt')
end;

function GetFirstExtensionsNode(const ARtePt: TXmlVSNode): TXmlVSNode;
begin
  result := GetExtensionsNode(ARtePt, false);
end;

function GetLastExtensionsNode(const ARtePt: TXmlVSNode): TXmlVSNode;
begin
  result := GetExtensionsNode(ARtePt, true);
end;

initialization
begin
  FormatSettings := GetLocaleSetting;
end;

end.
