// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmTransferOptions.pas' rev: 36.00 (Windows)

#ifndef UFrmTransferOptionsHPP
#define UFrmTransferOptionsHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.ImageList.hpp>
#include <Vcl.ImgList.hpp>
#include <UnitGpxDefs.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmtransferoptions
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmTransferOptions;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFrmTransferOptions : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* PnlBot;
	Vcl::Buttons::TBitBtn* BtnCancel;
	Vcl::Buttons::TBitBtn* BitBtn2;
	Vcl::Stdctrls::TMemo* MemoTransfer;
	Vcl::Stdctrls::TMemo* MemoDestinations;
	Vcl::Comctrls::TTreeView* TvSelections;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall TvSelectionsCheckStateChanging(Vcl::Comctrls::TCustomTreeView* Sender, Vcl::Comctrls::TTreeNode* Node, Vcl::Comctrls::TNodeCheckState NewCheckState, Vcl::Comctrls::TNodeCheckState OldCheckState, bool &AllowChange);
	
private:
	void __fastcall SetPrefs();
	void __fastcall StorePrefs();
	
public:
	Unitgpxdefs::TGPXFuncArray Funcs;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmTransferOptions(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmTransferOptions(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFrmTransferOptions(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmTransferOptions() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmTransferOptions(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmTransferOptions* FrmTransferOptions;
}	/* namespace Ufrmtransferoptions */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMTRANSFEROPTIONS)
using namespace Ufrmtransferoptions;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UFrmTransferOptionsHPP
