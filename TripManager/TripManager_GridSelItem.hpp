// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TripManager_GridSelItem.pas' rev: 36.00 (Windows)

#ifndef TripManager_GridSelItemHPP
#define TripManager_GridSelItemHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <UnitTripObjects.hpp>
#include <Vcl.ValEdit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tripmanager_gridselitem
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGridSelItem;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TGridSelItem : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Unittripobjects::TBaseItem* FBaseItem;
	System::IntPtr FSelStart;
	System::IntPtr FSelLength;
	
public:
	__fastcall TGridSelItem(Unittripobjects::TBaseItem* ABaseItem, System::IntPtr ASelLength, System::IntPtr ASelStart)/* overload */;
	__fastcall TGridSelItem(System::IntPtr ASelLength, System::IntPtr ASelStart)/* overload */;
	__property Unittripobjects::TBaseItem* BaseItem = {read=FBaseItem};
	__property System::IntPtr SelStart = {read=FSelStart, nodefault};
	__property System::IntPtr SelLength = {read=FSelLength, nodefault};
	__classmethod TGridSelItem* __fastcall GridSelItem(Vcl::Valedit::TValueListEditor* AValueListEditor, int ARow);
	__classmethod Unittripobjects::TBaseDataItem* __fastcall BaseDataItem(Vcl::Valedit::TValueListEditor* AValueListEditor, int ARow);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TGridSelItem() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Tripmanager_gridselitem */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TRIPMANAGER_GRIDSELITEM)
using namespace Tripmanager_gridselitem;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// TripManager_GridSelItemHPP
