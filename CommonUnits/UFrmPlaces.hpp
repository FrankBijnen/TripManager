// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmPlaces.pas' rev: 36.00 (Windows)

#ifndef UFrmPlacesHPP
#define UFrmPlacesHPP

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
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.ComCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmplaces
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmPlaces;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFrmPlaces : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Buttons::TBitBtn* BtnOk;
	Vcl::Buttons::TBitBtn* BtnCancel;
	Vcl::Comctrls::TListView* ListView1;
	Vcl::Buttons::TBitBtn* BtnRetry;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ListView1DblClick(System::TObject* Sender);
	
public:
	void __fastcall AddPlace2LV(System::UnicodeString PLace, System::UnicodeString Lat, System::UnicodeString Lon);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmPlaces(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmPlaces(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFrmPlaces(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmPlaces() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmPlaces(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmPlaces* FrmPlaces;
}	/* namespace Ufrmplaces */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMPLACES)
using namespace Ufrmplaces;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UFrmPlacesHPP
