// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmPostProcess.pas' rev: 35.00 (Windows)

#ifndef UfrmpostprocessHPP
#define UfrmpostprocessHPP

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
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmpostprocess
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmPostProcess;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFrmPostProcess : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* PnlBot;
	Vcl::Buttons::TBitBtn* BtnCancel;
	Vcl::Buttons::TBitBtn* BitBtn2;
	Vcl::Extctrls::TPanel* PnlBegin;
	Vcl::Extctrls::TPanel* PnlBeginCaption;
	Vcl::Controls::TImageList* ImgListSymbols;
	Vcl::Extctrls::TPanel* PnlBeginData;
	Vcl::Stdctrls::TEdit* EdBeginStr;
	Vcl::Comctrls::TComboBoxEx* CmbBeginSymbol;
	Vcl::Extctrls::TPanel* PnlEnd;
	Vcl::Extctrls::TPanel* PnlEndCaption;
	Vcl::Extctrls::TPanel* PnlEndData;
	Vcl::Stdctrls::TEdit* EdEndStr;
	Vcl::Comctrls::TComboBoxEx* CmbEndSymbol;
	Vcl::Stdctrls::TCheckBox* ChkProcessBegin;
	Vcl::Stdctrls::TCheckBox* ChkProcessEnd;
	Vcl::Extctrls::TPanel* PnlShape;
	Vcl::Extctrls::TPanel* PnlShapeCaption;
	Vcl::Stdctrls::TCheckBox* ChkProcessShape;
	Vcl::Extctrls::TPanel* PnlShapeData;
	Vcl::Stdctrls::TComboBox* CmbShapingName;
	Vcl::Stdctrls::TMemo* MemoPostProcess;
	Vcl::Stdctrls::TComboBox* CmbDistanceUnit;
	Vcl::Extctrls::TPanel* PnlWaypt;
	Vcl::Extctrls::TPanel* PnlWayptCaption;
	Vcl::Stdctrls::TCheckBox* ChkProcessWpt;
	Vcl::Extctrls::TPanel* PnlWayptData;
	Vcl::Stdctrls::TComboBox* CmbWayPtCat;
	Vcl::Stdctrls::TEdit* EdWptStr;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall FormCreate(System::TObject* Sender);
	
private:
	bool SymbolsLoaded;
	void __fastcall LoadSymbols();
	void __fastcall SetFixedPrefs();
	void __fastcall SetPrefs();
	void __fastcall StorePrefs();
	
public:
	void __fastcall SetPreferences();
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmPostProcess(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmPostProcess(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmPostProcess() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmPostProcess(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmPostProcess* FrmPostProcess;
}	/* namespace Ufrmpostprocess */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMPOSTPROCESS)
using namespace Ufrmpostprocess;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UfrmpostprocessHPP
