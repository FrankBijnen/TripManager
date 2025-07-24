// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmAdvSettings.pas' rev: 36.00 (Windows)

#ifndef UFrmAdvSettingsHPP
#define UFrmAdvSettingsHPP

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
#include <Vcl.Grids.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmadvsettings
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmAdvSettings;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TFrmAdvSettings : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* BtnOK;
	Vcl::Stdctrls::TButton* BtnCancel;
	Vcl::Extctrls::TPanel* PnlBottom;
	Vcl::Comctrls::TPageControl* PctMain;
	Vcl::Comctrls::TTabSheet* TabZumo;
	Vcl::Comctrls::TTabSheet* TabGeoCode;
	Vcl::Stdctrls::TMemo* MemoAddressFormat;
	Vcl::Extctrls::TPanel* PnlResult;
	Vcl::Stdctrls::TMemo* MemoResult;
	Vcl::Extctrls::TPanel* PnlAddressFormatTop;
	Vcl::Extctrls::TSplitter* Splitter1;
	Vcl::Extctrls::TPanel* PnlAddressFormat;
	Vcl::Stdctrls::TButton* BtnBuilder;
	Vcl::Comctrls::TTabSheet* TabGeneral;
	Vcl::Grids::TStringGrid* GridGeneralSettings;
	Vcl::Grids::TStringGrid* GridZumoSettings;
	Vcl::Menus::TPopupMenu* PopupBuilder;
	Vcl::Grids::TStringGrid* GridGeoCodeSettings;
	Vcl::Extctrls::TPanel* PnlGeoCodeFuncs;
	Vcl::Stdctrls::TButton* BtnValidate;
	Vcl::Stdctrls::TButton* BtnClearCoordCache;
	Vcl::Comctrls::TTabSheet* TabDevice;
	Vcl::Grids::TStringGrid* GridDeviceSettings;
	Vcl::Extctrls::TPanel* PnlZumoFuncs;
	Vcl::Stdctrls::TButton* BtnCurrent;
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall MemoAddressFormatChange(System::TObject* Sender);
	void __fastcall BtnBuilderMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall Clear1Click(System::TObject* Sender);
	void __fastcall StatePlaceRoadnr1Click(System::TObject* Sender);
	void __fastcall NrRoadPlaceState1Click(System::TObject* Sender);
	void __fastcall Smallestplace1Click(System::TObject* Sender);
	void __fastcall Largestplace1Click(System::TObject* Sender);
	void __fastcall AddTag(System::TObject* Sender);
	void __fastcall BtnValidateClick(System::TObject* Sender);
	void __fastcall BtnClearCoordCacheClick(System::TObject* Sender);
	void __fastcall BtnCurrentClick(System::TObject* Sender);
	void __fastcall PctMainResize(System::TObject* Sender);
	
private:
	System::TObject* SamplePlace;
	System::UnicodeString __fastcall GetSampleDataItem(System::TObject* const ABase);
	System::UnicodeString __fastcall GetSampleItem(const System::ShortString &KeyName);
	System::UnicodeString __fastcall GetSampleLocationItem(const System::UnicodeString ClassName);
	void __fastcall LookupSamplePlace(bool UseCache);
	void __fastcall ValidateApiKey();
	void __fastcall LoadSettings_General();
	void __fastcall LoadSettings_Device();
	void __fastcall LoadSettings_XT2();
	void __fastcall LoadSettings_GeoCode();
	void __fastcall LoadSettings();
	void __fastcall SaveGrid(Vcl::Grids::TStringGrid* AGrid);
	void __fastcall SaveSettings();
	
public:
	System::TObject* SampleTrip;
	System::UnicodeString SampleLat;
	System::UnicodeString SampleLon;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmAdvSettings(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmAdvSettings(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFrmAdvSettings(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmAdvSettings() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmAdvSettings(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmAdvSettings* FrmAdvSettings;
}	/* namespace Ufrmadvsettings */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMADVSETTINGS)
using namespace Ufrmadvsettings;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UFrmAdvSettingsHPP
