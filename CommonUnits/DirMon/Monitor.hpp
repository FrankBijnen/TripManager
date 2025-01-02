// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'Monitor.pas' rev: 35.00 (Windows)

#ifndef MonitorHPP
#define MonitorHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>

//-- user supplied -----------------------------------------------------------

namespace Monitor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TDirectoryMonitor;
class DELPHICLASS TDirectoryMonitorWorkerThread;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TActionToWatch : unsigned char { awChangeFileName, awChangeDirName, awChangeAttributes, awChangeSize, awChangeLastWrite, awChangeLastAccess, awChangeCreation, awChangeSecurity };

typedef System::Set<TActionToWatch, TActionToWatch::awChangeFileName, TActionToWatch::awChangeSecurity> TActionsToWatch;

enum DECLSPEC_DENUM TDirectoryMonitorAction : unsigned char { daUnknown, daFileAdded, daFileRemoved, daFileModified, daFileRenamedOldName, daFileRenamedNewName };

typedef void __fastcall (__closure *TDirectoryChangeEvent)(System::TObject* Sender, TDirectoryMonitorAction Action, const System::WideString FileName);

class PASCALIMPLEMENTATION TDirectoryMonitor : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	NativeUInt FHandle;
	System::UnicodeString FDirectory;
	TActionsToWatch FActions;
	bool FSubdirectories;
	TDirectoryChangeEvent FOnChange;
	TDirectoryMonitorWorkerThread* FWorkerThread;
	bool __fastcall GetActive();
	void __fastcall SetActive(const bool Value);
	void __fastcall SetActions(const TActionsToWatch Value);
	void __fastcall SetDirectory(const System::UnicodeString Value);
	void __fastcall SetSubdirectories(const bool Value);
	
protected:
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Msg);
	virtual void __fastcall DoChange(TDirectoryMonitorAction Action, const System::WideString FileName);
	__property NativeUInt Handle = {read=FHandle, nodefault};
	
public:
	__fastcall TDirectoryMonitor();
	__fastcall virtual ~TDirectoryMonitor();
	void __fastcall Start();
	void __fastcall Stop();
	__property System::UnicodeString Directory = {read=FDirectory, write=SetDirectory};
	__property TActionsToWatch Actions = {read=FActions, write=SetActions, default=255};
	__property bool Subdirectories = {read=FSubdirectories, write=SetSubdirectories, default=0};
	__property TDirectoryChangeEvent OnChange = {read=FOnChange, write=FOnChange};
	__property bool Active = {read=GetActive, write=SetActive, nodefault};
};


class PASCALIMPLEMENTATION TDirectoryMonitorWorkerThread : public System::Classes::TThread
{
	typedef System::Classes::TThread inherited;
	
private:
	System::UnicodeString FDirectory;
	TActionsToWatch FActions;
	bool FSubdirectories;
	NativeUInt FOwnerHandle;
	NativeUInt FDirHandle;
	NativeUInt FChangeHandle;
	NativeUInt FShutdownHandle;
	unsigned __fastcall GetNotifyMask();
	TDirectoryMonitorAction __fastcall GetNotifyAction(unsigned SystemAction);
	
protected:
	virtual void __fastcall Execute();
	virtual void __fastcall TerminatedSet();
	
public:
	__fastcall TDirectoryMonitorWorkerThread(TDirectoryMonitor* Owner);
	__fastcall virtual ~TDirectoryMonitorWorkerThread();
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word WMUSER_DIRECTORYCHANGED = System::Word(0x401);
#define AllActions (System::Set<TActionToWatch, TActionToWatch::awChangeFileName, TActionToWatch::awChangeSecurity>() << TActionToWatch::awChangeFileName << TActionToWatch::awChangeDirName << TActionToWatch::awChangeAttributes << TActionToWatch::awChangeSize << TActionToWatch::awChangeLastWrite << TActionToWatch::awChangeLastAccess << TActionToWatch::awChangeCreation << TActionToWatch::awChangeSecurity )
}	/* namespace Monitor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_MONITOR)
using namespace Monitor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// MonitorHPP
