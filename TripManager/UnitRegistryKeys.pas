unit UnitRegistryKeys;

interface

const
  Reg_GPISymbolSize           = 'GPISymbolsSize';
  Reg_GPIProximity            = 'GPIProximity';
  Reg_TrackColor              = 'TrackColor';     // User preferred track color

  // XT1 and XT2
  Reg_ZumoModel               = 'ZumoModel';
  Reg_ScPosn_Unknown1         = 'ScPosn_Unknown1';
  //XT2
  Reg_ExploreUuid                 = 'ExploreUuid';
  Reg_VehicleProfileGuid          = 'VehicleProfileGuid';
  Reg_VehicleProfileHash          = 'VehicleProfileHash';
  Reg_VehicleId                   = 'VehicleId';
  Reg_VehicleProfileTruckType     = 'VehicleProfileTruckType';
  Reg_AvoidancesChangedTimeAtSave = 'AvoidancesChangedTimeAtSave';
  Reg_VehicleProfileName          = 'VehicleProfileName';

  Reg_ProcessBegin            = 'ProcessBegin';
  Reg_CurrentDevice           = 'CurrentDevice';
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
  Reg_CompareDistOK_Key       = 'CompareDistOK';
  Reg_CompareDistOK_Val       = 500;

  Reg_PrefFileSysFolder_Key   = 'PrefFileSysFolder';
  Reg_PrefFileSysFolder_Val   = 'rfDesktop';
  Reg_PrefDev_Key             = 'PrefDevice';
  Reg_PrefDevTripsFolder_Key  = 'PrefDeviceTripsFolder';
  Reg_PrefDevTripsFolder_Val  = 'Internal Storage\.System\Trips';
  Reg_TripNameInList          = 'TripNameInList';

  Reg_PrefDevGpxFolder_Key    = 'PrefDeviceGpxFolder';
  Reg_PrefDevGpxFolder_Val    = 'Internal Storage\GPX';
  Reg_PrefDevPoiFolder_Key    = 'PrefDevicePoiFolder';
  Reg_PrefDevPoiFolder_Val    = 'Internal Storage\POI';
  Reg_EnableSendTo            = 'EnableSendTo';
  Reg_EnableDirFuncs          = 'EnableDirFuncs';
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

  Reg_SavedMapPosition_Key    = 'SavedMapPosition';
  Reg_DefaultCoordinates      = '48.854918, 2.346558'; // Somewhere in Paris

implementation

end.
