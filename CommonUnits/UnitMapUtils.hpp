// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitMapUtils.pas' rev: 36.00 (Windows)

#ifndef UnitMapUtilsHPP
#define UnitMapUtilsHPP

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

//-- user supplied -----------------------------------------------------------

namespace Unitmaputils
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall CreateLink(const System::UnicodeString PathObj, const System::UnicodeString PathLink, const System::UnicodeString Desc, const System::UnicodeString Param);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ResolveLink(const System::UnicodeString Path);
extern DELPHI_PACKAGE bool __fastcall DeleteLink(const System::UnicodeString Path);
extern DELPHI_PACKAGE void __fastcall ListMapsRegistryKey(System::Classes::TStringList* MapsList, System::UnicodeString MapsKey);
extern DELPHI_PACKAGE void __fastcall ListMapsAppData(const System::UnicodeString BaseDir, System::Classes::TStringList* MapsList, bool IncludePath = false);
extern DELPHI_PACKAGE System::Classes::TStringList* __fastcall ListMaps(const System::UnicodeString BaseDir);
extern DELPHI_PACKAGE System::UnicodeString __fastcall LookupMap(const System::UnicodeString MapSegment);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetKnownFolder(const GUID &Known);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetMapFolder();
extern DELPHI_PACKAGE void __fastcall ClearTileCache();
}	/* namespace Unitmaputils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITMAPUTILS)
using namespace Unitmaputils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitMapUtilsHPP
