// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitVerySimpleXml.pas' rev: 36.00 (Windows)

#ifndef UnitVerySimpleXmlHPP
#define UnitVerySimpleXmlHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Xml.VerySimple.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitverysimplexml
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef Xml::Verysimple::TXmlVerySimple TXmlVSDocument;

typedef Xml::Verysimple::TXmlNode TXmlVSNode;

typedef Xml::Verysimple::TXmlNodeType TXmlVSNodeType;

typedef Xml::Verysimple::TXmlNodeTypes TXmlVSNodeTypes;

typedef Xml::Verysimple::TXmlNodeList TXmlVSNodeList;

typedef Xml::Verysimple::TXmlAttributeType TXmlVSAttributeType;

typedef Xml::Verysimple::TXmlOptions TXmlVSOptions;

typedef Xml::Verysimple::TXmlAttribute TXmlVSAttribute;

typedef Xml::Verysimple::TXmlAttributeList TXmlVSAttributeList;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall XMLPrefix(TXmlVSNode* const AName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FindSubNodeValue(TXmlVSNode* ANode, System::UnicodeString SubName);
}	/* namespace Unitverysimplexml */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITVERYSIMPLEXML)
using namespace Unitverysimplexml;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitVerySimpleXmlHPP
