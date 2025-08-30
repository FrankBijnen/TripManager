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
#include <UnitGpxDefs.hpp>
#include <UnitProcessOptions.hpp>
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
class DELPHICLASS TGPXFile;
//-- type declarations -------------------------------------------------------
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
	Unitgpxdefs::TCoords CurrentCoord;
	double TotalDistance;
	double CurrentDistance;
	Unitgpxdefs::TCoords PrevCoord;
	Unitverysimplexml::TXmlVSDocument* FXmlDocument;
	System::UnicodeString FOutDir;
	System::Classes::TNotifyEvent FOnFunctionPrefs;
	System::Classes::TNotifyEvent FOnSavePrefs;
	System::Classes::TStringList* FOutStringList;
	System::Classes::TStringList* FSubClassList;
	System::UnicodeString FBaseFile;
	System::UnicodeString FGPXFile;
	unsigned FSeqNo;
	Unittripobjects::TTripList* FTripList;
	Unitprocessoptions::TProcessOptions* FProcessOptions;
	System::UnicodeString __fastcall DistanceFormat(double Distance);
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
	void __fastcall AddWptPoint(Unitverysimplexml::TXmlVSNode* const ChildNode, Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString WayPointName, const Unitgpxdefs::TProcessPointType ProcessPointType, const System::UnicodeString Symbol = System::UnicodeString(), const System::UnicodeString Description = System::UnicodeString());
	void __fastcall AddWayPointFromRoute(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString WayPointName, const bool ViaPt, const System::UnicodeString Symbol, const System::UnicodeString Category, const System::UnicodeString Route);
	void __fastcall AddViaOrShapePoint(Unitverysimplexml::TXmlVSNode* const RtePtNode, const System::UnicodeString ViaOrShapingPointName, const System::UnicodeString Symbol, const Unitgpxdefs::TProcessPointType ProcessPointType, const System::UnicodeString Category);
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
	double __fastcall GetTotalDistance(const System::UnicodeString ATripName);
	bool __fastcall BuildSubClassesList(Unitverysimplexml::TXmlVSNodeList* const RtePts);
	int __fastcall CreateLocations(Unittripobjects::TmLocations* Locations, Unitverysimplexml::TXmlVSNodeList* RtePts);
	void __fastcall UpdateTemplate(const System::UnicodeString TripName, unsigned ParentTripId, Unitverysimplexml::TXmlVSNodeList* RtePts);
	
protected:
	System::UnicodeString __fastcall MapSegRoadExclBit(const System::UnicodeString ASubClass);
	void __fastcall BuildSubClasses(Unitverysimplexml::TXmlVSNode* const ARtePt, const double DistOKMeters, const Unitgpxdefs::TSubClassType SCType = (Unitgpxdefs::TSubClassType() << Unitgpxdefs::Unitgpxdefs__1::scCompare ));
	void __fastcall CloneAttributes(Unitverysimplexml::TXmlVSNode* FromNode, Unitverysimplexml::TXmlVSNode* ToNode);
	void __fastcall CloneSubNodes(Unitverysimplexml::TXmlVSNodeList* FromNodes, Unitverysimplexml::TXmlVSNodeList* ToNodes);
	void __fastcall CloneNode(Unitverysimplexml::TXmlVSNode* FromNode, Unitverysimplexml::TXmlVSNode* ToNode);
	void __fastcall Track2OSMTrackPoints(Unitverysimplexml::TXmlVSNode* Track, int &TrackId, System::Classes::TStringList* TrackStringList);
	
public:
	Ufrmselectgpx::TFrmSelectGPX* FrmSelectGpx;
	__fastcall TGPXFile(const System::UnicodeString GPXFile, const System::Classes::TNotifyEvent FunctionPrefs, const System::Classes::TNotifyEvent SavePrefs)/* overload */;
	__fastcall TGPXFile(const System::UnicodeString GPXFile, const System::UnicodeString OutDir, const System::Classes::TNotifyEvent FunctionPrefs, const System::Classes::TNotifyEvent SavePrefs, System::Classes::TStringList* const OutStringList, const unsigned SeqNo)/* overload */;
	__fastcall virtual ~TGPXFile();
	bool __fastcall ShowSelectTracks(const System::UnicodeString Caption, const System::UnicodeString SubCaption, Ufrmselectgpx::TTagsToShow TagsToShow, System::UnicodeString CheckMask);
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
	void __fastcall FixCurrentGPX();
	void __fastcall AnalyzeGpx();
	__property System::Classes::TStringList* SubClassList = {read=FSubClassList};
	__property Unitverysimplexml::TXmlVSNodeList* WayPointList = {read=FWayPointList};
	__property Unitverysimplexml::TXmlVSNodeList* RouteViaPointList = {read=FRouteViaPointList};
	__property Unitverysimplexml::TXmlVSNodeList* TrackList = {read=FTrackList};
	__property Unitverysimplexml::TXmlVSDocument* XmlDocument = {read=FXmlDocument};
	__property Unitprocessoptions::TProcessOptions* ProcessOptions = {read=FProcessOptions, write=FProcessOptions};
	__classmethod void __fastcall PerformFunctions(const Unitgpxdefs::TGPXFunc *AllFuncs, const System::NativeInt AllFuncs_High, const System::UnicodeString GPXFile, const System::Classes::TNotifyEvent FunctionPrefs, const System::Classes::TNotifyEvent SavePrefs, const System::UnicodeString ForceOutDir = System::UnicodeString(), System::Classes::TStringList* const OutStringList = (System::Classes::TStringList*)(0x0), const unsigned SeqNo = (unsigned)(0x0));
	__classmethod bool __fastcall CmdLinePostProcess(System::Classes::TNotifyEvent SetPrefsEvent);
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Unitgpxobjects */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITGPXOBJECTS)
using namespace Unitgpxobjects;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitGPXObjectsHPP
