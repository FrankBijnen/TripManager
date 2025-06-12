unit UnitRegistry;

interface

uses
  System.Win.Registry, System.TypInfo, Winapi.Windows;

const
  Reg_TripManagerKey          = 'Software\TDBware\TripManager';
  Reg_FuncTrip                = 'FuncTrip';
  Reg_FuncTrack               = 'FuncTrack';
  Reg_FuncRoute               = 'FuncRoute';
  Reg_FuncWayPoint            = 'FuncWayPoint';
  Reg_FuncWayPointWpt         = 'FuncWayPointWpt';
  Reg_FuncWayPointVia         = 'FuncWayPointVia';
  Reg_FuncWayPointShape       = 'FuncWayPointShape';
  Reg_FuncGpi                 = 'FuncGpi';
  Reg_FuncGpiWayPt            = 'FuncGpiWayPt';
  Reg_FuncGpiViaPt            = 'FuncGpiViaPt';
  Reg_FuncGpiShpPt            = 'FuncGpiShpPt';
  Reg_FuncKml                 = 'FuncKml';
  Reg_FuncHtml                = 'FuncHtml';

  Reg_TrackColor              = 'TrackColor';
  Reg_ExploreUuid             = 'ExploreUuid';
  Reg_VehicleProfileGuid      = 'VehicleProfileGuid';
  Reg_VehicleProfileHash      = 'VehicleProfileHash';
  Reg_VehicleId               = 'VehicleId';

  Reg_ProcessBegin            = 'ProcessBegin';
  Reg_ZumoModel               = 'ZumoModel';
  Reg_BeginSymbol             = 'BeginSymbol';
  Reg_BeginStr                = 'BeginStr';
  Reg_BeginAddress            = 'BeginAddress';

  Reg_ProcessEnd              = 'ProcessEnd';
  Reg_EndSymbol               = 'EndSymbol';
  Reg_EndStr                  = 'EndStr';
  Reg_EndAddress              = 'EndAddress';

  Reg_ProcessWpt              = 'ProcessWpt';
  Reg_ProcessCategory         = 'ProcessCategory';
  Reg_WayPtAddress            = 'WayPtAddress';

  Reg_ProcessVia              = 'ProcessVia';
  Reg_ViaAddress              = 'ViaAddress';

  Reg_ProcessShape            = 'ProcessShape';
  Reg_ShapingName             = 'ShapingName';
  Reg_DistanceUnit            = 'DistanceUnit';
  Reg_ShapeAddress            = 'ShapeAddress';


  Reg_PrefFileSysFolder_Key   = 'PrefFileSysFolder';
  Reg_PrefFileSysFolder_Val   = 'rfDesktop';
  Reg_PrefDev_Key             = 'PrefDevice';
  Reg_PrefDevTripsFolder_Key  = 'PrefDeviceTripsFolder';
  Reg_PrefDevTripsFolder_Val  = 'Internal Storage\.System\Trips';
  Reg_PrefDevGpxFolder_Key    = 'PrefDeviceGpxFolder';
  Reg_PrefDevGpxFolder_Val    = 'Internal Storage\GPX';
  Reg_PrefDevPoiFolder_Key    = 'PrefDevicePoiFolder';
  Reg_PrefDevPoiFolder_Val    = 'Internal Storage\POI';
  Reg_WarnModel_Key           = 'WarnModel';
  Reg_TripColor_Key           = 'TripColor';
  Reg_TripColor_Val           = 'Magenta';
  Reg_Maximized_Key           = 'Maximized';
  Reg_WidthColumns_Key        = 'WidthColumns';
  Reg_WidthColumns_Val        = '145,55,75,100';
  Reg_SortColumn_Key          = 'SortColumn';
  Reg_SortAscending_Key       = 'SortAscending';
  Reg_RoutePointTimeOut_Key   = 'RoutePointTimeOut';
  Reg_RoutePointTimeOut_Val   = '5000';
  Reg_GeoSearchTimeOut_Key    = 'GeoSearchTimeOut';
  Reg_GeoSearchTimeOut_Val    = '8000';

  Reg_TransferRoute           = 'TransferRoute';
  Reg_SavedMapPosition_Key    = 'SavedMapPosition';
  Reg_DefaultCoordinates      = '48.854918, 2.346558'; // Somewhere in Paris

  BooleanValues: array[boolean] of string = ('False', 'True');

function GetRegistry(const Name: string; const Default: string = ''): string; overload;
function GetRegistry(const Name: string; const Default: boolean): boolean; overload;
function GetRegistry(const Name: string; const Default: integer): integer; overload;
function GetRegistry(const Name: string; const Default: integer; AType: PTypeInfo): integer; overload;

procedure SetRegistry(const Name, Value: string); overload;
procedure SetRegistry(const Name: string; Value: boolean); overload;
procedure SetRegistry(const Name: string; Value: integer); overload;

implementation

uses
  System.SysUtils;

function GetRegistryValue(const ARootKey: HKEY; const KeyName, Name: string; const Default: string=''): string;
var Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := ARootKey;
    // False because we do not want to create it if it doesn't exist
    if (Registry.OpenKey(KeyName, False)) then
      result := Registry.ReadString(Name);
  finally
    Registry.Free;
  end;
  if (result = '') then
    result := Default;
end;

function GetRegistry(const Name: string; const Default: string = ''): string;
begin
  result := GetRegistryValue(HKEY_CURRENT_USER, Reg_TripManagerKey, Name, Default);
end;

function GetRegistry(const Name: string; const Default: boolean): boolean;
begin
  result := SameText(GetRegistryValue(HKEY_CURRENT_USER, Reg_TripManagerKey, Name, BooleanValues[Default]), BooleanValues[True]);
end;

function GetRegistry(const Name: string; const Default: integer): integer;
begin
  result := StrToint(GetRegistryValue(HKEY_CURRENT_USER, Reg_TripManagerKey, Name, IntToStr(Default)));
end;

function GetRegistry(const Name: string; const Default: integer; AType: PTypeInfo): integer;
begin
  result := GetEnumValue(AType, GetRegistry(Name, GetEnumName(AType, Default)));
end;

procedure SetRegistryValue(const ARootKey: HKEY; const KeyName, Name, Value: string);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_WRITE);
  try
    Registry.RootKey := ARootKey;
    Registry.OpenKey(KeyName, True);
    Registry.WriteString(Name, Value);
  finally
    Registry.Free;
  end;
end;

procedure SetRegistry(const Name, Value: string);
begin
  SetRegistryValue(HKEY_CURRENT_USER, Reg_TripManagerKey, Name, Value);
end;

procedure SetRegistry(const Name: string; Value: boolean);
begin
  SetRegistryValue(HKEY_CURRENT_USER, Reg_TripManagerKey, Name, BooleanValues[Value]);
end;

procedure SetRegistry(const Name: string; Value: integer);
begin
  SetRegistryValue(HKEY_CURRENT_USER, Reg_TripManagerKey, Name, IntToStr(Value));
end;

end.
