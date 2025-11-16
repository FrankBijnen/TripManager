// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UnitSqlite.pas' rev: 36.00 (Windows)

#ifndef UnitSqliteHPP
#define UnitSqliteHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Generics.Collections.hpp>
#include <System.Classes.hpp>
#include <Data.DB.hpp>
#include <Datasnap.DBClient.hpp>
#include <SQLiteWrap.hpp>
#include <UnitGpxDefs.hpp>
#include <System.SysUtils.hpp>
#include <System.Generics.Defaults.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unitsqlite
{
//-- forward type declarations -----------------------------------------------
struct TSqlColumn;
struct TVehicleProfile;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TSqlColumn
{
public:
	System::UTF8String Table_Name;
	System::UTF8String Table_Type;
	System::UTF8String Column_Name;
	System::UTF8String Column_Type;
	System::UTF8String PK;
};


typedef System::Generics::Collections::TList__1<TSqlColumn> TSqlColumns;

struct DECLSPEC_DRECORD TVehicleProfile
{
public:
	bool Valid;
	int Vehicle_Id;
	int TruckType;
	System::UTF8String Name;
	System::UTF8String GUID;
	int VehicleType;
	int TransportMode;
	int AdventurousLevel;
	bool __fastcall Changed(System::UTF8String IName, System::UTF8String IGUID, int IVehicle_Id, int ITruckType, int ITransportMode)/* overload */;
	bool __fastcall Changed(const TVehicleProfile &IVehicleProfile)/* overload */;
};


typedef System::Generics::Collections::TList__1<System::Variant> TSqlResult;

typedef System::Generics::Collections::TObjectList__1<TSqlResult*> TSqlResults;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::Generics::Collections::TList__1<TSqlColumn>* __fastcall GetColumns(Sqlitewrap::TSQLiteDatabase* const Db, const System::UnicodeString TabName)/* overload */;
extern DELPHI_PACKAGE TSqlColumns* __fastcall GetColumns(const System::UnicodeString DbName, const System::UnicodeString TabName)/* overload */;
extern DELPHI_PACKAGE void __fastcall GetTables(const System::UnicodeString DbName, System::Classes::TStrings* TabList);
extern DELPHI_PACKAGE void __fastcall ExecSqlQuery(const System::UnicodeString DbName, const System::UnicodeString Query, TSqlResults* const Results);
extern DELPHI_PACKAGE int __fastcall CDSFromQuery(const System::UnicodeString DbName, const System::UnicodeString Query, Datasnap::Dbclient::TClientDataSet* const ACds);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetAvoidancesChanged(const System::UnicodeString DbName);
extern DELPHI_PACKAGE TVehicleProfile __fastcall GetVehicleProfile(const System::UnicodeString DbName, const Unitgpxdefs::TGarminModel Model);
}	/* namespace Unitsqlite */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITSQLITE)
using namespace Unitsqlite;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnitSqliteHPP
