// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitStringUtils.pas' rev: 35.00 (Windows)

#ifndef UnitstringutilsHPP
#define UnitstringutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Variants.hpp>
#include <Winapi.ShellAPI.hpp>
#include <System.Win.Registry.hpp>
#include <Winapi.Windows.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitstringutils
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::Byte, 4> T4Bytes;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString CreatedTempPath;
extern DELPHI_PACKAGE System::UnicodeString App_Prefix;
extern DELPHI_PACKAGE System::UnicodeString __fastcall SenSize(const __int64 S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall Intd(const int N, const int D);
extern DELPHI_PACKAGE System::UnicodeString __fastcall Spc(const int Cnt);
extern DELPHI_PACKAGE System::UnicodeString __fastcall NextField(System::UnicodeString &AString, const System::UnicodeString ADelimiter);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReplaceAll(const System::UnicodeString AString, const System::UnicodeString *OldPatterns, const int OldPatterns_High, const System::UnicodeString *NewPatterns, const int NewPatterns_High, System::Sysutils::TReplaceFlags Flags = (System::Sysutils::TReplaceFlags() << System::Sysutils::System_Sysutils__95::rfReplaceAll ));
extern DELPHI_PACKAGE T4Bytes __fastcall Swap32(T4Bytes I)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall Swap32(unsigned I)/* overload */;
extern DELPHI_PACKAGE int __fastcall Swap32(int I)/* overload */;
extern DELPHI_PACKAGE float __fastcall Swap32(float I)/* overload */;
extern DELPHI_PACKAGE double __fastcall CoordAsDec(const System::UnicodeString ACoord);
extern DELPHI_PACKAGE bool __fastcall ValidLatLon(const System::UnicodeString Lat, const System::UnicodeString Lon);
extern DELPHI_PACKAGE void __fastcall AdjustLatLon(System::UnicodeString &Lat, System::UnicodeString &Lon, int No_Decimals);
extern DELPHI_PACKAGE void __fastcall ParseLatLon(const System::UnicodeString LatLon, System::UnicodeString &Lat, System::UnicodeString &Lon);
extern DELPHI_PACKAGE void __fastcall DebugMsg(const System::Variant *Msg, const int Msg_High);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetRegistryValue(const HKEY ARootKey, const System::UnicodeString KeyName, const System::UnicodeString Name, const System::UnicodeString Default = System::UnicodeString());
extern DELPHI_PACKAGE void __fastcall SetRegistryValue(const HKEY ARootKey, const System::UnicodeString KeyName, const System::UnicodeString Name, const System::UnicodeString Value);
extern DELPHI_PACKAGE System::UnicodeString __fastcall TempFilename(const System::UnicodeString Prefix);
extern DELPHI_PACKAGE System::UnicodeString __fastcall CreateTempPath(const System::UnicodeString Prefix);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetHtmlTmp();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTracksExt();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTracksMask();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTracksTmp();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetOSMTemp();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetRoutesTmp();
extern DELPHI_PACKAGE System::UnicodeString __fastcall EscapeDQuote(const System::UnicodeString HTML);
extern DELPHI_PACKAGE System::UnicodeString __fastcall EscapeHtml(const System::UnicodeString HTML);
extern DELPHI_PACKAGE System::UnicodeString __fastcall EscapeFileName(System::UnicodeString InFile);
}	/* namespace Unitstringutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITSTRINGUTILS)
using namespace Unitstringutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitstringutilsHPP
