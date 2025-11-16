// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitRegistryKeys.pas' rev: 36.00 (Windows)

#ifndef UnitRegistryKeysHPP
#define UnitRegistryKeysHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <UnitGpxDefs.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitregistrykeys
{
//-- forward type declarations -----------------------------------------------
struct TGarminDevice;
class DELPHICLASS TSetProcessOptions;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TGarminDevice
{
public:
	Unitgpxdefs::TGarminModel GarminModel;
	System::UnicodeString ModelDescription;
	System::UnicodeString GpxPath;
	System::UnicodeString GpiPath;
	System::UnicodeString CoursePath;
	System::UnicodeString NewFilesPath;
	System::UnicodeString ActivitiesPath;
	void __fastcall Init();
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TSetProcessOptions : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	void __fastcall SetFixedPrefs(System::TObject* Sender);
	void __fastcall SetPostProcessPrefs(System::TObject* Sender);
	void __fastcall SetSendToPrefs(System::TObject* Sender);
	void __fastcall SetCmdLinePrefs(System::TObject* Sender);
	void __fastcall SetSkipTrackDlgPrefs(System::TObject* Sender);
	void __fastcall SavePrefs(System::TObject* Sender);
	__classmethod void __fastcall SetPrefs(System::TObject* TvSelections);
	__classmethod Unitgpxdefs::TGPXFuncArray __fastcall StorePrefs(System::TObject* TvSelections);
	__classmethod System::Classes::TStringList* __fastcall GetKnownDevices();
	__classmethod System::UnicodeString __fastcall GetKnownDevice(int DevIndex);
	__classmethod System::Classes::TStringList* __fastcall GetDefaultDevices();
	__classmethod System::UnicodeString __fastcall GetDefaultDevice(int DevIndex);
	__classmethod Unitgpxdefs::TGarminModel __fastcall GetModelFromDescription(const System::UnicodeString ModelDescription);
	__classmethod System::UnicodeString __fastcall GetKnownPath(int DevIndex, int PathId);
public:
	/* TObject.Create */ inline __fastcall TSetProcessOptions() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TSetProcessOptions() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define InternalStorage L"Internal Storage\\"
#define NonMTPRoot L"?:\\"
#define Garmin L"Garmin"
#define SettingsDb L"settings.db"
#define ProfileDb L"vehicle_profile.db"
#define GarminDeviceXML L"GarminDevice.xml"
#define Reg_GPISymbolSize L"GPISymbolsSize"
#define Reg_GPIProximity L"GPIProximity"
#define Reg_TrackColor L"TrackColor"
#define Reg_MinDistTrackPoints_Key L"MinDistTrackPoints"
#define Reg_ScPosn_Unknown1 L"ScPosn_Unknown1"
#define Reg_AllowGrouping L"AllowGrouping"
#define Reg_TripOption L"TripOption"
#define Reg_DefAdvLevel L"DefAdvLevel"
#define Reg_VehicleProfileGuid L"VehicleProfileGuid"
#define Reg_VehicleProfileHash L"VehicleProfileHash"
#define Reg_VehicleId L"VehicleId"
#define Reg_VehicleProfileTruckType L"VehicleProfileTruckType"
#define Reg_AvoidancesChangedTimeAtSave L"AvoidancesChangedTimeAtSave"
#define Reg_VehicleProfileName L"VehicleProfileName"
#define Reg_VehicleType L"VehicleType"
#define Reg_VehicleTransportMode L"VehicleTransportMode"
#define Reg_ProcessBegin L"ProcessBegin"
#define Reg_CurrentModel L"CurrentModel"
#define Reg_BeginSymbol L"BeginSymbol"
#define Reg_BeginStr L"BeginStr"
#define Reg_BeginAddress L"BeginAddress"
#define Reg_ProcessEnd L"ProcessEnd"
#define Reg_EndSymbol L"EndSymbol"
#define Reg_EndStr L"EndStr"
#define Reg_EndAddress L"EndAddress"
#define Reg_ProcessWpt L"ProcessWpt"
#define Reg_ProcessCategory L"ProcessCategory"
#define Reg_WayPtAddress L"WayPtAddress"
#define Reg_ProcessVia L"ProcessVia"
#define Reg_ViaAddress L"ViaAddress"
#define Reg_ProcessShape L"ProcessShape"
#define Reg_ShapingName L"ShapingName"
#define Reg_DistanceUnit L"DistanceUnit"
#define Reg_ShapeAddress L"ShapeAddress"
#define Reg_CompareDistOK_Key L"CompareDistOK"
static _DELPHI_CONST System::Word Reg_CompareDistOK_Val = System::Word(0x1f4);
#define Reg_PrefFileSysFolder_Key L"PrefFileSysFolder"
#define Reg_PrefFileSysFolder_Val L"rfDesktop"
#define Reg_PrefDev_Key L"PrefDevice"
#define Reg_PrefDevTripsFolder_Key L"PrefDeviceTripsFolder"
#define Reg_PrefDevTripsFolder_Val L"Internal Storage\\.System\\Trips"
#define Reg_PrefDevGpxFolder_Key L"PrefDeviceGpxFolder"
#define Reg_PrefDevGpxFolder_Val L"Internal Storage\\GPX"
#define Reg_PrefDevPoiFolder_Key L"PrefDevicePoiFolder"
#define Reg_PrefDevPoiFolder_Val L"Internal Storage\\POI"
#define Reg_EnableDirFuncs L"EnableDirFuncs"
#define Reg_EnableFitFuncs L"EnableFitFuncs"
#define Reg_EnableTripFuncs L"EnableTripFuncs"
#define Reg_TripColor_Key L"TripColor"
#define Reg_TripColor_Val L"Magenta"
#define Reg_Maximized_Key L"Maximized"
#define Reg_WidthColumns_Key L"WidthColumns"
#define Reg_WidthColumns_Val L"145,55,75,100"
#define Reg_SortColumn_Key L"SortColumn"
#define Reg_SortAscending_Key L"SortAscending"
#define Reg_RoutePointTimeOut_Key L"RoutePointTimeOut"
#define Reg_RoutePointTimeOut_Val L"5000"
#define Reg_GeoSearchTimeOut_Key L"GeoSearchTimeOut"
#define Reg_GeoSearchTimeOut_Val L"8000"
#define Reg_SavedMapPosition_Key L"SavedMapPosition"
#define Reg_DefaultCoordinates L"48.854918, 2.346558"
static _DELPHI_CONST System::Int8 IdTrip = System::Int8(0x0);
static _DELPHI_CONST System::Int8 IdTrack = System::Int8(0x1);
static _DELPHI_CONST System::Int8 IdCompleteRoute = System::Int8(0x2);
static _DELPHI_CONST System::Int8 IdStrippedRoute = System::Int8(0x3);
static _DELPHI_CONST System::Int8 IdWayPoint = System::Int8(0x4);
static _DELPHI_CONST System::Int8 IdWayPointWpt = System::Int8(0x5);
static _DELPHI_CONST System::Int8 IdWayPointVia = System::Int8(0x6);
static _DELPHI_CONST System::Int8 IdWayPointShp = System::Int8(0x7);
static _DELPHI_CONST System::Int8 IdGpi = System::Int8(0x8);
static _DELPHI_CONST System::Int8 IdGpiWayPt = System::Int8(0x9);
static _DELPHI_CONST System::Int8 IdGpiViaPt = System::Int8(0xa);
static _DELPHI_CONST System::Int8 IdGpiShpPt = System::Int8(0xb);
static _DELPHI_CONST System::Int8 IdKml = System::Int8(0xc);
static _DELPHI_CONST System::Int8 IdHtml = System::Int8(0xd);
static _DELPHI_CONST System::Int8 IdFit = System::Int8(0xe);
#define Garmin_Name L"Garmin"
#define Edge_Name L"Edge"
extern DELPHI_PACKAGE TSetProcessOptions* SetProcessOptions;
extern DELPHI_PACKAGE TGarminDevice GarminDevice;
}	/* namespace Unitregistrykeys */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITREGISTRYKEYS)
using namespace Unitregistrykeys;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitRegistryKeysHPP
