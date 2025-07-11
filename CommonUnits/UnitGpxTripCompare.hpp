// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitGpxTripCompare.pas' rev: 36.00 (Windows)

#ifndef UnitGpxTripCompareHPP
#define UnitGpxTripCompareHPP

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
#include <UnitVerySimpleXml.hpp>
#include <UnitGpxDefs.hpp>
#include <UnitGPXObjects.hpp>
#include <unitTripObjects.hpp>
#include <Xml.VerySimple.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitgpxtripcompare
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGPXTripCompare;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TGPXTripCompare : public Unitgpxobjects::TGPXFile
{
	typedef Unitgpxobjects::TGPXFile inherited;
	
private:
	double FDistOKMeters;
	Unittripobjects::TmAllRoutes* FAllRoutes;
	Unittripobjects::TmUdbDataHndl* FUdbHandle;
	Unittripobjects::TUdbDir* FUdbDir;
	Unitverysimplexml::TXmlVSNode* FRtePt;
	bool FCheckSegmentOK;
	bool FCheckRouteOK;
	System::UnicodeString __fastcall DisplayMapSegRoad(const System::UnicodeString MapSegRoad);
	Unitverysimplexml::TXmlVSNode* __fastcall GetRouteNode(const System::UnicodeString RouteName);
	Unitverysimplexml::TXmlVSNode* __fastcall GetRtePtFromRoute(System::Classes::TStrings* const Messages, Unitverysimplexml::TXmlVSNode* const RouteSelected);
	Unitverysimplexml::TXmlVSNode* __fastcall PrepareTripForCompare(System::Classes::TStrings* const Messages, System::Classes::TStrings* const OutTrackList, int &UdbHandleCount, int &UdbDirCount);
	double __fastcall ScanForTrkPt(const Unitgpxdefs::TCoord &FromCoords, Unitverysimplexml::TXmlVSNode* const ScanFromTrkPt, Unitverysimplexml::TXmlVSNode* const ScanToTrkPt, Unitverysimplexml::TXmlVSNode* &BestScanTrkPt);
	void __fastcall NoMatchRoutePoints(System::Classes::TStrings* const Messages);
	void __fastcall NoMatchRoutePoint(System::Classes::TStrings* const Messages, const Unitgpxdefs::TCoord &CoordTrip, const Unitgpxdefs::TCoord &CoordGpx, double ThisDist);
	void __fastcall NoMatchRoutePointEnd(System::Classes::TStrings* const Messages, const Unitgpxdefs::TCoord &CoordTrip);
	void __fastcall NoGpxxRpt(System::Classes::TStrings* const Messages);
	void __fastcall NoMatchUdbDirSubClass(System::Classes::TStrings* const Messages, const Unitgpxdefs::TCoord &CoordTrip, Unitverysimplexml::TXmlVSNode* BestRpt, double BestDist);
	void __fastcall NoMatchRoutePointTrk(System::Classes::TStrings* const Messages, const Unitgpxdefs::TCoord &CoordTrip, Unitverysimplexml::TXmlVSNode* BestToTrkpt, double ThisDist);
	void __fastcall NoMatchUdbDirTrk(System::Classes::TStrings* const Messages, const Unitgpxdefs::TCoord &CoordTrip, Unitverysimplexml::TXmlVSNode* BestTrkpt, double BestDist);
	
public:
	__fastcall TGPXTripCompare(const System::UnicodeString AGPXFile, Unittripobjects::TTripList* ATripList);
	__fastcall virtual ~TGPXTripCompare();
	void __fastcall CompareGpxRoute(System::Classes::TStrings* const Messages, System::Classes::TStrings* const OutTrackList);
	void __fastcall CompareGpxTrack(System::Classes::TStrings* const Messages, System::Classes::TStrings* const OutTrackList);
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Unitgpxtripcompare */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITGPXTRIPCOMPARE)
using namespace Unitgpxtripcompare;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitGpxTripCompareHPP
