// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitStringUtils.pas' rev: 36.00 (Windows)

#ifndef UnitStringUtilsHPP
#define UnitStringUtilsHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <Winapi.ShellAPI.hpp>
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
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReplaceAll(const System::UnicodeString AString, const System::UnicodeString *OldPatterns, const System::NativeInt OldPatterns_High, const System::UnicodeString *NewPatterns, const System::NativeInt NewPatterns_High, System::Sysutils::TReplaceFlags Flags = (System::Sysutils::TReplaceFlags() << System::Sysutils::TReplaceFlag::rfReplaceAll ));
extern DELPHI_PACKAGE void __fastcall SetSubString(System::UnicodeString &AString, const int Pos, System::UnicodeString SubString);
extern DELPHI_PACKAGE T4Bytes __fastcall Swap32(T4Bytes I)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall Swap32(unsigned I)/* overload */;
extern DELPHI_PACKAGE int __fastcall Swap32(int I)/* overload */;
extern DELPHI_PACKAGE float __fastcall Swap32(float I)/* overload */;
extern DELPHI_PACKAGE bool __fastcall ValidLatLon(const System::UnicodeString Lat, const System::UnicodeString Lon);
extern DELPHI_PACKAGE void __fastcall PrepStream(System::Classes::TMemoryStream* TmpStream, const unsigned *Buffer, const System::NativeInt Buffer_High)/* overload */;
extern DELPHI_PACKAGE void __fastcall PrepStream(System::Classes::TMemoryStream* TmpStream, const unsigned Count, const System::Word *Buffer, const System::NativeInt Buffer_High)/* overload */;
extern DELPHI_PACKAGE void __fastcall CheckHRGuid(HRESULT HR);
extern DELPHI_PACKAGE void __fastcall AdjustLatLon(System::UnicodeString &Lat, System::UnicodeString &Lon, int No_Decimals);
extern DELPHI_PACKAGE void __fastcall ParseLatLon(const System::UnicodeString LatLon, System::UnicodeString &Lat, System::UnicodeString &Lon);
extern DELPHI_PACKAGE void __fastcall DebugMsg(const System::Variant *Msg, const System::NativeInt Msg_High);
extern DELPHI_PACKAGE System::UnicodeString __fastcall TempFilename(const System::UnicodeString Prefix);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetAppData();
extern DELPHI_PACKAGE System::UnicodeString __fastcall CreateTempPath(const System::UnicodeString Prefix);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetHtmlTmp();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTracksExt();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTracksMask();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTracksTmp();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetOSMTemp();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetRoutesTmp();
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetDeviceTmp();
extern DELPHI_PACKAGE System::UnicodeString __fastcall EscapeDQuote(const System::UnicodeString HTML);
extern DELPHI_PACKAGE System::UnicodeString __fastcall EscapeHtml(const System::UnicodeString HTML);
extern DELPHI_PACKAGE System::UnicodeString __fastcall EscapeFileName(System::UnicodeString InFile);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GPX2HTMLColor(System::UnicodeString GPXColor);
extern DELPHI_PACKAGE System::Sysutils::TFormatSettings __fastcall GetLocaleSetting();
extern DELPHI_PACKAGE System::UnicodeString __fastcall VerInfo(bool IncludeCompany = false);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UserAgent();
extern DELPHI_PACKAGE bool __fastcall Sto_RedirectedExecute(System::UnicodeString CmdLine, System::UnicodeString CurrentDir, System::UnicodeString &Output, System::UnicodeString &Error, unsigned &ExitCode, const System::UnicodeString Input = System::UnicodeString(), const unsigned Wait = (unsigned)(0x36ee80), const bool ShowWindow = false);
}	/* namespace Unitstringutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITSTRINGUTILS)
using namespace Unitstringutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitStringUtilsHPP
