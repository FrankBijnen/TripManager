unit UnitGPX;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  System.Classes, System.SysUtils, Vcl.ExtCtrls, Vcl.Dialogs,
  WinApi.Windows, System.IniFiles, System.Math,
  Xml.XMLIntf, UnitVerySimpleXml,
  kml_helper, OSM_helper,
  UnitMapUtils,
  UnitGPI, UnitBMP, UnitTripObjects;

type
  TDistanceUnit = (duKm, duMi);
  TProcessCategory = (pcSymbol, pcGPX);
  TProcessCategoryFor = (pcfNone, pcfWayPt, pcfViaPt, pcfShapePt);
  TShapingPointName = (Unchanged, Route_Sequence, Route_Distance, Sequence_Route, Distance_Route);

  TCoord = record
    Lat: double;
    Lon: double;
  end;

  TGPXFunc = (Unglitch, CreateTracks, CreateRoutePoints, CreatePOI, CreateKML,
              CreateOSM, CreatePoly, CreateRoutes, CreateTrips, CreateOSMPoints);

const CreateSubDir: boolean = true;
const ForceOutDir: string  = '';
const EnableBalloon: boolean = true;
const EnableTimeout: boolean = true;
const TimeOut: integer = 1000;
const MaxTries: integer = 3;

const ProcessBegin: boolean = true;
const ProcessEnd: boolean = true;
const ProcessShape: boolean = true;
const ProcessSubClass: boolean = true;
const ProcessFlags: boolean = true;
const ProcessViaPts: boolean = true;
const ProcessWayPts: boolean = true;
const ProcessTracks: boolean = true;
const UniqueTracks: boolean = true;
const ProcessWayPtsFromRoute: boolean = true; // Create points for GPI and RoutePoints from route
const DeleteWayPtsInRoute: boolean = true;    // Remove Waypoints from stripped routes
const ProcessShapePtsInGpi: boolean = false;
const ProcessViaPtsInGpi: boolean = true;
const ProcessWayPtsInGpi: boolean = true;

const ProcessCategory: set of TProcessCategory = [pcSymbol, pcGPX];
const ProcessCategoryFor: set of TProcessCategoryFor = [pcfWayPt, pcfViaPt, pcfShapePt];
const ProcessCategoryPick: string = 'None' + #10 + 'Symbol' + #10 + 'GPX filename' + #10 + 'Symbol + GPX filename';
const ProcessDistance: boolean = true;
const ClearCmt: boolean = false;
const ClearDesc: boolean = false;
const IniProximityStr: TGPXString = '';

const DirectRoutingClass = '000000000000FFFFFFFFFFFFFFFFFFFFFFFF';
const UnglitchTreshold: double = 0.0005; // In Km. ==> 50 Cm
const BeginStr: string = 'Begin';
const BeginSymbol: string = 'Flag, Red';
const EndStr: string = 'End';
const EndSymbol: string = 'Flag, Blue';
const ShapingPointName: TShapingPointName = TShapingPointName.Route_Distance;
const ShapingPointSymbol: string = 'Navaid, Blue';
const ShapingPointCategory: string = 'Shape';
const ViaPointSymbol: string = 'Navaid, Red';
const ViaPointCategory: string = 'Via';
const DefTrackColor: string = 'Blue';
const TrackColor: string = 'Blue';
const KMLTrackColor: string = 'Magenta';
const OSMTrackColor: string = 'Red';
const DebugComments: string = 'False';
const DistanceUnit: TDistanceUnit = duKm;
const CatSymbol = 'Symbol:';
const CatGPX = 'GPX:';
const DefWaypointSymbol = 'Waypoint';
const ZumoModel: TZumoModel = TZumoModel.XT;

procedure DoFunction(const AllFuncs: array of TGPXFunc;
                     const GPXFile:string;
                     const OutStringList: TStringList = nil;
                     const SeqNo: cardinal = 0);
procedure ReadConfigFromIni;
function ReadConfigParm(ASection, AKey: TGPXString; Default: TGPXString = ''): TGPXString;
procedure Usage;
procedure ShowBalloon(const Hint: string; const Force: boolean = false);

implementation

uses
  System.TypInfo, System.DateUtils, System.StrUtils, UnitStringUtils, UfrmSelectGpx;

const EarthRadiusKm: Double = 6371.009;
const EarthRadiusMi: Double = 3958.761;

var TrayIcon: TTrayIcon;
    Xml: TXmlVSDocument;
    WptTracksXml: TXmlVSDocument;
    WayPointList: TXmlVSNodeList;
    WayPointFromRouteList: TXmlVSNodeList;
    RouteViaPointList: TXmlVSNodeList;
    TrackList: TXmlVSNodeList;
    ViaPoint: integer;
    WayPointsProcessedList: TStringList;
    FormatSettings: TFormatSettings;
    DistanceStr: string;

function GetToolsDirectory: TGPXString;
begin
  result := TGPXString(ExtractFilePath(ParamStr(0)));
end;

function ReadConfigParm(ASection, AKey: TGPXString; Default: TGPXString = ''): TGPXString;
var MainIni:TIniFile;
begin
  MainIni := TIniFile.Create(string(GetToolsDirectory + '\GPXTools.ini'));
  try
    result := TGPXString(MainIni.ReadString(string(ASection), string(AKey), string(Default)));
  finally
    MainIni.free;
  end;
end;

function ReadConfigParmStr(ASection, AKey: TGPXString; Default: TGPXString = ''):string;
begin
  result := string(ReadConfigParm(ASection, AKey, Default));
end;

function GetLocaleSetting: TFormatSettings;
begin
  // Get Windows settings, and modify decimal separator and negcurr
  Result := TFormatSettings.Create(GetThreadLocale);
  with Result do
  begin
    DecimalSeparator := '.'; // The decimal separator is a . PERIOD!
    NegCurrFormat := 11;
  end;
end;

function CoordFromAttribute(Atributes: TXmlVSAttributeList): TCoord;
begin
  result.Lat := StrToFloat(Atributes.Find('lat').Value, FormatSettings);
  result.Lon := StrToFloat(Atributes.Find('lon').Value, FormatSettings);
end;

function DegreesToRadians(Degrees: double): double;
begin
  result := Degrees * PI / 180;
end;

function CoordDistance(Coord1, Coord2: TCoord): double;
var DLat, DLon, Lat1, Lat2, A, C: double;
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

function DistanceFormat(Distance: double): string;
begin
  if (Distance < 100) then
    result := '%4.1f'
  else if (Distance < 1000) then
    result := '%3.0f'
  else
    result := '%4.0f';
  result := result + ' ' + DistanceStr;
end;

function Coord2Float(ACoord: LongInt): string;
var HCoord: Double;
begin
  result := IntToStr(ACoord);
  HCoord := ACoord;
  try
    HCoord := HCoord * 360;
    Result := result + ' * 360 = ' + FormatFloat('0', HCoord);
    HCoord := HCoord / 4294967296;
    Result := result + ' / 2^32 = ' + FormatFloat('0.000000000000000', HCoord);
  except
    result := '';
  end;
end;

function Float2Coord(ACoord: Double): LongInt;
var HCoord: Double;
begin
  try
    HCoord := ACoord * 4294967296 {2^32} / 360;
    result := round(HCoord);
  except
    result := 0;
  end;
end;

function DebugCoords(Coords: TXmlVSAttributeList): string;
var LastSub, Hex, LatLon: string;
    Coord: TCoord;
begin
  Coord := CoordFromAttribute(Coords);
  Hex := IntToHex(Float2Coord(Coord.Lat),8);
  LatLon := Hex + ' = ' + Coord2Float(Float2Coord(Coord.Lat));
  LastSub := Copy(Hex, 5, 2) + Copy(Hex, 3, 2);
  result := Copy(Hex, 1, 2);
  Hex := IntToHex(Float2Coord(Coord.Lon),8);
  LatLon := LatLon + ' ' + Hex + ' = ' + Coord2Float(Float2Coord(Coord.Lon));
  LastSub := LastSub + Copy(Hex, 5, 2) + Copy(Hex, 3, 2);
  result := result + Copy(Hex, 1, 2) + 'xx';
  result := result + LastSub + ' ' + LatLon;
end;

