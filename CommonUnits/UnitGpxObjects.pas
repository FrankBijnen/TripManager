unit UnitGPXObjects;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  System.Classes, System.SysUtils,
  WinApi.Windows, System.Math,
  Xml.XMLIntf, UnitVerySimpleXml,
  UnitGpxDefs,
  UnitProcessOptions,
  kml_helper,
  UfrmSelectGpx,
{$IFDEF MAPUTILS}
  UnitMapUtils,
{$ENDIF}
{$IFDEF TRIPOBJECTS}
  UnitTripObjects,
{$ENDIF}
{$IFDEF GEOCODE}
  UnitGeoCode,
{$ENDIF}
  UnitGPI, UnitBMP,
  Vcl.ComCtrls;

type

  TGPXFile = class
  private
    FWayPointList: TXmlVSNodeList;          // All Original way point
    FWayPointFromRouteList: TXmlVSNodeList; // Used in CreateWaypoints and CreatePoi. Has Categories. Only private
    FRouteViaPointList: TXmlVSNodeList;     // Used in CreateOSM(Points), CreateKml, CreatePoly. Exposed public
    FTrackList: TXmlVSNodeList;             // All tracks. Can be created from calculated routes
    FWayPointsProcessedList: TStringList;   // To prevent duplicate Way points

    CurrentTrack: TXmlVSNode;
    CurrentViaPointRoute: TXmlVSNode;
    CurrentWayPointFromRoute: TXmlVSNode;
    CurrentRouteTrackName: string;
    ShapingPointCnt: integer;               // Counter of all <trp:ShapingPoint>. Seqnr of name

    CurrentCoord: TCoord;
    TotalDistance: double;
    CurrentDistance: double;
    PrevCoord: TCoord;

    FXmlDocument: TXmlVSDocument;
    FOutDir: string;
    FOnFunctionPrefs: TNotifyEvent;
    FOnSavePrefs: TNotifyEvent;
    FOutStringList: TStringList;
    FBaseFile: string;
    FGPXFile: string;
{$IFDEF TRIPOBJECTS}
    FSeqNo: cardinal;
    FTripList: TTripList;
{$ENDIF}
    FProcessOptions: TProcessOptions;
    function DistanceFormat(Distance: double): string;
    function DebugCoords(Coords: TXmlVSAttributeList): string;
    function GetTrackColor(ANExtension: TXmlVsNode): string;
{$IFDEF MAPUTILS}
    function GetFirstSubClass(const ExtensionNode: TXmlVSNode): string;
    function MapSegFromSubClass(const CalculatedSubclass: string): integer;
{$ENDIF}
    function WayPointNotProcessed(WayPoint: TXmlVSNode): boolean;
    function GPXWayPoint(CatId, BmpId: integer; WayPoint: TXmlVSNode): TGPXWayPoint;
    function GetSpeedFromName(WptName: string): integer;
    function GPXBitMap(WayPoint: TXmlVSNode): TGPXBitmap;
    function GPXCategory(Category: string): TGPXCategory;

    procedure FreeGlobals;
    procedure CreateGlobals;
    procedure ClearGlobals;

    procedure ProcessGPX;

    procedure ComputeDistance(RptNode: TXmlVSNode);
    procedure ClearSubClass(ANode: TXmlVSNode);
    procedure UnglitchNode(RtePtNode, ExtensionNode: TXmlVSNode; ViaPtName:TGPXString);
    procedure EnsureSubNodeAfter(ANode: TXmlVSNode; ChildNode: string; const AfterNodes: array of string);
    procedure RenameSubNode(RtePtNode: TXmlVSNode; const NodeName:string; const NewName: string);
    procedure LookUpAddrRtePt(RtePtNode: TXmlVSNode);
    procedure RenameNode(RtePtNode: TXmlVSNode; const NewName: string = '');
    procedure AddRouteCategory(const ExtensionsNode: TXmlVsNode;
                               const NS, Symbol, Route: string);
    procedure ReplaceAutoName(const ExtensionsNode: TXmlVsNode; const AutoName: string);
    procedure ReplaceCategory(const ExtensionsNode: TXmlVsNode; const NS, Category: string);
    procedure ReplaceAddrWayPt(ExtensionsNode: TXmlVSNode; const NS: string);
    procedure AddWptPoint(const ChildNode: TXmlVsNode;
                          const RtePtNode: TXmlVsNode;
                          const WayPointName: string;
                          const ProcessPointType: TProcessPointType;
                          const Symbol: string = '';
                          const Description: string = '');

    procedure AddWayPointFromRoute(const RtePtNode: TXmlVsNode;
                                   const WayPointName: string;
                                   const ViaPt: boolean;
                                   const Symbol: string;
                                   const Category: string;
                                   const Route: string);
    procedure AddViaOrShapePoint(const RtePtNode: TXmlVsNode;
                                 const ViaOrShapingPointName: string;
                                 const Symbol: string;
                                 const ProcessPointType: TProcessPointType;
                                 const Category: string);

    procedure AddBeginPoint(const RtePtNode: TXmlVsNode;
                            const ViaPointName: string;
                            const Symbol: string);
    procedure AddEndPoint(const RtePtNode: TXmlVsNode;
                          const ViaPointName: string;
                          const Symbol: string);
    procedure AddViaPoint(const RtePtNode: TXmlVsNode;
                          const ViaPointName: string;
                          const Symbol: string);
    procedure AddShapingPoint(const RtePtNode: TXmlVsNode;
                              const ShapingPointName: string;
                              const Symbol: string);
    procedure AddWayPoint(const RtePtNode: TXmlVsNode;
                          const WayPointName: string);
    procedure AddTrackPoint(const RptNode: TXmlVsNode);
    procedure ProcessRtePt(const RtePtNode: TXmlVsNode;
                           const RouteName: string;
                           const Cnt, LastCnt: integer);
    procedure ProcessRte(const RteNode: TXmlVSNode);
    procedure ProcessTrk(const TrkNode: TXmlVSNode);
    procedure ProcessWpt(const WptNode: TXmlVSNode);
    procedure ProcessGPXNode(GpxNode: TXmlVSNode);
    procedure StripRtePt(const RtePtNode: TXmlVSNode);
    procedure StripRte(const RteNode: TXmlVSNode);
{$IFDEF TRIPOBJECTS}
    function CreateLocations(RtePts: TXmlVSNodeList): integer;
    procedure CreateTrip_XT(const TripName, CalculationMode, TransportMode: string;
                            ParentTripID: Cardinal; RtePts: TXmlVSNodeList);

    procedure CreateTrip_XT2(const TripName, CalculationMode, TransportMode: string;
                             ParentTripID: Cardinal; RtePts: TXmlVSNodeList);
{$ENDIF}
  protected
    procedure CloneAttributes(FromNode, ToNode: TXmlVsNode);
    procedure CloneSubNodes(FromNodes, ToNodes: TXmlVsNodeList);
    procedure CloneNode(FromNode, ToNode: TXmlVsNode);
    procedure Track2OSMTrackPoints(Track: TXmlVSNode;
                                   var TrackId: integer;
                                   TrackStringList: TStringList);
  public
    var FrmSelectGpx: TFrmSelectGPX;
    constructor Create(const GPXFile:string;
                       const FunctionPrefs, SavePrefs: TNotifyEvent); overload;
    constructor Create(const GPXFile:string;
                       const OutDir: string;
                       const FunctionPrefs, SavePrefs: TNotifyEvent;
                       const OutStringList: TStringList = nil;
                       const SeqNo: cardinal = 0); overload;
    destructor Destroy; override;
    function ShowSelectTracks(const Caption, SubCaption: string; TagsToShow: TTagsToShow; CheckMask: string): boolean;
    procedure DoPostProcess;
    procedure DoCreateTracks;
    procedure DoCreateWayPoints;
    procedure DoCreatePOI;
    procedure DoCreateKML;
    procedure DoCreateHTML;
    procedure DoCreateOSMPoints;
    procedure DoCreatePOLY;
    procedure DoCreateRoutes;
    procedure DoCreateTrips;
{$IFDEF TRIPOBJECTS}
    procedure ProcessTrip(const RteNode: TXmlVSNode; ParentTripId: Cardinal);
{$ENDIF}
    procedure AnalyzeGpx;
    property WayPointList: TXmlVSNodeList read FWayPointList;
    property RouteViaPointList: TXmlVSNodeList read FRouteViaPointList;
    property TrackList: TXmlVSNodeList read FTrackList;
    property XmlDocument: TXmlVSDocument read FXmlDocument;

    property ProcessOptions: TProcessOptions read FProcessOptions write FProcessOptions;

    class function Coord2Float(ACoord: LongInt): string;
    class function Float2Coord(ACoord: Double): LongInt;
    class function DegreesToRadians(Degrees: double): double;
    class function CoordFromAttribute(Attributes: TXmlVSAttributeList): TCoord;
    class function CoordDistance(Coord1, Coord2: TCoord; DistanceUnit: TDistanceUnit): double;
    class procedure PerformFunctions(const AllFuncs: array of TGPXFunc;
                                     const GPXFile:string;
                                     const FunctionPrefs, SavePrefs: TNotifyEvent;
                                     const ForceOutDir: string = '';
                                     const OutStringList: TStringList = nil;
                                     const SeqNo: cardinal = 0);

end;

implementation

uses
  System.TypInfo, System.DateUtils, System.StrUtils,
  UnitStringUtils, UnitOSMMap;

// Not configurable
const
  EarthRadiusKm: Double = 6371.009;
  EarthRadiusMi: Double = 3958.761;

  DebugComments: string = 'False';
  UniqueTracks: boolean = true;
  DeleteWayPtsInRoute: boolean = true;    // Remove Waypoints from stripped routes
  DeleteTracksInRoute: boolean = true;    // Remove Tracks from stripped routes
  DirectRoutingClass = '000000000000FFFFFFFFFFFFFFFFFFFFFFFF';
  UnglitchTreshold: double = 0.0005;      // In Km. ==> 50 Cm

var
  FormatSettings: TFormatSettings;

class function TGPXfile.CoordFromAttribute(Attributes: TXmlVSAttributeList): TCoord;
begin
  result.Lat := StrToFloat(Attributes.Find('lat').Value, FormatSettings);
  result.Lon := StrToFloat(Attributes.Find('lon').Value, FormatSettings);
end;

class function TGPXfile.DegreesToRadians(Degrees: double): double;
begin
  result := Degrees * PI / 180;
end;

class function TGPXfile.CoordDistance(Coord1, Coord2: TCoord; DistanceUnit: TDistanceUnit): double;
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

class function TGPXfile.Coord2Float(ACoord: LongInt): string;
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

class function TGPXfile.Float2Coord(ACoord: Double): LongInt;
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

function TGPXfile.DistanceFormat(Distance: double): string;
begin
  if (Distance < 100) then
    result := '%4.1f'
  else if (Distance < 1000) then
    result := '%3.0f'
  else
    result := '%4.0f';
  result := result + ' ' + ProcessOptions.DistanceStr;
end;

function TGPXfile.DebugCoords(Coords: TXmlVSAttributeList): string;
var LastSub, Hex, LatLon: string;
    Coord: TCoord;
begin
  Coord := CoordFromAttribute(Coords);
  Hex := IntToHex(Float2Coord(Coord.Lat), 8);
  LatLon := Hex + ' = ' + Coord2Float(Float2Coord(Coord.Lat));
  LastSub := Copy(Hex, 5, 2) + Copy(Hex, 3, 2);
  result := Copy(Hex, 1, 2);
  Hex := IntToHex(Float2Coord(Coord.Lon),8);
  LatLon := LatLon + ' ' + Hex + ' = ' + Coord2Float(Float2Coord(Coord.Lon));
  LastSub := LastSub + Copy(Hex, 5, 2) + Copy(Hex, 3, 2);
  result := result + Copy(Hex, 1, 2) + 'xx';
  result := result + LastSub + ' ' + LatLon;
end;

procedure TGPXfile.FreeGlobals;
begin
  FrmSelectGpx.Free;
  FProcessOptions.Free;
  FreeAndNil(FRouteViaPointList);
  FreeAndNil(FWayPointFromRouteList);
  FreeAndNil(FWayPointList);
  FreeAndNil(FTrackList);
  FreeAndNil(FWayPointsProcessedList);
  FreeAndNil(FXmlDocument);
end;

procedure TGPXfile.CreateGlobals;
begin
  FProcessOptions := TProcessOptions.Create(FOnFunctionPrefs, FOnSavePrefs);
  FRouteViaPointList := TXmlVSNodeList.Create;
  FWayPointFromRouteList := TXmlVSNodeList.Create;
  FWayPointList := TXmlVSNodeList.Create;
  FTrackList := TXmlVSNodeList.Create;
  FWayPointsProcessedList := TStringList.Create;
  FXmlDocument := TXmlVSDocument.Create;
  FrmSelectGpx := TFrmSelectGPX.Create(nil);
end;

procedure TGPXfile.ClearGlobals;
begin
  FXmlDocument.Clear;
  FRouteViaPointList.Clear;
  FWayPointFromRouteList.Clear;
  FWayPointList.Clear;
  FTrackList.Clear;
  FWayPointsProcessedList.Clear;
end;

procedure TGPXfile.CloneAttributes(FromNode, ToNode: TXmlVsNode);
var
  Attribute: TXmlVSAttribute;
begin
  for Attribute in FromNode.AttributeList do
    ToNode.SetAttribute(Attribute.Name, Attribute.Value);
end;

procedure TGPXfile.CloneSubNodes(FromNodes, ToNodes: TXmlVsNodeList);
var
  SubNode, ToSubNode: TXmlVsNode;
begin
  for SubNode in FromNodes do
  begin
    ToSubNode := ToNodes.Add(SubNode.Name);
    ToSubNode.NodeType := SubNode.NodeType;
    ToSubNode.NodeValue := SubNode.NodeValue;
    CloneAttributes(SubNode, ToSubNode);
    CloneSubNodes(SubNode.ChildNodes, ToSubNode.ChildNodes);
  end;
end;

procedure TGPXfile.CloneNode(FromNode, ToNode: TXmlVsNode);
begin
  ToNode.NodeType := FromNode.NodeType;
  CloneAttributes(FromNode, ToNode);
  CloneSubNodes(FromNode.ChildNodes, ToNode.ChildNodes);
end;

procedure TGPXfile.EnsureSubNodeAfter(ANode: TXmlVSNode; ChildNode: string; const AfterNodes: array of string);
var
  Pos: integer;
  AfterNode: string;
begin
  if (ANode.Find(ChildNode) = nil) then
  begin
    for AfterNode in AfterNodes do
    begin
      Pos := ANode.FindPos(AfterNode);
      if (Pos <> -1) then
      begin
        ANode.InsertChild(ChildNode, Pos +1);
        exit;
      end;
    end;
    ANode.InsertChild(ChildNode, 0); // Add first
  end;
end;

function TGPXfile.GetTrackColor(ANExtension: TXmlVsNode): string;
begin
  result := '';
  if (ANExtension <> nil) then
    result := FindSubNodeValue(ANExtension, 'gpxx:DisplayColor');
  if (result = '') then
    result := ProcessOptions.DefTrackColor;
end;

{$IFDEF MAPUTILS}
function TGPXfile.GetFirstSubClass(const ExtensionNode: TXmlVSNode): string;
var
  GpxxRptNode: TXmlVSNode;
begin
  for GpxxRptNode in ExtensionNode.ChildNodes do
  begin
    if (GpxxRptNode.NodeName <> 'gpxx:rpt') then
      Continue;
    result := FindSubNodeValue(GpxxRptNode, 'gpxx:Subclass');
    if (Length(Result) < 14) then
      Continue;
    result := Copy(result, 5, 8);
    if (result = '00000000') then
      continue;
    break;
  end;
end;

function TGPXfile.MapSegFromSubClass(const CalculatedSubclass: string): integer;
var
  ErrCode: DWORD;
  Reversed: string;
begin
  Reversed := '$' + Copy(CalculatedSubclass, 7, 2) +
                    Copy(CalculatedSubclass, 5, 2) +
                    Copy(CalculatedSubclass, 3, 2) +
                    Copy(CalculatedSubclass, 1, 2);
  Val(Reversed, result, ErrCode);
end;
{$ENDIF}

procedure TGPXfile.ComputeDistance(RptNode: TXmlVSNode);
begin
  CurrentCoord := CoordFromAttribute(RptNode.AttributeList);
  CurrentDistance := CoordDistance(PrevCoord, CurrentCoord, ProcessOptions.DistanceUnit);
  TotalDistance := TotalDistance + CurrentDistance;
  PrevCoord := CurrentCoord;
end;

procedure TGPXfile.ClearSubClass(ANode: TXmlVSNode);
var
  SubClassNode: TXmlVSNode;
begin
  if (ANode = nil) then
    exit;
  SubClassNode := ANode.Find('gpxx:Subclass');
  if (SubClassNode <> nil) and
     (SubClassNode.NodeValue <> DirectRoutingClass)  then
  begin
    if (DebugComments = 'True') then
      SubClassNode.ChildNodes.Add(TXmlVSNodeType.ntComment).Text := SubClassNode.NodeValue;
    SubClassNode.NodeValue := DirectRoutingClass;
  end;
end;

procedure TGPXfile.UnglitchNode(RtePtNode, ExtensionNode: TXmlVSNode; ViaPtName:TGPXString);
var
  RptNode, DebugNode: TXmlVSNode;
  ViaPtCoord, NextCoord: TCoord;
  Distance: Double;
begin
  if (RtePtNode = nil) or
     (ExtensionNode = nil) then
    exit;

  RptNode := ExtensionNode.Find('gpxx:rpt');
  if (RptNode = nil) then
     exit;

// We could compare Lat and Lon values, but instead we compute the distance.
// Slower, but nicer.
  ViaPtCoord := CoordFromAttribute(RptNode.AttributeList);
  NextCoord := CoordFromAttribute(RtePtNode.AttributeList);
  Distance := CoordDistance(ViaPtCoord, NextCoord, ProcessOptions.DistanceUnit);

  if (Abs(Distance) > UnglitchTreshold) then
  begin
    if (DebugComments = 'True') then
    begin
      DebugNode := TXmlVSNode.Create(TXmlVSNodeType.ntComment);
      DebugNode.Text := 'Old Values: ' + RtePtNode.AttributeList.AsString;
      RtePtNode.ChildNodes.Insert(0, DebugNode);
    end;
    // Copy Lat and Lon from next 'Ghost point' to 'Route Point'
    CloneAttributes(RptNode, RtePtNode);
  end;

  if (DebugComments = 'True') then
    RptNode.ChildNodes.Add(TXmlVSNodeType.ntComment).Text := DebugCoords(RptNode.AttributeList);
end;

procedure TGPXfile.RenameSubNode(RtePtNode: TXmlVSNode; const NodeName:string; const NewName: string);
var
  SubNode: TXmlVSNode;
begin
  SubNode := RtePtNode.Find(NodeName);
  if (SubNode = nil) then
      exit;
  SubNode.NodeValue := NewName;
end;

procedure TGPXfile.LookUpAddrRtePt(RtePtNode: TXmlVSNode);
{$IFDEF GEOCODE}
var
  Lat, Lon: string;
  Place: TPlace;
{$ENDIF}
begin
{$IFDEF GEOCODE}
  Lat := RtePtNode.AttributeList.Find('lat').Value;
  Lon := RtePtNode.AttributeList.Find('lon').Value;
  AdjustLatLon(Lat, Lon, Place_Decimals);

  EnsureSubNodeAfter(RtePtNode, 'cmt', ['name']);
  RenameSubNode(RtePtNode, 'cmt',  Format('%s, %s', [Lat, Lon], FormatSettings));
  Place := GetPlaceOfCoords(Lat, Lon, ProcessOptions.LookUpWindow, ProcessOptions.LookUpMessage);
  if (Place <> nil) then
    RenameSubNode(RtePtNode, 'cmt',  Place.RoutePlace);
{$ENDIF}
end;

procedure TGPXfile.RenameNode(RtePtNode: TXmlVSNode; const NewName: string = '');
begin
  RenameSubNode(RtePtNode, 'name', NewName);
end;

procedure TGPXfile.AddRouteCategory(const ExtensionsNode: TXmlVsNode;
                                    const NS, Symbol, Route: string);
var
  AnExtensionsNode: TXmlVsNode;
begin
  AnExtensionsNode := ExtensionsNode.AddChild(NS + 'WaypointExtension');
  AnExtensionsNode := AnExtensionsNode.AddChild(NS + 'Categories');
  AnExtensionsNode.AddChild(NS + 'Category').NodeValue := ProcessOptions.CatSymbol + Symbol;
  AnExtensionsNode.AddChild(NS + 'Category').NodeValue := ProcessOptions.CatRoute + Route;
end;

procedure TGPXfile.ReplaceAutoName(const ExtensionsNode: TXmlVsNode; const AutoName: string);
var
  RouteExtensionsNode, AutoNameNode: TXmlVsNode;
begin
  RouteExtensionsNode := ExtensionsNode.Find('gpxx:RouteExtension');
  if (RouteExtensionsNode = nil) then
    exit;
  AutoNameNode := RouteExtensionsNode.find('gpxx:IsAutoNamed');
  if (AutoNameNode = nil) then
    exit;
  AutoNameNode.NodeValue := AutoName;
end;

procedure TGPXfile.ReplaceCategory(const ExtensionsNode: TXmlVsNode; const NS, Category: string);
var
  AnExtensionsNode, CategoriesNode: TXmlVsNode;
  CatPos:integer;
begin
  if (ExtensionsNode = nil) then
    exit;

  AnExtensionsNode := ExtensionsNode.Find(NS + 'WaypointExtension');
  if (AnExtensionsNode = nil) then   // Extensions node must exist. (Saved by Basecamp!)
    exit;

  // Find or Create Categories node. Must be after Displaymode
  EnsureSubNodeAfter(AnExtensionsNode, NS + 'Categories', [NS + 'DisplayMode']);
  CategoriesNode := AnExtensionsNode.find(NS + 'Categories');

  // Always delete these categories
  for CatPos := CategoriesNode.ChildNodes.Count -1 downto 0 do
  begin
    if (StartsText(ProcessOptions.CatSymbol, CategoriesNode.ChildNodes[CatPos].NodeValue)) or
       (StartsText(ProcessOptions.CatGPX, CategoriesNode.ChildNodes[CatPos].NodeValue)) then
      CategoriesNode.ChildNodes.Delete(CatPos);
  end;
  // And add them if requested
  if (pcSymbol in ProcessOptions.ProcessCategory) then
    CategoriesNode.AddChild(NS + 'Category').NodeValue := ProcessOptions.CatSymbol + Category;
  if (pcGPX in ProcessOptions.ProcessCategory) then
    CategoriesNode.AddChild(NS + 'Category').NodeValue := ProcessOptions.CatGPX + FBaseFile;

  // Mapsource and BaseCamp dont like <Categories/>
  if (CategoriesNode.ChildNodes.Count = 0) then
  begin
    CatPos := AnExtensionsNode.findPos(NS + 'Categories');
    AnExtensionsNode.ChildNodes.Delete(CatPos);
  end;
end;

procedure TGPXFile.ReplaceAddrWayPt(ExtensionsNode: TXmlVSNode; const NS: string);
{$IFDEF GEOCODE}
var
  WptNode: TXmlVsNode;
  Lat, Lon: string;
  Place: TPlace;
  AnExtensionsNode, AddressNode: TXmlVsNode;
{$ENDIF}
begin
{$IFDEF GEOCODE}
  WptNode := ExtensionsNode.Parent;
  Lat := WptNode.AttributeList.Find('lat').Value;
  Lon := WptNode.AttributeList.Find('lon').Value;
  AdjustLatLon(Lat, Lon, Place_Decimals);
  Place := GetPlaceOfCoords(Lat, Lon, ProcessOptions.LookUpWindow, ProcessOptions.LookUpMessage);
  if (Place <> nil) then
  begin
    EnsureSubNodeAfter(WptNode, 'cmt', ['name']);
    RenameSubNode(WptNode, 'cmt', Place.FormattedAddress);

    AnExtensionsNode := ExtensionsNode.Find(NS + 'WaypointExtension');
    // Extensions node must exist. (Saved by Basecamp!)
    if (AnExtensionsNode = nil) then
      exit;

    // Find or create Address node, after Categories, or DisplayMode
    EnsureSubNodeAfter(AnExtensionsNode, NS + 'Address', [NS + 'Categories', NS + 'DisplayMode']);
    AddressNode := AnExtensionsNode.find(NS + 'Address');
    // Delete existinfg address
    AddressNode.ChildNodes.DeleteRange(0, AddressNode.ChildNodes.Count);

    AddressNode.AddChild(NS + 'StreetAddress').NodeValue := Place.Road;
    AddressNode.AddChild(NS + 'City').NodeValue := Place.City;
    AddressNode.AddChild(NS + 'State').NodeValue := Place.State;
    AddressNode.AddChild(NS + 'Country').NodeValue := Place.Country;
    AddressNode.AddChild(NS + 'PostalCode').NodeValue := Place.PostalCode;
  end;
{$ENDIF}
end;

procedure TGpxFile.AddWptPoint(const ChildNode: TXmlVsNode;
                               const RtePtNode: TXmlVsNode;
                               const WayPointName: string;
                               const ProcessPointType: TProcessPointType;
                               const Symbol: string = '';
                               const Description: string = '');
var
  ExtensionsNode: TXmlVsNode;
  NewSymbol, WptTime, WptDesc, WptCmt: string;
begin
  with ChildNode do
  begin
    CloneAttributes(RtePtNode, ChildNode);
    WptTime := FindSubNodeValue(RtePtNode, 'time');
    if (WptTime <> '') then
      AddChild('time').NodeValue := WptTime;
    AddChild('name').NodeValue := WayPointName;
    WptCmt := FindSubNodeValue(RtePtNode, 'cmt');
    if (WptCmt <> '') then
      AddChild('cmt').NodeValue := WptCmt;

    if (Description <> '') then
      WptDesc := Description
    else
      WptDesc := FindSubNodeValue(RtePtNode, 'desc');
    if (WptDesc <> '') then
      AddChild('desc').NodeValue := WptDesc;

    NewSymbol := Symbol;
    if (NewSymbol = '') then
      NewSymbol := FindSubNodeValue(RtePtNode, 'sym');
    if (NewSymbol = '') then
      NewSymbol := ProcessOptions.DefWayPointSymbol;
    AddChild('sym').NodeValue := NewSymbol;
  end;

  if (ProcessOptions.ProcessWpt) and
     (ProcessPointType in [pptWayPt]) then
  begin
    ExtensionsNode := RtePtNode.find('extensions');
    if (ExtensionsNode <> nil) then
    begin
      ReplaceCategory(ExtensionsNode, 'gpxx:', NewSymbol);
      ReplaceCategory(ExtensionsNode, 'wptx1:', NewSymbol);
      if (ProcessOptions.ProcessAddrWayPt) then
      begin
        ReplaceAddrWayPt(ExtensionsNode, 'gpxx:');
        ReplaceAddrWayPt(ExtensionsNode, 'wptx1:');
      end;
    end;
  end;
end;

procedure TGPXFile.AddWayPointFromRoute(const RtePtNode: TXmlVsNode;
                                        const WayPointName: string;
                                        const ViaPt: boolean;
                                        const Symbol: string;
                                        const Category: string;
                                        const Route: string);
var
  NewNode, ExtensionsNode: TXmlVsNode;
begin
  NewNode := CurrentWayPointFromRoute.AddChild('wpt');
  if (ViaPt) then
    AddWptPoint(NewNode,
                RtePtNode,
                WayPointName,
                TProcessPointType.pptViaPt,
                Symbol)
  else
    AddWptPoint(NewNode,
                RtePtNode,
                WayPointName,
                TProcessPointType.pptShapePt,
                Symbol);

  ExtensionsNode := NewNode.AddChild('extensions');
  if (ViaPt) then
    ExtensionsNode.AddChild('trp:ViaPoint')
  else
    ExtensionsNode.AddChild('trp:ShapingPoint');

  AddRouteCategory(ExtensionsNode, 'gpxx:', Category, Route);
  AddRouteCategory(ExtensionsNode, 'wptx1:', Category, Route);
end;

procedure TGPXFile.AddViaOrShapePoint(const RtePtNode: TXmlVsNode;
                                      const ViaOrShapingPointName: string;
                                      const Symbol: string;
                                      const ProcessPointType: TProcessPointType;
                                      const Category: string);
var
  NewNode, ExtensionsNode: TXmlVsNode;
  DefinedSymbol, Distance: string;
begin
  // If there is a symbol defined, other than Waypoint, take that.
  DefinedSymbol := FindSubNodeValue(RtePtNode, 'sym');
  if (DefinedSymbol = '') or
     (DefinedSymbol = ProcessOptions.DefShapePtSymbol) then
    DefinedSymbol := Symbol;

  NewNode := CurrentViaPointRoute.AddChild('wpt');
  Distance := '';
  if (ProcessOptions.ProcessDistance) then
    Distance := Format(DistanceFormat(TotalDistance),
                       [TotalDistance], FormatSettings);
  AddWptPoint(NewNode,
              RtePtNode,
              ViaOrShapingPointName,
              ProcessPointType,
              DefinedSymbol,
              Distance);

  ExtensionsNode := NewNode.AddChild('extensions');
  if (ProcessPointType = pptViaPt) then
    ExtensionsNode.AddChild('trp:ViaPoint');
  if (ProcessPointType = pptShapePt) then
    ExtensionsNode.AddChild('trp:ShapingPoint');
end;

procedure TGPXFile.AddBeginPoint(const RtePtNode: TXmlVsNode;
                                const ViaPointName: string;
                                const Symbol: string);
begin
  AddViaOrShapePoint(RtePtNode, ViaPointName, Symbol, TProcessPointType.pptViaPt, ProcessOptions.Beginstr);
end;

procedure TGPXFile.AddEndPoint(const RtePtNode: TXmlVsNode;
                              const ViaPointName: string;
                              const Symbol: string);
begin
  AddViaOrShapePoint(RtePtNode, ViaPointName, Symbol, TProcessPointType.pptViaPt, ProcessOptions.EndStr);
end;

procedure TGPXFile.AddViaPoint(const RtePtNode: TXmlVsNode;
                              const ViaPointName: string;
                              const Symbol: string);
begin
  AddViaOrShapePoint(RtePtNode, ViaPointName, Symbol, TProcessPointType.pptViaPt, ProcessOptions.ViaPointCategory);
end;

procedure TGPXFile.AddShapingPoint(const RtePtNode: TXmlVsNode;
                                   const ShapingPointName: string;
                                   const Symbol: string);
begin
  AddViaOrShapePoint(RtePtNode, ShapingPointName, Symbol, TProcessPointType.pptShapePt, ProcessOptions.ShapingPointCategory);
end;

procedure TGPXFile.AddWayPoint(const RtePtNode: TXmlVsNode;
                               const WayPointName: string);
var
  ExtensionsNode: TXmlVsNode;
  NewNode: TXmlVsNode;
begin
  NewNode := FWayPointList.Add('wpt');
  AddWptPoint(NewNode,
              RtePtNode,
              WayPointName,
              TProcessPointType.pptWayPt);

  ExtensionsNode := RtePtNode.Find('extensions');
  if (ExtensionsNode = nil) then
    exit;
  CloneNode(ExtensionsNode, NewNode.AddChild('extensions'));
end;

procedure TGPXFile.AddTrackPoint(const RptNode: TXmlVsNode);
var
  TrackPoint: TXmlVsNode;
begin
  TrackPoint := CurrentTrack.AddChild('trkpt');
  CloneAttributes(RptNode, TrackPoint);
end;

procedure TGPXFile.ProcessRtePt(const RtePtNode: TXmlVsNode;
                                const RouteName: string;
                                const Cnt, LastCnt: integer);

var
  ExtensionNode: TXmlVSNode;
  RptNode, RtePtExtensions, RtePtShapingPoint, RtePtViaPoint: TXmlVSNode;
  WptName, Symbol, ViaPtName, ShapePtName: string;
{$IFDEF MAPUTILS}
  DescNode, RteNode: TXmlVSNode;
  CalculatedSubClass, MapName: string;
  MapSeg, NewDescPos: integer;
{$ENDIF}
begin
  Symbol := FindSubNodeValue(RtePtNode, 'sym');
  RtePtExtensions := RtePtNode.Find('extensions');
  if (RtePtExtensions = nil) then
    exit;
  ExtensionNode := RtePtExtensions.Find('gpxx:RoutePointExtension');
  RtePtShapingPoint := RtePtExtensions.Find('trp:ShapingPoint');
  RtePtViaPoint := RtePtExtensions.Find('trp:ViaPoint');

  // Begin
  if (ProcessOptions.ProcessDistance) and
     (Cnt = 1) then
  begin
    TotalDistance := 0;
    PrevCoord := CoordFromAttribute(RtePtNode.AttributeList);
  end;

  if (Cnt = 1) then
  begin
    WptName := FindSubNodeValue(RtePtNode, 'name');
    if (Symbol = '') then
      Symbol := ProcessOptions.BeginSymbol;

    if (ProcessOptions.ProcessSubClass) then
      ClearSubClass(ExtensionNode);

    if (ProcessOptions.ProcessBegin) then
    begin
      WptName := ProcessOptions.BeginStr + ' ' + RouteName;
      Symbol := ProcessOptions.BeginSymbol;
      RenameNode(RtePtNode, WptName);

      if (ProcessOptions.ProcessAddrBegin) then
        LookUpAddrRtePt(RtePtNode);

      if (ProcessOptions.ProcessFlags) then
        RenameSubNode(RtePtNode, 'sym', Symbol);

      // Fill Mapsegment
{$IFDEF MAPUTILS}
      RteNode := RtePtNode.Parent;
      if (RteNode <> nil) then
      begin
        DescNode := RteNode.Find('desc');
        if  (DescNode = nil) then                   // No Desc node, add it.
        begin
          NewDescPos := RteNode.FindPos('cmt');     // After existing Cmt?
          if (NewDescPos < 0) then
            NewDescPos := RteNode.FindPos('name');  // No, After name
          if (NewDescPos > -1) then
            DescNode := RteNode.InsertChild('desc', NewDescPos +1);
        end;

        if (DescNode <> nil) and
           (ExtensionNode <> nil) then
        begin
          CalculatedSubClass := GetFirstSubClass(ExtensionNode);
          MapSeg := MapSegFromSubClass(CalculatedSubClass);
          MapName := LookupMap(IntToStr(MapSeg));
          if (MapName <> '') then
            RenameSubNode(RteNode, 'desc', 'Map name: '+ MapName + ' Map segment: ' + IntToStr(MapSeg))
          else
            RenameSubNode(RteNode, 'desc', 'Map segment: '+ IntToStr(MapSeg));
        end;
      end;
{$ENDIF}
    end;

    if (ProcessOptions.ProcessWayPtsFromRoute) then
      AddWayPointFromRoute(RtePtNode, WptName, true, Symbol, ProcessOptions.BeginStr, RouteName);

    if (ProcessOptions.ProcessCreateRoutePoints) then
      AddBeginPoint(RtePtNode, WptName, Symbol);
  end;

  // End
  if (Cnt = LastCnt) then
  begin
    WptName := FindSubNodeValue(RtePtNode, 'name');
    if (Symbol = '') then
      Symbol := ProcessOptions.EndSymbol;

    if (ProcessOptions.ProcessSubClass) then
      ClearSubClass(ExtensionNode);

    if (ProcessOptions.ProcessEnd) then
    begin
      WptName := ProcessOptions.EndStr + ' ' + RouteName;
      Symbol := ProcessOptions.EndSymbol;
      RenameNode(RtePtNode, WptName);

      if (ProcessOptions.ProcessAddrEnd) then
        LookUpAddrRtePt(RtePtNode);

      if (ProcessOptions.ProcessFlags) then
        RenameSubNode(RtePtNode, 'sym', Symbol);
    end;

    if (ProcessOptions.ProcessWayPtsFromRoute) then
      AddWayPointFromRoute(RtePtNode, WptName, true, Symbol, ProcessOptions.EndStr, RouteName);

    if (ProcessOptions.ProcessCreateRoutePoints) then
    begin
      if (ProcessOptions.ProcessDistance) then
        ComputeDistance(RtePtNode);
      AddEndPoint(RtePtNode, WptName, Symbol);
    end;
  end;

  // Shaping point
  if (RtePtShapingPoint <> nil) then
  begin
    if (ProcessOptions.ProcessDistance) then
      ComputeDistance(RtePtNode);
    inc(ShapingPointCnt);

    case (ProcessOptions.ShapingPointName) of
      TShapingPointName.Unchanged:
        ShapePtName := FindSubNodeValue(RtePtNode, 'name');
      TShapingPointName.Route_Sequence:
        ShapePtName := Format('%s_%3.3d', [RouteName, ShapingPointCnt]);
      TShapingPointName.Route_Distance:
        ShapePtName := Format('%s_%3.3d %s', [RouteName, Round(TotalDistance), Processoptions.DistanceStr]);
      TShapingPointName.Sequence_Route:
        ShapePtName := Format('%3.3d_%s', [ShapingPointCnt, RouteName]);
      TShapingPointName.Distance_Route:
        ShapePtName := Format('%3.3d %s_%s', [Round(TotalDistance), Processoptions.DistanceStr, RouteName]);
    end;

    if (Symbol = '') or
       (Symbol = ProcessOptions.DefShapePtSymbol) then
      Symbol := ProcessOptions.DefShapingPointSymbol;

    if (ProcessOptions.ProcessSubClass) then
      ClearSubClass(ExtensionNode);

    if (ProcessOptions.ProcessShape) then
    begin
      Symbol := ProcessOptions.DefShapePtSymbol;
      UnglitchNode(RtePtNode, ExtensionNode, TGPXString(ShapePtName));

      RenameNode(RtePtNode, ShapePtName);

      if (ProcessOptions.ProcessAddrShape) then
        LookUpAddrRtePt(RtePtNode);

      if (ProcessOptions.ProcessFlags) then
        RenameSubNode(RtePtNode, 'sym', Symbol); // Symbol for shaping and via points.

    end;
    if (ProcessOptions.ProcessCreateRoutePoints) then
      AddShapingPoint(RtePtNode, ShapePtName, Symbol);

    if (ProcessOptions.ProcessWayPtsFromRoute) then
      AddWayPointFromRoute(RtePtNode, ShapePtName, false, Symbol, ProcessOptions.ShapingPointCategory, RouteName);
  end;

  // Via point
  if (Cnt <> 1) and
     (Cnt <> LastCnt) and
     (RtePtViaPoint <> nil) then
  begin
    if (Symbol = '') then
      Symbol := ProcessOptions.DefViaPointSymbol;

    if (ProcessOptions.ProcessSubClass) then
      ClearSubClass(ExtensionNode);

    ViaPtName := FindSubNodeValue(RtePtNode, 'name');
    if (ProcessOptions.ProcessVia) then
    begin
      if (ProcessOptions.ProcessAddrVia) then
        LookUpAddrRtePt(RtePtNode);
    end;

    if (ProcessOptions.ProcessCreateRoutePoints) then
      AddViaPoint(RtePtNode, ViaPtName, Symbol);

    if (ProcessOptions.ProcessWayPtsFromRoute) then
      AddWayPointFromRoute(RtePtNode, ViaPtName, true, Symbol, ProcessOptions.ViaPointCategory, RouteName);
  end;

  if (ProcessOptions.ProcessDistance) and
     (ExtensionNode <> nil) then
  begin
    for RptNode in ExtensionNode.ChildNodes do
    begin
      if (RptNode.Name = 'gpxx:rpt') then
        ComputeDistance(RptNode);
    end;
  end;

  if (ProcessOptions.ProcessTracks) and
     (ExtensionNode <> nil) then
  begin
    AddTrackPoint(RtePtNode);  // Add the <rtept> as a trackpoint. Will draw straight lines. In line with BC
    for RptNode in ExtensionNode.ChildNodes do
    begin
      if (RptNode.Name = 'gpxx:rpt') then
        AddTrackPoint(RptNode);
    end;
  end;
end;

procedure TGPXFile.ProcessRte(const RteNode: TXmlVSNode);
var
  RtePtNode, RteNameNode: TXmlVSNode;
  ExtensionsNode, RouteExtension: TXmlVSNode;
  RtePts: TXmlVSNodeList;
  Cnt: integer;
begin
  CurrentRouteTrackName := 'UnNamed';
  RteNameNode := RteNode.Find('name');
  if (RteNameNode <> nil) then
    CurrentRouteTrackName := RteNameNode.NodeValue;
  ExtensionsNode := RteNode.Find('extensions');

  ShapingPointCnt := 0;

  if (ProcessOptions.ProcessWayPtsFromRoute) then
  begin
    CurrentWayPointFromRoute := FWayPointFromRouteList.Add(CurrentRouteTrackName);
    CurrentWayPointFromRoute.NodeValue := CurrentRouteTrackName;
  end;

  if (ProcessOptions.ProcessCreateRoutePoints) then
  begin
    CurrentViaPointRoute := FRouteViaPointList.Add(CurrentRouteTrackName);
    CurrentViaPointRoute.NodeValue := CurrentRouteTrackName;
  end;

  if (ProcessOptions.ProcessTracks) then
  begin
    CurrentTrack := FTrackList.Add(CurrentRouteTrackName);
    CurrentTrack.NodeValue := CurrentRouteTrackName;
    CurrentTrack.AddChild('desc').NodeValue := 'Rte';

    if (ExtensionsNode <> nil) then
    begin
      RouteExtension := ExtensionsNode.Find('gpxx:RouteExtension');
      if (RouteExtension <> nil) then
        CurrentTrack.AddChild('extensions').
                     AddChild('gpxx:TrackExtension').
                     AddChild('gpxx:DisplayColor').NodeValue := GetTrackColor(RouteExtension);
    end;
  end;

  if (ProcessOptions.ProcessBegin) or
     (ProcessOptions.ProcessEnd) or
     (ProcessOptions.ProcessShape) then
  begin
    if (ExtensionsNode <> nil) then
      ReplaceAutoName(ExtensionsNode, 'false');
  end;

  RtePts := RteNode.FindNodes('rtept');
  if (RtePts <> nil) then
  begin
    Cnt := 0;
    for RtePtNode in RtePts do
    begin
      inc(Cnt);
      ProcessRtePt(RtePtNode, CurrentRouteTrackName, Cnt, RtePts.Count);
    end;
  end;

  RtePts.Free;
end;

procedure TGPXFile.ProcessTrk(const TrkNode: TXmlVSNode);
var
  TrackNameNode, ExtensionsNode, TrackExtension: TXmlVSNode;
  TrkSegNode, TrkPtNode: TXmlVSNode;
  FirstTrkPtNode, LastTrkPtNode: TXmlVSNode;
  WptName, Symbol: string;
begin
  CurrentRouteTrackName := 'UnNamed';
  TrackNameNode := TrkNode.Find('name');
  if (TrackNameNode <> nil) then
    CurrentRouteTrackName := TrackNameNode.NodeValue;

  ExtensionsNode := TrkNode.Find('extensions');

  if (ProcessOptions.ProcessCreateRoutePoints) then
  begin
    CurrentViaPointRoute := FRouteViaPointList.Add(CurrentRouteTrackName);
    CurrentViaPointRoute.NodeValue := CurrentRouteTrackName;
  end;

  if (ProcessOptions.ProcessTracks) then
  begin
    CurrentTrack := FTrackList.Add(CurrentRouteTrackName);
    CurrentTrack.NodeValue := CurrentRouteTrackName;
    CurrentTrack.AddChild('desc').NodeValue := 'Trk';
    if (ExtensionsNode <> nil) then
    begin
      TrackExtension := ExtensionsNode.Find('gpxx:TrackExtension');
      if (TrackExtension <> nil) then
        CurrentTrack.AddChild('extensions').
                     AddChild('gpxx:TrackExtension').
                     AddChild('gpxx:DisplayColor').NodeValue := GetTrackColor(TrackExtension);
    end;

    FirstTrkPtNode := nil;
    LastTrkPtNode := nil;

    for TrkSegNode in TrkNode.ChildNodes do
    begin
      for TrkPtNode in TrkSegNode.ChildNodes do
      begin
        if (TrkPtNode.Name = 'trkpt') then
        begin
          AddTrackPoint(TrkPtNode);
          if (FirstTrkPtNode = nil) then
          begin
            FirstTrkPtNode := TrkPtNode;
            if (ProcessOptions.ProcessDistance) then
            begin
              TotalDistance := 0;
              PrevCoord := CoordFromAttribute(TrkPtNode.AttributeList);
            end;
          end;
          LastTrkPtNode := TrkPtNode;
          if (ProcessOptions.ProcessDistance) then
            ComputeDistance(TrkPtNode);
        end;
      end;
    end;

    if (ProcessOptions.ProcessCreateRoutePoints) then
    begin
      if (LastTrkPtNode <> nil) then
      begin
        WptName := ProcessOptions.EndStr + ' ' + CurrentRouteTrackName;
        Symbol := ProcessOptions.EndSymbol;
        AddViaPoint(LastTrkPtNode, WptName, Symbol);
      end;

      TotalDistance := 0; // Showing Distance for Begin seems silly

      if (FirstTrkPtNode <> nil) then
      begin
        WptName := ProcessOptions.BeginStr + ' ' + CurrentRouteTrackName;
        Symbol := ProcessOptions.BeginSymbol;
        AddViaPoint(FirstTrkPtNode, WptName, Symbol);
      end;

    end;
  end;
end;

//Waypoint not part of route
procedure TGPXfile.ProcessWpt(const WptNode: TXmlVSNode);
var
  WptNameNode: TXmlVSNode;
  Name: string;
begin
  Name := '';
  WptNameNode := WptNode.Find('name');
  if (WptNameNode <> nil) then
    Name := WptNameNode.NodeValue;

  AddWayPoint(WptNode, Name);
end;

procedure TGPXfile.ProcessGPXNode(GpxNode: TXmlVSNode);
var
  MainNode: TXmlVSNode;
begin
  for MainNode in GpxNode.ChildNodes do
  begin
    TotalDistance := 0;
    if (MainNode.Name = 'wpt') then
      ProcessWpt(MainNode)
    else if (MainNode.Name = 'rte') then
      ProcessRte(MainNode)
    else if (MainNode.Name = 'trk') then
      ProcessTrk(MainNode);
  end;
end;

procedure TGPXfile.ProcessGPX;
var
  GpxNode: TXmlVSNode;
begin
  ClearGlobals;
  try
    FXmlDocument.LoadFromFile(FGPXFile);
    for GpxNode in FXmlDocument.ChildNodes do
    begin
      if (GpxNode.Name = 'gpx') then
        ProcessGPXNode(GpxNode);
    end;
  finally
  { Future use }
  end;
end;

function HTMLColor(GPXColor: string): string;
begin
  result := 'ff00ff';
  if SameText(GPXColor, 'Black')       then exit('000000');
  if SameText(GPXColor, 'DarkRed')     then exit('8b0000');
  if SameText(GPXColor, 'DarkGreen')   then exit('006400');
  if SameText(GPXColor, 'DarkYellow')  then exit('b5b820');
  if SameText(GPXColor, 'DarkBlue')    then exit('00008b');
  if SameText(GPXColor, 'DarkMagenta') then exit('8b008b');
  if SameText(GPXColor, 'DarkCyan')    then exit('008b8b');
  if SameText(GPXColor, 'LightGray')   then exit('cccccc');
  if SameText(GPXColor, 'DarkGray')    then exit('444444');
  if SameText(GPXColor, 'Red')         then exit('ff0000');
  if SameText(GPXColor, 'Green')       then exit('00ff00');
  if SameText(GPXColor, 'Yellow')      then exit('ffff00');
  if SameText(GPXColor, 'Blue')        then exit('0000ff');
  if SameText(GPXColor, 'Magenta')     then exit('ff00ff');
  if SameText(GPXColor, 'Cyan')        then exit('00ffff');
  if SameText(GPXColor, 'White')       then exit('ffffff');
  if SameText(GPXColor, 'Transparent') then exit('ffffff');
end;

function TGPXfile.WayPointNotProcessed(WayPoint: TXmlVSNode): boolean;
var
  WayPointName: string;
begin
  result := false;
  WayPointName := WayPoint.Find('name').NodeValue;
  if (FWayPointsProcessedList.IndexOf(WayPointName) <> -1) then
    exit;
  FWayPointsProcessedList.Add(WayPointName);
  result := true;
end;

function TGPXfile.GetSpeedFromName(WptName: string): integer;
var
  SpeedStr: string;
  SpeedPos: integer;
begin
  result := 0;
  SpeedPos := LastDelimiter('@', WptName);
  if (SpeedPos > 0) then
  begin
    SpeedStr := Copy(WptName, SpeedPos +1);
    if (TryStrToInt(SpeedStr, Integer(SpeedPos))) then
      result := SpeedPos;
  end;
end;

function TGPXfile.GPXWayPoint(CatId, BmpId: integer; WayPoint: TXmlVSNode): TGPXWayPoint;
var
  ExtensionsNode, AddressNode: TXmlVSNode;
  ProximityStr: TGPXString;
  ProximityFloat: single;
begin
  result := TGPXWayPoint.Create;
  with result do
  begin
    Name        := TGPXString(FindSubNodeValue(WayPoint, 'name'));
    Comment     := TGPXString(FindSubNodeValue(WayPoint, 'cmt'));
    Lat         := TGPXString(WayPoint.AttributeList.Find('lat').Value);
    Lon         := TGPXString(WayPoint.AttributeList.Find('lon').Value);
    Proximity   := 0;
    if (ProcessOptions.DefaultProximityStr <> '') then
      Proximity := StrToInt(ProcessOptions.DefaultProximityStr);
    Speed       := GetSpeedFromName(string(result.Name));

    ExtensionsNode := WayPoint.Find('extensions');
    if (ExtensionsNode <> nil) then
      ExtensionsNode := ExtensionsNode.Find('gpxx:WaypointExtension');
    if (ExtensionsNode <> nil) then
    begin
      Phone         := TGPXString(FindSubNodeValue(ExtensionsNode, 'gpxx:PhoneNumber'));
      ProximityStr  := TGPXString(FindSubNodeValue(ExtensionsNode, 'gpxx:Proximity'));
      if (ProximityStr <> '') and
         (TryStrToFloat(string(ProximityStr), ProximityFloat, FormatSettings)) then
        Proximity := Trunc(ProximityFloat);
      AddressNode := ExtensionsNode.Find('gpxx:Address');
      if (AddressNode <> nil) then
      begin
        Country     := TGPXString(FindSubNodeValue(AddressNode, 'gpxx:Country'));
        State       := TGPXString(FindSubNodeValue(AddressNode, 'gpxx:State'));
        PostalCode  := TGPXString(FindSubNodeValue(AddressNode, 'gpxx:PostalCode'));
        City        := TGPXString(FindSubNodeValue(AddressNode, 'gpxx:City'));
        Street      := TGPXString(FindSubNodeValue(AddressNode, 'gpxx:StreetAddress'));  // Has HouseNbr
      end;
    end;
    CategoryId := CatId;
    BitmapId := BmpId;
  end;
end;

function TGPXfile.GPXBitMap(WayPoint: TXmlVSNode): TGPXBitmap;
begin
  result := TGPXBitmap.Create(ProcessOptions.GPISymbolsDir);
  result.Bitmap := TGPXString(FindSubNodeValue(WayPoint, 'sym'));
end;

function TGPXfile.GPXCategory(Category: string): TGPXCategory;
begin
  result := TGPXCategory.Create;
  result.Category := TGPXString(Category);
end;

constructor TGPXFile.Create(const GPXFile:string;
                            const OutDir: string;
                            const FunctionPrefs, SavePrefs: TNotifyEvent;
                            const OutStringList: TStringList = nil;
                            const SeqNo: cardinal = 0);

begin
  inherited Create;

  FGPXFile := GPXFile;
  FBaseFile := ChangeFileExt(ExtractFileName(FGPXFile), '');
  if (OutDir <> '') then
    FOutDir := OutDir
  else
    FOutDir := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(ExtractFilePath(FGPXFile) + FBaseFile));
  FOnFunctionPrefs := FunctionPrefs;
  FOnSavePrefs := SavePrefs;
  FOutStringList := OutStringList;
{$IFDEF TRIPOBJECTS}
  FSeqNo := SeqNo;
{$ENDIF}
  CreateGlobals;
end;

constructor TGPXfile.Create(const GPXFile:string;
                            const FunctionPrefs, SavePrefs: TNotifyEvent);
begin
  Create(GPXFile, '', FunctionPrefs, SavePrefs, nil, 0);
end;

destructor TGPXfile.Destroy;
begin
  FreeGlobals;
  inherited Destroy;
end;

procedure TGPXfile.AnalyzeGpx;
var
  BaseFile: string;
begin
  BaseFile := ChangeFileExt(ExtractFileName(FGPXFile), '');
  ProcessGPX;
end;

function TGPXfile.ShowSelectTracks(const Caption, SubCaption: string; TagsToShow: TTagsToShow; CheckMask: string): boolean;
var
  Track, RoutePoints: TXmlVSNode;
  DisplayColor, RteTrk: string;
begin
  case TagsToShow of
    TTagsToShow.Rte,
    TTagsToShow.Trk,
    TTagsToShow.RteTrk:
      begin
        for Track in FTrackList do
        begin
          RteTrk := FindSubNodeValue(Track, 'desc');
          case TagsToShow of
            TTagsToShow.Rte:
              if not SameText(RteTrk, 'rte') then
                continue;
            TTagsToShow.Trk:
              if not SameText(RteTrk, 'trk') then
                continue;
          end;

          if (Track.Find('extensions') <> nil) then
            DisplayColor := GetTrackColor(Track.Find('extensions').Find('gpxx:TrackExtension'))
          else
            DisplayColor := ProcessOptions.DefTrackColor;

          FrmSelectGPX.AllTracks.Add(DisplayColor + #9 +
                                     IntToStr(Track.ChildNodes.Count) + #9 +
                                     Track.Name + #9 +
                                     RteTrk);
        end;
      end;
    TTagsToShow.WptRte:
      begin

        if (WayPointList.Count > 0) then
          FrmSelectGPX.AllTracks.Add('-' + #9 +
                                     IntToStr(WayPointList.Count) + #9 +
                                     'Waypoints' + #9 +
                                     'Wpt');
        if (RouteViaPointList.Count > 0) then
        begin
          for RoutePoints in RouteViaPointList do
          begin
            if (RoutePoints.ChildNodes.Count > 0) then
              FrmSelectGPX.AllTracks.Add('-' + #9 +
                                         IntToStr(RoutePoints.ChildNodes.Count) + #9 +
                                         RoutePoints.NodeValue + #9 +
                                         'Rte');
          end;
        end;
      end;
  end;

  FrmSelectGPX.LoadTracks(ProcessOptions.TrackColor, TagsToShow, CheckMask);
  FrmSelectGPX.Caption := Caption;
  FrmSelectGPX.PnlTop.Caption := SubCaption;
  result := (FrmSelectGPX.ShowModal = ID_OK);

  if (result) then
  begin
    if (FrmSelectGPX.CmbOverruleColor.ItemIndex = 0) then
      ProcessOptions.TrackColor := ''
    else
      ProcessOptions.TrackColor := FrmSelectGPX.CmbOverruleColor.Text;
    ProcessOptions.DoPrefSaved;
  end;
