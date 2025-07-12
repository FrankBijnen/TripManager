// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'TripManager_ShellList.pas' rev: 36.00 (Windows)

#ifndef TripManager_ShellListHPP
#define TripManager_ShellListHPP

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
#include <UnitListViewSort.hpp>

//-- user supplied -----------------------------------------------------------

namespace Tripmanager_shelllist
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TShellListView;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TShellListView : public Vcl::Shell::Shellctrls::TShellListView
{
	typedef Vcl::Shell::Shellctrls::TShellListView inherited;
	
private:
	bool FColumnSorted;
	int FSortColumn;
	Unitlistviewsort::THeaderSortState FSortState;
	_di_IContextMenu2 ICM2;
	Winapi::Windows::TPoint FDragStartPos;
	bool FDragSource;
	bool FDragStarted;
	HRESULT __stdcall GiveFeedback(System::LongInt dwEffect);
	HRESULT __stdcall QueryContinueDrag(System::LongBool fEscapePressed, System::LongInt grfKeyState);
	void __fastcall SetColumnSorted(bool AValue);
	System::Classes::TStringList* __fastcall CreateSelectedFileList();
	
protected:
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	HIDESBASE MESSAGE void __fastcall WMNotify(Winapi::Messages::TWMNotify &Msg);
	void __fastcall InitSortSpec(int SortColumn, Unitlistviewsort::THeaderSortState SortState);
	void __fastcall RestoreSortIndicator();
	DYNAMIC void __fastcall DoContextPopup(const Winapi::Windows::TPoint &MousePos, bool &Handled);
	virtual int __fastcall OwnerDataFind(Vcl::Comctrls::TItemFind Find, const System::UnicodeString FindString, const Winapi::Windows::TPoint &FindPosition, void * FindData, int StartIndex, Vcl::Comctrls::TSearchDirection Direction, bool Wrap);
	virtual void __fastcall ColumnSort();
	virtual void __fastcall CreateWnd();
	virtual void __fastcall EnumColumns();
	virtual void __fastcall Populate();
	DYNAMIC void __fastcall Edit(const Winapi::Commctrl::TLVItem &Item);
	void __fastcall ShowMultiContextMenu(const Winapi::Windows::TPoint &MousePos);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	
public:
	__fastcall virtual TShellListView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TShellListView();
	virtual void __fastcall Invalidate();
	virtual void __fastcall ClearSelection();
	virtual void __fastcall SelectAll();
	HIDESBASE void __fastcall Refresh();
	HIDESBASE void __fastcall ColumnClick(Vcl::Comctrls::TListColumn* Column);
	virtual void __fastcall SetFocus();
	System::UnicodeString __fastcall PathForParsing(Vcl::Shell::Shellctrls::TShellFolder* AFolder);
	__property bool ColumnSorted = {read=FColumnSorted, write=SetColumnSorted, nodefault};
	__property int SortColumn = {read=FSortColumn, write=FSortColumn, nodefault};
	__property Unitlistviewsort::THeaderSortState SortState = {read=FSortState, write=FSortState, nodefault};
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
#endif	// TripManager_ShellListHPP
