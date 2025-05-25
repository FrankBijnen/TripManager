// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'ListViewSort.pas' rev: 36.00 (Windows)

#ifndef ListViewSortHPP
#define ListViewSortHPP

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
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Winapi.CommCtrl.hpp>
#include <System.Math.hpp>
#include <System.DateUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Listviewsort
{
//-- forward type declarations -----------------------------------------------
struct TSortSpecification;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TSortSpecification
{
public:
	Vcl::Comctrls::TListColumn* Column;
	bool Ascending;
	bool UseObject;
	int __fastcall (*CompareItems)(const System::UnicodeString s1, const System::UnicodeString s2);
};


enum DECLSPEC_DENUM THeaderSortState : unsigned char { hssNone, hssAscending, hssDescending };

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE int __fastcall CompareTextAsInteger(const System::UnicodeString s1, const System::UnicodeString s2);
extern DELPHI_PACKAGE int __fastcall CompareTextAsDateTime(const System::UnicodeString s1, const System::UnicodeString s2);
extern DELPHI_PACKAGE THeaderSortState __fastcall GetListHeaderSortState(Vcl::Comctrls::TCustomListView* HeaderLView, Vcl::Comctrls::TListColumn* Column);
extern DELPHI_PACKAGE void __fastcall SetListHeaderSortState(Vcl::Comctrls::TCustomListView* HeaderLView, Vcl::Comctrls::TListColumn* Column, THeaderSortState Value);
extern DELPHI_PACKAGE void __fastcall ListViewCompare(Vcl::Comctrls::TListItem* Item1, Vcl::Comctrls::TListItem* Item2, const TSortSpecification &FSortSpecification, int Data, int &Compare);
extern DELPHI_PACKAGE void __fastcall InitSortSpec(Vcl::Comctrls::TListColumn* Column, bool Ascending, TSortSpecification &FSortSpecification);
extern DELPHI_PACKAGE void __fastcall DoListViewSort(Vcl::Comctrls::TListView* AListView, Vcl::Comctrls::TListColumn* Column, bool Ascending, TSortSpecification &FSortSpecification);
extern DELPHI_PACKAGE void __fastcall ListViewColumnClick(Vcl::Comctrls::TListView* AListView, Vcl::Comctrls::TListColumn* Column, TSortSpecification &FSortSpecification);
}	/* namespace Listviewsort */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_LISTVIEWSORT)
using namespace Listviewsort;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// ListViewSortHPP
