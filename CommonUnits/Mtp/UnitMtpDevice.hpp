// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitMtpDevice.pas' rev: 36.00 (Windows)

#ifndef UnitMtpDeviceHPP
#define UnitMtpDeviceHPP

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
#include <Vcl.ComCtrls.hpp>
#include <PortableDeviceApiLib_TLB.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitmtpdevice
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TBASE_Data;
class DELPHICLASS TMTP_Data;
class DELPHICLASS TMTP_Device;
//-- type declarations -------------------------------------------------------
typedef Portabledeviceapilib_tlb::_di_IPortableDevice IMTPDevice;

class PASCALIMPLEMENTATION TBASE_Data : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	bool IsFolder;
	__int64 SortValue;
	System::UnicodeString ObjectId;
	System::TDateTime Created;
	bool IsNotSavedTrip;
	int CalculatedModel;
	__fastcall TBASE_Data(const bool AIsFolder, const __int64 ASortValue, const System::UnicodeString AObjectId, const System::TDateTime ACreated);
	void __fastcall UpdateListItem(Vcl::Comctrls::TListItem* const AListItem, const System::UnicodeString *ASubItems, const System::NativeInt ASubItems_High);
	Vcl::Comctrls::TListItem* __fastcall CreateListItem(Vcl::Comctrls::TListItems* const Alist, const System::UnicodeString ACaption, const System::UnicodeString *ASubItems, const System::NativeInt ASubItems_High);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TBASE_Data() { }
	
};


class PASCALIMPLEMENTATION TMTP_Data : public TBASE_Data
{
	typedef TBASE_Data inherited;
	
public:
	/* TBASE_Data.Create */ inline __fastcall TMTP_Data(const bool AIsFolder, const __int64 ASortValue, const System::UnicodeString AObjectId, const System::TDateTime ACreated) : TBASE_Data(AIsFolder, ASortValue, AObjectId, ACreated) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TMTP_Data() { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TMTP_Device : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString Device;
	System::UnicodeString Description;
	System::UnicodeString FriendlyName;
	IMTPDevice PortableDev;
public:
	/* TObject.Create */ inline __fastcall TMTP_Device() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TMTP_Device() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Unitmtpdevice */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITMTPDEVICE)
using namespace Unitmtpdevice;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitMtpDeviceHPP
