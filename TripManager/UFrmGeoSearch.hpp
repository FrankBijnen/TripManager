// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmGeoSearch.pas' rev: 36.00 (Windows)

#ifndef UFrmGeoSearchHPP
#define UFrmGeoSearchHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Mask.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Buttons.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmgeosearch
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFGeoSearch;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFGeoSearch : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TPageControl* PctMain;
	Vcl::Comctrls::TTabSheet* TabFreeSearch;
	Vcl::Extctrls::TLabeledEdit* EdSearchFree;
	Vcl::Comctrls::TTabSheet* TabFormattedSearch;
	Vcl::Stdctrls::TMemo* MemoFreeSearch;
	Vcl::Stdctrls::TMemo* MemoFormatted;
	Vcl::Extctrls::TLabeledEdit* EdStreet;
	Vcl::Extctrls::TLabeledEdit* EdCity;
	Vcl::Extctrls::TLabeledEdit* EdCounty;
	Vcl::Extctrls::TLabeledEdit* EdState;
	Vcl::Extctrls::TLabeledEdit* EdCountry;
	Vcl::Extctrls::TLabeledEdit* EdPostalCode;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Buttons::TBitBtn* BtnOk;
	Vcl::Buttons::TBitBtn* BtnCancel;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	
private:
	void __fastcall UpdateDesign();
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFGeoSearch(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFGeoSearch(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFGeoSearch(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFGeoSearch() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFGeoSearch(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFGeoSearch* FGeoSearch;
}	/* namespace Ufrmgeosearch */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMGEOSEARCH)
using namespace Ufrmgeosearch;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UFrmGeoSearchHPP