end;

procedure TGPXfile.DoPostProcess;
begin
  FXmlDocument.Encoding := 'utf-8';
  FXmlDocument.SaveToFile(FGPXFile);
end;

procedure TGPXfile.DoCreateTracks;
var
  TracksXml: TXmlVSDocument;
  TracksRoot: TXmlVSNode;
  WptTrack: TXmlVSNode;
  Track : TXmlVSNode;
  TrackPoint: TXmlVSNode;
  OutFile, DisplayColor: string;
  TracksProcessed: TStringList;

begin
  TracksProcessed := TStringList.Create;
  TracksXml := TXmlVSDocument.Create;
  try
    TracksRoot := InitGarminGpx(TracksXml);

    for Track in FTrackList do
    begin
      if (UniqueTracks) then
      begin
        if (TracksProcessed.IndexOf(Track.NodeValue) > -1) then
          continue;
        TracksProcessed.Add(Track.NodeValue);
      end;

      DisplayColor := FrmSelectGPX.TrackSelectedColor(Track.Name, FindSubNodeValue(Track, 'desc'));
      if (DisplayColor = '') then
        continue;

      WptTrack := TracksRoot.AddChild('trk');
      WptTrack.AddChild('name').NodeValue := Track.NodeValue;

      WptTrack.AddChild('extensions').
               AddChild('gpxx:TrackExtension').
               AddChild('gpxx:DisplayColor').NodeValue := DisplayColor;

      WptTrack := WptTrack.AddChild('trkseg');
      for TrackPoint in Track.ChildNodes do
      begin
        if (TrackPoint.Name <> 'trkpt') then
          continue;
        CloneAttributes(TrackPoint, WptTrack.AddChild('trkpt'));
      end;
    end;

    OutFile := FOutDir +
               'Tracks_' +
               FBaseFile +
               ExtractFileExt(FGPXFile);
    TracksXml.SaveToFile(OutFile);
  finally
    TracksXml.Free;
    TracksProcessed.Free;
  end;
end;

procedure TGPXfile.DoCreateWayPoints;
var
  WptXml: TXmlVSDocument;
  WptRoot: TXmlVSNode;
  RouteWayPoints, WayPoint: TXmlVSNode;
  ExtensionsNode: TXmlVSNode;
  OutFile: string;
  IsViaPt: boolean;
begin

  WptXml := TXmlVSDocument.Create;
  try
    WptRoot := InitGarminGpx(WptXml);

  // Create Way points, from Way points
    if (ProcessOptions.ProcessWayPtsInWayPts) then
    begin
      for WayPoint in FWayPointList do
      begin
        if (WayPointNotProcessed(WayPoint)) then
          CloneNode(WayPoint, WptRoot.AddChild(WayPoint.Name));
      end;
      OutFile := FOutDir +
           'WayPoints_' +
           FBaseFile +
           ExtractFileExt(FGPXFile);
      WptXml.SaveToFile(OutFile);
    end;

  // Create Way points, from Via, or Shaping points in routes.
  // Create a file per route/track
    if ((ProcessOptions.ProcessViaPtsInWayPts) or (ProcessOptions.ProcessShapePtsInWayPts)) and
       (ProcessOptions.ProcessWayPtsFromRoute) then
    begin
      for RouteWayPoints in FWayPointFromRouteList do
      begin
        WptXml.Clear;
        WptRoot := InitGarminGpx(WptXml);

        for WayPoint in RouteWayPoints.ChildNodes do
        begin
          if (WayPointNotProcessed(WayPoint)) then
          begin
            IsViaPt := false;
            ExtensionsNode := WayPoint.find('extensions');
            if (ExtensionsNode <> nil) then
              IsViaPt := (ExtensionsNode.Find('trp:ViaPoint') <> nil);

            if ((IsViaPt) and (ProcessOptions.ProcessViaPtsInWayPts)) or
               ((IsViaPt = false) and (ProcessOptions.ProcessShapePtsInWayPts)) then
              CloneNode(WayPoint, WptRoot.AddChild(WayPoint.Name));
          end;
        end;

        OutFile := FOutDir +
                   'WayPoints_' +
                   EscapeFileName(RouteWayPoints.Name) +
                   ExtractFileExt(FGPXFile);
        WptXml.SaveToFile(OutFile);
      end;
    end;
  finally
    WptXml.Free;
  end;
end;

procedure TGPXFile.DoCreatePOI;
var
  OutFile: string;
  RouteWayPoints, WayPoint: TXmlVSNode;
  GPIFile: TGPI;
  POIGroup: TPOIGroup;
  S: TBufferedFileStream;
  CatId: integer;
  BmpId: integer;
  IsViaPt: boolean;
  ExtensionsNode: TXmlVSNode;
begin
  OutFile := ChangeFileExt(FOutDir + FBaseFile, '.gpi');
  S := TBufferedFileStream.Create(OutFile, fmCreate);
  GPIFile := TGPI.Create(GPIVersion);
  GPIFile.WriteHeader(S);
  PoiGroup := GPIFile.CreatePOIGroup(TGPXString(ProcessOptions.CatGPX + FBaseFile));

  if (ProcessOptions.ProcessWayPtsInGpi) then
  begin
    for WayPoint in FWayPointList do
    begin
      if (WayPointNotProcessed(WayPoint)) then
      begin
        CatId := PoiGroup.AddCat(GPXCategory(ProcessOptions.CatSymbol + FindSubNodeValue(WayPoint, 'sym'))); // Symbol
        BmpId := PoiGroup.AddBmp(GPXBitMap(WayPoint));
        PoiGroup.AddWpt(GPXWayPoint(CatId, BmpId, WayPoint));
      end;
    end;
  end;

// Create Way points, from Via, or Shaping points in routes.
// Create a file per route/track
  if ((ProcessOptions.ProcessViaPtsInGpi) or (ProcessOptions.ProcessShapePtsInGpi)) and
     (ProcessOptions.ProcessWayPtsFromRoute) then
  begin
    for RouteWayPoints in FWayPointFromRouteList do
    begin
      CatId := PoiGroup.AddCat(GPXCategory(ProcessOptions.CatRoute + RouteWayPoints.NodeValue)); // RouteName

      for WayPoint in RouteWayPoints.ChildNodes do
      begin
        if (WayPointNotProcessed(WayPoint)) then
        begin
          IsViaPt := false;
          ExtensionsNode := WayPoint.find('extensions');
          if (ExtensionsNode <> nil) then
            IsViaPt := (ExtensionsNode.Find('trp:ViaPoint') <> nil);

          if ((IsViaPt) and (ProcessOptions.ProcessViaPtsInGpi)) or
             ((IsViaPt = false) and (ProcessOptions.ProcessShapePtsInGpi)) then
          begin
            BmpId := PoiGroup.AddBmp(GPXBitMap(WayPoint));
            PoiGroup.AddWpt(GPXWayPoint(CatId, BmpId, WayPoint));
          end;
        end;
      end;

    end;
  end;

  POIGroup.Write(S);
  GPIFile.WriteEnd(S);
  S.Free;

end;

procedure TGPXFile.DoCreateKML;
var
  OutFile, Lon, Lat, Ele, DisplayColor: string;
  RouteWayPoint, WayPoint: TXmlVSNode;
  WayPointAttribute: TXmlVSAttribute;
  Track : TXmlVSNode;
  Folder: IXMLNode;
  TrackPoint: TXmlVSNode;
  TrackPointAttribute: TXmlVSAttribute;
  Helper: TKMLHelper;
begin
  OutFile := FOutDir + ChangeFileExt(ExtractFileName(FGPXFile), '.kml');
  Helper := TKMLHelper.Create(OutFile);
  Helper.FormatSettings := GetLocaleSetting;

  try
    Helper.WriteHeader;

    if (ProcessOptions.ProcessTracks) then
    begin
      for Track in FTrackList do
      begin
        DisplayColor := FrmSelectGPX.TrackSelectedColor(Track.Name, FindSubNodeValue(Track, 'desc'));
        if (DisplayColor = '') then
          continue;

        Helper.WritePointsStart(Track.NodeValue, DisplayColor);
        for TrackPoint in Track.ChildNodes do
        begin
          if (TrackPoint.Name <> 'trkpt') then
            continue;
          Lon := '0';
          Lat := '0';
          Ele := '0';
          for TrackPointAttribute in TrackPoint.AttributeList do
          begin
            if (TrackPointAttribute.Name = 'lon') then
              Lon := TrackPointAttribute.Value;
            if (TrackPointAttribute.Name = 'lat') then
              Lat := TrackPointAttribute.Value;
          end;

          Helper.WritePoint(Lon, Lat, Ele);

        end;
        Folder := Helper.WritePointsEnd;

        if (ProcessOptions.ProcessCreateRoutePoints) then
        begin
          for RouteWayPoint in FRouteViaPointList do
          begin
            if (RouteWayPoint.NodeValue <> Track.NodeValue) then
              continue;
            for WayPoint in RouteWayPoint.ChildNodes do
            begin
              Lon := '0';
              Lat := '0';
              Ele := '0';
              for WayPointAttribute in WayPoint.AttributeList do
              begin
                if (WayPointAttribute.Name = 'lon') then
                  lon := WayPointAttribute.Value;
                if (WayPointAttribute.Name = 'lat') then
                  lat := WayPointAttribute.Value;
              end;
              Helper.WritePlace( Folder,
                                 Format('%s,%s,%s ', [lon, lat, ele], Helper.FormatSettings),
                                 FindSubNodeValue(WayPoint, 'name'),
                                 Format('%s%s%s', [FindSubNodeValue(WayPoint, 'cmt'),
                                                   #10,
                                                   FindSubNodeValue(WayPoint, 'desc')]));
            end;
          end;
          Helper.WritePlacesEnd;
        end;
      end;
    end;
    Helper.WriteFooter;
    Helper.WriteKml;

  finally
    Helper.Free;
  end;
end;

procedure TGPXFile.Track2OSMTrackPoints(Track: TXmlVSNode;
                                        var TrackId: integer;
                                        TrackStringList: TStringList);
var
  Lon, Lat, DisplayColor, Color, LayerName, RoutePointName: string;
  RouteWayPoint, WayPoint: TXmlVSNode;
  WayPointAttribute: TXmlVSAttribute;
  TrackPoint: TXmlVSNode;
  RtePtExtensions: TXmlVSNode;
  TrackPoints: integer;
  LayerId: integer;
  TrackPointAttribute: TXmlVSAttribute;
begin
  TrackStringList.Clear;
  TrackPoints := 0;
  DisplayColor := FrmSelectGpx.TrackSelectedColor(Track.Name, FindSubNodeValue(Track, 'desc'));
  if (DisplayColor = '') then
  	exit;

  for TrackPoint in Track.ChildNodes do
  begin
    if (TrackPoint.Name <> 'trkpt') then
      continue;
    Lon := '0';
    Lat := '0';
    for TrackPointAttribute in TrackPoint.AttributeList do
    begin
      if (TrackPointAttribute.Name = 'lon') then
        Lon := TrackPointAttribute.Value;
      if (TrackPointAttribute.Name = 'lat') then
        Lat := TrackPointAttribute.Value;
    end;
    TrackStringList.Add(Format('AddTrkPoint(%d,%s,%s);', [TrackPoints, Lat, Lon]));
    Inc(TrackPoints);
  end;

  if (ProcessOptions.ProcessCreateRoutePoints) then
  begin
    for RouteWayPoint in FRouteViaPointList do
    begin
      if (RouteWayPoint.NodeValue <> Track.NodeValue) then
        continue;

      for WayPoint in RouteWayPoint.ChildNodes do
      begin
        Lon := '0';
        Lat := '0';
        for WayPointAttribute in WayPoint.AttributeList do
        begin
          if (WayPointAttribute.Name = 'lon') then
            lon := WayPointAttribute.Value;
          if (WayPointAttribute.Name = 'lat') then
            lat := WayPointAttribute.Value;
        end;
        RoutePointName := EscapeDQuote(FindSubNodeValue(WayPoint, 'name'));

        LayerId := TrackId + 1;
        LayerName := Format('Shape: %s', [EscapeDQuote(Track.Name)]);
        Color := 'blue';

        RtePtExtensions := WayPoint.Find('extensions');
        if (RtePtExtensions <> nil) and
           (RtePtExtensions.Find('trp:ViaPoint') <> nil) then
        begin
          LayerId := TrackId;
          LayerName := Format('Via: %s', [EscapeDQuote(Track.name)]);
          Color := 'red';
        end;

        TrackStringList.Add(Format('AddRoutePoint(%d, "%s", "%s", %s, %s, "%s");',
                                   [LayerId,
                                    LayerName,
                                    RoutePointName,
                                    lat,
                                    lon,
                                    Color]));
      end;
      Inc(TrackId, 2);
    end;
  end;
  TrackStringList.Add(Format('CreateTrack("%s", "%s");', [EscapeDQuote(Track.Name), OSMColor(DisplayColor)]));
end;

procedure TGPXFile.DoCreateHTML;
var
  OutFile: string;
  Track : TXmlVSNode;
  TrackId: integer;
  TrackPointList: TStringList;
begin
  TrackPointList := TStringList.Create;
  try
    for Track in FTrackList do
    begin
      if (FrmSelectGPX.TrackSelectedColor(Track.Name, FindSubNodeValue(Track, 'desc')) = '') then
        continue;
      TrackId := 0; // We get a new HTML file for every track/route
      Track2OSMTrackPoints(Track, TrackId, TrackPointList);
      OutFile := FOutDir + ChangeFileExt(EscapeFileName(Track.NodeValue), '.html');
      CreateOSMMapHtml(OutFile, TrackPointList);
    end;
  finally
    TrackPointList.Free;
  end;
end;

procedure TGPXFile.DoCreateOSMPoints;
var
  Track : TXmlVSNode;
  TrackId: integer;
  TrackPointList: TStringList;
begin
  FOutStringList.Clear;
  TrackPointList := TStringList.Create;
  try
    TrackId := 0;
    for Track in FTrackList do
    begin
      Track2OSMTrackPoints(Track, TrackId, TrackPointList);
      FOutStringList.AddStrings(TrackPointList);
    end;
  finally
    TrackPointList.Free;
  end;
end;

procedure TGPXFile.DoCreatePOLY;
var
  RouteWayPoints, WayPoint: TXmlVSNode;
  OutFile: string;
  F: TextFile;
  Coords: TCoord;
begin
  for RouteWayPoints in FRouteViaPointList do
  begin
    OutFile := FOutDir +
               EscapeFileName(RouteWayPoints.Name) +
               '.poly';
    AssignFile(F, OutFile);
    Rewrite(F);
    Writeln(F, EscapeFileName(RouteWayPoints.Name) );
    Writeln(F, '1');

    for WayPoint in RouteWayPoints.ChildNodes do
    begin
      Coords := CoordFromAttribute(WayPoint.AttributeList);
      Writeln(F, ' ',
              FormatFloat('0.00000;-0.00000;0.00', Coords.Lon, FormatSettings),
              ' ',
              FormatFloat('0.00000;-0.00000;0.00', Coords.Lat, FormatSettings));
    end;
    Writeln(F, 'END');
    Writeln(F, 'END');
    CloseFile(F);
  end;
end;

procedure TGPXFile.StripRtePt(const RtePtNode: TXmlVSNode);
var
  ExtensionNode: TXmlVSNode;
  RtePtExtensions: TXmlVSNode;
begin
  RtePtExtensions := RtePtNode.Find('extensions');
  if (RtePtExtensions = nil) then
    exit;
  ExtensionNode := RtePtExtensions.Find('gpxx:RoutePointExtension');
  if (ExtensionNode <> nil) then
    ExtensionNode.ChildNodes.DeleteRange(0, ExtensionNode.ChildNodes.Count);
end;

procedure TGPXFile.StripRte(const RteNode: TXmlVSNode);
var
  RtePtNode: TXmlVSNode;
  RtePts: TXmlVSNodeList;
begin
  RtePts := RteNode.FindNodes('rtept');
  if (RtePts = nil) then
    exit;
  try
    for RtePtNode in RtePts do
      StripRtePt(RtePtNode)
  finally
    RtePts.Free;
  end;
end;

procedure TGPXFile.DoCreateRoutes;
var
  OutFile: string;
  RteNode, GpxNode: TXmlVSNode;
  Node2Delete: TXmlVSNode;
  Node2DeletePos: integer;

begin
  GpxNode := FXmlDocument.ChildNodes.find('gpx');  // Look for <gpx> node
  if (GpxNode = nil) or
   (GpxNode.Name <> 'gpx') then
    exit;

  // Remove WayPt and Trk from GPX
  for Node2DeletePos := GpxNode.ChildNodes.Count -1 downto 0 do
  begin
    Node2Delete := GpxNode.ChildNodes[Node2DeletePos];

    if (DeleteWayPtsInRoute) and
       (Node2Delete.Name = 'wpt') then
    begin
      GpxNode.ChildNodes.Delete(Node2DeletePos);
      continue;
    end;

    if (DeleteTracksInRoute) and
       (Node2Delete.Name = 'trk') then
    begin
      GpxNode.ChildNodes.Delete(Node2DeletePos);
      continue
    end;
  end;

  for RteNode in GpxNode.ChildNodes do
  begin
    if (RteNode.Name = 'rte') then // Only want <rte> nodes. No <trk> or <wpt>
      StripRte(RteNode);
  end;

  OutFile := FOutDir +
             'Routes_' +
             FBaseFile +
             ExtractFileExt(FGPXFile);
  FXmlDocument.Encoding := 'utf-8';
  FXmlDocument.SaveToFile(OutFile);
end;

{$IFDEF TRIPOBJECTS}
function TGPXFile.CreateLocations(RtePts: TXmlVSNodeList): integer;
var
  Locations: TmLocations;
  RtePtNode: TXmlVSNode;
  TmpStream : TMemoryStream;
  RtePtName: string;
  Coords: TCoord;
  RtePtExtensions: TXmlVSNode;
  RtePtViaPoint: TXmlVSNode;
  RtePtCmt: string;
  DepartureDateString: string;
  DepartureDate: TDateTime;
begin
  result := 0;
  TmpStream := TMemoryStream.Create;
  try
    Locations := TmLocations.Create;
    for RtePtNode in RtePts do
    begin
      // Get Data from RtePt
      RtePtName := FindSubNodeValue(RtePtNode, 'name');
      Coords := CoordFromAttribute(RtePtNode.AttributeList);

      RtePtExtensions := RtePtNode.Find('extensions');
      if (RtePtExtensions = nil) then
        continue;
      RtePtViaPoint := RtePtExtensions.Find('trp:ViaPoint');

      RtePtCmt := FindSubNodeValue(RtePtNode, 'cmt');
      if (RtePtCmt = '') then
        RtePtCmt := Format('%s, %s', [FormatFloat('##0.00000', Coords.Lat, FormatSettings),
                                      FormatFloat('##0.00000', Coords.Lon, FormatSettings)]
                          );
      DepartureDateString := '';
      if (RtePtViaPoint <> nil) then
        DepartureDateString := FindSubNodeValue(RtePtViaPoint,'trp:DepartureTime');
      // Have all we need.

      // Create Location
      Locations.AddLocatIon(TLocation.Create);

      if (ProcessOptions.ZumoModel = TZumoModel.XT2) then
      begin
        PrepStream(TmpStream, [Swap32($00000008), Swap32($00000080), Swap32($00000080)]);
        Locations.Add(TRawDataItem.Create).InitFromStream('mShapingCenter', TmpStream.Size, $08, TmpStream);
      end;

      if (RtePtViaPoint <> nil) then
      begin
        inc(result);
        Locations.Add(TmAttr.Create(TRoutePoint.rpVia))
      end
      else
        Locations.Add(TmAttr.Create(TRoutePoint.rpShaping));
      Locations.Add(TmIsDFSPoint.Create);
      Locations.Add(TmDuration.Create);

      if (DepartureDateString <> '') and
        TryISO8601ToDate(DepartureDateString, DepartureDate, false) then
        Locations.Add(TmArrival.Create(DepartureDate))
      else
        Locations.Add(TmArrival.Create);
      Locations.Add(TmScPosn.Create(Coords.Lat, Coords.Lon, ProcessOptions.ScPosn_Unknown1));
      Locations.Add(TmAddress.Create(RtePtCmt));
      Locations.Add(TmisTravelapseDestination.Create);
      Locations.Add(TmShapingRadius.Create);
      Locations.Add(TmName.Create(RtePtName));
    end;
    FTripList.Add(Locations);
  finally
    TmpStream.Free;
  end;
end;

procedure TGPXFile.CreateTrip_XT(const TripName, CalculationMode, TransportMode: string;
                                 ParentTripID: Cardinal; RtePts: TXmlVSNodeList);
var
  ViaPointCount: integer;
begin
  FTripList.AddHeader(THeader.Create);
  FTripList.Add(TmPreserveTrackToRoute.Create);
  FTripList.Add(TmParentTripId.Create(ParentTripId));
  FTripList.Add(TmDayNumber.Create);
  FTripList.Add(TmTripDate.Create);
  FTripList.Add(TmIsDisplayable.Create);
  FTripList.Add(TmAvoidancesChanged.Create);
  FTripList.Add(TmIsRoundTrip.Create);
  FTripList.Add(TmParentTripName.Create(FBaseFile));
  FTripList.Add(TmOptimized.Create);
  FTripList.Add(TmTotalTripTime.Create);
  FTripList.Add(TmImported.Create);
  FTripList.Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode)));
  FTripList.Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
  FTripList.Add(TmTotalTripDistance.Create);
  FTripList.Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
  ViaPointCount := CreateLocations(RtePts);
  FTripList.Add(TmPartOfSplitRoute.Create);
  FTripList.Add(TmVersionNumber.Create);
  FTripList.Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
  FTripList.Add(TmTripName.Create(TripName));

  // Create Dummy AllRoutes, to force recalc on the XT. Just an entry for every Via.
  FTripList.ForceRecalc(ProcessOptions.ZumoModel, ViaPointCount);
end;

procedure TGPXFile.CreateTrip_XT2(const TripName, CalculationMode, TransportMode: string;
                                  ParentTripID: Cardinal; RtePts: TXmlVSNodeList);
var
  TmpStream: TMemoryStream;
  Uid: TGuid;
  ViaPointCount: integer;
begin
  TmpStream := TMemoryStream.Create;
  try
    FTripList.AddHeader(THeader.Create);

    PrepStream(TmpStream, [$0000]);
    FTriplist.Add(TRawDataItem.Create).InitFromStream('mGreatRidesInfoMap', TmpStream.Size, $0c, TmpStream);
    FTriplist.Add(TmAvoidancesChangedTimeAtSave.Create(ProcessOptions.AvoidancesChangedTimeAtSave));
    TmpStream.Position := 0;
    FTriplist.Add(TRawDataItem.Create).InitFromStream('mTrackToRouteInfoMap', TmpStream.Size, $0c, TmpStream);
    FTripList.Add(TmIsDisplayable.Create);
    FTripList.Add(TBooleanItem.Create('mIsDeviceRoute', true));
    FTripList.Add(TmDayNumber.Create);
    FTripList.Add(TmTripDate.Create);
    FTripList.Add(TmOptimized.Create);
    FTripList.Add(TmTotalTripTime.Create);
    FTripList.Add(TmTripName.Create(TripName));
    FTripList.Add(TStringItem.Create('mVehicleProfileGuid', ProcessOptions.VehicleProfileGuid));
    FTripList.Add(TmParentTripId.Create(ParentTripId));
    FTripList.Add(TmIsRoundTrip.Create);
    FTripList.Add(TStringItem.Create('mVehicleProfileName', ProcessOptions.VehicleProfileName));
    FTripList.Add(TmAvoidancesChanged.Create);
    FTripList.Add(TmParentTripName.Create(FBaseFile));
    FTripList.Add(TByteItem.Create('mVehicleProfileTruckType', StrToInt(ProcessOptions.VehicleProfileTruckType)));
    FTripList.Add(TCardinalItem.Create('mVehicleProfileHash', StrToInt(ProcessOptions.VehicleProfileHash)));
    FTriplist.Add(TmRoutePreferences.Create);
    FTripList.Add(TmImported.Create);
    FTripList.Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
    if (ProcessOptions.ExploreUuid <> '') then
      FTripList.Add(TStringItem.Create('mExploreUuid', ProcessOptions.ExploreUuid))
    else
    begin
      CheckHRGuid(CreateGUID(Uid));
      FTripList.Add(TStringItem.Create('mExploreUuid',
                                       ReplaceAll(LowerCase(GuidToString(Uid)), ['{','}'], ['',''], [rfReplaceAll])))
    end;
    FTripList.Add(TmVersionNumber.Create(4, $10));
    FTriplist.Add(TmRoutePreferencesAdventurousHillsAndCurves.Create);
    FTripList.Add(TmTotalTripDistance.Create);
    FTripList.Add(TByteItem.Create('mVehicleId', StrToInt(ProcessOptions.VehicleId)));
    FTriplist.Add(TmRoutePreferencesAdventurousScenicRoads.Create);
    FTripList.Add(TmAllRoutes.Create); // Add Placeholder for AllRoutes
    FTriplist.Add(TmRoutePreferencesAdventurousPopularPaths.Create);
    FTripList.Add(TmPartOfSplitRoute.Create);
    FTripList.Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode)));
    FTripList.Add(TBooleanItem.Create('mShowLastStopAsShapingPoint', false));
    FTriplist.Add(TmRoutePreferencesAdventurousMode.Create);
    FTripList.Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
    ViaPointCount := CreateLocations(RtePts);
    // Create dummy AllRoutes, and complete RoutePreferences
    FTripList.ForceRecalc(ProcessOptions.ZumoModel, ViaPointCount);
  finally
    TmpStream.Free;
  end;
end;

procedure TGPXFile.ProcessTrip(const RteNode: TXmlVSNode; ParentTripId: Cardinal);
var
  RtePts: TXmlVSNodeList;
  TripName, OutFile: string;
  CalculationMode, TransportMode: string;
  RteExtensions, RteTrpPoint, RtePtExtensions, RtePtNode, RtePtViaPoint: TXmlVSNode;
begin
  RtePts := RteNode.FindNodes('rtept');
  if (RtePts = nil) then // No route points, no trip
    exit;

  FTripList := TTripList.Create;
  try
    TripName := FindSubNodeValue(RteNode, 'name');
    OutFile := FOutDir + EscapeFileName(TripName) + '.trip';

    // Get TransportationMode
    TransportMode := '';
    RteExtensions := RteNode.Find('extensions');
    if (Assigned(RteExtensions)) then
    begin
      RteTrpPoint := RteExtensions.Find('trp:Trip');
      if (Assigned(RteTrpPoint)) then
        TransportMode := FindSubNodeValue(RteTrpPoint,'trp:TransportationMode');
    end;

    // Scan for CalculationMode
    CalculationMode := '';
    for RtePtNode in RtePts do
    begin
      RtePtExtensions := RtePtNode.Find('extensions');
      if (RtePtExtensions = nil) then
        continue;
      RtePtViaPoint := RtePtExtensions.Find('trp:ViaPoint');
      if (RtePtViaPoint <> nil) then
      begin
        CalculationMode := FindSubNodeValue(RtePtViaPoint,'trp:CalculationMode');
        if (CalculationMode <> '') then
          break;
      end;
    end;

    case ProcessOptions.ZumoModel of
      TZumoModel.XT:
        CreateTrip_XT(TripName, CalculationMode, TransportMode, ParentTripID, RtePts);
      TZumoModel.XT2:
        CreateTrip_XT2(TripName, CalculationMode, TransportMode, ParentTripID, RtePts);
      else
        // Unknown model, default to XT
        CreateTrip_XT(TripName, CalculationMode, TransportMode, ParentTripID, RtePts);
    end;

    // Write to File
    FTripList.SaveToFile(OutFile);
  finally
    RtePts.Free;
    FTripList.Free;
  end;
end;
{$ENDIF}

procedure TGPXFile.DoCreateTrips;
{$IFDEF TRIPOBJECTS}
var
  ParentTripId: Cardinal;
  RteNode, GpxNode: TXmlVSNode;
{$ENDIF}
begin
{$IFDEF TRIPOBJECTS}
  GpxNode := FXmlDocument.ChildNodes.find('gpx');  // Look for <gpx> node
  if (GpxNode = nil) or
     (GpxNode.Name <> 'gpx') then
    exit;

  ParentTripId := TUnixDate.DateTimeAsCardinal(Now) + FSeqNo;
  for RteNode in GpxNode.ChildNodes do
  begin
    if (RteNode.Name = 'rte') then // Only want <rte> nodes. No <trk> or <wpt>
      ProcessTrip(RteNode, ParentTripId);
  end;
{$ENDIF}
end;

class procedure TGPXFile.PerformFunctions(const AllFuncs: array of TGPXFunc;
                                          const GPXFile:string;
                                          const FunctionPrefs, SavePrefs: TNotifyEvent;
                                          const ForceOutDir: string = '';
                                          const OutStringList: TStringList = nil;
                                          const SeqNo: cardinal = 0);
var
  Func: TGPXFunc;
  GpxFileObj: TGPXFile;
  SubCaption: string;
begin

  GpxFileObj := TGPXFile.Create(GPXFile, ForceOutDir, FunctionPrefs, SavePrefs, OutStringList, SeqNo);

  try

    for Func in AllFuncs do
    begin
      case Func of
        CreateTracks,
        CreateWayPoints,
        CreatePOI,
        CreateKML,
        CreateHTML,
        CreatePOLY,
        CreateRoutes,
        CreateTrips:
          begin
            if not Assigned(OutStringList) then
              ForceDirectories(GpxFileObj.FOutDir);
            break;
          end;
      end;
    end;

    GpxFileObj.ProcessGPX;

    SubCaption := '';
    for Func in AllFuncs do
    begin
      case Func of
        CreateTracks:
        begin
          if (SubCaption <> '') then
            SubCaption := SubCaption + ', ';
          SubCaption := SubCaption + 'Tracks';
        end;
        CreateKML:
        begin
          if (SubCaption <> '') then
            SubCaption := SubCaption + ', ';
          SubCaption := SubCaption + 'Kml';
        end;
        CreateHTML:
        begin
          if (SubCaption <> '') then
            SubCaption := SubCaption + ', ';
          SubCaption := SubCaption + 'Html';
        end;
        CreateOSMPoints:
        begin
          if (SubCaption <> '') then
            SubCaption := SubCaption + ', ';
          SubCaption := SubCaption + 'Map';
        end;
      end;
    end;
    if (SubCaption <> '') then
    begin
      if (not GpxFileObj.ShowSelectTracks(ExtractFileName(GPXFile),
                                          Format('Select Rte/Trk to add to %s', [SubCaption]),
                                          TTagsToShow.RteTrk, '*')) then
        exit;
    end;

    for Func in AllFuncs  do
    begin
      GpxFileObj.FWayPointsProcessedList.Clear;
      case Func of
        PostProcess:
          GpxFileObj.DoPostProcess;
        CreateTracks:
          GpxFileObj.DoCreateTracks;
        CreateWayPoints:
          GpxFileObj.DoCreateWayPoints;
        CreatePOI:
          GpxFileObj.DoCreatePOI;
        CreateKML:
          GpxFileObj.DoCreateKML;
        CreateHTML:
          GpxFileObj.DoCreateHTML;
        CreateOSMPoints:
          GpxFileObj.DoCreateOSMPoints;
        CreatePOLY:
          GpxFileObj.DoCreatePOLY;
        CreateTrips:
          GpxFileObj.DoCreateTrips;
      end;
    end;

    // Process always last, removes a lot of nodes.
    for Func in AllFuncs  do
    begin
      case Func of
        TGPXFunc.CreateRoutes:
          GpxFileObj.DoCreateRoutes;
      end;
    end;
  finally
    GpxFileObj.Free;
  end;
end;

initialization
begin
  FormatSettings := GetLocaleSetting;
  OnSetFixedPrefs := nil;
end;

end.