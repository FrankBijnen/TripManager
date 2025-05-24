// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmNewTrip.pas' rev: 36.00 (Windows)

#ifndef UFrmNewTripHPP
#define UFrmNewTripHPP

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
#include <UnitMtpDevice.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmnewtrip
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmNewTrip;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFrmNewTrip : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* PnlBot;
	Vcl::Buttons::TBitBtn* BtnCancel;
	Vcl::Buttons::TBitBtn* BtnOk;
	Vcl::Stdctrls::TEdit* EdNewTrip;
	Vcl::Stdctrls::TEdit* EdResultFile;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	void __fastcall ChkDeviceClick(System::TObject* Sender);
	void __fastcall EdNewTripChange(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	
private:
	void __fastcall ShowResultFile();
	bool __fastcall CheckTripExists();
	
public:
	System::UnicodeString SavedFolderId;
	Unitmtpdevice::TMTP_Device* CurrentDevice;
	System::UnicodeString DevicePath;
	System::UnicodeString CurPath;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmNewTrip(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmNewTrip(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFrmNewTrip(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmNewTrip() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmNewTrip(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmNewTrip* FrmNewTrip;
}	/* namespace Ufrmnewtrip */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMNEWTRIP)
using namespace Ufrmnewtrip;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UFrmNewTripHPP
