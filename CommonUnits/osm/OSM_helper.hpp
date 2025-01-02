// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'OSM_helper.pas' rev: 35.00 (Windows)

#ifndef Osm_helperHPP
#define Osm_helperHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Osm_helper
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TOSMHelper;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TOSMHelper : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	int FPointCnt;
	System::Classes::TStringList* Html;
	System::UnicodeString FPathName;
	void __fastcall WriteHeader(System::UnicodeString Color = System::UnicodeString());
	void __fastcall WritePointsStart(const System::UnicodeString TrackName);
	void __fastcall WritePoint(const System::UnicodeString ALon, const System::UnicodeString ALat, const System::UnicodeString AEle);
	void __fastcall WritePointsEnd();
	void __fastcall WritePlacesStart();
	void __fastcall WritePlace(System::UnicodeString ACoordinates, System::UnicodeString AWayPoint, System::UnicodeString ADescription = System::UnicodeString());
	void __fastcall WritePlacesEnd();
	void __fastcall WriteFooter();
	System::Sysutils::TFormatSettings FormatSettings;
	__fastcall TOSMHelper(System::UnicodeString APathName);
	__fastcall virtual ~TOSMHelper();
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall OSMColor(System::UnicodeString GPXColor);
}	/* namespace Osm_helper */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_OSM_HELPER)
using namespace Osm_helper;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Osm_helperHPP
