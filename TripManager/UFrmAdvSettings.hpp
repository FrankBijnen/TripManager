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
#include <Vcl.ValEdit.hpp>
#include <Vcl.ComCtrls.hpp>
#include <UnitGeoCode.hpp>
#include <Vcl.Menus.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmadvsettings
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmAdvSettings;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::UnicodeString, 2> Ufrmadvsettings__1;

class PASCALIMPLEMENTATION TFrmAdvSettings : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* BtnOK;
	Vcl::Stdctrls::TButton* BtnCancel;
	Vcl::Extctrls::TPanel* PnlBottom;
	Vcl::Comctrls::TPageControl* PctMain;
	Vcl::Comctrls::TTabSheet* TabXT2;
	Vcl::Valedit::TValueListEditor* VlXT2Settings;
	Vcl::Comctrls::TTabSheet* TabGeoCode;
	Vcl::Valedit::TValueListEditor* VlGeoCodeSettings;
	Vcl::Stdctrls::TMemo* MemoAddressFormat;
	Vcl::Extctrls::TPanel* PnlResult;
	Vcl::Stdctrls::TMemo* MemoResult;
	Vcl::Extctrls::TPanel* PnlAddressFormatTop;
	Vcl::Extctrls::TSplitter* Splitter1;
	Vcl::Extctrls::TPanel* PnlAddressFormat;
	Vcl::Stdctrls::TButton* BtnClearCoordCache;
	Vcl::Stdctrls::TButton* BtnBuilder;
	Vcl::Menus::TPopupMenu* PopupBuilder;
	Vcl::Menus::TMenuItem* Clear1;
	Vcl::Menus::TMenuItem* N1;
	Vcl::Menus::TMenuItem* StatePlaceRoadnr1;
	Vcl::Menus::TMenuItem* NrRoadPlaceState1;
	Vcl::Menus::TMenuItem* N2;
	Vcl::Menus::TMenuItem* Housenbr1;
	Vcl::Menus::TMenuItem* Road1;
	Vcl::Menus::TMenuItem* Smallestplace1;
	Vcl::Menus::TMenuItem* Largestplace1;
	Vcl::Menus::TMenuItem* State1;
	Vcl::Menus::TMenuItem* Countrycode1;
	Vcl::Menus::TMenuItem* Countrycode2;
	Vcl::Menus::TMenuItem* N3;
	Vcl::Menus::TMenuItem* Debug1;
	Vcl::Menus::TMenuItem* Hamlet1;
	Vcl::Menus::TMenuItem* Village1;
	Vcl::Menus::TMenuItem* N4;
	Vcl::Menus::TMenuItem* City1;
	Vcl::Menus::TMenuItem* postalcode1;
	Vcl::Menus::TMenuItem* City2;
	Vcl::Menus::TMenuItem* municipality1;
	Vcl::Menus::TMenuItem* N5;
	Vcl::Comctrls::TTabSheet* TabGeneral;
	Vcl::Valedit::TValueListEditor* VlGeneralSettings;
	Vcl::Menus::TMenuItem* Coords1;
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall MemoAddressFormatChange(System::TObject* Sender);
	void __fastcall VlGeoCodeSettingsStringsChange(System::TObject* Sender);
	void __fastcall BtnClearCoordCacheClick(System::TObject* Sender);
	void __fastcall BtnBuilderMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall Clear1Click(System::TObject* Sender);
	void __fastcall StatePlaceRoadnr1Click(System::TObject* Sender);
	void __fastcall NrRoadPlaceState1Click(System::TObject* Sender);
	void __fastcall Smallestplace1Click(System::TObject* Sender);
	void __fastcall Largestplace1Click(System::TObject* Sender);
	void __fastcall AddTag(System::TObject* Sender);
	
private:
	Unitgeocode::TPlace* SamplePlace;
	void __fastcall LoadSettings();
	void __fastcall SaveSettings();
	
public:
	System::UnicodeString SampleLat;
	System::UnicodeString SampleLon;
	void __fastcall SetFixedPrefs();
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmAdvSettings(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmAdvSettings(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFrmAdvSettings(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmAdvSettings() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmAdvSettings(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define TripManagerReg_Key L"Software\\TDBware\\TripManager"
#define PrefFileSysFolder_Key L"PrefFileSysFolder"
#define PrefDev_Key L"PrefDevice"
#define PrefDevTripsFolder_Key L"PrefDeviceTripsFolder"
#define PrefDevGpxFolder_Key L"PrefDeviceGpxFolder"
#define PrefDevPoiFolder_Key L"PrefDevicePoiFolder"
#define WarnModel_Key L"WarnModel"
#define TripColor_Key L"TripColor"
#define Maximized_Key L"Maximized"
#define WidthColumns_Key L"WidthColumns"
#define SortColumn_Key L"SortColumn"
#define SortAscending_Key L"SortAscending"
extern DELPHI_PACKAGE Ufrmadvsettings__1 BooleanValues;
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
