// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitGeoCode.pas' rev: 36.00 (Windows)

#ifndef UnitGeoCodeHPP
#define UnitGeoCodeHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <System.Generics.Collections.hpp>
#include <System.IniFiles.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Edge.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitgeocode
{
//-- forward type declarations -----------------------------------------------
struct GEOsettingsRec;
class DELPHICLASS TPlace;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TExecRestEvent)(System::UnicodeString Url, System::UnicodeString Response, bool Succes);

struct DECLSPEC_DRECORD GEOsettingsRec
{
public:
	System::UnicodeString GeoCodeUrl;
	System::UnicodeString GeoCodeApiKey;
	System::UnicodeString AddressFormat;
	int ThrottleGeoCode;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TPlace : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TStringList* FAddressList;
	System::UnicodeString __fastcall GetHtmlPlace();
	System::UnicodeString __fastcall GetDisplayPlace();
	System::UnicodeString __fastcall GetFormattedAddress(System::UnicodeString AnAddressFormat)/* overload */;
	System::UnicodeString __fastcall GetFormattedAddress()/* overload */;
	System::UnicodeString __fastcall GetRoutePlace();
	System::UnicodeString __fastcall GetRoad();
	System::UnicodeString __fastcall GetCity();
	System::UnicodeString __fastcall GetState();
	System::UnicodeString __fastcall GetCountry();
	System::UnicodeString __fastcall GetPostalCode();
	
public:
	__fastcall TPlace();
	__fastcall virtual ~TPlace();
	void __fastcall Clear();
	void __fastcall AssignFromGeocode(System::UnicodeString Key, System::UnicodeString Value);
	__classmethod System::UnicodeString __fastcall UnEscape(System::UnicodeString Value);
	__property System::UnicodeString HtmlPlace = {read=GetHtmlPlace};
	__property System::UnicodeString DisplayPlace = {read=GetDisplayPlace};
	__property System::UnicodeString RoutePlace = {read=GetRoutePlace};
	__property System::UnicodeString FormattedAddress = {read=GetFormattedAddress};
	__property System::UnicodeString Road = {read=GetRoad};
	__property System::UnicodeString City = {read=GetCity};
	__property System::UnicodeString State = {read=GetState};
	__property System::UnicodeString Country = {read=GetCountry};
	__property System::UnicodeString PostalCode = {read=GetPostalCode};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define DefState L"ISO3166-2-lvl4,state"
#define DefCity L"village,town,city,municipality,hamlet"
#define DefRoadHouse L"road+house_number"
#define DefHouseRoad L"house_number+road"
#define DefCountry L"country"
#define DefPostalCode L"postcode"
#define Reg_GeoCodeUrl L"GeoCodeUrl"
#define Reg_GeoCodeApiKey L"GeoCodeApiKey"
#define Reg_AddressFormat L"AddressFormat"
#define Reg_ThrottleGeoCode L"ThrottleGeoCode"
#define Reg_SelectUniqPlace L"SelectUniqPlace"
static _DELPHI_CONST System::Int8 Place_Decimals = System::Int8(0x4);
extern DELPHI_PACKAGE GEOsettingsRec GeoSettings;
extern DELPHI_PACKAGE TExecRestEvent ExecRestEvent;
extern DELPHI_PACKAGE System::UnicodeString GeoCodeCache;
extern DELPHI_PACKAGE TPlace* __fastcall GetPlaceOfCoords(const System::UnicodeString Lat, const System::UnicodeString Lon, HWND hWnd = (HWND)(0x0), unsigned Msg = (unsigned)(0x0), bool UseCache = true);
extern DELPHI_PACKAGE void __fastcall ClearCoordCache();
extern DELPHI_PACKAGE void __fastcall GetCoordsOfPlace(const System::UnicodeString Place, System::UnicodeString &Lat, System::UnicodeString &Lon);
extern DELPHI_PACKAGE void __fastcall ReadGeoCodeSettings();
}	/* namespace Unitgeocode */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITGEOCODE)
using namespace Unitgeocode;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitGeoCodeHPP
