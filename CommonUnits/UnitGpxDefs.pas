unit UnitGpxDefs;

interface

uses
  UnitVerySimpleXml, System.Generics.Collections;

const
  EarthRadiusKm: Double       = 6371.009;
  EarthRadiusMi: Double       = 3958.761;
  ProcessCategoryPick: string = 'None' + #10 + 'Symbol' + #10 + 'GPX filename' + #10 + 'Symbol + GPX filename';
  LatLonFormat                = '%1.5f';
  RecalcMapSegAndRoad         = 'FFFFFFFFFFFFFFFF';  // Mapseg and RoadId forcing a recalc

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
              CreateHTML, CreatePoly, CreateRoutes, CreateTrips, CreateOSMPoints, CreateFITPoints,
              CreateCompleteRoutes);
  TGPXFuncArray = Array of TGPXFunc;
  TSubClassType = set of (scCompare, scFirst, ScLast);
  // Note: See TModelConv for mapping to TripModel
  TGarminModel  = (XT, XT2, Tread2, Zumo59x, Drive51, Zumo3x0, GarminEdge, GarminGeneric, Unknown);

  // Trip Info to CSV
  TTripInfo = class(TObject)
    SegmentId: integer;
    RoutePointId: integer;
    RoutePoint: string;
    RoadClass: byte;
    MapSegRoadId: string;
    Description: string;
    Coords: string;
    Speed: integer;
    Distance: double;
    Time: double;
  end;
  TTripInfoList = TObjectDictionary<string, TTripInfo>;
  TTagsToShow = (WptRteTrk = 1, RteTrk = 10, Rte = 20, Trk = 30);

function Coord2Float(ACoord: LongInt): string;
function Float2Coord(ACoord: Double): LongInt;
function CoordDistance(Coord1, Coord2: TCoords; DistanceUnit: TDistanceUnit): double;
function GetFirstExtensionsNode(const ARtePt: TXmlVSNode): TXmlVSNode;
function GetLastExtensionsNode(const ARtePt: TXmlVSNode): TXmlVSNode;
function RecalcSubClass(ASubClass: string): string;

implementation

uses
  System.SysUtils, System.Math,
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
  try
    if Assigned(Attributes) and
       (TXmlVSAttributeList(Attributes).Count > 0) then
    with TXmlVSAttributeList(Attributes) do
    begin
      Lat := StrToFloat(Find('lat').Value, FormatSettings);
      Lon := StrToFloat(Find('lon').Value, FormatSettings);
    end;
  except
    FillChar(Self, SizeOf(Self), 0);
  end;
end;

function Coord2Float(ACoord: LongInt): string;
var
  HCoord: Double;
begin
  result := IntToStr(ACoord);
  HCoord := ACoord;
  try
    HCoord := HCoord * 360;
    Result := result + ' * 360 = ' + FormatFloat('0', HCoord);
    HCoord := HCoord / 4294967296; {2^32}
    Result := result + ' / 2^32 = ' + FormatFloat('0.000000000000000', HCoord);
  except
    result := '';
  end;
end;

function Float2Coord(ACoord: Double): LongInt;
var
  HCoord: Double;
begin
  try
    HCoord := ACoord * 4294967296 {2^32} / 360;
    result := round(HCoord);
  except
    result := 0;
  end;
end;

function DegreesToRadians(Degrees: double): double;
begin
  result := Degrees * PI / 180;
end;

function CoordDistance(Coord1, Coord2: TCoords; DistanceUnit: TDistanceUnit): double;
var
  DLat, DLon, Lat1, Lat2, A, C: double;
begin
  DLat := DegreesToRadians(Coord2.Lat - Coord1.Lat);
  DLon := DegreesToRadians(Coord2.Lon - Coord1.lon);

  Lat1 := DegreesToRadians(Coord1.Lat);
  Lat2 := DegreesToRadians(Coord2.Lat);

  A := sin(DLat/2) * sin(DLat/2) +
       sin(DLon/2) * sin(DLon/2) * cos(Lat1) * cos(Lat2);
  C := 2 * ArcTan2(sqrt(A), sqrt(1-A));

  if (DistanceUnit = TDistanceUnit.duMi) then
    result := EarthRadiusMi * C
  else
    result := EarthRadiusKm * C;
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

function RecalcSubClass(ASubClass: string): string;
begin
  result := ASubClass;
  if (Length(result) < Length(RecalcMapSegAndRoad)) then
    result := RecalcMapSegAndRoad +   // Unknown MapSeg and Road
              '2116' +                // Leave Route point
              '000000000000'
  else
  begin
    Delete(result, 1 ,Length(RecalcMapSegAndRoad));
    Insert(RecalcMapSegAndRoad, result, 1);
  end;
end;

initialization
begin
  FormatSettings := GetLocaleSetting;
end;

end.
