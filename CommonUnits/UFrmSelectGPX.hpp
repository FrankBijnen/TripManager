// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmSelectGPX.pas' rev: 35.00 (Windows)

#ifndef UfrmselectgpxHPP
#define UfrmselectgpxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmselectgpx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmSelectGPX;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFrmSelectGPX : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Comctrls::TListView* LvTracks;
	Vcl::Extctrls::TPanel* PnlTop;
	Vcl::Extctrls::TPanel* PnlBot;
	Vcl::Buttons::TBitBtn* BitBtnOK;
	Vcl::Buttons::TBitBtn* BitBtnCan;
	Vcl::Menus::TPopupMenu* PopupMenu1;
	Vcl::Menus::TMenuItem* CheckAll1;
	Vcl::Menus::TMenuItem* CheckNone1;
	Vcl::Extctrls::TPanel* PnlClear;
	Vcl::Stdctrls::TComboBox* CmbOverruleColor;
	Vcl::Stdctrls::TLabel* lblChangeColor;
	void __fastcall CheckAll1Click(System::TObject* Sender);
	void __fastcall CheckNone1Click(System::TObject* Sender);
	void __fastcall LvTracksChange(System::TObject* Sender, Vcl::Comctrls::TListItem* Item, Vcl::Comctrls::TItemChange Change);
	void __fastcall CmbOverruleColorClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	
public:
	void __fastcall LoadTracks(System::Classes::TStringList* const TrackList);
	System::UnicodeString __fastcall TrackSelectedColor(const System::UnicodeString TrackName);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmSelectGPX(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmSelectGPX(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmSelectGPX() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmSelectGPX(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmSelectGPX* FrmSelectGPX;
}	/* namespace Ufrmselectgpx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMSELECTGPX)
using namespace Ufrmselectgpx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UfrmselectgpxHPP
