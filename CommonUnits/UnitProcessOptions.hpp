// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitProcessOptions.pas' rev: 36.00 (Windows)

#ifndef UnitProcessOptionsHPP
#define UnitProcessOptionsHPP

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
#include <Winapi.Windows.hpp>
#include <Vcl.ComCtrls.hpp>
#include <UnitGpxDefs.hpp>
#include <unitTripObjects.hpp>
#include <UnitGpi.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitprocessoptions
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TProcessOptions;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TProcessOptions : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	HWND LookUpWindow;
	unsigned LookUpMessage;
	bool ProcessSubClass;
	bool ProcessFlags;
	bool ProcessBegin;
	bool ProcessAddrBegin;
	System::UnicodeString BeginStr;
	System::UnicodeString BeginSymbol;
	bool ProcessEnd;
	bool ProcessAddrEnd;
	System::UnicodeString EndStr;
	System::UnicodeString EndSymbol;
	bool ProcessWpt;
	bool ProcessShape;
	System::UnicodeString DefShapePtSymbol;
	bool ProcessAddrShape;
	Unitgpxdefs::TShapingPointName ShapingPointName;
	System::UnicodeString DefShapingPointSymbol;
	System::UnicodeString ShapingPointCategory;
	bool ProcessVia;
	bool ProcessAddrVia;
	System::UnicodeString DefViaPointSymbol;
	System::UnicodeString ViaPointCategory;
	bool ProcessCreateRoutePoints;
	bool ProcessTracks;
	bool ProcessWayPtsFromRoute;
	bool ProcessWayPtsInWayPts;
	bool ProcessViaPtsInWayPts;
	bool ProcessShapePtsInWayPts;
	bool ProcessWayPtsInGpi;
	bool ProcessViaPtsInGpi;
	bool ProcessShapePtsInGpi;
	System::UnicodeString DefaultProximityStr;
	System::UTF8String GPISymbolsDir;
	bool ProcessDistance;
	Unitgpxdefs::TDistanceUnit DistanceUnit;
	int CompareDistanceOK;
	System::Set<Unitgpxdefs::TProcessCategory, Unitgpxdefs::TProcessCategory::pcSymbol, Unitgpxdefs::TProcessCategory::pcGPX> ProcessCategory;
	bool ProcessAddrWayPt;
	System::UnicodeString DefTrackColor;
	System::UnicodeString TrackColor;
	System::UnicodeString DefWaypointSymbol;
	System::UnicodeString CatSymbol;
	System::UnicodeString CatGPX;
	System::UnicodeString CatRoute;
	Unittripobjects::TZumoModel ZumoModel;
	unsigned ScPosn_Unknown1;
	System::UnicodeString ExploreUuid;
	System::UnicodeString VehicleProfileGuid;
	System::UnicodeString VehicleProfileHash;
	System::UnicodeString VehicleId;
	System::UnicodeString VehicleProfileTruckType;
	System::UnicodeString VehicleProfileName;
	unsigned AvoidancesChangedTimeAtSave;
	System::Classes::TNotifyEvent FOnSetFuncPrefs;
	System::Classes::TNotifyEvent FOnSavePrefs;
	__fastcall TProcessOptions(System::Classes::TNotifyEvent OnSetFuncPrefs, System::Classes::TNotifyEvent OnSavePrefs);
	__fastcall virtual ~TProcessOptions();
	void __fastcall DoPrefSaved();
	void __fastcall SetProcessCategory(bool ProcessWpt, System::UnicodeString WayPtCat);
	System::UnicodeString __fastcall DistanceStr();
	double __fastcall GetDistOKMeters();
	__property double DistOKMeters = {read=GetDistOKMeters};
	__classmethod void __fastcall SetPrefs(Vcl::Comctrls::TTreeView* TvSelections);
	__classmethod Unitgpxdefs::TGPXFuncArray __fastcall StorePrefs(Vcl::Comctrls::TTreeView* TvSelections);
};


//-- var, const, procedure ---------------------------------------------------
#define TripFilesFor L"Trip files (No import required, but will recalculate. Sele"\
	L"cted model: %s)"
#define Reg_FuncTrip L"FuncTrip"
#define Reg_FuncTrack L"FuncTrack"
#define Reg_FuncStrippedRoute L"FuncStrippedRoute"
#define Reg_FuncCompleteRoute L"FuncCompleteRoute"
#define Reg_FuncWayPoint L"FuncWayPoint"
#define Reg_FuncWayPointWpt L"FuncWayPointWpt"
#define Reg_FuncWayPointVia L"FuncWayPointVia"
#define Reg_FuncWayPointShape L"FuncWayPointShape"
#define Reg_FuncGpi L"FuncGpi"
#define Reg_FuncGpiWayPt L"FuncGpiWayPt"
#define Reg_FuncGpiViaPt L"FuncGpiViaPt"
#define Reg_FuncGpiShpPt L"FuncGpiShpPt"
#define Reg_FuncKml L"FuncKml"
#define Reg_FuncHtml L"FuncHtml"
extern DELPHI_PACKAGE System::Classes::TNotifyEvent OnSetFixedPrefs;
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
}	/* namespace Unitprocessoptions */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITPROCESSOPTIONS)
using namespace Unitprocessoptions;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitProcessOptionsHPP
