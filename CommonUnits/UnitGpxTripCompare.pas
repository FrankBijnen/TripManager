unit UnitGpxTripCompare;
// Compare Trip with GPX

interface

uses
  System.Classes, System.SysUtils,
  UnitVerySimpleXml,
  UnitGpxDefs, UnitGpxObjects, UnitTripDefs, UnitTripObjects;

type
  TGPXTripCompare = class(TGPXFile)
  private
    FDistOKKms: double;
    FMinShapeDistKms: double;
    FAllRoutes: TmAllRoutes;
    FUdbHandle: TmUdbDataHndl;
    FUdbDir: TUdbDir;
    FRtePt: TXmlVSNode;
    FCheckSegmentOK: boolean;
    FCheckRouteOK: boolean;
    FGpxRptList: Tlist;
    function AddGpxRptPt(const FromNode: TXmlVSNode;
                         const ANodeValue: string): TXmlVSNode;
    function GetRouteNode(const RouteName: string): TXmlVSNode;
    function GetPrevSubClass(const GpxxRptNode: TXmlVSNode): string;

    function ScanSubClass(const AMapSegRoad: string;
                          const ACoordTrip: TCoords;
                          var GpxSubClass: string;
                          var MinDist: double): TXmlVSNode;
    function ScanGpxxRptNode(const GpxxRptNode: TXmlVSNode;
                             const ACoordTrip: TCoords;
                             var GpxSubClass: string;
                             var MinDist: double): TXmlVSNode;
    function GetBestGpxRpt(const BestRpt: TXmlVSNode;
                           const BestSubClass: string;
                           const CoordTrip: TCoords): TXmlVSNode;

    function GetRtePtFromRoute(const Messages: TStrings;
                               const RouteSelected: TXmlVSNode): TXmlVSNode;
    function PrepareTripForCompare(const Messages, OutTrackList: TStrings;
                                   var UdbHandleCount: integer;
                                   var UdbDirCount: integer): TXmlVSNode;
    function GetBestTrkRpt(const BestTrkpt: TXmlVSNode; const BestDist: double;
                           const PropTrkpt: TXmlVSNode = nil; const PropDist: double = 0): TXmlVSNode;
    function ScanForTrkPt(const FromCoords: TCoords;
                          const ScanFromTrkPt: TXmlVSNode;
                          const ScanToTrkPt: TXmlVSNode;
                          var BestScanTrkPt: TXmlVSNode): double; overload;
    function ScanForTrkPt(const FromCoords: TCoords;
                          const ScanFromTrkPt: TXmlVSNode;
                          const ScanToTrkPt: TXmlVSNode;
                          var BestScanTrkPt: TXmlVSNode;
                          var WorstScanTrkpt: TXmlVSNode): double; overload;
    // (BC) Route Checks
    procedure NoMatchRoutePoints(const Messages: TStrings);
    procedure NoMatchRoutePoint(const Messages: TStrings;
                                CoordTrip: TCoords;
                                BestRpt: TXmlVSNode;
                                ThisDist: double);
    procedure NoMatchRoutePointEnd(const Messages: TStrings; CoordTrip: TCoords);
    procedure NoGpxxRpt(const Messages: TStrings);
    procedure NoMatchUdbDirSubClass(const Messages: TStrings;
                                    const CoordTrip: TCoords;
                                    const BestRpt: TXmlVSNode;
                                    const BestSubClass: string);
    // Track Checks
    procedure NoMatchRoutePointTrk(const Messages: TStrings;
                                   CoordTrip: TCoords; BestToTrkpt: TXmlVSNode; ThisDist: double);
    function NoMatchUdbDirTrk(const Messages: TStrings;
                              CoordTrip: TCoords;
                              BestTrkpt, PropTrkpt: TXmlVSNode): TXmlVSNode;
  public
    constructor Create(const AGPXFile: string; ATripList: TTripList; AGpxRptList: Tlist);
    destructor Destroy; override;
    procedure CompareGpxRoute(const Messages, OutTrackList: TStrings);
    procedure CompareGpxTrack(const Messages, OutTrackList: TStrings);
  end;

const
  TripFile  = '.trip file';
  GpxFile   = '.gpx file';
  CheckSeg  = 'Checking Segment';

implementation

uses
  System.Math,
  UnitStringUtils;

var
  FormatSettings: TFormatSettings;

procedure BreakPoint;
{$IFDEF DEBUG}
asm int 3
  {$ELSE}
begin
{$ENDIF}
end;

constructor TGPXTripCompare.Create(const AGPXFile: string; ATripList: TTripList; AGpxRptList: Tlist);
begin
  inherited Create(AGPXFile, nil, nil); // Default processOptions are OK

  FDistOKKms := ProcessOptions.GetDistOKKms;
  FMinShapeDistKms := ProcessOptions.GetMinShapeDistKms;
  FAllRoutes := TmAllRoutes(ATripList.GetItem('mAllRoutes'));
  FGpxRptList := AGpxRptList;
end;

destructor TGPXTripCompare.Destroy;
begin
  inherited Destroy;
end;

// Adds an XML node containing lat/lan values and a nodevalue to the objects of Messages.
// The reason is that the 'FromNode' will be freed after the compare,
// but is needed to reposition the map from the ShowLog Form.
// These objects will be freed  in TFrmShowLog.ClearGpxRptList.
function TGPXTripCompare.AddGpxRptPt(const FromNode: TXmlVSNode;
                                     const ANodeValue: string): TXmlVSNode;
begin
  result := TXmlVSNode.Create;
  FGpxRptList.Add(result);
  CloneNode(FromNode, result);
  result.NodeValue := ANodeValue;
end;

//Gets the (BC) <rte> from the XMLDocument
function TGPXTripCompare.GetRouteNode(const RouteName: string): TXmlVSNode;
var
  GpxNode: TXmlVSNode;
  RouteTrackNode: TXmlVSNode;
begin
  result := nil;
  for GpxNode in XmlDocument.ChildNodes do
  begin
    if (GpxNode.Name <> 'gpx') then
      continue;

    for RouteTrackNode in GpxNode.ChildNodes do
    begin
      if (RouteTrackNode.Name = 'rte') and
         (FindSubNodeValue(RouteTrackNode, 'name') = RouteName) then
        exit(RouteTrackNode);
    end;
  end;
end;

function TGPXTripCompare.PrepareTripForCompare(const Messages, OutTrackList: TStrings;
                                               var UdbHandleCount: integer;
                                               var UdbDirCount: integer): TXmlVSNode;
var
  TrackId: integer;
  TrackRouteSelected: TXmlVSNode;
  AnUdbHandle: TmUdbDataHndl;
  AnUdbDir: TUdbDir;
begin
  result := nil;

  // Some checks
  if (FAllRoutes = nil) then
  begin
    Messages.Add('Can not find mAllRoutes in trip.');
    exit;
  end;

  UdbDirCount := 0;
  UdbHandleCount := 0;
  for AnUdbHandle in FAllRoutes.Items do
  begin
    for AnUdbDir in AnUdbHandle.Items do
    begin
      AnUdbDir.Status := udsUnchecked;
      if (AnUdbDir.UdbDirValue.SubClass.IsKnownRoutePoint) then
        Inc(UdbDirCount);
    end;
    Inc(UdbHandleCount);
  end;

  if (UdbDirCount = 0) then
  begin
    Messages.Add('Trip does not appear to be calculated.');
    exit;
  end;

  // Show track to compare with on map, and return name
  TrackId := 0;
  for TrackRouteSelected in TrackList do
  begin
    if (FrmSelectGPX.TrackSelectedColor(TrackRouteSelected.Name,
                                        FindSubNodeValue(TrackRouteSelected, 'desc')) = '') then
      continue;
    Track2OSMTrackPoints(TrackRouteSelected, TrackId, TStringList(OutTrackList));
    exit(TrackRouteSelected);
  end;

end;

procedure TGPXTripCompare.NoMatchRoutePoints(const Messages: TStrings);
var
  LocAnUdbHandle: TmUdbDataHndl;
  LocAnUdbDir: TUdbDir;
  LocUdbHandleCount, LocUdbDirCount: integer;
  LocScanRtePt: TXmlVSNode;
  MsgScanRtePt: TXmlVSNode;
begin
  Messages.Add('Number of route points does not match in trip and gpx route.' + #13#10 +
               'Try "By Point Location (Track or Route)"');

  LocScanRtePt := FRtePt;
  LocUdbHandleCount := 1;
  for LocAnUdbHandle in FAllRoutes.Items do
  begin
    LocUdbDirCount := 1;
    for LocAnUdbDir in LocAnUdbHandle.Items do
    begin
      if (LocAnUdbDir.UdbDirValue.SubClass.IsKnownRoutePoint) then
      begin
        Messages.Add('');
        Messages.AddObject(Format('  %s: UdbHandle: %d Route point: %d %s',
                                  [TripFile, LocUdbHandleCount, LocUdbDirCount, LocAnUdbDir.DisplayName]), LocAnUdbDir);
        if (LocScanRtePt <> nil) then
        begin
          MsgScanRtePt := AddGpxRptPt(LocScanRtePt, FindSubNodeValue(LocScanRtePt, 'name'));
          Messages.AddObject(Format('  %s: %s',
                                    [GpxFile, MsgScanRtePt.NodeValue]), MsgScanRtePt);
          LocScanRtePt := LocScanRtePt.NextSibling;
        end
        else
          Messages.Add(Format('  %s: %s', [GpxFile, 'Not found']));
        Inc(LocUdbDirCount);
      end;
    end;
    Inc(LocUdbHandleCount);
  end;

  while (LocScanRtePt <> nil) do
  begin
    MsgScanRtePt := AddGpxRptPt(LocScanRtePt, FindSubNodeValue(LocScanRtePt, 'name'));

    Messages.Add('');
    Messages.Add      (Format('  %s: %s',  [TripFile, 'Not found']));
    Messages.AddObject(Format('   %s: %s', [GpxFile, MsgScanRtePt.NodeValue]), MsgScanRtePt);
    LocScanRtePt := LocScanRtePt.NextSibling;
  end;
end;

procedure TGPXTripCompare.NoMatchRoutePoint(const Messages: TStrings;
                                            CoordTrip: TCoords;
                                            BestRpt: TXmlVSNode;
                                            ThisDist: double);
var
  BestLat, BestLon: string;
  CTripLat, CTripLon: string;
  CoordGpx: TCoords;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;
  FUdbDir.Status := TUdbDirStatus.udsRoutePointNOK;

  CoordTrip.FormatLatLon(CTripLat, CTripLon);
  CoordGpx.FromAttributes(BestRpt.AttributeList);
  CoordGpx.FormatLatLon(BestLat, BestLon);

  Messages.Add('');
  Messages.AddObject(Format('  Route point NOT OK', []), FUdbDir);
  Messages.AddObject(Format('    %s: Lat: %s Lon: %s, Name: %s', [TripFile, CTripLat, CTripLon, FUdbDir.DisplayName]), FUdbDir);
  Messages.AddObject(Format('     %s: Lat: %s Lon: %s, Name: %s, Distance: %1.0f Mtr',
                            [GpxFile, BestLat, BestLon, FindSubNodeValue(FRtePt, 'name'), ThisDist * 1000]), FUdbDir);
end;

procedure TGPXTripCompare.NoMatchRoutePointEnd(const Messages: TStrings; CoordTrip: TCoords);
var
  CTripLat, CTripLon: string;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;
  FUdbDir.Status := TUdbDirStatus.udsCoordsNOK;

  CoordTrip.FormatLatLon(CTripLat, CTripLon);

  Messages.Add('');
  Messages.AddObject(Format('  No matching RtePt found for: %s MapSeg + Road:%s, Lat:%s, Lon:%s',
                            [FUdbDir.DisplayName,
                             FUdbDir.MapSegRoadDisplay,
                             CTripLat, CTripLon]), FUdbDir);
end;

procedure TGPXTripCompare.NoGpxxRpt(const Messages: TStrings);
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;

  Messages.Add('No <gpxx:rpt> in GPX file. Non BaseCamp origin?');
end;

function TGPXTripCompare.GetBestGpxRpt(const BestRpt: TXmlVSNode;
                                       const BestSubClass: string;
                                       const CoordTrip: TCoords): TXmlVSNode;
var
  CoordGpx, NextCoordGpx: TCoords;
  BestLat, BestLon: string;
  NextBestRpt: TXmlVSNode;
  BestDist: double;
begin
  // Get next best gpxrpt point. To avoid center of junction
  NextBestRpt := BestRpt;
  CoordGpx.FromAttributes(NextBestRpt.AttributeList);
  NextCoordGpx := CoordGpx;
  while (NextBestRpt.NextSibling <> nil) and
        (CoordGpx.Lat = NextCoordGpx.Lat) and
        (CoordGpx.Lon = NextCoordGpx.Lon) do
  begin
    NextBestRpt := NextBestRpt.NextSibling;
    NextCoordGpx.FromAttributes(NextBestRpt.AttributeList);
  end;
  NextCoordGpx.FormatLatLon(BestLat, BestLon);
  BestDist := CoordDistance(CoordTrip, NextCoordGpx, TDistanceUnit.duKm);
  //
  result := AddGpxRptPt(NextBestRpt, Format('      %s: MapSeg + Road: %s, Lat: %s, Lon: %s, Distance: %1.0f Mtr',
                                        [GpxFile, BestSubClass,
                                         BestLat, BestLon, BestDist * 1000]));
end;

procedure TGPXTripCompare.NoMatchUdbDirSubClass(const Messages: TStrings;
                                                const CoordTrip: TCoords;
                                                const BestRpt: TXmlVSNode;
                                                const BestSubClass: string);
var
  CheckFail: string;
  CTripLat, CTripLon: string;
  MsgGpxRpt: TXmlVSNode;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;

  case FUdbDir.Status of
    TUdbDirStatus.udsRoadNOK:
      CheckFail := 'Road NOT OK';
    TUdbDirStatus.UdsRoadOKCoordsNOK:
      CheckFail := 'Road OK, Coordinates NOT OK';
    TUdbDirStatus.udsCoordsNOK:
      CheckFail := 'Coordinates NOT OK';
    else
      CheckFail := 'General';
  end;

  CoordTrip.FormatLatLon(CTripLat, CTripLon);
  MsgGpxRpt := GetBestGpxRpt(BestRpt, BestSubClass, CoordTrip);

  Messages.Add('');
  Messages.AddObject(Format('  %s: %s', [CheckFail, FUdbDir.DisplayName]), FUdbDir);
  Messages.AddObject(Format('     %s: MapSeg + Road: %s, Lat: %s, Lon: %s',
                            [TripFile, FUdbDir.MapSegRoadDisplay, CTripLat, CTripLon]), FUdbDir);
  Messages.AddObject(MsgGpxRpt.NodeValue, MsgGpxRpt);
end;

// RouteSelected only is the track created from the <gpxx:rpt> of the <rte>
// Get the original <rte> from the document. We need the SubClass.
function TGPXTripCompare.GetRtePtFromRoute(const Messages: TStrings;
                                           const RouteSelected: TXmlVSNode): TXmlVSNode;
begin
  result := GetRouteNode(RouteSelected.NodeName);
  if (result = nil) then // Should not happen
  begin
    Messages.Add('No <rte> in GPX.');
    exit(nil);
  end;

  result := result.Find('rtept');
  if (result = nil) then
  begin
    Messages.Add('No <rtept> in GPX.');
    exit;
  end;
end;

// Get the SubClass of a GpxxRptNode. If not avail scan back
function TGPXTripCompare.GetPrevSubClass(const GpxxRptNode: TXmlVSNode): string;
var
  ScanRtePt: TXmlVSNode;
begin
  result := '';
  ScanRtePt := GpxxRptNode;
  while (ScanRtePt <> nil) and
        (ScanRtePt.Find('gpxx:Subclass') = nil) do
    ScanRtePt := ScanRtePt.PreviousSibling;

  if (ScanRtePt <> nil) and
     (ScanRtePt.Find('gpxx:Subclass') <> nil) then
  begin
    result := FindSubNodeValue(ScanRtePt, 'gpxx:Subclass');
    result := Format('%s %s', [Copy(result, 5, 8), Copy(result, 13, 8)]);
  end;
end;

// Scan for best matching Subclass
function TGPXTripCompare.ScanSubClass(const AMapSegRoad: string;
                                      const ACoordTrip: TCoords;
                                      var GpxSubClass: string;
                                      var MinDist: double): TXmlVSNode;
var
  SubClassIdx: integer;
  ScanRtePt: TXmlVSNode;
  CoordGpx: TCoords;
  ThisDist: double;
begin
  result := nil;
  GpxSubClass := '';
  MinDist := MaxDouble;

  for SubClassIdx := 0 to SubClassList.Count -1 do
  begin
    if (SubClassList[SubClassIdx] = AMapSegRoad) then
    begin
      ScanRtePt := TXmlVSNode(SubClassList.Objects[SubClassIdx]);
      while (ScanRtePt <> nil) do
      begin
        CoordGpx.FromAttributes(ScanRtePt.AttributeList);
        ThisDist := CoordDistance(ACoordTrip, CoordGpx, TDistanceUnit.duKm);
        if (ThisDist < MinDist) then
        begin
          GpxSubClass := GetPrevSubClass(ScanRtePt);
          MinDist := ThisDist;
          result := ScanRtePt;
        end;
        ScanRtePt := ScanRtePt.NextSibling;

        // Only scan until next subclass
        if (ScanRtePt = nil) or
           ((ScanRtePt.Name = 'gpxx:rpt') and
            (FindSubNodeValue(ScanRtePt, 'gpxx:Subclass') <> '')) then
          break;
      end;
    end;
  end;
end;

// Scan for best matching <gpxx:rpt>
function TGPXTripCompare.ScanGpxxRptNode(const GpxxRptNode: TXmlVSNode;
                                         const ACoordTrip: TCoords;
                                         var GpxSubClass: string;
                                         var MinDist: double): TXmlVSNode;
var
  ScanRtePt: TXmlVSNode;
  CoordGpx: TCoords;
  ThisDist: double;
begin
  result := nil;
  GpxSubClass := '';
  MinDist := MaxDouble;

  ScanRtePt := GpxxRptNode;
  while (ScanRtePt <> nil) do
  begin
    CoordGpx.FromAttributes(ScanRtePt.AttributeList);
    ThisDist := CoordDistance(ACoordTrip, CoordGpx, TDistanceUnit.duKm);
    if (ThisDist < MinDist) then
    begin
      GpxSubClass := GetPrevSubClass(ScanRtePt);
      MinDist := ThisDist;
      result := ScanRtePt;
    end;

    ScanRtePt := ScanRtePt.NextSibling;
  end;
end;

procedure TGPXTripCompare.CompareGpxRoute(const Messages, OutTrackList: TStrings);
var
  RtePtCount, UdbHandleCount, AnUdbHandleCnt, UdbDirCount, AnUdbDirCnt, LastUdbDirCnt: integer;
  RouteSelected, ScanRtePt, BestRpt: TXmlVSNode;
  GpxxRptNode: TXmlVSNode;
  CoordTrip, CoordGpx: TCoords;
  CTMapSegRoad, BestSubClass: string;
  ThisDist, MinDist: double;
  StartSegmentLine: integer;
  SubClassOK: boolean;
begin
  RouteSelected := PrepareTripForCompare(Messages, OutTrackList, UdbHandleCount, UdbDirCount);
  if (RouteSelected = nil) then
  begin
    Messages.Add('No Route selected.');
    exit;
  end;

  Messages.Add(Format('Checking: %s', [RouteSelected.NodeName]));

  FRtePt := GetRtePtFromRoute(Messages, RouteSelected);
  if (FRtePt = nil) then
  begin
    Messages.Add('No <rtept> in GPX.');
    exit;
  end;

  // Count <rtept> in GPX
  try
    RtePtCount := 0;
    ScanRtePt := FRtePt;
    while (ScanRtePt <> nil) do
    begin
      if (ScanRtePt.Name = 'rtept') then
        Inc(RtePtCount);
      ScanRtePt := ScanRtePt.NextSibling;
    end;

    // Need an exact match, to compare by segment
    if (UdbDirCount - (UdbHandleCount -1) <> RtePtCount) then
      NoMatchRoutePoints(Messages);

    FCheckSegmentOK := true;
    FCheckRouteOK := true;
    StartSegmentLine := -1;

    for AnUdbHandleCnt := 0 to FAllRoutes.Items.Count -1 do
    begin
      FUdbHandle := FAllRoutes.Items[AnUdbHandleCnt];
      GpxxRptNode := nil;

      // Dont check last UdbDir from UdbHandle. Except last UdbHandle
      LastUdbDirCnt := FUdbHandle.Items.Count -1;
      if (AnUdbHandleCnt < FAllRoutes.Items.Count -1) then
        Dec(LastUdbDirCnt);

      for AnUdbDirCnt := 0 to LastUdbDirCnt do
      begin
        FUdbDir := FUdbHandle.Items[AnUdbDirCnt];

        if (FUdbDir.UdbDirValue.SubClass.IsKnownStartEndSegment) then
          continue;

        CTMapSegRoad := FUdbDir.MapSegRoadExclBit;
        CoordTrip.Lat := FUdbDir.Lat;
        CoordTrip.Lon := FUdbDir.Lon;

        if (FUdbDir.UdbDirValue.SubClass.IsKnownRoutePoint) then
        begin

          if (StartSegmentLine > -1) then
          begin
            Messages[StartSegmentLine] := Messages[StartSegmentLine] + ' => ' + FUdbDir.DisplayName;
            if (FCheckSegmentOK = false) then
              Messages[StartSegmentLine] := Messages[StartSegmentLine] + ' NOT OK';
          end;

          FCheckSegmentOK := true;
          Messages.Add('');
          StartSegmentLine := Messages.AddObject(Format('%s: %s', [CheckSeg, FUdbDir.DisplayName]), FUdbDir);
          CoordGpx.FromAttributes(FRtePt.AttributeList);
          ThisDist := CoordDistance(CoordTrip, CoordGpx, TDistanceUnit.duKm);

          if (ThisDist > FDistOKKms) or
             (FUdbDir.DisplayName <> FindSubNodeValue(FRtePt, 'name')) then
            NoMatchRoutePoint(Messages, CoordTrip, FRtePt, ThisDist);

          // Init GpxxRptNode
          GpxxRptNode := GetFirstExtensionsNode(FRtePt);

          // Build known subclasses for this <rtept>
          BuildSubClasses(FRtePt, FDistOKKms, [scCompare]);

          // Point to next segment
          if (FUdbDir <> FUdbHandle.Items[FUdbHandle.Items.Count -1]) then
            FRtePt := FRtePt.NextSibling;

          // More UdbDirs than <RtePt> ?
          if (FRtePt = nil) then
            break
          else
            continue;
      	end;

        if (GpxxRptNode = nil) then
        begin
          NoGpxxRpt(Messages);
          break;
        end;

        // Scan for best matching Subclass
        BestRpt := ScanSubClass(CTMapSegRoad, CoordTrip, BestSubClass, MinDist);
        SubClassOK := (BestRpt <> nil);

        // Scan for best matching <gpxx:rpt>
        if not (SubClassOK) then
          BestRpt := ScanGpxxRptNode(GpxxRptNode, CoordTrip, BestSubClass, MinDist);

        // A valid trip file/gpx File will never get here.
        if (BestRpt = nil) then
        begin
          NoMatchRoutePointEnd(Messages, CoordTrip);
          continue;
        end;

        // Point to next GpxxRptNode
        GpxxRptNode := BestRpt;

        // Any errors?
        if (SubClassOK) and
           (MinDist > FDistOKKms) then
        begin
          FUdbDir.Status := UdsRoadOKCoordsNOK;
          NoMatchUdbDirSubClass(Messages, CoordTrip, BestRpt, BestSubClass);
          continue;
        end;

        if not (SubClassOK) then
        begin
          FUdbDir.Status := TUdbDirStatus.udsRoadNOK;
          NoMatchUdbDirSubClass(Messages, CoordTrip, BestRpt, BestSubClass);
          continue;
        end;

        if (MinDist > FDistOKKms) then
        begin
          FUdbDir.Status := TUdbDirStatus.udsCoordsNOK;
          NoMatchUdbDirSubClass(Messages, CoordTrip, BestRpt, BestSubClass);
          continue;
        end;

      end;
    end;

    if (FCheckRouteOK = false) then
      Messages[0] := Messages[0] + ' NOT OK';

  finally
// Reserved future use
  end;
end;

// Scan for a track point that best matches the coordinates of a route point.
// ScanFromTrkPt ScanToTrkPt limit the range in the track.
// Returns the BestScanTrkPt and the Coordinate distance
function TGPXTripCompare.ScanForTrkPt(const FromCoords: TCoords;
                                      const ScanFromTrkPt: TXmlVSNode;
                                      const ScanToTrkPt: TXmlVSNode;
                                      var BestScanTrkPt: TXmlVSNode): double;
var
  ScanTrkPt: TXmlVSNode;
  ScanCoords: TCoords;
  ScanDist: Double;
begin
  result := MaxDouble;
  BestScanTrkPt := ScanToTrkPt;
  ScanTrkPt := ScanFromTrkPt;
  while (ScanTrkPt <> nil) do     // TrkPt loop
  begin
    if (ScanTrkPt.Name = 'trkpt') then
    begin
      ScanCoords.FromAttributes(ScanTrkPt.AttributeList);
      ScanDist := CoordDistance(FromCoords, ScanCoords, TDistanceUnit.duKm);
      if (ScanDist < result) then
      begin
        result := ScanDist;
        BestScanTrkPt := ScanTrkPt;
      end;

      if (ScanTrkPt = ScanToTrkPt) then
        break;
    end;
    ScanTrkPt := ScanTrkPt.NextSibling;
  end;
end;

// Also scan backwards to find the worst trkpt. To use as proposal
function TGPXTripCompare.ScanForTrkPt(const FromCoords: TCoords;
                                      const ScanFromTrkPt: TXmlVSNode;
                                      const ScanToTrkPt: TXmlVSNode;
                                      var BestScanTrkPt: TXmlVSNode;
                                      var WorstScanTrkpt: TXmlVSNode): double;
var
  ScanTrkPt: TXmlVSNode;
  ScanCoords: TCoords;
  ScanDist, WorstScanDist: Double;
begin
  result := ScanForTrkPt(FromCoords, ScanFromTrkPt, ScanToTrkPt, BestScanTrkPt);
  WorstScanTrkpt := BestScanTrkPt;

  if (result < FDistOKKms) then
        exit;

  WorstScanDist := 0;
  ScanTrkPt := BestScanTrkPt;
  while (ScanTrkPt <> nil) do     // TrkPt loop
  begin
    if (ScanTrkPt.Name = 'trkpt') then
    begin
      ScanCoords.FromAttributes(ScanTrkPt.AttributeList);
      ScanDist := CoordDistance(FromCoords, ScanCoords, TDistanceUnit.duKm);
      if (ScanDist > WorstScanDist) then
      begin
        WorstScanDist := ScanDist;
        WorstScanTrkpt := ScanTrkPt;
    end;
    end;
    if (ScanTrkPt = ScanFromTrkPt) then
      break;
    ScanTrkPt := ScanTrkPt.PreviousSibling;
  end;
end;

function TGPXTripCompare.GetBestTrkRpt(const BestTrkpt: TXmlVSNode; const BestDist: double;
                                       const PropTrkpt: TXmlVSNode = nil; const PropDist: double = 0): TXmlVSNode;
var
  CoordGpx: TCoords;
  BestLat, BestLon, PropLat, PropLon: string;
begin
  CoordGpx.FromAttributes(BestTrkpt.AttributeList);
  CoordGpx.FormatLatLon(BestLat, BestLon);
  if (PropTrkpt <> nil) and
     (BestTrkpt <> PropTrkpt) then
  begin
    CoordGpx.FromAttributes(PropTrkpt.AttributeList);
    CoordGpx.FormatLatLon(PropLat, PropLon);

    result := AddGpxRptPt(PropTrkpt, Format('     %s: Lat: %s, Lon: %s, Distance: %1.0f Mtr. Proposal: Lat: %s, Lon: %s, Distance: %1.0f ',
                                             [GpxFile, BestLat, BestLon, BestDist * 1000,
                                                       PropLat, PropLon, PropDist * 1000]));
  end
  else
    result := AddGpxRptPt(BestTrkpt, Format('     %s: Lat: %s, Lon: %s, Distance: %1.0f Mtr',
                                        [GpxFile, BestLat, BestLon, BestDist * 1000]));
end;

procedure TGPXTripCompare.NoMatchRoutePointTrk(const Messages: TStrings;
                                               CoordTrip: TCoords; BestToTrkpt: TXmlVSNode; ThisDist: double);
var
  TripLat, TripLon: string;
  MsgTrkPt: TXmlVSNode;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;
  FUdbDir.Status := TUdbDirStatus.udsRoutePointNOK;

  CoordTrip.FormatLatLon(TripLat, TripLon);
  MsgTrkPt := GetBestTrkRpt(BestToTrkpt, ThisDist);

  Messages.Add('');
  Messages.AddObject(Format('  Route point NOT OK: %s',
                            [FUdbDir.DisplayName]), FUdbDir);
  Messages.AddObject(Format('    %s: Lat: %s Lon: %s',
                            [TripFile, TripLat, TripLon]), FUdbDir);
  Messages.AddObject(MsgTrkPt.NodeValue, MsgTrkPt);
end;

function TGPXTripCompare.NoMatchUdbDirTrk(const Messages: TStrings;
                                          CoordTrip: TCoords;
                                          BestTrkpt, PropTrkpt: TXmlVSNode): TXmlVSNode;
var
  BestCoords, PropCoords, NextPropCoords: TCoords;
  TripLat, TripLon: string;
  MsgTrkPt: TXmlVSNode;
  BestDist, PropDist: double;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;
  FUdbDir.Status := TUdbDirStatus.udsCoordsNOK;
  CoordTrip.FormatLatLon(TripLat, TripLon);

  BestCoords.FromAttributes(BestTrkpt.AttributeList);
  BestDist := CoordDistance(CoordTrip, BestCoords, TDistanceUnit.duKm);

  // Make sure to advance. But not past BestTrkpt
  result := PropTrkpt;
  PropCoords.FromAttributes(PropTrkpt.AttributeList);
  NextPropCoords := PropCoords;
  while (result <> nil) and
        (result <> BestTrkpt) and
        (result.NextSibling <> nil) do
  begin
    NextPropCoords.FromAttributes(result.AttributeList);
    if (CoordDistance(NextPropCoords, PropCoords, TDistanceUnit.duKm) > FDistOKKms) then
      break;
    result := result.NextSibling;
  end;

  PropDist := CoordDistance(NextPropCoords, CoordTrip, TDistanceUnit.duKm);
  MsgTrkPt := GetBestTrkRpt(BestTrkpt, BestDist, PropTrkpt, PropDist);
  Messages.Add('');
  Messages.AddObject(Format('  Coordinates NOT OK: %s',
                            [FUdbDir.DisplayName]), FUdbDir);
  Messages.AddObject(Format('    %s: Lat: %s, Lon: %s, MapSeg + Road: %s, ',
                            [TripFile, TripLat, TripLon, FUdbDir.MapSegRoadDisplay]), FUdbDir);
  Messages.AddObject(MsgTrkPt.NodeValue, MsgTrkPt);

end;

procedure TGPXTripCompare.CompareGpxTrack(const Messages, OutTrackList: TStrings);

var
  AnUdbHandle, ToUdbHandle: TmUdbDataHndl;
  ToUdbDir: TUdbDir;

  BestTrkPt,  // Best matching <trkpt>
  PropTrkpt,  // Proposed matching <trkpt>
  NextTrkPt,  // Current <trkpt> Pointer
  LastTrkPt,  // Last <trkpt> in track
  ToTrkPt,    // Limit scan to <trkpt>
  BestToTrkPt: TXmlVSNode;

  TrackSelected: TXmlVSNode;
  ToCoordTrip, CoordTrip: TCoords;
  ThisDist: double;
  TripLat, TripLon: string;
  UdbHandleCount, UdbDirCount, StartSegmentLine,
  AnUdbHandleCnt, ToUdbHandleCnt, AnUdbDirCnt, FromUdbDirCnt, ToUdbDirCnt, LastUdbDirCnt: integer;
begin
  TrackSelected := PrepareTripForCompare(Messages, OutTrackList, UdbHandleCount, UdbDirCount);
  if (TrackSelected = nil) then
  begin
    Messages.Add('No Track selected.');
    exit;
  end;

  Messages.Add(Format('Checking: %s', [TrackSelected.NodeName]));

  NextTrkPt := TrackSelected.Find('trkpt');
  if (NextTrkPt = nil) then
  begin
    Messages.Add('No <trkpt> in GPX.');
    exit;
  end;

  // Init Error status
  FCheckSegmentOK := true;
  FCheckRouteOK := true;
  StartSegmentLine := -1;

  for AnUdbHandleCnt := 0 to FAllRoutes.Items.Count -1 do
  begin
    AnUdbHandle := FAllRoutes.Items[AnUdbHandleCnt];

    // Search limits
    LastTrkPt := TrackSelected.LastChild;
    ToTrkPt := LastTrkPt;
    BestToTrkPt := LastTrkPt;

    // Dont check last UdbDir from UdbHandle. Except last UdbHandle
    LastUdbDirCnt := AnUdbHandle.Items.Count -1;
    if (AnUdbHandleCnt < FAllRoutes.Items.Count -1) then
      Dec(LastUdbDirCnt);

    for AnUdbDirCnt := 0 to LastUdbDirCnt do
    begin
      FUdbDir := AnUdbHandle.Items[AnUdbDirCnt];
      CoordTrip.Lat := FUdbDir.Lat;
      CoordTrip.Lon := FUdbDir.Lon;
      TripLat := Format(LatLonFormat, [CoordTrip.Lat], FormatSettings);
      TripLon := Format(LatLonFormat, [CoordTrip.Lon], FormatSettings);

      if (FUdbDir.UdbDirValue.SubClass.IsKnownRoutePoint) then
      begin

        if (StartSegmentLine > -1) then
        begin
          Messages[StartSegmentLine] := Messages[StartSegmentLine] + ' => ' + FUdbDir.DisplayName;
          if (FCheckSegmentOK = false) then
            Messages[StartSegmentLine] := Messages[StartSegmentLine] + ' NOT OK';
        end;

        FCheckSegmentOK := true;
        Messages.Add('');
        StartSegmentLine := Messages.AddObject(Format('%s: %s', [CheckSeg, FUdbDir.DisplayName]), FUdbDir);

        ThisDist := ScanForTrkPt(CoordTrip, NextTrkPt, ToTrkPt, BestToTrkpt);

        // report route point error
        if (ThisDist > FDistOKKms) then
          NoMatchRoutePointTrk(Messages, CoordTrip, BestToTrkpt, ThisDist);

        // Scan for trkpt of next routepoint.
        // Use ToTrkSeg, ToTrkPt to limit the search in the track
        ToTrkPt := LastTrkPt;

        // Scan for next RoutePoint UdbDir
        ToUdbDir := nil;
        ToUdbHandleCnt := AnUdbHandleCnt;
        while (ToUdbHandleCnt < FAllRoutes.Items.Count) and
              (ToUdbDir = nil) do
        begin
          ToUdbHandle := FAllRoutes.Items[ToUdbHandleCnt];
          if (ToUdbHandleCnt = AnUdbHandleCnt) then
            FromUdbDirCnt := AnUdbDirCnt +1
          else
            FromUdbDirCnt := 0;
          for ToUdbDirCnt := FromUdbDirCnt to ToUdbHandle.Items.Count -1 do
          begin
            ToUdbDir := ToUdbHandle.Items[ToUdbDirCnt];
            if (ToUdbDir.UdbDirValue.SubClass.IsKnownRoutePoint) then
              break;
          end;
          Inc(ToUdbHandleCnt);
        end;

        if (ToUdbDir <> nil) then
        begin
          ToCoordTrip.Lat := ToUdbDir.Lat;
          ToCoordTrip.Lon := ToUdbDir.Lon;
          if (ScanForTrkPt(ToCoordTrip, NextTrkPt, ToTrkPt, BestToTrkpt) < FDistOKKms) then
            ToTrkPt := BestToTrkPt;
        end;

        continue;
      end;

      // Get minimum distance of this route point in track
      ThisDist := ScanForTrkPt(CoordTrip, NextTrkPt, ToTrkPt, BestTrkpt, PropTrkpt);

      if (ThisDist > FDistOKKms) then
        NextTrkPt := NoMatchUdbDirTrk(Messages, CoordTrip, BestTrkpt, PropTrkpt) // Report coords error.
      else
        NextTrkPt := BestTrkPt;
    end;
  end;

  if (FCheckRouteOK = false) then
    Messages[0] := Messages[0] + ' NOT OK';
end;

initialization
begin
  FormatSettings := GetLocaleSetting;
end;

end.