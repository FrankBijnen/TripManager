// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Xml.VerySimple.pas' rev: 36.00 (Windows)

#ifndef Xml_VerySimpleHPP
#define Xml_VerySimpleHPP

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
#include <System.Generics.Defaults.hpp>
#include <System.Generics.Collections.hpp>
#include <System.Rtti.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Xml
{
namespace Verysimple
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS WeakAttribute;
class DELPHICLASS TXmlStreamReader;
class DELPHICLASS TXmlAttribute;
class DELPHICLASS TXmlAttributeList;
class DELPHICLASS TXmlNode;
class DELPHICLASS TXmlNodeList;
class DELPHICLASS TXmlVerySimple;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TXmlNodeType : unsigned char { ntElement, ntText, ntCData, ntProcessingInstr, ntComment, ntDocument, ntDocType, ntXmlDecl };

typedef System::Set<TXmlNodeType, TXmlNodeType::ntElement, TXmlNodeType::ntXmlDecl> TXmlNodeTypes;

enum DECLSPEC_DENUM TXmlAttributeType : unsigned char { atValue, atSingle };

enum DECLSPEC_DENUM Xml_Verysimple__1 : unsigned char { doNodeAutoIndent, doCompact, doParseProcessingInstr, doPreserveWhiteSpace, doCaseInsensitive, doWriteBOM, doNoHeader };

typedef System::Set<Xml_Verysimple__1, Xml_Verysimple__1::doNodeAutoIndent, Xml_Verysimple__1::doNoHeader> TXmlOptions;

enum DECLSPEC_DENUM Xml_Verysimple__2 : unsigned char { etoDeleteStopChar, etoStopString };

typedef System::Set<Xml_Verysimple__2, Xml_Verysimple__2::etoDeleteStopChar, Xml_Verysimple__2::etoStopString> TExtractTextOptions;

#pragma pack(push,4)
class PASCALIMPLEMENTATION WeakAttribute : public System::TCustomAttribute
{
	typedef System::TCustomAttribute inherited;
	
public:
	/* TObject.Create */ inline __fastcall WeakAttribute() : System::TCustomAttribute() { }
	/* TObject.Destroy */ inline __fastcall virtual ~WeakAttribute() { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TStreamReaderFillBuffer)(System::Sysutils::TEncoding* &Encoding);

class PASCALIMPLEMENTATION TXmlStreamReader : public System::Classes::TStreamReader
{
	typedef System::Classes::TStreamReader inherited;
	
protected:
	System::Sysutils::TStringBuilder* FBufferedData;
	bool *FNoDataInStream;
	TStreamReaderFillBuffer FFillBuffer;
	HIDESBASE void __fastcall FillBuffer();
	
public:
	__fastcall TXmlStreamReader(System::Classes::TStream* Stream, System::Sysutils::TEncoding* Encoding, bool DetectBOM, int BufferSize);
	bool __fastcall PrepareBuffer(int Value);
	virtual System::UnicodeString __fastcall ReadText(const System::UnicodeString StopChars, TExtractTextOptions Options);
	System::UnicodeString __fastcall FirstChar();
	virtual void __fastcall IncCharPos(int Value = 0x1);
	virtual bool __fastcall IsUppercaseText(const System::UnicodeString Value);
public:
	/* TStreamReader.Destroy */ inline __fastcall virtual ~TXmlStreamReader() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TXmlAttribute : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::UnicodeString FValue;
	
protected:
	virtual void __fastcall SetValue(const System::UnicodeString Value);
	
public:
	System::UnicodeString Name;
	TXmlAttributeType AttributeType;
	__fastcall virtual TXmlAttribute();
	System::UnicodeString __fastcall AsString();
	__classmethod virtual System::UnicodeString __fastcall Escape(const System::UnicodeString Value);
	virtual void __fastcall Assign(TXmlAttribute* Source);
	__property System::UnicodeString Value = {read=FValue, write=SetValue};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TXmlAttribute() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TXmlAttributeList : public System::Generics::Collections::TObjectList__1<TXmlAttribute*>
{
	typedef System::Generics::Collections::TObjectList__1<TXmlAttribute*> inherited;
	
public:
	TXmlVerySimple* Document;
	HIDESBASE virtual TXmlAttribute* __fastcall Add(const System::UnicodeString Name)/* overload */;
	virtual TXmlAttribute* __fastcall Find(const System::UnicodeString Name);
	HIDESBASE virtual void __fastcall Delete(const System::UnicodeString Name)/* overload */;
	virtual bool __fastcall HasAttribute(const System::UnicodeString AttrName);
	virtual System::UnicodeString __fastcall AsString();
	virtual void __fastcall Assign(TXmlAttributeList* Source);
public:
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlAttribute>.Create */ inline __fastcall TXmlAttributeList()/* overload */ : System::Generics::Collections::TObjectList__1<TXmlAttribute*>() { }
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlAttribute>.Create */ inline __fastcall TXmlAttributeList(bool AOwnsObjects)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlAttribute*>(AOwnsObjects) { }
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlAttribute>.Create */ inline __fastcall TXmlAttributeList(const System::DelphiInterface<System::Generics::Defaults::IComparer__1<TXmlAttribute*> > AComparer, bool AOwnsObjects)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlAttribute*>(AComparer, AOwnsObjects) { }
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlAttribute>.Create */ inline __fastcall TXmlAttributeList(System::Generics::Collections::TEnumerable__1<TXmlAttribute*>* const Collection, bool AOwnsObjects)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlAttribute*>(Collection, AOwnsObjects) { }
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlAttribute>.Destroy */ inline __fastcall virtual ~TXmlAttributeList() { }
	
public:
	/* {System_Generics_Collections}TList<Xml_VerySimple_TXmlAttribute>.Create */ inline __fastcall TXmlAttributeList(const System::DelphiInterface<System::Generics::Defaults::IComparer__1<TXmlAttribute*> > AComparer)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlAttribute*>(AComparer) { }
	/* {System_Generics_Collections}TList<Xml_VerySimple_TXmlAttribute>.Create */ inline __fastcall TXmlAttributeList(System::Generics::Collections::TEnumerable__1<TXmlAttribute*>* const Collection)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlAttribute*>(Collection) { }
	/* {System_Generics_Collections}TList<Xml_VerySimple_TXmlAttribute>.Create */ inline __fastcall TXmlAttributeList(const System::DelphiInterface<System::IEnumerable__1<TXmlAttribute*> > Collection)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlAttribute*>(Collection) { }
	/* {System_Generics_Collections}TList<Xml_VerySimple_TXmlAttribute>.Create */ inline __fastcall TXmlAttributeList(TXmlAttribute* const *Values, const System::NativeInt Values_High)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlAttribute*>(Values, Values_High) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TXmlNode : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TXmlVerySimple* FDocument;
	void __fastcall SetDocument(TXmlVerySimple* Value);
	virtual System::UnicodeString __fastcall GetAttr(const System::UnicodeString AttrName);
	virtual void __fastcall SetAttr(const System::UnicodeString AttrName, const System::UnicodeString AttrValue);
	
public:
	TXmlAttributeList* AttributeList;
	TXmlNodeList* ChildNodes;
	System::UnicodeString Name;
	TXmlNodeType NodeType;
	TXmlNode* Parent;
	System::UnicodeString Text;
	__fastcall virtual TXmlNode(TXmlNodeType ANodeType);
	__fastcall virtual ~TXmlNode();
	void __fastcall Clear();
	virtual int __fastcall FindPos(TXmlNode* Node)/* overload */;
	virtual int __fastcall FindPos(const System::UnicodeString Name, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual int __fastcall FindPos(const System::UnicodeString Name, const System::UnicodeString NodeValue, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual TXmlNode* __fastcall Find(const System::UnicodeString Name, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual TXmlNode* __fastcall Find(const System::UnicodeString Name, const System::UnicodeString AttrName, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual TXmlNode* __fastcall Find(const System::UnicodeString Name, const System::UnicodeString AttrName, const System::UnicodeString AttrValue, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual TXmlNodeList* __fastcall FindNodes(const System::UnicodeString Name, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ));
	virtual bool __fastcall HasAttribute(const System::UnicodeString AttrName);
	virtual bool __fastcall HasChild(const System::UnicodeString Name, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ));
	virtual TXmlNode* __fastcall AddChild(const System::UnicodeString AName, TXmlNodeType ANodeType = (TXmlNodeType)(0x0));
	virtual TXmlNode* __fastcall InsertChild(const System::UnicodeString Name, int Position, TXmlNodeType NodeType = (TXmlNodeType)(0x0));
	virtual TXmlNode* __fastcall SetText(const System::UnicodeString Value);
	virtual TXmlNode* __fastcall SetAttribute(const System::UnicodeString AttrName, const System::UnicodeString AttrValue);
	virtual TXmlNode* __fastcall FirstChild();
	virtual TXmlNode* __fastcall LastChild();
	virtual TXmlNode* __fastcall NextSibling()/* overload */;
	virtual TXmlNode* __fastcall PreviousSibling()/* overload */;
	virtual bool __fastcall HasChildNodes();
	virtual bool __fastcall IsTextElement();
	virtual TXmlNode* __fastcall SetNodeType(TXmlNodeType Value);
	__property System::UnicodeString Attributes[const System::UnicodeString AttrName] = {read=GetAttr, write=SetAttr};
	__property TXmlVerySimple* Document = {read=FDocument, write=SetDocument};
	__property System::UnicodeString NodeName = {read=Name, write=Name};
	__property System::UnicodeString NodeValue = {read=Text, write=Text};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TXmlNodeList : public System::Generics::Collections::TObjectList__1<TXmlNode*>
{
	typedef System::Generics::Collections::TObjectList__1<TXmlNode*> inherited;
	
protected:
	virtual bool __fastcall IsSame(const System::UnicodeString Value1, const System::UnicodeString Value2);
	
public:
	TXmlVerySimple* Document;
	TXmlNode* Parent;
	HIDESBASE virtual int __fastcall Add(TXmlNode* Value)/* overload */;
	HIDESBASE virtual TXmlNode* __fastcall Add(TXmlNodeType NodeType = (TXmlNodeType)(0x0))/* overload */;
	HIDESBASE virtual TXmlNode* __fastcall Add(const System::UnicodeString Name, TXmlNodeType NodeType = (TXmlNodeType)(0x0))/* overload */;
	virtual int __fastcall FindPos(TXmlNode* Node)/* overload */;
	virtual int __fastcall FindPos(const System::UnicodeString Name, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual int __fastcall FindPos(const System::UnicodeString Name, const System::UnicodeString NodeValue, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual TXmlNode* __fastcall Find(const System::UnicodeString Name, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual TXmlNode* __fastcall FindNode(const System::UnicodeString Name, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ));
	virtual TXmlNode* __fastcall Find(const System::UnicodeString Name, const System::UnicodeString AttrName, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual TXmlNode* __fastcall Find(const System::UnicodeString Name, const System::UnicodeString AttrName, const System::UnicodeString AttrValue, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ))/* overload */;
	virtual TXmlNodeList* __fastcall FindNodes(const System::UnicodeString Name, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ));
	virtual bool __fastcall HasNode(const System::UnicodeString Name, TXmlNodeTypes NodeTypes = (TXmlNodeTypes() << TXmlNodeType::ntElement ));
	HIDESBASE virtual TXmlNode* __fastcall Insert(const System::UnicodeString Name, int Position, TXmlNodeType NodeType = (TXmlNodeType)(0x0))/* overload */;
	virtual TXmlNode* __fastcall FirstChild();
	virtual TXmlNode* __fastcall NextSibling(TXmlNode* Node);
	virtual TXmlNode* __fastcall PreviousSibling(TXmlNode* Node);
	virtual TXmlNode* __fastcall Get(int Index);
public:
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlNode>.Create */ inline __fastcall TXmlNodeList()/* overload */ : System::Generics::Collections::TObjectList__1<TXmlNode*>() { }
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlNode>.Create */ inline __fastcall TXmlNodeList(bool AOwnsObjects)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlNode*>(AOwnsObjects) { }
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlNode>.Create */ inline __fastcall TXmlNodeList(const System::DelphiInterface<System::Generics::Defaults::IComparer__1<TXmlNode*> > AComparer, bool AOwnsObjects)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlNode*>(AComparer, AOwnsObjects) { }
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlNode>.Create */ inline __fastcall TXmlNodeList(System::Generics::Collections::TEnumerable__1<TXmlNode*>* const Collection, bool AOwnsObjects)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlNode*>(Collection, AOwnsObjects) { }
	/* {System_Generics_Collections}TObjectList<Xml_VerySimple_TXmlNode>.Destroy */ inline __fastcall virtual ~TXmlNodeList() { }
	
public:
	/* {System_Generics_Collections}TList<Xml_VerySimple_TXmlNode>.Create */ inline __fastcall TXmlNodeList(const System::DelphiInterface<System::Generics::Defaults::IComparer__1<TXmlNode*> > AComparer)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlNode*>(AComparer) { }
	/* {System_Generics_Collections}TList<Xml_VerySimple_TXmlNode>.Create */ inline __fastcall TXmlNodeList(System::Generics::Collections::TEnumerable__1<TXmlNode*>* const Collection)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlNode*>(Collection) { }
	/* {System_Generics_Collections}TList<Xml_VerySimple_TXmlNode>.Create */ inline __fastcall TXmlNodeList(const System::DelphiInterface<System::IEnumerable__1<TXmlNode*> > Collection)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlNode*>(Collection) { }
	/* {System_Generics_Collections}TList<Xml_VerySimple_TXmlNode>.Create */ inline __fastcall TXmlNodeList(TXmlNode* const *Values, const System::NativeInt Values_High)/* overload */ : System::Generics::Collections::TObjectList__1<TXmlNode*>(Values, Values_High) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TXmlVerySimple : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TXmlNode* Root;
	TXmlNode* FHeader;
	TXmlNode* FDocumentElement;
	bool SkipIndent;
	virtual void __fastcall Parse(TXmlStreamReader* Reader);
	virtual void __fastcall ParseComment(TXmlStreamReader* Reader, TXmlNode* &Parent);
	virtual void __fastcall ParseDocType(TXmlStreamReader* Reader, TXmlNode* &Parent);
	virtual void __fastcall ParseProcessingInstr(TXmlStreamReader* Reader, TXmlNode* &Parent);
	virtual void __fastcall ParseCData(TXmlStreamReader* Reader, TXmlNode* &Parent);
	virtual void __fastcall ParseText(const System::UnicodeString Line, TXmlNode* Parent);
	virtual TXmlNode* __fastcall ParseTag(TXmlStreamReader* Reader, bool ParseText, TXmlNode* &Parent)/* overload */;
	virtual TXmlNode* __fastcall ParseTag(const System::UnicodeString TagStr, TXmlNode* &Parent)/* overload */;
	virtual void __fastcall Walk(System::Classes::TStreamWriter* Writer, const System::UnicodeString PrefixNode, TXmlNode* Node);
	virtual void __fastcall SetText(const System::UnicodeString Value);
	virtual System::UnicodeString __fastcall GetText();
	virtual void __fastcall SetEncoding(const System::UnicodeString Value);
	virtual System::UnicodeString __fastcall GetEncoding();
	virtual void __fastcall SetVersion(const System::UnicodeString Value);
	virtual System::UnicodeString __fastcall GetVersion();
	virtual void __fastcall Compose(System::Classes::TStreamWriter* Writer);
	virtual void __fastcall SetStandAlone(const System::UnicodeString Value);
	virtual System::UnicodeString __fastcall GetStandAlone();
	virtual TXmlNodeList* __fastcall GetChildNodes();
	virtual void __fastcall CreateHeaderNode();
	virtual System::UnicodeString __fastcall ExtractText(System::UnicodeString &Line, const System::UnicodeString StopChars, TExtractTextOptions Options);
	virtual void __fastcall SetDocumentElement(TXmlNode* Value);
	void __fastcall SetPreserveWhitespace(bool Value);
	bool __fastcall GetPreserveWhitespace();
	bool __fastcall IsSame(const System::UnicodeString Value1, const System::UnicodeString Value2);
	
public:
	System::UnicodeString NodeIndentStr;
	System::UnicodeString LineBreak;
	TXmlOptions Options;
	__fastcall virtual TXmlVerySimple();
	__fastcall virtual ~TXmlVerySimple();
	virtual void __fastcall Clear();
	virtual TXmlNode* __fastcall AddChild(const System::UnicodeString Name, TXmlNodeType NodeType = (TXmlNodeType)(0x0));
	virtual TXmlNode* __fastcall CreateNode(const System::UnicodeString Name, TXmlNodeType NodeType = (TXmlNodeType)(0x0));
	__classmethod virtual System::UnicodeString __fastcall Escape(const System::UnicodeString Value);
	__classmethod virtual System::UnicodeString __fastcall Unescape(const System::UnicodeString Value);
	virtual TXmlVerySimple* __fastcall LoadFromFile(const System::UnicodeString FileName, int BufferSize = 0x1000);
	virtual TXmlVerySimple* __fastcall LoadFromStream(System::Classes::TStream* const Stream, int BufferSize = 0x1000);
	virtual void __fastcall ParseAttributes(const System::UnicodeString AttribStr, TXmlAttributeList* AttributeList);
	virtual TXmlVerySimple* __fastcall SaveToFile(const System::UnicodeString FileName);
	virtual TXmlVerySimple* __fastcall SaveToStream(System::Classes::TStream* const Stream);
	__property TXmlNodeList* ChildNodes = {read=GetChildNodes};
	__property TXmlNode* DocumentElement = {read=FDocumentElement, write=SetDocumentElement};
	__property System::UnicodeString Encoding = {read=GetEncoding, write=SetEncoding};
	__property TXmlNode* Header = {read=FHeader};
	__property bool PreserveWhitespace = {read=GetPreserveWhitespace, write=SetPreserveWhitespace, nodefault};
	__property System::UnicodeString StandAlone = {read=GetStandAlone, write=SetStandAlone};
	__property System::UnicodeString Text = {read=GetText, write=SetText};
	__property System::UnicodeString Version = {read=GetVersion, write=SetVersion};
	__property System::UnicodeString Xml = {read=GetText, write=SetText};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define TXmlSpaces L" \n\r\t"
}	/* namespace Verysimple */
}	/* namespace Xml */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_XML_VERYSIMPLE)
using namespace Xml::Verysimple;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_XML)
using namespace Xml;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Xml_VerySimpleHPP
