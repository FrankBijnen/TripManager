// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitOSMMap.pas' rev: 36.00 (Windows)

#ifndef UnitOSMMapHPP
#define UnitOSMMapHPP

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
#include <System.Generics.Collections.hpp>
#include <System.IniFiles.hpp>
#include <Vcl.Edge.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitosmmap
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOSMHelper;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TOSMHelper : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool HasData;
	int Scaled;
	System::Sysutils::TFormatSettings OsmFormatSettings;
	System::Classes::TStringList* Html;
	System::UnicodeString FInitialZoom;
	System::UnicodeString FPathName;
	System::UnicodeString FHome;
	void __fastcall WriteHeader();
	void __fastcall WriteTrackPoints();
	void __fastcall WriteFooter();
	
public:
	__fastcall TOSMHelper(const System::UnicodeString APathName, const System::UnicodeString AHome, const System::UnicodeString AInitialZoom);
	__fastcall virtual ~TOSMHelper();
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static _DELPHI_CONST System::Int8 Coord_Decimals = System::Int8(0x6);
static _DELPHI_CONST System::Int8 Place_Decimals = System::Int8(0x4);
#define OSMCtrlClick L"Ctrl Click"
#define OSMGetBounds L"GetBounds"
#define OSMGetRoutePoint L"GetRoutePoint"
#define InitialZoom_Point L"15"
#define InitialZoom_Home L"12"
#define InitialZoom_NoHome L"20"
#define PopupTimeout L"3000"
#define GeoSearchTimeout L"8000"
extern DELPHI_PACKAGE void __fastcall ShowMap(Vcl::Edge::TEdgeBrowser* Browser, System::UnicodeString Home = System::UnicodeString());
extern DELPHI_PACKAGE void __fastcall ParseJsonMessage(const System::UnicodeString Message, System::UnicodeString &Msg, System::UnicodeString &Parm1, System::UnicodeString &Parm2);
}	/* namespace Unitosmmap */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITOSMMAP)
using namespace Unitosmmap;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitOSMMapHPP
