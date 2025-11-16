// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UfrmEditRoutePref.pas' rev: 36.00 (Windows)

#ifndef UfrmEditRoutePrefHPP
#define UfrmEditRoutePrefHPP

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
#include <Vcl.Grids.hpp>
#include <Vcl.ValEdit.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <UnitTripObjects.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmeditroutepref
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmEditRoutePref;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFrmEditRoutePref : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* PnlBot;
	Vcl::Buttons::TBitBtn* BtnCancel;
	Vcl::Buttons::TBitBtn* BtnOK;
	Vcl::Valedit::TValueListEditor* VlRoutePrefs;
	void __fastcall VlRoutePrefsGetPickList(System::TObject* Sender, const System::UnicodeString KeyName, System::Classes::TStrings* Values);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall VlRoutePrefsStringsChange(System::TObject* Sender);
	
private:
	System::Classes::TStringList* PickList;
	
public:
	bool VlModified;
	Unittripobjects::TTripList* CurTripList;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmEditRoutePref(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmEditRoutePref(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFrmEditRoutePref(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmEditRoutePref() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmEditRoutePref(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmEditRoutePref* FrmEditRoutePref;
}	/* namespace Ufrmeditroutepref */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMEDITROUTEPREF)
using namespace Ufrmeditroutepref;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UfrmEditRoutePrefHPP
