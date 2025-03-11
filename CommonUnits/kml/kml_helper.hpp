// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'kml_helper.pas' rev: 36.00 (Windows)

#ifndef kml_helperHPP
#define kml_helperHPP

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
#include <Xml.xmldom.hpp>
#include <Xml.XMLIntf.hpp>
#include <Xml.XMLDoc.hpp>
#include <ogckml23.hpp>

//-- user supplied -----------------------------------------------------------

namespace Kml_helper
{
//-- forward type declarations -----------------------------------------------
struct TStyleMap;
class DELPHICLASS TKMLHelper;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TStyleMap
{
public:
	System::UnicodeString Key;
	System::UnicodeString Style;
	double Scale;
	__fastcall TStyleMap(System::UnicodeString Akey, System::UnicodeString AStyle, double AScale);
	TStyleMap() {}
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TKMLHelper : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::Classes::TStringList* Coordinates;
	System::UnicodeString FPathName;
	System::UnicodeString FTrackName;
	System::UnicodeString FColor;
	Ogckml23::_di_IXMLDocumentType FNewDoc;
	Ogckml23::_di_IXMLDocumentType __fastcall NewKMLDocument();
	void __fastcall WriteLineStyle(Xml::Xmlintf::_di_IXMLNode AStyle, System::UnicodeString AColor = L"Magenta");
	void __fastcall WriteStyle(const TStyleMap &AStyle);
	void __fastcall WriteStyleMap(TStyleMap *Styles, const System::NativeInt Styles_High);
	Xml::Xmlintf::_di_IXMLNode __fastcall WriteFolder(System::UnicodeString AName, System::UnicodeString ACoordinates);
	void __fastcall WriteHeader(bool ARing = false);
	void __fastcall WritePointsStart(const System::UnicodeString ATrackName, const System::UnicodeString AColor);
	void __fastcall WritePoint(const System::UnicodeString ALon, const System::UnicodeString ALat, const System::UnicodeString AEle);
	Xml::Xmlintf::_di_IXMLNode __fastcall WritePointsEnd();
	Xml::Xmlintf::_di_IXMLNode __fastcall WritePlacesStart(System::UnicodeString AName);
	void __fastcall WritePlace(Xml::Xmlintf::_di_IXMLNode AFolder, System::UnicodeString ACoordinates, System::UnicodeString AName, System::UnicodeString ADescription = System::UnicodeString());
	void __fastcall WritePlacesEnd();
	void __fastcall WriteFooter();
	void __fastcall WriteKml();
	System::Sysutils::TFormatSettings FormatSettings;
	__fastcall TKMLHelper(System::UnicodeString APathName);
	__fastcall virtual ~TKMLHelper();
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define KML_StyleUrl L"m_ylw-pushpin"
#define Href L"http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.pn"\
	L"g"
}	/* namespace Kml_helper */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_KML_HELPER)
using namespace Kml_helper;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// kml_helperHPP
