// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'unitTripObjects.pas' rev: 36.00 (Windows)

#ifndef unitTripObjectsHPP
#define unitTripObjectsHPP

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
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <System.Generics.Collections.hpp>
#include <Winapi.Windows.hpp>
#include <System.Generics.Defaults.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Unittripobjects
{
//-- forward type declarations -----------------------------------------------
struct TOSMRoutePoint;
class DELPHICLASS TBaseItem;
class DELPHICLASS TBaseDataItem;
class DELPHICLASS TByteItem;
class DELPHICLASS TCardinalItem;
class DELPHICLASS TSingleItem;
class DELPHICLASS TBooleanItem;
struct TVersionValue;
class DELPHICLASS TmVersionNumber;
struct TPosnValue;
class DELPHICLASS TmScPosn;
class DELPHICLASS TStringItem;
class DELPHICLASS TUnixDate;
class DELPHICLASS TRawDataItem;
class DELPHICLASS TmPreserveTrackToRoute;
class DELPHICLASS TmParentTripId;
class DELPHICLASS TmDayNumber;
class DELPHICLASS TmTripDate;
class DELPHICLASS TmIsDisplayable;
class DELPHICLASS TmAvoidancesChanged;
class DELPHICLASS TmIsRoundTrip;
class DELPHICLASS TmParentTripName;
class DELPHICLASS TmExploreUuid;
class DELPHICLASS TmAvoidancesChangedTimeAtSave;
class DELPHICLASS TmOptimized;
class DELPHICLASS TmTotalTripTime;
class DELPHICLASS TmImported;
class DELPHICLASS TmRoutePreference;
class DELPHICLASS TmTransportationMode;
class DELPHICLASS TmTotalTripDistance;
class DELPHICLASS TmFileName;
class DELPHICLASS TmPartOfSplitRoute;
class DELPHICLASS TmTripName;
class DELPHICLASS TmAttr;
class DELPHICLASS TmIsDFSPoint;
class DELPHICLASS TmDuration;
class DELPHICLASS TmArrival;
class DELPHICLASS TmAddress;
class DELPHICLASS TmisTravelapseDestination;
class DELPHICLASS TmShapingRadius;
class DELPHICLASS TmName;
class DELPHICLASS TBaseRoutePreferences;
class DELPHICLASS TmRoutePreferences;
class DELPHICLASS TmRoutePreferencesAdventurousHillsAndCurves;
class DELPHICLASS TmRoutePreferencesAdventurousScenicRoads;
class DELPHICLASS TmRoutePreferencesAdventurousMode;
class DELPHICLASS TmRoutePreferencesAdventurousPopularPaths;
struct TTrackPoints;
struct TTrackHeader;
class DELPHICLASS TmTrackToRouteInfoMap;
struct THeaderValue;
class DELPHICLASS THeader;
struct TLocationValue;
class DELPHICLASS TLocation;
class DELPHICLASS TmLocations;
struct TSubClass;
struct TUdbDirValue;
class DELPHICLASS TUdbDir;
struct TUdbPrefValue;
struct TUdbHandleValue;
class DELPHICLASS TmUdbDataHndl;
struct TmAllRoutesValue;
class DELPHICLASS TmAllRoutes;
class DELPHICLASS TTripList;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TEditMode : unsigned char { emNone, emEdit, emPickList, emButton };

enum DECLSPEC_DENUM TZumoModel : unsigned char { XT, XT2, Tread2, Unknown };

enum DECLSPEC_DENUM TRoutePreference : unsigned char { rmFasterTime, rmShorterDistance, rmDirect = 4, rmCurvyRoads = 7, rmHills = 26, rmNoShape = 88, rmScenic = 190, rmPopular = 239 };

enum DECLSPEC_DENUM TTransportMode : unsigned char { tmAutoMotive = 1, tmMotorcycling = 9, tmOffRoad };

enum DECLSPEC_DENUM TRoutePoint : unsigned char { rpVia, rpShaping, rpShapingXT2 };

enum DECLSPEC_DENUM TUdbDirStatus : unsigned char { udsUnchecked, udsRoutePointNOK, udsRoadNOK, UdsRoadOKCoordsNOK, udsCoordsNOK };

enum DECLSPEC_DENUM TTripOption : unsigned char { ttCalc, ttNoCal, ttTripTrack, ttTripTrackLoc };

typedef System::StaticArray<System::Classes::TIdentMapEntry, 2> Unittripobjects__1;

typedef System::StaticArray<System::Classes::TIdentMapEntry, 8> Unittripobjects__2;

typedef System::StaticArray<System::Classes::TIdentMapEntry, 3> Unittripobjects__3;

typedef System::StaticArray<System::Classes::TIdentMapEntry, 3> Unittripobjects__4;

struct DECLSPEC_DRECORD TOSMRoutePoint
{
public:
	System::UnicodeString Name;
	System::UnicodeString MapCoords;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TBaseItem : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	char FInitiator;
	unsigned FStartPos;
	unsigned FEndPos;
	bool FCalculated;
	virtual void __fastcall Calculate(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteTerminator(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall Write(System::Classes::TMemoryStream* AStream);
	virtual unsigned __fastcall SubLength();
	virtual System::UnicodeString __fastcall GetPickList();
	virtual TEditMode __fastcall GetEditMode();
	
public:
	__fastcall virtual TBaseItem(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType);
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__property unsigned SelStart = {read=FStartPos, nodefault};
	__property unsigned SelEnd = {read=FEndPos, nodefault};
	__property TEditMode EditMode = {read=GetEditMode, nodefault};
	__property System::UnicodeString PickList = {read=GetPickList};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TBaseItem() { }
	
};

#pragma pack(pop)

typedef System::Generics::Collections::TList__1<TBaseItem*> TItemList;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBaseDataItem : public TBaseItem
{
	typedef TBaseItem inherited;
	
private:
	unsigned FLenName;
	System::ShortString FName;
	unsigned FLenValue;
	System::Byte FDataType;
	unsigned __fastcall NameLength();
	unsigned __fastcall ValueLength();
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual System::UnicodeString __fastcall GetName();
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(System::UnicodeString NewValue);
	virtual unsigned __fastcall GetLenValue();
	int __fastcall GetOffSetLenValue();
	int __fastcall GetOffSetDataType();
	int __fastcall GetOffSetValue();
	virtual System::UnicodeString __fastcall GetMapCoords();
	virtual void __fastcall SetMapCoords(System::UnicodeString ACoords);
	
public:
	__fastcall virtual TBaseDataItem(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType);
	__fastcall virtual ~TBaseDataItem();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__property System::UnicodeString DisplayName = {read=GetName};
	__property System::UnicodeString AsString = {read=GetValue, write=SetValue};
	__property unsigned LenName = {read=FLenName, nodefault};
	__property System::ShortString Name = {read=FName};
	__property unsigned LenValue = {read=GetLenValue, nodefault};
	__property System::Byte DataType = {read=FDataType, nodefault};
	__property int OffsetLenValue = {read=GetOffSetLenValue, nodefault};
	__property int OffsetDataType = {read=GetOffSetDataType, nodefault};
	__property int OffsetValue = {read=GetOffSetValue, nodefault};
	__property System::UnicodeString MapCoords = {read=GetMapCoords, write=SetMapCoords};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TByteItem : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	System::Byte FValue;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual System::UnicodeString __fastcall GetValue();
	virtual TEditMode __fastcall GetEditMode();
	virtual void __fastcall SetValue(System::UnicodeString NewValue);
	
public:
	__fastcall TByteItem(System::ShortString &AName, System::Byte AValue);
	__fastcall virtual ~TByteItem();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__property System::Byte AsByte = {read=FValue, write=FValue, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TCardinalItem : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	unsigned FValue;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual System::UnicodeString __fastcall GetValue();
	virtual TEditMode __fastcall GetEditMode();
	virtual void __fastcall SetValue(System::UnicodeString NewValue);
	
public:
	__fastcall TCardinalItem(System::ShortString &AName, unsigned AValue);
	__fastcall virtual ~TCardinalItem();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__property unsigned AsCardinal = {read=FValue, write=FValue, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TSingleItem : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	float FValue;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual System::UnicodeString __fastcall GetValue();
	virtual TEditMode __fastcall GetEditMode();
	virtual void __fastcall SetValue(System::UnicodeString NewValue);
	
public:
	__fastcall TSingleItem(System::ShortString &AName, float AValue);
	__fastcall virtual ~TSingleItem();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__property float AsSingle = {read=FValue, write=FValue};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBooleanItem : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	bool Value;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual System::UnicodeString __fastcall GetValue();
	virtual System::UnicodeString __fastcall GetPickList();
	virtual TEditMode __fastcall GetEditMode();
	virtual void __fastcall SetValue(System::UnicodeString NewValue);
	
public:
	__fastcall TBooleanItem(System::ShortString &AName, bool AValue);
	__fastcall virtual ~TBooleanItem();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__property bool AsBoolean = {read=Value, write=Value, nodefault};
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TVersionValue
{
public:
	unsigned Major;
	unsigned Minor;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TmVersionNumber : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	TVersionValue FValue;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual System::UnicodeString __fastcall GetValue();
	
public:
	__fastcall TmVersionNumber(unsigned AMajor, unsigned AMinor);
	__fastcall virtual ~TmVersionNumber();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TPosnValue
{
	
public:
	unsigned ScnSize;
	union
	{
		struct 
		{
			System::StaticArray<unsigned, 2> Unknown1_16;
			int Lat_16;
			int Lon_16;
		};
		struct 
		{
			unsigned Unknown1;
			int Lat;
			int Lon;
		};
		
	};
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TmScPosn : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	TPosnValue FValue;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual System::UnicodeString __fastcall GetValue();
	virtual TEditMode __fastcall GetEditMode();
	virtual System::UnicodeString __fastcall GetMapCoords();
	virtual void __fastcall SetMapCoords(System::UnicodeString ACoords);
	
public:
	__fastcall TmScPosn(double ALat, double ALon, unsigned AUnknown1, unsigned ASize);
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__fastcall virtual ~TmScPosn();
	__property unsigned Unknown1 = {read=FValue.Unknown1, nodefault};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TStringItem : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	System::Word FByteSize;
	System::UCS4String FValue;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual System::UnicodeString __fastcall GetValue();
	virtual TEditMode __fastcall GetEditMode();
	virtual void __fastcall SetValue(System::UnicodeString NewValue);
	
protected:
	__fastcall TStringItem(System::ShortString &AName, System::Word Chars)/* overload */;
	
public:
	__fastcall TStringItem(System::ShortString &AName, System::WideString AValue)/* overload */;
	__fastcall TStringItem(System::ShortString &AName, System::UCS4String AValue)/* overload */;
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__fastcall virtual ~TStringItem();
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TUnixDate : public TCardinalItem
{
	typedef TCardinalItem inherited;
	
private:
	virtual TEditMode __fastcall GetEditMode();
	virtual System::UnicodeString __fastcall GetValue();
	unsigned __fastcall GetAsUnixDateTime();
	void __fastcall SetAsUnixDateTime(unsigned AValue);
	
public:
	__fastcall TUnixDate(System::ShortString &AName, System::TDateTime AValue);
	__property unsigned AsUnixDateTime = {read=GetAsUnixDateTime, write=SetAsUnixDateTime, nodefault};
	__classmethod unsigned __fastcall DateTimeAsCardinal(System::TDateTime ADateTime);
	__classmethod System::TDateTime __fastcall CardinalAsDateTime(unsigned ACardinal);
	__classmethod System::UnicodeString __fastcall CardinalAsDateTimeString(unsigned ACardinal);
public:
	/* TCardinalItem.Destroy */ inline __fastcall virtual ~TUnixDate() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TRawDataItem : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	System::Sysutils::TBytes FBytes;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	
public:
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__fastcall virtual ~TRawDataItem();
public:
	/* TBaseDataItem.Create */ inline __fastcall virtual TRawDataItem(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType) : TBaseDataItem(AName, ALenValue, ADataType) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmPreserveTrackToRoute : public TBooleanItem
{
	typedef TBooleanItem inherited;
	
public:
	__fastcall TmPreserveTrackToRoute(bool AValue);
public:
	/* TBooleanItem.Destroy */ inline __fastcall virtual ~TmPreserveTrackToRoute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmParentTripId : public TCardinalItem
{
	typedef TCardinalItem inherited;
	
public:
	__fastcall TmParentTripId(unsigned AValue);
public:
	/* TCardinalItem.Destroy */ inline __fastcall virtual ~TmParentTripId() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmDayNumber : public TByteItem
{
	typedef TByteItem inherited;
	
public:
	__fastcall TmDayNumber(System::Byte AValue);
public:
	/* TByteItem.Destroy */ inline __fastcall virtual ~TmDayNumber() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmTripDate : public TCardinalItem
{
	typedef TCardinalItem inherited;
	
public:
	__fastcall TmTripDate(int AValue);
public:
	/* TCardinalItem.Destroy */ inline __fastcall virtual ~TmTripDate() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmIsDisplayable : public TBooleanItem
{
	typedef TBooleanItem inherited;
	
public:
	__fastcall TmIsDisplayable(bool AValue);
public:
	/* TBooleanItem.Destroy */ inline __fastcall virtual ~TmIsDisplayable() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmAvoidancesChanged : public TBooleanItem
{
	typedef TBooleanItem inherited;
	
public:
	__fastcall TmAvoidancesChanged(bool AValue);
public:
	/* TBooleanItem.Destroy */ inline __fastcall virtual ~TmAvoidancesChanged() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmIsRoundTrip : public TBooleanItem
{
	typedef TBooleanItem inherited;
	
public:
	__fastcall TmIsRoundTrip(bool AValue);
public:
	/* TBooleanItem.Destroy */ inline __fastcall virtual ~TmIsRoundTrip() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmParentTripName : public TStringItem
{
	typedef TStringItem inherited;
	
public:
	__fastcall TmParentTripName(System::UnicodeString AValue);
public:
	/* TStringItem.Destroy */ inline __fastcall virtual ~TmParentTripName() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmExploreUuid : public TStringItem
{
	typedef TStringItem inherited;
	
public:
	__fastcall TmExploreUuid(System::UnicodeString AValue);
public:
	/* TStringItem.Destroy */ inline __fastcall virtual ~TmExploreUuid() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmAvoidancesChangedTimeAtSave : public TUnixDate
{
	typedef TUnixDate inherited;
	
public:
	__fastcall TmAvoidancesChangedTimeAtSave(System::TDateTime AValue)/* overload */;
	__fastcall TmAvoidancesChangedTimeAtSave(unsigned AValue)/* overload */;
public:
	/* TCardinalItem.Destroy */ inline __fastcall virtual ~TmAvoidancesChangedTimeAtSave() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmOptimized : public TBooleanItem
{
	typedef TBooleanItem inherited;
	
public:
	__fastcall TmOptimized(bool AValue);
public:
	/* TBooleanItem.Destroy */ inline __fastcall virtual ~TmOptimized() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmTotalTripTime : public TCardinalItem
{
	typedef TCardinalItem inherited;
	
private:
	virtual System::UnicodeString __fastcall GetValue();
	
public:
	__fastcall TmTotalTripTime(unsigned AValue);
public:
	/* TCardinalItem.Destroy */ inline __fastcall virtual ~TmTotalTripTime() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmImported : public TBooleanItem
{
	typedef TBooleanItem inherited;
	
private:
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall TmImported(bool AValue);
public:
	/* TBooleanItem.Destroy */ inline __fastcall virtual ~TmImported() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmRoutePreference : public TByteItem
{
	typedef TByteItem inherited;
	
private:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(System::UnicodeString AValue);
	virtual TEditMode __fastcall GetEditMode();
	virtual System::UnicodeString __fastcall GetPickList();
	
public:
	__fastcall TmRoutePreference(TRoutePreference AValue);
	__classmethod TRoutePreference __fastcall RoutePreference(System::UnicodeString AValue);
public:
	/* TByteItem.Destroy */ inline __fastcall virtual ~TmRoutePreference() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmTransportationMode : public TByteItem
{
	typedef TByteItem inherited;
	
private:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(System::UnicodeString AValue);
	virtual TEditMode __fastcall GetEditMode();
	virtual System::UnicodeString __fastcall GetPickList();
	
public:
	__fastcall TmTransportationMode(TTransportMode AValue);
	__classmethod TTransportMode __fastcall TransPortMethod(System::UnicodeString AValue);
public:
	/* TByteItem.Destroy */ inline __fastcall virtual ~TmTransportationMode() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmTotalTripDistance : public TSingleItem
{
	typedef TSingleItem inherited;
	
private:
	virtual System::UnicodeString __fastcall GetValue();
	
public:
	__fastcall TmTotalTripDistance(float AValue);
public:
	/* TSingleItem.Destroy */ inline __fastcall virtual ~TmTotalTripDistance() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmFileName : public TStringItem
{
	typedef TStringItem inherited;
	
public:
	__fastcall TmFileName(System::UnicodeString AValue);
public:
	/* TStringItem.Destroy */ inline __fastcall virtual ~TmFileName() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmPartOfSplitRoute : public TBooleanItem
{
	typedef TBooleanItem inherited;
	
public:
	__fastcall TmPartOfSplitRoute(bool AValue);
public:
	/* TBooleanItem.Destroy */ inline __fastcall virtual ~TmPartOfSplitRoute() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmTripName : public TStringItem
{
	typedef TStringItem inherited;
	
public:
	__fastcall TmTripName(System::UnicodeString AValue);
public:
	/* TStringItem.Destroy */ inline __fastcall virtual ~TmTripName() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmAttr : public TCardinalItem
{
	typedef TCardinalItem inherited;
	
private:
	virtual System::UnicodeString __fastcall GetValue();
	virtual void __fastcall SetValue(System::UnicodeString AValue);
	virtual TEditMode __fastcall GetEditMode();
	virtual System::UnicodeString __fastcall GetPickList();
	TRoutePoint __fastcall GetRoutePoint();
	
public:
	__fastcall TmAttr(TRoutePoint ARoutePoint);
	__classmethod TRoutePoint __fastcall RoutePoint(System::UnicodeString AValue);
	__property TRoutePoint AsRoutePoint = {read=GetRoutePoint, nodefault};
public:
	/* TCardinalItem.Destroy */ inline __fastcall virtual ~TmAttr() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmIsDFSPoint : public TBooleanItem
{
	typedef TBooleanItem inherited;
	
public:
	__fastcall TmIsDFSPoint(bool AValue);
public:
	/* TBooleanItem.Destroy */ inline __fastcall virtual ~TmIsDFSPoint() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmDuration : public TCardinalItem
{
	typedef TCardinalItem inherited;
	
public:
	__fastcall TmDuration(int AValue);
public:
	/* TCardinalItem.Destroy */ inline __fastcall virtual ~TmDuration() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmArrival : public TUnixDate
{
	typedef TUnixDate inherited;
	
public:
	__fastcall TmArrival(System::TDateTime AValue);
public:
	/* TCardinalItem.Destroy */ inline __fastcall virtual ~TmArrival() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmAddress : public TStringItem
{
	typedef TStringItem inherited;
	
public:
	__fastcall TmAddress(System::UnicodeString AValue);
public:
	/* TStringItem.Destroy */ inline __fastcall virtual ~TmAddress() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmisTravelapseDestination : public TBooleanItem
{
	typedef TBooleanItem inherited;
	
public:
	__fastcall TmisTravelapseDestination(bool AValue);
public:
	/* TBooleanItem.Destroy */ inline __fastcall virtual ~TmisTravelapseDestination() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmShapingRadius : public TCardinalItem
{
	typedef TCardinalItem inherited;
	
private:
	virtual System::UnicodeString __fastcall GetValue();
	virtual TEditMode __fastcall GetEditMode();
	
public:
	__fastcall TmShapingRadius(unsigned AValue);
public:
	/* TCardinalItem.Destroy */ inline __fastcall virtual ~TmShapingRadius() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmName : public TStringItem
{
	typedef TStringItem inherited;
	
public:
	__fastcall TmName(System::UnicodeString AValue);
public:
	/* TStringItem.Destroy */ inline __fastcall virtual ~TmName() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBaseRoutePreferences : public TRawDataItem
{
	typedef TRawDataItem inherited;
	
private:
	virtual bool __fastcall StandardPrefs();
	unsigned __fastcall GetCount();
	
public:
	virtual System::UnicodeString __fastcall GetValue();
	System::UnicodeString __fastcall GetRoutePrefs();
	__property unsigned Count = {read=GetCount, nodefault};
public:
	/* TRawDataItem.Destroy */ inline __fastcall virtual ~TBaseRoutePreferences() { }
	
public:
	/* TBaseDataItem.Create */ inline __fastcall virtual TBaseRoutePreferences(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType) : TRawDataItem(AName, ALenValue, ADataType) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmRoutePreferences : public TBaseRoutePreferences
{
	typedef TBaseRoutePreferences inherited;
	
private:
	virtual bool __fastcall StandardPrefs();
	
public:
	__fastcall virtual TmRoutePreferences(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType);
public:
	/* TRawDataItem.Destroy */ inline __fastcall virtual ~TmRoutePreferences() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmRoutePreferencesAdventurousHillsAndCurves : public TBaseRoutePreferences
{
	typedef TBaseRoutePreferences inherited;
	
public:
	__fastcall virtual TmRoutePreferencesAdventurousHillsAndCurves(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType);
public:
	/* TRawDataItem.Destroy */ inline __fastcall virtual ~TmRoutePreferencesAdventurousHillsAndCurves() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmRoutePreferencesAdventurousScenicRoads : public TBaseRoutePreferences
{
	typedef TBaseRoutePreferences inherited;
	
public:
	__fastcall virtual TmRoutePreferencesAdventurousScenicRoads(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType);
public:
	/* TRawDataItem.Destroy */ inline __fastcall virtual ~TmRoutePreferencesAdventurousScenicRoads() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmRoutePreferencesAdventurousMode : public TBaseRoutePreferences
{
	typedef TBaseRoutePreferences inherited;
	
public:
	__fastcall virtual TmRoutePreferencesAdventurousMode(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType);
public:
	/* TRawDataItem.Destroy */ inline __fastcall virtual ~TmRoutePreferencesAdventurousMode() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmRoutePreferencesAdventurousPopularPaths : public TBaseRoutePreferences
{
	typedef TBaseRoutePreferences inherited;
	
public:
	__fastcall virtual TmRoutePreferencesAdventurousPopularPaths(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType);
public:
	/* TRawDataItem.Destroy */ inline __fastcall virtual ~TmRoutePreferencesAdventurousPopularPaths() { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TTrackPoints
{
public:
	char Inititiator;
	unsigned KeyLen;
	System::StaticArray<char, 12> KeyName;
	unsigned ValueLen;
	System::Byte DataType;
	unsigned TrkPntCnt;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TTrackHeader
{
public:
	unsigned TrkCnt;
	System::Byte SubItems;
	System::StaticArray<unsigned, 2> Unknown1;
	unsigned SubLength;
	System::Byte DataType;
	unsigned ItemCount;
	TTrackPoints TrackPoints;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TmTrackToRouteInfoMap : public TRawDataItem
{
	typedef TRawDataItem inherited;
	
public:
	TTrackHeader FTrackHeader;
	__fastcall virtual TmTrackToRouteInfoMap(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType);
	void __fastcall InitFromGpxxRpt(System::TObject* RtePts);
public:
	/* TRawDataItem.Destroy */ inline __fastcall virtual ~TmTrackToRouteInfoMap() { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD THeaderValue
{
public:
	System::StaticArray<char, 4> Id;
	unsigned SubLength;
	System::Byte HeaderLength;
	unsigned TotalItems;
	void __fastcall SwapCardinals();
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION THeader : public TBaseItem
{
	typedef TBaseItem inherited;
	
private:
	THeaderValue FValue;
	void __fastcall UpdateFromTripList(unsigned ItemCount, unsigned ASubLength);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall THeader();
	__fastcall virtual ~THeader();
	void __fastcall Clear();
	__property THeaderValue HeaderValue = {read=FValue};
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TLocationValue
{
public:
	System::StaticArray<char, 4> Id;
	unsigned Size;
	System::Byte DataType;
	System::Word Unknown1;
	System::Word Count;
	void __fastcall SwapCardinals();
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TLocation : public TBaseItem
{
	typedef TBaseItem inherited;
	
private:
	TLocationValue Value;
	TItemList* FItems;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall TLocation(System::Byte ADataType);
	__fastcall virtual ~TLocation();
	void __fastcall Add(TBaseItem* ANitem);
	TmAttr* __fastcall LocationTmAttr();
	TmName* __fastcall LocationTmName();
	TmAddress* __fastcall LocationTmAddress();
	TmScPosn* __fastcall LocationTmScPosn();
	__property TLocationValue LocationValue = {read=Value};
	__property TItemList* LocationItems = {read=FItems};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmLocations : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	unsigned FItemCount;
	TItemList* FItemList;
	TLocation* FLocation;
	virtual void __fastcall Calculate(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall TmLocations();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__fastcall virtual ~TmLocations();
	void __fastcall Clear();
	void __fastcall AddLocatIon(TLocation* ALocation);
	TBaseItem* __fastcall Add(TBaseItem* ANItem);
	void __fastcall GetRoutePoints(int ViaPoint, System::Generics::Collections::TList__1<TLocation*>* RoutePointList);
	__property TItemList* Locations = {read=FItemList};
	__property unsigned LocationCount = {read=FItemCount, nodefault};
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD TSubClass
{
public:
	unsigned MapSegment;
	unsigned RoadId;
	System::Byte PointType;
	void __fastcall Init(const System::UnicodeString GPXSubClass);
	
public:
	union
	{
		struct 
		{
			System::Byte Direction2;
			System::Word Time;
			System::StaticArray<System::Word, 2> Unknown2;
		};
		struct 
		{
			System::Byte B4Lat;
			System::Byte B4Lon;
			System::Byte Reserved;
			System::Word B2_3Lat;
			System::Word B2_3Lon;
		};
		struct 
		{
			System::StaticArray<System::Byte, 7> ComprLatLon;
		};
		struct 
		{
			System::Byte Direction;
			System::StaticArray<System::Byte, 6> Unknown1;
		};
		
	};
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TUdbDirValue
{
public:
	TSubClass SubClass;
	int Lat;
	int Lon;
	unsigned Unknown1;
	System::Byte Time;
	System::Byte Border;
	System::StaticArray<System::Word, 9> Unknown2;
	System::StaticArray<unsigned, 121> Name;
	void __fastcall SwapCardinals();
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TUdbDir : public TBaseItem
{
	typedef TBaseItem inherited;
	
private:
	TUdbDirValue FValue;
	TUdbDirStatus FUdbDirStatus;
	
protected:
	__fastcall TUdbDir(System::WideString AName, double ALat, double ALon, System::Byte APointType)/* overload */;
	__fastcall TUdbDir(TLocation* ALocation)/* overload */;
	__fastcall TUdbDir(System::UnicodeString GPXSubClass, System::UnicodeString RoadClass, double Lat, double Lon, double Dist)/* overload */;
	
private:
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteTerminator(System::Classes::TMemoryStream* AStream);
	virtual unsigned __fastcall SubLength();
	System::UnicodeString __fastcall GetName();
	System::UnicodeString __fastcall GetMapCoords();
	System::UnicodeString __fastcall GetMapSegRoad();
	System::UnicodeString __fastcall GetMapSegRoadExclBit();
	System::UnicodeString __fastcall GetPointType();
	System::UnicodeString __fastcall GetDirection();
	void __fastcall FillCompressedLatLon();
	System::UnicodeString __fastcall GetComprLatLon();
	
public:
	double __fastcall Lat();
	double __fastcall Lon();
	bool __fastcall IsTurn();
	__property System::UnicodeString DisplayName = {read=GetName};
	__property TUdbDirValue UdbDirValue = {read=FValue};
	__property System::UnicodeString MapCoords = {read=GetMapCoords};
	__property System::UnicodeString MapSegRoad = {read=GetMapSegRoad};
	__property System::UnicodeString MapSegRoadExclBit = {read=GetMapSegRoadExclBit};
	__property System::UnicodeString PointType = {read=GetPointType};
	__property System::UnicodeString Direction = {read=GetDirection};
	__property System::UnicodeString ComprLatLon = {read=GetComprLatLon};
	__property TUdbDirStatus Status = {read=FUdbDirStatus, write=FUdbDirStatus, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TUdbDir() { }
	
};

#pragma pack(pop)

typedef System::Generics::Collections::TList__1<TUdbDir*> TUdbDirList;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TUdbPrefValue
{
public:
	unsigned Unknown1;
	unsigned PrefixSize;
	System::Byte DataType;
	unsigned PrefId;
	void __fastcall SwapCardinals();
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TUdbHandleValue
{
	
private:
	typedef System::DynamicArray<System::Byte> _TUdbHandleValue__1;
	
	
public:
	unsigned UdbHandleSize;
	unsigned CalcStatus;
	System::StaticArray<System::Byte, 150> Unknown2;
	System::Word UDbDirCount;
	_TUdbHandleValue__1 Unknown3;
	void __fastcall SwapCardinals();
	void __fastcall AllocUnknown3(TZumoModel AModel = (TZumoModel)(0x0))/* overload */;
	void __fastcall AllocUnknown3(unsigned ASize)/* overload */;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TmUdbDataHndl : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	unsigned FUdbHandleId;
	TUdbPrefValue FUdbPrefValue;
	TUdbHandleValue FValue;
	TUdbDirList* FUdbDirList;
	unsigned FSubLength;
	unsigned __fastcall ComputeUnknown3Size();
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteTerminator(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall TmUdbDataHndl(unsigned AHandleId, TZumoModel AModel, bool ForceRecalc);
	__fastcall virtual ~TmUdbDataHndl();
	void __fastcall Add(TUdbDir* AnUdbDir);
	__property unsigned HandleId = {read=FUdbHandleId, nodefault};
	__property TUdbPrefValue PrefValue = {read=FUdbPrefValue};
	__property TUdbHandleValue UdbHandleValue = {read=FValue};
	__property TUdbDirList* Items = {read=FUdbDirList};
};

#pragma pack(pop)

typedef System::Generics::Collections::TList__1<TmUdbDataHndl*> TUdbHandleList;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TmAllRoutesValue
{
public:
	unsigned UdbHandleCount;
	void __fastcall SwapCardinals();
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TmAllRoutes : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	TmAllRoutesValue FValue;
	TUdbHandleList* FUdBList;
	virtual void __fastcall Calculate(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteTerminator(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall TmAllRoutes();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__fastcall virtual ~TmAllRoutes();
	void __fastcall AddUdbHandle(TmUdbDataHndl* AnUdbHandle);
	__property TUdbHandleList* Items = {read=FUdBList};
	__property TmAllRoutesValue AllRoutesValue = {read=FValue};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TTripList : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	THeader* FHeader;
	TItemList* FItemList;
	void __fastcall ResetCalculation();
	void __fastcall Calculate(System::Classes::TMemoryStream* AStream);
	TmUdbDataHndl* __fastcall FirstUdbDataHndle();
	TZumoModel __fastcall GetZumoModel();
	TZumoModel __fastcall GetCalcModel(TZumoModel AModel);
	TZumoModel __fastcall GetIsCalculatedModel();
	TBaseItem* __fastcall InitAllRoutes();
	void __fastcall SetPreserveTrackToRoute(System::TObject* const RtePts);
	void __fastcall AddLocation_XT(TmLocations* Locations, System::TObject* ProcessOptions, TRoutePoint RoutePoint, double Lat, double Lon, System::TDateTime DepartureDate, System::UnicodeString Name, System::UnicodeString Address);
	void __fastcall AddLocation_XT2(TmLocations* Locations, System::TObject* ProcessOptions, TRoutePoint RoutePoint, double Lat, double Lon, System::TDateTime DepartureDate, System::UnicodeString Name, System::UnicodeString Address);
	void __fastcall AddLocation_Tread2(TmLocations* Locations, System::TObject* ProcessOptions, TRoutePoint RoutePoint, double Lat, double Lon, System::TDateTime DepartureDate, System::UnicodeString Name, System::UnicodeString Address);
	void __fastcall CreateTemplate_XT(const System::UnicodeString TripName, const System::UnicodeString CalculationMode, const System::UnicodeString TransportMode);
	void __fastcall CreateTemplate_XT2(const System::UnicodeString TripName, const System::UnicodeString CalculationMode, const System::UnicodeString TransportMode);
	void __fastcall CreateTemplate_Tread2(const System::UnicodeString TripName, const System::UnicodeString CalculationMode, const System::UnicodeString TransportMode);
	
public:
	__fastcall TTripList();
	__fastcall virtual ~TTripList();
	void __fastcall Clear();
	void __fastcall AddHeader(THeader* AHeader);
	TBaseItem* __fastcall Add(TBaseItem* ANItem);
	void __fastcall SaveToStream(System::Classes::TMemoryStream* AStream);
	void __fastcall SaveToFile(System::UnicodeString AFile);
	bool __fastcall LoadFromStream(System::Classes::TBufferedFileStream* AStream);
	bool __fastcall LoadFromFile(System::UnicodeString AFile);
	System::UnicodeString __fastcall GetValue(System::ShortString &AKey);
	TBaseItem* __fastcall GetItem(System::ShortString &AKey);
	void __fastcall SetItem(System::ShortString &AKey, TBaseItem* ABaseItem);
	int __fastcall GetRoutePointCount();
	TLocation* __fastcall GetRoutePoint(int RoutePointId);
	TOSMRoutePoint __fastcall OSMRoutePoint(int RoutePointId);
	TmArrival* __fastcall GetArrival();
	void __fastcall CreateOSMPoints(System::Classes::TStringList* const OutStringList, const System::UnicodeString HTMLColor);
	void __fastcall SetRoutePrefs_XT2_Tread2(int ViaCount);
	void __fastcall AddLocation(TmLocations* Locations, System::TObject* ProcessOptions, TRoutePoint RoutePoint, double Lat, double Lon, System::TDateTime DepartureDate, System::UnicodeString Name, System::UnicodeString Address);
	void __fastcall ForceRecalc(const TZumoModel AModel = (TZumoModel)(0x3), int ViaPointCount = 0x0);
	unsigned __fastcall TripTrack(const TZumoModel AModel = (TZumoModel)(0x3), System::TObject* RtePts = (System::TObject*)(0x0), System::Classes::TStringList* SubClasses = (System::Classes::TStringList*)(0x0));
	unsigned __fastcall SaveCalculated(const TZumoModel AModel = (TZumoModel)(0x3), System::TObject* RtePts = (System::TObject*)(0x0));
	void __fastcall CreateTemplate(const TZumoModel AModel, const System::UnicodeString TripName, const System::UnicodeString CalculationMode = System::UnicodeString(), const System::UnicodeString TransportMode = System::UnicodeString());
	void __fastcall SaveAsGPX(const System::UnicodeString GPXFile);
	__property THeader* Header = {read=FHeader};
	__property TItemList* ItemList = {read=FItemList};
	__property TZumoModel ZumoModel = {read=GetZumoModel, nodefault};
	__property TZumoModel CalculatedModel = {read=GetIsCalculatedModel, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define XT_Name L"z\u016bmo XT"
#define XT2_Name L"z\u016bmo XT2"
#define XT2_VehicleProfileGuid L"dbcac367-42c5-4d01-17aa-ecfe025f2d1c"
#define XT2_VehicleProfileHash L"135656608"
static _DELPHI_CONST System::WideChar XT2_VehicleId = (System::WideChar)(0x31);
static _DELPHI_CONST System::WideChar XT2_VehicleProfileTruckType = (System::WideChar)(0x37);
#define XT2_AvoidancesChangedTimeAtSave L""
#define XT2_VehicleProfileName L"z\u016bmo Motorcycle"
#define Tread2_Name L"Tread 2"
#define Tread2_VehicleProfileName L"Tread Profile"
#define Tread2_VehicleProfileGuid L"c21c922c-553f-4783-85f8-c0a13f52d960"
#define Tread2_VehicleProfileHash L"61578528"
static _DELPHI_CONST System::Int8 Tread2_TmScPosnSize = System::Int8(0x10);
static _DELPHI_CONST System::Int8 dtByte = System::Int8(0x1);
static _DELPHI_CONST System::Int8 dtCardinal = System::Int8(0x3);
static _DELPHI_CONST System::Int8 dtSingle = System::Int8(0x4);
static _DELPHI_CONST System::Int8 dtBoolean = System::Int8(0x7);
static _DELPHI_CONST System::Int8 dtVersion = System::Int8(0x8);
static _DELPHI_CONST System::Int8 dtPosn = System::Int8(0x8);
static _DELPHI_CONST System::Int8 dtLctnPref = System::Int8(0xa);
static _DELPHI_CONST System::Int8 dtUdbPref = System::Int8(0xa);
static _DELPHI_CONST System::Int8 dtUdbHandle = System::Int8(0xb);
static _DELPHI_CONST System::Int8 dtString = System::Int8(0xe);
static _DELPHI_CONST System::Byte dtList = System::Byte(0x80);
extern DELPHI_PACKAGE char biInitiator;
extern DELPHI_PACKAGE Unittripobjects__1 BooleanMap;
extern DELPHI_PACKAGE Unittripobjects__2 RoutePreferenceMap;
extern DELPHI_PACKAGE Unittripobjects__3 TransportModeMap;
extern DELPHI_PACKAGE Unittripobjects__4 RoutePointMap;
#define UdbDirTurn L"Turn"
extern DELPHI_PACKAGE System::StaticArray<System::Byte, 4> TurnMagic;
extern DELPHI_PACKAGE System::StaticArray<int, 4> Unknown3Size;
extern DELPHI_PACKAGE System::StaticArray<unsigned, 4> CalculationMagic;
extern DELPHI_PACKAGE System::StaticArray<unsigned, 4> ShapeBitmap;
}	/* namespace Unittripobjects */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITTRIPOBJECTS)
using namespace Unittripobjects;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// unitTripObjectsHPP
