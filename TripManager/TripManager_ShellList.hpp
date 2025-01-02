// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TripManager_ShellList.pas' rev: 35.00 (Windows)

#ifndef Tripmanager_shelllistHPP
#define Tripmanager_shelllistHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <System.Types.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Winapi.ShlObj.hpp>
#include <Winapi.ActiveX.hpp>
#include <Vcl.Shell.ShellCtrls.hpp>
#include <Vcl.Shell.ShellConsts.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tripmanager_shelllist
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TShellListView;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM THeaderSortState : unsigned char { hssNone, hssAscending, hssDescending };

class PASCALIMPLEMENTATION TShellListView : public Vcl::Shell::Shellctrls::TShellListView
{
	typedef Vcl::Shell::Shellctrls::TShellListView inherited;
	
private:
	bool FColumnSorted;
	int FSortColumn;
	THeaderSortState FSortState;
	_di_IContextMenu2 ICM2;
	System::Types::TPoint FDragStartPos;
	bool FDragSource;
	bool FDragStarted;
	HRESULT __stdcall GiveFeedback(int dwEffect);
	HRESULT __stdcall QueryContinueDrag(System::LongBool fEscapePressed, int grfKeyState);
	void __fastcall SetColumnSorted(bool AValue);
	System::Classes::TStringList* __fastcall CreateSelectedFileList();
	
protected:
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall InitSortSpec(int SortColumn, THeaderSortState SortState);
	virtual void __fastcall Populate();
	virtual void __fastcall ColumnSort();
	virtual void __fastcall CreateWnd();
	virtual void __fastcall DestroyWnd();
	DYNAMIC void __fastcall DoContextPopup(const System::Types::TPoint &MousePos, bool &Handled);
	DYNAMIC void __fastcall Edit(const tagLVITEMW &Item);
	void __fastcall ShowMultiContextMenu(const System::Types::TPoint &MousePos);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	
public:
	__fastcall virtual TShellListView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TShellListView();
	virtual void __fastcall ClearSelection();
	virtual void __fastcall SelectAll();
	HIDESBASE void __fastcall Refresh();
	HIDESBASE void __fastcall ColumnClick(Vcl::Comctrls::TListColumn* Column);
	virtual void __fastcall SetFocus();
	__property bool ColumnSorted = {read=FColumnSorted, write=SetColumnSorted, nodefault};
	__property int SortColumn = {read=FSortColumn, write=FSortColumn, nodefault};
	__property THeaderSortState SortState = {read=FSortState, write=FSortState, nodefault};
	__property OnMouseWheel;
	__property bool DragSource = {read=FDragSource, write=FDragSource, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TShellListView(HWND ParentWindow) : Vcl::Shell::Shellctrls::TShellListView(ParentWindow) { }
	
private:
	void *__IDropSource;	// IDropSource 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {00000121-0000-0000-C000-000000000046}
	operator _di_IDropSource()
	{
		_di_IDropSource intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator IDropSource*(void) { return (IDropSource*)&__IDropSource; }
	#endif
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Tripmanager_shelllist */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_TRIPMANAGER_SHELLLIST)
using namespace Tripmanager_shelllist;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Tripmanager_shelllistHPP
