// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitGpxDefs.pas' rev: 36.00 (Windows)

#ifndef UnitGpxDefsHPP
#define UnitGpxDefsHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitgpxdefs
{
//-- forward type declarations -----------------------------------------------
struct TCoord;
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
	void __fastcall FormatLatLon(System::UnicodeString &OLat, System::UnicodeString &OLon);
};


enum DECLSPEC_DENUM TGPXFunc : unsigned char { PostProcess, CreateTracks, CreateWayPoints, CreatePOI, CreateKML, CreateHTML, CreatePoly, CreateRoutes, CreateTrips, CreateOSMPoints };

typedef System::DynamicArray<TGPXFunc> TGPXFuncArray;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString ProcessCategoryPick;
#define LatLonFormat L"%1.5f"
}	/* namespace Unitgpxdefs */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITGPXDEFS)
using namespace Unitgpxdefs;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitGpxDefsHPP
