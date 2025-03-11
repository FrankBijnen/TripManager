// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'PortableDeviceApiLib_TLB.pas' rev: 36.00 (Windows)

#ifndef PortableDeviceApiLib_TLBHPP
#define PortableDeviceApiLib_TLBHPP

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
#include <System.Classes.hpp>
#include <System.Variants.hpp>
#include <System.Win.StdVCL.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.OleServer.hpp>
#include <Winapi.ActiveX.hpp>

//-- user supplied -----------------------------------------------------------

namespace Portabledeviceapilib_tlb
{
//-- forward type declarations -----------------------------------------------
__interface DELPHIINTERFACE IPortableDevice;
typedef System::DelphiInterface<IPortableDevice> _di_IPortableDevice;
__interface DELPHIINTERFACE IPortableDeviceManager;
typedef System::DelphiInterface<IPortableDeviceManager> _di_IPortableDeviceManager;
__interface DELPHIINTERFACE IPortableDeviceService;
typedef System::DelphiInterface<IPortableDeviceService> _di_IPortableDeviceService;
__interface DELPHIINTERFACE IPortableDeviceDispatchFactory;
typedef System::DelphiInterface<IPortableDeviceDispatchFactory> _di_IPortableDeviceDispatchFactory;
__interface DELPHIINTERFACE IPortableDeviceWebControl;
typedef System::DelphiInterface<IPortableDeviceWebControl> _di_IPortableDeviceWebControl;
struct _tagpropertykey;
struct _LARGE_INTEGER;
struct _ULARGE_INTEGER;
struct _FILETIME;
struct tagCLIPDATA;
struct tagBSTRBLOB;
struct tagBLOB;
struct tagVersionedStream;
struct tagSTATSTG;
struct tagRemSNB;
struct tagCAC;
struct tagCAUB;
struct _wireSAFEARR_BSTR;
struct _wireSAFEARR_UNKNOWN;
struct _wireSAFEARR_DISPATCH;
struct _FLAGGED_WORD_BLOB;
struct _wireSAFEARR_VARIANT;
struct _wireBRECORD;
struct __MIDL_IOleAutomationTypes_0005;
struct tagTYPEDESC;
struct tagSAFEARRAYBOUND;
struct tagIDLDESC;
struct tagPARAMDESCEX;
struct tagPARAMDESC;
struct tagELEMDESC;
struct tagFUNCDESC;
struct __MIDL_IOleAutomationTypes_0006;
struct tagVARDESC;
struct tagTLIBATTR;
struct _wireSAFEARR_BRECORD;
struct _wireSAFEARR_HAVEIID;
struct _BYTE_SIZEDARR;
struct _SHORT_SIZEDARR;
struct _LONG_SIZEDARR;
struct _HYPER_SIZEDARR;
struct tagCAI;
struct tagCAUI;
struct tagCAL;
struct tagCAUL;
struct tagCAH;
struct tagCAUH;
struct tagCAFLT;
struct tagCADBL;
struct tagCABOOL;
struct tagCASCODE;
struct tagCACY;
struct tagCADATE;
struct tagCAFILETIME;
struct tagCACLSID;
struct tagCACLIPDATA;
struct tagCABSTR;
struct tagCABSTRBLOB;
struct tagCALPSTR;
struct tagCALPWSTR;
struct tagCAPROPVARIANT;
struct __MIDL___MIDL_itf_PortableDeviceApi_0001_0000_0001;
struct tag_inner_PROPVARIANT;
struct __MIDL_IOleAutomationTypes_0004;
struct __MIDL_IOleAutomationTypes_0001;
struct _wireSAFEARRAY_UNION;
struct _wireVARIANT;
struct tagTYPEATTR;
struct tagARRAYDESC;
struct _wireSAFEARRAY;
__interface DELPHIINTERFACE IPortableDeviceValues;
typedef System::DelphiInterface<IPortableDeviceValues> _di_IPortableDeviceValues;
__interface DELPHIINTERFACE IStorage;
typedef System::DelphiInterface<IStorage> _di_IStorage;
__interface DELPHIINTERFACE IEnumSTATSTG;
typedef System::DelphiInterface<IEnumSTATSTG> _di_IEnumSTATSTG;
__interface DELPHIINTERFACE IRecordInfo;
typedef System::DelphiInterface<IRecordInfo> _di_IRecordInfo;
__interface DELPHIINTERFACE ITypeInfo;
typedef System::DelphiInterface<ITypeInfo> _di_ITypeInfo;
__interface DELPHIINTERFACE ITypeComp;
typedef System::DelphiInterface<ITypeComp> _di_ITypeComp;
__interface DELPHIINTERFACE ITypeLib;
typedef System::DelphiInterface<ITypeLib> _di_ITypeLib;
__interface DELPHIINTERFACE IPortableDevicePropVariantCollection;
typedef System::DelphiInterface<IPortableDevicePropVariantCollection> _di_IPortableDevicePropVariantCollection;
__interface DELPHIINTERFACE IPortableDeviceKeyCollection;
typedef System::DelphiInterface<IPortableDeviceKeyCollection> _di_IPortableDeviceKeyCollection;
__interface DELPHIINTERFACE IPortableDeviceValuesCollection;
typedef System::DelphiInterface<IPortableDeviceValuesCollection> _di_IPortableDeviceValuesCollection;
__interface DELPHIINTERFACE IPropertyStore;
typedef System::DelphiInterface<IPropertyStore> _di_IPropertyStore;
__interface DELPHIINTERFACE IPortableDeviceContent;
typedef System::DelphiInterface<IPortableDeviceContent> _di_IPortableDeviceContent;
__interface DELPHIINTERFACE IEnumPortableDeviceObjectIDs;
typedef System::DelphiInterface<IEnumPortableDeviceObjectIDs> _di_IEnumPortableDeviceObjectIDs;
__interface DELPHIINTERFACE IPortableDeviceProperties;
typedef System::DelphiInterface<IPortableDeviceProperties> _di_IPortableDeviceProperties;
__interface DELPHIINTERFACE IPortableDeviceResources;
typedef System::DelphiInterface<IPortableDeviceResources> _di_IPortableDeviceResources;
__interface DELPHIINTERFACE IPortableDeviceCapabilities;
typedef System::DelphiInterface<IPortableDeviceCapabilities> _di_IPortableDeviceCapabilities;
__interface DELPHIINTERFACE IPortableDeviceEventCallback;
typedef System::DelphiInterface<IPortableDeviceEventCallback> _di_IPortableDeviceEventCallback;
__interface DELPHIINTERFACE IPortableDeviceServiceCapabilities;
typedef System::DelphiInterface<IPortableDeviceServiceCapabilities> _di_IPortableDeviceServiceCapabilities;
__interface DELPHIINTERFACE IPortableDeviceContent2;
typedef System::DelphiInterface<IPortableDeviceContent2> _di_IPortableDeviceContent2;
__interface DELPHIINTERFACE IPortableDeviceServiceMethods;
typedef System::DelphiInterface<IPortableDeviceServiceMethods> _di_IPortableDeviceServiceMethods;
__interface DELPHIINTERFACE IPortableDeviceServiceMethodCallback;
typedef System::DelphiInterface<IPortableDeviceServiceMethodCallback> _di_IPortableDeviceServiceMethodCallback;
__dispinterface IPortableDeviceWebControlDisp;
typedef System::DelphiInterface<IPortableDeviceWebControlDisp> _di_IPortableDeviceWebControlDisp;
__interface DELPHIINTERFACE IPortableDeviceDataStream;
typedef System::DelphiInterface<IPortableDeviceDataStream> _di_IPortableDeviceDataStream;
class DELPHICLASS CoPortableDevice;
class DELPHICLASS CoPortableDeviceManager;
class DELPHICLASS CoPortableDeviceService;
class DELPHICLASS CoPortableDeviceDispatchFactory;
class DELPHICLASS CoPortableDeviceFTM;
class DELPHICLASS CoPortableDeviceServiceFTM;
class DELPHICLASS CoPortableDeviceWebControl;
//-- type declarations -------------------------------------------------------
typedef Winapi::Activex::TOleEnum tagTYPEKIND;

typedef Winapi::Activex::TOleEnum tagDESCKIND;

typedef Winapi::Activex::TOleEnum tagFUNCKIND;

typedef Winapi::Activex::TOleEnum tagINVOKEKIND;

typedef Winapi::Activex::TOleEnum tagCALLCONV;

typedef Winapi::Activex::TOleEnum tagVARKIND;

typedef Winapi::Activex::TOleEnum tagSYSKIND;

typedef _di_IPortableDevice PortableDevice;

typedef _di_IPortableDeviceManager PortableDeviceManager;

typedef _di_IPortableDeviceService PortableDeviceService;

typedef _di_IPortableDeviceDispatchFactory PortableDeviceDispatchFactory;

typedef _di_IPortableDevice PortableDeviceFTM;

typedef _di_IPortableDeviceService PortableDeviceServiceFTM;

typedef _di_IPortableDeviceWebControl PortableDeviceWebControl;

typedef _wireSAFEARRAY *PUserType5;

typedef PUserType5 *wirePSAFEARRAY;

typedef tagRemSNB *wireSNB;

typedef _FLAGGED_WORD_BLOB *PUserType6;

typedef _wireVARIANT *PUserType7;

typedef _wireBRECORD *PUserType14;

typedef PUserType5 *PPUserType1;

typedef tagTYPEDESC *PUserType11;

typedef tagARRAYDESC *PUserType12;

typedef tag_inner_PROPVARIANT *PUserType2;

typedef unsigned *PUINT1;

typedef _tagpropertykey *PUserType1;

typedef GUID *PUserType3;

typedef System::Byte *PByte1;

typedef _FILETIME *PUserType4;

typedef System::OleVariant *POleVariant1;

typedef tagTYPEATTR *PUserType8;

typedef tagFUNCDESC *PUserType9;

typedef tagVARDESC *PUserType10;

typedef tagTLIBATTR *PUserType13;

#pragma pack(push,4)
struct DECLSPEC_DRECORD _tagpropertykey
{
public:
	GUID fmtid;
	System::LongWord pid;
};
#pragma pack(pop)


struct DECLSPEC_DRECORD _LARGE_INTEGER
{
public:
	__int64 QuadPart;
};


struct DECLSPEC_DRECORD _ULARGE_INTEGER
{
public:
	unsigned __int64 QuadPart;
};


#pragma pack(push,4)
struct DECLSPEC_DRECORD _FILETIME
{
public:
	System::LongWord dwLowDateTime;
	System::LongWord dwHighDateTime;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCLIPDATA
{
public:
	System::LongWord cbSize;
	int ulClipFmt;
	System::Byte *pClipData;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagBSTRBLOB
{
public:
	System::LongWord cbSize;
	System::Byte *pData;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagBLOB
{
public:
	System::LongWord cbSize;
	System::Byte *pBlobData;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagVersionedStream
{
public:
	GUID guidVersion;
	_di_IStream pStream;
};
#pragma pack(pop)


struct DECLSPEC_DRECORD tagSTATSTG
{
public:
	System::WideChar *pwcsName;
	System::LongWord type_;
	_ULARGE_INTEGER cbSize;
	_FILETIME mtime;
	_FILETIME ctime;
	_FILETIME atime;
	System::LongWord grfMode;
	System::LongWord grfLocksSupported;
	GUID clsid;
	System::LongWord grfStateBits;
	System::LongWord reserved;
};


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagRemSNB
{
public:
	System::LongWord ulCntStr;
	System::LongWord ulCntChar;
	System::Word *rgString;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAC
{
public:
	System::LongWord cElems;
	System::Int8 *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAUB
{
public:
	System::LongWord cElems;
	System::Byte *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _wireSAFEARR_BSTR
{
public:
	System::LongWord Size;
	PUserType6 *aBstr;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _wireSAFEARR_UNKNOWN
{
public:
	System::LongWord Size;
	System::_di_IInterface *apUnknown;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _wireSAFEARR_DISPATCH
{
public:
	System::LongWord Size;
	_di_IDispatch *apDispatch;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _FLAGGED_WORD_BLOB
{
public:
	System::LongWord fFlags;
	System::LongWord clSize;
	System::Word *asData;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _wireSAFEARR_VARIANT
{
public:
	System::LongWord Size;
	PUserType7 *aVariant;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _wireBRECORD
{
public:
	System::LongWord fFlags;
	System::LongWord clSize;
	_di_IRecordInfo pRecInfo;
	System::Byte *pRecord;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD __MIDL_IOleAutomationTypes_0005
{
	
public:
	union
	{
		struct 
		{
			System::LongWord hreftype;
		};
		struct 
		{
			PUserType12 lpadesc;
		};
		struct 
		{
			PUserType11 lptdesc;
		};
		
	};
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagTYPEDESC
{
public:
	__MIDL_IOleAutomationTypes_0005 DUMMYUNIONNAME;
	System::Word vt;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagSAFEARRAYBOUND
{
public:
	System::LongWord cElements;
	int lLbound;
};
#pragma pack(pop)


typedef System::LongWord ULONG_PTR;

#pragma pack(push,4)
struct DECLSPEC_DRECORD tagIDLDESC
{
public:
	ULONG_PTR dwReserved;
	System::Word wIDLFlags;
};
#pragma pack(pop)


typedef System::LongWord DWORD;

struct DECLSPEC_DRECORD tagPARAMDESCEX
{
public:
	System::LongWord cBytes;
	System::OleVariant varDefaultValue;
};


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagPARAMDESC
{
public:
	tagPARAMDESCEX *pparamdescex;
	System::Word wParamFlags;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagELEMDESC
{
public:
	tagTYPEDESC tdesc;
	tagPARAMDESC paramdesc;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagFUNCDESC
{
public:
	int memid;
	int *lprgscode;
	tagELEMDESC *lprgelemdescParam;
	tagFUNCKIND funckind;
	tagINVOKEKIND invkind;
	tagCALLCONV callconv;
	short cParams;
	short cParamsOpt;
	short oVft;
	short cScodes;
	tagELEMDESC elemdescFunc;
	System::Word wFuncFlags;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD __MIDL_IOleAutomationTypes_0006
{
	
public:
	union
	{
		struct 
		{
			System::OleVariant *lpvarValue;
		};
		struct 
		{
			System::LongWord oInst;
		};
		
	};
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagVARDESC
{
public:
	int memid;
	System::WideChar *lpstrSchema;
	__MIDL_IOleAutomationTypes_0006 DUMMYUNIONNAME;
	tagELEMDESC elemdescVar;
	System::Word wVarFlags;
	tagVARKIND varkind;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagTLIBATTR
{
public:
	GUID guid;
	System::LongWord lcid;
	tagSYSKIND syskind;
	System::Word wMajorVerNum;
	System::Word wMinorVerNum;
	System::Word wLibFlags;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _wireSAFEARR_BRECORD
{
public:
	System::LongWord Size;
	PUserType14 *aRecord;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _wireSAFEARR_HAVEIID
{
public:
	System::LongWord Size;
	System::_di_IInterface *apUnknown;
	GUID iid;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _BYTE_SIZEDARR
{
public:
	System::LongWord clSize;
	System::Byte *pData;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _SHORT_SIZEDARR
{
public:
	System::LongWord clSize;
	System::Word *pData;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _LONG_SIZEDARR
{
public:
	System::LongWord clSize;
	unsigned *pData;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _HYPER_SIZEDARR
{
public:
	System::LongWord clSize;
	__int64 *pData;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAI
{
public:
	System::LongWord cElems;
	short *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAUI
{
public:
	System::LongWord cElems;
	System::Word *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAL
{
public:
	System::LongWord cElems;
	int *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAUL
{
public:
	System::LongWord cElems;
	unsigned *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAH
{
public:
	System::LongWord cElems;
	_LARGE_INTEGER *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAUH
{
public:
	System::LongWord cElems;
	_ULARGE_INTEGER *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAFLT
{
public:
	System::LongWord cElems;
	float *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCADBL
{
public:
	System::LongWord cElems;
	double *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCABOOL
{
public:
	System::LongWord cElems;
	System::WordBool *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCASCODE
{
public:
	System::LongWord cElems;
	int *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCACY
{
public:
	System::LongWord cElems;
	System::Currency *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCADATE
{
public:
	System::LongWord cElems;
	System::TDateTime *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAFILETIME
{
public:
	System::LongWord cElems;
	_FILETIME *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCACLSID
{
public:
	System::LongWord cElems;
	GUID *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCACLIPDATA
{
public:
	System::LongWord cElems;
	tagCLIPDATA *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCABSTR
{
public:
	System::LongWord cElems;
	System::WideString *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCABSTRBLOB
{
public:
	System::LongWord cElems;
	tagBSTRBLOB *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCALPSTR
{
public:
	System::LongWord cElems;
	char * *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCALPWSTR
{
public:
	System::LongWord cElems;
	System::WideChar * *pElems;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagCAPROPVARIANT
{
public:
	System::LongWord cElems;
	PUserType2 pElems;
};
#pragma pack(pop)


struct DECLSPEC_DRECORD __MIDL___MIDL_itf_PortableDeviceApi_0001_0000_0001
{
	
public:
	union
	{
		struct 
		{
			PUserType2 pvarVal;
		};
		struct 
		{
			wirePSAFEARRAY *pparray;
		};
		struct 
		{
			void *ppdispVal;
		};
		struct 
		{
			void *ppunkVal;
		};
		struct 
		{
			System::WideString *pbstrVal;
		};
		struct 
		{
			System::TDateTimeBase *pdate;
		};
		struct 
		{
			System::CurrencyBase *pcyVal;
		};
		struct 
		{
			int *pscode;
		};
		struct 
		{
			tagDEC *pdecVal;
		};
		struct 
		{
			System::WordBool *pboolVal;
		};
		struct 
		{
			double *pdblVal;
		};
		struct 
		{
			float *pfltVal;
		};
		struct 
		{
			unsigned *puintVal;
		};
		struct 
		{
			int *pintVal;
		};
		struct 
		{
			unsigned *pulVal;
		};
		struct 
		{
			int *plVal;
		};
		struct 
		{
			System::Word *puiVal;
		};
		struct 
		{
			short *piVal;
		};
		struct 
		{
			System::Byte *pbVal;
		};
		struct 
		{
			System::Int8 *pcVal;
		};
		struct 
		{
			tagCAPROPVARIANT capropvar;
		};
		struct 
		{
			tagCALPWSTR calpwstr;
		};
		struct 
		{
			tagCALPSTR calpstr;
		};
		struct 
		{
			tagCABSTRBLOB cabstrblob;
		};
		struct 
		{
			tagCABSTR cabstr;
		};
		struct 
		{
			tagCACLIPDATA caclipdata;
		};
		struct 
		{
			tagCACLSID cauuid;
		};
		struct 
		{
			tagCAFILETIME cafiletime;
		};
		struct 
		{
			tagCADATE cadate;
		};
		struct 
		{
			tagCACY cacy;
		};
		struct 
		{
			tagCASCODE cascode;
		};
		struct 
		{
			tagCABOOL cabool;
		};
		struct 
		{
			tagCADBL cadbl;
		};
		struct 
		{
			tagCAFLT caflt;
		};
		struct 
		{
			tagCAUH cauh;
		};
		struct 
		{
			tagCAH cah;
		};
		struct 
		{
			tagCAUL caul;
		};
		struct 
		{
			tagCAL cal;
		};
		struct 
		{
			tagCAUI caui;
		};
		struct 
		{
			tagCAI cai;
		};
		struct 
		{
			tagCAUB caub;
		};
		struct 
		{
			tagCAC cac;
		};
		struct 
		{
			wirePSAFEARRAY parray;
		};
		struct 
		{
			tagVersionedStream *pVersionedStream;
		};
		struct 
		{
			void *pStorage;
		};
		struct 
		{
			void *pStream;
		};
		struct 
		{
			void *pdispVal;
		};
		struct 
		{
			void *punkVal;
		};
		struct 
		{
			System::WideChar *pwszVal;
		};
		struct 
		{
			char *pszVal;
		};
		struct 
		{
			tagBLOB blob;
		};
		struct 
		{
			tagBSTRBLOB bstrblobVal;
		};
		struct 
		{
			void *bstrVal;
		};
		struct 
		{
			tagCLIPDATA *pClipData;
		};
		struct 
		{
			GUID *puuid;
		};
		struct 
		{
			_FILETIME filetime;
		};
		struct 
		{
			System::TDateTimeBase date;
		};
		struct 
		{
			System::CurrencyBase cyVal;
		};
		struct 
		{
			int scode;
		};
		struct 
		{
			System::WordBool Bool;
		};
		struct 
		{
			System::WordBool boolVal;
		};
		struct 
		{
			double dblVal;
		};
		struct 
		{
			float fltVal;
		};
		struct 
		{
			_ULARGE_INTEGER uhVal;
		};
		struct 
		{
			_LARGE_INTEGER hVal;
		};
		struct 
		{
			unsigned uintVal;
		};
		struct 
		{
			int intVal;
		};
		struct 
		{
			System::LongWord ulVal;
		};
		struct 
		{
			int lVal;
		};
		struct 
		{
			System::Word uiVal;
		};
		struct 
		{
			short iVal;
		};
		struct 
		{
			System::Byte bVal;
		};
		struct 
		{
			System::Int8 cVal;
		};
		
	};
};


struct DECLSPEC_DRECORD tag_inner_PROPVARIANT
{
public:
	System::Word vt;
	System::Byte wReserved1;
	System::Byte wReserved2;
	System::LongWord wReserved3;
	__MIDL___MIDL_itf_PortableDeviceApi_0001_0000_0001 __MIDL____MIDL_itf_PortableDeviceApi_0001_00000001;
};


struct DECLSPEC_DRECORD __MIDL_IOleAutomationTypes_0004
{
	
public:
	union
	{
		struct 
		{
			unsigned *puintVal;
		};
		struct 
		{
			int *pintVal;
		};
		struct 
		{
			unsigned __int64 *pullVal;
		};
		struct 
		{
			unsigned *pulVal;
		};
		struct 
		{
			System::Word *puiVal;
		};
		struct 
		{
			System::Int8 *pcVal;
		};
		struct 
		{
			tagDEC *pdecVal;
		};
		struct 
		{
			Winapi::Activex::TDecimal decVal;
		};
		struct 
		{
			unsigned uintVal;
		};
		struct 
		{
			int intVal;
		};
		struct 
		{
			unsigned __int64 ullVal;
		};
		struct 
		{
			System::LongWord ulVal;
		};
		struct 
		{
			System::Word uiVal;
		};
		struct 
		{
			System::Int8 cVal;
		};
		struct 
		{
			PUserType7 *pvarVal;
		};
		struct 
		{
			PPUserType1 *pparray;
		};
		struct 
		{
			void *ppdispVal;
		};
		struct 
		{
			void *ppunkVal;
		};
		struct 
		{
			PUserType6 *pbstrVal;
		};
		struct 
		{
			System::TDateTimeBase *pdate;
		};
		struct 
		{
			System::CurrencyBase *pcyVal;
		};
		struct 
		{
			int *pscode;
		};
		struct 
		{
			System::WordBool *pboolVal;
		};
		struct 
		{
			double *pdblVal;
		};
		struct 
		{
			float *pfltVal;
		};
		struct 
		{
			__int64 *pllVal;
		};
		struct 
		{
			int *plVal;
		};
		struct 
		{
			short *piVal;
		};
		struct 
		{
			System::Byte *pbVal;
		};
		struct 
		{
			_wireBRECORD *brecVal;
		};
		struct 
		{
			PUserType5 *parray;
		};
		struct 
		{
			void *pdispVal;
		};
		struct 
		{
			void *punkVal;
		};
		struct 
		{
			_FLAGGED_WORD_BLOB *bstrVal;
		};
		struct 
		{
			System::TDateTimeBase date;
		};
		struct 
		{
			System::CurrencyBase cyVal;
		};
		struct 
		{
			int scode;
		};
		struct 
		{
			System::WordBool boolVal;
		};
		struct 
		{
			double dblVal;
		};
		struct 
		{
			float fltVal;
		};
		struct 
		{
			short iVal;
		};
		struct 
		{
			System::Byte bVal;
		};
		struct 
		{
			int lVal;
		};
		struct 
		{
			__int64 llVal;
		};
		
	};
};


#pragma pack(push,4)
struct DECLSPEC_DRECORD __MIDL_IOleAutomationTypes_0001
{
	
public:
	union
	{
		struct 
		{
			_HYPER_SIZEDARR HyperStr;
		};
		struct 
		{
			_LONG_SIZEDARR LongStr;
		};
		struct 
		{
			_SHORT_SIZEDARR WordStr;
		};
		struct 
		{
			_BYTE_SIZEDARR ByteStr;
		};
		struct 
		{
			_wireSAFEARR_HAVEIID HaveIidStr;
		};
		struct 
		{
			_wireSAFEARR_BRECORD RecordStr;
		};
		struct 
		{
			_wireSAFEARR_VARIANT VariantStr;
		};
		struct 
		{
			_wireSAFEARR_DISPATCH DispatchStr;
		};
		struct 
		{
			_wireSAFEARR_UNKNOWN UnknownStr;
		};
		struct 
		{
			_wireSAFEARR_BSTR BstrStr;
		};
		
	};
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _wireSAFEARRAY_UNION
{
public:
	System::LongWord sfType;
	__MIDL_IOleAutomationTypes_0001 u;
};
#pragma pack(pop)


struct DECLSPEC_DRECORD _wireVARIANT
{
public:
	System::LongWord clSize;
	System::LongWord rpcReserved;
	System::Word vt;
	System::Word wReserved1;
	System::Word wReserved2;
	System::Word wReserved3;
	__MIDL_IOleAutomationTypes_0004 DUMMYUNIONNAME;
};


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagTYPEATTR
{
public:
	GUID guid;
	System::LongWord lcid;
	System::LongWord dwReserved;
	int memidConstructor;
	int memidDestructor;
	System::WideChar *lpstrSchema;
	System::LongWord cbSizeInstance;
	tagTYPEKIND typekind;
	System::Word cFuncs;
	System::Word cVars;
	System::Word cImplTypes;
	System::Word cbSizeVft;
	System::Word cbAlignment;
	System::Word wTypeFlags;
	System::Word wMajorVerNum;
	System::Word wMinorVerNum;
	tagTYPEDESC tdescAlias;
	tagIDLDESC idldescType;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD tagARRAYDESC
{
public:
	tagTYPEDESC tdescElem;
	System::Word cDims;
	tagSAFEARRAYBOUND *rgbounds;
};
#pragma pack(pop)


#pragma pack(push,4)
struct DECLSPEC_DRECORD _wireSAFEARRAY
{
public:
	System::Word cDims;
	System::Word fFeatures;
	System::LongWord cbElements;
	System::LongWord cLocks;
	_wireSAFEARRAY_UNION uArrayStructs;
	tagSAFEARRAYBOUND *rgsabound;
};
#pragma pack(pop)


__interface  INTERFACE_UUID("{625E2DF8-6392-4CF0-9AD1-3CFA5F17775C}") IPortableDevice  : public System::IInterface 
{
	virtual HRESULT __stdcall Open(System::WideChar * pszPnPDeviceID, const _di_IPortableDeviceValues pClientInfo) = 0 ;
	virtual HRESULT __stdcall SendCommand(System::LongWord dwFlags, const _di_IPortableDeviceValues pParameters, /* out */ _di_IPortableDeviceValues &ppResults) = 0 ;
	virtual HRESULT __stdcall Content(/* out */ _di_IPortableDeviceContent &ppContent) = 0 ;
	virtual HRESULT __stdcall Capabilities(/* out */ _di_IPortableDeviceCapabilities &ppCapabilities) = 0 ;
	virtual HRESULT __stdcall Cancel() = 0 ;
	virtual HRESULT __stdcall Close() = 0 ;
	virtual HRESULT __stdcall Advise(System::LongWord dwFlags, const _di_IPortableDeviceEventCallback pCallback, const _di_IPortableDeviceValues pParameters, /* out */ System::WideChar * &ppszCookie) = 0 ;
	virtual HRESULT __stdcall Unadvise(System::WideChar * pszCookie) = 0 ;
	virtual HRESULT __stdcall GetPnPDeviceID(/* out */ System::WideChar * &ppszPnPDeviceID) = 0 ;
};

__interface  INTERFACE_UUID("{6848F6F2-3155-4F86-B6F5-263EEEAB3143}") IPortableDeviceValues  : public System::IInterface 
{
	virtual HRESULT __stdcall GetCount(System::LongWord &pcelt) = 0 ;
	virtual HRESULT __stdcall GetAt(System::LongWord index, _tagpropertykey &pKey, tag_inner_PROPVARIANT &pValue) = 0 ;
	virtual HRESULT __stdcall SetValue(_tagpropertykey &key, tag_inner_PROPVARIANT &pValue) = 0 ;
	virtual HRESULT __stdcall GetValue(_tagpropertykey &key, /* out */ tag_inner_PROPVARIANT &pValue) = 0 ;
	virtual HRESULT __stdcall SetStringValue(_tagpropertykey &key, System::WideChar * Value) = 0 ;
	virtual HRESULT __stdcall GetStringValue(_tagpropertykey &key, /* out */ System::WideChar * &pValue) = 0 ;
	virtual HRESULT __stdcall SetUnsignedIntegerValue(_tagpropertykey &key, System::LongWord Value) = 0 ;
	virtual HRESULT __stdcall GetUnsignedIntegerValue(_tagpropertykey &key, /* out */ System::LongWord &pValue) = 0 ;
	virtual HRESULT __stdcall SetSignedIntegerValue(_tagpropertykey &key, int Value) = 0 ;
	virtual HRESULT __stdcall GetSignedIntegerValue(_tagpropertykey &key, /* out */ int &pValue) = 0 ;
	virtual HRESULT __stdcall SetUnsignedLargeIntegerValue(_tagpropertykey &key, unsigned __int64 Value) = 0 ;
	virtual HRESULT __stdcall GetUnsignedLargeIntegerValue(_tagpropertykey &key, /* out */ unsigned __int64 &pValue) = 0 ;
	virtual HRESULT __stdcall SetSignedLargeIntegerValue(_tagpropertykey &key, __int64 Value) = 0 ;
	virtual HRESULT __stdcall GetSignedLargeIntegerValue(_tagpropertykey &key, /* out */ __int64 &pValue) = 0 ;
	virtual HRESULT __stdcall SetFloatValue(_tagpropertykey &key, float Value) = 0 ;
	virtual HRESULT __stdcall GetFloatValue(_tagpropertykey &key, /* out */ float &pValue) = 0 ;
	virtual HRESULT __stdcall SetErrorValue(_tagpropertykey &key, HRESULT Value) = 0 ;
	virtual HRESULT __stdcall GetErrorValue(_tagpropertykey &key, /* out */ HRESULT &pValue) = 0 ;
	virtual HRESULT __stdcall SetKeyValue(_tagpropertykey &key, _tagpropertykey &Value) = 0 ;
	virtual HRESULT __stdcall GetKeyValue(_tagpropertykey &key, /* out */ _tagpropertykey &pValue) = 0 ;
	virtual HRESULT __stdcall SetBoolValue(_tagpropertykey &key, int Value) = 0 ;
	virtual HRESULT __stdcall GetBoolValue(_tagpropertykey &key, /* out */ int &pValue) = 0 ;
	virtual HRESULT __stdcall SetIUnknownValue(_tagpropertykey &key, const System::_di_IInterface pValue) = 0 ;
	virtual HRESULT __stdcall GetIUnknownValue(_tagpropertykey &key, /* out */ System::_di_IInterface &ppValue) = 0 ;
	virtual HRESULT __stdcall SetGuidValue(_tagpropertykey &key, GUID &Value) = 0 ;
	virtual HRESULT __stdcall GetGuidValue(_tagpropertykey &key, /* out */ GUID &pValue) = 0 ;
	virtual HRESULT __stdcall SetBufferValue(_tagpropertykey &key, System::Byte &pValue, System::LongWord cbValue) = 0 ;
	virtual HRESULT __stdcall GetBufferValue(_tagpropertykey &key, /* out */ PByte1 &ppValue, /* out */ System::LongWord &pcbValue) = 0 ;
	virtual HRESULT __stdcall SetIPortableDeviceValuesValue(_tagpropertykey &key, const _di_IPortableDeviceValues pValue) = 0 ;
	virtual HRESULT __stdcall GetIPortableDeviceValuesValue(_tagpropertykey &key, /* out */ _di_IPortableDeviceValues &ppValue) = 0 ;
	virtual HRESULT __stdcall SetIPortableDevicePropVariantCollectionValue(_tagpropertykey &key, const _di_IPortableDevicePropVariantCollection pValue) = 0 ;
	virtual HRESULT __stdcall GetIPortableDevicePropVariantCollectionValue(_tagpropertykey &key, /* out */ _di_IPortableDevicePropVariantCollection &ppValue) = 0 ;
	virtual HRESULT __stdcall SetIPortableDeviceKeyCollectionValue(_tagpropertykey &key, const _di_IPortableDeviceKeyCollection pValue) = 0 ;
	virtual HRESULT __stdcall GetIPortableDeviceKeyCollectionValue(_tagpropertykey &key, /* out */ _di_IPortableDeviceKeyCollection &ppValue) = 0 ;
	virtual HRESULT __stdcall SetIPortableDeviceValuesCollectionValue(_tagpropertykey &key, const _di_IPortableDeviceValuesCollection pValue) = 0 ;
	virtual HRESULT __stdcall GetIPortableDeviceValuesCollectionValue(_tagpropertykey &key, /* out */ _di_IPortableDeviceValuesCollection &ppValue) = 0 ;
	virtual HRESULT __stdcall RemoveValue(_tagpropertykey &key) = 0 ;
	virtual HRESULT __stdcall CopyValuesFromPropertyStore(const _di_IPropertyStore pStore) = 0 ;
	virtual HRESULT __stdcall CopyValuesToPropertyStore(const _di_IPropertyStore pStore) = 0 ;
	virtual HRESULT __stdcall Clear() = 0 ;
};

__interface  INTERFACE_UUID("{0000000B-0000-0000-C000-000000000046}") IStorage  : public System::IInterface 
{
	virtual HRESULT __stdcall CreateStream(System::WideChar * pwcsName, System::LongWord grfMode, System::LongWord reserved1, System::LongWord reserved2, /* out */ _di_IStream &ppstm) = 0 ;
	virtual HRESULT __stdcall RemoteOpenStream(System::WideChar * pwcsName, System::LongWord cbReserved1, System::Byte &reserved1, System::LongWord grfMode, System::LongWord reserved2, /* out */ _di_IStream &ppstm) = 0 ;
	virtual HRESULT __stdcall CreateStorage(System::WideChar * pwcsName, System::LongWord grfMode, System::LongWord reserved1, System::LongWord reserved2, /* out */ _di_IStorage &ppstg) = 0 ;
	virtual HRESULT __stdcall OpenStorage(System::WideChar * pwcsName, const _di_IStorage pstgPriority, System::LongWord grfMode, tagRemSNB &snbExclude, System::LongWord reserved, /* out */ _di_IStorage &ppstg) = 0 ;
	virtual HRESULT __stdcall RemoteCopyTo(System::LongWord ciidExclude, GUID &rgiidExclude, tagRemSNB &snbExclude, const _di_IStorage pstgDest) = 0 ;
	virtual HRESULT __stdcall MoveElementTo(System::WideChar * pwcsName, const _di_IStorage pstgDest, System::WideChar * pwcsNewName, System::LongWord grfFlags) = 0 ;
	virtual HRESULT __stdcall Commit(System::LongWord grfCommitFlags) = 0 ;
	virtual HRESULT __stdcall Revert() = 0 ;
	virtual HRESULT __stdcall RemoteEnumElements(System::LongWord reserved1, System::LongWord cbReserved2, System::Byte &reserved2, System::LongWord reserved3, /* out */ _di_IEnumSTATSTG &ppenum) = 0 ;
	virtual HRESULT __stdcall DestroyElement(System::WideChar * pwcsName) = 0 ;
	virtual HRESULT __stdcall RenameElement(System::WideChar * pwcsOldName, System::WideChar * pwcsNewName) = 0 ;
	virtual HRESULT __stdcall SetElementTimes(System::WideChar * pwcsName, _FILETIME &pctime, _FILETIME &patime, _FILETIME &pmtime) = 0 ;
	virtual HRESULT __stdcall SetClass(GUID &clsid) = 0 ;
	virtual HRESULT __stdcall SetStateBits(System::LongWord grfStateBits, System::LongWord grfMask) = 0 ;
	virtual HRESULT __stdcall Stat(/* out */ tagSTATSTG &pstatstg, System::LongWord grfStatFlag) = 0 ;
};

__interface  INTERFACE_UUID("{0000000D-0000-0000-C000-000000000046}") IEnumSTATSTG  : public System::IInterface 
{
	virtual HRESULT __stdcall RemoteNext(System::LongWord celt, /* out */ tagSTATSTG &rgelt, /* out */ System::LongWord &pceltFetched) = 0 ;
	virtual HRESULT __stdcall Skip(System::LongWord celt) = 0 ;
	virtual HRESULT __stdcall Reset() = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumSTATSTG &ppenum) = 0 ;
};

__interface  INTERFACE_UUID("{0000002F-0000-0000-C000-000000000046}") IRecordInfo  : public System::IInterface 
{
	virtual HRESULT __stdcall RecordInit(void * pvNew) = 0 ;
	virtual HRESULT __stdcall RecordClear(void * pvExisting) = 0 ;
	virtual HRESULT __stdcall RecordCopy(void * pvExisting, void * pvNew) = 0 ;
	virtual HRESULT __stdcall GetGuid(/* out */ GUID &pguid) = 0 ;
	virtual HRESULT __stdcall GetName(/* out */ System::WideString &pbstrName) = 0 ;
	virtual HRESULT __stdcall GetSize(/* out */ System::LongWord &pcbSize) = 0 ;
	virtual HRESULT __stdcall GetTypeInfo(/* out */ _di_ITypeInfo &ppTypeInfo) = 0 ;
	virtual HRESULT __stdcall GetField(void * pvData, System::WideChar * szFieldName, /* out */ System::OleVariant &pvarField) = 0 ;
	virtual HRESULT __stdcall GetFieldNoCopy(void * pvData, System::WideChar * szFieldName, /* out */ System::OleVariant &pvarField, /* out */ void * &ppvDataCArray) = 0 ;
	virtual HRESULT __stdcall PutField(System::LongWord wFlags, void * pvData, System::WideChar * szFieldName, const System::OleVariant &pvarField) = 0 ;
	virtual HRESULT __stdcall PutFieldNoCopy(System::LongWord wFlags, void * pvData, System::WideChar * szFieldName, const System::OleVariant &pvarField) = 0 ;
	virtual HRESULT __stdcall GetFieldNames(System::LongWord &pcNames, /* out */ System::WideString &rgBstrNames) = 0 ;
	virtual int __stdcall IsMatchingType(const _di_IRecordInfo pRecordInfo) = 0 ;
	virtual void * __stdcall RecordCreate() = 0 ;
	virtual HRESULT __stdcall RecordCreateCopy(void * pvSource, /* out */ void * &ppvDest) = 0 ;
	virtual HRESULT __stdcall RecordDestroy(void * pvRecord) = 0 ;
};

__interface  INTERFACE_UUID("{00020401-0000-0000-C000-000000000046}") ITypeInfo  : public System::IInterface 
{
	virtual HRESULT __stdcall RemoteGetTypeAttr(/* out */ PUserType8 &ppTypeAttr, /* out */ DWORD &pDummy) = 0 ;
	virtual HRESULT __stdcall GetTypeComp(/* out */ _di_ITypeComp &ppTComp) = 0 ;
	virtual HRESULT __stdcall RemoteGetFuncDesc(unsigned index, /* out */ PUserType9 &ppFuncDesc, /* out */ DWORD &pDummy) = 0 ;
	virtual HRESULT __stdcall RemoteGetVarDesc(unsigned index, /* out */ PUserType10 &ppVarDesc, /* out */ DWORD &pDummy) = 0 ;
	virtual HRESULT __stdcall RemoteGetNames(int memid, /* out */ System::WideString &rgBstrNames, unsigned cMaxNames, /* out */ unsigned &pcNames) = 0 ;
	virtual HRESULT __stdcall GetRefTypeOfImplType(unsigned index, /* out */ System::LongWord &pRefType) = 0 ;
	virtual HRESULT __stdcall GetImplTypeFlags(unsigned index, /* out */ int &pImplTypeFlags) = 0 ;
	virtual HRESULT __stdcall LocalGetIDsOfNames() = 0 ;
	virtual HRESULT __stdcall LocalInvoke() = 0 ;
	virtual HRESULT __stdcall RemoteGetDocumentation(int memid, System::LongWord refPtrFlags, /* out */ System::WideString &pbstrName, /* out */ System::WideString &pBstrDocString, /* out */ System::LongWord &pdwHelpContext, /* out */ System::WideString &pBstrHelpFile) = 0 ;
	virtual HRESULT __stdcall RemoteGetDllEntry(int memid, tagINVOKEKIND invkind, System::LongWord refPtrFlags, /* out */ System::WideString &pBstrDllName, /* out */ System::WideString &pbstrName, /* out */ System::Word &pwOrdinal) = 0 ;
	virtual HRESULT __stdcall GetRefTypeInfo(System::LongWord hreftype, /* out */ _di_ITypeInfo &ppTInfo) = 0 ;
	virtual HRESULT __stdcall LocalAddressOfMember() = 0 ;
	virtual HRESULT __stdcall RemoteCreateInstance(GUID &riid, /* out */ System::_di_IInterface &ppvObj) = 0 ;
	virtual HRESULT __stdcall GetMops(int memid, /* out */ System::WideString &pBstrMops) = 0 ;
	virtual HRESULT __stdcall RemoteGetContainingTypeLib(/* out */ _di_ITypeLib &ppTLib, /* out */ unsigned &pIndex) = 0 ;
	virtual HRESULT __stdcall LocalReleaseTypeAttr() = 0 ;
	virtual HRESULT __stdcall LocalReleaseFuncDesc() = 0 ;
	virtual HRESULT __stdcall LocalReleaseVarDesc() = 0 ;
};

__interface  INTERFACE_UUID("{00020403-0000-0000-C000-000000000046}") ITypeComp  : public System::IInterface 
{
	virtual HRESULT __stdcall RemoteBind(System::WideChar * szName, System::LongWord lHashVal, System::Word wFlags, /* out */ _di_ITypeInfo &ppTInfo, /* out */ tagDESCKIND &pDescKind, /* out */ PUserType9 &ppFuncDesc, /* out */ PUserType10 &ppVarDesc, /* out */ _di_ITypeComp &ppTypeComp, /* out */ DWORD &pDummy) = 0 ;
	virtual HRESULT __stdcall RemoteBindType(System::WideChar * szName, System::LongWord lHashVal, /* out */ _di_ITypeInfo &ppTInfo) = 0 ;
};

__interface  INTERFACE_UUID("{00020402-0000-0000-C000-000000000046}") ITypeLib  : public System::IInterface 
{
	virtual HRESULT __stdcall RemoteGetTypeInfoCount(/* out */ unsigned &pcTInfo) = 0 ;
	virtual HRESULT __stdcall GetTypeInfo(unsigned index, /* out */ _di_ITypeInfo &ppTInfo) = 0 ;
	virtual HRESULT __stdcall GetTypeInfoType(unsigned index, /* out */ tagTYPEKIND &pTKind) = 0 ;
	virtual HRESULT __stdcall GetTypeInfoOfGuid(GUID &guid, /* out */ _di_ITypeInfo &ppTInfo) = 0 ;
	virtual HRESULT __stdcall RemoteGetLibAttr(/* out */ PUserType13 &ppTLibAttr, /* out */ DWORD &pDummy) = 0 ;
	virtual HRESULT __stdcall GetTypeComp(/* out */ _di_ITypeComp &ppTComp) = 0 ;
	virtual HRESULT __stdcall RemoteGetDocumentation(int index, System::LongWord refPtrFlags, /* out */ System::WideString &pbstrName, /* out */ System::WideString &pBstrDocString, /* out */ System::LongWord &pdwHelpContext, /* out */ System::WideString &pBstrHelpFile) = 0 ;
	virtual HRESULT __stdcall RemoteIsName(System::WideChar * szNameBuf, System::LongWord lHashVal, /* out */ int &pfName, /* out */ System::WideString &pBstrLibName) = 0 ;
	virtual HRESULT __stdcall RemoteFindName(System::WideChar * szNameBuf, System::LongWord lHashVal, /* out */ _di_ITypeInfo &ppTInfo, /* out */ int &rgMemId, System::Word &pcFound, /* out */ System::WideString &pBstrLibName) = 0 ;
	virtual HRESULT __stdcall LocalReleaseTLibAttr() = 0 ;
};

__interface  INTERFACE_UUID("{89B2E422-4F1B-4316-BCEF-A44AFEA83EB3}") IPortableDevicePropVariantCollection  : public System::IInterface 
{
	virtual HRESULT __stdcall GetCount(System::LongWord &pcElems) = 0 ;
	virtual HRESULT __stdcall GetAt(System::LongWord dwIndex, tag_inner_PROPVARIANT &pValue) = 0 ;
	virtual HRESULT __stdcall Add(tag_inner_PROPVARIANT &pValue) = 0 ;
	virtual HRESULT __stdcall GetType(/* out */ System::Word &pvt) = 0 ;
	virtual HRESULT __stdcall ChangeType(System::Word vt) = 0 ;
	virtual HRESULT __stdcall Clear() = 0 ;
	virtual HRESULT __stdcall RemoveAt(System::LongWord dwIndex) = 0 ;
};

__interface  INTERFACE_UUID("{DADA2357-E0AD-492E-98DB-DD61C53BA353}") IPortableDeviceKeyCollection  : public System::IInterface 
{
	virtual HRESULT __stdcall GetCount(System::LongWord &pcElems) = 0 ;
	virtual HRESULT __stdcall GetAt(System::LongWord dwIndex, _tagpropertykey &pKey) = 0 ;
	virtual HRESULT __stdcall Add(_tagpropertykey &key) = 0 ;
	virtual HRESULT __stdcall Clear() = 0 ;
	virtual HRESULT __stdcall RemoveAt(System::LongWord dwIndex) = 0 ;
};

__interface  INTERFACE_UUID("{6E3F2D79-4E07-48C4-8208-D8C2E5AF4A99}") IPortableDeviceValuesCollection  : public System::IInterface 
{
	virtual HRESULT __stdcall GetCount(System::LongWord &pcElems) = 0 ;
	virtual HRESULT __stdcall GetAt(System::LongWord dwIndex, /* out */ _di_IPortableDeviceValues &ppValues) = 0 ;
	virtual HRESULT __stdcall Add(const _di_IPortableDeviceValues pValues) = 0 ;
	virtual HRESULT __stdcall Clear() = 0 ;
	virtual HRESULT __stdcall RemoveAt(System::LongWord dwIndex) = 0 ;
};

__interface  INTERFACE_UUID("{886D8EEB-8CF2-4446-8D02-CDBA1DBDCF99}") IPropertyStore  : public System::IInterface 
{
	virtual HRESULT __stdcall GetCount(/* out */ System::LongWord &cProps) = 0 ;
	virtual HRESULT __stdcall GetAt(System::LongWord iProp, /* out */ _tagpropertykey &pKey) = 0 ;
	virtual HRESULT __stdcall GetValue(_tagpropertykey &key, /* out */ tag_inner_PROPVARIANT &pv) = 0 ;
	virtual HRESULT __stdcall SetValue(_tagpropertykey &key, tag_inner_PROPVARIANT &propvar) = 0 ;
	virtual HRESULT __stdcall Commit() = 0 ;
};

__interface  INTERFACE_UUID("{6A96ED84-7C73-4480-9938-BF5AF477D426}") IPortableDeviceContent  : public System::IInterface 
{
	virtual HRESULT __stdcall EnumObjects(System::LongWord dwFlags, System::WideChar * pszParentObjectID, const _di_IPortableDeviceValues pFilter, /* out */ _di_IEnumPortableDeviceObjectIDs &ppenum) = 0 ;
	virtual HRESULT __stdcall Properties(/* out */ _di_IPortableDeviceProperties &ppProperties) = 0 ;
	virtual HRESULT __stdcall Transfer(/* out */ _di_IPortableDeviceResources &ppResources) = 0 ;
	virtual HRESULT __stdcall CreateObjectWithPropertiesOnly(const _di_IPortableDeviceValues pValues, System::WideChar * &ppszObjectID) = 0 ;
	virtual HRESULT __stdcall CreateObjectWithPropertiesAndData(const _di_IPortableDeviceValues pValues, /* out */ _di_IStream &ppData, System::LongWord &pdwOptimalWriteBufferSize, System::WideChar * &ppszCookie) = 0 ;
	virtual HRESULT __stdcall Delete(System::LongWord dwOptions, const _di_IPortableDevicePropVariantCollection pObjectIDs, _di_IPortableDevicePropVariantCollection &ppResults) = 0 ;
	virtual HRESULT __stdcall GetObjectIDsFromPersistentUniqueIDs(const _di_IPortableDevicePropVariantCollection pPersistentUniqueIDs, /* out */ _di_IPortableDevicePropVariantCollection &ppObjectIDs) = 0 ;
	virtual HRESULT __stdcall Cancel() = 0 ;
	virtual HRESULT __stdcall Move(const _di_IPortableDevicePropVariantCollection pObjectIDs, System::WideChar * pszDestinationFolderObjectID, _di_IPortableDevicePropVariantCollection &ppResults) = 0 ;
	virtual HRESULT __stdcall Copy(const _di_IPortableDevicePropVariantCollection pObjectIDs, System::WideChar * pszDestinationFolderObjectID, _di_IPortableDevicePropVariantCollection &ppResults) = 0 ;
};

__interface  INTERFACE_UUID("{10ECE955-CF41-4728-BFA0-41EEDF1BBF19}") IEnumPortableDeviceObjectIDs  : public System::IInterface 
{
	virtual HRESULT __stdcall Next(System::LongWord cObjects, /* out */ System::WideChar * &pObjIDs, System::LongWord &pcFetched) = 0 ;
	virtual HRESULT __stdcall Skip(System::LongWord cObjects) = 0 ;
	virtual HRESULT __stdcall Reset() = 0 ;
	virtual HRESULT __stdcall Clone(/* out */ _di_IEnumPortableDeviceObjectIDs &ppenum) = 0 ;
	virtual HRESULT __stdcall Cancel() = 0 ;
};

__interface  INTERFACE_UUID("{7F6D695C-03DF-4439-A809-59266BEEE3A6}") IPortableDeviceProperties  : public System::IInterface 
{
	virtual HRESULT __stdcall GetSupportedProperties(System::WideChar * pszObjectID, /* out */ _di_IPortableDeviceKeyCollection &ppKeys) = 0 ;
	virtual HRESULT __stdcall GetPropertyAttributes(System::WideChar * pszObjectID, _tagpropertykey &key, /* out */ _di_IPortableDeviceValues &ppAttributes) = 0 ;
	virtual HRESULT __stdcall GetValues(System::WideChar * pszObjectID, const _di_IPortableDeviceKeyCollection pKeys, /* out */ _di_IPortableDeviceValues &ppValues) = 0 ;
	virtual HRESULT __stdcall SetValues(System::WideChar * pszObjectID, const _di_IPortableDeviceValues pValues, /* out */ _di_IPortableDeviceValues &ppResults) = 0 ;
	virtual HRESULT __stdcall Delete(System::WideChar * pszObjectID, const _di_IPortableDeviceKeyCollection pKeys) = 0 ;
	virtual HRESULT __stdcall Cancel() = 0 ;
};

__interface  INTERFACE_UUID("{FD8878AC-D841-4D17-891C-E6829CDB6934}") IPortableDeviceResources  : public System::IInterface 
{
	virtual HRESULT __stdcall GetSupportedResources(System::WideChar * pszObjectID, /* out */ _di_IPortableDeviceKeyCollection &ppKeys) = 0 ;
	virtual HRESULT __stdcall GetResourceAttributes(System::WideChar * pszObjectID, _tagpropertykey &key, /* out */ _di_IPortableDeviceValues &ppResourceAttributes) = 0 ;
	virtual HRESULT __stdcall GetStream(System::WideChar * pszObjectID, _tagpropertykey &key, System::LongWord dwMode, System::LongWord &pdwOptimalBufferSize, /* out */ _di_IStream &ppStream) = 0 ;
	virtual HRESULT __stdcall Delete(System::WideChar * pszObjectID, const _di_IPortableDeviceKeyCollection pKeys) = 0 ;
	virtual HRESULT __stdcall Cancel() = 0 ;
	virtual HRESULT __stdcall CreateResource(const _di_IPortableDeviceValues pResourceAttributes, /* out */ _di_IStream &ppData, System::LongWord &pdwOptimalWriteBufferSize, System::WideChar * &ppszCookie) = 0 ;
};

__interface  INTERFACE_UUID("{2C8C6DBF-E3DC-4061-BECC-8542E810D126}") IPortableDeviceCapabilities  : public System::IInterface 
{
	virtual HRESULT __stdcall GetSupportedCommands(/* out */ _di_IPortableDeviceKeyCollection &ppCommands) = 0 ;
	virtual HRESULT __stdcall GetCommandOptions(_tagpropertykey &Command, /* out */ _di_IPortableDeviceValues &ppOptions) = 0 ;
	virtual HRESULT __stdcall GetFunctionalCategories(/* out */ _di_IPortableDevicePropVariantCollection &ppCategories) = 0 ;
	virtual HRESULT __stdcall GetFunctionalObjects(GUID &Category, /* out */ _di_IPortableDevicePropVariantCollection &ppObjectIDs) = 0 ;
	virtual HRESULT __stdcall GetSupportedContentTypes(GUID &Category, /* out */ _di_IPortableDevicePropVariantCollection &ppContentTypes) = 0 ;
	virtual HRESULT __stdcall GetSupportedFormats(GUID &ContentType, /* out */ _di_IPortableDevicePropVariantCollection &ppFormats) = 0 ;
	virtual HRESULT __stdcall GetSupportedFormatProperties(GUID &Format, /* out */ _di_IPortableDeviceKeyCollection &ppKeys) = 0 ;
	virtual HRESULT __stdcall GetFixedPropertyAttributes(GUID &Format, _tagpropertykey &key, /* out */ _di_IPortableDeviceValues &ppAttributes) = 0 ;
	virtual HRESULT __stdcall Cancel() = 0 ;
	virtual HRESULT __stdcall GetSupportedEvents(/* out */ _di_IPortableDevicePropVariantCollection &ppEvents) = 0 ;
	virtual HRESULT __stdcall GetEventOptions(GUID &Event, /* out */ _di_IPortableDeviceValues &ppOptions) = 0 ;
};

__interface  INTERFACE_UUID("{A8792A31-F385-493C-A893-40F64EB45F6E}") IPortableDeviceEventCallback  : public System::IInterface 
{
	virtual HRESULT __stdcall OnEvent(const _di_IPortableDeviceValues pEventParameters) = 0 ;
};

__interface  INTERFACE_UUID("{A1567595-4C2F-4574-A6FA-ECEF917B9A40}") IPortableDeviceManager  : public System::IInterface 
{
	virtual HRESULT __stdcall GetDevices(System::WideChar * &pPnPDeviceIDs, System::LongWord &pcPnPDeviceIDs) = 0 ;
	virtual HRESULT __stdcall RefreshDeviceList() = 0 ;
	virtual HRESULT __stdcall GetDeviceFriendlyName(System::WideChar * pszPnPDeviceID, System::Word &pDeviceFriendlyName, System::LongWord &pcchDeviceFriendlyName) = 0 ;
	virtual HRESULT __stdcall GetDeviceDescription(System::WideChar * pszPnPDeviceID, System::Word &pDeviceDescription, System::LongWord &pcchDeviceDescription) = 0 ;
	virtual HRESULT __stdcall GetDeviceManufacturer(System::WideChar * pszPnPDeviceID, System::Word &pDeviceManufacturer, System::LongWord &pcchDeviceManufacturer) = 0 ;
	virtual HRESULT __stdcall GetDeviceProperty(System::WideChar * pszPnPDeviceID, System::WideChar * pszDevicePropertyName, System::Byte &pData, System::LongWord &pcbData, System::LongWord &pdwType) = 0 ;
	virtual HRESULT __stdcall GetPrivateDevices(System::WideChar * &pPnPDeviceIDs, System::LongWord &pcPnPDeviceIDs) = 0 ;
};

__interface  INTERFACE_UUID("{D3BD3A44-D7B5-40A9-98B7-2FA4D01DEC08}") IPortableDeviceService  : public System::IInterface 
{
	virtual HRESULT __stdcall Open(System::WideChar * pszPnPServiceID, const _di_IPortableDeviceValues pClientInfo) = 0 ;
	virtual HRESULT __stdcall Capabilities(/* out */ _di_IPortableDeviceServiceCapabilities &ppCapabilities) = 0 ;
	virtual HRESULT __stdcall Content(/* out */ _di_IPortableDeviceContent2 &ppContent) = 0 ;
	virtual HRESULT __stdcall Methods(/* out */ _di_IPortableDeviceServiceMethods &ppMethods) = 0 ;
	virtual HRESULT __stdcall Cancel() = 0 ;
	virtual HRESULT __stdcall Close() = 0 ;
	virtual HRESULT __stdcall GetServiceObjectID(/* out */ System::WideChar * &ppszServiceObjectID) = 0 ;
	virtual HRESULT __stdcall GetPnPServiceID(/* out */ System::WideChar * &ppszPnPServiceID) = 0 ;
	virtual HRESULT __stdcall Advise(System::LongWord dwFlags, const _di_IPortableDeviceEventCallback pCallback, const _di_IPortableDeviceValues pParameters, /* out */ System::WideChar * &ppszCookie) = 0 ;
	virtual HRESULT __stdcall Unadvise(System::WideChar * pszCookie) = 0 ;
	virtual HRESULT __stdcall SendCommand(System::LongWord dwFlags, const _di_IPortableDeviceValues pParameters, /* out */ _di_IPortableDeviceValues &ppResults) = 0 ;
};

__interface  INTERFACE_UUID("{24DBD89D-413E-43E0-BD5B-197F3C56C886}") IPortableDeviceServiceCapabilities  : public System::IInterface 
{
	virtual HRESULT __stdcall GetSupportedMethods(/* out */ _di_IPortableDevicePropVariantCollection &ppMethods) = 0 ;
	virtual HRESULT __stdcall GetSupportedMethodsByFormat(GUID &Format, /* out */ _di_IPortableDevicePropVariantCollection &ppMethods) = 0 ;
	virtual HRESULT __stdcall GetMethodAttributes(GUID &Method, /* out */ _di_IPortableDeviceValues &ppAttributes) = 0 ;
	virtual HRESULT __stdcall GetMethodParameterAttributes(GUID &Method, _tagpropertykey &Parameter, /* out */ _di_IPortableDeviceValues &ppAttributes) = 0 ;
	virtual HRESULT __stdcall GetSupportedFormats(/* out */ _di_IPortableDevicePropVariantCollection &ppFormats) = 0 ;
	virtual HRESULT __stdcall GetFormatAttributes(GUID &Format, /* out */ _di_IPortableDeviceValues &ppAttributes) = 0 ;
	virtual HRESULT __stdcall GetSupportedFormatProperties(GUID &Format, /* out */ _di_IPortableDeviceKeyCollection &ppKeys) = 0 ;
	virtual HRESULT __stdcall GetFormatPropertyAttributes(GUID &Format, _tagpropertykey &Property_, /* out */ _di_IPortableDeviceValues &ppAttributes) = 0 ;
	virtual HRESULT __stdcall GetSupportedEvents(/* out */ _di_IPortableDevicePropVariantCollection &ppEvents) = 0 ;
	virtual HRESULT __stdcall GetEventAttributes(GUID &Event, /* out */ _di_IPortableDeviceValues &ppAttributes) = 0 ;
	virtual HRESULT __stdcall GetEventParameterAttributes(GUID &Event, _tagpropertykey &Parameter, /* out */ _di_IPortableDeviceValues &ppAttributes) = 0 ;
	virtual HRESULT __stdcall GetInheritedServices(System::LongWord dwInheritanceType, /* out */ _di_IPortableDevicePropVariantCollection &ppServices) = 0 ;
	virtual HRESULT __stdcall GetFormatRenderingProfiles(GUID &Format, /* out */ _di_IPortableDeviceValuesCollection &ppRenderingProfiles) = 0 ;
	virtual HRESULT __stdcall GetSupportedCommands(/* out */ _di_IPortableDeviceKeyCollection &ppCommands) = 0 ;
	virtual HRESULT __stdcall GetCommandOptions(_tagpropertykey &Command, /* out */ _di_IPortableDeviceValues &ppOptions) = 0 ;
	virtual HRESULT __stdcall Cancel() = 0 ;
};

__interface  INTERFACE_UUID("{9B4ADD96-F6BF-4034-8708-ECA72BF10554}") IPortableDeviceContent2  : public IPortableDeviceContent 
{
	virtual HRESULT __stdcall UpdateObjectWithPropertiesAndData(System::WideChar * pszObjectID, const _di_IPortableDeviceValues pProperties, /* out */ _di_IStream &ppData, System::LongWord &pdwOptimalWriteBufferSize) = 0 ;
};

__interface  INTERFACE_UUID("{E20333C9-FD34-412D-A381-CC6F2D820DF7}") IPortableDeviceServiceMethods  : public System::IInterface 
{
	virtual HRESULT __stdcall Invoke(GUID &Method, const _di_IPortableDeviceValues pParameters, _di_IPortableDeviceValues &ppResults) = 0 ;
	virtual HRESULT __stdcall InvokeAsync(GUID &Method, const _di_IPortableDeviceValues pParameters, const _di_IPortableDeviceServiceMethodCallback pCallback) = 0 ;
	virtual HRESULT __stdcall Cancel(const _di_IPortableDeviceServiceMethodCallback pCallback) = 0 ;
};

__interface  INTERFACE_UUID("{C424233C-AFCE-4828-A756-7ED7A2350083}") IPortableDeviceServiceMethodCallback  : public System::IInterface 
{
	virtual HRESULT __stdcall OnComplete(HRESULT hrStatus, const _di_IPortableDeviceValues pResults) = 0 ;
};

__interface  INTERFACE_UUID("{5E1EAFC3-E3D7-4132-96FA-759C0F9D1E0F}") IPortableDeviceDispatchFactory  : public System::IInterface 
{
	virtual HRESULT __stdcall GetDeviceDispatch(System::WideChar * pszPnPDeviceID, /* out */ _di_IDispatch &ppDeviceDispatch) = 0 ;
};

__interface  INTERFACE_UUID("{94FC7953-5CA1-483A-8AEE-DF52E7747D00}") IPortableDeviceWebControl  : public IDispatch 
{
	virtual HRESULT __safecall GetDeviceFromId(const System::WideString deviceId, _di_IDispatch &__GetDeviceFromId_result) = 0 ;
	virtual HRESULT __safecall GetDeviceFromIdAsync(const System::WideString deviceId, const _di_IDispatch pCompletionHandler, const _di_IDispatch pErrorHandler) = 0 ;
};

__dispinterface  INTERFACE_UUID("{94FC7953-5CA1-483A-8AEE-DF52E7747D00}") IPortableDeviceWebControlDisp  : public IDispatch 
{
	
};

__interface  INTERFACE_UUID("{88E04DB3-1012-4D64-9996-F703A950D3F4}") IPortableDeviceDataStream  : public IStream 
{
	virtual HRESULT __stdcall GetObjectID(System::WideChar * &ppszObjectID) = 0 ;
	virtual HRESULT __stdcall Cancel() = 0 ;
};

#pragma pack(push,4)
class PASCALIMPLEMENTATION CoPortableDevice : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod _di_IPortableDevice __fastcall Create();
	__classmethod _di_IPortableDevice __fastcall CreateRemote(const System::UnicodeString MachineName);
public:
	/* TObject.Create */ inline __fastcall CoPortableDevice() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~CoPortableDevice() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION CoPortableDeviceManager : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod _di_IPortableDeviceManager __fastcall Create();
	__classmethod _di_IPortableDeviceManager __fastcall CreateRemote(const System::UnicodeString MachineName);
public:
	/* TObject.Create */ inline __fastcall CoPortableDeviceManager() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~CoPortableDeviceManager() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION CoPortableDeviceService : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod _di_IPortableDeviceService __fastcall Create();
	__classmethod _di_IPortableDeviceService __fastcall CreateRemote(const System::UnicodeString MachineName);
public:
	/* TObject.Create */ inline __fastcall CoPortableDeviceService() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~CoPortableDeviceService() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION CoPortableDeviceDispatchFactory : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod _di_IPortableDeviceDispatchFactory __fastcall Create();
	__classmethod _di_IPortableDeviceDispatchFactory __fastcall CreateRemote(const System::UnicodeString MachineName);
public:
	/* TObject.Create */ inline __fastcall CoPortableDeviceDispatchFactory() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~CoPortableDeviceDispatchFactory() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION CoPortableDeviceFTM : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod _di_IPortableDevice __fastcall Create();
	__classmethod _di_IPortableDevice __fastcall CreateRemote(const System::UnicodeString MachineName);
public:
	/* TObject.Create */ inline __fastcall CoPortableDeviceFTM() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~CoPortableDeviceFTM() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION CoPortableDeviceServiceFTM : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod _di_IPortableDeviceService __fastcall Create();
	__classmethod _di_IPortableDeviceService __fastcall CreateRemote(const System::UnicodeString MachineName);
public:
	/* TObject.Create */ inline __fastcall CoPortableDeviceServiceFTM() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~CoPortableDeviceServiceFTM() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION CoPortableDeviceWebControl : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod _di_IPortableDeviceWebControl __fastcall Create();
	__classmethod _di_IPortableDeviceWebControl __fastcall CreateRemote(const System::UnicodeString MachineName);
public:
	/* TObject.Create */ inline __fastcall CoPortableDeviceWebControl() : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~CoPortableDeviceWebControl() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static _DELPHI_CONST System::Int8 PortableDeviceApiLibMajorVersion = System::Int8(0x1);
static _DELPHI_CONST System::Int8 PortableDeviceApiLibMinorVersion = System::Int8(0x0);
extern DELPHI_PACKAGE GUID LIBID_PortableDeviceApiLib;
extern DELPHI_PACKAGE GUID IID_IPortableDevice;
extern DELPHI_PACKAGE GUID CLASS_PortableDevice;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceValues;
extern DELPHI_PACKAGE GUID IID_IStorage;
extern DELPHI_PACKAGE GUID IID_IEnumSTATSTG;
extern DELPHI_PACKAGE GUID IID_IRecordInfo;
extern DELPHI_PACKAGE GUID IID_ITypeInfo;
extern DELPHI_PACKAGE GUID IID_ITypeComp;
extern DELPHI_PACKAGE GUID IID_ITypeLib;
extern DELPHI_PACKAGE GUID IID_IPortableDevicePropVariantCollection;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceKeyCollection;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceValuesCollection;
extern DELPHI_PACKAGE GUID IID_IPropertyStore;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceContent;
extern DELPHI_PACKAGE GUID IID_IEnumPortableDeviceObjectIDs;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceProperties;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceResources;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceCapabilities;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceEventCallback;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceManager;
extern DELPHI_PACKAGE GUID CLASS_PortableDeviceManager;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceService;
extern DELPHI_PACKAGE GUID CLASS_PortableDeviceService;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceServiceCapabilities;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceContent2;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceServiceMethods;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceServiceMethodCallback;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceDispatchFactory;
extern DELPHI_PACKAGE GUID CLASS_PortableDeviceDispatchFactory;
extern DELPHI_PACKAGE GUID CLASS_PortableDeviceFTM;
extern DELPHI_PACKAGE GUID CLASS_PortableDeviceServiceFTM;
extern DELPHI_PACKAGE GUID IID_IPortableDeviceWebControl;
extern DELPHI_PACKAGE GUID CLASS_PortableDeviceWebControl;
static _DELPHI_CONST System::Int8 TKIND_ENUM = System::Int8(0x0);
static _DELPHI_CONST System::Int8 TKIND_RECORD = System::Int8(0x1);
static _DELPHI_CONST System::Int8 TKIND_MODULE = System::Int8(0x2);
static _DELPHI_CONST System::Int8 TKIND_INTERFACE = System::Int8(0x3);
static _DELPHI_CONST System::Int8 TKIND_DISPATCH = System::Int8(0x4);
static _DELPHI_CONST System::Int8 TKIND_COCLASS = System::Int8(0x5);
static _DELPHI_CONST System::Int8 TKIND_ALIAS = System::Int8(0x6);
static _DELPHI_CONST System::Int8 TKIND_UNION = System::Int8(0x7);
static _DELPHI_CONST System::Int8 TKIND_MAX = System::Int8(0x8);
static _DELPHI_CONST System::Int8 DESCKIND_NONE = System::Int8(0x0);
static _DELPHI_CONST System::Int8 DESCKIND_FUNCDESC = System::Int8(0x1);
static _DELPHI_CONST System::Int8 DESCKIND_VARDESC = System::Int8(0x2);
static _DELPHI_CONST System::Int8 DESCKIND_TYPECOMP = System::Int8(0x3);
static _DELPHI_CONST System::Int8 DESCKIND_IMPLICITAPPOBJ = System::Int8(0x4);
static _DELPHI_CONST System::Int8 DESCKIND_MAX = System::Int8(0x5);
static _DELPHI_CONST System::Int8 FUNC_VIRTUAL = System::Int8(0x0);
static _DELPHI_CONST System::Int8 FUNC_PUREVIRTUAL = System::Int8(0x1);
static _DELPHI_CONST System::Int8 FUNC_NONVIRTUAL = System::Int8(0x2);
static _DELPHI_CONST System::Int8 FUNC_STATIC = System::Int8(0x3);
static _DELPHI_CONST System::Int8 FUNC_DISPATCH = System::Int8(0x4);
static _DELPHI_CONST System::Int8 INVOKE_FUNC = System::Int8(0x1);
static _DELPHI_CONST System::Int8 INVOKE_PROPERTYGET = System::Int8(0x2);
static _DELPHI_CONST System::Int8 INVOKE_PROPERTYPUT = System::Int8(0x4);
static _DELPHI_CONST System::Int8 INVOKE_PROPERTYPUTREF = System::Int8(0x8);
static _DELPHI_CONST System::Int8 CC_FASTCALL = System::Int8(0x0);
static _DELPHI_CONST System::Int8 CC_CDECL = System::Int8(0x1);
static _DELPHI_CONST System::Int8 CC_MSCPASCAL = System::Int8(0x2);
static _DELPHI_CONST System::Int8 CC_PASCAL = System::Int8(0x2);
static _DELPHI_CONST System::Int8 CC_MACPASCAL = System::Int8(0x3);
static _DELPHI_CONST System::Int8 CC_STDCALL = System::Int8(0x4);
static _DELPHI_CONST System::Int8 CC_FPFASTCALL = System::Int8(0x5);
static _DELPHI_CONST System::Int8 CC_SYSCALL = System::Int8(0x6);
static _DELPHI_CONST System::Int8 CC_MPWCDECL = System::Int8(0x7);
static _DELPHI_CONST System::Int8 CC_MPWPASCAL = System::Int8(0x8);
static _DELPHI_CONST System::Int8 CC_MAX = System::Int8(0x9);
static _DELPHI_CONST System::Int8 VAR_PERINSTANCE = System::Int8(0x0);
static _DELPHI_CONST System::Int8 VAR_STATIC = System::Int8(0x1);
static _DELPHI_CONST System::Int8 VAR_CONST = System::Int8(0x2);
static _DELPHI_CONST System::Int8 VAR_DISPATCH = System::Int8(0x3);
static _DELPHI_CONST System::Int8 SYS_WIN16 = System::Int8(0x0);
static _DELPHI_CONST System::Int8 SYS_WIN32 = System::Int8(0x1);
static _DELPHI_CONST System::Int8 SYS_MAC = System::Int8(0x2);
static _DELPHI_CONST System::Int8 SYS_WIN64 = System::Int8(0x3);
}	/* namespace Portabledeviceapilib_tlb */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_PORTABLEDEVICEAPILIB_TLB)
using namespace Portabledeviceapilib_tlb;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// PortableDeviceApiLib_TLBHPP
