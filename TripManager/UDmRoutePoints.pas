unit UDmRoutePoints;
{$WARN SYMBOL_PLATFORM OFF}
interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.UITypes,
  Data.DB, Datasnap.DBClient,
  UnitVerySimpleXml;

type
  TOnGetMapCoords = function: string of object;

  TDmRoutePoints = class(TDataModule)
    DsRoutePoints: TDataSource;
    CdsRoutePoints: TClientDataSet;
    CdsRoutePointsId: TIntegerField;
    CdsRoutePointsName: TWideStringField;
    CdsRoutePointsViaPoint: TBooleanField;
    CdsRoutePointsLat: TStringField;
    CdsRoutePointsLon: TStringField;
    CdsRoutePointsAddress: TStringField;
    CdsRoutePointsCoords: TStringField;
    CdsRoute: TClientDataSet;
    DsRoute: TDataSource;
    CdsRouteTripName: TStringField;
    CdsRouteRoutePreference: TStringField;
    CdsRouteTransportationMode: TStringField;
    CdsRouteDepartureDate: TDateTimeField;
    CdsRoutePointsRoutePref: TWordField;
    procedure CdsRoutePointsAfterInsert(DataSet: TDataSet);
    procedure CdsRoutePointsAfterScroll(DataSet: TDataSet);
    procedure CdsRoutePointsBeforePost(DataSet: TDataSet);
    procedure CdsRoutePointsBeforeDelete(DataSet: TDataSet);
    procedure CdsRoutePointsAfterPost(DataSet: TDataSet);
    procedure CdsRoutePointsBeforeInsert(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure CdsRoutePointsCalcFields(DataSet: TDataSet);
    procedure CdsRoutePointsViaPointGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure CdsRoutePointsViaPointSetText(Sender: TField; const Text: string);
    procedure CdsRoutePointsAfterDelete(DataSet: TDataSet);
  private
    { Private declarations }
    FRoutePickList: string;
    FTransportPickList: string;
    FTripList: TObject;
    IdToInsert: integer;
    FOnRouteUpdated: TNotifyEvent;
    FOnRoutePointUpdated: TNotifyEvent;
    FOnGetMapCoords: TOnGetMapCoords;
    FUuidList: TStringList;
    procedure DoRouteUpdated;
    procedure DoRoutePointUpdated;
    function CheckEmptyField(Sender: TField): boolean;
    procedure SetAddressFromCoords(Sender: TObject; Coords: string);
    procedure OnSetAnalyzePrefs(Sender: TObject);
    procedure AddRoutePoint(ARoutePoint: TXmlVSNode; FromWpt: boolean);
  public
    { Public declarations }
    function ShowFieldExists(AField: string; AButtons: TMsgDlgButtons = [TMsgDlgBtn.mbOK]): integer;
    function NameExists(Name: string): boolean;
    procedure SetPickLists(ATripList: TObject);
    procedure LoadTrip(ATripList: TObject);
    procedure SaveTrip;
    procedure MoveUp(Dataset: TDataset);
    procedure MoveDown(Dataset: TDataset);
    procedure SetDefaultName(IdToAssign: integer);
    procedure SetBoolValue(ABoolValue: string; ABoolField: TField);
    function FromRegional(ANum: string): string;
    function ToRegional(ANum: string): string;
    function AddressFromCoords(const Lat, Lon: string): string;
    procedure LookUpAddress;
    procedure CoordinatesApplied(Sender: TObject; Coords: string);
    procedure ImportFromGPX(const GPXFile: string);
    function Trk2RtPreview(GPXFileObj: TObject; UpdateDb: boolean): integer;
    function Trk2RtImportFromGPX(const GPXOrKmlFile: string; const UpdateDB: boolean = false): integer;
    procedure ExportToGPX(const GPXFile: string);
    procedure ImportFromCSV(const CSVFile: string);
    procedure ExportToCSV(const CSVFile: string);
    function KurvigerURL: string;
    property OnRouteUpdated: TNotifyEvent read FOnRouteUpdated write FOnRouteUpdated;
    property OnRoutePointUpdated: TNotifyEvent read FOnRoutePointUpdated write FOnRoutePointUpdated;
    property OnGetMapCoords: TOnGetMapCoords read FOnGetMapCoords write FOnGetMapCoords;
    property RoutePickList: string read FRoutePickList;
    property TransportPickList: string read FTransportPickList;
    property UuidList: TStringList read FUuidList write FUuidList;
  end;

var
  DmRoutePoints: TDmRoutePoints;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  System.StrUtils, System.Variants, System.DateUtils, System.Math,
  Winapi.Windows,
  Vcl.Dialogs, Vcl.ComCtrls,
  UnitGeoCode, UnitStringUtils, UnitRedirect, UnitProcessOptions, UnitGpxDefs, UnitGpxObjects,
  UnitTripDefs, UnitTripObjects;

{$R *.dfm}

const
  BooleanTrue       = 'True';
  BooleanFalse      = 'False';
  BooleanValues:    array[0..2, 0..1] of string = (('Via','Shape'), ('True','False'), ('Yes','No'));
  RtePt             = 'RtePt ';
  MaxDepartureYear  = 2037;
  KmlExtension      = '.kml';
  Trk2Rt            = 'Trk2Rt';
  T2R               = 'T2R';
  GPXExtension      = '.gpx';
  Trk2RtIn          = Trk2Rt + GPXExtension;
  Trk2RtOut         = T2R + '\' + Trk2Rt + '_' + T2R + GPXExtension;

var
  RegionalFormatSettings: TFormatSettings;
  FloatFormatSettings: TFormatSettings;

function TDmRoutePoints.CheckEmptyField(Sender: TField): boolean;
begin
  result := (Sender.AsString <> '');
  if (not result) then
    MessageDlg(Format('%s is Mandatory', [Sender.FieldName]), TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
end;

procedure TDmRoutePoints.DataModuleCreate(Sender: TObject);
begin
  RegionalFormatSettings := TFormatSettings.Create(GetThreadLocale);
  FloatFormatSettings.ThousandSeparator := ',';
  FloatFormatSettings.DecimalSeparator := '.';
  SetPickLists(nil);
end;

procedure TDmRoutePoints.DoRoutePointUpdated;
begin
  if (CdsRoutePoints.ControlsDisabled) then
    exit;
  if Assigned(FOnRoutePointUpdated) then
    FOnRoutePointUpdated(Self);
end;

procedure TDmRoutePoints.DoRouteUpdated;
begin
  if (CdsRoutePoints.ControlsDisabled) then
    exit;
  if Assigned(FOnRouteUpdated) then
    FOnRouteUpdated(Self);
end;

// Renumber Route points
procedure TDmRoutePoints.CdsRoutePointsAfterDelete(DataSet: TDataSet);
var
  Id: integer;
  MyBook: TBookmark;
begin
  CdsRoutePoints.DisableControls;
  MyBook := CdsRoutePoints.GetBookmark;
  try
    Id := 0;
    CdsRoutePoints.First;
    while not CdsRoutePoints.Eof do
    begin
      Inc(Id);
      CdsRoutePoints.Edit;
      CdsRoutePointsId.AsInteger := Id;
      SetDefaultName(Id);
      CdsRoutePoints.Post;
      CdsRoutePoints.Next;
    end;
  finally
    CdsRoutePoints.GotoBookmark(MyBook);
    CdsRoutePoints.FreeBookmark(MyBook);
    CdsRoutePoints.EnableControls;
  end;
  DoRouteUpdated;
end;

procedure TDmRoutePoints.CdsRoutePointsAfterInsert(DataSet: TDataSet);
begin
  CdsRoutePointsId.AsInteger := IdToInsert;
  CdsRoutePointsRoutePref.AsInteger := Ord(TmRoutePreference.RoutePreference(CdsRouteRoutePreference.AsString)) shl 8;
  if (DataSet.ControlsDisabled) then
    exit;

  SetDefaultName(IdToInsert);
  CdsRoutePointsViaPoint.AsBoolean := false;
  if Assigned(FOnGetMapCoords) then
    SetAddressFromCoords(Dataset, FOnGetMapCoords);
end;

procedure TDmRoutePoints.CdsRoutePointsAfterPost(DataSet: TDataSet);
begin
  DoRouteUpdated;
  DoRoutePointUpdated;
end;

procedure TDmRoutePoints.CdsRoutePointsAfterScroll(DataSet: TDataSet);
begin
  DoRoutePointUpdated;
end;

procedure TDmRoutePoints.CdsRoutePointsBeforeInsert(DataSet: TDataSet);
var
  MyBook: TBookmark;
begin
  if (Dataset.RecordCount = 0) or
     (Dataset.RecNo = Dataset.RecordCount) then // Last record, appends
    IdToInsert := DataSet.RecordCount +1
  else
  begin
    Dataset.Next;
    IdToInsert := DataSet.FieldByName('Id').AsInteger;
    MyBook := Dataset.GetBookmark;
    Dataset.DisableControls;
    try
      Dataset.Last;
      while not Dataset.Bof and
            (Dataset.FieldByName('Id').AsInteger >= IdToInsert) do
      begin
        Dataset.Edit;
        Dataset.FieldByName('Id').AsInteger := Dataset.FieldByName('Id').AsInteger +1;
        SetDefaultName(Dataset.FieldByName('Id').AsInteger);
        Dataset.Post;
        Dataset.Prior;
      end;
    finally
      DataSet.GotoBookmark(MyBook);
      DataSet.FreeBookmark(MyBook);
      Dataset.EnableControls;
    end;
  end;
end;

function TDmRoutePoints.ShowFieldExists(AField: string; AButtons: TMsgDlgButtons = [TMsgDlgBtn.mbOK]): integer;
begin
  result := MessageDlg(Format('%s Exists', [AField]), TMsgDlgType.mtError, AButtons, 0);
end;

procedure TDmRoutePoints.CdsRoutePointsBeforePost(DataSet: TDataSet);
begin
  if not (CheckEmptyField(Dataset.FieldByName('Name'))) then
    Abort;
end;

function TDmRoutePoints.AddressFromCoords(const Lat, Lon: string): string;
begin
  result := Format('%s, %s', [Lat, Lon]);
end;

procedure TDmRoutePoints.CdsRoutePointsCalcFields(DataSet: TDataSet);
begin
  DataSet.FieldByName('Coords').AsString :=
    AddressFromCoords(DataSet.FieldByName('Lat').AsString, DataSet.FieldByName('Lon').AsString);
end;

procedure TDmRoutePoints.CdsRoutePointsViaPointGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text:=''; // In case Boolean is null
  if (Sender.IsNull = false) and
     (SameText(Sender.Value, BooleanTrue)) then
     Text := BooleanValues[Sender.Tag, 0];
  if (Sender.IsNull = false) and
     (SameText(Sender.Value, BooleanFalse)) then
     Text := BooleanValues[Sender.Tag, 1];
end;

procedure TDmRoutePoints.CdsRoutePointsViaPointSetText(Sender: TField; const Text: string);
begin
  Sender.clear;
  if StartsText(Text, BooleanValues[Sender.Tag, 0]) then
     Sender.Value := BooleanTrue
  else
     Sender.Value := BooleanFalse;
end;

procedure TDmRoutePoints.CdsRoutePointsBeforeDelete(DataSet: TDataSet);
begin
  if CdsRoutePoints.ReadOnly then
    Abort;
end;

procedure TDmRoutePoints.MoveUp(Dataset: TDataSet);
var
  OrigId, PriorId: integer;
  MyBook: TBookmark;
begin
  Dataset.DisableControls;
  MyBook := Dataset.GetBookmark;
  try
    // Cant move
    if (Dataset.RecordCount < 2) or
      (Dataset.Bof) then
      exit;

    // Sort column Orig
    OrigId := Dataset.FieldByName('Id').AsInteger;
    if (OrigId < 1) then
      exit;

    // Edit Prior line
    Dataset.Prior;
    Dataset.Edit;
    PriorId := Dataset.FieldByName('Id').AsInteger; // Save Id Prior
    Dataset.FieldByName('Id').AsInteger := OrigId;
    SetDefaultName(OrigId);
    Dataset.Post;

    // Reposition to Orig line, and update with PriorId
    Dataset.GotoBookmark(MyBook);
    Dataset.Edit;
    Dataset.FieldByName('Id').AsInteger := PriorId;
    SetDefaultName(PriorId);
    Dataset.Post;

  finally
    Dataset.FreeBookmark(MyBook);
    Dataset.EnableControls;
    DoRouteUpdated;
  end;
end;

procedure TDmRoutePoints.MoveDown(Dataset: TDataSet);
var
  OrigId, NextId, S: integer;
  MyBook: TBookmark;
begin
  Dataset.DisableControls;
  MyBook := Dataset.GetBookmark;
  try
    // Cant move
    if (Dataset.RecordCount < 2) or
      (Dataset.Eof) then
      exit;

    // Sort column Orig
    OrigId := Dataset.FieldByName('Id').AsInteger;
    if (OrigId < 0) then
      exit;

    // Edit Next line
    Dataset.Next;
    Dataset.Edit;
    NextId := Dataset.FieldByName('Id').AsInteger; // Save Id Next
    Dataset.FieldByName('Id').AsInteger := OrigId;
    SetDefaultName(OrigId);
    Dataset.Post;

    // Reposition to orig line, and update with NextId
    Dataset.GotoBookmark(MyBook);
    Dataset.Edit;
    Dataset.FieldByName('Id').AsInteger := NextId;
    SetDefaultName(NextId);
    Dataset.Post;

    // Hack to fix the toprow of the grid
    S := Dataset.RecNo;
    DataSet.First;
    Dataset.RecNo := S;

  finally
    Dataset.FreeBookmark(MyBook);
    Dataset.EnableControls;
    DoRouteUpdated;
  end;
end;

procedure PrepStream(TmpStream: TMemoryStream; const Buffer: array of Cardinal);
begin
  TmpStream.Clear;
  TmpStream.Write(Buffer, SizeOf(Buffer));
  TmpStream.Position := 0;
end;

procedure TDmRoutePoints.SaveTrip;
var
  SaveRecNo: integer;
  Locations: TmLocations;
  Links: TmAllLinks;
  TmpStream: TMemoryStream;
  ANItem: TBaseItem;
  ProcessOptions: TProcessOptions;
  RoutePoint: TRoutePoint;
  P: integer;
begin
  if (CdsRoute.State in [dsEdit, dsInsert]) then
    CdsRoute.Post;

  if (CdsRoutePoints.State in [dsEdit, dsInsert]) then
    CdsRoutePoints.Post;

  SaveRecNo := CdsRoutePoints.RecNo;
  CdsRoutePoints.DisableControls;
  TmpStream := TMemoryStream.Create;
  ProcessOptions := TProcessOptions.Create;
  ProcessOptions.TripModel := TTripList(FTripList).TripModel;
  try
    Locations := TmLocations(TTripList(FTripList).GetItem('mLocations'));
    if not (Assigned(Locations)) then
      exit;

    Locations.Clear;
    CdsRoutePoints.First;
    while not CdsRoutePoints.Eof do
    begin
      if (CdsRoutePointsViaPoint.AsBoolean) or
         (CdsRoutePoints.RecNo = 1) or
         (CdsRoutePoints.RecNo = CdsRoutePoints.RecordCount) then
        RoutePoint := TRoutePoint.rpVia
      else
        RoutePoint := TRoutePoint.rpShaping;

      TTripList(FTripList).AddLocation(Locations,
                                       ProcessOptions,
                                       RoutePoint,
                                       TRoutePreference(Hi(CdsRoutePointsRoutePref.AsInteger)),
                                       TAdvlevel(Lo(CdsRoutePointsRoutePref.AsInteger)),
                                       StrToFloatDef(CdsRoutePointsLat.AsString, 0, FloatFormatSettings),
                                       StrToFloatDef(CdsRoutePointsLon.AsString, 0, FloatFormatSettings),
                                       0,
                                       CdsRoutePointsName.AsString,
                                       CdsRoutePointsAddress.AsString);
      CdsRoutePoints.Next;
    end;

    if (CdsRoute.State = dsBrowse) then
    begin
      ANItem := TTripList(FTripList).GetItem('mTripName');
      if (ANItem <> nil) then
        TmTripName(ANItem).AsString := CdsRouteTripName.AsString;

      case TTripList(FTripList).TripModel of
        TTripModel.Nuvi2595:
        begin
          Links := TmAllLinks(TTripList(FTripList).GetItem('mAllLinks'));
          Links.DefRoutePref := TmRoutePreference.RoutePreference(CdsRouteRoutePreference.AsString);
          Links.DefTransportMode := TmTransportationMode.TransPortMethod(CdsRouteTransportationMode.AsString);
        end
        else
        begin
          ANItem := TTripList(FTripList).GetItem('mRoutePreference');
          if (ANItem <> nil) then
            TmRoutePreference(ANItem).AsString := CdsRouteRoutePreference.AsString;

          ANItem := TTripList(FTripList).GetItem('mTransportationMode');
          if (ANItem <> nil) then
            TmTransportationMode(ANItem).AsString := CdsRouteTransportationMode.AsString;
        end;
      end;
      ANItem := TTripList(FTripList).GetArrival;
      if (ANItem <> nil) then
        TmArrival(ANItem).AsUnixDateTime := TmArrival(ANItem).DateTimeAsCardinal(CdsRouteDepartureDate.AsDateTime);

      if (Assigned(FUuidList)) then
      begin
        P := FUuidList.IndexOfName(CdsRouteTripName.AsString);
        if (P > -1) then
        begin
          ANItem := TTripList(FTripList).GetItem('mExploreUuid');
          if (ANItem <> nil) then
            TmExploreUuid(ANItem).AsString := FUuidList.ValueFromIndex[P];
        end;
      end;

    end;
  finally
    TmpStream.Free;
    ProcessOptions.Free;
    CdsRoutePoints.RecNo := SaveRecNo;
    CdsRoutePoints.EnableControls;
  end;
end;

function TDmRoutePoints.NameExists(Name: string): boolean;
var
  ACds: TClientDataSet;
begin
  ACds := TClientDataSet.Create(Self);
  try
    ACds.CloneCursor(CdsRoutePoints, true, false);
    result := ACds.Locate('Name', Name, [TLocateOption.loCaseInsensitive]);
  finally
    ACds.Free;
  end;
end;

procedure TDmRoutePoints.SetPickLists(ATripList: TObject);
begin
  with TmRoutePreference.Create(TRoutePreference.rmFasterTime) do
  begin
    SetTripList(TTripList(ATripList));
    FRoutePickList := PickList;
    Free;
  end;
  with TmTransportationMode.Create(TTransportMode.tmMotorcycling) do
  begin
    SetTripList(TTripList(ATripList));
    FTransportPickList := PickList;
    Free;
  end;
end;

procedure TDmRoutePoints.LoadTrip(ATripList: TObject);
var
  Locations: TmLocations;
  Links: TmAllLinks;
  Link: TBaseItem;
  Location, ANItem: TBaseItem;
  LatLon, CalculationMode: string;
begin
  FTripList := ATripList;

  CdsRoute.Close;
  CdsRoute.DisableControls;
  CdsRoute.ReadOnly := false;

  CdsRoutePoints.Close;
  CdsRoutePoints.DisableControls;
  CdsRoutePoints.ReadOnly := false;
  try

    CdsRoute.IndexFieldNames := 'TripName'; // There will be only 1 record!
    CdsRoute.CreateDataSet;
    CdsRoute.LogChanges := false;

    CdsRoute.Insert;
    CdsRouteTripName.AsString := TTripList(FTripList).TripName;

    case TTripList(FTripList).TripModel of
      TTripModel.Nuvi2595:
      begin
        Links := TmAllLinks(TTripList(FTripList).GetItem('mAllLinks'));
        for Link in Links.Links do
        begin
          for ANItem in Tlink(Link).Items do
          begin
            if (ANItem is TmRoutePreference) then
              CdsRouteRoutePreference.AsString := TmRoutePreference(ANItem).AsString;
            if (ANItem is TmTransportationMode) then
              CdsRouteTransportationMode.AsString := TmTransportationMode(ANItem).AsString;
          end;
          break;
        end;
      end
      else
      begin
        ANItem := TTripList(FTripList).GetItem('mRoutePreference');
        if (ANItem = nil) then
        begin
          ANItem := TTripList(FTripList).GetItem('mRoutePreferences');
          if (ANItem <> nil) then
          begin
            IntToIdent(Ord(TmRoutePreferences(ANItem).GetRoutePref(1)), CalculationMode, RoutePreferenceMap);
            CdsRouteRoutePreference.AsString := CalculationMode;
          end;
        end
        else
          CdsRouteRoutePreference.AsString := TmRoutePreference(ANItem).AsString;

        ANItem := TTripList(FTripList).GetItem('mTransportationMode');
        if (ANItem <> nil) then
          CdsRouteTransportationMode.AsString := TmTransportationMode(ANItem).AsString;
      end;
    end;

    ANItem := TTripList(FTripList).GetArrival;
    if (ANItem <> nil) then
      CdsRouteDepartureDate.AsDateTime := TmArrival(ANItem).CardinalAsDateTime(TmArrival(ANItem).AsUnixDateTime);
    CdsRoute.Post;

    CdsRoutePoints.IndexFieldNames := 'Id';
    CdsRoutePoints.CreateDataSet;
    CdsRoutePoints.LogChanges := false;

    Locations := TmLocations(TTripList(FTripList).GetItem('mLocations'));
    if not (Assigned(Locations)) or
       (Locations.LocationCount = 0) then
      exit;

    for Location in Locations.Locations do
    begin
      if (Location is TLocation) then
      begin
        CdsRoutePoints.Insert; // Id is autoassigned

        // TmAttr, tmShaping
        CdsRoutePointsViaPoint.AsBoolean := TLocation(Location).IsViaPoint;

        // TmName
        ANItem := TLocation(Location).LocationTmName;
        if (Assigned(ANItem)) then
          CdsRoutePointsName.AsString := TmName(ANItem).AsString;
        if (CdsRoutePointsName.AsString = '') then
          SetDefaultName(IdToInsert);

        // TmAddress
        ANItem := TLocation(Location).LocationTmAddress;
        if (Assigned(ANItem)) then
          CdsRoutePointsAddress.AsString := TmAddress(ANItem).AsString;

        // TmscPosn
        ANItem := TLocation(Location).LocationTmScPosn;
        if (Assigned(ANItem)) then
        begin
          LatLon := TmScPosn(ANItem).MapCoords;
          CdsRoutePointsLat.AsString := Trim(NextField(LatLon, ','));
          CdsRoutePointsLon.AsString := Trim(LatLon);
        end;

        CdsRoutePointsRoutePref.AsInteger := (Ord(TLocation(Location).RoutePref) shl 8) + Ord(TLocation(Location).AdvLevel);

        CdsRoutePoints.Post;
      end;
    end;
  finally
    CdsRoute.First;
    CdsRoute.EnableControls;

    CdsRoutePoints.First;
    CdsRoutePoints.EnableControls;

    DoRoutePointUpdated;  // Now filter tagnames
  end;
end;

procedure TDmRoutePoints.SetDefaultName(IdToAssign: integer);
var
  IsDefault: boolean;
begin
  IsDefault := (CdsRoutePointsName.AsString = '') or
               StartsText(RtePt, CdsRoutePointsName.AsString);
  if (IsDefault) then
    CdsRoutePointsName.AsString := Format(RtePt + '%d', [IdToAssign]);
end;

procedure TDmRoutePoints.SetBoolValue(ABoolValue: string; ABoolField: TField);
var
  BoolValue: integer;
begin
  ABoolField.AsBoolean := false;
  for BoolValue := Low(BooleanValues) to High(BooleanValues) do
  if (SameText(ABoolValue, BooleanValues[BoolValue, 0])) then
  begin
    ABoolField.AsBoolean := true;
    break;
  end;
end;

function TDmRoutePoints.FromRegional(ANum: string): string;
begin
  result := ReplaceAll(ANum, [RegionalFormatSettings.DecimalSeparator], [FloatFormatSettings.DecimalSeparator]);
end;

function TDmRoutePoints.ToRegional(ANum: string): string;
begin
  result := ReplaceAll(ANum, [FloatFormatSettings.DecimalSeparator], [RegionalFormatSettings.DecimalSeparator]);
end;

procedure TDmRoutePoints.SetAddressFromCoords(Sender: TObject; Coords: string);
var
  Lat, Lon: string;
begin
  ParseLatLon(Coords, Lat, Lon);
  CdsRoutePointsLat.AsString := Lat;
  CdsRoutePointsLon.AsString := Lon;
  CdsRoutePointsAddress.AsString := AddressFromCoords(Lat, Lon);
end;

procedure TDmRoutePoints.LookUpAddress;
var
  Place: TPlace;
  Lat, Lon: string;
begin
  if (ValidLatLon(CdsRoutePointsLat.AsString, CdsRoutePointsLon.AsString)) then
  begin
    Place := GetPlaceOfCoords(CdsRoutePointsLat.AsString,
                              CdsRoutePointsLon.AsString);
    if (Place = nil) then
      CdsRoutePointsAddress.AsString := AddressFromCoords(CdsRoutePointsLat.AsString, CdsRoutePointsLon.AsString)
    else
      CdsRoutePointsAddress.AsString := Place.RoutePlace;
  end
  else
  begin
    GetCoordsOfPlace(CdsRoutePointsAddress.AsString, Lat, Lon);
    CdsRoutePointsLat.AsString := Lat;
    CdsRoutePointsLon.AsString := Lon;
  end;
end;

procedure TDmRoutePoints.CoordinatesApplied(Sender: TObject; Coords: string);
begin
  if not (CdsRoutePoints.State in [dsInsert, dsEdit]) then
    CdsRoutePoints.Edit;
  SetAddressFromCoords(Sender, Coords);
  LookUpAddress;
  CdsRoutePoints.Post;
end;

procedure TDmRoutePoints.OnSetAnalyzePrefs(Sender: TObject);
begin
  with TProcessOptions(Sender) do
  begin
    ProcessTracks := true; // Needed for Trk2RT

    ProcessDistance := false;
    ProcessShape := false;
    ProcessVia := false;
    ProcessBegin := false;
    ProcessEnd := false;

    ShapingPointName := TShapingPointName.Unchanged;
  end;
end;

procedure TDmRoutePoints.AddRoutePoint(ARoutePoint: TXmlVSNode; FromWpt: boolean);
var
  ExtensionsNode, WayPointExtension, Address, AddressChild: TXmlVSNode;
  Lat, Lon, AddressLine: string;
begin
  DmRoutePoints.CdsRoutePoints.Insert;
  DmRoutePoints.CdsRoutePointsName.AsString := FindSubNodeValue(ARoutePoint, 'name');
  Lat := ARoutePoint.Attributes['lat'];
  Lon := ARoutePoint.Attributes['lon'];
  AdjustLatLon(Lat, Lon, 6);
  DmRoutePoints.CdsRoutePointsLat.AsString := Lat;
  DmRoutePoints.CdsRoutePointsLon.AsString := Lon;
  ExtensionsNode := ARoutePoint.Find('extensions');
  if (FromWpt) then
  begin
    DmRoutePoints.CdsRoutePointsViaPoint.AsBoolean := true;
    AddressLine := '';
    if (ExtensionsNode <> nil) then
    begin
      Address := nil;
      WayPointExtension := ExtensionsNode.find('gpxx:WaypointExtension');
      if (WayPointExtension <> nil) then
        Address := WayPointExtension.Find('gpxx:Address');
      if (Address <> nil) then
      begin
        for AddressChild in Address.ChildNodes do
        begin
          if (AddressLine <> '') then
            AddressLine := AddressLine + ', ';
          AddressLine := AddressLine + AddressChild.NodeValue;
        end;
      end;
    end;
    DmRoutePoints.CdsRoutePointsAddress.AsString := AddressLine;
  end
  else
  begin
    DmRoutePoints.CdsRoutePointsAddress.AsString := ReplaceAll(FindSubNodeValue(ARoutePoint, 'cmt'),
                                                               [#13#10, #10], [', ',', ']);
    if (DmRoutePoints.CdsRoutePointsAddress.AsString = '') then
      DmRoutePoints.CdsRoutePointsAddress.AsString := DmRoutePoints.AddressFromCoords(Lat, Lon);
    if (ExtensionsNode <> nil) then
      DmRoutePoints.CdsRoutePointsViaPoint.AsBoolean := (ExtensionsNode.Find('trp:ViaPoint') <> nil);
  end;
  DmRoutePoints.CdsRoutePoints.Post;
end;

procedure TDmRoutePoints.ImportFromGPX(const GPXFile: string);
var
  CrNormal,CrWait: HCURSOR;
  RoutePoints, RoutePoint: TXmlVSNode;
  AnItem: TListItem;
  SelectedItem: Char;
  GPXFileObj: TGPXFile;
begin
  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  GPXFileObj := TGPXFile.Create(GPXFile, OnSetAnalyzePrefs, nil);
  try
    GPXFileObj.AnalyzeGpx;
    SetCursor(CrNormal);
    if (GPXFileObj.ShowSelectTracks(TTagsToShow.WptRte,
                                    'Import route points from: ' + ExtractFileName(GPXFile),
                                    'Use the Checkboxes to select Waypoints/Routes', CdsRouteTripName.AsString, nil)) then
    begin
      if (CdsRoute.State in [dsEdit, dsInsert]) then
        CdsRoute.Post;
      if (CdsRoutePoints.State in [dsEdit, dsInsert]) then
        CdsRoutePoints.Post;

      CdsRoutePoints.DisableControls;
      try
        CdsRoutePoints.Last;  // Add to Route Points at end of list

        for AnItem in GPXFileObj.FrmSelectGPX.LvTracks.Items do
        begin
          if not (AnItem.Checked) then
            continue;

          SelectedItem := UpperCase(AnItem.SubItems[0] + ' ')[1];
          case SelectedItem of
          'W':
            begin
              for RoutePoint in GPXFileObj.WayPointList do
                AddRoutePoint(RoutePoint, true);
            end;
          'R':
            begin
              for RoutePoints in GPXFileObj.WayPointFromRouteList do
              begin
                if (RoutePoints.NodeName <> AnItem.Caption) then
                  continue;

                for RoutePoint in RoutePoints.ChildNodes do
                  AddRoutePoint(RoutePoint, false);
              end;
            end;
          end;
        end;
      finally
        CdsRoutePoints.EnableControls;
        if Assigned(OnRouteUpdated) then
          OnRouteUpdated(Self);
      end;
    end;
  finally
    GPXFileObj.Free;
    SetCursor(CrNormal);
  end;
end;

function TDmRoutePoints.Trk2RtPreview(GPXFileObj: TObject; UpdateDb: boolean): integer;
var
  CrNormal,CrWait: HCURSOR;
  RoutePoints, RoutePoint: TXmlVSNode;
  GpxFileTrkObj: TGPXFile;
  Trk2RtCmdLine, ResOutput, ResError: string;
  ResExit: Dword;
begin
  result := 0;
  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    if (TGPXFile(GPXFileObj).SaveSelectionAsXML(CreatedTempPath + Trk2RtIn) = 0) then
      exit;

    Trk2RtCmdLine := Format('%s.exe %s "%s"', [Trk2Rt, TProcessOptions.Trk2RtOptions, CreatedTempPath + Trk2RtIn]);
    if not Sto_RedirectedExecute(Trk2RtCmdLine, CreatedTempPath, ResOutput, ResError, ResExit) then
      raise Exception.Create(Format('Could not start %s.exe. Check installation', [Trk2Rt]));

    GpxFileTrkObj := TGPXFile.Create(CreatedTempPath + Trk2RtOut, OnSetAnalyzePrefs, nil);
    try
      GpxFileTrkObj.AnalyzeGpx;
      RoutePoints := GpxFileTrkObj.RouteViaPointList.FirstChild;
      if (RoutePoints = nil) then
        exit;
      result := RoutePoints.ChildNodes.Count;
      if (UpdateDB) then
      begin
        for RoutePoint in RoutePoints.ChildNodes do
          AddRoutePoint(RoutePoint, false);
      end;
    finally
      GpxFileTrkObj.Free;
    end;
  finally
    SetCursor(CrNormal);
  end;
end;

function TDmRoutePoints.Trk2RtImportFromGPX(const GPXOrKmlFile: string; const UpdateDB: boolean = false): integer;
var
  GPXFileObj: TGPXFile;
  GpxFile: string;
  Trk2RtCmdLine, ResOutput, ResError: string;
  ResExit: Dword;
begin
  result := 0;
  GpxFile := GPXOrKmlFile;

  // Use Trk2Rt to convert from KML to GPX first?
  if (ContainsText(ExtractFileExt(GPXOrKmlFile), KmlExtension)) then
  begin
    Trk2RtCmdLine := Format('%s.exe %s exportPath="%s" "%s"',
                            [Trk2Rt, TProcessOptions.Trk2RtOptions, ExcludeTrailingPathDelimiter(CreatedTempPath), GPXOrKmlFile]);
    if not Sto_RedirectedExecute(Trk2RtCmdLine, CreatedTempPath, ResOutput, ResError, ResExit) then
      raise Exception.Create(Format('Could not start %s.exe. Check installation', [Trk2Rt]));
    GpxFile := Format('%s%s_%s%s', [IncludeTrailingPathDelimiter(CreatedTempPath),
                                    ExtractFileName(ChangeFileExt(GPXOrKmlFile, '')),
                                    T2R,
                                    GPXExtension]);
  end;

  GPXFileObj := TGPXFile.Create(GPXFile, OnSetAnalyzePrefs, nil);
  try
    if (CdsRoute.State in [dsEdit, dsInsert]) then
      CdsRoute.Post;
    if (CdsRoutePoints.State in [dsEdit, dsInsert]) then
      CdsRoutePoints.Post;

    CdsRoutePoints.DisableControls;
    CdsRoutePoints.Last;  // Add to Route Points at end of list
    try
      GPXFileObj.AnalyzeGpx;
      if (GPXFileObj.ShowSelectTracks(TTagsToShow.WptRteTrk,
                                      'Import route points from: ' + ExtractFileName(GPXFile),
                                      'Use the Checkboxes to telect Waypoints/Routes/Tracks',
                                       CdsRouteTripName.AsString, Trk2RtPreview)) then
        Trk2RtPreview(GPXFileObj, true);

    finally
      CdsRoutePoints.EnableControls;
      if Assigned(OnRouteUpdated) then
        OnRouteUpdated(Self);
    end;
  finally
    GPXFileObj.Free;
  end;
end;

procedure TDmRoutePoints.ExportToGPX(const GPXFile: string);
var
  Xml: TXmlVSDocument;
  XMLRoot: TXmlVSNode;
  Rte, RtePt, Extensions, PointType: TXmlVSNode;
  DefProcessOptions: TProcessOptions;
begin
  XML := TXmlVSDocument.Create;
  DefProcessOptions := TProcessOptions.Create;
  if (CdsRoute.State in [dsEdit, dsInsert]) then
    CdsRoute.Post;
  if (CdsRoutePoints.State in [dsEdit, dsInsert]) then
    CdsRoutePoints.Post;

  CdsRoutePoints.DisableControls;
  try
    XMLRoot := InitGarminGpx(XML);
    Rte := XMLRoot.AddChild('rte');
    Rte.AddChild('name').NodeValue := CdsRouteTripName.AsString;
    Extensions := Rte.AddChild('extensions');
    Extensions.AddChild('gpxx:RouteExtension').AddChild('gpxx:IsAutoNamed').NodeValue := 'false';
    Extensions.AddChild('trp:Trip').AddChild('trp:TransportationMode').NodeValue := CdsRouteTransportationMode.AsString;

    CdsRoutePoints.First;
    while not CdsRoutePoints.Eof do
    begin
      RtePt := Rte.AddChild('rtept');
      RtePt.Attributes['lat'] := CdsRoutePointsLat.AsString;
      RtePt.Attributes['lon'] := CdsRoutePointsLon.AsString;
      RtePt.AddChild('name').NodeValue := CdsRoutePointsName.AsString;
      RtePt.AddChild('cmt').NodeValue := CdsRoutePointsAddress.AsString;
      RtePt.AddChild('desc').NodeValue := CdsRoutePointsAddress.AsString;

      // Add Symbol
      if (CdsRoutePoints.RecNo = 1) then
        RtePt.AddChild('sym').NodeValue := DefProcessOptions.BeginSymbol
      else if (CdsRoutePoints.RecNo = CdsRoutePoints.RecordCount) then
        RtePt.AddChild('sym').NodeValue := DefProcessOptions.EndSymbol
      else
        RtePt.AddChild('sym').NodeValue := DefProcessOptions.DefRtePtSymbol;

      // Add Point Type (Via of Shaping)
      if (CdsRoutePointsViaPoint.AsBoolean) then // Includes Begin and End
      begin
        PointType := RtePt.AddChild('extensions').AddChild('trp:ViaPoint');
        if (CdsRoutePoints.RecNo = 1) and
           (YearOf(CdsRouteDepartureDate.AsDateTime) <= MaxDepartureYear) then // BC Hack
          PointType.AddChild('trp:DepartureTime').NodeValue :=
            DateToISO8601(TTimezone.Local.ToUniversalTime(CdsRouteDepartureDate.AsDateTime), true);
        PointType.AddChild('trp:CalculationMode').NodeValue := CdsRouteRoutePreference.AsString;
      end
      else
        RtePt.AddChild('extensions').AddChild('trp:ShapingPoint');

      CdsRoutePoints.Next;
    end;

    XML.SaveToFile(GPXFile);
  finally
    Xml.Free;
    DefProcessOptions.Free;
    CdsRoutePoints.EnableControls;
  end;
end;

procedure TDmRoutePoints.ImportFromCSV(const CSVFile: string);
var
  Reader: TStringList;
  ALine, AField: string;
  Lst: TStringList;
  PointId, Column: integer;
  Columns: array of TField;
  Heading: boolean;
begin
  Heading := true;
  SetLength(Columns, 0);

  Reader := TStringList.Create;
  Reader.LoadFromFile(CSVFile);
  if (CdsRoute.State in [dsEdit, dsInsert]) then
    CdsRoute.Post;
  if (CdsRoutePoints.State in [dsEdit, dsInsert]) then
    CdsRoutePoints.Post;

  PointId := CdsRoutePoints.RecordCount +1;
  CdsRoutePoints.DisableControls;
  try
    Lst := TStringList.Create;
    try
      Lst.QuoteChar := '"';
      Lst.Delimiter := ';';
      Lst.StrictDelimiter := true;
      for ALine in Reader do
      begin
        Lst.DelimitedText := Aline;

        if (Heading) then
        begin
          Heading := false;
          SetLength(Columns, Lst.Count);
          for Column := 0 to Lst.Count -1 do
          begin
            AField := Lst[Column];
            if (ContainsText(AField, 'Route')) then
              Columns[Column] := CdsRoutePointsName
            else if (ContainsText(AField, 'Type')) then
              Columns[Column] := CdsRoutePointsViaPoint
            else if (ContainsText(AField, 'Lat')) then
              Columns[Column] := CdsRoutePointsLat
            else if (ContainsText(AField, 'Lon')) then
              Columns[Column] := CdsRoutePointsLon
            else if (ContainsText(AField, 'Address')) then
              Columns[Column] := CdsRoutePointsAddress
            else
              Columns[Column] := nil;
          end;
          continue;
        end;
        CdsRoutePoints.Last;
        CdsRoutePoints.Insert;
        for Column := 0 to Min(Lst.Count -1, High(Columns)) do
        begin
          AField := Lst[Column];
          if (Columns[Column] = nil) then
            continue;
          if (Columns[Column] is TBooleanField) then
          begin
            SetBoolValue(AField, Columns[Column]);
            continue;
          end;
          Columns[Column].AsString := AField;
        end;
        if (CdsRoutePointsViaPoint.IsNull) then
          CdsRoutePointsViaPoint.AsBoolean := true;
        SetDefaultName(PointId);
        CdsRoutePointsLat.AsString := FromRegional(CdsRoutePointsLat.AsString);
        CdsRoutePointsLon.AsString := FromRegional(CdsRoutePointsLon.AsString);
        Inc(PointId);
        CdsRoutePoints.Post;
      end;
    finally
      Lst.Free;
      CdsRoutePoints.EnableControls;
    end;
 finally
    Reader.Free;
  end;
end;

procedure TDmRoutePoints.ExportToCSV(const CSVFile: string);
var
  Writer: TTextWriter;
  Lst: TStringList;
  ViaShape: string;
begin
  if (CdsRoute.State in [dsEdit, dsInsert]) then
    CdsRoute.Post;
  if (CdsRoutePoints.State in [dsEdit, dsInsert]) then
    CdsRoutePoints.Post;

  CdsRoutePoints.DisableControls;
  Writer := TStreamWriter.Create(CSVFile, false, TEncoding.UTF8);
  try
    Lst := TStringList.Create;
    try
      Lst.QuoteChar := '"';
      Lst.Delimiter := ';';
      Lst.StrictDelimiter := true;

      Lst.AddStrings(['Route point', 'Point type', 'Lat', 'Lon', 'Address']);
      Writer.WriteLine(Lst.DelimitedText);

      CdsRoutePoints.First;
      while not CdsRoutePoints.Eof do
      begin
        if SameText(CdsRoutePointsViaPoint.AsString, BooleanTrue) then
           ViaShape := BooleanValues[CdsRoutePoints.Tag, 0]
        else
           ViaShape := BooleanValues[CdsRoutePoints.Tag, 1];

        Lst.Clear;
        Lst.AddStrings([CdsRoutePointsName.AsString,
                        ViaShape,
                        ToRegional(CdsRoutePointsLat.AsString),
                        ToRegional(CdsRoutePointsLon.AsString),
                        ReplaceAll(CdsRoutePointsAddress.AsString, [#13#10, #10], [', ',', ']) ]);
        Writer.WriteLine(Lst.DelimitedText);
        CdsRoutePoints.Next;
      end;
    finally
      Lst.Free;
    end;
  finally
    Writer.Free;
    CdsRoutePoints.EnableControls;
  end;
end;

function TDmRoutePoints.KurvigerURL: string;
begin
  result := TTripList(FTripList).KurvigerUrl;
end;

end.
