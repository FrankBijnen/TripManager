// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitGPX.pas' rev: 36.00 (Windows)

#ifndef UnitGPXHPP
#define UnitGPXHPP

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
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <System.IniFiles.hpp>
#include <System.Math.hpp>
#include <Xml.XMLIntf.hpp>
#include <UnitVerySimpleXml.hpp>
#include <kml_helper.hpp>
#include <OSM_helper.hpp>
#include <UnitMapUtils.hpp>
#include <unitTripObjects.hpp>
#include <UnitGpi.hpp>
#include <UnitBmp.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitgpx
{
//-- forward type declarations -----------------------------------------------
struct TCoord;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TDistanceUnit : unsigned char { duKm, duMi };

enum DECLSPEC_DENUM TProcessCategory : unsigned char { pcSymbol, pcGPX };

enum DECLSPEC_DENUM TProcessCategoryFor : unsigned char { pcfNone, pcfWayPt, pcfViaPt, pcfShapePt };

enum DECLSPEC_DENUM TShapingPointName : unsigned char { Unchanged, Route_Sequence, Route_Distance, Sequence_Route, Distance_Route };

struct DECLSPEC_DRECORD TCoord
{
public:
	double Lat;
	double Lon;
};


enum DECLSPEC_DENUM TGPXFunc : unsigned char { Unglitch, CreateTracks, CreateRoutePoints, CreatePOI, CreateKML, CreateOSM, CreatePoly, CreateRoutes, CreateTrips, CreateOSMPoints };

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool CreateSubDir;
extern DELPHI_PACKAGE System::UnicodeString ForceOutDir;
extern DELPHI_PACKAGE bool ProcessBegin;
extern DELPHI_PACKAGE bool ProcessEnd;
extern DELPHI_PACKAGE bool ProcessShape;
extern DELPHI_PACKAGE bool ProcessVia;
extern DELPHI_PACKAGE bool ProcessSubClass;
extern DELPHI_PACKAGE bool ProcessFlags;
extern DELPHI_PACKAGE bool ProcessViaPts;
extern DELPHI_PACKAGE bool ProcessWayPts;
extern DELPHI_PACKAGE bool ProcessTracks;
extern DELPHI_PACKAGE bool UniqueTracks;
extern DELPHI_PACKAGE bool ProcessWayPtsFromRoute;
extern DELPHI_PACKAGE bool DeleteWayPtsInRoute;
extern DELPHI_PACKAGE bool DeleteTracksInRoute;
extern DELPHI_PACKAGE bool ProcessShapePtsInGpi;
extern DELPHI_PACKAGE bool ProcessViaPtsInGpi;
extern DELPHI_PACKAGE bool ProcessWayPtsInGpi;
extern DELPHI_PACKAGE System::Set<TProcessCategory, TProcessCategory::pcSymbol, TProcessCategory::pcGPX> ProcessCategory;
extern DELPHI_PACKAGE System::Set<TProcessCategoryFor, TProcessCategoryFor::pcfNone, TProcessCategoryFor::pcfShapePt> ProcessCategoryFor;
extern DELPHI_PACKAGE System::UnicodeString ProcessCategoryPick;
extern DELPHI_PACKAGE bool ProcessDistance;
extern DELPHI_PACKAGE HWND LookUpWindow;
extern DELPHI_PACKAGE unsigned LookUpMessage;
extern DELPHI_PACKAGE bool ProcessAddrBegin;
extern DELPHI_PACKAGE bool ProcessAddrEnd;
extern DELPHI_PACKAGE bool ProcessAddrVia;
extern DELPHI_PACKAGE bool ProcessAddrShape;
extern DELPHI_PACKAGE bool ProcessAddrWayPt;
extern DELPHI_PACKAGE Unitgpi::TGPXString IniProximityStr;
#define DirectRoutingClass L"000000000000FFFFFFFFFFFFFFFFFFFFFFFF"
extern DELPHI_PACKAGE double UnglitchTreshold;
extern DELPHI_PACKAGE System::UnicodeString BeginStr;
extern DELPHI_PACKAGE System::UnicodeString BeginSymbol;
extern DELPHI_PACKAGE System::UnicodeString EndStr;
extern DELPHI_PACKAGE System::UnicodeString EndSymbol;
extern DELPHI_PACKAGE TShapingPointName ShapingPointName;
extern DELPHI_PACKAGE System::UnicodeString ShapingPointSymbol;
extern DELPHI_PACKAGE System::UnicodeString ShapingPointCategory;
extern DELPHI_PACKAGE System::UnicodeString ViaPointSymbol;
extern DELPHI_PACKAGE System::UnicodeString ViaPointCategory;
extern DELPHI_PACKAGE System::UnicodeString DefTrackColor;
extern DELPHI_PACKAGE System::UnicodeString TrackColor;
extern DELPHI_PACKAGE System::UnicodeString KMLTrackColor;
extern DELPHI_PACKAGE System::UnicodeString OSMTrackColor;
extern DELPHI_PACKAGE System::UnicodeString DebugComments;
extern DELPHI_PACKAGE TDistanceUnit DistanceUnit;
#define CatSymbol L"Symbol:"
#define CatGPX L"GPX:"
#define DefWaypointSymbol L"Waypoint"
extern DELPHI_PACKAGE Unittripobjects::TZumoModel ZumoModel;
extern DELPHI_PACKAGE System::UnicodeString ExploreUuid;
extern DELPHI_PACKAGE System::UnicodeString VehicleProfileGuid;
extern DELPHI_PACKAGE System::UnicodeString VehicleProfileHash;
extern DELPHI_PACKAGE System::UnicodeString VehicleId;
extern DELPHI_PACKAGE Unitgpi::TGPXString __fastcall ReadConfigParm(Unitgpi::TGPXString ASection, Unitgpi::TGPXString AKey, Unitgpi::TGPXString Default = System::UTF8String());
extern DELPHI_PACKAGE void __fastcall ReadConfigFromIni();
extern DELPHI_PACKAGE System::UnicodeString __fastcall FindSubNodeValue(Unitverysimplexml::TXmlVSNode* ANode, System::UnicodeString SubName);
extern DELPHI_PACKAGE Unitverysimplexml::TXmlVSNode* __fastcall InitRoot(Unitverysimplexml::TXmlVSDocument* WptTracksXml);
extern DELPHI_PACKAGE void __fastcall AnalyzeGpx(const System::UnicodeString GPXFile, Unitverysimplexml::TXmlVSNodeList* &OutWayPointList, Unitverysimplexml::TXmlVSNodeList* &OutWayPointFromRouteList, Unitverysimplexml::TXmlVSNodeList* &OutRouteViaPointList, Unitverysimplexml::TXmlVSNodeList* &OutTrackList);
extern DELPHI_PACKAGE void __fastcall DoFunction(const TGPXFunc *AllFuncs, const System::NativeInt AllFuncs_High, const System::UnicodeString GPXFile, System::Classes::TStringList* const OutStringList = (System::Classes::TStringList*)(0x0), const unsigned SeqNo = (unsigned)(0x0));
}	/* namespace Unitgpx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITGPX)
using namespace Unitgpx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitGPXHPP
