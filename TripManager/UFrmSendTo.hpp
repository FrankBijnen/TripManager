// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmSendTo.pas' rev: 36.00 (Windows)

#ifndef UFrmSendToHPP
#define UFrmSendToHPP

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

namespace Ufrmsendto
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmSendTo;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TSendToDest : unsigned char { stDevice, stWindows };

class PASCALIMPLEMENTATION TFrmSendTo : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* PnlBot;
	Vcl::Buttons::TBitBtn* BtnCancel;
	Vcl::Buttons::TBitBtn* BtnOk;
	Vcl::Comctrls::TTreeView* TvSelections;
	Vcl::Stdctrls::TLabel* LblDestinations;
	Vcl::Comctrls::TStatusBar* StatusBar1;
	Vcl::Stdctrls::TGroupBox* GrpModel;
	Vcl::Stdctrls::TLabel* LblModel;
	Vcl::Stdctrls::TGroupBox* GrpDestination;
	Vcl::Stdctrls::TGroupBox* GrpTasks;
	Vcl::Stdctrls::TGroupBox* GrpSelDestination;
	Vcl::Comctrls::TPageControl* PCTDestination;
	Vcl::Comctrls::TTabSheet* TabDevice;
	Vcl::Stdctrls::TMemo* MemoTransfer;
	Vcl::Comctrls::TTabSheet* TabFolder;
	Vcl::Stdctrls::TMemo* MemoAdditional;
	Vcl::Stdctrls::TMemo* MemoTasks;
	Vcl::Buttons::TBitBtn* BtnHelp;
	Vcl::Extctrls::TPanel* PnlModel;
	Vcl::Stdctrls::TComboBox* CmbTripOption;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall PCTDestinationChange(System::TObject* Sender);
	void __fastcall TvSelectionsCheckStateChanging(Vcl::Comctrls::TCustomTreeView* Sender, Vcl::Comctrls::TTreeNode* Node, Vcl::Comctrls::TNodeCheckState NewCheckState, Vcl::Comctrls::TNodeCheckState OldCheckState, bool &AllowChange);
	void __fastcall PCTDestinationChanging(System::TObject* Sender, bool &AllowChange);
	void __fastcall TvSelectionsHint(System::TObject* Sender, Vcl::Comctrls::TTreeNode* const Node, System::UnicodeString &Hint);
	void __fastcall TvSelectionsCollapsing(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node, bool &AllowCollapse);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall TvSelectionsCheckStateChanged(Vcl::Comctrls::TCustomTreeView* Sender, Vcl::Comctrls::TTreeNode* Node, Vcl::Comctrls::TNodeCheckState CheckState);
	void __fastcall BtnHelpClick(System::TObject* Sender);
	
private:
	int GrpDestHeight;
	int GrpSelDestHeight;
	int FrmHeight;
	bool ShowHelp;
	void __fastcall EnableItems();
	void __fastcall UpdateDesign();
	void __fastcall SetPrefs();
	void __fastcall StorePrefs();
	
public:
	Unitgpxdefs::TGPXFuncArray Funcs;
	TSendToDest SendToDest;
	bool HasCurrentDevice;
	System::UnicodeString DisplayedDevice;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmSendTo(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmSendTo(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFrmSendTo(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmSendTo() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmSendTo(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmSendTo* FrmSendTo;
}	/* namespace Ufrmsendto */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMSENDTO)
using namespace Ufrmsendto;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UFrmSendToHPP
