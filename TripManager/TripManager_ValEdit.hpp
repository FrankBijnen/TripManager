// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TripManager_ValEdit.pas' rev: 36.00 (Windows)

#ifndef TripManager_ValEditHPP
#define TripManager_ValEditHPP

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
#include <Vcl.Grids.hpp>
#include <Vcl.ValEdit.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tripmanager_valedit
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TValueListEditor;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TValueListEditor : public Vcl::Valedit::TValueListEditor
{
	typedef Vcl::Valedit::TValueListEditor inherited;
	
private:
	System::Classes::TNotifyEvent FOnSelectionMoved;
	
protected:
	virtual void __fastcall SelectionMoved(const Vcl::Grids::TGridRect &OldSel);
	
public:
	__property System::Classes::TNotifyEvent OnSelectionMoved = {read=FOnSelectionMoved, write=FOnSelectionMoved};
public:
	/* TValueListEditor.Create */ inline __fastcall virtual TValueListEditor(System::Classes::TComponent* AOwner) : Vcl::Valedit::TValueListEditor(AOwner) { }
	/* TValueListEditor.Destroy */ inline __fastcall virtual ~TValueListEditor() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TValueListEditor(HWND ParentWindow) : Vcl::Valedit::TValueListEditor(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Tripmanager_valedit */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TRIPMANAGER_VALEDIT)
using namespace Tripmanager_valedit;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// TripManager_ValEditHPP
