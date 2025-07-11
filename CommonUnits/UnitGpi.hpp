// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitGpi.pas' rev: 36.00 (Windows)

#ifndef UnitGpiHPP
#define UnitGpiHPP

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
#include <System.Types.hpp>
#include <System.SysUtils.hpp>
#include <System.AnsiStrings.hpp>
#include <System.DateUtils.hpp>
#include <System.Generics.Collections.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Graphics.hpp>
#include <UnitBmp.hpp>
#include <System.Generics.Defaults.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitgpi
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TGPXWayPoint;
class DELPHICLASS TGPXCategory;
class DELPHICLASS TGPXBitmap;
struct TPString;
struct TPLString;
struct TExtraRec;
struct TMainRec;
struct TCategoryRef;
struct TCategory;
struct TPoiBitmapRef;
struct TPoiBitmap;
struct THeader1;
struct THeader2;
struct TAlert;
struct TComment;
struct TAddress;
struct TContact;
struct TWayPt;
struct TArea;
struct TEndx;
struct TPOIGroup;
struct TGPI;
//-- type declarations -------------------------------------------------------
typedef System::UTF8String TGPXString;

class PASCALIMPLEMENTATION TGPXWayPoint : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TGPXString Name;
	TGPXString Lat;
	TGPXString Lon;
	TGPXString Symbol;
	TGPXString Phone;
	TGPXString Email;
	TGPXString Comment;
	TGPXString Country;
	TGPXString State;
	TGPXString PostalCode;
	TGPXString City;
	TGPXString Street;
	TGPXString HouseNbr;
	TGPXString Category;
	System::Word Speed;
	System::Word Proximity;
	int BitmapId;
	int CategoryId;
	__int64 SelStart;
	__int64 SelLength;
	__fastcall TGPXWayPoint();
	__fastcall virtual ~TGPXWayPoint();
};


typedef System::Generics::Collections::TObjectList__1<TGPXWayPoint*> TPOIList;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGPXCategory : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TGPXString Category;
	System::Word CategoryId;
	__fastcall TGPXCategory();
	__fastcall virtual ~TGPXCategory();
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TGPXBitmap : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	TGPXString Bitmap;
	System::Word BitmapId;
	TGPXString GpiSymbolsDir;
	__fastcall TGPXBitmap(TGPXString SymbolsDir);
	__fastcall virtual ~TGPXBitmap();
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TPString
{
	
private:
	typedef System::DynamicArray<char> _TPString__1;
	
	
public:
	System::Word LChars;
	_TPString__1 Chars;
	__fastcall TPString(TGPXString AChars);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Read(System::Classes::TBufferedFileStream* S);
	int __fastcall Size();
	TPString() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TPLString
{
	
private:
	typedef System::DynamicArray<char> _TPLString__1;
	
	
public:
	unsigned LCountry;
	System::StaticArray<char, 2> Country;
	System::Word LChars;
	_TPLString__1 Chars;
	__fastcall TPLString(TGPXString AChars);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Read(System::Classes::TBufferedFileStream* S);
	int __fastcall Size();
	TPLString() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TExtraRec
{
public:
	System::Word RecType;
	System::Word Flags;
	unsigned TotalLength;
	unsigned MainLength;
	__fastcall TExtraRec(System::Word AVersion, System::Word ARecType);
	void __fastcall Write(System::Classes::TBufferedFileStream* S, unsigned ATotalLength, unsigned AExtra);
	void __fastcall Read(System::Classes::TBufferedFileStream* S);
	bool __fastcall Assign(TExtraRec &Dest);
	TExtraRec() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TMainRec
{
public:
	System::Word RecType;
	System::Word Flags;
	unsigned Length;
	__fastcall TMainRec(System::Word AVersion, System::Word ARecType);
	void __fastcall Write(System::Classes::TBufferedFileStream* S, unsigned ALength);
	void __fastcall Read(System::Classes::TBufferedFileStream* S)/* overload */;
	void __fastcall Read(System::Classes::TBufferedFileStream* S, TExtraRec &ExtraRec)/* overload */;
	void __fastcall Assign(TMainRec &Dest);
	TMainRec() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TCategoryRef
{
public:
	TMainRec MainRec;
	short Id;
	__fastcall TCategoryRef(System::Word AVersion, short AId);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec);
	int __fastcall Size();
	TCategoryRef() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TCategory
{
public:
	TMainRec MainRec;
	short Id;
	TPLString Name;
	__fastcall TCategory(System::Word AVersion, TGPXCategory* GPXCategory);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec);
	int __fastcall Size();
	TCategory() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TPoiBitmapRef
{
public:
	TMainRec MainRec;
	short Id;
	__fastcall TPoiBitmapRef(System::Word AVersion, short AId);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec);
	int __fastcall Size();
	TPoiBitmapRef() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TPoiBitmap
{
	
private:
	typedef System::DynamicArray<System::Byte> _TPoiBitmap__1;
	
	typedef System::DynamicArray<System::Byte> _TPoiBitmap__2;
	
	
public:
	TMainRec MainRec;
	short Id;
	short Height;
	short Width;
	short LineSize;
	short BPP;
	short Dummy1;
	unsigned ImageSize;
	unsigned Dummy2;
	unsigned CntColPat;
	unsigned TranspCol;
	unsigned Flags2;
	unsigned Dummy3;
	_TPoiBitmap__1 ScanLines;
	_TPoiBitmap__2 ColPat;
	Unitbmp::TBitMapReader* BitMapRd;
	__fastcall TPoiBitmap(System::Word AVersion, TGPXBitmap* GPXBitMap);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec);
	Vcl::Graphics::TBitmap* __fastcall Bitmap();
	int __fastcall Size();
	TPoiBitmap() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD THeader1
{
public:
	TMainRec MainRec;
	System::StaticArray<char, 6> GrmRec;
	System::StaticArray<char, 2> Version;
	unsigned TimeStamp;
	System::Byte Flag1;
	System::Byte Flag2;
	TPString Name;
	__fastcall THeader1(System::Word AVersion);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Read(System::Classes::TBufferedFileStream* S);
	int __fastcall Size();
	THeader1() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD THeader2
{
public:
	TMainRec MainRec;
	System::StaticArray<char, 4> PoiRec;
	System::Word Dummy;
	System::StaticArray<char, 2> Version;
	System::Word CodePage;
	System::Word CopyRight;
	__fastcall THeader2(System::Word AVersion);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Read(System::Classes::TBufferedFileStream* S);
	int __fastcall Size();
	THeader2() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TAlert
{
public:
	TMainRec MainRec;
	System::Word Proximity;
	System::Word Speed;
	System::Word Dummy1;
	System::Word Dummy2;
	System::Byte Alert;
	System::Byte AlertType;
	System::Byte SoundNbr;
	System::Byte AudioAlert;
	__fastcall TAlert(System::Word AVersion, TGPXWayPoint* GPXWayPoint);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec);
	TAlert() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TComment
{
public:
	TMainRec MainRec;
	TPLString Comment;
	__fastcall TComment(System::Word AVersion, TGPXWayPoint* GPXWayPoint);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec);
	int __fastcall Size();
	TComment() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TAddress
{
public:
	TMainRec MainRec;
	System::Word Flags;
	TPLString City;
	TPLString Country;
	TPLString State;
	TPString PostalCode;
	TPLString Street;
	TPString HouseNbr;
	__fastcall TAddress(System::Word AVersion, TGPXWayPoint* GPXWayPoint);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec);
	int __fastcall Size();
	TAddress() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TContact
{
public:
	TMainRec MainRec;
	System::Word Flags;
	TPString Phone;
	TPString Email;
	__fastcall TContact(System::Word AVersion, TGPXWayPoint* GPXWayPoint);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec);
	int __fastcall Size();
	TContact() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TWayPt
{
public:
	bool Extra;
	TExtraRec ExtraRec;
	TMainRec MainRec;
	System::LongInt Lat;
	System::LongInt Lon;
	System::Word Dummy1;
	System::Byte HasAlert;
	TPLString Name;
	TCategoryRef CategoryRef;
	TPoiBitmapRef BitmapRef;
	TAlert Alert;
	TComment Comment;
	TContact Contact;
	TAddress Address;
	__fastcall TWayPt(System::Word AVersion, TGPXWayPoint* GPXWayPoint, bool AExtra);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec, const TExtraRec &ExtraRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec, const TExtraRec &ExtraRec);
	int __fastcall Size();
	int __fastcall ExtraSize();
	TWayPt() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TArea
{
public:
	bool Extra;
	int ExtraSize;
	TExtraRec ExtraRec;
	System::LongInt MaxLat;
	System::LongInt MaxLon;
	System::LongInt MinLat;
	System::LongInt MinLon;
	unsigned Dummy1;
	System::Word Dummy2;
	System::Byte Alert;
	System::Generics::Collections::TObjectList__1<TGPXWayPoint*>* WayPts;
	__fastcall TArea(System::Word AVersion, bool AExtra);
	void __fastcall AddWpt(TGPXWayPoint* GPXWayPt);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TExtraRec &ExtraRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TExtraRec &ExtraRec);
	int __fastcall Size();
	TArea() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TEndx
{
public:
	TMainRec MainRec;
	__fastcall TEndx(System::Word AVersion);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	int __fastcall Size();
	TEndx() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TPOIGroup
{
public:
	bool Extra;
	int ExtraSize;
	TMainRec MainRec;
	TExtraRec ExtraRec;
	TPLString Name;
	TArea Area;
	System::Generics::Collections::TObjectList__1<TGPXCategory*>* Categories;
	System::Generics::Collections::TObjectList__1<TGPXBitmap*>* BitMaps;
	__fastcall TPOIGroup(System::Word AVersion, TGPXString AName, bool AExtra);
	void __fastcall AddWpt(TGPXWayPoint* GPXWayPt);
	int __fastcall AddCat(TGPXCategory* GPXCategory);
	int __fastcall AddBmp(TGPXBitmap* GPXBitMap);
	void __fastcall Write(System::Classes::TBufferedFileStream* S);
	void __fastcall Assign(const TMainRec &MainRec, const TExtraRec &ExtraRec);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, const TMainRec &MainRec, const TExtraRec &ExtraRec);
	int __fastcall Size();
	TPOIGroup() {}
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TGPI
{
public:
	System::Word Version;
	bool Extra;
	THeader1 Header1;
	THeader2 Header2;
	TPOIGroup POIGroup;
	TEndx Endx;
	__fastcall TGPI(System::Word AVersion, bool AExtra);
	void __fastcall WriteHeader(System::Classes::TBufferedFileStream* S);
	TPOIGroup __fastcall CreatePOIGroup(TGPXString Category);
	void __fastcall WriteEnd(System::Classes::TBufferedFileStream* S);
	void __fastcall Read(System::Classes::TBufferedFileStream* S, TPOIList* APOIList, System::UnicodeString ImageDir = System::UnicodeString());
	TGPI() {}
};
#pragma pack(pop)


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TGPXString GpiName;
extern DELPHI_PACKAGE System::Word GpiVersion;
extern DELPHI_PACKAGE unsigned DefTransparentColor;
#define DefGpiSymbolsDir L"Symbols\\24x24\\"
#define Reg_GPISymbolSize L"GPISymbolsSize"
#define Reg_GPIProximity L"GPIProximity"
extern DELPHI_PACKAGE System::Word HasPhone;
extern DELPHI_PACKAGE System::Word HasEmail;
extern DELPHI_PACKAGE System::Word HasCity;
extern DELPHI_PACKAGE System::Word HasCountry;
extern DELPHI_PACKAGE System::Word HasState;
extern DELPHI_PACKAGE System::Word HasPostal;
extern DELPHI_PACKAGE System::Word HasStreet;
extern DELPHI_PACKAGE System::Word HasHouseNbr;
}	/* namespace Unitgpi */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITGPI)
using namespace Unitgpi;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitGpiHPP
