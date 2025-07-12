// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TripManager_DBGrid.pas' rev: 36.00 (Windows)

#ifndef TripManager_DBGridHPP
#define TripManager_DBGridHPP

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
#include <System.UITypes.hpp>
#include <Vcl.DBGrids.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tripmanager_dbgrid
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TDBGrid;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TDBGrid : public Vcl::Dbgrids::TDBGrid
{
	typedef Vcl::Dbgrids::TDBGrid inherited;
	
private:
	int FirstSel;
	void __fastcall SelectRange();
	
protected:
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	
public:
	__fastcall virtual TDBGrid(System::Classes::TComponent* AOwner);
	__property InplaceEditor;
public:
	/* TCustomDBGrid.Destroy */ inline __fastcall virtual ~TDBGrid() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TDBGrid(HWND ParentWindow) : Vcl::Dbgrids::TDBGrid(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Tripmanager_dbgrid */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TRIPMANAGER_DBGRID)
using namespace Tripmanager_dbgrid;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// TripManager_DBGridHPP
