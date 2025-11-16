// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitRegistry.pas' rev: 36.00 (Windows)

#ifndef UnitRegistryHPP
#define UnitRegistryHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Win.Registry.hpp>
#include <System.TypInfo.hpp>
#include <Winapi.Windows.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitregistry
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::UnicodeString, 2> Unitregistry__1;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Unitregistry__1 BooleanValues;
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetRegistry(const System::UnicodeString Name, const System::UnicodeString Default = System::UnicodeString(), const System::UnicodeString SubKey = System::UnicodeString())/* overload */;
extern DELPHI_PACKAGE bool __fastcall GetRegistry(const System::UnicodeString Name, const bool Default)/* overload */;
extern DELPHI_PACKAGE int __fastcall GetRegistry(const System::UnicodeString Name, const int Default)/* overload */;
extern DELPHI_PACKAGE int __fastcall GetRegistry(const System::UnicodeString Name, const int Default, System::Typinfo::PTypeInfo AType)/* overload */;
extern DELPHI_PACKAGE void __fastcall SetRegistry(const System::UnicodeString Name, const System::UnicodeString Value, const System::UnicodeString SubKey = System::UnicodeString())/* overload */;
extern DELPHI_PACKAGE void __fastcall SetRegistry(const System::UnicodeString Name, bool Value)/* overload */;
extern DELPHI_PACKAGE void __fastcall SetRegistry(const System::UnicodeString Name, int Value)/* overload */;
}	/* namespace Unitregistry */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITREGISTRY)
using namespace Unitregistry;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitRegistryHPP
