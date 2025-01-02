// CodeGear C++Builder
// Copyright (c) 1995, 2022 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'unitTripObjects.pas' rev: 35.00 (Windows)

#ifndef UnittripobjectsHPP
#define UnittripobjectsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
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
class DELPHICLASS TRawDataItem;
class DELPHICLASS TmPreserveTrackToRoute;
class DELPHICLASS TmParentTripId;
class DELPHICLASS TmDayNumber;
class DELPHICLASS TmTripDate;
class DELPHICLASS TmIsDisplayable;
class DELPHICLASS TmAvoidancesChanged;
class DELPHICLASS TmIsRoundTrip;
class DELPHICLASS TmParentTripName;
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

enum DECLSPEC_DENUM TZumoModel : unsigned char { XT, XT2, Unknown };

enum DECLSPEC_DENUM TRoutePreference : unsigned char { rmFasterTime, rmShorterDistance, rmDirect = 4, rmCurvyRoads = 7 };

enum DECLSPEC_DENUM TTransportMode : unsigned char { tmAutoMotive = 1, tmMotorcycling = 9, tmOffRoad };

enum DECLSPEC_DENUM TRoutePoint : unsigned char { rpVia, rpShaping };

typedef System::StaticArray<System::Classes::TIdentMapEntry, 2> Unittripobjects__1;

typedef System::StaticArray<System::Classes::TIdentMapEntry, 4> Unittripobjects__2;

typedef System::StaticArray<System::Classes::TIdentMapEntry, 3> Unittripobjects__3;

typedef System::StaticArray<System::Classes::TIdentMapEntry, 2> Unittripobjects__4;

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

typedef System::Generics::Collections::TList__1<TBaseItem*>* TItemList;

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
	unsigned Unknown1;
	int Lat;
	int Lon;
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
	__fastcall TmScPosn(float ALat, float ALon);
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__fastcall virtual ~TmScPosn();
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
class PASCALIMPLEMENTATION TRawDataItem : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	System::DynamicArray<System::Byte> FBytes;
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
class PASCALIMPLEMENTATION TmArrival : public TCardinalItem
{
	typedef TCardinalItem inherited;
	
private:
	virtual TEditMode __fastcall GetEditMode();
	virtual System::UnicodeString __fastcall GetValue();
	unsigned __fastcall GetAsUnixDateTime();
	void __fastcall SetAsUnixDateTime(unsigned AValue);
	
public:
	__fastcall TmArrival(System::TDateTime AValue);
	__property unsigned AsUnixDateTime = {read=GetAsUnixDateTime, write=SetAsUnixDateTime, nodefault};
	__classmethod unsigned __fastcall DateTimeAsCardinal(System::TDateTime ADateTime);
	__classmethod System::TDateTime __fastcall CardinalAsDateTime(unsigned ACardinal);
	__classmethod System::UnicodeString __fastcall CardinalAsDateTimeString(unsigned ACardinal);
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
	System::Generics::Collections::TList__1<TBaseItem*>* FItems;
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall TLocation(System::Byte ADataType);
	__fastcall virtual ~TLocation();
	void __fastcall Add(TBaseItem* ANitem);
	__property TLocationValue LocationValue = {read=Value};
	__property System::Generics::Collections::TList__1<TBaseItem*>* LocationItems = {read=FItems};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TmLocations : public TBaseDataItem
{
	typedef TBaseDataItem inherited;
	
private:
	unsigned FItemCount;
	System::Generics::Collections::TList__1<TBaseItem*>* FItemList;
	TLocation* FLocation;
	virtual void __fastcall Calculate(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall TmLocations();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__fastcall virtual ~TmLocations();
	void __fastcall AddLocatIon(TLocation* ALocation);
	TBaseItem* __fastcall Add(TBaseItem* ANItem);
	__property System::Generics::Collections::TList__1<TBaseItem*>* Locations = {read=FItemList};
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
	System::Byte Direction;
	System::StaticArray<System::Byte, 6> Unknown1;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TUdbDirValue
{
public:
	TSubClass SubClass;
	int Lat;
	int Lon;
	System::StaticArray<unsigned, 6> Unknown1;
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
	
protected:
	__fastcall TUdbDir(System::WideString AName, float ALat, float ALon, System::Byte APointType, System::Byte ADirection);
	
private:
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteTerminator(System::Classes::TMemoryStream* AStream);
	virtual unsigned __fastcall SubLength();
	System::UnicodeString __fastcall GetName();
	System::UnicodeString __fastcall GetMapCoords();
	
public:
	double __fastcall Lat();
	double __fastcall Lon();
	bool __fastcall IsTurn();
	__property System::UnicodeString DisplayName = {read=GetName};
	__property TUdbDirValue UdbDirValue = {read=FValue};
	__property System::UnicodeString MapCoords = {read=GetMapCoords};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TUdbDir() { }
	
};

#pragma pack(pop)

typedef System::Generics::Collections::TList__1<TUdbDir*>* TUdbDirList;

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
	System::Generics::Collections::TList__1<TUdbDir*>* FUdbDirList;
	unsigned FSubLength;
	unsigned __fastcall ComputeUnknown3Size();
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteTerminator(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall TmUdbDataHndl(unsigned AHandleId, TZumoModel AModel);
	__fastcall virtual ~TmUdbDataHndl();
	void __fastcall Add(TUdbDir* AnUdbDir);
	__property unsigned HandleId = {read=FUdbHandleId, nodefault};
	__property TUdbPrefValue PrefValue = {read=FUdbPrefValue};
	__property TUdbHandleValue UdbHandleValue = {read=FValue};
	__property System::Generics::Collections::TList__1<TUdbDir*>* Items = {read=FUdbDirList};
};

#pragma pack(pop)

typedef System::Generics::Collections::TList__1<TmUdbDataHndl*>* TUdbHandleList;

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
	System::Generics::Collections::TList__1<TmUdbDataHndl*>* FUdBList;
	virtual void __fastcall Calculate(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WritePrefix(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteValue(System::Classes::TMemoryStream* AStream);
	virtual void __fastcall WriteTerminator(System::Classes::TMemoryStream* AStream);
	
public:
	__fastcall TmAllRoutes();
	virtual void __fastcall InitFromStream(System::ShortString &AName, unsigned ALenValue, System::Byte ADataType, System::Classes::TStream* AStream);
	__fastcall virtual ~TmAllRoutes();
	void __fastcall AddUdbHandle(TmUdbDataHndl* AnUdbHandle);
	__property System::Generics::Collections::TList__1<TmUdbDataHndl*>* Items = {read=FUdBList};
	__property TmAllRoutesValue AllRoutesValue = {read=FValue};
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TTripList : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	THeader* FHeader;
	System::Generics::Collections::TList__1<TBaseItem*>* FItemList;
	void __fastcall ResetCalculation();
	void __fastcall Calculate(System::Classes::TMemoryStream* AStream);
	TZumoModel __fastcall GetZumoModel();
	
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
	int __fastcall GetRoutePointCount();
	TLocation* __fastcall GetRoutePoint(int RoutePointId);
	TOSMRoutePoint __fastcall OSMRoutePoint(int RoutePointId);
	TmArrival* __fastcall GetArrival();
	void __fastcall CreateOSMPoints(System::Classes::TStringList* const OutStringList);
	void __fastcall ForceRecalc(const TZumoModel AModel = (TZumoModel)(0x2), int ViaPointCount = 0x0);
	__property THeader* Header = {read=FHeader};
	__property System::Generics::Collections::TList__1<TBaseItem*>* ItemList = {read=FItemList};
	__property TZumoModel ZumoModel = {read=GetZumoModel, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define XT2Name L"z\u016bmo XT2"
#define XTName L"z\u016bmo XT"
static const System::Int8 dtByte = System::Int8(0x1);
static const System::Int8 dtCardinal = System::Int8(0x3);
static const System::Int8 dtSingle = System::Int8(0x4);
static const System::Int8 dtBoolean = System::Int8(0x7);
static const System::Int8 dtVersion = System::Int8(0x8);
static const System::Int8 dtPosn = System::Int8(0x8);
static const System::Int8 dtLctnPref = System::Int8(0xa);
static const System::Int8 dtUdbPref = System::Int8(0xa);
static const System::Int8 dtUdbHandle = System::Int8(0xb);
static const System::Int8 dtString = System::Int8(0xe);
static const System::Byte dtList = System::Byte(0x80);
extern DELPHI_PACKAGE char biInitiator;
extern DELPHI_PACKAGE Unittripobjects__1 BooleanMap;
extern DELPHI_PACKAGE Unittripobjects__2 RoutePreferenceMap;
extern DELPHI_PACKAGE Unittripobjects__3 TransportModeMap;
extern DELPHI_PACKAGE Unittripobjects__4 RoutePointMap;
#define UdbDirTurn L"Turn"
extern DELPHI_PACKAGE System::StaticArray<System::Byte, 4> TurnMagic;
extern DELPHI_PACKAGE System::StaticArray<int, 3> Unknown3Size;
extern DELPHI_PACKAGE System::StaticArray<unsigned, 3> CalculationMagic;
}	/* namespace Unittripobjects */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UNITTRIPOBJECTS)
using namespace Unittripobjects;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UnittripobjectsHPP
