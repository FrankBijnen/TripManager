unit UnitGpxTripCompare;
// Compare Trip with GPX

interface

uses
  System.Classes, System.SysUtils,
  UnitVerySimpleXml,
  UnitGpxDefs, UnitGpxObjects, UnitTripObjects;

type
  TGPXTripCompare = class(TGPXFile)
  private
    FDistOKMeters: double;
    FAllRoutes: TmAllRoutes;
    FUdbHandle: TmUdbDataHndl;
    FUdbDir: TUdbDir;
    FRtePt: TXmlVSNode;
    FCheckSegmentOK: boolean;
    FCheckRouteOK: boolean;
    function DisplayMapSegRoad(const MapSegRoad: string): string;
    function GetRouteNode(const RouteName: string): TXmlVSNode;
    function GetRtePtFromRoute(const Messages: TStrings;
                               const RouteSelected: TXmlVSNode): TXmlVSNode;
    function PrepareTripForCompare(const Messages, OutTrackList: TStrings;
                                   var UdbHandleCount: integer;
                                   var UdbDirCount: integer): TXmlVSNode;
    function ScanForTrkPt(const FromCoords: TCoord;
                          const ScanFromTrkPt: TXmlVSNode;
                          const ScanToTrkPt: TXmlVSNode;
                          var BestScanTrkPt: TXmlVSNode): double;
    // (BC) Route Checks
    procedure NoMatchRoutePoints(const Messages: TStrings);
    procedure NoMatchRoutePoint(const Messages: TStrings;
                                CoordTrip, CoordGpx: TCoord; ThisDist: double);
    procedure NoMatchRoutePointEnd(const Messages: TStrings; CoordTrip: TCoord);
    procedure NoGpxxRpt(const Messages: TStrings);
    procedure NoMatchUdbDirSubClass(const Messages: TStrings;
                                    CoordTrip: TCoord;
                                    BestRpt: TXmlVSNode;
                                    BestDist: double);
    // Track Checks
    procedure NoMatchRoutePointTrk(const Messages: TStrings;
                                   CoordTrip: TCoord; BestToTrkpt: TXmlVSNode; ThisDist: double);
    procedure NoMatchUdbDirTrk(const Messages: TStrings;
                               CoordTrip: TCoord; BestTrkpt: TXmlVSNode; BestDist: Double);
  public
    constructor Create(const AGPXFile: string; ATripList: TTripList);
    destructor Destroy; override;
    procedure CompareGpxRoute(const Messages, OutTrackList: TStrings);
    procedure CompareGpxTrack(const Messages, OutTrackList: TStrings);
  end;

implementation

uses
  System.Math,
  UnitStringUtils;

var
  FormatSettings: TFormatSettings;

constructor TGPXTripCompare.Create(const AGPXFile: string; ATripList: TTripList);
begin
  inherited Create(AGPXFile, nil, nil); // Default processOptions are OK

  FDistOKMeters := ProcessOptions.GetDistOKMeters;
  FAllRoutes := TmAllRoutes(ATripList.GetItem('mAllRoutes'));
end;

destructor TGPXTripCompare.Destroy;
begin
  inherited Destroy;
end;

function TGPXTripCompare.DisplayMapSegRoad(const MapSegRoad: string): string;
begin
  result := MapSegRoad;
  Insert(' ' ,result, 9);
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
      if (AnUdbDir.UdbDirValue.SubClass.PointType = 3) then
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
      if (LocAnUdbDir.UdbDirValue.SubClass.PointType = 3) then
      begin
        Messages.Add('');
        Messages.AddObject(Format('  .trip file: UdbHandle: %d Route point: %d %s',
                                  [LocUdbHandleCount, LocUdbDirCount, LocAnUdbDir.DisplayName]), LocAnUdbDir);
        if (LocScanRtePt <> nil) then
        begin
          Messages.AddObject(Format('  .gpx file: %s',
                                    [FindSubNodeValue(LocScanRtePt, 'name') ]), LocAnUdbDir);
          LocScanRtePt := LocScanRtePt.NextSibling;
        end
        else
          Messages.AddObject(Format('  .gpx file: %s', ['Not found']), LocAnUdbDir);
        Inc(LocUdbDirCount);
      end;
    end;
    Inc(LocUdbHandleCount);
  end;

  while (LocScanRtePt <> nil) do
  begin
    Messages.Add('');
    Messages.Add(Format('  .trip file: %s', ['Not found']));
    Messages.Add(Format('   .gpx file: %s', [FindSubNodeValue(LocScanRtePt, 'name') ]));
    LocScanRtePt := LocScanRtePt.NextSibling;
  end;
end;

procedure TGPXTripCompare.NoMatchRoutePoint(const Messages: TStrings;
                                            CoordTrip, CoordGpx: TCoord; ThisDist: double);
var
  BestLat, BestLon: string;
  CTripLat, CTripLon: string;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;
  FUdbDir.Status := TUdbDirStatus.udsRoutePointNotFound;

  CoordTrip.FormatLatLon(CTripLat, CTripLon);
  CoordGpx.FormatLatLon(BestLat, BestLon);

  Messages.Add('');
  Messages.AddObject(Format('  Route point: %s check failed.', [FUdbDir.DisplayName]), FUdbDir);
  Messages.AddObject(Format('     .trip file: Lat:%s Lon:%s', [CTripLat, CTripLon]), FUdbDir);
  Messages.AddObject(Format('     .gpx file: Lat:%s Lon:%s. Distance: %1.0f Mtr', [BestLat, BestLon, ThisDist * 1000]), FUdbDir);
end;

procedure TGPXTripCompare.NoMatchRoutePointEnd(const Messages: TStrings; CoordTrip: TCoord);
var
  CTripLat, CTripLon: string;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;
  FUdbDir.Status := TUdbDirStatus.udsCoordsNotFound;

  CoordTrip.FormatLatLon(CTripLat, CTripLon);

  Messages.Add('');
  Messages.AddObject(Format('  No matching RtePt found for: %s MapSeg + Road:%s, Lat:%s, Lon:%s',
                            [FUdbDir.DisplayName,
                             DisplayMapSegRoad(FUdbDir.MapSegRoad),
                             CTripLat, CTripLon]), FUdbDir);
end;

procedure TGPXTripCompare.NoGpxxRpt(const Messages: TStrings);
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;

  Messages.Add('No <gpxx:rpt> in GPX file. Non BaseCamp origin?');
end;

procedure TGPXTripCompare.NoMatchUdbDirSubClass(const Messages: TStrings;
                                                CoordTrip: TCoord;
                                                BestRpt: TXmlVSNode;
                                                BestDist: double);
var
  CheckFail: string;
  CTripLat, CTripLon: string;
  CoordGpx: TCoord;
  BestLat, BestLon: string;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;

  case FUdbDir.Status of
    TUdbDirStatus.udsRoadNotFound:
      CheckFail := 'Road';
    TUdbDirStatus.udsCoordsNotFound:
      CheckFail := 'Coordinates';
    else
      CheckFail := 'General';
  end;

  CoordTrip.FormatLatLon(CTripLat, CTripLon);

  CoordGpx := CoordFromAttribute(BestRpt.AttributeList);
  CoordGpx.FormatLatLon(BestLat, BestLon);

  Messages.Add('');
  Messages.AddObject(Format('  %s: %s check failed', [CheckFail, FUdbDir.DisplayName]), FUdbDir);
  Messages.AddObject(Format('     .trip file: MapSeg + Road: %s, Lat: %s, Lon: %s',
                            [DisplayMapSegRoad(FUdbDir.MapSegRoad), CTripLat, CTripLon]), FUdbDir);
  Messages.AddObject(Format('      .gpx file: MapSeg + Road: %s, Lat: %s, Lon: %s, Distance: %1.0f Mtr',
                            [DisplayMapSegRoad(Copy(FindSubNodeValue(BestRpt,'gpxx:Subclass'), 5, 16)),
                             BestLat, BestLon, BestDist * 1000]), FUdbDir);
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

procedure TGPXTripCompare.CompareGpxRoute(const Messages, OutTrackList: TStrings);
var
  RtePtCount, UdbHandleCount, AnUdbHandleCnt, UdbDirCount, AnUdbDirCnt, LastUdbDirCnt: integer;
  RouteSelected, ScanRtePt, BestRpt: TXmlVSNode;
  ExtensionsNode, RoutePointExtensionNode, GpxxRptNode: TXmlVSNode;
  CoordTrip, CoordGpx: TCoord;
  CTMapSegRoad: string;
  ThisDist, MinDist: double;
  StartSegmentLine: integer;
  SubClassList: TStringList;
begin
  Messages.Clear;

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

  RtePtCount := 0;
  ScanRtePt := FRtePt;
  while (ScanRtePt <> nil) do
  begin
    if (ScanRtePt.Name = 'rtept') then
      Inc(RtePtCount);
    ScanRtePt := ScanRtePt.NextSibling;
  end;

  if (UdbDirCount - (UdbHandleCount -1) <> RtePtCount) then
  begin
    NoMatchRoutePoints(Messages);
    exit;
  end;

  SubClassList := TStringList.Create;
  SubClassList.Sorted := true;
  SubClassList.Duplicates := TDuplicates.dupIgnore;
  try
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
        CTMapSegRoad := FUdbDir.MapSegRoad;
        CoordTrip.Lat := FUdbDir.Lat;
        CoordTrip.Lon := FUdbDir.Lon;

        if (FUdbDir.UdbDirValue.SubClass.PointType = 3) then
        begin

          if (StartSegmentLine > -1) then
          begin
            Messages[StartSegmentLine] := Messages[StartSegmentLine] + ' => ' + FUdbDir.DisplayName;
            if (FCheckSegmentOK = false) then
              Messages[StartSegmentLine] := Messages[StartSegmentLine] + ' NOT OK';
          end;

          FCheckSegmentOK := true;
          Messages.Add('');
          StartSegmentLine := Messages.AddObject(Format('Checking Segment: %s', [FUdbDir.DisplayName]), FUdbDir);
          CoordGpx := CoordFromAttribute(FRtePt.AttributeList);
          ThisDist := CoordDistance(CoordTrip, CoordGpx, TDistanceUnit.duKm);

          if (ThisDist > FDistOKMeters) or
             (FUdbDir.DisplayName <> FindSubNodeValue(FRtePt, 'name')) then
            NoMatchRoutePoint(Messages, CoordTrip, CoordGpx, ThisDist);

          // Init GpxxRptNode
          GpxxRptNode := nil;
          RoutePointExtensionNode := nil;
          ExtensionsNode := FRtePt.Find('extensions');
          if (ExtensionsNode <> nil) then
            RoutePointExtensionNode := ExtensionsNode.Find('gpxx:RoutePointExtension');
          if (RoutePointExtensionNode <> nil) then
            GpxxRptNode := RoutePointExtensionNode.Find('gpxx:rpt');

          // Build list of SubClasses
          SubClassList.Clear;
          ScanRtePt := GpxxRptNode;
          while (ScanRtePt <> nil) do
          begin
            if (ScanRtePt.Name = 'gpxx:rpt') then
              SubClassList.Add(Copy(FindSubNodeValue(ScanRtePt,'gpxx:Subclass'), 5, 16));
            ScanRtePt := ScanRtePt.NextSibling;
          end;

          // Point to next segment
          if (FUdbDir <> FUdbHandle.Items[FUdbHandle.Items.Count -1]) then
            FRtePt := FRtePt.NextSibling;
          continue;
      	end;

        if (GpxxRptNode = nil) then
        begin
          NoGpxxRpt(Messages);
          break;
        end;

        MinDist := MaxDouble;
        ScanRtePt := GpxxRptNode;
        BestRpt := nil;
        while (ScanRtePt <> nil) do
        begin
          if (ScanRtePt.Name = 'gpxx:rpt') and
             (FindSubNodeValue(ScanRtePt, 'gpxx:Subclass') <> '') then
          begin
            CoordGpx := CoordFromAttribute(ScanRtePt.AttributeList);
            ThisDist := CoordDistance(CoordTrip, CoordGpx, TDistanceUnit.duKm);
            if (ThisDist < MinDist) then
            begin
              MinDist := ThisDist;
              BestRpt := ScanRtePt;
            end;
          end;
          ScanRtePt := ScanRtePt.NextSibling;
        end;

        // A valid trip file will never get here. That always ends with a type=3 Udbdir
        if (BestRpt = nil) then
        begin
          NoMatchRoutePointEnd(Messages, CoordTrip);
          continue;
        end;

        // Point to next GpxxRptNode
        GpxxRptNode := BestRpt;

        // Error?
        if (FUdbDir.UdbDirValue.SubClass.PointType <> $21) and // Dont care for RoadId for Start/begin segment.
           (SubClassList.IndexOf(CTMapSegRoad) < 0) then
          FUdbDir.Status := TUdbDirStatus.udsRoadNotFound
        else if (MinDist > FDistOKMeters) then
          FUdbDir.Status := TUdbDirStatus.udsCoordsNotFound
        else
          continue;

        NoMatchUdbDirSubClass(Messages, CoordTrip, BestRpt, MinDist);
      end;
    end;

    if (FCheckRouteOK = false) then
      Messages[0] := Messages[0] + ' NOT OK';

  finally
    SubClassList.Free;
  end;
end;

// Scan for a track point that best matches the coordinates of a route point.
// ScanFromTrkPt ScanToTrkPt limit the range in the track.
// Returns the BestScanTrkPt and the Coordinate distance
function TGPXTripCompare.ScanForTrkPt(const FromCoords: TCoord;
                                      const ScanFromTrkPt: TXmlVSNode;
                                      const ScanToTrkPt: TXmlVSNode;
                                      var BestScanTrkPt: TXmlVSNode): double;
var
  ScanTrkPt: TXmlVSNode;
  ScanCoords: TCoord;
  ScanDist: Double;
begin
  result := MaxDouble;
  BestScanTrkPt := ScanToTrkPt;

  ScanTrkPt := ScanFromTrkPt;
  while (ScanTrkPt <> nil) do     // TrkPt loop
  begin
    ScanCoords := CoordFromAttribute(ScanTrkPt.AttributeList);
    ScanDist := CoordDistance(FromCoords, ScanCoords, TDistanceUnit.duKm);
    if (ScanDist < result) then
    begin
      result := ScanDist;
      BestScanTrkPt := ScanTrkPt;
    end;

    if (ScanTrkPt = ScanToTrkPt) then
      exit;

    ScanTrkPt := ScanTrkPt.NextSibling;
  end;
end;

procedure TGPXTripCompare.NoMatchRoutePointTrk(const Messages: TStrings;
                                               CoordTrip: TCoord; BestToTrkpt: TXmlVSNode; ThisDist: double);
var
  CoordGpx: TCoord;
  BestLat, BestLon: string;
  TripLat, TripLon: string;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;
  FUdbDir.Status := TUdbDirStatus.udsRoutePointNotFound;

  CoordGpx := CoordFromAttribute(BestToTrkpt.AttributeList);
  CoordGpx.FormatLatLon(BestLat, BestLon);
  CoordTrip.FormatLatLon(TripLat, TripLon);

  Messages.Add('');
  Messages.AddObject(Format('  Route point: %s check failed.',
                            [FUdbDir.DisplayName]), FUdbDir);
  Messages.AddObject(Format('    .trip file: Lat: %s Lon: %s',
                            [TripLat, TripLon]), FUdbDir);
  Messages.AddObject(Format('     .gpx file: Lat: %s Lon: %s, Distance: %1.0f Mtr',
                            [BestLat, BestLon, ThisDist * 1000]), FUdbDir);
end;

procedure TGPXTripCompare.NoMatchUdbDirTrk(const Messages: TStrings;
                                           CoordTrip: TCoord; BestTrkpt: TXmlVSNode; BestDist: Double);
var
  CoordGpx: TCoord;
  BestLat, BestLon: string;
  TripLat, TripLon: string;
begin
  FCheckSegmentOK := false;
  FCheckRouteOK := false;
  FUdbDir.Status := TUdbDirStatus.udsCoordsNotFound;

  CoordTrip.FormatLatLon(TripLat, TripLon);
  CoordGpx := CoordFromAttribute(BestTrkpt.AttributeList);
  CoordGpx.FormatLatLon(BestLat, BestLon);

  Messages.Add('');
  Messages.AddObject(Format('  Coordinates: %s check failed.',
                            [FUdbDir.DisplayName]), FUdbDir);
  Messages.AddObject(Format('    .trip file: Lat: %s, Lon: %s MapSeg + Road: %s, ',
                            [TripLat, TripLon, DisplayMapSegRoad(FUdbDir.MapSegRoad)]), FUdbDir);
  Messages.AddObject(Format('     .gpx file: Lat: %s, Lon: %s, Distance: %1.0f Mtr',
                            [BestLat, BestLon, BestDist * 1000]), FUdbDir);
end;

procedure TGPXTripCompare.CompareGpxTrack(const Messages, OutTrackList: TStrings);

var
  AnUdbHandle, ToUdbHandle: TmUdbDataHndl;
  ToUdbDir: TUdbDir;

  BestTrkPt,  // Best matching <trkpt>
  NextTrkPt,  // Current <trkpt> Pointer
  LastTrkPt,  // Last <trkpt> in track
  ToTrkPt,    // Limit scan to <trkpt>
  BestToTrkPt: TXmlVSNode;

  TrackSelected: TXmlVSNode;
  ToCoordTrip, CoordTrip: TCoord;
  ThisDist: double;
  TripLat, TripLon: string;
  UdbHandleCount, UdbDirCount, StartSegmentLine,
  AnUdbHandleCnt, ToUdbHandleCnt, AnUdbDirCnt, FromUdbDirCnt, ToUdbDirCnt, LastUdbDirCnt: integer;
begin
  Messages.Clear;

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

      if (FUdbDir.UdbDirValue.SubClass.PointType = 3) then
      begin

        if (StartSegmentLine > -1) then
        begin
          Messages[StartSegmentLine] := Messages[StartSegmentLine] + ' => ' + FUdbDir.DisplayName;
          if (FCheckSegmentOK = false) then
            Messages[StartSegmentLine] := Messages[StartSegmentLine] + ' NOT OK';
        end;

        FCheckSegmentOK := true;
        Messages.Add('');
        StartSegmentLine := Messages.AddObject(Format('Checking Segment: %s', [FUdbDir.DisplayName]), FUdbDir);

        ThisDist := ScanForTrkPt(CoordTrip, NextTrkPt, ToTrkPt, BestToTrkpt);

        // report route point error
        if (ThisDist > FDistOKMeters) then
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
            if (ToUdbDir.UdbDirValue.SubClass.PointType = 3) then
              break;
          end;
          Inc(ToUdbHandleCnt);
        end;

        if (ToUdbDir <> nil) then
        begin
          ToCoordTrip.Lat := ToUdbDir.Lat;
          ToCoordTrip.Lon := ToUdbDir.Lon;
          if (ScanForTrkPt(ToCoordTrip, NextTrkPt, ToTrkPt, BestToTrkpt) < FDistOKMeters) then
            ToTrkPt := BestToTrkPt;
        end;

        continue;
      end;

      // Get minimum distance of this route point in track
      ThisDist := ScanForTrkPt(CoordTrip, NextTrkPt, ToTrkPt, BestTrkpt);

      if (ThisDist > FDistOKMeters) then
        NoMatchUdbDirTrk(Messages, CoordTrip, BestTrkPt, ThisDist)       // Report coords error.
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