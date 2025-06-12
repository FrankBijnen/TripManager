unit UnitGeoCode;

interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections, System.IniFiles,
  Winapi.Windows,
  Vcl.Edge;

const
  DefState                = 'ISO3166-2-lvl4,state';
  DefCity                 = 'village,town,city,municipality,hamlet';
  DefRoadHouse            = 'road+house_number';
  DefHouseRoad            = 'house_number+road';
  DefCountry              = 'country';
  DefPostalCode           = 'postcode';

type

  TExecRestEvent = procedure(Url, Response: string; Succes: boolean) of object;

  GEOsettingsRec = record
    GeoCodeUrl: string;
    GeoCodeApiKey: string;
    AddressFormat: string;
    ThrottleGeoCode: integer;
  end;

  TPlace = class
  private
    FAddressList : TStringList;
    function GetHtmlPlace: string;
    function GetDisplayPlace: string;
    function GetFormattedAddress(AnAddressFormat: string): string; overload;
    function GetFormattedAddress: string; overload;
    function GetRoutePlace: string;
    function GetRoad: string;
    function GetCity: string;
    function GetState: string;
    function GetCountry: string;
    function GetPostalCode: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AssignFromGeocode(Key, Value: string);
    class function UnEscape(Value: string): string;
    property HtmlPlace: string read GetHtmlPlace;
    property DisplayPlace: string read GetDisplayPlace;
    property RoutePlace: string read GetRoutePlace;
    property FormattedAddress: string read GetFormattedAddress;
    property Road: string read GetRoad;
    property City: string read GetCity;
    property State: string read GetState;
    property Country: string read GetCountry;
    property PostalCode: string read GetPostalCode;
  end;

function GetPlaceOfCoords(const Lat, Lon: string; hWnd: HWND = 0; Msg: UINT = 0; UseCache: boolean = true): TPlace;
procedure GetCoordsOfPlace(const Place: string; var Lat, Lon: string);
procedure ReadGeoCodeSettings;
procedure ClearCoordCache;

const
  Place_Decimals = 4;

var
  GeoSettings: GEOsettingsRec;
  ExecRestEvent: TExecRestEvent;
  GeoCodeCache: string;

implementation

uses
  System.Variants, System.JSON,  System.NetEncoding, System.Math, System.StrUtils, System.DateUtils,
  Vcl.Dialogs,
  REST.Types, REST.Client, REST.Utils,
  UnitStringUtils, UnitRegistry,
  UFrmPLaces, UFrmGeoSearch;

const
  StrInvalidJson = 'Json Invalid %s';

var
  LastQuery: TDateTime;
  CoordCache: TObjectDictionary<string, TPlace>;

constructor TPlace.Create;
begin
  inherited Create; // Does nothing
  FAddressList := TStringList.Create;
end;

destructor TPlace.Destroy;
begin
  Clear;
  FAddressList.Free;
  inherited;
end;

procedure TPlace.Clear;
begin
{}
end;

class function TPlace.UnEscape(Value: string): string;
begin
  result := Value;
  if (LeftStr(Value, 1) = '"') and
     (RightStr(Value, 1) = '"') then
    result := Copy(result, 2, Length(result) -2);
  result := ReplaceAll(result, ['\/'], ['/']); // Belgium
end;

procedure TPlace.AssignFromGeocode(Key, Value: string);
begin
  FAddressList.AddPair(Key, Value);
end;

function TPlace.GetFormattedAddress(AnAddressFormat: string): string;
var
  AAddressFormat: string;
  AField: string;
  ABackup: string;
  AFieldValue: string;
  SubFieldChar: char;
  Index: integer;
begin
  result := '';
  AAddressFormat := AnAddressFormat;
  while (AAddressFormat <> '') do
  begin
    AField := NextField(AAddressFormat, '|');

    // Show Debug info?
    if (SameText('debug', AField)) then
    begin
      if (result <> '') then
        result := result + ', ';
      result := result + '*****Debug info*****';
      for Index := 0 to FAddressList.Count -1 do
      begin
        if (result <> '') then
          result := result + ', ';
        result := result + FAddressList.KeyNames[Index] + ':' +
                           ReplaceAll(FAddressList.ValueFromIndex[Index], [','], ['&#44;'], [rfReplaceAll]); // Dont add extra lines
      end;
      result := result + ', *****Debug info*****';
      continue;
    end;

    SubFieldChar := ',';
    if (Pos('+', AField) > 0) then
      SubFieldChar := '+';
    AFieldValue := '';
    while (AField <> '') and
          ((AFieldValue = '') or (SubFieldChar = '+')) do
    begin
      ABackup := Trim(NextField(AField, SubFieldChar));
      if (SubFieldChar = ',') then
        AFieldValue := FAddressList.Values[ABackup]
      else
      begin
        if (FAddressList.Values[ABackup] = '') then
          continue;
        if (AFieldValue <> '') then
          AFieldValue := AFieldValue + ' ';
        AFieldValue := AFieldValue + FAddressList.Values[ABackup];
      end;
    end;
    if (AFieldValue <> '') then
    begin
      if (result <> '') then
        result := result + ', ';
      result := result + AFieldValue;
    end;
  end;
end;

function TPlace.GetFormattedAddress: string;
begin
  result := GetFormattedAddress(GeoSettings.AddressFormat);
end;

function TPlace.GetHtmlPlace: string;
begin
  result := ReplaceAll(TPlace.UnEscape(FormattedAddress), [', '], ['<br>'], [rfReplaceAll]);
end;

function TPlace.GetDisplayPlace: string;
begin
  result := ReplaceAll(TPlace.UnEscape(FormattedAddress), [', ', '&#44;'], [#13#10, ','], [rfReplaceAll]);
end;

function TPlace.GetRoutePlace: string;
begin
  result := ReplaceAll(TPlace.UnEscape(FormattedAddress), ['&#44;'], [','], [rfReplaceAll]);
end;

function TPlace.GetRoad: string;
begin
  result := GetFormattedAddress(DefRoadHouse);
end;

function TPlace.GetCity: string;
begin
  result := GetFormattedAddress(DefCity);
end;

function TPlace.GetState: string;
begin
  result := GetFormattedAddress(DefState);
end;

function TPlace.GetCountry: string;
begin
  result := GetFormattedAddress(DefCountry);
end;

function TPlace.GetPostalCode: string;
begin
  result := GetFormattedAddress(DefPostalCode);
end;

procedure Throttle(const Delay: Int64);
var Diff: Int64;
begin
  Diff := Delay - MilliSecondsBetween(Now, LastQuery);
  if (Diff > 0) then
    Sleep(Diff);
end;

function ExecuteRest(const RESTRequest: TRESTRequest): boolean;
var
  ARestParm: TRESTRequestParameter;
begin
  result := true;
  try
    try
      Throttle(GeoSettings.ThrottleGeoCode);
      RESTRequest.Execute;
      LastQuery := Now;
      if (RESTRequest.Response.StatusCode >= 400) then
        raise exception.Create('Request failed with' + #10 + RESTRequest.Response.StatusText);
    except
      on E:Exception do
      begin
        result := false;
        if (not Assigned(ExecRestEvent)) then
          ShowMessage(E.Message);
      end;
    end;
  finally
    if Assigned(ExecRestEvent) then
    begin
      // The Caller will free the params right after this request.
      // No need to restore.
      for ARestParm in RESTRequest.Params do
        ARestParm.Options := [TRESTRequestParameterOption.poDoNotEncode];
      ExecRestEvent(RESTRequest.GetFullRequestURL(true) + #10, RESTRequest.Response.Content, result);
    end;
  end;
end;

function GetPlaceOfCoords_GeoCode(const Lat, Lon: string; UseCache: boolean): TPlace;
var
  RESTClient:   TRESTClient;
  RESTRequest:  TRESTRequest;
  RESTResponse: TRESTResponse;
  JSONObject:   TJSONObject;
  JSONAddress:  TJSONObject;
  JSONPair:     TJSONPair;
  LatE, LonE:   string;
begin
  result := TPlace.Create;
  LatE := Trim(Lat);
  LonE := Trim(Lon);

  RESTClient := TRESTClient.Create(GeoSettings.GeoCodeUrl);
  RESTResponse := TRESTResponse.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);
  RESTRequest.Client := RESTClient;
  RESTRequest.Resource := 'reverse';
  RESTRequest.Response := RESTResponse;
  try
    RESTRequest.Params.Clear;
    RESTRequest.Params.AddItem('lat', LatE, TRESTRequestParameterKind.pkGETorPOST);
    RESTRequest.Params.AddItem('lon', LonE, TRESTRequestParameterKind.pkGETorPOST);

    if (GeoSettings.GeoCodeApiKey <> '') then
      RESTRequest.params.AddItem('api_key', GeoSettings.GeoCodeApiKey , TRESTRequestParameterKind.pkGETorPOST);

    if not ExecuteRest(RESTRequest) then
      exit;

    if not RESTResponse.JSONValue.TryGetValue(JSONObject) then
      raise Exception.Create(Format(StrInvalidJson, [RESTResponse.Content]));

    result.AssignFromGeocode('coords', LatE + ',' + LonE);
    if (JSONObject.FindValue('display_name') <> nil) then
      result.AssignFromGeocode('display_name',
                               TPlace.UnEscape(JSONObject.GetValue('display_name').ToString)
                              );
    if (JSONObject.FindValue('address') <> nil) then
    begin
      JSONAddress := JSONObject.GetValue<TJSONObject>('address');
      for JSONPair in JSONAddress do
        result.AssignFromGeocode(TPlace.UnEscape(JSONPair.JsonString.ToString),
                                 TPlace.UnEscape(JSONPair.JsonValue.ToString)
                                );
    end;

  finally
    RESTResponse.Free;
    RESTRequest.Free;
    RESTClient.Free;
  end;
end;

function GetPlaceOfCoords(const Lat, Lon: string; hWnd: HWND = 0; Msg: UINT = 0; UseCache: boolean = true): TPlace;
var CoordsKey: string;
    LatP, LonP: string;
    CrWait, CrNormal: HCURSOR;
begin
  result := nil;
  if (GeoSettings.GeoCodeApiKey = '') then
    exit;

  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    LatP := Lat;
    LonP := Lon;
    AdjustLatLon(LatP, LonP, Place_Decimals);
    CoordsKey := LatP + ',' + LonP;
    if (UseCache) and
       (CoordCache.ContainsKey(CoordsKey)) then
    begin
      result := CoordCache.Items[CoordsKey];
      exit;
    end;

    result := GetPlaceOfCoords_GeoCode(Lat, Lon, UseCache);

    // Also cache if not found
    if (CoordCache.ContainsKey(CoordsKey)) then // Prevent Duplicates not allowed
      CoordCache.Remove(CoordsKey);
    CoordCache.Add(CoordsKey, result);
    if (hWnd <> 0) and
       (Msg <> 0) then
      SendMessage(hWnd, Msg, 0, LPARAM(result));
  finally
    SetCursor(CrNormal);
  end;
end;

procedure ClearCoordCache;
begin
  CoordCache.Clear;
end;

function ChooseLocation(var Lat, Lon: string): integer;
begin
  Lat := '';
  Lon := '';
  with FrmPlaces do
  begin
    result := ShowModal;
    if (result <> IDOK) then
      exit;

    if (Listview1.Selected = nil) then
      exit;
    Lat := Listview1.Selected.Caption;
    Lon := Listview1.Selected.Subitems[0];
  end;
end;

function GetCoordsOfPlace_GeoCode(var Lat, Lon: string):integer;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JValue: TJSONValue;
  Places: TJSONArray;
begin
  result := IDRETRY;
  Lat := '';
  Lon := '';

  RESTClient := TRESTClient.Create(GeoSettings.GeoCodeUrl);
  RESTResponse := TRESTResponse.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);
  RESTRequest.Client := RESTClient;
  RESTRequest.Resource := 'search';
  RESTRequest.Response := RESTResponse;
  try
    RESTRequest.params.Clear;
    if (FGeoSearch.PctMain.TabIndex = 0) and
       (FGeoSearch.EdSearchFree.Text <> '') then
      RESTRequest.params.AddItem('q', FGeoSearch.EdSearchFree.Text, TRESTRequestParameterKind.pkGETorPOST)
    else
    begin
      if (FGeoSearch.EdStreet.Text <> '') then
        RESTRequest.params.AddItem('street', FGeoSearch.EdStreet.Text, TRESTRequestParameterKind.pkGETorPOST);
      if (FGeoSearch.EdCity.Text <> '') then
        RESTRequest.params.AddItem('city', FGeoSearch.EdCity.Text, TRESTRequestParameterKind.pkGETorPOST);
      if (FGeoSearch.EdCounty.Text <> '') then
        RESTRequest.params.AddItem('county', FGeoSearch.EdCounty.Text, TRESTRequestParameterKind.pkGETorPOST);
      if (FGeoSearch.EdState.Text <> '') then
        RESTRequest.params.AddItem('state', FGeoSearch.EdState.Text, TRESTRequestParameterKind.pkGETorPOST);
      if (FGeoSearch.EdCountry.Text <> '') then
        RESTRequest.params.AddItem('country', FGeoSearch.EdCountry.Text, TRESTRequestParameterKind.pkGETorPOST);
      if (FGeoSearch.EdPostalCode.Text <> '') then
        RESTRequest.params.AddItem('postalcode', FGeoSearch.EdPostalCode.Text, TRESTRequestParameterKind.pkGETorPOST);
    end;

    if (RESTRequest.params.Count = 0) then
    begin
      ShowMessage('Enter some search criteria');
      exit;
    end;

    if (GeoSettings.GeoCodeApiKey <> '') then
      RESTRequest.params.AddItem('api_key', GeoSettings.GeoCodeApiKey , TRESTRequestParameterKind.pkGETorPOST);

    if not ExecuteRest(RESTRequest) then
      exit;

    if not RESTResponse.JSONValue.TryGetValue(Places) then
      raise Exception.Create(Format(StrInvalidJson, [RESTResponse.Content]));

    for JValue in Places do
      FrmPlaces.AddPlace2LV(JValue.GetValue<string>('display_name'), JValue.GetValue<string>('lat'), JValue.GetValue<string>('lon'));
    result := ChooseLocation(Lat, Lon);
  finally
    RESTResponse.Free;
    RESTRequest.Free;
    RESTClient.Free;
  end;
end;

procedure GetCoordsOfPlace(const Place: string; var Lat, Lon: string);
var
  CrWait, CrNormal: HCURSOR;
  RetrySearch: boolean;
begin
  Lat := '';
  Lon := '';
  if (GeoSettings.GeoCodeApiKey = '') then
    exit;
  FGeoSearch.EdSearchFree.Text := Trim(Place);

  repeat
    if (FGeoSearch.ShowModal <> IDOK) then
      exit;

    CrWait := LoadCursor(0, IDC_WAIT);
    CrNormal := SetCursor(CrWait);

    FrmPlaces.ListView1.Items.Clear;
    try
      RetrySearch := (GetCoordsOfPlace_GeoCode(Lat, Lon) = IDRETRY);
    finally
      SetCursor(CrNormal);
    end;
  until (not RetrySearch);
end;

// https://wiki.openstreetmap.org/wiki/Key:place
procedure ReadGeoCodeSettings;
begin
  GeoSettings.GeoCodeUrl := GetRegistry(Reg_GeoCodeUrl, 'https://geocode.maps.co');
  GeoSettings.GeoCodeApiKey := GetRegistry(Reg_GeoCodeApiKey, '');
  GeoSettings.AddressFormat := GetRegistry(Reg_AddressFormat, DefState + '|' + DefCity + '|' + DefRoadHouse);
  GeoSettings.ThrottleGeoCode := GetRegistry(Reg_ThrottleGeoCode, 1000);
end;

procedure ReadCoordCache;
var
  ALine, CoordsKey: string;
  F: TextFile;
  Place: TPlace;
begin
  if not (FileExists(GeoCodeCache)) then
    exit;
  AssignFile(F, GeoCodeCache, CP_UTF8);
  Reset(F);
  while not Eof(F) do
  begin
    ReadLn(F, ALine);
    CoordsKey := NextField(Aline, '/t');
    ALine := ReplaceAll(ALine, ['/r/n'], [#13#10]);
    Place := TPlace.Create;
    Place.FAddressList.Text := ALine;
    CoordCache.Add(CoordsKey, Place);
  end;
  CloseFile(F);
end;

procedure WriteCoordCache;
var
  CoordKey: string;
  F: TextFile;
begin
  AssignFile(F, GeoCodeCache, CP_UTF8);
  Rewrite(F);
  for CoordKey in CoordCache.Keys do
  begin
    Write(F, CoordKey, '/t');
    Writeln(F, ReplaceAll(CoordCache.Items[CoordKey].FAddressList.Text, [#13#10], ['/r/n']));
  end;
  CloseFile(F);
end;

initialization
begin
  GeoCodeCache := IncludeTrailingPathDelimiter(GetAppData) + 'GeoCode.cache';
  CoordCache := TObjectDictionary<string, TPlace>.Create([doOwnsValues]);
  ReadCoordCache;
  LastQuery := 0;
end;

finalization
begin
  WriteCoordCache;
  CoordCache.Free;
end;

end.
