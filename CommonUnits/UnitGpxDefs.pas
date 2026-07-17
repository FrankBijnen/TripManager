unit UnitGpxDefs;

interface

uses
  UnitVerySimpleXml;

const
  EarthRadiusKm: Double       = 6371.009;
  EarthRadiusMi: Double       = 3958.761;
  ProcessCategoryPick: string = 'None' + #10 + 'Symbol' + #10 + 'GPX filename' + #10 + 'Symbol + GPX filename';
  LatLonFormat                = '%1.5f';
  DirectRoutingClass          = '000000000000FFFFFFFFFFFFFFFFFFFFFFFF';
  RecalcMapSeg                = 'FFFFFFFF';          // Mapseg and RoadId forcing a recalc
  RecalcRoad                  = 'FFFFFFFF';          // Mapseg and RoadId forcing a recalc
  RecalcMapSegAndRoad         = RecalcMapSeg + RecalcRoad ;
  MapSegRoadMask              = $ffff7f8d;           // Mask out flag bits in road id.
  LeaveRoutePoint             = '2116';
  ApproachRoutePoint          = '2117';
  TrkOrigin                   = 'Trk';
  RteOrigin                   = 'Rte';
  GpxExtension                = '.gpx';
  GpxMask                     = '*' + GpxExtension;
  NotApplicable               = 'N/A';

type
  TDistanceUnit = (duKm, duMi);
  TProcessCategory = (pcSymbol, pcGPX);
  TProcessPointType = (pptNone, pptWayPt, pptViaPt, pptShapePt);
  TShapingPointName = (Unchanged, Route_Sequence, Route_Distance, Sequence_Route, Distance_Route);
  TCoords = record
    Lat: double;
    Lon: double;
    procedure FormatLatLon(var OLat: string; var OLon: string; const FormatStr: string = '');
    procedure FromAttributes(Attributes: TObject);
  end;
  TGPXFunc = (PostProcess, CreateTracks, CreateWayPoints, CreatePOI, CreateKML,
              CreateHTML, CreateKurviger, CreatePoly, CreateRoutes, CreateTrips, CreateOSMPoints, CreateFITPoints,
              CreateCompleteRoutes);
  TGPXFuncArray = array of TGPXFunc;
  TSubClassType = set of (scCompare, scFirst, ScLast);
  // Note: See TModelConv for mapping to TripModel
  TGarminModel  = (XT, XT2, XT3, Tread2,
                   Zumo346, Zumo595, Zumo590, Zumo3x0,
                   Drive51, Drive66, Nuvi2595, Nuvi2599, Nuvi57,
                   GarminEdge, GarminForeRunner,
                   GarminGeneric, Unknown);

  TTagsToShow = (WptRte = 1, WptTrk = 2, WptRteTrk = 3, RteTrk = 10, Rte = 20, Trk = 30);
  THtmlOutput = (OSM, Kurviger, Both);

function Coord2Float(ACoord: LongInt): string;
function Float2Coord(ACoord: Double): LongInt;
function CoordDistance(Coord1, Coord2: TCoords; DistanceUnit: TDistanceUnit): double;
function GetFirstGpxxRptNode(const ARtePt: TXmlVSNode): TXmlVSNode;
function GetLastGpxxRptNode(const ARtePt: TXmlVSNode): TXmlVSNode;
function GetTMExtensionsNode(const ARtePt: TXmlVSNode): TXmlVSNode;
function RecalcSubClass(ASubClass: string): string;

implementation

uses
  System.SysUtils, System.Math,
  UnitStringUtils;

var
  FormatSettings: TFormatSettings;

procedure TCoords.FormatLatLon(var OLat: string; var OLon: string; const FormatStr: string = '');
var
  Fmt: string;
begin
  if (FormatStr <> '') then
    Fmt := FormatStr
  else
    Fmt := LatLonFormat;
  OLat := Format(Fmt, [Lat], FormatSettings);
  OLon := Format(Fmt, [Lon], FormatSettings);
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
    Self := Default(TCoords);
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

function GetRoutePointExtensionsNode(const ARtePt: TXmlVSNode): TXmlVSNode;
var
  ExtensionsNode: TXmlVSNode;
begin
  ExtensionsNode := ARtePt.Find('extensions');
  if (ExtensionsNode = nil) then
    exit(nil);

  result := ExtensionsNode.Find('gpxx:RoutePointExtension');
end;

function GetFirstGpxxRptNode(const ARtePt: TXmlVSNode): TXmlVSNode;
begin
  result := GetRoutePointExtensionsNode(ARtePt);
  if (result = nil) then
    exit(nil);

  result := result.Find('gpxx:rpt');
end;

function GetLastGpxxRptNode(const ARtePt: TXmlVSNode): TXmlVSNode;
begin
  result := GetRoutePointExtensionsNode(ARtePt);
  if (result = nil) then
    exit(nil);

  result := result.LastChild;

  // Should be a 'gpxx:rpt'. Need to check.
  while (result.Name <> 'gpxx:rpt') and
        (result.PreviousSibling <> nil) do
    result := result.PreviousSibling;
end;

function GetTMExtensionsNode(const ARtePt: TXmlVSNode): TXmlVSNode;
begin
  result := GetRoutePointExtensionsNode(ARtePt);
  if (result = nil) then
    exit(nil);

  result := result.Find('gpxx:Extensions');
end;

function RecalcSubClass(ASubClass: string): string;
begin
  result := ASubClass;
  if (Length(result) < Length(RecalcMapSegAndRoad)) then
    result := RecalcMapSegAndRoad +   // Unknown MapSeg and Road
              LeaveRoutePoint +       // Leave Route point
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
