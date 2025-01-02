// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TripManager_MultiContext.pas' rev: 35.00 (Windows)

#ifndef Tripmanager_multicontextHPP
#define Tripmanager_multicontextHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.Win.ComObj.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.ShlObj.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Shell.ShellCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tripmanager_multicontext
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall InvokeMultiContextMenu(Vcl::Controls::TWinControl* Owner, Vcl::Shell::Shellctrls::TShellFolder* AFolder, const System::Types::TPoint &MousePos, _di_IContextMenu2 &ICM2, System::Classes::TStrings* AFileList = (System::Classes::TStrings*)(0x0));
extern DELPHI_PACKAGE void __fastcall DoContextMenuVerb(Vcl::Shell::Shellctrls::TShellFolder* AFolder, char * Verb);
}	/* namespace Tripmanager_multicontext */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TRIPMANAGER_MULTICONTEXT)
using namespace Tripmanager_multicontext;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Tripmanager_multicontextHPP
