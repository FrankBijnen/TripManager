// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TripManager_ShellTree.pas' rev: 36.00 (Windows)

#ifndef TripManager_ShellTreeHPP
#define TripManager_ShellTreeHPP

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
#include <System.Types.hpp>
#include <Vcl.Shell.ShellCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tripmanager_shelltree
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TShellTreeView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TShellTreeView : public Vcl::Shell::Shellctrls::TShellTreeView
{
	typedef Vcl::Shell::Shellctrls::TShellTreeView inherited;
	
protected:
	DYNAMIC void __fastcall DoContextPopup(const System::Types::TPoint &MousePos, bool &Handled);
public:
	/* TCustomShellTreeView.Create */ inline __fastcall virtual TShellTreeView(System::Classes::TComponent* AOwner) : Vcl::Shell::Shellctrls::TShellTreeView(AOwner) { }
	/* TCustomShellTreeView.Destroy */ inline __fastcall virtual ~TShellTreeView() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TShellTreeView(HWND ParentWindow) : Vcl::Shell::Shellctrls::TShellTreeView(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Tripmanager_shelltree */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TRIPMANAGER_SHELLTREE)
using namespace Tripmanager_shelltree;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// TripManager_ShellTreeHPP
