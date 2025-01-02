// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmDateDialog.pas' rev: 35.00 (Windows)

#ifndef UfrmdatedialogHPP
#define UfrmdatedialogHPP

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

//-- user supplied -----------------------------------------------------------

namespace Ufrmdatedialog
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmDateDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFrmDateDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* PnlBot;
	Vcl::Buttons::TBitBtn* BtnCancel;
	Vcl::Buttons::TBitBtn* BitBtn2;
	Vcl::Comctrls::TDateTimePicker* DtPicker;
	Vcl::Stdctrls::TCheckBox* ChkIncrement;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmDateDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmDateDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmDateDialog() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmDateDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmDateDialog* FrmDateDialog;
}	/* namespace Ufrmdatedialog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMDATEDIALOG)
using namespace Ufrmdatedialog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UfrmdatedialogHPP
