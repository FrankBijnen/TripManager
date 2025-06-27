// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitGPXObjects.pas' rev: 36.00 (Windows)

#ifndef UnitGPXObjectsHPP
#define UnitGPXObjectsHPP

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
#include <System.Math.hpp>
#include <Xml.XMLIntf.hpp>
#include <UnitVerySimpleXml.hpp>
#include <kml_helper.hpp>
#include <UFrmSelectGPX.hpp>
#include <unitTripObjects.hpp>
#include <UnitGpi.hpp>
#include <UnitBmp.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Xml.VerySimple.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitgpxobjects
{
//-- forward type declarations -----------------------------------------------
struct TCoord;
class DELPHICLASS TProcessOptions;
class DELPHICLASS TGPXFile;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TDistanceUnit : unsigned char { duKm, duMi };

enum DECLSPEC_DENUM TProcessCategory : unsigned char { pcSymbol, pcGPX };

enum DECLSPEC_DENUM TProcessPointType : unsigned char { pptNone, pptWayPt, pptViaPt, pptShapePt };

enum DECLSPEC_DENUM TShapingPointName : unsigned char { Unchanged, Route_Sequence, Route_Distance, Sequence_Route, Distance_Route };

struct DECLSPEC_DRECORD TCoord
{
public:
	double Lat;
	double Lon;
};


enum DECLSPEC_DENUM TGPXFunc : unsigned char { PostProcess, CreateTracks, CreateWayPoints, CreatePOI, CreateKML, CreateHTML, CreatePoly, CreateRoutes, CreateTrips, CreateOSMPoints };

typedef System::DynamicArray<TGPXFunc> TGPXFuncArray;

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
	bool ProcessShape;
	System::UnicodeString DefShapePtSymbol;
	bool ProcessAddrShape;
	TShapingPointName ShapingPointName;
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
	bool ProcessDistance;
	TDistanceUnit DistanceUnit;
	System::Set<TProcessCategory, TProcessCategory::pcSymbol, TProcessCategory::pcGPX> ProcessCategory;
	bool ProcessAddrWayPt;
	System::UnicodeString DefTrackColor;
	System::UnicodeString TrackColor;
	System::UnicodeString DefWaypointSymbol;
	System::UnicodeString CatSymbol;
	System::UnicodeString CatGPX;
	System::UnicodeString CatRoute;
	Unittripobjects::TZumoModel ZumoModel;
	System::UnicodeString ExploreUuid;
	System::UnicodeString VehicleProfileGuid;
	System::UnicodeString VehicleProfileHash;
	System::UnicodeString VehicleId;
	System::Classes::TNotifyEvent FOnSetFuncPrefs;
	System::Classes::TNotifyEvent FOnSavePrefs;
	__fastcall TProcessOptions(System::Classes::TNotifyEvent OnSetFuncPrefs, System::Classes::TNotifyEvent OnSavePrefs);
	__fastcall virtual ~TProcessOptions();
	void __fastcall DoPrefSaved();
	void __fastcall SetProcessCategory(bool ProcessWpt, System::UnicodeString WayPtCat);
	__classmethod void __fastcall SetPrefs(Vcl::Comctrls::TTreeView* TvSelections, System::UnicodeString TripManagerReg_Key);
	__classmethod TGPXFuncArray __fastcall StorePrefs(Vcl::Comctrls::TTreeView* TvSelections, System::UnicodeString TripManagerReg_Key);
};


class PASCALIMPLEMENTATION TGPXFile : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Unitverysimplexml::TXmlVSNodeList* FWayPointList;
	Unitverysimplexml::TXmlVSNodeList* FWayPointFromRouteList;
	Unitverysimplexml::TXmlVSNodeList* FRouteViaPointList;
	Unitverysimplexml::TXmlVSNodeList* FTrackList;
	System::Classes::TStringList* FWayPointsProcessedList;
	Unitverysimplexml::TXmlVSNode* CurrentTrack;
	Unitverysimplexml::TXmlVSNode* CurrentViaPointRoute;
	Unitverysimplexml::TXmlVSNode* CurrentWayPointFromRoute;
	System::UnicodeString CurrentRouteTrackName;
	int ShapingPointCnt;
	TCoord CurrentCoord;
	double TotalDistance;
	double CurrentDistance;
	System::UnicodeString DistanceStr;
	TCoord PrevCoord;
	Unitverysimplexml::TXmlVSDocument* FXmlDocument;
	System::UnicodeString FOutDir;
	System::Classes::TNotifyEvent FOnFunctionPrefs;
	System::Classes::TNotifyEvent FOnSavePrefs;
	System::Classes::TStringList* FOutStringList;
	System::UnicodeString FBaseFile;
	System::UnicodeString FGPXFile;
	unsigned FSeqNo;
	Unittripobjects::TTripList* FTripList;
	TProcessOptions* FProcessOptions;
	TCoord __fastcall CoordFromAttribute(Unitverysimplexml::TXmlVSAttributeList* Atributes);
	double __fastcall DegreesToRadians(double Degrees);
	double __fastcall CoordDistance(const TCoord &Coord1, const TCoord &Coord2);
	System::UnicodeString __fastcall DistanceFormat(double Distance);
	System::UnicodeString __fastcall Coord2Float(System::LongInt ACoord);
	System::LongInt __fastcall Float2Coord(double ACoord);
	System::UnicodeString __fastcall DebugCoords(Unitverysimplexml::TXmlVSAttributeList* Coords);
	System::UnicodeString __fastcall GetTrackColor(Unitverysimplexml::TXmlVSNode* ANExtension);
	bool __fastcall WayPointNotProcessed(Unitverysimplexml::TXmlVSNode* WayPoint);
	Unitgpi::TGPXWayPoint* __fastcall GPXWayPoint(int CatId, int BmpId, Unitverysimplexml::TXmlVSNode* WayPoint);
	int __fastcall GetSpeedFromName(System::UnicodeString WptName);
	Unitgpi::TGPXBitmap* __fastcall GPXBitMap(Unitverysimplexml::TXmlVSNode* WayPoint);
	Unitgpi::TGPXCategory* __fastcall GPXCategory(System::UnicodeString Category);
	void __fastcall FreeGlobals();
	void __fastcall CreateGlobals();
	void __fastcall ClearGlobals();
	void __fastcall CloneAttributes(Unitverysimplexml::TXmlVSNode* FromNode, Unitverysimplexml::TXmlVSNode* ToNode);
	void __fastcall CloneSubNodes(Unitverysimplexml::TXmlVSNodeList* FromNodes, Unitverysimplexml::TXmlVSNodeList* ToNodes);
	void __fastcall CloneNode(Unitverysimplexml::TXmlVSNode* FromNode, Unitverysimplexml::TXmlVSNode* ToNode);
	void __fastcall ProcessGPX();
	void __fastcall ComputeDistance(Unitverysimplexml::TXmlVSNode* RptNode);
	void __fastcall ClearSubClass(Unitverysimplexml::TXmlVSNode* ANode);
	void __fastcall UnglitchNode(Unitverysimplexml::TXmlVSNode* RtePtNode, Unitverysimplexml::TXmlVSNode* ExtensionNode, Unitgpi::TGPXString ViaPtName);
	void __fastcall EnsureSubNodeAfter(Unitverysimplexml::TXmlVSNode* ANode, System::UnicodeString ChildNode, const System::UnicodeString *AfterNodes, const System::NativeInt AfterNodes_High);
	void __fastcall RenameSubNode(Unitverysimplexml::TXmlVSNode* RtePtNode, const System::UnicodeString NodeName, const System::UnicodeString NewName);
	void __fastcall LookUpAddrRtePt(Unitverysimplexml::TXmlVSNode* RtePtNode);
	void __fastcall RenameNode(Unitverysimplexml::TXmlVSNode* RtePtNode, const System::UnicodeString NewName = System::UnicodeString());
	void __fastcall AddRouteCategory(Unitverysimplexml::TXmlVSNode* const ExtensionsNode, const System::UnicodeString NS, const System::UnicodeString Symbol, const System::UnicodeString Route);
	void __fastcall ReplaceAutoName(Unitverysimplexml::TXmlVSNode* const ExtensionsNode, const System::UnicodeString AutoName);
	void __fastcall ReplaceCategory(Unitverysimplexml::TXmlVSNode* const ExtensionsNode, const System::UnicodeString NS, const System::UnicodeString Category);
	void __fastcall ReplaceAddrWayPt(Unitverysimplexml::TXmlVSNode* ExtensionsNode, const System::UnicodeString NS);
	void __fastcall AddWptPoint(Unitverysimplexml::TXmlVSNode* const ChildNode, Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString WayPointName, const TProcessPointType ProcessPointType, const System::UnicodeString Symbol = System::UnicodeString(), const System::UnicodeString Description = System::UnicodeString());
	void __fastcall AddWayPointFromRoute(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString WayPointName, const bool ViaPt, const System::UnicodeString Symbol, const System::UnicodeString Category, const System::UnicodeString Route);
	void __fastcall AddViaOrShapePoint(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString ViaOrShapingPointName, const System::UnicodeString Symbol, const TProcessPointType ProcessPointType, const System::UnicodeString Category);
	void __fastcall AddBeginPoint(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString ViaPointName, const System::UnicodeString Symbol);
	void __fastcall AddEndPoint(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString ViaPointName, const System::UnicodeString Symbol);
	void __fastcall AddViaPoint(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString ViaPointName, const System::UnicodeString Symbol);
	void __fastcall AddShapingPoint(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString ShapingPointName, const System::UnicodeString Symbol);
	void __fastcall AddWayPoint(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString WayPointName);
	void __fastcall AddTrackPoint(Unitverysimplexml::TXmlVSNode* const RptNode);
	void __fastcall ProcessRtePt(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString RouteName, const int Cnt, const int LastCnt);
	void __fastcall ProcessRte(Unitverysimplexml::TXmlVSNode* const RteNode);
	void __fastcall ProcessTrk(Unitverysimplexml::TXmlVSNode* const TrkNode);
	void __fastcall ProcessWpt(Unitverysimplexml::TXmlVSNode* const WptNode);
	void __fastcall ProcessGPXNode(Unitverysimplexml::TXmlVSNode* GpxNode);
	void __fastcall StripRtePt(Unitverysimplexml::TXmlVSNode* const RtePtNode);
	void __fastcall StripRte(Unitverysimplexml::TXmlVSNode* const RteNode);
	void __fastcall Track2OSMTrackPoints(Unitverysimplexml::TXmlVSNode* Track, int RouteId, int &FirstViaPointId, System::Classes::TStringList* TrackStringList);
	int __fastcall CreateLocations(Unitverysimplexml::TXmlVSNodeList* RtePts);
	void __fastcall CreateTrip_XT(const System::UnicodeString TripName, const System::UnicodeString CalculationMode, const System::UnicodeString TransportMode, unsigned ParentTripID, Unitverysimplexml::TXmlVSNodeList* RtePts);
	void __fastcall CreateTrip_XT2(const System::UnicodeString TripName, const System::UnicodeString CalculationMode, const System::UnicodeString TransportMode, unsigned ParentTripID, Unitverysimplexml::TXmlVSNodeList* RtePts);
	
public:
	Ufrmselectgpx::TFrmSelectGPX* FrmSelectGpx;
	__fastcall TGPXFile(const System::UnicodeString GPXFile, const System::Classes::TNotifyEvent FunctionPrefs, const System::Classes::TNotifyEvent SavePrefs)/* overload */;
	__fastcall TGPXFile(const System::UnicodeString GPXFile, const System::UnicodeString OutDir, const System::Classes::TNotifyEvent FunctionPrefs, const System::Classes::TNotifyEvent SavePrefs, System::Classes::TStringList* const OutStringList, const unsigned SeqNo)/* overload */;
	__fastcall virtual ~TGPXFile();
	bool __fastcall ShowSelectTracks(const System::UnicodeString Caption, const System::UnicodeString SubCaption, Ufrmselectgpx::TTagsToShow TagsToShow);
	void __fastcall DoPostProcess();
	void __fastcall DoCreateTracks();
	void __fastcall DoCreateWayPoints();
	void __fastcall DoCreatePOI();
	void __fastcall DoCreateKML();
	void __fastcall DoCreateHTML();
	void __fastcall DoCreateOSMPoints();
	void __fastcall DoCreatePOLY();
	void __fastcall DoCreateRoutes();
	void __fastcall DoCreateTrips();
	void __fastcall ProcessTrip(Unitverysimplexml::TXmlVSNode* const RteNode, unsigned ParentTripId);
	void __fastcall AnalyzeGpx();
	__property Unitverysimplexml::TXmlVSNodeList* WayPointList = {read=FWayPointList};
	__property Unitverysimplexml::TXmlVSNodeList* RouteViaPointList = {read=FRouteViaPointList};
	__property Unitverysimplexml::TXmlVSNodeList* TrackList = {read=FTrackList};
	__property TProcessOptions* ProcessOptions = {read=FProcessOptions, write=FProcessOptions};
	__classmethod void __fastcall PerformFunctions(const TGPXFunc *AllFuncs, const System::NativeInt AllFuncs_High, const System::UnicodeString GPXFile, const System::Classes::TNotifyEvent FunctionPrefs, const System::Classes::TNotifyEvent SavePrefs, const System::UnicodeString ForceOutDir = System::UnicodeString(), System::Classes::TStringList* const OutStringList = (System::Classes::TStringList*)(0x0), const unsigned SeqNo = (unsigned)(0x0));
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::Classes::TNotifyEvent OnSetFixedPrefs;
extern DELPHI_PACKAGE System::UnicodeString ProcessCategoryPick;
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
#define TripFilesFor L"Trip files (No import required, but will recalculate. Sele"\
	L"cted model: %s)"
extern DELPHI_PACKAGE Unitverysimplexml::TXmlVSNode* __fastcall InitGarminGpx(Unitverysimplexml::TXmlVSDocument* GarminGPX);
}	/* namespace Unitgpxobjects */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITGPXOBJECTS)
using namespace Unitgpxobjects;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitGPXObjectsHPP
