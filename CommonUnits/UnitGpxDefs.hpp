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
#include <UnitVerySimpleXml.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitgpxdefs
{
//-- forward type declarations -----------------------------------------------
struct TCoords;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TDistanceUnit : unsigned char { duKm, duMi };

enum DECLSPEC_DENUM TProcessCategory : unsigned char { pcSymbol, pcGPX };

enum DECLSPEC_DENUM TProcessPointType : unsigned char { pptNone, pptWayPt, pptViaPt, pptShapePt };

enum DECLSPEC_DENUM TShapingPointName : unsigned char { Unchanged, Route_Sequence, Route_Distance, Sequence_Route, Distance_Route };

struct DECLSPEC_DRECORD TCoords
{
public:
	double Lat;
	double Lon;
	void __fastcall FormatLatLon(System::UnicodeString &OLat, System::UnicodeString &OLon);
	void __fastcall FromAttributes(System::TObject* Attributes);
};


enum DECLSPEC_DENUM TGPXFunc : unsigned char { PostProcess, CreateTracks, CreateWayPoints, CreatePOI, CreateKML, CreateHTML, CreatePoly, CreateRoutes, CreateTrips, CreateOSMPoints, CreateFITPoints };

typedef System::DynamicArray<TGPXFunc> TGPXFuncArray;

enum DECLSPEC_DENUM Unitgpxdefs__1 : unsigned char { scCompare, scFirst, ScLast };

typedef System::Set<Unitgpxdefs__1, Unitgpxdefs__1::scCompare, Unitgpxdefs__1::ScLast> TSubClassType;

enum DECLSPEC_DENUM TGarminModel : unsigned char { XT, XT2, Tread2, GarminEdge, GarminGeneric, Unknown };

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE double EarthRadiusKm;
extern DELPHI_PACKAGE double EarthRadiusMi;
extern DELPHI_PACKAGE System::UnicodeString ProcessCategoryPick;
#define LatLonFormat L"%1.5f"
extern DELPHI_PACKAGE System::UnicodeString __fastcall Coord2Float(System::LongInt ACoord);
extern DELPHI_PACKAGE System::LongInt __fastcall Float2Coord(double ACoord);
extern DELPHI_PACKAGE double __fastcall CoordDistance(const TCoords &Coord1, const TCoords &Coord2, TDistanceUnit DistanceUnit);
extern DELPHI_PACKAGE Unitverysimplexml::TXmlVSNode* __fastcall GetFirstExtensionsNode(Unitverysimplexml::TXmlVSNode* const ARtePt);
extern DELPHI_PACKAGE Unitverysimplexml::TXmlVSNode* __fastcall GetLastExtensionsNode(Unitverysimplexml::TXmlVSNode* const ARtePt);
}	/* namespace Unitgpxdefs */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITGPXDEFS)
using namespace Unitgpxdefs;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitGpxDefsHPP
