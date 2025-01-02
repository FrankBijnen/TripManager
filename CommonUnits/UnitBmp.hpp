// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitBmp.pas' rev: 35.00 (Windows)

#ifndef UnitbmpHPP
#define UnitbmpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.Types.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Dialogs.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitbmp
{
//-- forward type declarations -----------------------------------------------
struct TBitmapFileHeader;
struct TBitmapInfoHeader;
class DELPHICLASS TBitMapReader;
//-- type declarations -------------------------------------------------------
typedef System::SmallString<2> TIDString;

struct DECLSPEC_DRECORD TBitmapFileHeader
{
public:
	System::Word bmfIdentifier;
	unsigned bmfFileSize;
	unsigned bmfReserved;
	unsigned bmfBitMapDataOffset;
};


struct DECLSPEC_DRECORD TBitmapInfoHeader
{
public:
	int biSize;
	int biWidth;
	int biHeight;
	System::Word biPlanes;
	System::Word biBitCount;
	int biCompression;
	int biSizeImage;
	int biXPelsPerMeter;
	int biYPelsPerMeter;
	int biClrUsed;
	int biClrImportant;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TBitMapReader : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<System::Byte> _TBitMapReader__1;
	
	typedef System::DynamicArray<System::Byte> _TBitMapReader__2;
	
	
public:
	TBitmapFileHeader BitmapFileHeader;
	TBitmapInfoHeader BitmapInfoHeader;
	System::Byte RedByte;
	System::Byte BlueByte;
	System::Byte GreenByte;
	System::Word AWord;
	int Amt;
	System::Byte AByte;
	int ALongint;
	System::WideChar AChar;
	HPALETTE BMhPalette;
	int PalCount;
	void *Pb;
	_TBitMapReader__1 ColPat;
	_TBitMapReader__2 ScanLines;
	__fastcall TBitMapReader(System::UTF8String ABitMap);
	__fastcall virtual ~TBitMapReader();
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Unitbmp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITBMP)
using namespace Unitbmp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitbmpHPP
