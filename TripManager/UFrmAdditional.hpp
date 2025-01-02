// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmAdditional.pas' rev: 35.00 (Windows)

#ifndef UfrmadditionalHPP
#define UfrmadditionalHPP

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
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.ImageList.hpp>
#include <Vcl.ImgList.hpp>
#include <UnitGPX.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmadditional
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmAdditional;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFrmAdditional : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
	
private:
	typedef System::DynamicArray<Unitgpx::TGPXFunc> _TFrmAdditional__1;
	
	
__published:
	Vcl::Extctrls::TPanel* PnlBot;
	Vcl::Buttons::TBitBtn* BtnCancel;
	Vcl::Buttons::TBitBtn* BitBtn2;
	Vcl::Stdctrls::TMemo* MemoPostProcess;
	Vcl::Comctrls::TTreeView* TvSelections;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	
private:
	void __fastcall SetPrefs();
	void __fastcall StorePrefs();
	
public:
	_TFrmAdditional__1 Funcs;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmAdditional(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmAdditional(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmAdditional() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmAdditional(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmAdditional* FrmAdditional;
}	/* namespace Ufrmadditional */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMADDITIONAL)
using namespace Ufrmadditional;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UfrmadditionalHPP
