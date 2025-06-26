unit UnitProcessOptions;

interface

uses
  System.Classes,
  Winapi.Windows,
  Vcl.ComCtrls,
  UnitGpxDefs, UnitTripObjects, UnitGpi;

//TODO Deprecated
const
  TripFilesFor    = 'Trip files (No import required, but will recalculate. Selected model: %s)';

type
  TProcessOptions = class
    LookUpWindow: HWND;                       // 0, Window handle
                                              // Used to send progress messages when looking up addresses
    LookUpMessage: UINT;                      // 0, Message Id
                                              // Used to send progress messages when looking up addresses

    ProcessSubClass: boolean;                 // True, Allow clearing the subclass,
                                              // Used in: PostProcess, CreateRoutes
    ProcessFlags: boolean;                    // True, Allow to change the symbol
                                              // Used in: PostProcess, CreateRoutes
    ProcessBegin: boolean;                    // True, Allow RenameNode(BeginStr),
                                              //       ClearSubClass(ProcessSubClass),
                                              //       Change Symbol(ProcessFlags),
                                              //       Lookup Address(ProcessAddrBegin),
      ProcessAddrBegin: boolean;              // False
      BeginStr: string;                       // Begin
                                              // Also used as category
      BeginSymbol: string;                    // Flag, Red
                                              // Also used as category

    ProcessEnd: boolean;                      // True, Allow RenameNode(EndStr),
                                              //       ClearSubClass(ProcessSubClass),
                                              //       Change Symbol(ProcessFlags),
                                              //       Lookup Address(ProcessAddrEnd)
      ProcessAddrEnd: boolean;                // False
      EndStr: string;                         // End
                                              // Also used as category
      EndSymbol: string;                      // Flag, Blue
                                              // Also used as category

    ProcessShape: boolean;                    // True, Allow Unglitch,
                                              //       ClearSubClass(ProcessSubClass)
                                              //       Change Symbol(ProcessFlags),
                                              //       RenameNode(ShapingPointName),
                                              //       Lookup Address(ProcessAddrShape)
      DefShapePtSymbol: string;               // Waypoint ==> https://www.javawa.nl/bc_waypointsymbool.html.
                                              // Used in: Unglitch
      ProcessAddrShape: boolean;              // False
      ShapingPointName: TShapingPointName;    // Route_Distance, Rename Shaping points automatically
      DefShapingPointSymbol: string;          // Navaid, Blue,
                                              // Only used if there is no custom symbol defined
                                              // Used in: CreateRoutes, and CreateWayPoints
      ShapingPointCategory: string;           // Shape
                                              // Used in: CreateWayPoints, CreatePOI

    ProcessVia: boolean;                      // True, Allow ClearSubClass(ProcessSubClass),
                                              //       Lookup Address(ProcessAddrVia)
     ProcessAddrVia: boolean;                 // False
      DefViaPointSymbol: string;              // Navaid, Red
                                              // Only used if there is no custom symbol defined
                                              // Used in: CreateRoutes, and CreateWayPoints
      ViaPointCategory: string;               // Via
                                              // Used in: CreateWayPoints, CreatePOI
    ProcessCreateRoutePoints: boolean;        // True, Allow adding routepoints to FRouteViaPointList
                                              // Used in: CreateOSM(Points), CreateKml, CreatePoly. Exposed public

    ProcessTracks: boolean;                   // True, Retain tracks, Create tracks from ghost points in routes.

    ProcessWayPtsFromRoute: boolean;          // True, Allow adding routepoints to FWayPointFromRouteList for creating WayPoints
                                              // Used in: CreateWayPoints, CreatePOI
    ProcessWayPtsInWayPts: boolean;           // True, Add original Way points to WayPoints_<Gpx_name>.gpx
                                              // Categories are taken from original Way point
    ProcessViaPtsInWayPts: boolean;           // False, Add Via points to WayPoints_<Route_name>.gpx
                                              // Categories 'Symbol:<Begin, End, Via>' and 'Route:<Route_name>'
    ProcessShapePtsInWayPts: boolean;         // False, Add Shaping points to WayPoints_<Route_name>.gpx
                                              // Categories 'Symbol:<Via>' and 'Route:<Route_name>'

                                              // The POIGroup name will be <Gpx_name>.
                                              // The XT will use that as the main category in Custom POI's.
    ProcessWayPtsInGpi: boolean;              // True, Add original Way points to <Gpx_name>.gpi
                                              // Category 'Symbol:<symbol>' from original Way point
    ProcessViaPtsInGpi: boolean;              // True, Add Via points to <Gpx_name>.gpi
                                              // Category 'Route:<Route_name>
    ProcessShapePtsInGpi: boolean;            // False, Add Shaping points to <Gpx_name>.gpi
                                              // Category 'Route:<Route_name>
    DefaultProximityStr: string;              // 500, Default proximity for alerts (meters)
    GPISymbolsDir: UTF8String;                // Symbols\24x24\ Sets the size of the GPI Symbols

    ProcessDistance: boolean;                 // True, Compute distance. Added in KML, and name of shaping points
    DistanceUnit: TDistanceUnit;              // duKm, Kilometers.

    ProcessCategory: set of TProcessCategory; // [pcSymbol, pcGPX], Add Categories to WayPoints
    ProcessAddrWayPt: boolean;                // False
    DefTrackColor: string;                    // Blue, Used if no Displaycolor found in <trk>
    TrackColor: string;                       // '', The Track color possible changed by user. Saved in Registry

    DefWaypointSymbol: string;                // Flag, Green, Default symbol for Via and Shaping points in GPX
    CatSymbol: string;                        // Symbol:, used in created Waypoints/GPI
    CatGPX: string;                           // GPX:, used in created Waypoints/GPI from Original Way points
    CatRoute: string;                         // ROUTE:, used in created Waypoints/GPI from Via/Shaping points

    {$IFDEF TRIPOBJECTS}
    ZumoModel: TZumoModel;                    // XT1
    ExploreUuid: string;                      // Defaults for XT2
    VehicleProfileGuid: string;               // Defaults for XT2
    VehicleProfileHash: string;               // Defaults for XT2
    VehicleId: string;                        // Defaults for XT2
    {$ENDIF}

    FOnSetFuncPrefs: TNotifyEvent;
    FOnSavePrefs: TNotifyEvent;

    constructor Create(OnSetFuncPrefs: TNotifyEvent = nil; OnSavePrefs: TNotifyEvent = nil);
    destructor Destroy; override;
    procedure DoPrefSaved;
    procedure SetProcessCategory(ProcessWpt: boolean; WayPtCat: string);
    function DistanceStr: string;
{$IFDEF REGISTRY}
    class procedure SetPrefs(TvSelections: TTreeview);
    class function StorePrefs(TvSelections: TTreeview): TGPXFuncArray;
{$ENDIF}
  end;

var
  OnSetFixedPrefs: TNotifyEvent;

const
  IdTrip          = 0;
  IdTrack         = 1;
  IdCompleteRoute = 2; // Only Transfer
  IdStrippedRoute = 3;
  IdWayPoint      = 4;
    IdWayPointWpt = 5;
    IdWayPointVia = 6;
    IdWayPointShp = 7;
  IdGpi           = 8;
    IdGpiWayPt    = 9;
    IdGpiViaPt    = 10;
    IdGpiShpPt    = 11;
  IdKml           = 12; // Only Additional
  IdHtml          = 13; // Only Additional

implementation

uses
  System.SysUtils,
{$IFDEF REGISTRY}
  UnitRegistry,
{$ENDIF}
  UnitStringUtils;

constructor TProcessOptions.Create(OnSetFuncPrefs: TNotifyEvent = nil; OnSavePrefs: TNotifyEvent = nil);
begin
  inherited Create;
  FOnSetFuncPrefs := OnSetFuncPrefs;
  FOnSavePrefs := OnSavePrefs;

  ProcessSubClass := true;
  ProcessFlags := true;

  ProcessBegin := true;
    ProcessAddrBegin := false;
    BeginStr := 'Begin';
    BeginSymbol := 'Flag, Red';

  ProcessEnd := true;
    ProcessAddrEnd := false;
    EndStr := 'End';
    EndSymbol := 'Flag, Blue';

  ProcessShape := true;
    ProcessAddrShape := false;
    ShapingPointName := TShapingPointName.Route_Distance;
    DefShapingPointSymbol := 'Navaid, Blue';
    ShapingPointCategory := 'Shape';
    DefShapePtSymbol := 'Waypoint';

  ProcessVia := true;
    DefViaPointSymbol := 'Navaid, Red';
    ViaPointCategory := 'Via';

  ProcessCreateRoutePoints := true;

  ProcessTracks := true;

  ProcessWayPtsFromRoute := true; // Create points for GPI and route Points from route
  ProcessWayPtsInWayPts := true;
  ProcessViaPtsInWayPts := false;
  ProcessShapePtsInWayPts := false;

  ProcessWayPtsInGpi := true;
  ProcessViaPtsInGpi := true;
  ProcessShapePtsInGpi := false;
  GPISymbolsDir := DefGpiSymbolsDir;
  DefaultProximityStr := '';

  ProcessCategory := [pcSymbol, pcGPX];

  ProcessAddrVia := false;
  ProcessAddrWayPt := false;

  ProcessDistance := true;
  DistanceUnit := duKm;

  DefTrackColor := 'Blue';
  TrackColor := '';

  DefWaypointSymbol := 'Flag, Green';
  CatSymbol := 'Symbol:';
  CatGPX := 'GPX:';
  CatRoute := 'Route:';

  LookUpWindow := 0;
  LookUpMessage := 0;

{$IFDEF TRIPOBJECTS}
  ZumoModel := TZumoModel.XT;
  ExploreUuid := '';
  VehicleProfileGuid := '';
  VehicleProfileHash := '';
  VehicleId := '';
{$ENDIF}

  if (Assigned(OnSetFixedPrefs)) then
    OnSetFixedPrefs(Self);

  if (Assigned(FOnSetFuncPrefs)) then
    FOnSetFuncPrefs(Self);
end;

destructor TProcessOptions.Destroy;
begin
// Future use
  inherited Destroy;
end;

procedure TProcessOptions.DoPrefSaved;
begin
  if (Assigned(FOnSavePrefs)) then
    FOnSavePrefs(Self);
end;

procedure TProcessOptions.SetProcessCategory(ProcessWpt: boolean; WayPtCat: string);
var
  WayPtList: TStringList;
  WayPtCatSeq: integer;
begin
  WayPtList := TStringList.Create;
  try
    WayPtList.Text := ProcessCategoryPick;
    ProcessCategory := [];
    WayPtCatSeq := WayPtList.IndexOf(WayPtCat);
    if (ProcessWpt) then
    begin
      case WayPtCatSeq of
        1: Include(ProcessCategory, pcSymbol);
        2: Include(ProcessCategory, pcGPX);
        3: begin
             Include(ProcessCategory, pcSymbol);
             Include(ProcessCategory, pcGPX);
            end;
      end;
    end;
  finally
    WayPtList.Free;
  end;
end;

function TProcessOptions.DistanceStr: string;
begin
  if (DistanceUnit = TDistanceUnit.duMi) then
    result := 'Mi'
  else
    result := 'Km';
end;

{$IFDEF REGISTRY}
class procedure TProcessOptions.SetPrefs(TvSelections: TTreeview);
var
  SavedStateChanging: TTVCheckStateChangingEvent;
begin
  // Cant uncheck when node is not enabled
  SavedStateChanging := TvSelections.OnCheckStateChanging;
  TvSelections.OnCheckStateChanging := nil;
  try
    TvSelections.Items[IdTrip].Checked := GetRegistry(Reg_FuncTrip, true);

    TvSelections.Items[IdTrack].Checked := GetRegistry(Reg_FuncTrack, true);

    TvSelections.Items[IdStrippedRoute].Checked := GetRegistry(Reg_FuncStrippedRoute, true);
    TvSelections.Items[IdCompleteRoute].Checked := TvSelections.Items[IdCompleteRoute].Enabled and
                                                     GetRegistry(Reg_FuncCompleteRoute, false);
    TvSelections.Items[IdWayPoint].Checked := GetRegistry(Reg_FuncWayPoint, false);
      TvSelections.Items[IdWayPointWpt].Checked := GetRegistry(Reg_FuncWayPointWpt, true);
      TvSelections.Items[IdWayPointVia].Checked := GetRegistry(Reg_FuncWayPointVia, false);
      TvSelections.Items[IdWayPointShp].Checked := GetRegistry(Reg_FuncWayPointShape, false);

    TvSelections.Items[IdGpi].Checked := GetRegistry(Reg_FuncGpi, true);
      TvSelections.Items[IdGpiWayPt].Checked := GetRegistry(Reg_FuncGpiWayPt, true);
      TvSelections.Items[IdGpiViaPt].Checked := GetRegistry(Reg_FuncGpiViaPt, false);
      TvSelections.Items[IdGpiShpPt].Checked := GetRegistry(Reg_FuncGpiShpPt, false);

    TvSelections.Items[IdKml].Checked := TvSelections.Items[IdKml].Enabled and
                                           GetRegistry(Reg_FuncKml, true);
    TvSelections.Items[IdHtml].Checked := TvSelections.Items[IdHtml].Enabled and
                                            GetRegistry(Reg_FuncHtml, true);
  finally
    TvSelections.OnCheckStateChanging := SavedStateChanging;
    TvSelections.FullExpand;
  end;
end;

class function TProcessOptions.StorePrefs(TvSelections: TTreeview): TGPXFuncArray;
begin
  if (TvSelections.Items[IdStrippedRoute].Checked) and
     (TvSelections.Items[IdCompleteRoute].Checked) then
    raise Exception.Create('Only one route option can be selected!');

  SetLength(result, 0);

  SetRegistry(Reg_FuncTrip, TvSelections.Items[IdTrip].Checked);
  if (TvSelections.Items[IdTrip].Checked) then
    result := result + [TGPXFunc.CreateTrips];

  SetRegistry(Reg_FuncTrack, TvSelections.Items[IdTrack].Checked);
  if (TvSelections.Items[IdTrack].Checked) then
    result := result + [TGPXFunc.CreateTracks];

  SetRegistry(Reg_FuncStrippedRoute, TvSelections.Items[IdStrippedRoute].Checked);
  if (TvSelections.Items[IdStrippedRoute].Checked) then
    result := result + [TGPXFunc.CreateRoutes];

  if (TvSelections.Items[IdCompleteRoute].Enabled) then
    SetRegistry(Reg_FuncCompleteRoute, TvSelections.Items[IdCompleteRoute].Checked);

  SetRegistry(Reg_FuncWayPoint, TvSelections.Items[IdWayPoint].Checked);
  if (TvSelections.Items[IdWayPoint].Checked) then
  begin
    result := result + [TGPXFunc.CreateWayPoints];
    if (TvSelections.Items[IdWayPointWpt].Checked = false) and
       (TvSelections.Items[IdWayPointWpt].Checked = false) and
       (TvSelections.Items[IdWayPointWpt].Checked = false) then
      raise Exception.Create(Format('Select at least one of: %s %s %s %s %s %s!',
       [#10, TvSelections.Items[IdWayPointWpt].Text,
        #10, TvSelections.Items[IdWayPointVia].Text,
        #10, TvSelections.Items[IdWayPointVia].Text]));
  end;
    SetRegistry(Reg_FuncWayPointWpt, TvSelections.Items[IdWayPointWpt].Checked);
    SetRegistry(Reg_FuncWayPointVia, TvSelections.Items[IdWayPointVia].Checked);
    SetRegistry(Reg_FuncWayPointShape, TvSelections.Items[IdWayPointVia].Checked);

  SetRegistry(Reg_FuncGpi, TvSelections.Items[IdGpi].Checked);
  if (TvSelections.Items[IdGpi].Checked) then
  begin
    result := result + [TGPXFunc.CreatePOI];
    if (TvSelections.Items[IdGpiWayPt].Checked = false) and
       (TvSelections.Items[IdGpiViaPt].Checked = false) and
       (TvSelections.Items[IdGpiShpPt].Checked = false) then
      raise Exception.Create(Format('Select at least one of: %s %s %s %s %s %s!',
       [#10, TvSelections.Items[IdGpiWayPt].Text,
        #10, TvSelections.Items[IdGpiViaPt].Text,
        #10, TvSelections.Items[IdGpiShpPt].Text]));
  end;
    SetRegistry(Reg_FuncGpiWayPt, TvSelections.Items[IdGpiWayPt].Checked);
    SetRegistry(Reg_FuncGpiViaPt, TvSelections.Items[IdGpiViaPt].Checked);
    SetRegistry(Reg_FuncGpiShpPt, TvSelections.Items[IdGpiShpPt].Checked);

  if (TvSelections.Items[IdKml].Enabled) then
  begin
    SetRegistry(Reg_FuncKml, TvSelections.Items[IdKml].Checked);
    if (TvSelections.Items[IdKml].Checked) then
      result := result + [TGPXFunc.CreateKML];
  end;

  if (TvSelections.Items[IdHtml].Enabled) then
  begin
    SetRegistry(Reg_FuncHtml, TvSelections.Items[IdHtml].Checked);
    if (TvSelections.Items[IdHtml].Checked) then
      result := result + [TGPXFunc.CreateHTML];
  end;
end;
{$ENDIF}

end.
