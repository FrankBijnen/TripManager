// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitUSBEvent.pas' rev: 36.00 (Windows)

#ifndef UnitUSBEventHPP
#define UnitUSBEventHPP

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
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitusbevent
{
//-- forward type declarations -----------------------------------------------
struct DEV_BROADCAST_DEVICEINTERFACE;
class DELPHICLASS TUSBEvent;
//-- type declarations -------------------------------------------------------
typedef DEV_BROADCAST_DEVICEINTERFACE *PDevBroadcastDeviceInterface;

struct DECLSPEC_DRECORD DEV_BROADCAST_DEVICEINTERFACE
{
public:
	unsigned dbcc_size;
	unsigned dbcc_devicetype;
	unsigned dbcc_reserved;
	GUID dbcc_classguid;
	System::WideChar dbcc_name;
};


typedef void __fastcall (__closure *TOnUSBChangeEvent)(const bool Inserted, const System::UnicodeString DeviceName, const System::UnicodeString VendorId, const System::UnicodeString ProductId);

class PASCALIMPLEMENTATION TUSBEvent : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	HWND FHandle;
	void *FDevNotifyHandle;
	TOnUSBChangeEvent FOnUSBChangeEvent;
	System::Classes::TNotifyEvent FOnDeviceAddedOrRemoved;
	void __fastcall WindowProc(Winapi::Messages::TMessage &AMessage);
	void __fastcall WMDeviceChange(Winapi::Messages::TMessage &AMessage);
	
public:
	__fastcall TUSBEvent();
	__fastcall virtual ~TUSBEvent();
	bool __fastcall RegisterUSBHandler(const GUID &ClassGuid);
	bool __fastcall UnRegisterUSBHandler();
	__property TOnUSBChangeEvent OnUSBChange = {read=FOnUSBChangeEvent, write=FOnUSBChangeEvent};
	__property System::Classes::TNotifyEvent OnDeviceAddedOrRemoved = {read=FOnDeviceAddedOrRemoved, write=FOnDeviceAddedOrRemoved};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE GUID GUID_DEVINTF_USB_DEVICE;
extern DELPHI_PACKAGE GUID GUID_DEVINTERFACE_WPD;
static _DELPHI_CONST System::Int8 USB_VOLUME = System::Int8(0x2);
static _DELPHI_CONST System::Int8 USB_INTERFACE = System::Int8(0x5);
static _DELPHI_CONST System::Int8 DBT_DEVNODES_CHANGED = System::Int8(0x7);
static _DELPHI_CONST System::Word DBT_DEVICEARRIVAL = System::Word(0x8000);
static _DELPHI_CONST System::Word DBT_DEVICEREMOVECOMPLETE = System::Word(0x8004);
}	/* namespace Unitusbevent */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITUSBEVENT)
using namespace Unitusbevent;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitUSBEventHPP
