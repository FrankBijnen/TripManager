// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UDmRoutePoints.pas' rev: 36.00 (Windows)

#ifndef UDmRoutePointsHPP
#define UDmRoutePointsHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <System.Generics.Collections.hpp>
#include <System.UITypes.hpp>
#include <Data.DB.hpp>
#include <Datasnap.DBClient.hpp>
#include <UnitTripObjects.hpp>
#include <UnitVerySimpleXml.hpp>

//-- user supplied -----------------------------------------------------------

namespace Udmroutepoints
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TDmRoutePoints;
//-- type declarations -------------------------------------------------------
typedef System::UnicodeString __fastcall (__closure *TOnGetMapCoords)();

class PASCALIMPLEMENTATION TDmRoutePoints : public System::Classes::TDataModule
{
	typedef System::Classes::TDataModule inherited;
	
__published:
	Data::Db::TDataSource* DsRoutePoints;
	Datasnap::Dbclient::TClientDataSet* CdsRoutePoints;
	Data::Db::TIntegerField* CdsRoutePointsId;
	Data::Db::TWideStringField* CdsRoutePointsName;
	Data::Db::TBooleanField* CdsRoutePointsViaPoint;
	Data::Db::TStringField* CdsRoutePointsLat;
	Data::Db::TStringField* CdsRoutePointsLon;
	Data::Db::TStringField* CdsRoutePointsAddress;
	Data::Db::TStringField* CdsRoutePointsCoords;
	Datasnap::Dbclient::TClientDataSet* CdsRoute;
	Data::Db::TDataSource* DsRoute;
	Data::Db::TStringField* CdsRouteTripName;
	Data::Db::TStringField* CdsRouteRoutePreference;
	Data::Db::TStringField* CdsRouteTransportationMode;
	Data::Db::TDateTimeField* CdsRouteDepartureDate;
	Data::Db::TWordField* CdsRoutePointsRoutePref;
	void __fastcall CdsRoutePointsAfterInsert(Data::Db::TDataSet* DataSet);
	void __fastcall CdsRoutePointsAfterScroll(Data::Db::TDataSet* DataSet);
	void __fastcall CdsRoutePointsBeforePost(Data::Db::TDataSet* DataSet);
	void __fastcall CdsRoutePointsBeforeDelete(Data::Db::TDataSet* DataSet);
	void __fastcall CdsRoutePointsAfterPost(Data::Db::TDataSet* DataSet);
	void __fastcall CdsRoutePointsBeforeInsert(Data::Db::TDataSet* DataSet);
	void __fastcall DataModuleCreate(System::TObject* Sender);
	void __fastcall CdsRoutePointsCalcFields(Data::Db::TDataSet* DataSet);
	void __fastcall CdsRoutePointsViaPointGetText(Data::Db::TField* Sender, System::UnicodeString &Text, bool DisplayText);
	void __fastcall CdsRoutePointsViaPointSetText(Data::Db::TField* Sender, const System::UnicodeString Text);
	void __fastcall CdsRoutePointsAfterDelete(Data::Db::TDataSet* DataSet);
	
private:
	System::UnicodeString FRoutePickList;
	System::UnicodeString FTransportPickList;
	Unittripobjects::TTripList* FTripList;
	int IdToInsert;
	System::Classes::TNotifyEvent FOnRouteUpdated;
	System::Classes::TNotifyEvent FOnRoutePointUpdated;
	TOnGetMapCoords FOnGetMapCoords;
	void __fastcall DoRouteUpdated();
	void __fastcall DoRoutePointUpdated();
	bool __fastcall CheckEmptyField(Data::Db::TField* Sender);
	void __fastcall SetAddressFromCoords(System::TObject* Sender, System::UnicodeString Coords);
	void __fastcall OnSetAnalyzePrefs(System::TObject* Sender);
	void __fastcall AddRoutePoint(Unitverysimplexml::TXmlVSNode* ARoutePoint, bool FromWpt);
	
public:
	int __fastcall ShowFieldExists(System::UnicodeString AField, System::Uitypes::TMsgDlgButtons AButtons = (System::Uitypes::TMsgDlgButtons() << System::Uitypes::TMsgDlgBtn::mbOK ));
	bool __fastcall NameExists(System::UnicodeString Name);
	void __fastcall LoadTrip(Unittripobjects::TTripList* ATripList);
	void __fastcall SaveTrip();
	void __fastcall MoveUp(Data::Db::TDataSet* Dataset);
	void __fastcall MoveDown(Data::Db::TDataSet* Dataset);
	void __fastcall SetDefaultName(int IdToAssign);
	void __fastcall SetBoolValue(System::UnicodeString ABoolValue, Data::Db::TField* ABoolField);
	System::UnicodeString __fastcall FromRegional(System::UnicodeString ANum);
	System::UnicodeString __fastcall ToRegional(System::UnicodeString ANum);
	System::UnicodeString __fastcall AddressFromCoords(const System::UnicodeString Lat, const System::UnicodeString Lon);
	void __fastcall LookUpAddress();
	void __fastcall CoordinatesApplied(System::TObject* Sender, System::UnicodeString Coords);
	void __fastcall ImportFromGPX(const System::UnicodeString GPXFile);
	void __fastcall ExportToGPX(const System::UnicodeString GPXFile);
	void __fastcall ImportFromCSV(const System::UnicodeString CSVFile);
	void __fastcall ExportToCSV(const System::UnicodeString CSVFile);
	__property System::Classes::TNotifyEvent OnRouteUpdated = {read=FOnRouteUpdated, write=FOnRouteUpdated};
	__property System::Classes::TNotifyEvent OnRoutePointUpdated = {read=FOnRoutePointUpdated, write=FOnRoutePointUpdated};
	__property TOnGetMapCoords OnGetMapCoords = {read=FOnGetMapCoords, write=FOnGetMapCoords};
	__property System::UnicodeString RoutePickList = {read=FRoutePickList};
	__property System::UnicodeString TransportPickList = {read=FTransportPickList};
public:
	/* TDataModule.Create */ inline __fastcall virtual TDmRoutePoints(System::Classes::TComponent* AOwner) : System::Classes::TDataModule(AOwner) { }
	/* TDataModule.CreateNew */ inline __fastcall virtual TDmRoutePoints(System::Classes::TComponent* AOwner, int Dummy) : System::Classes::TDataModule(AOwner, Dummy) { }
	/* TDataModule.Destroy */ inline __fastcall virtual ~TDmRoutePoints() { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TDmRoutePoints* DmRoutePoints;
}	/* namespace Udmroutepoints */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UDMROUTEPOINTS)
using namespace Udmroutepoints;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UDmRoutePointsHPP
