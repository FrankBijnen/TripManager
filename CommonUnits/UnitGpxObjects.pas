unit UnitGPXObjects;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  System.Classes, System.SysUtils,
  WinApi.Windows, System.Math,
  Xml.XMLIntf, UnitVerySimpleXml,
  Vcl.ComCtrls,
{$IFDEF KML}
  kml_helper,
{$ENDIF}
{$IFDEF MAPUTILS}
  UnitMapUtils,
{$ENDIF}
{$IFDEF TRIPOBJECTS}
  UnitTripObjects,
{$ENDIF}
{$IFDEF GEOCODE}
  UnitGeoCode,
{$ENDIF}
{$IFDEF GPI}
  UnitGPI, UnitBMP,
{$ENDIF}
  UnitGpxDefs,
  UnitProcessOptions,
  UfrmSelectGpx;

type

  TGPXFile = class
  private
    FWayPointList: TXmlVSNodeList;          // All Original way point
    FWayPointFromRouteList: TXmlVSNodeList; // Used in CreateWaypoints and CreatePoi. Has Categories. Only private
    FRouteViaPointList: TXmlVSNodeList;     // Used in CreateOSM(Points), CreateKml, CreatePoly. Exposed public
    FTrackList: TXmlVSNodeList;             // All tracks. Can be created from calculated routes
    FWayPointsProcessedList: TStringList;   // To prevent duplicate Way points

    PrevTrackCoords: TCoords;
    CurrentTrack: TXmlVSNode;
    CurrentViaPointRoute: TXmlVSNode;
    CurrentWayPointFromRoute: TXmlVSNode;
    CurrentRouteTrackName: string;
    ShapingPointCnt: integer;               // Counter of all <trp:ShapingPoint>. Seqnr of name

    CurrentCoord: TCoords;
    TotalDistance: double;
    CurrentDistance: double;
    PrevCoord: TCoords;

    FXmlDocument: TXmlVSDocument;
    FOutDir: string;
    FOnFunctionPrefs: TNotifyEvent;
    FOnSavePrefs: TNotifyEvent;
    FOutStringList: TStringList;
    FSubClassList: TStringList;
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
{$IFDEF GPI}
    function GPXWayPoint(CatId, BmpId: integer; WayPoint: TXmlVSNode): TGPXWayPoint;
    function GetSpeedFromName(WptName: string): integer;
    function GPXBitMap(WayPoint: TXmlVSNode): TGPXBitmap;
    function GPXCategory(Category: string): TGPXCategory;
{$ENDIF}
    procedure FreeGlobals;
    procedure CreateGlobals;
    procedure ClearGlobals;

    procedure ProcessGPX;

    procedure ComputeDistance(RptNode: TXmlVSNode);
    procedure ClearSubClass(ANode: TXmlVSNode);
    procedure UnglitchNode(RtePtNode, ExtensionNode: TXmlVSNode; ViaPtName: UTF8String);
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
    procedure AddTrackPoint(const RptNode: TXmlVsNode; const ExtensionNode: TXmlVsNode = nil);
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
    function BuildSubClassesList(const RtePts: TXmlVSNodeList): boolean;
    function CreateLocations(Locations: TmLocations; RtePts: TXmlVSNodeList): integer;
    procedure UpdateTemplate(const TripName: string; RouteCnt, ParentTripId: cardinal; RtePts: TXmlVSNodeList);
{$ENDIF}
  protected
    procedure WriteTrack2XML(TracksRoot, Track: TXmlVSNode; DisplayColor: string);
    function MapSegRoadExclBit(const ASubClass: string): string;
    procedure BuildSubClasses(const ARtePt: TXmlVSNode;
                              const DistOKMeters: double;
                              const SCType: TSubClassType);
    procedure CloneAttributes(FromNode, ToNode: TXmlVsNode);
    procedure CloneSubNodes(FromNodes, ToNodes: TXmlVsNodeList);
    procedure CloneNode(FromNode, ToNode: TXmlVsNode);
    procedure Track2OSMTrackPoints(Track: TXmlVSNode;
                                   var TrackId: integer;
                                   TrackStringList: TStringList);
    procedure Track2FITTrackPoints(Track: TXmlVSNode;
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
    procedure CreateTrack(Track: TXmlVSNode; OutFile: string);
    procedure DoCreateTracks;
    procedure DoCreateWayPoints;
    procedure DoCreatePOI;
    procedure DoCreateKML;
    procedure DoCreateHTML;
    procedure DoCreateOSMPoints;
    procedure DoCreatePOLY;
    procedure DoCreateFITPoints;
    procedure DoCreateRoutes;
    procedure DoCreateCompleteRoutes;
    procedure DoCreateTrips;
{$IFDEF TRIPOBJECTS}
    procedure ProcessTrip(const RteNode: TXmlVSNode; RouteCnt, ParentTripId: Cardinal);
{$ENDIF}
    procedure FixCurrentGPX;
    procedure AnalyzeGpx;
    property SubClassList: TStringList read FSubClassList;
    property WayPointList: TXmlVSNodeList read FWayPointList;
    property RouteViaPointList: TXmlVSNodeList read FRouteViaPointList;
    property TrackList: TXmlVSNodeList read FTrackList;
    property XmlDocument: TXmlVSDocument read FXmlDocument;
    property ProcessOptions: TProcessOptions read FProcessOptions write FProcessOptions;
    class procedure PerformFunctions(const AllFuncs: array of TGPXFunc;
                                     const GPXFile:string;
                                     const FunctionPrefs, SavePrefs: TNotifyEvent;
                                     const ForceOutDir: string = '';
                                     const OutStringList: TStringList = nil;
                                     const SeqNo: cardinal = 0);
    class function CmdLinePostProcess(SetPrefsEvent: TNotifyEvent): boolean;
end;

implementation

uses
  System.TypInfo, System.DateUtils, System.StrUtils, System.IOUtils, System.UITypes,
  Vcl.Dialogs,
{$IFDEF OSMMAP}
  UnitOSMMap,
{$ENDIF}
{$IFDEF REGISTRYKEYS}
  UnitRegistryKeys,
  UnitRegistry,
{$ENDIF}
  UnitRedirect,
  UnitStringUtils;

// Not configurable
const
  DebugComments: string = 'False';
  UniqueTracks: boolean = true;
  DeleteWayPtsInRoute: boolean = true;    // Remove Waypoints from stripped routes
  DeleteTracksInRoute: boolean = true;    // Remove Tracks from stripped routes
  DirectRoutingClass = '000000000000FFFFFFFFFFFFFFFFFFFFFFFF';
  UnglitchTreshold: double = 0.0005;      // In Km. ==> 50 Cm

var
  FormatSettings: TFormatSettings;

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
    Coord: TCoords;
begin
  Coord.FromAttributes(Coords);
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
  FSubClassList.Free;
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
  FSubClassList := TStringList.Create;
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

function TGPXfile.MapSegRoadExclBit(const ASubClass: string): string;
var
  RoadIdHex: Cardinal;
begin
  RoadIdHex := StrToIntDef('$' + Copy(ASubClass, 13, 8), 0) and $ffff7fbf; // $11ff7fbf; ?
  result := UpperCase(Copy(ASubClass, 5, 8) + IntToHex(RoadIdHex, 8));
end;

procedure TGPXfile.BuildSubClasses(const ARtePt: TXmlVSNode;
                                   const DistOKMeters: double;
                                   const SCType: TSubClassType);

  procedure AddSubClass(const GpxxRptNode: TXmlVSNode; const CurType: TSubClassType = [scCompare]);
  var
    CMapSegRoad: string;
    KeepBegin: boolean;
    KeepEnd: boolean;
  begin
    CMapSegRoad := FindSubNodeValue(GpxxRptNode, 'gpxx:Subclass');
    if (CMapSegRoad <> '') then
    begin
      if (scCompare in SCType) then
        CMapSegRoad := MapSegRoadExclBit(CMapSegRoad) // For compare only mapsegment and roadid
      else
      begin
        if (Copy(CMapSegRoad, 21, 4) = '2116') then   // Complete subclass
        begin
          KeepBegin := ((scFirst in SCType) and
                        (scFirst in CurType));
          if not KeepBegin then
            exit;
        end;

        if (Copy(CMapSegRoad, 21, 4) = '2117') then
        begin
          KeepEnd :=  ((ScLast in SCType) and
                       (ScLast in CurType));
          if not KeepEnd then
            exit;
        end;

      end;
      FSubClassList.AddObject(CMapSegRoad, GpxxRptNode);
    end;
  end;

  //Add subclasses from previous segment with Distance < DistOK from this Rtept
  procedure AddPreviousSegment;
  var
    ScanGpxxRptNode: TXmlVSNode;
    RtePtCoord, GpxxRptCoord: TCoords;
    PrevRtePt: TXmlVSNode;
    ThisDist: double;
  begin
    PrevRtePt := ARtePt.PreviousSibling;
    if (PrevRtePt = nil) then
      exit;

    RtePtCoord.FromAttributes(ARtePt.AttributeList);
    ScanGpxxRptNode := GetLastExtensionsNode(PrevRtePt);
    while (ScanGpxxRptNode <> nil) do
    begin
      GpxxRptCoord.FromAttributes(ScanGpxxRptNode.AttributeList);
      ThisDist := CoordDistance(RtePtCoord, GpxxRptCoord, TDistanceUnit.duKm);
      if (ThisDist > DistOKMeters) then
        break;
      AddSubClass(ScanGpxxRptNode);

      ScanGpxxRptNode := ScanGpxxRptNode.PreviousSibling;
    end;
  end;

  // Add subclasses from this segment
  procedure AddCurrentSegment;
  var
    ScanGpxxRptNode: TXmlVSNode;
    SegmentCnt: integer;
    CurType: TSubClassType;
  begin
    ScanGpxxRptNode := GetFirstExtensionsNode(ARtePt);
    SegmentCnt := 0;
    while (ScanGpxxRptNode <> nil) do
    begin
      CurType := [];
      if (SegmentCnt = 0) then
        Include(CurType, scFirst);
      if (ScanGpxxRptNode.NextSibling = nil) then
        Include(CurType, ScLast);
      Inc(SegmentCnt);

      AddSubClass(ScanGpxxRptNode, CurType);

      ScanGpxxRptNode := ScanGpxxRptNode.NextSibling;
    end;
  end;

  //Add subclasses from next segment with Distance < DistOK from next Rtept
  procedure AddNextSegment;
  var
    ScanGpxxRptNode: TXmlVSNode;
    RtePtCoord, GpxxRptCoord: TCoords;
    NextRtePt: TXmlVSNode;
    ThisDist: double;
  begin
    NextRtePt := ARtePt.NextSibling;
    if (NextRtePt = nil) then
      exit;

    RtePtCoord.FromAttributes(NextRtePt.AttributeList);
    ScanGpxxRptNode := GetFirstExtensionsNode(NextRtePt);
    while (ScanGpxxRptNode <> nil) do
    begin
      GpxxRptCoord.FromAttributes(ScanGpxxRptNode.AttributeList);
      ThisDist := CoordDistance(RtePtCoord, GpxxRptCoord, TDistanceUnit.duKm);
      if (ThisDist > DistOKMeters) then
        break;

      AddSubClass(ScanGpxxRptNode);

      ScanGpxxRptNode := ScanGpxxRptNode.NextSibling;
    end;
  end;

begin
  if (scCompare in SCType) then
  begin
    FSubClassList.Clear;

    AddPreviousSegment;

    AddCurrentSegment;

    AddNextSegment;
  end
  else
    AddCurrentSegment;
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
  CurrentCoord.FromAttributes(RptNode.AttributeList);
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

procedure TGPXfile.UnglitchNode(RtePtNode, ExtensionNode: TXmlVSNode; ViaPtName: UTF8String);
var
  RptNode, DebugNode: TXmlVSNode;
  ViaPtCoord, NextCoord: TCoords;
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
  ViaPtCoord.FromAttributes(RptNode.AttributeList);
  NextCoord.FromAttributes(RtePtNode.AttributeList);
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

procedure TGPXFile.AddTrackPoint(const RptNode: TXmlVsNode; const ExtensionNode: TXmlVsNode = nil);
var
  TrackPoint, RtePtViaPoint: TXmlVsNode;
  CurCoords: TCoords;
  CurDist: Double;
  SubNodeValue: string;
begin
  CurCoords.FromAttributes(RptNode.AttributeList);
  if (ProcessOptions.MinDistTrackPoint > 0) then
  begin
    CurDist := CoordDistance(CurCoords, PrevTrackCoords, TDistanceUnit.duKm);
    if (CurDist < (ProcessOptions.MinDistTrackPoint / 1000)) then
      exit
    else
      PrevTrackCoords := CurCoords;
  end;

  TrackPoint := CurrentTrack.AddChild('trkpt');
  CloneAttributes(RptNode, TrackPoint);

// For track
  SubNodeValue := FindSubNodeValue(RptNode, 'ele');
  if (SubNodeValue <> '') then
    TrackPoint.AddChild('ele').NodeValue := SubNodeValue;

  SubNodeValue := '';
  if (ExtensionNode <> nil) then
  begin
    // Use Departure from (Start) point as time
    RtePtViaPoint := ExtensionNode.Find('trp:ViaPoint');
    if (RtePtViaPoint <> nil) then
      SubNodeValue := FindSubNodeValue(RtePtViaPoint,'trp:DepartureTime');
  end
  else
    SubNodeValue := FindSubNodeValue(RptNode, 'time');

  if (SubNodeValue <> '') then
    TrackPoint.AddChild('time').NodeValue := SubNodeValue;
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
    PrevCoord.FromAttributes(RtePtNode.AttributeList);
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

    case ProcessOptions.ShapingPointName of
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
      UnglitchNode(RtePtNode, ExtensionNode, UTF8String(ShapePtName));

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
    AddTrackPoint(RtePtNode, ExtensionNode);  // Add the <rtept> as a trackpoint. Will draw straight lines. In line with BC
    for RptNode in ExtensionNode.ChildNodes do
    begin
      if (RptNode.Name = 'gpxx:rpt') then
        AddTrackPoint(RptNode);
    end;
  end;
end;

procedure TGPXFile.ProcessRte(const RteNode: TXmlVSNode);
var
  RtePtNode, RteNameNode, NumberNode: TXmlVSNode;
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

  NumberNode := nil;
  if (ProcessOptions.ProcessTracks) then
  begin
    FillChar(PrevTrackCoords, SizeOf(PrevTrackCoords), 0);
    CurrentTrack := FTrackList.Add(CurrentRouteTrackName);
    CurrentTrack.NodeValue := CurrentRouteTrackName;
    CurrentTrack.AddChild('desc').NodeValue := 'Rte';
    NumberNode := CurrentTrack.AddChild('number');
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
  if (Assigned(NumberNode)) then
    NumberNode.NodeValue := Format('%f', [TotalDistance * 1000]);

  RtePts.Free;
end;

procedure TGPXFile.ProcessTrk(const TrkNode: TXmlVSNode);
var
  TrackNameNode, ExtensionsNode, TrackExtension: TXmlVSNode;
  TrkSegNode, TrkPtNode: TXmlVSNode;
  FirstTrkPtNode, LastTrkPtNode: TXmlVSNode;
  WptName, Symbol: string;
  TrackDistance: Double;
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
    FillChar(PrevTrackCoords, SizeOf(PrevTrackCoords), 0);
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
              PrevCoord.FromAttributes(TrkPtNode.AttributeList);
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
      TrackDistance := TotalDistance;
      TotalDistance := 0; // Showing Distance for Begin seems silly

      if (FirstTrkPtNode <> nil) then
      begin
        WptName := ProcessOptions.BeginStr + ' ' + CurrentRouteTrackName;
        Symbol := ProcessOptions.BeginSymbol;
        AddViaPoint(FirstTrkPtNode, WptName, Symbol);
      end;

      // Restore computed distance
      TotalDistance := TrackDistance;

      if (LastTrkPtNode <> nil) then
      begin
        WptName := ProcessOptions.EndStr + ' ' + CurrentRouteTrackName;
        Symbol := ProcessOptions.EndSymbol;
        AddViaPoint(LastTrkPtNode, WptName, Symbol);
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
  MainNode, RtePtNode: TXmlVSNode;
begin
  for MainNode in GpxNode.ChildNodes do
  begin
    TotalDistance := 0;
    if (MainNode.Name = 'wpt') then
      ProcessWpt(MainNode)
    else if (MainNode.Name = 'rte') then
    begin
      if (FOutStringList <> nil) then
      begin
        RtePtNode := MainNode.Find('rtept');
        if (RtePtNode = nil) then
        begin
          FOutStringList.Add(Format('Incomplete route detected %s', [FindSubNodeValue(MainNode, 'name')]));
          FOutStringList.Add(Format('Only the first error is reported', []));
        end;
      end;
      ProcessRte(MainNode);
    end
    else if (MainNode.Name = 'trk') then
      ProcessTrk(MainNode);
  end;
end;

procedure TGPXfile.FixCurrentGPX;
var
  AllXml: string;
begin
  AllXml := TFile.ReadAllText(FGPXFile, TEncoding.UTF8);
  AllXml := ReplaceAll(AllXml,
    ['</extensions><rte>', '</extensions></gpx>'],
    ['</extensions><rtept lat="0" lon="0"><name>Begin</name></rtept><rtept lat="0" lon="0"><name>End</name></rtept></rte><rte>',
     '</extensions><rtept lat="0" lon="0"><name>Begin</name></rtept><rtept lat="0" lon="0"><name>End</name></rtept></rte></gpx>'],
    [rfReplaceAll]);
  TFile.WriteAllText(FGPXFile, AllXml);
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

{$IFDEF GPI}
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
{$ENDIF}

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
  Track,  TrackRoute, RoutePoints: TXmlVSNode;
  DisplayColor, RteTrk: string;
  ChildNodeCount: string;
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

          ChildNodeCount := IntToStr(Track.ChildNodes.Count);
          if SameText(RteTrk, 'rte') then
          begin
            RoutePoints := RouteViaPointList.Find(Track.Name);
            if (RoutePoints <> nil) then
              ChildNodeCount := IntToStr(RoutePoints.ChildNodes.Count);
          end;

          if (Track.Find('extensions') <> nil) then
            DisplayColor := GetTrackColor(Track.Find('extensions').Find('gpxx:TrackExtension'))
          else
            DisplayColor := ProcessOptions.DefTrackColor;

          FrmSelectGPX.AllTracks.Add(DisplayColor + #9 +
                                     ChildNodeCount + #9 +
                                     Track.Name + #9 +
                                     RteTrk);
        end;
      end;
    TTagsToShow.WptRteTrk:
      begin

        if (WayPointList.Count > 0) then
          FrmSelectGPX.AllTracks.Add('-' + #9 +
                                     IntToStr(WayPointList.Count) + #9 +
                                     'Waypoints' + #9 +
                                     'Wpt');

        if (TrackList.Count > 0) then
        begin
          for TrackRoute in TrackList do
          begin
            RteTrk := FindSubNodeValue(TrackRoute, 'desc');

            ChildNodeCount := IntToStr(TrackRoute.ChildNodes.Count);
            if SameText(RteTrk, 'rte') then
            begin
              RoutePoints := RouteViaPointList.Find(TrackRoute.Name);
              if (RoutePoints <> nil) then
                ChildNodeCount := IntToStr(RoutePoints.ChildNodes.Count);
            end;

            if (TrackRoute.ChildNodes.Count > 0) then
              FrmSelectGPX.AllTracks.Add('-' + #9 +
                                         ChildNodeCount + #9 +
                                         TrackRoute.NodeValue + #9 +
                                         RteTrk);
          end;
        end;
      end;
  end;

  FrmSelectGPX.LoadTracks(ProcessOptions.TrackColor, TagsToShow, CheckMask);
  FrmSelectGPX.Caption := Caption;
  FrmSelectGPX.PnlTop.Caption := SubCaption;
  result := ProcessOptions.HasConsole or ProcessOptions.SkipTrackDialog;
  if not result then
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

procedure TGPXfile.WriteTrack2XML(TracksRoot, Track: TXmlVSNode; DisplayColor: string);
var
  WptTrack: TXmlVSNode;
  TrackPoint: TXmlVSNode;
begin
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

procedure TGPXfile.CreateTrack(Track: TXmlVSNode; OutFile: string);
var
  TracksXml: TXmlVSDocument;
  TracksRoot: TXmlVSNode;
begin
  TracksXml := TXmlVSDocument.Create;
  try
    TracksRoot := InitGarminGpx(TracksXml);
    WriteTrack2XML(TracksRoot, Track, ProcessOptions.DefTrackColor);
    TracksXml.SaveToFile(OutFile);
  finally
    TracksXml.Free;
  end;
end;

procedure TGPXfile.DoCreateTracks;
var
  TracksXml: TXmlVSDocument;
  TracksRoot: TXmlVSNode;
  Track : TXmlVSNode;
  OutFile, DisplayColor: string;
  TracksProcessed: TStringList;
begin
  TracksProcessed := TStringList.Create;
  TracksXml := TXmlVSDocument.Create;
  try
    TracksRoot := InitGarminGpx(TracksXml);

    for Track in FTrackList do
    begin
      DisplayColor := FrmSelectGPX.TrackSelectedColor(Track.Name, FindSubNodeValue(Track, 'desc'));
      if (DisplayColor = '') then
        continue;

      if (UniqueTracks) then
      begin
        if (TracksProcessed.IndexOf(Track.NodeValue) > -1) then
          continue;
        TracksProcessed.Add(Track.NodeValue);
      end;

      WriteTrack2XML(TracksRoot, Track, DisplayColor);
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
{$IFDEF GPI}
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
{$ENDIF}
begin
{$IFDEF GPI}
  OutFile := ChangeFileExt(FOutDir + FBaseFile, '.gpi');
  try
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
  except
    on E:Exception do
      MessageDlg(e.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
  end;
{$ENDIF}
end;

procedure TGPXFile.DoCreateKML;
{$IFDEF KML}
var
  OutFile, Lon, Lat, Ele, DisplayColor: string;
  RouteWayPoint, WayPoint: TXmlVSNode;
  WayPointAttribute: TXmlVSAttribute;
  Track : TXmlVSNode;
  Folder: IXMLNode;
  TrackPoint: TXmlVSNode;
  TrackPointAttribute: TXmlVSAttribute;
  Helper: TKMLHelper;
{$ENDIF}
begin
{$IFDEF KML}
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
{$ENDIF}
end;

procedure TGPXFile.Track2OSMTrackPoints(Track: TXmlVSNode;
                                        var TrackId: integer;
                                        TrackStringList: TStringList);
{$IFDEF OSMMAP}
var
  Lon, Lat, DisplayColor, Color, LayerName, RoutePointName: string;
  RouteWayPoint, WayPoint: TXmlVSNode;
  WayPointAttribute: TXmlVSAttribute;
  TrackPoint: TXmlVSNode;
  RtePtExtensions: TXmlVSNode;
  LayerId: integer;
  TrackPointAttribute: TXmlVSAttribute;
{$ENDIF}
begin
{$IFDEF OSMMAP}
  TrackStringList.Clear;
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
    AdjustLatLon(Lat, Lon, Coord_Decimals);
    TrackStringList.Add(Format('     AddTrkPoint(%s,%s);', [ Lat, Lon]));
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

        TrackStringList.Add(Format('     AddRoutePoint(%d, "%s", "%s", %s, %s, "%s");',
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
  TrackStringList.Add(Format('     CreateTrack("%s", "%s");', [EscapeDQuote(Track.Name), OSMColor(DisplayColor)]));
{$ENDIF}
end;

procedure TGPXFile.Track2FITTrackPoints(Track: TXmlVSNode;
                                        var TrackId: integer;
                                        TrackStringList: TStringList);
{$IFDEF TRIPOBJECTS}
var
  TrackPoint: TXmlVSNode;
  Rte, RtePt: TXmlVSNode;
  Coords: TCoords;
  PrevCoords: TCoords;
  UnixTime: cardinal;
  WinDateTime: TDateTime;
  GpxTime: string;
  Ele: string;
  CurrentDist: double;
  BikeSpeed: double; // in 100 meters / sec

  function CoordAsInt(CoordDec: double): integer;
  begin
    result := Round(SimpleRoundTo(CoordDec, -10) * 4294967296 / 360);
  end;
{$ENDIF}
begin
{$IFDEF TRIPOBJECTS}
  BikeSpeed := (FProcessOptions.DefRoadSpeed * 100000) / 3600;
  TrackStringList.Clear;
  UnixTime := 0;

  TrackStringList.Add(Format('%s', [EscapeFileName(Track.Name)]));

  for TrackPoint in Track.ChildNodes do
  begin
    if (TrackPoint.Name = 'trkpt') then
    begin
      PrevCoords.FromAttributes(TrackPoint.AttributeList);

      GpxTime := FindSubNodeValue(TrackPoint, 'time');
      if (GpxTime <> '') and
        TryISO8601ToDate(GpxTime, WinDateTime, false) then
        UnixTime := TUnixDate.DateTimeAsCardinal(WinDateTime)
      else
        UnixTime := TUnixDate.DateTimeAsCardinal(Now);
      UnixTime := UnixTime + Cardinal(TrackId);  // Time needs to be unique.

      break;
    end;
  end;

  for Rte in RouteViaPointList do
  begin
    if (Rte.NodeName <> Track.Name) then
      continue;
    for RtePt in Rte.ChildNodes do
    begin
      Coords.FromAttributes(RtePt.AttributeList);
      TrackStringList.Add(Format('0,%u,%u,%u,%1.0f,%s,%s',
                                [UnixTime,
                                 CoordAsInt(Coords.Lat),
                                 CoordAsInt(Coords.Lon),
                                 0.0,
                                 '0',
                                 ReplaceAll(FindSubNodeValue(RtePt, 'name'), [' ', #9], ['_', '_'])
                                ]));

    end;
  end;

  for TrackPoint in Track.ChildNodes do
  begin
    if (TrackPoint.Name <> 'trkpt') then
      continue;

    Coords.FromAttributes(TrackPoint.AttributeList);
    CurrentDist := (CoordDistance(Coords, PrevCoords, TDistanceUnit.duKm) * 100000); // * 100m
    PrevCoords := Coords;
    if (CurrentDist = 0) then
      continue;

    // speed?
    UnixTime := UnixTime + Round((CurrentDist / BikeSpeed));

    Ele := FindSubNodeValue(TrackPoint, 'ele');
    if (Ele = '') then
      Ele := '0';
    TrackStringList.Add(Format('1,%u,%u,%u,%1.0f,%s',
                              [UnixTime,
                               CoordAsInt(Coords.Lat),
                               CoordAsInt(Coords.Lon),
                               CurrentDist,
                               Ele]));
  end;
  TrackStringList.Add(Chr(26)); // EOF for Stdin
{$ENDIF}
end;

procedure TGPXFile.DoCreateHTML;
{$IFDEF OSMMAP}
var
  OutFile: string;
  Track : TXmlVSNode;
  TrackId: integer;
  TrackPointList: TStringList;
{$ENDIF}
begin
{$IFDEF OSMMAP}
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
{$ENDIF}
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
  Coords: TCoords;
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
      Coords.FromAttributes(WayPoint.AttributeList);
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

procedure TGPXFile.DoCreateFITPoints;
var
  Track : TXmlVSNode;
  TrackId: integer;
  TrackPointList: TStringList;
  DisplayColor: string;
  ResOut, ResErr: string;
  ResExit: DWord;
begin
  TrackPointList := TStringList.Create;
  try
    TrackId := 0;
    for Track in FTrackList do
    begin
      DisplayColor := FrmSelectGPX.TrackSelectedColor(Track.Name, FindSubNodeValue(Track, 'desc'));
      if (DisplayColor = '') then
        continue;

      Track2FITTrackPoints(Track, TrackId, TrackPointList);
      Inc(TrackId);
      Sto_RedirectedExecute('trk2fit.exe', FOutDir, ResOut, ResErr, ResExit, TrackPointList.Text);
      if (ResExit <> 0) then
        raise Exception.Create(Track.NodeValue + #10 + ResOut + #10 + ResErr);
    end;
  finally
    TrackPointList.Free;
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

procedure TGPXFile.DoCreateCompleteRoutes;
var
  OutFile: string;
begin
  OutFile := FOutDir + ExtractFilename(FGPXFile);
  if not CopyFile(PWideChar(FGPXFile), PWideChar(OutFile), false) then
    raise Exception.Create(Format('Could not copy %s to:%s%s', [FGPXFile, #10, FOutDir]))
end;

{$IFDEF TRIPOBJECTS}
function TGPXFile.BuildSubClassesList(const RtePts: TXmlVSNodeList): boolean;
var
  ARtePt: TXmlVSNode;
  FirstRtePt, LastRtePt: TXmlVSNode;
  ScType: TSubClassType;
begin
  SubClassList.Clear;

  // From to segment
  FirstRtePt := RtePts.First;
  LastRtePt := RtePts.Last;
  if (LastRtePt <> nil) then
    LastRtePt := LastRtePt.PreviousSibling;

  // Build SubClass list.
  for ARtePt in RtePts do
  begin
    ScType := [];
    if (ProcessOptions.TripOption in [TTripOption.ttTripTrack]) then // Need to drop intermediate route points
    begin
      if (ARtePt = FirstRtePt) then
        Include(ScType, scFirst);
      if (ARtePt = LastRtePt) then
        Include(ScType, ScLast);
    end;
    BuildSubClasses(ARtePt, 0, ScType);
  end;

  result := (SubClassList.Count > 2); // Need more than a start and end
end;

function TGPXFile.CreateLocations(Locations: TmLocations; RtePts: TXmlVSNodeList): integer;
var
  RtePtNode: TXmlVSNode;
  RtePtName: string;
  Coords: TCoords;
  RtePtExtensions: TXmlVSNode;
  RtePtViaPoint: TXmlVSNode;
  RtePtCalculationMode: TXmlVSNode;
  RtePtAdvLevel: TXmlVSNode;
  RtePtCmt: string;
  DepartureDateString: string;
  DepartureDate: TDateTime;
  PointCnt: integer;
  RoutePoint: TRoutePoint;
  RoutePref: TRoutePreference;
  AdvLevel: TAdvlevel;
begin
  result := 0;
  PointCnt := 0;
  RoutePref := TRoutePreference.rmFasterTime;  // If the GPX has no trp:CalculationMode at all
  for RtePtNode in RtePts do
  begin
    Inc(PointCnt);
    AdvLevel := TAdvlevel.advNA;
    if (ProcessOptions.TripOption in [TTripOption.ttTripTrack]) then
    begin
      if (PointCnt <> 1) and
         (PointCnt <> RtePts.Count) then
        continue;
    end;
    // Get Data from RtePt
    RtePtName := FindSubNodeValue(RtePtNode, 'name');
    // Coords
    Coords.FromAttributes(RtePtNode.AttributeList);
    // Via/Shape
    RoutePoint := TRoutePoint.rpShaping;
    RtePtExtensions := RtePtNode.Find('extensions');
    if (RtePtExtensions = nil) then
      continue;
    RtePtViaPoint := RtePtExtensions.Find('trp:ViaPoint');
    if (RtePtViaPoint <> nil) then
    begin
      Inc(result);
      RoutePoint := TRoutePoint.rpVia;

      // RoutePref
      if (ProcessOptions.TripOption in [TTripOption.ttTripTrack, TTripOption.ttTripTrackLoc]) then
      begin
        RoutePref := TRoutePreference.rmTripTrack;
        AdvLevel := TAdvlevel.advNA;
      end
      else
      begin
        RtePtCalculationMode := RtePtViaPoint.Find('trp:CalculationMode');
        if (RtePtCalculationMode <> nil) then
          RoutePref := TmRoutePreference.RoutePreference(RtePtCalculationMode.NodeValue);
        if (RoutePref = TRoutePreference.rmCurvyRoads) then
        begin
          AdvLevel := TAdvlevel.advNA;
          RtePtAdvLevel := RtePtViaPoint.Find('trp:AdventurousLevel');
          if (RtePtAdvLevel <> nil) then
            AdvLevel := TmRoutePreference.AdvLevel(RtePtAdvLevel.NodeValue);
        end;
      end;
    end;

    // Address
    RtePtCmt := FindSubNodeValue(RtePtNode, 'cmt');
    if (RtePtCmt = '') then
      RtePtCmt := Format('%s, %s', [FormatFloat('##0.00000', Coords.Lat, FormatSettings),
                                    FormatFloat('##0.00000', Coords.Lon, FormatSettings)]
                        );
    // Departure
    DepartureDateString := '';
    if (RtePtViaPoint <> nil) then
      DepartureDateString := FindSubNodeValue(RtePtViaPoint,'trp:DepartureTime');
    if (DepartureDateString <> '') and
      TryISO8601ToDate(DepartureDateString, DepartureDate, false) then
    else
      DepartureDate := 0;

    // Have all we need. Create location
    FTripList.AddLocation(Locations,
                          ProcessOptions,
                          RoutePoint,
                          RoutePref,
                          AdvLevel,
                          Coords.Lat, Coords.Lon,
                          DepartureDate, RtePtName, RtePtCmt);
  end;
end;


procedure TGPXFile.UpdateTemplate(const TripName: string; RouteCnt, ParentTripId: cardinal; RtePts: TXmlVSNodeList);
var
  ViaPointCount:    integer;
  HasSubClasses:    boolean;
  Locations:        TmLocations;
  mParentTripName:  TmParentTripName;
  RouteNode:        TXmlVSNode;
  GpxDistance:      double;
begin
  if (ProcessOptions.AllowGrouping) and
     (ProcessOptions.TripModel = TTripModel.XT) then
    (FTripList.GetItem('mParentTripId') as TmParentTripId).AsCardinal := ParentTripId;

  mParentTripName := FTripList.GetItem('mParentTripName') as TmParentTripName;
  if (Assigned(mParentTripName)) then
    mParentTripName.AsString := FBaseFile;

  Locations := FTripList.GetItem('mLocations') as TmLocations;
  ViaPointCount := CreateLocations(Locations, RtePts);

  HasSubClasses := BuildSubClassesList(RtePts);

  if ((ProcessOptions.TripOption in [TTripOption.ttTripTrack]) and HasSubClasses) then
  begin
    // Get distance from GPX, the subclasses are not accurate enough
    GpxDistance := 0;
    RouteNode := FTrackList.Find(TripName);
    if (Assigned(RouteNode)) then
      TryStrToFloat(FindSubNodeValue(RouteNode, 'number'), GpxDistance);

    // Create TripTrack from BC calculation
    FTripList.TripTrack(FTripList.TripModel, RtePts, SubClassList, GpxDistance);
  end
  else if ((ViaPointCount >= 2)and HasSubClasses) then
    // Create AllRoutes from BC calculation
    FTripList.SaveCalculated(FTripList.TripModel, RtePts)
  else
    // Create Dummy AllRoutes, to force recalc on the Zumo. Just an entry for every Via.
    FTripList.ForceRecalc(FTripList.TripModel, ViaPointCount);
end;

procedure TGPXFile.ProcessTrip(const RteNode: TXmlVSNode; RouteCnt, ParentTripId: Cardinal);
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
    FTripList.RouteCnt := RouteCnt;
    TripName := FindSubNodeValue(RteNode, 'name');
    OutFile := Format('%s%s%s', [FOutDir, EscapeFileName(TripName), '.trip']);

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
    FTripList.CreateTemplate(ProcessOptions.TripModel,
                             TripName, CalculationMode, TransportMode);

    UpdateTemplate(TripName, RouteCnt, ParentTripId, RtePts);

    // Write to File
    FTripList.SaveToFile(OutFile);

    // Create CSV
    if (ProcessOptions.TripOption <> TTripOption.ttTripTrack) and
       (ProcessOptions.EnableTripOverview) then
      FTripList.ExportTripInfo(ChangeFileExt(OutFile, '.csv'));

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
  DisplayColor: string;
  RouteCnt: integer;
{$ENDIF}
begin
{$IFDEF TRIPOBJECTS}
  GpxNode := FXmlDocument.ChildNodes.find('gpx');  // Look for <gpx> node
  if (GpxNode = nil) or
     (GpxNode.Name <> 'gpx') then
    exit;

  ParentTripId := TUnixDate.DateTimeAsCardinal(Now) + FSeqNo;
  RouteCnt := 0;
  for RteNode in GpxNode.ChildNodes do
  begin
    if (RteNode.Name <> 'rte') then // Only want <rte> nodes. No <trk> or <wpt>
      continue;
    DisplayColor := FrmSelectGPX.TrackSelectedColor(FindSubNodeValue(RteNode, 'name'), RteNode.Name);
    if (DisplayColor = '') then
      continue;

    ProcessTrip(RteNode, RouteCnt, ParentTripId);
    Inc(RouteCnt);
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
  CrWait, CrNormal: HCURSOR;

  function AddSubCaption(const SubCaption, Element: string): string;
  begin
    result := SubCaption;
    if (result <> '') then
      result := result + ', ';
    result := result + Element;
  end;

begin

  GpxFileObj := TGPXFile.Create(GPXFile, ForceOutDir, FunctionPrefs, SavePrefs, OutStringList, SeqNo);
  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
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
        CreateCompleteRoutes,
        CreateTrips,
        CreateFITPoints:
          begin
            if not Assigned(OutStringList) then
              ForceDirectories(GpxFileObj.FOutDir);
            break;
          end;
      end;
    end;

    SetCursor(CrWait);
    GpxFileObj.ProcessGPX;

    SubCaption := '';
    for Func in AllFuncs do
    begin
      case Func of
        CreateTracks:
          SubCaption := AddSubCaption(SubCaption, 'Tracks');
        CreateKML:
          SubCaption := AddSubCaption(SubCaption, 'Kml');
        CreateHTML:
          SubCaption := AddSubCaption(SubCaption, 'Html');
        CreateOSMPoints:
          SubCaption := AddSubCaption(SubCaption, 'Map');
        CreateFITPoints:
          SubCaption := AddSubCaption(SubCaption, 'Fit');
        CreateTrips:
          SubCaption := AddSubCaption(SubCaption, 'Trip');
      end;
    end;

    if (SubCaption <> '') then
    begin
      if (not GpxFileObj.ShowSelectTracks(ExtractFileName(GPXFile),
                                          Format('Select Rte/Trk to add to %s', [SubCaption]),
                                          TTagsToShow.RteTrk, '*')) then
        exit;
      SetCursor(CrWait);
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
        CreateFITPoints:
          GpxFileObj.DoCreateFITPoints;
        CreatePOLY:
          GpxFileObj.DoCreatePOLY;
        CreateTrips:
          GpxFileObj.DoCreateTrips;
        CreateCompleteRoutes:
          GpxFileObj.DoCreateCompleteRoutes;
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
    SetCursor(CrNormal);
  end;
end;

class function TGPXFile.CmdLinePostProcess(SetPrefsEvent: TNotifyEvent): boolean;
var
  Fs: TSearchRec;
  Rc, Cnt: integer;
  HasConsole: boolean;
  GPXDir: string;
  GPXMask: string;
  AGPX: string;
  Funcs: TGPXFuncArray;
  AFunc: TGPXFunc;

  procedure ShowUsage;
  begin
    if HasConsole then
    begin
      Writeln;
      Writeln;
      Writeln('Usage: ', paramstr(0) + ' /Options GPX files Mask');
      Writeln;
      Writeln('Options:');
      Writeln(#9, '/PP or /PostProcess = Postprocess');
      Writeln(#9, '/Trips              = Create .trip Zumo Trips');
      Writeln(#9, '/Routes             = Create GPX Stripped Routes');
      Writeln(#9, '/Tracks             = Create GPX Tracks');
      Writeln(#9, '/Wpts or /WayPoints = Create GPX WayPoints');
      Writeln(#9, '/Poi or /Gpi        = Create Points Of Interest');
      Writeln(#9, '/Kml                = Create KML Google Earth');
      Writeln(#9, '/Html               = Create HTML');
      Writeln(#9, '/Poly               = Create POLY');
      Writeln;
      Writeln('Example: ', paramstr(0), ' /PP /Tracks /Trips *.gpx');
      Writeln;
    end;
  end;

begin
  Cnt := 0;
  result := false;
  SetLength(Funcs, 0);
  HasConsole := AttachConsole(ATTACH_PARENT_PROCESS);
  try
    if FindCmdLineSwitch('?', true) then
    begin
      ShowUsage;
      exit(true);
    end;
    if FindCmdLineSwitch('PP', true) or
       FindCmdLineSwitch('PostProcess', true) then
      Funcs := Funcs + [TGPXFunc.PostProcess];
    if FindCmdLineSwitch('TRACKS', true) then
      Funcs := Funcs + [TGPXFunc.CreateTracks];
    if FindCmdLineSwitch('WPTS', true) or
       FindCmdLineSwitch('WAYPOINTS', true) then
      Funcs := Funcs + [TGPXFunc.CreateWayPoints];
    if FindCmdLineSwitch('POI', true) or
       FindCmdLineSwitch('GPI', true) then
      Funcs := Funcs + [TGPXFunc.CreatePOI];
    if FindCmdLineSwitch('KML', true) then
      Funcs := Funcs + [TGPXFunc.CreateKML];
    if FindCmdLineSwitch('HTML', true) then
      Funcs := Funcs + [TGPXFunc.CreateHTML];
    if FindCmdLineSwitch('POLY', true) then
      Funcs := Funcs + [TGPXFunc.CreatePoly];
    if FindCmdLineSwitch('ROUTES', true) then
      Funcs := Funcs + [TGPXFunc.CreateRoutes];
    if FindCmdLineSwitch('TRIPS', true) then
      Funcs := Funcs + [TGPXFunc.CreateTrips];

    if (Length(Funcs) > 0) and
       (ParamCount > 1) then
    begin
      result := true;
      GPXMask := ParamStr(ParamCount);
      GPXDir := ExtractFilePath(TPath.GetFullPath(GPXMask));
      if (HasConsole) then
      begin
        Writeln;
        Writeln;
        Writeln('Processing started for: ', GPXMask);
{$IFDEF TRIPOBJECTS}
{$IFDEF REGISTRYKEYS}
        Writeln('Selected model: ', TModelConv.GetDefaultDevice(GetRegistry(Reg_CurrentModel, 0)));
{$ENDIF}
{$ENDIF}
        Write('Selected functions:');
        for AFunc in Funcs do
        begin
          Write(' ', GetEnumName(TypeInfo(TGPXFunc), Ord(AFunc)));
        end;
        Writeln;
      end;
      Rc := System.SysUtils.FindFirst(GPXmask, faAnyFile - faDirectory, Fs);
      while (Rc = 0) do
      begin
        Inc(Cnt);
        AGPX := TPath.Combine(GPXDir, Fs.Name);
        if (HasConsole) then
          Writeln('Processing: ', AGPX);
        TGPXFile.PerformFunctions(Funcs, AGPX, SetPrefsEvent, nil);
        Rc := System.SysUtils.FindNext(Fs);
      end;
      System.SysUtils.FindClose(Fs);
      if (HasConsole) then
        Writeln('Processing ended. ', Cnt, ' Files processed');
    end;
  finally
    FreeConsole;
  end;
end;

initialization
begin
  FormatSettings := GetLocaleSetting;
end;

end.