procedure ReadConfigFromIni;
begin
  TimeOut := StrToInt(string(ReadConfigParm('General', 'TimeOut', '1000')));
  TrackColor := ReadConfigParmStr('General', 'TrackColor', 'Blue');
  UniqueTracks := (ReadConfigParmStr('General', 'UniqueTracks', 'True') = 'True');
{$IFDEF DEBUG}
  DebugComments := ReadConfigParmStr('General', 'DebugComments', 'True');
{$ELSE}
  DebugComments := ReadConfigParmStr('General', 'DebugComments', 'False');
{$ENDIF}
  UnglitchTreshold := StrToFloat(ReadConfigParmStr('Unglitch', 'UnglitchTreshold', '0.0005'), FormatSettings);
  BeginStr := ReadConfigParmStr('Unglitch', 'BeginStr', 'Begin');
  BeginSymbol := ReadConfigParmStr('Unglitch', 'BeginSymbol', 'Flag, Red');
  EndStr := ReadConfigParmStr('Unglitch', 'EndStr', 'End');
  EndSymbol := ReadConfigParmStr('Unglitch', 'EndSymbol', 'Flag, Blue');
  ShapingPointName := TShapingPointName(GetEnumValue(TypeInfo(TShapingPointName),
                                                     ReadConfigParmStr('Unglitch', 'ShapingPointName', 'Unchanged')));
  ShapingPointSymbol := ReadConfigParmStr('Unglitch', 'ShapingPointSymbol', 'Navaid, Blue');
  ShapingPointCategory := ReadConfigParmStr('Unglitch', 'ShapingPointCategory', 'Shape');

  ViaPointSymbol := ReadConfigParmStr('Unglitch', 'ViaPointSymbol', 'Navaid, Red');
  ViaPointCategory := ReadConfigParmStr('Unglitch', 'ViaPointCategory', 'Via');

  KMLTrackColor := ReadConfigParmStr('KML', 'TrackColor', 'Magenta');

  OSMTrackColor := ReadConfigParmStr('OSM', 'TrackColor', 'Red');

  GpiSymbolsDir := GetToolsDirectory + '\' + ReadConfigParm('GPI', 'SymbolsDir', 'Symbols\80x80\');
  IniProximityStr := ReadConfigParm('GPI', 'DefaultProximity');
end;

procedure CreateGlobals;
begin
  RouteViaPointList := TXmlVSNodeList.Create;
  WayPointFromRouteList := TXmlVSNodeList.Create;
  WayPointList := TXmlVSNodeList.Create;
  TrackList := TXmlVSNodeList.Create;

  Xml := TXmlVSDocument.Create;
  WptTracksXml := TXmlVSDocument.Create;

  WayPointsProcessedList := TStringList.Create;

  if (DistanceUnit = TDistanceUnit.duMi) then
    DistanceStr := 'Mi'
  else
    DistanceStr := 'Km';

end;

procedure FreeGlobals;
begin
  RouteViaPointList.Free;
  WayPointFromRouteList.Free;
  WayPointList.Free;
  TrackList.Free;

  Xml.Free;
  WptTracksXml.Free;

  WayPointsProcessedList.Free;
end;

procedure CloneAttributes(FromNode, ToNode: TXmlVsNode);
var Attribute: TXmlVSAttribute;
begin
  for Attribute in FromNode.AttributeList do
    ToNode.SetAttribute(Attribute.Name, Attribute.Value);
end;

procedure CloneSubNodes(FromNodes, ToNodes: TXmlVsNodeList);
var SubNode, ToSubNode: TXmlVsNode;
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

procedure CloneNode(FromNode, ToNode: TXmlVsNode);
begin
  ToNode.NodeType := FromNode.NodeType;
  CloneAttributes(FromNode, ToNode);
  CloneSubNodes(FromNode.ChildNodes, ToNode.ChildNodes);
end;

function FindSubNodeValue(ANode: TXmlVSNode;
                          SubName: string): string;
var
  SubNode: TXmlVSNode;
begin
  Result := '';
  SubNode := ANode.Find(SubName);
  if (SubNode <> nil) then
  begin
    Result := SubNode.NodeValue;
    if (Result = '') and
       (SubNode.HasChildNodes) and
       (SubNode.FirstChild.NodeType = TXmlVSNodeType.ntCData) then
      Result := SubNode.FirstChild.NodeValue;
  end;
end;

function GetTrackColor(ANExtension: TXmlVsNode): string;
begin
  result := '';
  if (ANExtension <> nil) then
    result := FindSubNodeValue(ANExtension, 'gpxx:DisplayColor');
  if (result = '') then
    result := DefTrackColor;
end;

function GetFirstSubClass(const ExtensionNode: TXmlVSNode): string;
var GpxxRptNode: TXmlVSNode;

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

function MapSegFromSubClass(const CalculatedSubclass: string): integer;
var ErrCode: DWORD;
    Reversed: string;
begin
  Reversed := '$' + Copy(CalculatedSubclass, 7, 2) +
                    Copy(CalculatedSubclass, 5, 2) +
                    Copy(CalculatedSubclass, 3, 2) +
                    Copy(CalculatedSubclass, 1, 2);
  Val(Reversed, result, ErrCode);
end;

procedure ProcessGPX(const GPXFile, BaseFile:string);
var CurrentTrack: TXmlVSNode;
    CurrentViaPointRoute: TXmlVSNode;
    CurrentWayPointFromRoute: TXmlVSNode;
    CurrentRouteTrackName: string;
    TotalDistance: double;
    CurrentDistance: double;
    PrevCoord: TCoord;
    CurrentCoord: TCoord;
    TransportationMode: TXmlVSNode;
    GpxNode: TXmlVSNode;

    procedure ComputeDistance(RptNode: TXmlVSNode);
    begin
      CurrentCoord := CoordFromAttribute(RptNode.AttributeList);
      CurrentDistance := CoordDistance(PrevCoord, CurrentCoord);
      TotalDistance := TotalDistance + CurrentDistance;
      PrevCoord := CurrentCoord;
    end;

    procedure ClearSubClass(ANode: TXmlVSNode);
    var SubClassNode: TXmlVSNode;
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

    procedure UnglitchNode(RtePtNode, ExtensionNode: TXmlVSNode; ViaPtName:TGPXString);
    var RptNode, DebugNode: TXmlVSNode;
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
      Distance := CoordDistance(ViaPtCoord, NextCoord);

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

    procedure RenameSubNode(RtePtNode: TXmlVSNode;
                            const NodeName:string;
                            const NewName: string = '');
    var SubNode: TXmlVSNode;
    begin
      SubNode := RtePtNode.Find(NodeName);
      if (SubNode = nil) then
        exit;
      SubNode.NodeValue := NewName;
    end;

    procedure RenameNode(RtePtNode: TXmlVSNode; const NewName: string = '');
    begin
      RenameSubNode(RtePtNode, 'name', NewName);
      if (ClearCmt) then
        RenameSubNode(RtePtNode, 'cmt',  '');
      if (ClearDesc) then
        RenameSubNode(RtePtNode, 'desc', '');
    end;

    procedure AddCategory(const ExtensionsNode: TXmlVsNode;
                          const NS, Category: string);
    var AnExtensionsNode: TXmlVsNode;
    begin
      if (ProcessCategory = []) then
        exit;

      AnExtensionsNode := ExtensionsNode.AddChild(NS + 'WaypointExtension');
      AnExtensionsNode := AnExtensionsNode.AddChild(NS + 'Categories');
      if (pcSymbol in ProcessCategory) then
        AnExtensionsNode.AddChild(NS + 'Category').NodeValue := CatSymbol + Category;
      if (pcGPX in ProcessCategory) then
        AnExtensionsNode.AddChild(NS + 'Category').NodeValue := CatGPX + BaseFile;
    end;

    procedure ReplaceAutoName(const ExtensionsNode: TXmlVsNode;
                              const AutoName: string);
    var RouteExtensionsNode, AutoNameNode: TXmlVsNode;
    begin
      RouteExtensionsNode := ExtensionsNode.Find('gpxx:RouteExtension');
      if (RouteExtensionsNode = nil) then
        exit;
      AutoNameNode := RouteExtensionsNode.find('gpxx:IsAutoNamed');
      if (AutoNameNode = nil) then
        exit;
      AutoNameNode.NodeValue := AutoName;
    end;

    procedure ReplaceCategory(const ExtensionsNode: TXmlVsNode;
                              const NS, Category: string);
    var AnExtensionsNode, CategoriesNode: TXmlVsNode;
        CatsPos, CatPos:integer;
    begin
      if (ProcessCategory = []) then
        exit;
      if (ExtensionsNode = nil) then
        exit;
      AnExtensionsNode := ExtensionsNode.Find(NS + 'WaypointExtension');
      // Extensions node must exist. (Saved by Basecamp!)
      if (AnExtensionsNode = nil) then
        exit;
      CategoriesNode := AnExtensionsNode.find(NS + 'Categories');
      // Need to add categories?
      if (CategoriesNode = nil) then
      begin
        // Categories should be right after DisplayMode.
        CatsPos := AnExtensionsNode.FindPos(NS + 'DisplayMode');
        // Should always be there, but if not...
        if (CatsPos = -1) then
          exit;
        CategoriesNode := AnExtensionsNode.InsertChild(NS + 'Categories', CatsPos +1);
      end;
      // Always delete these categories
      for CatPos := CategoriesNode.ChildNodes.Count -1 downto 0 do
      begin
        if (StartsText(CatSymbol, CategoriesNode.ChildNodes[CatPos].NodeValue)) or
           (StartsText(CatGPX, CategoriesNode.ChildNodes[CatPos].NodeValue)) then
          CategoriesNode.ChildNodes.Delete(CatPos);
      end;
      // And add them if requested
      if (pcSymbol in ProcessCategory) then
        CategoriesNode.AddChild(NS + 'Category').NodeValue := CatSymbol + Category;
      if (pcGPX in ProcessCategory) then
        CategoriesNode.AddChild(NS + 'Category').NodeValue := CatGPX + BaseFile;
    end;

    procedure AddWptPoint(const ChildNode: TXmlVsNode;
                          const RtePtNode: TXmlVsNode;
                          const WayPointName: string;
                          const ProcessCategory: TProcessCategoryFor;
                          const Symbol: string = '';
                          const Comment: string = '');
    var ExtensionsNode: TXmlVsNode;
        NewSymbol, WptTime, WptCmt: string;
    begin
      with ChildNode do
      begin
        CloneAttributes(RtePtNode, ChildNode);
        WptTime := FindSubNodeValue(RtePtNode, 'time');
        if (WptTime <> '') then
          AddChild('time').NodeValue := WptTime;
        AddChild('name').NodeValue := WayPointName;
        if (Comment <> '') then
          WptCmt := Comment
        else
          WptCmt := FindSubNodeValue(RtePtNode, 'cmt');
        if (WptCmt <> '') then
          AddChild('cmt').NodeValue := WptCmt;

        NewSymbol := Symbol;
        if (NewSymbol = '') then
          NewSymbol := FindSubNodeValue(RtePtNode, 'sym');
        AddChild('sym').NodeValue := NewSymbol;
      end;

      if (ProcessCategory in ProcessCategoryFor) then
      begin
        ExtensionsNode := RtePtNode.find('extensions');
        if (ExtensionsNode <> nil) then
        begin
          ReplaceCategory(ExtensionsNode, 'gpxx:', NewSymbol);
          ReplaceCategory(ExtensionsNode, 'wptx1:', NewSymbol);
        end;
      end;

    end;

    procedure AddWayPointFromRoute(const RtePtNode: TXmlVsNode;
                                   const WayPointName: string;
                                   const Category: string;
                                   const Symbol: string);
    var NewNode, ExtensionsNode: TXmlVsNode;
    begin
      NewNode := CurrentWayPointFromRoute.AddChild('wpt');

      AddWptPoint(NewNode,
                  RtePtNode,
                  WayPointName,
                  TProcessCategoryFor.pcfViaPt,
                  Symbol);

      if (pcfViaPt in ProcessCategoryFor) then
      begin
        ExtensionsNode := NewNode.AddChild('extensions');
        AddCategory(ExtensionsNode, 'gpxx:', Category);
        AddCategory(ExtensionsNode, 'wptx1:', Category);
      end;
    end;

    procedure AddViaOrShapePoint(const RtePtNode: TXmlVsNode;
                          const ViaOrShapingPointName: string;
                          const Symbol: string;
                          const ProcessCategory: TProcessCategoryFor;
                          const Category: string);
    var NewNode, ExtensionsNode: TXmlVsNode;
        DefinedSymbol, Distance: string;
    begin
      // If there is a symbol defined, other than Waypoint, take that.
      DefinedSymbol := FindSubNodeValue(RtePtNode, 'sym');
      if (DefinedSymbol = '') or
         (DefinedSymbol = DefWaypointSymbol) then
        DefinedSymbol := Symbol;

      NewNode := CurrentViaPointRoute.AddChild('wpt');
      Distance := '';
      if (ProcessDistance) then
        Distance := Format(DistanceFormat(TotalDistance),
                           [TotalDistance], FormatSettings);
      AddWptPoint(NewNode,
                  RtePtNode,
                  ViaOrShapingPointName,
                  ProcessCategory,
                  DefinedSymbol,
                  Distance);

      if (pcfViaPt in ProcessCategoryFor) or
         (pcfShapePt in ProcessCategoryFor) then
      begin
        ExtensionsNode := NewNode.AddChild('extensions');
        AddCategory(ExtensionsNode, 'gpxx:', Category);
        AddCategory(ExtensionsNode, 'wptx1:', Category);
      end;

    end;

    procedure AddBeginPoint(const RtePtNode: TXmlVsNode;
                          const ViaPointName: string;
                          const Symbol: string);
    begin
      AddViaOrShapePoint(RtePtNode, ViaPointName, Symbol, TProcessCategoryFor.pcfViaPt, Beginstr);
    end;

    procedure AddEndPoint(const RtePtNode: TXmlVsNode;
                          const ViaPointName: string;
                          const Symbol: string);
    begin
      AddViaOrShapePoint(RtePtNode, ViaPointName, Symbol, TProcessCategoryFor.pcfViaPt, EndStr);
    end;

    procedure AddViaPoint(const RtePtNode: TXmlVsNode;
                          const ViaPointName: string;
                          const Symbol: string);
    begin
      AddViaOrShapePoint(RtePtNode, ViaPointName, Symbol, TProcessCategoryFor.pcfViaPt, ViaPointCategory);
    end;

    procedure AddShapingPoint(const RtePtNode: TXmlVsNode;
                              const ShapingPointName: string;
                              const Symbol: string);
    begin
      AddViaOrShapePoint(RtePtNode, ShapingPointName, Symbol, TProcessCategoryFor.pcfShapePt, ShapingPointCategory);
    end;

    procedure AddWayPoint(const RtePtNode: TXmlVsNode;
                          const WayPointName: string);
    var ExtensionsNode: TXmlVsNode;
        NewNode: TXmlVsNode;
    begin
      NewNode := WayPointList.Add('wpt');
      AddWptPoint(NewNode,
                  RtePtNode,
                  WayPointName,
                  TProcessCategoryFor.pcfWayPt);

      ExtensionsNode := RtePtNode.Find('extensions');
      if (ExtensionsNode = nil) then
        exit;
      CloneNode(ExtensionsNode, NewNode.AddChild('extensions'));
    end;

    procedure AddTrackPoint(const RptNode: TXmlVsNode);
    var TrackPoint: TXmlVsNode;
    begin
      TrackPoint := CurrentTrack.AddChild('trkpt');
      CloneAttributes(RptNode, TrackPoint);
    end;

    procedure ProcessRtePt(const RtePtNode: TXmlVsNode;
                           const RouteName: string;
                           const Cnt, LastCnt: integer);

    var ExtensionNode: TXmlVSNode;
        RptNode, RtePtExtensions, RtePtShapingPoint, RtePtViaPoint, ViaNodeName,
        DescNode, RteNode: TXmlVSNode;
        ShapePtName, WptName, Symbol, CalculatedSubClass, MapName: string;
        MapSeg, NewDescPos: integer;
    begin
      RtePtExtensions := RtePtNode.Find('extensions');
      if (RtePtExtensions = nil) then
        exit;
      ExtensionNode := RtePtExtensions.Find('gpxx:RoutePointExtension');
      RtePtShapingPoint := RtePtExtensions.Find('trp:ShapingPoint');
      RtePtViaPoint := RtePtExtensions.Find('trp:ViaPoint');

      // Begin
      if (ProcessDistance) and
         (Cnt = 1) then
      begin
        TotalDistance := 0;
        PrevCoord := CoordFromAttribute(RtePtNode.AttributeList);
      end;

      if (ProcessBegin) and
         (Cnt = 1) then
      begin
        WptName := BeginStr + ' ' + RouteName;
        Symbol := BeginSymbol;
        RenameNode(RtePtNode, WptName);
        if (ProcessFlags) then
          RenameSubNode(RtePtNode, 'sym', Symbol);
        ClearSubClass(ExtensionNode);

        // Fill Mapsegment
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

        if (ProcessWayPtsFromRoute) then
          AddWayPointFromRoute(RtePtNode, WptName, BeginStr, Symbol);

        if (ProcessViaPts) then
          AddBeginPoint(RtePtNode, WptName, Symbol);
      end;

      // End
      if (ProcessEnd) and
         (Cnt = LastCnt) then
      begin
        WptName := EndStr + ' ' + RouteName;
        Symbol := EndSymbol;
        RenameNode(RtePtNode, WptName);
        if (ProcessFlags) then
          RenameSubNode(RtePtNode, 'sym', Symbol);
        ClearSubClass(ExtensionNode);

        if (ProcessWayPtsFromRoute) then
          AddWayPointFromRoute(RtePtNode, WptName, EndStr, Symbol);

        if (ProcessViaPts) then
        begin
          if (ProcessDistance) then
            ComputeDistance(RtePtNode);
          AddEndPoint(RtePtNode, WptName, Symbol);
        end;
      end;

      // Shaping point
      if (RtePtShapingPoint <> nil) then
      begin
        if (ProcessDistance) then
          ComputeDistance(RtePtNode);
        inc(ViaPoint);

        case (ShapingPointName) of
          TShapingPointName.Unchanged:
            ShapePtName := FindSubNodeValue(RtePtNode, 'name');
          TShapingPointName.Route_Sequence:
            ShapePtName := Format('%s_%3.3d', [RouteName, ViaPoint]);
          TShapingPointName.Route_Distance:
            ShapePtName := Format('%s_%3.3d %s', [RouteName, Round(TotalDistance), DistanceStr]);
          TShapingPointName.Sequence_Route:
            ShapePtName := Format('%3.3d_%s', [ViaPoint, RouteName]);
          TShapingPointName.Distance_Route:
            ShapePtName := Format('%3.3d %s_%s', [Round(TotalDistance), DistanceStr, RouteName]);
        end;

        if (ProcessSubClass) then
          ClearSubClass(ExtensionNode);

        if (ProcessShape) then
        begin

          UnglitchNode(RtePtNode, ExtensionNode, TGPXString(ShapePtName));

          RenameNode(RtePtNode, ShapePtName);

          if (ProcessFlags) then
            RenameSubNode(RtePtNode, 'sym', DefWaypointSymbol); // Symbol for shaping and via points is only used for viapointsxxx gpx

        end;
        if (ProcessViaPts) then
          AddShapingPoint(RtePtNode, ShapePtName, ShapingPointSymbol);
      end;

      // Via point
      if (Cnt <> 1) and
         (Cnt <> LastCnt) and
         (RtePtViaPoint <> nil) then
      begin
        if (ProcessSubClass) then
          ClearSubClass(ExtensionNode);

        ViaNodeName := RtePtNode.Find('name');
        if (ViaNodeName <> nil) then
        begin
          Symbol := ViaPointSymbol;
          if (ProcessViaPts) then
            AddViaPoint(RtePtNode, ViaNodeName.NodeValue, Symbol);

          if (ProcessWayPtsFromRoute) then
            AddWayPointFromRoute(RtePtNode, ViaNodeName.NodeValue, ViaPointCategory, Symbol);
        end;
      end;

      if (ProcessDistance) and
         (ExtensionNode <> nil) then
      begin
        for RptNode in ExtensionNode.ChildNodes do
        begin
          if (RptNode.Name = 'gpxx:rpt') then
            ComputeDistance(RptNode);
        end;
      end;

      if (ProcessTracks) and
         (ExtensionNode <> nil) then
      begin
        for RptNode in ExtensionNode.ChildNodes do
        begin
          if (RptNode.Name = 'gpxx:rpt') then
            AddTrackPoint(RptNode);
        end;
      end;
    end;

    procedure ProcessRte(const RteNode: TXmlVSNode);
    var RtePtNode, RteNameNode: TXmlVSNode;
        ExtensionsNode, RouteExtension, Trp: TXmlVSNode;
        RtePts: TXmlVSNodeList;
        Cnt: integer;
    begin
      CurrentRouteTrackName := 'UnNamed';
      RteNameNode := RteNode.Find('name');
      if (RteNameNode <> nil) then
        CurrentRouteTrackName := RteNameNode.NodeValue;
      ExtensionsNode := RteNode.Find('extensions');

      ViaPoint := 0;

      if (ProcessWayPtsFromRoute) then
      begin
        CurrentWayPointFromRoute := WayPointFromRouteList.Add(CurrentRouteTrackName);
        CurrentWayPointFromRoute.NodeValue := CurrentRouteTrackName;
      end;

      if (ProcessViaPts) then
      begin
        CurrentViaPointRoute := RouteViaPointList.Add(CurrentRouteTrackName);
        CurrentViaPointRoute.NodeValue := CurrentRouteTrackName;
      end;

      if (ProcessTracks) then
      begin
        CurrentTrack := TrackList.Add(CurrentRouteTrackName);
        CurrentTrack.NodeValue := CurrentRouteTrackName;

        if (ExtensionsNode <> nil) then
        begin
          RouteExtension := ExtensionsNode.Find('gpxx:RouteExtension');
          if (RouteExtension <> nil) then
            CurrentTrack.AddChild('extensions').
                         AddChild('gpxx:TrackExtension').
                         AddChild('gpxx:DisplayColor').NodeValue := GetTrackColor(RouteExtension);
        end;
      end;

      TransportationMode := nil;
      if (ProcessShape) then
      begin
        if (ExtensionsNode <> nil) then
        begin
          Trp := ExtensionsNode.Find('trp:Trip');
          if (Trp <> nil) then
            TransportationMode := Trp.find('trp:TransportationMode');

          ReplaceAutoName(ExtensionsNode, 'false');
        end;
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

    procedure ProcessTrk(const TrkNode: TXmlVSNode);
    var TrackNameNode, ExtensionsNode, TrackExtension: TXmlVSNode;
        TrkSegNode, TrkPtNode: TXmlVSNode;
        FirstTrkPtNode, LastTrkPtNode: TXmlVSNode;
        WptName, Symbol: string;
    begin
      CurrentRouteTrackName := 'UnNamed';
      TrackNameNode := TrkNode.Find('name');
      if (TrackNameNode <> nil) then
        CurrentRouteTrackName := TrackNameNode.NodeValue;

      ExtensionsNode := TrkNode.Find('extensions');

      if (ProcessViaPts) then
      begin
        CurrentViaPointRoute := RouteViaPointList.Add(CurrentRouteTrackName);
        CurrentViaPointRoute.NodeValue := CurrentRouteTrackName;
      end;

      if (ProcessTracks) then
      begin
        CurrentTrack := TrackList.Add(CurrentRouteTrackName);
        CurrentTrack.NodeValue := CurrentRouteTrackName;
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
                if (ProcessDistance) then
                begin
                  TotalDistance := 0;
                  PrevCoord := CoordFromAttribute(TrkPtNode.AttributeList);
                end;
              end;
              LastTrkPtNode := TrkPtNode;
              if (ProcessDistance) then
                ComputeDistance(TrkPtNode);
            end;
          end;
        end;

        if (ProcessViaPts) then
        begin
          if (LastTrkPtNode <> nil) then
          begin
            WptName := EndStr + ' ' + CurrentRouteTrackName;
            Symbol := EndSymbol;
            AddViaPoint(LastTrkPtNode, WptName, Symbol);
          end;

          TotalDistance := 0; // Showing Distance for Begin seems silly

          if (FirstTrkPtNode <> nil) then
          begin
            WptName := BeginStr + ' ' + CurrentRouteTrackName;
            Symbol := BeginSymbol;
            AddViaPoint(FirstTrkPtNode, WptName, Symbol);
          end;

        end;
      end;
    end;

    //Waypoint not part of route
    procedure ProcessWpt(const WptNode: TXmlVSNode);
    var WptNameNode: TXmlVSNode;
        Name: string;
    begin
      Name := '';
      WptNameNode := WptNode.Find('name');
      if (WptNameNode <> nil) then
        Name := WptNameNode.NodeValue;
      AddWayPoint(WptNode, Name);
    end;

    procedure ProcessGPX(GpxNode: TXmlVSNode; const BaseFile: string);
    var MainNode: TXmlVSNode;
    begin

      for MainNode in GpxNode.ChildNodes do
      begin
        TotalDistance := 0;
        if (MainNode.Name = 'wpt') then
        begin
          ProcessWpt(MainNode);
        end;
        if (MainNode.Name = 'rte') then
        begin
          ProcessRte(MainNode);
        end;
        if (MainNode.Name = 'trk') then
        begin
          ProcessTrk(MainNode);
        end;
      end;
    end;

begin
  try
    Xml.LoadFromFile(GPXFile);
    for GpxNode in xml.ChildNodes do
    begin
      if (GpxNode.Name = 'gpx') then
        ProcessGPX(GpxNode, BaseFile);
    end;
  finally
  { Future use }
  end;
end;

function InitRoot(WptTracksXml: TXmlVSDocument): TXmlVSNode;
begin
  WptTracksXml.Clear;
  WptTracksXml.Encoding := 'utf-8';
  result := WptTracksXml.AddChild('gpx', TXmlVSNodeType.ntDocument);
  result.SetAttribute('xmlns', 'http://www.topografix.com/GPX/1/1');
  result.SetAttribute('xmlns:gpxx',  'http://www.garmin.com/xmlschemas/GpxExtensions/v3');
  result.SetAttribute('xmlns:wptx1', 'http://www.garmin.com/xmlschemas/WaypointExtension/v1');
  result.SetAttribute('xmlns:ctx',   'http://www.garmin.com/xmlschemas/CreationTimeExtension/v1');

  result.SetAttribute('creator', 'TDBWare');
  result.SetAttribute('version', '1.1');
end;

function WayPointNotProcessed(WayPoint: TXmlVSNode): boolean;
var WayPointName: string;
begin
  result := false;
  WayPointName := WayPoint.Find('name').NodeValue;
  if (WayPointsProcessedList.IndexOf(WayPointName) <> -1) then
    exit;
  WayPointsProcessedList.Add(WayPointName);
  result := true;
end;

function GPXWayPoint(CatId, BmpId: integer; WayPoint: TXmlVSNode): TGPXWayPoint;
var ExtensionsNode, AddressNode: TXmlVSNode;
    ProximityStr: TGPXString;
    ProximityFloat: single;

    function GetSpeedFromName(WptName: string): integer;
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

begin
  result := TGPXWayPoint.Create;
  with result do
  begin
    Name        := TGPXString(FindSubNodeValue(WayPoint, 'name'));
    Comment     := TGPXString(FindSubNodeValue(WayPoint, 'cmt'));
    Lat         := TGPXString(WayPoint.AttributeList.Find('lat').Value);
    Lon         := TGPXString(WayPoint.AttributeList.Find('lon').Value);

    Proximity   := 0;
    if (IniProximityStr <> '') then // From INI file
      Proximity := StrToInt(string(IniProximityStr));

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

function GPXBitMap(WayPoint: TXmlVSNode): TGPXBitmap;
begin
  result := TGPXBitmap.Create;
  result.Bitmap := TGPXString(FindSubNodeValue(WayPoint, 'sym'));
end;

function GPXCategory(Category: string): TGPXCategory;
begin
  result := TGPXCategory.Create;
  result.Category := TGPXString(Category);
end;


procedure DoFunction(const AllFuncs: array of TGPXFunc;
                     const GPXFile:string;
                     const OutStringList: TStringList = nil;
                     const SeqNo: cardinal = 0);
var Func: TGPXFunc;
    OutDir: string;
    BaseFile: string;
    RetryCount: integer;

    procedure DoCreateTracks;
    var WptTracksRoot: TXmlVSNode;
        WptTrack: TXmlVSNode;
        Track : TXmlVSNode;
        RouteWayPoints, WayPoint: TXmlVSNode;
        TrackPoint: TXmlVSNode;
        OutFile: string;
        TracksProcessed: TStringList;
    begin
      TracksProcessed := TStringList.Create;
      try
        WptTracksRoot := InitRoot(WptTracksXml);

        if (ProcessWayPts) then
        begin
          for WayPoint in WayPointList do
          begin
            if (WayPointNotProcessed(WayPoint)) then
              CloneNode(WayPoint, WptTracksRoot.AddChild(WayPoint.Name));
          end;
        end;

        if (ProcessWayPtsFromRoute) then
        begin
          for RouteWayPoints in WayPointFromRouteList do
          begin
            for WayPoint in RouteWayPoints.ChildNodes do
            begin
              if (WayPointNotProcessed(WayPoint)) then
                CloneNode(WayPoint, WptTracksRoot.AddChild(WayPoint.Name));
            end;
          end;
        end;

        for Track in TrackList do
        begin
          if (UniqueTracks) then
          begin
            if (TracksProcessed.IndexOf(Track.NodeValue) > -1) then
              continue;
            TracksProcessed.Add(Track.NodeValue);
          end;

          WptTrack := WptTracksRoot.AddChild('trk');
          WptTrack.AddChild('name').NodeValue := Track.NodeValue;
          if (TrackColor <> '') then
            WptTrack.AddChild('extensions').
                     AddChild('gpxx:TrackExtension').
                     AddChild('gpxx:DisplayColor').NodeValue := TrackColor
          else
            CloneSubNodes(Track.Find('extensions').ChildNodes, WptTrack.AddChild('extensions').ChildNodes);
          WptTrack := WptTrack.AddChild('trkseg');
          for TrackPoint in Track.ChildNodes do
          begin
            if (TrackPoint.Name <> 'trkpt') then
              continue;
            CloneAttributes(TrackPoint, WptTrack.AddChild('trkpt'));
          end;
        end;

        OutFile := OutDir +
                   'Tracks_' +
                   BaseFile +
                   ExtractFileExt(GPXFile);
        WptTracksXml.SaveToFile(OutFile);
      finally
        TracksProcessed.Free;
      end;
    end;

    procedure DoCreateRoutePoints;
    var RouteWayPoints, WayPoint: TXmlVSNode;
        WptTracksRoot: TXmlVSNode;
        OutFile: string;

    begin
      for RouteWayPoints in RouteViaPointList do
      begin
        WptTracksXml.Clear;
        WptTracksRoot := InitRoot(WptTracksXml);

        for WayPoint in RouteWayPoints.ChildNodes do
          CloneNode(WayPoint, WptTracksRoot.AddChild(WayPoint.Name));
        OutFile := OutDir +
                   'RoutePoints_' +
                   EscapeFileName(RouteWayPoints.Name) +
                   ExtractFileExt(GPXFile);
        WptTracksXml.SaveToFile(OutFile);
      end;
    end;

    procedure DoCreatePOI;
    var OutFile: string;
        RouteWayPoints, WayPoint: TXmlVSNode;
        GPIFile: TGPI;
        POIGroup: TPOIGroup;
        S: TBufferedFileStream;
        CatId: integer;
        BmpId: integer;
    begin

      OutFile := ChangeFileExt(OutDir + BaseFile, '.gpi');
      S := TBufferedFileStream.Create(OutFile, fmCreate);
      GPIFile := TGPI.Create(GPIVersion);
      GPIFile.WriteHeader(S);
      PoiGroup := GPIFile.CreatePOIGroup(TGPXString(BaseFile));

      if (ProcessShapePtsInGpi) then // Default False
      begin
        for RouteWayPoints in RouteViaPointList do
        begin
          CatId := PoiGroup.AddCat(GPXCategory(RouteWayPoints.NodeValue)); // RouteName

          for WayPoint in RouteWayPoints.ChildNodes do
          begin
            BmpId := PoiGroup.AddBmp(GPXBitMap(WayPoint));
            PoiGroup.AddWpt(GPXWayPoint(CatId, BmpId, WayPoint));
          end;
        end;
      end;

      if (ProcessTracks) then
      begin
        CatId := PoiGroup.AddCat(GPXCategory(BaseFile)); // GPX filename

        if (ProcessWayPtsInGpi) then
        begin
          for WayPoint in WayPointList do
          begin
            if (WayPointNotProcessed(WayPoint)) then
            begin
              BmpId := PoiGroup.AddBmp(GPXBitMap(WayPoint));
              PoiGroup.AddWpt(GPXWayPoint(CatId, BmpId, WayPoint));
            end;
          end;
        end;

        if (ProcessViaPtsInGpi) then
        begin
          for RouteWayPoints in WayPointFromRouteList do
          begin
            for WayPoint in RouteWayPoints.ChildNodes do
            begin
              if (WayPointNotProcessed(WayPoint)) then
              begin
                BmpId := PoiGroup.AddBmp(GPXBitMap(WayPoint));
                PoiGroup.AddWpt(GPXWayPoint(CatId, BmpId, WayPoint));
              end;
            end;
          end;
        end;

        POIGroup.Write(S);
        GPIFile.WriteEnd(S);
        S.Free;
      end;
    end;

    procedure DoCreateKML;
    var OutFile, Lon, Lat, Ele, DisplayColor: string;
        RouteWayPoint, WayPoint: TXmlVSNode;
        WayPointAttribute: TXmlVSAttribute;
        Track : TXmlVSNode;
        Folder: IXMLNode;
        TrackPoint: TXmlVSNode;
        TrackPointAttribute: TXmlVSAttribute;
        TrackExtension: TXmlVSNode;
        Helper: TKMLHelper;
      begin
        OutFile := OutDir + ChangeFileExt(ExtractFileName(GPXFile), '.kml');
        Helper := TKMLHelper.Create(OutFile);
        Helper.FormatSettings := GetLocaleSetting;

        try
          Helper.WriteHeader;

          if (ProcessTracks) then
          begin
            for Track in TrackList do
            begin
              DisplayColor := DefTrackColor;
              if (KMLTrackColor <> '') then
                DisplayColor := KMLTrackColor
              else
              begin
                TrackExtension := Track.Find('extensions');
                if (TrackExtension <> nil) then
                  DisplayColor := GetTrackColor(TrackExtension.Find('gpxx:TrackExtension'));
              end;
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

              if (ProcessViaPts) then
              begin
                for RouteWayPoint in RouteViaPointList do
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
                                       Format('%s%s%s', [RouteWayPoint.NodeValue,
                                                        #10,
                                                        FindSubNodeValue(WayPoint, 'cmt')]));
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

    procedure DoCreateOSM;
    var OutFile, Lon, Lat, Ele, DisplayColor, Cmt: string;
        RouteWayPoint, WayPoint: TXmlVSNode;
        WayPointAttribute: TXmlVSAttribute;
        Track : TXmlVSNode;
        TrackPoint: TXmlVSNode;
        TrackPoints: integer;
        TrackPointAttribute: TXmlVSAttribute;
        Helper: TOSMHelper;
    begin

      if (ProcessTracks) then
      begin
        for Track in TrackList do
        begin
          OutFile := OutDir + ChangeFileExt(EscapeFileName(Track.NodeValue), '.html');
          if (OSMTrackColor <> '') then
            DisplayColor := OSMTrackColor
          else
            DisplayColor := FindSubNodeValue(Track.Find('extensions').
                                                   Find('gpxx:TrackExtension'),
                                             'gpxx:DisplayColor');
          Helper := TOSMHelper.Create(OutFile);
          Helper.FormatSettings := GetLocaleSetting;
          Helper.WriteHeader(DisplayColor);
          Helper.WritePointsStart(Track.NodeValue);
          try
            TrackPoints := 0;
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
              inc(TrackPoints);
              Helper.WritePoint(Lon, Lat, Ele);
            end;
            if (TrackPoints = 0) then // Direct route? Write via points
            begin
              for RouteWayPoint in RouteViaPointList do
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
                  Helper.WritePoint(Lon, Lat, Ele);
                end;
              end;
            end;
            Helper.WritePointsEnd;

            if (ProcessViaPts) then
            begin
              helper.WritePlacesStart;
              for RouteWayPoint in RouteViaPointList do
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
                  Cmt := FindSubNodeValue(WayPoint, 'cmt');
                  if (Pos(#10, Cmt) > 0) then
                    Cmt := Copy(Cmt, 1, Pos(#10, Cmt) -1);
                  Helper.WritePlace( Format('%s,%s ', [lon, lat], Helper.FormatSettings),
                                     FindSubNodeValue(WayPoint, 'name'),
                                     Cmt);
                end;
              end;
              Helper.WritePlacesEnd;
              Helper.WriteFooter;
            end;
          finally
            Helper.Free;
          end;
        end;
      end;
    end;

    procedure DoCreateOSMPoints;
    var Trackname, Lon, Lat, DisplayColor, Symbol, Color: string;
        RouteWayPoint, WayPoint: TXmlVSNode;
        WayPointAttribute: TXmlVSAttribute;
        Track : TXmlVSNode;
        TrackPoint: TXmlVSNode;
        TrackPoints: integer;
        RoutePoints: integer;
        TrackPointAttribute: TXmlVSAttribute;
        AllTracks: TStringList;
    begin
      AllTracks := TStringList.Create;
      FrmSelectGPX := TFrmSelectGPX.Create(nil);
      try
      OutStringList.Clear;

      if (ProcessTracks) then
      begin
        for Track in TrackList do
        begin
          if (Track.Find('extensions') <> nil) then
            DisplayColor := FindSubNodeValue(Track.Find('extensions').
                                             Find('gpxx:TrackExtension'),'gpxx:DisplayColor')
          else
            DisplayColor := 'Blue';
          AllTracks.Add(DisplayColor + #9 + IntToStr(Track.ChildNodes.Count) + #9 + Track.Name);
        end;
        FrmSelectGPX.LoadTracks(AllTracks);
        if FrmSelectGPX.ShowModal <> ID_OK then
            exit;

        RoutePoints := 0;
        for Track in TrackList do
        begin
          Trackname := Track.Name;
          DisplayColor := FrmSelectGPX.TrackSelectedColor(Trackname);
          if (DisplayColor = '') then
            continue;
          TrackPoints := 0;
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
            OutStringList.Add(Format('AddTrkPoint(%d,%s,%s);', [TrackPoints, Lat, Lon]));
            Inc(TrackPoints);
          end;
          OutStringList.Add(Format('CreateTrack("%s", "%s");', [EscapeDQuote(Trackname), OSMColor(DisplayColor)]));

          if (ProcessViaPts) then
          begin
            for RouteWayPoint in RouteViaPointList do
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

                Symbol := FindSubNodeValue(WayPoint, 'sym');
                if (ContainsText(Symbol, 'red')) or
                   (ContainsText(Symbol, 'flag')) then
                  Color := 'red'
                else
                  color := 'blue';
                OutStringList.Add(Format('AddRoutePoint(%d, "%s", %s, %s, "%s");',
                                         [RoutePoints,
                                          EscapeDQuote(FindSubNodeValue(WayPoint, 'name')),
                                          lat,
                                          lon,
                                          Color]));
                Inc(RoutePoints);
              end;
            end;
          end;
        end;
      end;
      finally
        FrmSelectGPX.Free;
        AllTracks.Free;
      end;
    end;

    procedure DoCreatePOLY;
    var RouteWayPoints, WayPoint: TXmlVSNode;
        OutFile: string;
        F: TextFile;
        Coords: TCoord;
    begin
      for RouteWayPoints in RouteViaPointList do
      begin
        OutFile := OutDir +
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

    procedure DoCreateRoutes;
    const GpxNodename = 'gpx';
          WptNodename = 'wpt';
          RteNodename = 'rte';
          RteNameNodeName = 'name';
          RtePtNodename = 'rtept';
          RtePtNameNodeName = 'name';
          SubClassNodename = 'gpxx:Subclass';
          ExtensionsNodename = 'extensions';
          RoutePointExtensionsNodename = 'gpxx:RoutePointExtension';

    var OutFile: string;
        RteNode, GpxNode: TXmlVSNode;
        WptNode: TXmlVSNode;
        WptNodePos: integer;

      procedure ProcessRtePt(const RtePtNode: TXmlVSNode);
      var ExtensionNode: TXmlVSNode;
          RtePtExtensions: TXmlVSNode;
      begin
        RtePtExtensions := RtePtNode.Find(ExtensionsNodename);
        if (RtePtExtensions = nil) then
          exit;
        ExtensionNode := RtePtExtensions.Find(RoutePointExtensionsNodename);
        if (ExtensionNode <> nil) then
          ExtensionNode.ChildNodes.DeleteRange(0, ExtensionNode.ChildNodes.Count);
      end;

      procedure ProcessRte(const RteNode: TXmlVSNode);
      var RtePtNode: TXmlVSNode;
          RtePts: TXmlVSNodeList;
      begin
        RtePts := RteNode.FindNodes(RtePtNodename);
        if (RtePts = nil) then
          exit;
        try
          for RtePtNode in RtePts do
            ProcessRtePt(RtePtNode)
        finally
          RtePts.Free;
        end;
      end;

    begin
      GpxNode := Xml.ChildNodes.find(GpxNodename);  // Look for <gpx> node
      if (GpxNode = nil) or
       (GpxNode.Name <> GpxNodename) then
        exit;

      if (DeleteWayPtsInRoute) then
      begin
        for WptNodePos := GpxNode.ChildNodes.Count -1 downto 0 do
        begin
          WptNode := GpxNode.ChildNodes[WptNodePos];
          if (WptNode.Name = WptNodename) then
            GpxNode.ChildNodes.Delete(WptNodePos);
        end;
      end;

      for RteNode in GpxNode.ChildNodes do
      begin
        if (RteNode.Name = RteNodename) then // Only want <rte> nodes. No <trk> or <wpt>
          ProcessRte(RteNode);
      end;

      OutFile := OutDir +
                 'Routes_' +
                 BaseFile +
                 ExtractFileExt(GPXFile);
      Xml.Encoding := 'utf-8';
      Xml.SaveToFile(OutFile);
    end;

    procedure DoCreateTrips;

    const GpxNodename = 'gpx';
          RteNodename = 'rte';
          RteNameNodeName = 'name';
          RtePtNodename = 'rtept';
          RtePtNameNodeName = 'name';
          SubClassNodename = 'gpxx:Subclass';
          ExtensionsNodename = 'extensions';
          RoutePointExtensionsNodename = 'gpxx:RoutePointExtension';

    var OutFile: string;
        ParentTripId: Cardinal;
        RteNode, GpxNode: TXmlVSNode;

      procedure PrepStream(TmpStream: TMemoryStream; const Buffer: array of Cardinal); overload;
      begin
        TmpStream.Clear;
        TmpStream.Write(Buffer, SizeOf(Buffer));
        TmpStream.Position := 0;
      end;

      procedure PrepStream(TmpStream: TMemoryStream; const Count: Cardinal; const Buffer: array of WORD); overload;
      var
        SwapCount: Cardinal;
      begin
        SwapCount := Swap32(Count);
        TmpStream.Clear;
        TmpStream.Write(SwapCount, SizeOf(SwapCount));
        TmpStream.Write(Buffer, SizeOf(Buffer));
        TmpStream.Position := 0;
      end;

      procedure ProcessTrip(const RteNode: TXmlVSNode; ParentTripId: Cardinal);
      var RtePtNode: TXmlVSNode;
          RtePts: TXmlVSNodeList;
          RtePtExtensions, RtePtViaPoint, RteExtensions, RteTrpPoint: TXmlVSNode;
          DepartureDateString, CalculationMode, TransportMode: string;
          TripName, RtePtName, RtePtDesc: string;
          DepartureDate: TDateTime;
          Coords: TCoord;
          TripList: TTripList;
          Locations: TmLocations;
          ViaPointCount: integer;

          procedure CreateLocations;
          var
            RtePtNode: TXmlVSNode;
            TmpStream : TMemoryStream;
          begin
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

                RtePtDesc := FindSubNodeValue(RtePtNode, 'desc');
                if (RtePtDesc = '') then
                  RtePtDesc := Format('%s, %s', [FormatFloat('##0.00000', Coords.Lat, FormatSettings),
                                                 FormatFloat('##0.00000', Coords.Lon, FormatSettings)]
                                      );
                DepartureDateString := '';
                if (RtePtViaPoint <> nil) then
                  DepartureDateString := FindSubNodeValue(RtePtViaPoint,'trp:DepartureTime');
                // Have all we need.

                // Create Location
                Locations.AddLocatIon(TLocation.Create);

                if (ZumoModel = TZumoModel.XT2) then
                begin
                  PrepStream(TmpStream, [Swap32($00000008), Swap32($00000080), Swap32($00000080)]);
                  Locations.Add(TRawDataItem.Create).InitFromStream('mShapingCenter', TmpStream.Size, $08, TmpStream);
                end;

                if (RtePtViaPoint <> nil) then
                  Locations.Add(TmAttr.Create(TRoutePoint.rpVia))
                else
                  Locations.Add(TmAttr.Create(TRoutePoint.rpShaping));
                Locations.Add(TmIsDFSPoint.Create);
                Locations.Add(TmDuration.Create);

                if (DepartureDateString <> '') and
                  TryISO8601ToDate(DepartureDateString, DepartureDate, false) then
                  Locations.Add(TmArrival.Create(DepartureDate))
                else
                  Locations.Add(TmArrival.Create);

                Locations.Add(TmScPosn.Create(Coords.Lat, Coords.Lon));
                Locations.Add(TmAddress.Create(RtePtDesc));
                Locations.Add(TmisTravelapseDestination.Create);
                Locations.Add(TmShapingRadius.Create);
                Locations.Add(TmName.Create(RtePtName));
              end;
              TripList.Add(Locations);
            finally
              TmpStream.Free;
            end;
          end;

          procedure CreateTrip_XT;
          begin
            TripList.AddHeader(THeader.Create);
            TripList.Add(TmPreserveTrackToRoute.Create);
            TripList.Add(TmParentTripId.Create(ParentTripId));
            TripList.Add(TmDayNumber.Create);
            TripList.Add(TmTripDate.Create);
            TripList.Add(TmIsDisplayable.Create);
            TripList.Add(TmAvoidancesChanged.Create);
            TripList.Add(TmIsRoundTrip.Create);
            TripList.Add(TmParentTripName.Create(BaseFile));
            TripList.Add(TmOptimized.Create);
            TripList.Add(TmTotalTripTime.Create);
            TripList.Add(TmImported.Create);
            TripList.Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode)));
            TripList.Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));
            TripList.Add(TmTotalTripDistance.Create);
            TripList.Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));

            CreateLocations;

            TripList.Add(TmPartOfSplitRoute.Create);
            TripList.Add(TmVersionNumber.Create);

            // Create Dummy AllRoutes, to force recalc on the XT. Just an entry for every Via.
            // Todo add param viapointcount
            TripList.ForceRecalc(ZumoModel);

            TripList.Add(TmTripName.Create(TripName));
          end;

          // Note: Not indented Items need verification
          procedure CreateTrip_XT2;
          var
            TmpStream: TMemoryStream;
            RoutePreferences: array of WORD;
            Index: integer;
          begin
            TmpStream := TMemoryStream.Create;
            try
              TripList.AddHeader(THeader.Create);

              //Note: TRawDataItem used for unknown (XT2) types. Need investigating
            PrepStream(TmpStream, [$0000]);
            Triplist.Add(TRawDataItem.Create).InitFromStream('mGreatRidesInfoMap', TmpStream.Size, $0c, TmpStream);

            Triplist.Add(TCardinalItem.Create('mAvoidancesChangedTimeAtSave', 0));

            PrepStream(TmpStream, [$0000]);
            Triplist.Add(TRawDataItem.Create).InitFromStream('mTrackToRouteInfoMap', TmpStream.Size, $0c, TmpStream);

              TripList.Add(TmIsDisplayable.Create);
              TripList.Add(TBooleanItem.Create('mIsDeviceRoute', true));
              TripList.Add(TmDayNumber.Create);
              TripList.Add(TmTripDate.Create);
              TripList.Add(TmOptimized.Create);
              TripList.Add(TmTotalTripTime.Create);
              TripList.Add(TmTripName.Create(TripName));

            TripList.Add(TStringItem.Create('mVehicleProfileGuid', '00000000-0000-0000-0000-000000000000'));

              TripList.Add(TmParentTripId.Create(ParentTripId));
              TripList.Add(TmIsRoundTrip.Create);

            TripList.Add(TStringItem.Create('mVehicleProfileName', 'z' + #0361 + 'mo Motorcycle'));
              TripList.Add(TmAvoidancesChanged.Create);
              TripList.Add(TmParentTripName.Create(BaseFile));
            TripList.Add(TByteItem.Create('mVehicleProfileTruckType', 7));  // 7 or 0 ?
            TripList.Add(TCardinalItem.Create('mVehicleProfileHash', 0));

            SetLength(RoutePreferences, ViaPointCount -1);
            for Index := 0 to High(RoutePreferences) do
              RoutePreferences[Index] := Swap($0100);
            PrepStream(TmpStream, ViaPointCount -1, RoutePreferences);
            Triplist.Add(TRawDataItem.Create).InitFromStream('mRoutePreferences', TmpStream.Size, $80, TmpStream);

              TripList.Add(TmImported.Create);
              TripList.Add(TmFileName.Create(Format('0:/.System/Trips/%s.trip', [TripName])));
              TripList.Add(TStringItem.Create('mExploreUuid', '00000000-0000-0000-0000-000000000000'));
              TripList.Add(TmVersionNumber.Create(4, $10));

            TmpStream.Position := 0;
            Triplist.Add(TRawDataItem.Create).InitFromStream('mRoutePreferencesAdventurousHillsAndCurves', TmpStream.Size, $80, TmpStream);
              TripList.Add(TmTotalTripDistance.Create);
            TripList.Add(TByteItem.Create('mVehicleId', 1)); // ?
            TmpStream.Position := 0;
            Triplist.Add(TRawDataItem.Create).InitFromStream('mRoutePreferencesAdventurousScenicRoads', TmpStream.Size, $80, TmpStream);

              // Create Dummy AllRoutes, to force recalc on the XT2. Just an entry for every Via.
              TripList.ForceRecalc(ZumoModel, ViaPointCount);
            TmpStream.Position := 0;
            Triplist.Add(TRawDataItem.Create).InitFromStream('mRoutePreferencesAdventurousPopularPaths', TmpStream.Size, $80, TmpStream);
              TripList.Add(TmPartOfSplitRoute.Create);
              TripList.Add(TmRoutePreference.Create(TmRoutePreference.RoutePreference(CalculationMode)));
              TripList.Add(TBooleanItem.Create('mShowLastStopAsShapingPoint', false));

            TmpStream.Position := 0;
            Triplist.Add(TRawDataItem.Create).InitFromStream('mRoutePreferencesAdventurousMode', TmpStream.Size, $80, TmpStream);

              TripList.Add(TmTransportationMode.Create(TmTransportationMode.TransPortMethod(TransportMode)));

              CreateLocations;

            finally
              TmpStream.Free;
            end;
          end;

      begin
        RtePts := RteNode.FindNodes(RtePtNodename);
        if (RtePts = nil) then
          exit;

        TripList := TTripList.Create;
        try
          TripName := FindSubNodeValue(RteNode, 'name');
          OutFile := OutDir + EscapeFileName(TripName) + '.trip';

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
          ViaPointCount := 0;
          for RtePtNode in RtePts do
          begin
            RtePtExtensions := RtePtNode.Find('extensions');
            if (RtePtExtensions = nil) then
              continue;
            RtePtViaPoint := RtePtExtensions.Find('trp:ViaPoint');
            if (RtePtViaPoint <> nil) then
            begin
              Inc(ViaPointCount);
              if (CalculationMode = '') then
                CalculationMode := FindSubNodeValue(RtePtViaPoint,'trp:CalculationMode');
            end;
          end;

          case ZumoModel of
            TZumoModel.XT:
              CreateTrip_XT;
            TZumoModel.XT2:
              CreateTrip_XT2;
            else
              CreateTrip_XT; // Unknown model, default to XT
          end;

          // Write to File
          TripList.SaveToFile(OutFile);
        finally
          RtePts.Free;
          TripList.Free;
        end;
      end;

    begin
      GpxNode := Xml.ChildNodes.find(GpxNodename);  // Look for <gpx> node
      if (GpxNode = nil) or
       (GpxNode.Name <> GpxNodename) then
        exit;
      ParentTripId := TmArrival.DateTimeAsCardinal(Now) + SeqNo;
      for RteNode in GpxNode.ChildNodes do
      begin
        if (RteNode.Name = RteNodename) then // Only want <rte> nodes. No <trk> or <wpt>
          ProcessTrip(RteNode, ParentTripId);
      end;
    end;

begin

  CreateGlobals;

  BaseFile := ChangeFileExt(ExtractFileName(GPXFile), '');
  if (ForceOutDir <> '') then
    OutDir := ForceOutDir
  else
  begin
    OutDir := IncludeTrailingPathDelimiter(ExtractFilePath(GPXFile));
    if (CreateSubDir) then
      OutDir := IncludeTrailingPathDelimiter(OutDir + BaseFile);
  end;

  for Func in AllFuncs  do
  begin
    case Func of
      CreateTracks,
      CreateRoutePoints,
      CreatePOI,
      CreateKML,
      CreateOSM,
      CreatePOLY,
      CreateRoutes,
      CreateTrips:
        begin
          if not Assigned(OutStringList) then
            ForceDirectories(OutDir);
          break;
        end;
    end;
  end;

  try
    RetryCount := 0;
    while (RetryCount <= MaxTries) do
    begin
      try
        ProcessGPX(GPXFile, BaseFile);

        for Func in AllFuncs  do
        begin
          WayPointsProcessedList.Clear;
          case Func of
            Unglitch:
              begin
                Xml.Encoding := 'utf-8';
                Xml.SaveToFile(GPXFile);
              end;
            CreateTracks:
              begin
                DoCreateTracks;
              end;
            CreateRoutePoints:
              begin
                DoCreateRoutePoints;
              end;
            CreatePOI:
              begin
                DoCreatePOI;
              end;
            CreateKML:
              begin
                DoCreateKML;
              end;
            CreateOSM:
              begin
                DoCreateOSM;
              end;
            CreateOSMPoints:
              begin
                DoCreateOSMPoints;
              end;
            CreatePOLY:
              begin
                DoCreatePOLY;
              end;
          end;
        end;

        // Process always last, removes a lot of nodes.
        for Func in AllFuncs  do
        begin
          case Func of
            TGPXFunc.CreateRoutes:
              begin
                DoCreateRoutes;
              end;
            TGPXFunc.CreateTrips:
              begin
                DoCreateTrips;
              end;
          end;
        end;

        RetryCount := MaxInt;

      except
        on E:Exception do
        begin
          Inc(RetryCount);
          if (RetryCount > MaxTries) then
            raise;
          ShowBalloon(Format('%s. %sRetrying %d...',[E.Message, #10, RetryCount]), true);
          Sleep(TimeOut);
        end;
      end;

    end;

    ShowBalloon(Format('All Done %s.',[GPXFile]));

  finally
    if (EnableTimeout) then
      Sleep(TimeOut);
    FreeGlobals;
  end;
end;

procedure Usage;
begin
  AllocConsole;
  writeln('Usage: ', Paramstr(0), ' GPX_file' );
  Readln;
  Halt(1);
end;

procedure ShowBalloon(const Hint: string; const Force: boolean = false);
begin
  if not Force and
     not EnableBalloon then
    exit;
  TrayIcon.Visible := true;
  TrayIcon.BalloonHint := Hint;
  TrayIcon.ShowBalloonHint;
  TrayIcon.BalloonTimeout := TimeOut;
end;

initialization
begin
  FormatSettings := GetLocaleSetting;
  TrayIcon := TTrayIcon.Create(nil);
end;

finalization
begin
  TrayIcon.Free;
end;

end.

