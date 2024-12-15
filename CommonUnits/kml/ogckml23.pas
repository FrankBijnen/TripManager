
{***************************************************}
{                                                   }
{                 XML Data Binding                  }
{                                                   }
{         Generated on: 4-2-2020 20:20:33           }
{       Generated from: C:\kml\2.3.0\ogckml23.xsd   }
{   Settings stored in: C:\kml\2.3.0\ogckml23.xdb   }
{                                                   }
{***************************************************}

unit ogckml23;

interface

uses Xml.xmldom, Xml.XMLDoc, Xml.XMLIntf;

type

{ Forward Decls }

  IXMLAbstractObjectType = interface;
  IXMLVec2Type = interface;
  IXMLSnippetType = interface;
  IXMLAbstractFeatureType = interface;
  IXMLAbstractFeatureTypeList = interface;
  IXMLAtomPersonConstruct_atom = interface;
  IXMLLink_atom = interface;
  IXMLAddressDetails_xal = interface;
  IXMLPostalServiceElements_xal = interface;
  IXMLAddressIdentifier_xal = interface;
  IXMLAddressIdentifier_xalList = interface;
  IXMLEndorsementLineCode_xal = interface;
  IXMLKeyLineCode_xal = interface;
  IXMLBarcode_xal = interface;
  IXMLSortingCode_xal = interface;
  IXMLAddressLatitude_xal = interface;
  IXMLAddressLatitudeDirection_xal = interface;
  IXMLAddressLongitude_xal = interface;
  IXMLAddressLongitudeDirection_xal = interface;
  IXMLSupplementaryPostalServiceData_xal = interface;
  IXMLSupplementaryPostalServiceData_xalList = interface;
  IXMLAddress_xal = interface;
  IXMLAddressLinesType_xal = interface;
  IXMLAddressLine_xal = interface;
  IXMLAddressLine_xalList = interface;
  IXMLCountry_xal = interface;
  IXMLCountryNameCode_xal = interface;
  IXMLCountryNameCode_xalList = interface;
  IXMLCountryName_xal = interface;
  IXMLCountryName_xalList = interface;
  IXMLAdministrativeArea_xal = interface;
  IXMLAdministrativeAreaName_xal = interface;
  IXMLAdministrativeAreaName_xalList = interface;
  IXMLSubAdministrativeArea_xal = interface;
  IXMLSubAdministrativeAreaName_xal = interface;
  IXMLSubAdministrativeAreaName_xalList = interface;
  IXMLLocality_xal = interface;
  IXMLLocalityName_xal = interface;
  IXMLLocalityName_xalList = interface;
  IXMLPostBox_xal = interface;
  IXMLPostBoxNumber_xal = interface;
  IXMLPostBoxNumberPrefix_xal = interface;
  IXMLPostBoxNumberSuffix_xal = interface;
  IXMLPostBoxNumberExtension_xal = interface;
  IXMLFirmType_xal = interface;
  IXMLFirmName_xal = interface;
  IXMLFirmName_xalList = interface;
  IXMLDepartment_xal = interface;
  IXMLDepartment_xalList = interface;
  IXMLDepartmentName_xal = interface;
  IXMLDepartmentName_xalList = interface;
  IXMLMailStopType_xal = interface;
  IXMLMailStopName_xal = interface;
  IXMLMailStopNumber_xal = interface;
  IXMLPostalCode_xal = interface;
  IXMLPostalCodeNumber_xal = interface;
  IXMLPostalCodeNumber_xalList = interface;
  IXMLPostalCodeNumberExtension_xal = interface;
  IXMLPostalCodeNumberExtension_xalList = interface;
  IXMLPostTown_xal = interface;
  IXMLPostTownName_xal = interface;
  IXMLPostTownName_xalList = interface;
  IXMLPostTownSuffix_xal = interface;
  IXMLLargeMailUserType_xal = interface;
  IXMLLargeMailUserName_xal = interface;
  IXMLLargeMailUserName_xalList = interface;
  IXMLLargeMailUserIdentifier_xal = interface;
  IXMLBuildingNameType_xal = interface;
  IXMLBuildingNameType_xalList = interface;
  IXMLThoroughfare_xal = interface;
  IXMLThoroughfareNumber_xal = interface;
  IXMLThoroughfareNumber_xalList = interface;
  IXMLThoroughfareNumberRange_xal = interface;
  IXMLThoroughfareNumberRange_xalList = interface;
  IXMLThoroughfareNumberFrom_xal = interface;
  IXMLThoroughfareNumberPrefix_xal = interface;
  IXMLThoroughfareNumberPrefix_xalList = interface;
  IXMLThoroughfareNumberSuffix_xal = interface;
  IXMLThoroughfareNumberSuffix_xalList = interface;
  IXMLThoroughfareNumberTo_xal = interface;
  IXMLThoroughfarePreDirectionType_xal = interface;
  IXMLThoroughfareLeadingTypeType_xal = interface;
  IXMLThoroughfareNameType_xal = interface;
  IXMLThoroughfareNameType_xalList = interface;
  IXMLThoroughfareTrailingTypeType_xal = interface;
  IXMLThoroughfarePostDirectionType_xal = interface;
  IXMLDependentThoroughfare_xal = interface;
  IXMLDependentLocalityType_xal = interface;
  IXMLDependentLocalityName_xal = interface;
  IXMLDependentLocalityName_xalList = interface;
  IXMLDependentLocalityNumber_xal = interface;
  IXMLPostOffice_xal = interface;
  IXMLPostOfficeName_xal = interface;
  IXMLPostOfficeName_xalList = interface;
  IXMLPostOfficeNumber_xal = interface;
  IXMLPostalRouteType_xal = interface;
  IXMLPostalRouteName_xal = interface;
  IXMLPostalRouteName_xalList = interface;
  IXMLPostalRouteNumber_xal = interface;
  IXMLPremise_xal = interface;
  IXMLPremiseName_xal = interface;
  IXMLPremiseName_xalList = interface;
  IXMLPremiseLocation_xal = interface;
  IXMLPremiseNumber_xal = interface;
  IXMLPremiseNumber_xalList = interface;
  IXMLPremiseNumberRange_xal = interface;
  IXMLPremiseNumberRangeFrom_xal = interface;
  IXMLPremiseNumberPrefix_xal = interface;
  IXMLPremiseNumberPrefix_xalList = interface;
  IXMLPremiseNumberSuffix_xal = interface;
  IXMLPremiseNumberSuffix_xalList = interface;
  IXMLPremiseNumberRangeTo_xal = interface;
  IXMLSubPremiseType_xal = interface;
  IXMLSubPremiseType_xalList = interface;
  IXMLSubPremiseName_xal = interface;
  IXMLSubPremiseName_xalList = interface;
  IXMLSubPremiseLocation_xal = interface;
  IXMLSubPremiseNumber_xal = interface;
  IXMLSubPremiseNumber_xalList = interface;
  IXMLSubPremiseNumberPrefix_xal = interface;
  IXMLSubPremiseNumberPrefix_xalList = interface;
  IXMLSubPremiseNumberSuffix_xal = interface;
  IXMLSubPremiseNumberSuffix_xalList = interface;
  IXMLAbstractViewType = interface;
  IXMLAbstractTimePrimitiveType = interface;
  IXMLAbstractStyleSelectorType = interface;
  IXMLAbstractStyleSelectorTypeList = interface;
  IXMLRegionType = interface;
  IXMLAbstractExtentType = interface;
  IXMLLodType = interface;
  IXMLLookAtType = interface;
  IXMLCameraType = interface;
  IXMLMetadataType = interface;
  IXMLExtendedDataType = interface;
  IXMLDataType = interface;
  IXMLDataTypeList = interface;
  IXMLSchemaDataType = interface;
  IXMLSchemaDataTypeList = interface;
  IXMLSimpleDataType = interface;
  IXMLSimpleDataTypeList = interface;
  IXMLSimpleArrayDataType = interface;
  IXMLSimpleArrayDataTypeList = interface;
  IXMLAbstractContainerType = interface;
  IXMLAbstractContainerTypeList = interface;
  IXMLAbstractGeometryType = interface;
  IXMLAbstractGeometryTypeList = interface;
  IXMLAbstractOverlayType = interface;
  IXMLBasicLinkType = interface;
  IXMLLinkType = interface;
  IXMLKmlType = interface;
  IXMLNetworkLinkControlType = interface;
  IXMLUpdateType = interface;
  IXMLDocumentType = interface;
  IXMLSchemaType = interface;
  IXMLSchemaTypeList = interface;
  IXMLSimpleFieldType = interface;
  IXMLSimpleFieldTypeList = interface;
  IXMLSimpleArrayFieldType = interface;
  IXMLSimpleArrayFieldTypeList = interface;
  IXMLFolderType = interface;
  IXMLPlacemarkType = interface;
  IXMLNetworkLinkType = interface;
  IXMLAbstractLatLonBoxType = interface;
  IXMLLatLonAltBoxType = interface;
  IXMLMultiGeometryType = interface;
  IXMLMultiGeometryTypeList = interface;
  IXMLPointType = interface;
  IXMLLineStringType = interface;
  IXMLLinearRingType = interface;
  IXMLPolygonType = interface;
  IXMLBoundaryType = interface;
  IXMLBoundaryTypeList = interface;
  IXMLModelType = interface;
  IXMLLocationType = interface;
  IXMLOrientationType = interface;
  IXMLScaleType = interface;
  IXMLResourceMapType = interface;
  IXMLAliasType = interface;
  IXMLAliasTypeList = interface;
  IXMLTrackType = interface;
  IXMLTrackTypeList = interface;
  IXMLMultiTrackType = interface;
  IXMLMultiTrackTypeList = interface;
  IXMLGroundOverlayType = interface;
  IXMLLatLonQuadType = interface;
  IXMLLatLonBoxType = interface;
  IXMLScreenOverlayType = interface;
  IXMLPhotoOverlayType = interface;
  IXMLViewVolumeType = interface;
  IXMLImagePyramidType = interface;
  IXMLStyleType = interface;
  IXMLAbstractSubStyleType = interface;
  IXMLAbstractColorStyleType = interface;
  IXMLIconStyleType = interface;
  IXMLLabelStyleType = interface;
  IXMLLineStyleType = interface;
  IXMLPolyStyleType = interface;
  IXMLBalloonStyleType = interface;
  IXMLListStyleType = interface;
  IXMLItemIconType = interface;
  IXMLItemIconTypeList = interface;
  IXMLStyleMapType = interface;
  IXMLPairType = interface;
  IXMLPairTypeList = interface;
  IXMLTimeStampType = interface;
  IXMLTimeSpanType = interface;
  IXMLCreateType = interface;
  IXMLDeleteType = interface;
  IXMLChangeType = interface;
  IXMLAbstractTourPrimitiveType = interface;
  IXMLAbstractTourPrimitiveTypeList = interface;
  IXMLAnimatedUpdateType = interface;
  IXMLFlyToType = interface;
  IXMLPlaylistType = interface;
  IXMLSoundCueType = interface;
  IXMLTourType = interface;
  IXMLTourControlType = interface;
  IXMLWaitType = interface;
  IXMLAtomEmailAddressList = interface;
  IXMLDateTimeTypeList = interface;
  IXMLAnyTypeList = interface;
  IXMLAnySimpleTypeList = interface;
  IXMLString_List = interface;

{ IXMLAbstractObjectType }

  IXMLAbstractObjectType = interface(IXMLNodeCollection)
    ['{54C0A6CE-16B3-44AC-9EAC-987B9A6F741E}']
    { Property Accessors }
    function Get_Id: UnicodeString;
    function Get_TargetId: UnicodeString;
    function Get_ObjectSimpleExtensionGroup(Index: Integer): Variant;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_TargetId(Value: UnicodeString);
    { Methods & Properties }
    function Add(const ObjectSimpleExtensionGroup: Variant): IXMLNode;
    function Insert(const Index: Integer; const ObjectSimpleExtensionGroup: Variant): IXMLNode;
    property Id: UnicodeString read Get_Id write Set_Id;
    property TargetId: UnicodeString read Get_TargetId write Set_TargetId;
    property ObjectSimpleExtensionGroup[Index: Integer]: Variant read Get_ObjectSimpleExtensionGroup; default;
  end;

{ IXMLVec2Type }

  IXMLVec2Type = interface(IXMLNode)
    ['{2FF6245C-4C97-42E3-B661-0D2808443E7E}']
    { Property Accessors }
    function Get_X: Double;
    function Get_Y: Double;
    function Get_Xunits: UnicodeString;
    function Get_Yunits: UnicodeString;
    procedure Set_X(Value: Double);
    procedure Set_Y(Value: Double);
    procedure Set_Xunits(Value: UnicodeString);
    procedure Set_Yunits(Value: UnicodeString);
    { Methods & Properties }
    property X: Double read Get_X write Set_X;
    property Y: Double read Get_Y write Set_Y;
    property Xunits: UnicodeString read Get_Xunits write Set_Xunits;
    property Yunits: UnicodeString read Get_Yunits write Set_Yunits;
  end;

{ IXMLSnippetType }

  IXMLSnippetType = interface(IXMLNode)
    ['{5E431E90-0927-4801-8E1E-757FFEFD8417}']
    { Property Accessors }
    function Get_MaxLines: Integer;
    procedure Set_MaxLines(Value: Integer);
    { Methods & Properties }
    property MaxLines: Integer read Get_MaxLines write Set_MaxLines;
  end;

{ IXMLAbstractFeatureType }

  IXMLAbstractFeatureType = interface(IXMLAbstractObjectType)
    ['{B4039B56-D29C-4356-9460-285D9F69304F}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Visibility: Boolean;
    function Get_BalloonVisibility: Boolean;
    function Get_Open: Boolean;
    function Get_Author: IXMLAtomPersonConstruct_atom;
    function Get_Link: IXMLLink_atom;
    function Get_Address: UnicodeString;
    function Get_AddressDetails: IXMLAddressDetails_xal;
    function Get_PhoneNumber: UnicodeString;
    function Get_AbstractSnippetGroup: UnicodeString;
    function Get_Description: UnicodeString;
    function Get_AbstractViewGroup: IXMLAbstractViewType;
    function Get_AbstractTimePrimitiveGroup: IXMLAbstractTimePrimitiveType;
    function Get_StyleUrl: UnicodeString;
    function Get_AbstractStyleSelectorGroup: IXMLAbstractStyleSelectorTypeList;
    function Get_Region: IXMLRegionType;
    function Get_AbstractExtendedDataGroup: UnicodeString;
    function Get_AbstractFeatureSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractFeatureObjectExtensionGroup: IXMLString_List;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Visibility(Value: Boolean);
    procedure Set_BalloonVisibility(Value: Boolean);
    procedure Set_Open(Value: Boolean);
    procedure Set_Address(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
    procedure Set_AbstractSnippetGroup(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    procedure Set_StyleUrl(Value: UnicodeString);
    procedure Set_AbstractExtendedDataGroup(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Visibility: Boolean read Get_Visibility write Set_Visibility;
    property BalloonVisibility: Boolean read Get_BalloonVisibility write Set_BalloonVisibility;
    property Open: Boolean read Get_Open write Set_Open;
    property Author: IXMLAtomPersonConstruct_atom read Get_Author;
    property Link: IXMLLink_atom read Get_Link;
    property Address: UnicodeString read Get_Address write Set_Address;
    property AddressDetails: IXMLAddressDetails_xal read Get_AddressDetails;
    property PhoneNumber: UnicodeString read Get_PhoneNumber write Set_PhoneNumber;
    property AbstractSnippetGroup: UnicodeString read Get_AbstractSnippetGroup write Set_AbstractSnippetGroup;
    property Description: UnicodeString read Get_Description write Set_Description;
    property AbstractViewGroup: IXMLAbstractViewType read Get_AbstractViewGroup;
    property AbstractTimePrimitiveGroup: IXMLAbstractTimePrimitiveType read Get_AbstractTimePrimitiveGroup;
    property StyleUrl: UnicodeString read Get_StyleUrl write Set_StyleUrl;
    property AbstractStyleSelectorGroup: IXMLAbstractStyleSelectorTypeList read Get_AbstractStyleSelectorGroup;
    property Region: IXMLRegionType read Get_Region;
    property AbstractExtendedDataGroup: UnicodeString read Get_AbstractExtendedDataGroup write Set_AbstractExtendedDataGroup;
    property AbstractFeatureSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractFeatureSimpleExtensionGroup;
    property AbstractFeatureObjectExtensionGroup: IXMLString_List read Get_AbstractFeatureObjectExtensionGroup;
  end;

{ IXMLAbstractFeatureTypeList }

  IXMLAbstractFeatureTypeList = interface(IXMLNodeCollection)
    ['{5C140788-2955-48BF-AC67-8B820789DC70}']
    { Methods & Properties }
    function Add: IXMLAbstractFeatureType;
    function Insert(const Index: Integer): IXMLAbstractFeatureType;

    function Get_Item(Index: Integer): IXMLAbstractFeatureType;
    property Items[Index: Integer]: IXMLAbstractFeatureType read Get_Item; default;
  end;

{ IXMLAtomPersonConstruct_atom }

  IXMLAtomPersonConstruct_atom = interface(IXMLNode)
    ['{7B97392E-A428-4BE5-8457-7DD8D72A5BE6}']
    { Property Accessors }
    function Get_Name: IXMLString_List;
    function Get_Uri: IXMLString_List;
    function Get_Email: IXMLAtomEmailAddressList;
    { Methods & Properties }
    property Name: IXMLString_List read Get_Name;
    property Uri: IXMLString_List read Get_Uri;
    property Email: IXMLAtomEmailAddressList read Get_Email;
  end;

{ IXMLLink_atom }

  IXMLLink_atom = interface(IXMLNode)
    ['{B5F67EB6-A6CC-44EA-B19E-584AD5606C12}']
    { Property Accessors }
    function Get_Href: UnicodeString;
    function Get_Rel: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Hreflang: UnicodeString;
    function Get_Title: UnicodeString;
    function Get_Length: UnicodeString;
    procedure Set_Href(Value: UnicodeString);
    procedure Set_Rel(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Hreflang(Value: UnicodeString);
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Length(Value: UnicodeString);
    { Methods & Properties }
    property Href: UnicodeString read Get_Href write Set_Href;
    property Rel: UnicodeString read Get_Rel write Set_Rel;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Hreflang: UnicodeString read Get_Hreflang write Set_Hreflang;
    property Title: UnicodeString read Get_Title write Set_Title;
    property Length: UnicodeString read Get_Length write Set_Length;
  end;

{ IXMLAddressDetails_xal }

  IXMLAddressDetails_xal = interface(IXMLNode)
    ['{CA68ADFD-519F-4655-B300-212408CC474C}']
    { Property Accessors }
    function Get_AddressType: UnicodeString;
    function Get_CurrentStatus: UnicodeString;
    function Get_ValidFromDate: UnicodeString;
    function Get_ValidToDate: UnicodeString;
    function Get_Usage: UnicodeString;
    function Get_Code: UnicodeString;
    function Get_AddressDetailsKey: UnicodeString;
    function Get_PostalServiceElements: IXMLPostalServiceElements_xal;
    function Get_Address: IXMLAddress_xal;
    function Get_AddressLines: IXMLAddressLinesType_xal;
    function Get_Country: IXMLCountry_xal;
    function Get_AdministrativeArea: IXMLAdministrativeArea_xal;
    function Get_Locality: IXMLLocality_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
    procedure Set_AddressType(Value: UnicodeString);
    procedure Set_CurrentStatus(Value: UnicodeString);
    procedure Set_ValidFromDate(Value: UnicodeString);
    procedure Set_ValidToDate(Value: UnicodeString);
    procedure Set_Usage(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    procedure Set_AddressDetailsKey(Value: UnicodeString);
    { Methods & Properties }
    property AddressType: UnicodeString read Get_AddressType write Set_AddressType;
    property CurrentStatus: UnicodeString read Get_CurrentStatus write Set_CurrentStatus;
    property ValidFromDate: UnicodeString read Get_ValidFromDate write Set_ValidFromDate;
    property ValidToDate: UnicodeString read Get_ValidToDate write Set_ValidToDate;
    property Usage: UnicodeString read Get_Usage write Set_Usage;
    property Code: UnicodeString read Get_Code write Set_Code;
    property AddressDetailsKey: UnicodeString read Get_AddressDetailsKey write Set_AddressDetailsKey;
    property PostalServiceElements: IXMLPostalServiceElements_xal read Get_PostalServiceElements;
    property Address: IXMLAddress_xal read Get_Address;
    property AddressLines: IXMLAddressLinesType_xal read Get_AddressLines;
    property Country: IXMLCountry_xal read Get_Country;
    property AdministrativeArea: IXMLAdministrativeArea_xal read Get_AdministrativeArea;
    property Locality: IXMLLocality_xal read Get_Locality;
    property Thoroughfare: IXMLThoroughfare_xal read Get_Thoroughfare;
  end;

{ IXMLPostalServiceElements_xal }

  IXMLPostalServiceElements_xal = interface(IXMLNode)
    ['{F9CF356F-695A-4C81-B8A0-8C1AB520355E}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressIdentifier: IXMLAddressIdentifier_xalList;
    function Get_EndorsementLineCode: IXMLEndorsementLineCode_xal;
    function Get_KeyLineCode: IXMLKeyLineCode_xal;
    function Get_Barcode: IXMLBarcode_xal;
    function Get_SortingCode: IXMLSortingCode_xal;
    function Get_AddressLatitude: IXMLAddressLatitude_xal;
    function Get_AddressLatitudeDirection: IXMLAddressLatitudeDirection_xal;
    function Get_AddressLongitude: IXMLAddressLongitude_xal;
    function Get_AddressLongitudeDirection: IXMLAddressLongitudeDirection_xal;
    function Get_SupplementaryPostalServiceData: IXMLSupplementaryPostalServiceData_xalList;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressIdentifier: IXMLAddressIdentifier_xalList read Get_AddressIdentifier;
    property EndorsementLineCode: IXMLEndorsementLineCode_xal read Get_EndorsementLineCode;
    property KeyLineCode: IXMLKeyLineCode_xal read Get_KeyLineCode;
    property Barcode: IXMLBarcode_xal read Get_Barcode;
    property SortingCode: IXMLSortingCode_xal read Get_SortingCode;
    property AddressLatitude: IXMLAddressLatitude_xal read Get_AddressLatitude;
    property AddressLatitudeDirection: IXMLAddressLatitudeDirection_xal read Get_AddressLatitudeDirection;
    property AddressLongitude: IXMLAddressLongitude_xal read Get_AddressLongitude;
    property AddressLongitudeDirection: IXMLAddressLongitudeDirection_xal read Get_AddressLongitudeDirection;
    property SupplementaryPostalServiceData: IXMLSupplementaryPostalServiceData_xalList read Get_SupplementaryPostalServiceData;
  end;

{ IXMLAddressIdentifier_xal }

  IXMLAddressIdentifier_xal = interface(IXMLNode)
    ['{75D3DAA2-2A0B-44EF-AC0E-FDDC4FE0E2F3}']
    { Property Accessors }
    function Get_IdentifierType: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_IdentifierType(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property IdentifierType: UnicodeString read Get_IdentifierType write Set_IdentifierType;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLAddressIdentifier_xalList }

  IXMLAddressIdentifier_xalList = interface(IXMLNodeCollection)
    ['{2191B7C1-DE28-4535-A7B7-213E023A056A}']
    { Methods & Properties }
    function Add: IXMLAddressIdentifier_xal;
    function Insert(const Index: Integer): IXMLAddressIdentifier_xal;

    function Get_Item(Index: Integer): IXMLAddressIdentifier_xal;
    property Items[Index: Integer]: IXMLAddressIdentifier_xal read Get_Item; default;
  end;

{ IXMLEndorsementLineCode_xal }

  IXMLEndorsementLineCode_xal = interface(IXMLNode)
    ['{36777523-1D8F-44F1-87BE-E8474EE770EB}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLKeyLineCode_xal }

  IXMLKeyLineCode_xal = interface(IXMLNode)
    ['{A3DD86A9-4E51-4CA7-8877-8939AFCF9D9D}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLBarcode_xal }

  IXMLBarcode_xal = interface(IXMLNode)
    ['{69009496-CFC5-4701-897B-7025388E5CC8}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLSortingCode_xal }

  IXMLSortingCode_xal = interface(IXMLNode)
    ['{A9898F8E-177E-47C1-9329-DB7CDD53DAAF}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLAddressLatitude_xal }

  IXMLAddressLatitude_xal = interface(IXMLNode)
    ['{5EB24BD2-DE3B-48C7-91DE-242A022B9067}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLAddressLatitudeDirection_xal }

  IXMLAddressLatitudeDirection_xal = interface(IXMLNode)
    ['{08A870F2-02C3-451E-B7A4-DD2E6CB043F0}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLAddressLongitude_xal }

  IXMLAddressLongitude_xal = interface(IXMLNode)
    ['{413AC196-7E70-49C4-97A8-B2BCCECB4BE2}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLAddressLongitudeDirection_xal }

  IXMLAddressLongitudeDirection_xal = interface(IXMLNode)
    ['{98B6CD5C-6EDF-453D-9023-CE15A5392585}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLSupplementaryPostalServiceData_xal }

  IXMLSupplementaryPostalServiceData_xal = interface(IXMLNode)
    ['{F0CC5626-68F8-4871-9B98-0BC08948434A}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLSupplementaryPostalServiceData_xalList }

  IXMLSupplementaryPostalServiceData_xalList = interface(IXMLNodeCollection)
    ['{8BFB3D5D-4AD6-4329-B2C0-BFD8B535F719}']
    { Methods & Properties }
    function Add: IXMLSupplementaryPostalServiceData_xal;
    function Insert(const Index: Integer): IXMLSupplementaryPostalServiceData_xal;

    function Get_Item(Index: Integer): IXMLSupplementaryPostalServiceData_xal;
    property Items[Index: Integer]: IXMLSupplementaryPostalServiceData_xal read Get_Item; default;
  end;

{ IXMLAddress_xal }

  IXMLAddress_xal = interface(IXMLNode)
    ['{B93D7489-427A-493F-BCF2-00487A351F35}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLAddressLinesType_xal }

  IXMLAddressLinesType_xal = interface(IXMLNodeCollection)
    ['{26973AF0-AFC2-4C2D-9024-DB6F189A6F3B}']
    { Property Accessors }
    function Get_AddressLine(Index: Integer): IXMLAddressLine_xal;
    { Methods & Properties }
    function Add: IXMLAddressLine_xal;
    function Insert(const Index: Integer): IXMLAddressLine_xal;
    property AddressLine[Index: Integer]: IXMLAddressLine_xal read Get_AddressLine; default;
  end;

{ IXMLAddressLine_xal }

  IXMLAddressLine_xal = interface(IXMLNode)
    ['{0B0542DB-20CC-4050-B1BB-BB5AED0E62CB}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLAddressLine_xalList }

  IXMLAddressLine_xalList = interface(IXMLNodeCollection)
    ['{E49AFF36-F31D-4D3F-8D72-0EA411145044}']
    { Methods & Properties }
    function Add: IXMLAddressLine_xal;
    function Insert(const Index: Integer): IXMLAddressLine_xal;

    function Get_Item(Index: Integer): IXMLAddressLine_xal;
    property Items[Index: Integer]: IXMLAddressLine_xal read Get_Item; default;
  end;

{ IXMLCountry_xal }

  IXMLCountry_xal = interface(IXMLNode)
    ['{888DEFD2-E216-4728-A2DA-62E8C4657349}']
    { Property Accessors }
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_CountryNameCode: IXMLCountryNameCode_xalList;
    function Get_CountryName: IXMLCountryName_xalList;
    function Get_AdministrativeArea: IXMLAdministrativeArea_xal;
    function Get_Locality: IXMLLocality_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
    { Methods & Properties }
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property CountryNameCode: IXMLCountryNameCode_xalList read Get_CountryNameCode;
    property CountryName: IXMLCountryName_xalList read Get_CountryName;
    property AdministrativeArea: IXMLAdministrativeArea_xal read Get_AdministrativeArea;
    property Locality: IXMLLocality_xal read Get_Locality;
    property Thoroughfare: IXMLThoroughfare_xal read Get_Thoroughfare;
  end;

{ IXMLCountryNameCode_xal }

  IXMLCountryNameCode_xal = interface(IXMLNode)
    ['{E8959FE9-D551-472C-83CB-9961FA517E13}']
    { Property Accessors }
    function Get_Scheme: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Scheme(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Scheme: UnicodeString read Get_Scheme write Set_Scheme;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLCountryNameCode_xalList }

  IXMLCountryNameCode_xalList = interface(IXMLNodeCollection)
    ['{C05C0854-C3E6-4CF9-91CA-161B5186C05C}']
    { Methods & Properties }
    function Add: IXMLCountryNameCode_xal;
    function Insert(const Index: Integer): IXMLCountryNameCode_xal;

    function Get_Item(Index: Integer): IXMLCountryNameCode_xal;
    property Items[Index: Integer]: IXMLCountryNameCode_xal read Get_Item; default;
  end;

{ IXMLCountryName_xal }

  IXMLCountryName_xal = interface(IXMLNode)
    ['{F62163F6-33EA-4F9D-B3BF-B9390615EE8E}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLCountryName_xalList }

  IXMLCountryName_xalList = interface(IXMLNodeCollection)
    ['{94A162D9-8943-40D3-B408-8842DA290484}']
    { Methods & Properties }
    function Add: IXMLCountryName_xal;
    function Insert(const Index: Integer): IXMLCountryName_xal;

    function Get_Item(Index: Integer): IXMLCountryName_xal;
    property Items[Index: Integer]: IXMLCountryName_xal read Get_Item; default;
  end;

{ IXMLAdministrativeArea_xal }

  IXMLAdministrativeArea_xal = interface(IXMLNode)
    ['{AD8B0DDA-6AB8-4605-8DF8-FDDA1375874E}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_UsageType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_AdministrativeAreaName: IXMLAdministrativeAreaName_xalList;
    function Get_SubAdministrativeArea: IXMLSubAdministrativeArea_xal;
    function Get_Locality: IXMLLocality_xal;
    function Get_PostOffice: IXMLPostOffice_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_UsageType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property UsageType: UnicodeString read Get_UsageType write Set_UsageType;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property AdministrativeAreaName: IXMLAdministrativeAreaName_xalList read Get_AdministrativeAreaName;
    property SubAdministrativeArea: IXMLSubAdministrativeArea_xal read Get_SubAdministrativeArea;
    property Locality: IXMLLocality_xal read Get_Locality;
    property PostOffice: IXMLPostOffice_xal read Get_PostOffice;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLAdministrativeAreaName_xal }

  IXMLAdministrativeAreaName_xal = interface(IXMLNode)
    ['{17C9AA29-AB29-4CFE-973E-64906673FC69}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLAdministrativeAreaName_xalList }

  IXMLAdministrativeAreaName_xalList = interface(IXMLNodeCollection)
    ['{1F6A8E69-F135-4BED-9A9B-8A5C83042B6D}']
    { Methods & Properties }
    function Add: IXMLAdministrativeAreaName_xal;
    function Insert(const Index: Integer): IXMLAdministrativeAreaName_xal;

    function Get_Item(Index: Integer): IXMLAdministrativeAreaName_xal;
    property Items[Index: Integer]: IXMLAdministrativeAreaName_xal read Get_Item; default;
  end;

{ IXMLSubAdministrativeArea_xal }

  IXMLSubAdministrativeArea_xal = interface(IXMLNode)
    ['{5C1CD25C-23C0-4B37-9A80-A5B347BA7E32}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_UsageType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_SubAdministrativeAreaName: IXMLSubAdministrativeAreaName_xalList;
    function Get_Locality: IXMLLocality_xal;
    function Get_PostOffice: IXMLPostOffice_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_UsageType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property UsageType: UnicodeString read Get_UsageType write Set_UsageType;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property SubAdministrativeAreaName: IXMLSubAdministrativeAreaName_xalList read Get_SubAdministrativeAreaName;
    property Locality: IXMLLocality_xal read Get_Locality;
    property PostOffice: IXMLPostOffice_xal read Get_PostOffice;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLSubAdministrativeAreaName_xal }

  IXMLSubAdministrativeAreaName_xal = interface(IXMLNode)
    ['{948C7105-8687-48A5-9C43-5A3796E088BE}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLSubAdministrativeAreaName_xalList }

  IXMLSubAdministrativeAreaName_xalList = interface(IXMLNodeCollection)
    ['{B97B2E63-AEBC-4307-A12E-7D35DED04EE1}']
    { Methods & Properties }
    function Add: IXMLSubAdministrativeAreaName_xal;
    function Insert(const Index: Integer): IXMLSubAdministrativeAreaName_xal;

    function Get_Item(Index: Integer): IXMLSubAdministrativeAreaName_xal;
    property Items[Index: Integer]: IXMLSubAdministrativeAreaName_xal read Get_Item; default;
  end;

{ IXMLLocality_xal }

  IXMLLocality_xal = interface(IXMLNode)
    ['{7CF5C6DC-A34E-431C-A9A3-1FC9761F4796}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_UsageType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_LocalityName: IXMLLocalityName_xalList;
    function Get_PostBox: IXMLPostBox_xal;
    function Get_LargeMailUser: IXMLLargeMailUserType_xal;
    function Get_PostOffice: IXMLPostOffice_xal;
    function Get_PostalRoute: IXMLPostalRouteType_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
    function Get_Premise: IXMLPremise_xal;
    function Get_DependentLocality: IXMLDependentLocalityType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_UsageType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property UsageType: UnicodeString read Get_UsageType write Set_UsageType;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property LocalityName: IXMLLocalityName_xalList read Get_LocalityName;
    property PostBox: IXMLPostBox_xal read Get_PostBox;
    property LargeMailUser: IXMLLargeMailUserType_xal read Get_LargeMailUser;
    property PostOffice: IXMLPostOffice_xal read Get_PostOffice;
    property PostalRoute: IXMLPostalRouteType_xal read Get_PostalRoute;
    property Thoroughfare: IXMLThoroughfare_xal read Get_Thoroughfare;
    property Premise: IXMLPremise_xal read Get_Premise;
    property DependentLocality: IXMLDependentLocalityType_xal read Get_DependentLocality;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLLocalityName_xal }

  IXMLLocalityName_xal = interface(IXMLNode)
    ['{F15FD55F-6EAB-43EA-89F6-CB250CE496B0}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLLocalityName_xalList }

  IXMLLocalityName_xalList = interface(IXMLNodeCollection)
    ['{07D2084D-1008-49C9-A9E1-A10B079FE6C1}']
    { Methods & Properties }
    function Add: IXMLLocalityName_xal;
    function Insert(const Index: Integer): IXMLLocalityName_xal;

    function Get_Item(Index: Integer): IXMLLocalityName_xal;
    property Items[Index: Integer]: IXMLLocalityName_xal read Get_Item; default;
  end;

{ IXMLPostBox_xal }

  IXMLPostBox_xal = interface(IXMLNode)
    ['{6FEF0F14-9C8F-46EF-A38C-200BC9E2AC95}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostBoxNumber: IXMLPostBoxNumber_xal;
    function Get_PostBoxNumberPrefix: IXMLPostBoxNumberPrefix_xal;
    function Get_PostBoxNumberSuffix: IXMLPostBoxNumberSuffix_xal;
    function Get_PostBoxNumberExtension: IXMLPostBoxNumberExtension_xal;
    function Get_Firm: IXMLFirmType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property PostBoxNumber: IXMLPostBoxNumber_xal read Get_PostBoxNumber;
    property PostBoxNumberPrefix: IXMLPostBoxNumberPrefix_xal read Get_PostBoxNumberPrefix;
    property PostBoxNumberSuffix: IXMLPostBoxNumberSuffix_xal read Get_PostBoxNumberSuffix;
    property PostBoxNumberExtension: IXMLPostBoxNumberExtension_xal read Get_PostBoxNumberExtension;
    property Firm: IXMLFirmType_xal read Get_Firm;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLPostBoxNumber_xal }

  IXMLPostBoxNumber_xal = interface(IXMLNode)
    ['{CF8DEA4E-606B-4615-A0A1-7DF43B2E0FE4}']
    { Property Accessors }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostBoxNumberPrefix_xal }

  IXMLPostBoxNumberPrefix_xal = interface(IXMLNode)
    ['{5F4313B0-556E-41DD-AB47-B73432E00462}']
    { Property Accessors }
    function Get_NumberPrefixSeparator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberPrefixSeparator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberPrefixSeparator: UnicodeString read Get_NumberPrefixSeparator write Set_NumberPrefixSeparator;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostBoxNumberSuffix_xal }

  IXMLPostBoxNumberSuffix_xal = interface(IXMLNode)
    ['{4D0ED476-0C1B-4821-B441-FE6354C6BEB7}']
    { Property Accessors }
    function Get_NumberSuffixSeparator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberSuffixSeparator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberSuffixSeparator: UnicodeString read Get_NumberSuffixSeparator write Set_NumberSuffixSeparator;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostBoxNumberExtension_xal }

  IXMLPostBoxNumberExtension_xal = interface(IXMLNode)
    ['{E6900EE3-FE3D-4EB6-89CF-EF72524AD509}']
    { Property Accessors }
    function Get_NumberExtensionSeparator: UnicodeString;
    procedure Set_NumberExtensionSeparator(Value: UnicodeString);
    { Methods & Properties }
    property NumberExtensionSeparator: UnicodeString read Get_NumberExtensionSeparator write Set_NumberExtensionSeparator;
  end;

{ IXMLFirmType_xal }

  IXMLFirmType_xal = interface(IXMLNode)
    ['{B69D2302-B0EB-4A33-898C-E952ED8B76D5}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_FirmName: IXMLFirmName_xalList;
    function Get_Department: IXMLDepartment_xalList;
    function Get_MailStop: IXMLMailStopType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property FirmName: IXMLFirmName_xalList read Get_FirmName;
    property Department: IXMLDepartment_xalList read Get_Department;
    property MailStop: IXMLMailStopType_xal read Get_MailStop;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLFirmName_xal }

  IXMLFirmName_xal = interface(IXMLNode)
    ['{DCE70C93-E4E1-402E-93B8-8B36BC0207F7}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLFirmName_xalList }

  IXMLFirmName_xalList = interface(IXMLNodeCollection)
    ['{423518F3-654D-469B-A04B-C98A848DD75F}']
    { Methods & Properties }
    function Add: IXMLFirmName_xal;
    function Insert(const Index: Integer): IXMLFirmName_xal;

    function Get_Item(Index: Integer): IXMLFirmName_xal;
    property Items[Index: Integer]: IXMLFirmName_xal read Get_Item; default;
  end;

{ IXMLDepartment_xal }

  IXMLDepartment_xal = interface(IXMLNode)
    ['{644CD814-4517-4FCD-AC38-E00A09D2CF20}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_DepartmentName: IXMLDepartmentName_xalList;
    function Get_MailStop: IXMLMailStopType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property DepartmentName: IXMLDepartmentName_xalList read Get_DepartmentName;
    property MailStop: IXMLMailStopType_xal read Get_MailStop;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLDepartment_xalList }

  IXMLDepartment_xalList = interface(IXMLNodeCollection)
    ['{954C16C5-5443-493F-A3AC-1F29250D39F0}']
    { Methods & Properties }
    function Add: IXMLDepartment_xal;
    function Insert(const Index: Integer): IXMLDepartment_xal;

    function Get_Item(Index: Integer): IXMLDepartment_xal;
    property Items[Index: Integer]: IXMLDepartment_xal read Get_Item; default;
  end;

{ IXMLDepartmentName_xal }

  IXMLDepartmentName_xal = interface(IXMLNode)
    ['{4C5AA098-77C0-498C-8F44-ACB52C36D4B1}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLDepartmentName_xalList }

  IXMLDepartmentName_xalList = interface(IXMLNodeCollection)
    ['{1AB26A9D-4AC9-4169-A7DB-7C0D4E701201}']
    { Methods & Properties }
    function Add: IXMLDepartmentName_xal;
    function Insert(const Index: Integer): IXMLDepartmentName_xal;

    function Get_Item(Index: Integer): IXMLDepartmentName_xal;
    property Items[Index: Integer]: IXMLDepartmentName_xal read Get_Item; default;
  end;

{ IXMLMailStopType_xal }

  IXMLMailStopType_xal = interface(IXMLNode)
    ['{C1CECDC3-05CC-4877-89D3-A4AF33003832}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_MailStopName: IXMLMailStopName_xal;
    function Get_MailStopNumber: IXMLMailStopNumber_xal;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property MailStopName: IXMLMailStopName_xal read Get_MailStopName;
    property MailStopNumber: IXMLMailStopNumber_xal read Get_MailStopNumber;
  end;

{ IXMLMailStopName_xal }

  IXMLMailStopName_xal = interface(IXMLNode)
    ['{A31E57B8-6AC7-424A-9340-77B4AAEAC402}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLMailStopNumber_xal }

  IXMLMailStopNumber_xal = interface(IXMLNode)
    ['{898EE005-E878-4AF4-B07A-41D5CD2C00DC}']
    { Property Accessors }
    function Get_NameNumberSeparator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NameNumberSeparator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NameNumberSeparator: UnicodeString read Get_NameNumberSeparator write Set_NameNumberSeparator;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostalCode_xal }

  IXMLPostalCode_xal = interface(IXMLNode)
    ['{F79CFFBD-76F7-488F-8881-F3D3C9FFB4D5}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostalCodeNumber: IXMLPostalCodeNumber_xalList;
    function Get_PostalCodeNumberExtension: IXMLPostalCodeNumberExtension_xalList;
    function Get_PostTown: IXMLPostTown_xal;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property PostalCodeNumber: IXMLPostalCodeNumber_xalList read Get_PostalCodeNumber;
    property PostalCodeNumberExtension: IXMLPostalCodeNumberExtension_xalList read Get_PostalCodeNumberExtension;
    property PostTown: IXMLPostTown_xal read Get_PostTown;
  end;

{ IXMLPostalCodeNumber_xal }

  IXMLPostalCodeNumber_xal = interface(IXMLNode)
    ['{ED28A83E-9D88-4EA2-A68E-DED11AC67126}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostalCodeNumber_xalList }

  IXMLPostalCodeNumber_xalList = interface(IXMLNodeCollection)
    ['{A4DF90BA-8A7A-44C6-8703-51EB0955F227}']
    { Methods & Properties }
    function Add: IXMLPostalCodeNumber_xal;
    function Insert(const Index: Integer): IXMLPostalCodeNumber_xal;

    function Get_Item(Index: Integer): IXMLPostalCodeNumber_xal;
    property Items[Index: Integer]: IXMLPostalCodeNumber_xal read Get_Item; default;
  end;

{ IXMLPostalCodeNumberExtension_xal }

  IXMLPostalCodeNumberExtension_xal = interface(IXMLNode)
    ['{9E3DB2ED-EAAE-4E45-9ABF-E2FA6D6BE907}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_NumberExtensionSeparator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_NumberExtensionSeparator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property NumberExtensionSeparator: UnicodeString read Get_NumberExtensionSeparator write Set_NumberExtensionSeparator;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostalCodeNumberExtension_xalList }

  IXMLPostalCodeNumberExtension_xalList = interface(IXMLNodeCollection)
    ['{4C846B95-6443-49E1-9541-11ED675BBAA4}']
    { Methods & Properties }
    function Add: IXMLPostalCodeNumberExtension_xal;
    function Insert(const Index: Integer): IXMLPostalCodeNumberExtension_xal;

    function Get_Item(Index: Integer): IXMLPostalCodeNumberExtension_xal;
    property Items[Index: Integer]: IXMLPostalCodeNumberExtension_xal read Get_Item; default;
  end;

{ IXMLPostTown_xal }

  IXMLPostTown_xal = interface(IXMLNode)
    ['{EBF91EBF-41E2-4858-A588-8322FF0CD831}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostTownName: IXMLPostTownName_xalList;
    function Get_PostTownSuffix: IXMLPostTownSuffix_xal;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property PostTownName: IXMLPostTownName_xalList read Get_PostTownName;
    property PostTownSuffix: IXMLPostTownSuffix_xal read Get_PostTownSuffix;
  end;

{ IXMLPostTownName_xal }

  IXMLPostTownName_xal = interface(IXMLNode)
    ['{3479E249-6059-4979-91B9-C4E6C946EA26}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostTownName_xalList }

  IXMLPostTownName_xalList = interface(IXMLNodeCollection)
    ['{DC980148-46BD-4209-B1D9-4CAC910B6052}']
    { Methods & Properties }
    function Add: IXMLPostTownName_xal;
    function Insert(const Index: Integer): IXMLPostTownName_xal;

    function Get_Item(Index: Integer): IXMLPostTownName_xal;
    property Items[Index: Integer]: IXMLPostTownName_xal read Get_Item; default;
  end;

{ IXMLPostTownSuffix_xal }

  IXMLPostTownSuffix_xal = interface(IXMLNode)
    ['{FA37C5EE-D128-4AC0-B4EA-6454231A4DB0}']
    { Property Accessors }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLLargeMailUserType_xal }

  IXMLLargeMailUserType_xal = interface(IXMLNode)
    ['{2BDEA9C6-88CB-42A7-850C-0E7DE467A3B0}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_LargeMailUserName: IXMLLargeMailUserName_xalList;
    function Get_LargeMailUserIdentifier: IXMLLargeMailUserIdentifier_xal;
    function Get_BuildingName: IXMLBuildingNameType_xalList;
    function Get_Department: IXMLDepartment_xal;
    function Get_PostBox: IXMLPostBox_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property LargeMailUserName: IXMLLargeMailUserName_xalList read Get_LargeMailUserName;
    property LargeMailUserIdentifier: IXMLLargeMailUserIdentifier_xal read Get_LargeMailUserIdentifier;
    property BuildingName: IXMLBuildingNameType_xalList read Get_BuildingName;
    property Department: IXMLDepartment_xal read Get_Department;
    property PostBox: IXMLPostBox_xal read Get_PostBox;
    property Thoroughfare: IXMLThoroughfare_xal read Get_Thoroughfare;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLLargeMailUserName_xal }

  IXMLLargeMailUserName_xal = interface(IXMLNode)
    ['{09ECAFF7-48A2-4067-BD2B-6C501C0550D9}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLLargeMailUserName_xalList }

  IXMLLargeMailUserName_xalList = interface(IXMLNodeCollection)
    ['{4CE92882-DFA8-44BE-A87C-0B1F5659246A}']
    { Methods & Properties }
    function Add: IXMLLargeMailUserName_xal;
    function Insert(const Index: Integer): IXMLLargeMailUserName_xal;

    function Get_Item(Index: Integer): IXMLLargeMailUserName_xal;
    property Items[Index: Integer]: IXMLLargeMailUserName_xal read Get_Item; default;
  end;

{ IXMLLargeMailUserIdentifier_xal }

  IXMLLargeMailUserIdentifier_xal = interface(IXMLNode)
    ['{DC283EAE-99BA-4192-A065-2AC75F6D65D1}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLBuildingNameType_xal }

  IXMLBuildingNameType_xal = interface(IXMLNode)
    ['{3D531A2A-F3C7-4E2B-A0EC-662F993A182E}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_TypeOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_TypeOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property TypeOccurrence: UnicodeString read Get_TypeOccurrence write Set_TypeOccurrence;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLBuildingNameType_xalList }

  IXMLBuildingNameType_xalList = interface(IXMLNodeCollection)
    ['{CEB3F42F-E6ED-4817-8135-15BE5AB88ED4}']
    { Methods & Properties }
    function Add: IXMLBuildingNameType_xal;
    function Insert(const Index: Integer): IXMLBuildingNameType_xal;

    function Get_Item(Index: Integer): IXMLBuildingNameType_xal;
    property Items[Index: Integer]: IXMLBuildingNameType_xal read Get_Item; default;
  end;

{ IXMLThoroughfare_xal }

  IXMLThoroughfare_xal = interface(IXMLNode)
    ['{5EA472B8-8591-488D-92D0-7E6B5CD02034}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_DependentThoroughfares: UnicodeString;
    function Get_DependentThoroughfaresIndicator: UnicodeString;
    function Get_DependentThoroughfaresConnector: UnicodeString;
    function Get_DependentThoroughfaresType: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfareNumber: IXMLThoroughfareNumber_xalList;
    function Get_ThoroughfareNumberRange: IXMLThoroughfareNumberRange_xalList;
    function Get_ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
    function Get_ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
    function Get_ThoroughfarePreDirection: IXMLThoroughfarePreDirectionType_xal;
    function Get_ThoroughfareLeadingType: IXMLThoroughfareLeadingTypeType_xal;
    function Get_ThoroughfareName: IXMLThoroughfareNameType_xalList;
    function Get_ThoroughfareTrailingType: IXMLThoroughfareTrailingTypeType_xal;
    function Get_ThoroughfarePostDirection: IXMLThoroughfarePostDirectionType_xal;
    function Get_DependentThoroughfare: IXMLDependentThoroughfare_xal;
    function Get_DependentLocality: IXMLDependentLocalityType_xal;
    function Get_Premise: IXMLPremise_xal;
    function Get_Firm: IXMLFirmType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_DependentThoroughfares(Value: UnicodeString);
    procedure Set_DependentThoroughfaresIndicator(Value: UnicodeString);
    procedure Set_DependentThoroughfaresConnector(Value: UnicodeString);
    procedure Set_DependentThoroughfaresType(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property DependentThoroughfares: UnicodeString read Get_DependentThoroughfares write Set_DependentThoroughfares;
    property DependentThoroughfaresIndicator: UnicodeString read Get_DependentThoroughfaresIndicator write Set_DependentThoroughfaresIndicator;
    property DependentThoroughfaresConnector: UnicodeString read Get_DependentThoroughfaresConnector write Set_DependentThoroughfaresConnector;
    property DependentThoroughfaresType: UnicodeString read Get_DependentThoroughfaresType write Set_DependentThoroughfaresType;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property ThoroughfareNumber: IXMLThoroughfareNumber_xalList read Get_ThoroughfareNumber;
    property ThoroughfareNumberRange: IXMLThoroughfareNumberRange_xalList read Get_ThoroughfareNumberRange;
    property ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList read Get_ThoroughfareNumberPrefix;
    property ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList read Get_ThoroughfareNumberSuffix;
    property ThoroughfarePreDirection: IXMLThoroughfarePreDirectionType_xal read Get_ThoroughfarePreDirection;
    property ThoroughfareLeadingType: IXMLThoroughfareLeadingTypeType_xal read Get_ThoroughfareLeadingType;
    property ThoroughfareName: IXMLThoroughfareNameType_xalList read Get_ThoroughfareName;
    property ThoroughfareTrailingType: IXMLThoroughfareTrailingTypeType_xal read Get_ThoroughfareTrailingType;
    property ThoroughfarePostDirection: IXMLThoroughfarePostDirectionType_xal read Get_ThoroughfarePostDirection;
    property DependentThoroughfare: IXMLDependentThoroughfare_xal read Get_DependentThoroughfare;
    property DependentLocality: IXMLDependentLocalityType_xal read Get_DependentLocality;
    property Premise: IXMLPremise_xal read Get_Premise;
    property Firm: IXMLFirmType_xal read Get_Firm;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLThoroughfareNumber_xal }

  IXMLThoroughfareNumber_xal = interface(IXMLNode)
    ['{9A524DE1-4AAE-47E0-B656-DD7293B9386B}']
    { Property Accessors }
    function Get_NumberType: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_NumberOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberType(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_NumberOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberType: UnicodeString read Get_NumberType write Set_NumberType;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property IndicatorOccurrence: UnicodeString read Get_IndicatorOccurrence write Set_IndicatorOccurrence;
    property NumberOccurrence: UnicodeString read Get_NumberOccurrence write Set_NumberOccurrence;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLThoroughfareNumber_xalList }

  IXMLThoroughfareNumber_xalList = interface(IXMLNodeCollection)
    ['{F9EF6232-6DC6-4878-97AD-32790B87F6CA}']
    { Methods & Properties }
    function Add: IXMLThoroughfareNumber_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNumber_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNumber_xal;
    property Items[Index: Integer]: IXMLThoroughfareNumber_xal read Get_Item; default;
  end;

{ IXMLThoroughfareNumberRange_xal }

  IXMLThoroughfareNumberRange_xal = interface(IXMLNode)
    ['{C7346513-22A2-46D6-AE38-51599DF9BEC0}']
    { Property Accessors }
    function Get_RangeType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_Separator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_NumberRangeOccurrence: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfareNumberFrom: IXMLThoroughfareNumberFrom_xal;
    function Get_ThoroughfareNumberTo: IXMLThoroughfareNumberTo_xal;
    procedure Set_RangeType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_Separator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_NumberRangeOccurrence(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property RangeType: UnicodeString read Get_RangeType write Set_RangeType;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property Separator: UnicodeString read Get_Separator write Set_Separator;
    property IndicatorOccurrence: UnicodeString read Get_IndicatorOccurrence write Set_IndicatorOccurrence;
    property NumberRangeOccurrence: UnicodeString read Get_NumberRangeOccurrence write Set_NumberRangeOccurrence;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property ThoroughfareNumberFrom: IXMLThoroughfareNumberFrom_xal read Get_ThoroughfareNumberFrom;
    property ThoroughfareNumberTo: IXMLThoroughfareNumberTo_xal read Get_ThoroughfareNumberTo;
  end;

{ IXMLThoroughfareNumberRange_xalList }

  IXMLThoroughfareNumberRange_xalList = interface(IXMLNodeCollection)
    ['{E4578FC4-EF28-4201-A9B3-4B51FFF851E7}']
    { Methods & Properties }
    function Add: IXMLThoroughfareNumberRange_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNumberRange_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNumberRange_xal;
    property Items[Index: Integer]: IXMLThoroughfareNumberRange_xal read Get_Item; default;
  end;

{ IXMLThoroughfareNumberFrom_xal }

  IXMLThoroughfareNumberFrom_xal = interface(IXMLNode)
    ['{7EE93840-B677-40CC-B03C-49A38D5B0883}']
    { Property Accessors }
    function Get_Code: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
    function Get_ThoroughfareNumber: IXMLThoroughfareNumber_xalList;
    function Get_ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Code: UnicodeString read Get_Code write Set_Code;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList read Get_ThoroughfareNumberPrefix;
    property ThoroughfareNumber: IXMLThoroughfareNumber_xalList read Get_ThoroughfareNumber;
    property ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList read Get_ThoroughfareNumberSuffix;
  end;

{ IXMLThoroughfareNumberPrefix_xal }

  IXMLThoroughfareNumberPrefix_xal = interface(IXMLNode)
    ['{3B5DDA52-8FB8-465B-858D-BF832AB60759}']
    { Property Accessors }
    function Get_NumberPrefixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberPrefixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberPrefixSeparator: UnicodeString read Get_NumberPrefixSeparator write Set_NumberPrefixSeparator;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLThoroughfareNumberPrefix_xalList }

  IXMLThoroughfareNumberPrefix_xalList = interface(IXMLNodeCollection)
    ['{A36186B4-8685-487D-9606-ADFE739FBEDB}']
    { Methods & Properties }
    function Add: IXMLThoroughfareNumberPrefix_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNumberPrefix_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNumberPrefix_xal;
    property Items[Index: Integer]: IXMLThoroughfareNumberPrefix_xal read Get_Item; default;
  end;

{ IXMLThoroughfareNumberSuffix_xal }

  IXMLThoroughfareNumberSuffix_xal = interface(IXMLNode)
    ['{B1165CD2-F3E2-413E-8009-E6C68B6F76AB}']
    { Property Accessors }
    function Get_NumberSuffixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberSuffixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberSuffixSeparator: UnicodeString read Get_NumberSuffixSeparator write Set_NumberSuffixSeparator;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLThoroughfareNumberSuffix_xalList }

  IXMLThoroughfareNumberSuffix_xalList = interface(IXMLNodeCollection)
    ['{BF27972E-3A4E-4814-8771-E0CC5481CF03}']
    { Methods & Properties }
    function Add: IXMLThoroughfareNumberSuffix_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNumberSuffix_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNumberSuffix_xal;
    property Items[Index: Integer]: IXMLThoroughfareNumberSuffix_xal read Get_Item; default;
  end;

{ IXMLThoroughfareNumberTo_xal }

  IXMLThoroughfareNumberTo_xal = interface(IXMLNode)
    ['{EC588CBD-F0E8-4ECC-AC59-251104E041E3}']
    { Property Accessors }
    function Get_Code: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
    function Get_ThoroughfareNumber: IXMLThoroughfareNumber_xalList;
    function Get_ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Code: UnicodeString read Get_Code write Set_Code;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList read Get_ThoroughfareNumberPrefix;
    property ThoroughfareNumber: IXMLThoroughfareNumber_xalList read Get_ThoroughfareNumber;
    property ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList read Get_ThoroughfareNumberSuffix;
  end;

{ IXMLThoroughfarePreDirectionType_xal }

  IXMLThoroughfarePreDirectionType_xal = interface(IXMLNode)
    ['{E1D90ACA-7584-4F78-8D61-636536D734E8}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLThoroughfareLeadingTypeType_xal }

  IXMLThoroughfareLeadingTypeType_xal = interface(IXMLNode)
    ['{18BA5EE3-587B-4642-9AA3-B827474C27BE}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLThoroughfareNameType_xal }

  IXMLThoroughfareNameType_xal = interface(IXMLNode)
    ['{CE960F48-EC67-48C2-9B5B-42ED8010634A}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLThoroughfareNameType_xalList }

  IXMLThoroughfareNameType_xalList = interface(IXMLNodeCollection)
    ['{F2935E08-B4B6-4237-ABAB-B92A7737F48B}']
    { Methods & Properties }
    function Add: IXMLThoroughfareNameType_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNameType_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNameType_xal;
    property Items[Index: Integer]: IXMLThoroughfareNameType_xal read Get_Item; default;
  end;

{ IXMLThoroughfareTrailingTypeType_xal }

  IXMLThoroughfareTrailingTypeType_xal = interface(IXMLNode)
    ['{0FA81B9E-1FA9-4CCE-9F34-844CFC1D426E}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLThoroughfarePostDirectionType_xal }

  IXMLThoroughfarePostDirectionType_xal = interface(IXMLNode)
    ['{A822F642-0E67-4ACF-B2C3-4D314B1BB961}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLDependentThoroughfare_xal }

  IXMLDependentThoroughfare_xal = interface(IXMLNode)
    ['{019679F0-5ADA-4F33-9450-FE1E07431ECD}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfarePreDirection: IXMLThoroughfarePreDirectionType_xal;
    function Get_ThoroughfareLeadingType: IXMLThoroughfareLeadingTypeType_xal;
    function Get_ThoroughfareName: IXMLThoroughfareNameType_xalList;
    function Get_ThoroughfareTrailingType: IXMLThoroughfareTrailingTypeType_xal;
    function Get_ThoroughfarePostDirection: IXMLThoroughfarePostDirectionType_xal;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property ThoroughfarePreDirection: IXMLThoroughfarePreDirectionType_xal read Get_ThoroughfarePreDirection;
    property ThoroughfareLeadingType: IXMLThoroughfareLeadingTypeType_xal read Get_ThoroughfareLeadingType;
    property ThoroughfareName: IXMLThoroughfareNameType_xalList read Get_ThoroughfareName;
    property ThoroughfareTrailingType: IXMLThoroughfareTrailingTypeType_xal read Get_ThoroughfareTrailingType;
    property ThoroughfarePostDirection: IXMLThoroughfarePostDirectionType_xal read Get_ThoroughfarePostDirection;
  end;

{ IXMLDependentLocalityType_xal }

  IXMLDependentLocalityType_xal = interface(IXMLNode)
    ['{CC5D9FF6-1526-4801-B8C2-4E3C1CF18994}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_UsageType: UnicodeString;
    function Get_Connector: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_DependentLocalityName: IXMLDependentLocalityName_xalList;
    function Get_DependentLocalityNumber: IXMLDependentLocalityNumber_xal;
    function Get_PostBox: IXMLPostBox_xal;
    function Get_LargeMailUser: IXMLLargeMailUserType_xal;
    function Get_PostOffice: IXMLPostOffice_xal;
    function Get_PostalRoute: IXMLPostalRouteType_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
    function Get_Premise: IXMLPremise_xal;
    function Get_DependentLocality: IXMLDependentLocalityType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_UsageType(Value: UnicodeString);
    procedure Set_Connector(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property UsageType: UnicodeString read Get_UsageType write Set_UsageType;
    property Connector: UnicodeString read Get_Connector write Set_Connector;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property DependentLocalityName: IXMLDependentLocalityName_xalList read Get_DependentLocalityName;
    property DependentLocalityNumber: IXMLDependentLocalityNumber_xal read Get_DependentLocalityNumber;
    property PostBox: IXMLPostBox_xal read Get_PostBox;
    property LargeMailUser: IXMLLargeMailUserType_xal read Get_LargeMailUser;
    property PostOffice: IXMLPostOffice_xal read Get_PostOffice;
    property PostalRoute: IXMLPostalRouteType_xal read Get_PostalRoute;
    property Thoroughfare: IXMLThoroughfare_xal read Get_Thoroughfare;
    property Premise: IXMLPremise_xal read Get_Premise;
    property DependentLocality: IXMLDependentLocalityType_xal read Get_DependentLocality;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLDependentLocalityName_xal }

  IXMLDependentLocalityName_xal = interface(IXMLNode)
    ['{987415C1-9E2B-4FFD-970C-5A7BB9E17F45}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLDependentLocalityName_xalList }

  IXMLDependentLocalityName_xalList = interface(IXMLNodeCollection)
    ['{75E93FD9-222F-4736-9BA6-0418F10E4346}']
    { Methods & Properties }
    function Add: IXMLDependentLocalityName_xal;
    function Insert(const Index: Integer): IXMLDependentLocalityName_xal;

    function Get_Item(Index: Integer): IXMLDependentLocalityName_xal;
    property Items[Index: Integer]: IXMLDependentLocalityName_xal read Get_Item; default;
  end;

{ IXMLDependentLocalityNumber_xal }

  IXMLDependentLocalityNumber_xal = interface(IXMLNode)
    ['{6574AC07-4C34-4CE8-977B-236950A034E2}']
    { Property Accessors }
    function Get_NameNumberOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NameNumberOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NameNumberOccurrence: UnicodeString read Get_NameNumberOccurrence write Set_NameNumberOccurrence;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostOffice_xal }

  IXMLPostOffice_xal = interface(IXMLNode)
    ['{E9035DB6-1E30-4AC1-96B0-CB673749F4DD}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostOfficeName: IXMLPostOfficeName_xalList;
    function Get_PostOfficeNumber: IXMLPostOfficeNumber_xal;
    function Get_PostalRoute: IXMLPostalRouteType_xal;
    function Get_PostBox: IXMLPostBox_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property PostOfficeName: IXMLPostOfficeName_xalList read Get_PostOfficeName;
    property PostOfficeNumber: IXMLPostOfficeNumber_xal read Get_PostOfficeNumber;
    property PostalRoute: IXMLPostalRouteType_xal read Get_PostalRoute;
    property PostBox: IXMLPostBox_xal read Get_PostBox;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
  end;

{ IXMLPostOfficeName_xal }

  IXMLPostOfficeName_xal = interface(IXMLNode)
    ['{95FFD9CB-AED9-407A-A47F-9E74539A3A69}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostOfficeName_xalList }

  IXMLPostOfficeName_xalList = interface(IXMLNodeCollection)
    ['{14C1AEB7-FFBC-4E2B-893B-D1470AB63897}']
    { Methods & Properties }
    function Add: IXMLPostOfficeName_xal;
    function Insert(const Index: Integer): IXMLPostOfficeName_xal;

    function Get_Item(Index: Integer): IXMLPostOfficeName_xal;
    property Items[Index: Integer]: IXMLPostOfficeName_xal read Get_Item; default;
  end;

{ IXMLPostOfficeNumber_xal }

  IXMLPostOfficeNumber_xal = interface(IXMLNode)
    ['{BB397936-3F2D-435C-8885-3EEB676264E6}']
    { Property Accessors }
    function Get_Indicator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property IndicatorOccurrence: UnicodeString read Get_IndicatorOccurrence write Set_IndicatorOccurrence;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostalRouteType_xal }

  IXMLPostalRouteType_xal = interface(IXMLNode)
    ['{34CBB400-7983-47E9-9ACD-E4B87E66EF6A}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostalRouteName: IXMLPostalRouteName_xalList;
    function Get_PostalRouteNumber: IXMLPostalRouteNumber_xal;
    function Get_PostBox: IXMLPostBox_xal;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property PostalRouteName: IXMLPostalRouteName_xalList read Get_PostalRouteName;
    property PostalRouteNumber: IXMLPostalRouteNumber_xal read Get_PostalRouteNumber;
    property PostBox: IXMLPostBox_xal read Get_PostBox;
  end;

{ IXMLPostalRouteName_xal }

  IXMLPostalRouteName_xal = interface(IXMLNode)
    ['{D741C430-7A0E-4E9D-A647-7FBE3723EAD0}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPostalRouteName_xalList }

  IXMLPostalRouteName_xalList = interface(IXMLNodeCollection)
    ['{5C9FED93-DCD9-4E98-9C37-220ECA1B1B70}']
    { Methods & Properties }
    function Add: IXMLPostalRouteName_xal;
    function Insert(const Index: Integer): IXMLPostalRouteName_xal;

    function Get_Item(Index: Integer): IXMLPostalRouteName_xal;
    property Items[Index: Integer]: IXMLPostalRouteName_xal read Get_Item; default;
  end;

{ IXMLPostalRouteNumber_xal }

  IXMLPostalRouteNumber_xal = interface(IXMLNode)
    ['{BB0527B0-A0B1-41ED-85CB-C545A15CEAA4}']
    { Property Accessors }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPremise_xal }

  IXMLPremise_xal = interface(IXMLNode)
    ['{AD83D9FD-B1D8-4B61-B104-16413F6A02AD}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_PremiseDependency: UnicodeString;
    function Get_PremiseDependencyType: UnicodeString;
    function Get_PremiseThoroughfareConnector: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PremiseName: IXMLPremiseName_xalList;
    function Get_PremiseLocation: IXMLPremiseLocation_xal;
    function Get_PremiseNumber: IXMLPremiseNumber_xalList;
    function Get_PremiseNumberRange: IXMLPremiseNumberRange_xal;
    function Get_PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
    function Get_PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
    function Get_BuildingName: IXMLBuildingNameType_xalList;
    function Get_SubPremise: IXMLSubPremiseType_xalList;
    function Get_Firm: IXMLFirmType_xal;
    function Get_MailStop: IXMLMailStopType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    function Get_Premise: IXMLPremise_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_PremiseDependency(Value: UnicodeString);
    procedure Set_PremiseDependencyType(Value: UnicodeString);
    procedure Set_PremiseThoroughfareConnector(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property PremiseDependency: UnicodeString read Get_PremiseDependency write Set_PremiseDependency;
    property PremiseDependencyType: UnicodeString read Get_PremiseDependencyType write Set_PremiseDependencyType;
    property PremiseThoroughfareConnector: UnicodeString read Get_PremiseThoroughfareConnector write Set_PremiseThoroughfareConnector;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property PremiseName: IXMLPremiseName_xalList read Get_PremiseName;
    property PremiseLocation: IXMLPremiseLocation_xal read Get_PremiseLocation;
    property PremiseNumber: IXMLPremiseNumber_xalList read Get_PremiseNumber;
    property PremiseNumberRange: IXMLPremiseNumberRange_xal read Get_PremiseNumberRange;
    property PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList read Get_PremiseNumberPrefix;
    property PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList read Get_PremiseNumberSuffix;
    property BuildingName: IXMLBuildingNameType_xalList read Get_BuildingName;
    property SubPremise: IXMLSubPremiseType_xalList read Get_SubPremise;
    property Firm: IXMLFirmType_xal read Get_Firm;
    property MailStop: IXMLMailStopType_xal read Get_MailStop;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
    property Premise: IXMLPremise_xal read Get_Premise;
  end;

{ IXMLPremiseName_xal }

  IXMLPremiseName_xal = interface(IXMLNode)
    ['{2517A210-7480-4D7F-BE15-E6716C373620}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_TypeOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_TypeOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property TypeOccurrence: UnicodeString read Get_TypeOccurrence write Set_TypeOccurrence;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPremiseName_xalList }

  IXMLPremiseName_xalList = interface(IXMLNodeCollection)
    ['{153A74F1-7198-436D-9A35-78344B8998EF}']
    { Methods & Properties }
    function Add: IXMLPremiseName_xal;
    function Insert(const Index: Integer): IXMLPremiseName_xal;

    function Get_Item(Index: Integer): IXMLPremiseName_xal;
    property Items[Index: Integer]: IXMLPremiseName_xal read Get_Item; default;
  end;

{ IXMLPremiseLocation_xal }

  IXMLPremiseLocation_xal = interface(IXMLNode)
    ['{F21FD5FE-A999-471B-8823-5C0F155667B5}']
    { Property Accessors }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPremiseNumber_xal }

  IXMLPremiseNumber_xal = interface(IXMLNode)
    ['{3AA5CFC6-3E4E-40BA-877B-4CFFA5A7E192}']
    { Property Accessors }
    function Get_NumberType: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_NumberTypeOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberType(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_NumberTypeOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberType: UnicodeString read Get_NumberType write Set_NumberType;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property IndicatorOccurrence: UnicodeString read Get_IndicatorOccurrence write Set_IndicatorOccurrence;
    property NumberTypeOccurrence: UnicodeString read Get_NumberTypeOccurrence write Set_NumberTypeOccurrence;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPremiseNumber_xalList }

  IXMLPremiseNumber_xalList = interface(IXMLNodeCollection)
    ['{F0F3152E-4474-4553-B88A-ED0001C3C2FD}']
    { Methods & Properties }
    function Add: IXMLPremiseNumber_xal;
    function Insert(const Index: Integer): IXMLPremiseNumber_xal;

    function Get_Item(Index: Integer): IXMLPremiseNumber_xal;
    property Items[Index: Integer]: IXMLPremiseNumber_xal read Get_Item; default;
  end;

{ IXMLPremiseNumberRange_xal }

  IXMLPremiseNumberRange_xal = interface(IXMLNode)
    ['{BE1FEF36-DC89-41AA-8558-C6AC55316B73}']
    { Property Accessors }
    function Get_RangeType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_Separator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_IndicatorOccurence: UnicodeString;
    function Get_NumberRangeOccurence: UnicodeString;
    function Get_PremiseNumberRangeFrom: IXMLPremiseNumberRangeFrom_xal;
    function Get_PremiseNumberRangeTo: IXMLPremiseNumberRangeTo_xal;
    procedure Set_RangeType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_Separator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_IndicatorOccurence(Value: UnicodeString);
    procedure Set_NumberRangeOccurence(Value: UnicodeString);
    { Methods & Properties }
    property RangeType: UnicodeString read Get_RangeType write Set_RangeType;
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property Separator: UnicodeString read Get_Separator write Set_Separator;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property IndicatorOccurence: UnicodeString read Get_IndicatorOccurence write Set_IndicatorOccurence;
    property NumberRangeOccurence: UnicodeString read Get_NumberRangeOccurence write Set_NumberRangeOccurence;
    property PremiseNumberRangeFrom: IXMLPremiseNumberRangeFrom_xal read Get_PremiseNumberRangeFrom;
    property PremiseNumberRangeTo: IXMLPremiseNumberRangeTo_xal read Get_PremiseNumberRangeTo;
  end;

{ IXMLPremiseNumberRangeFrom_xal }

  IXMLPremiseNumberRangeFrom_xal = interface(IXMLNode)
    ['{89C6F667-8D89-49E7-A32A-24FFF461FE4A}']
    { Property Accessors }
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
    function Get_PremiseNumber: IXMLPremiseNumber_xalList;
    function Get_PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
    { Methods & Properties }
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList read Get_PremiseNumberPrefix;
    property PremiseNumber: IXMLPremiseNumber_xalList read Get_PremiseNumber;
    property PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList read Get_PremiseNumberSuffix;
  end;

{ IXMLPremiseNumberPrefix_xal }

  IXMLPremiseNumberPrefix_xal = interface(IXMLNode)
    ['{5C810ADA-60A5-4A13-9D83-5A504A12276F}']
    { Property Accessors }
    function Get_NumberPrefixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberPrefixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberPrefixSeparator: UnicodeString read Get_NumberPrefixSeparator write Set_NumberPrefixSeparator;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPremiseNumberPrefix_xalList }

  IXMLPremiseNumberPrefix_xalList = interface(IXMLNodeCollection)
    ['{0E70328E-9883-46A3-9152-024A60C97E10}']
    { Methods & Properties }
    function Add: IXMLPremiseNumberPrefix_xal;
    function Insert(const Index: Integer): IXMLPremiseNumberPrefix_xal;

    function Get_Item(Index: Integer): IXMLPremiseNumberPrefix_xal;
    property Items[Index: Integer]: IXMLPremiseNumberPrefix_xal read Get_Item; default;
  end;

{ IXMLPremiseNumberSuffix_xal }

  IXMLPremiseNumberSuffix_xal = interface(IXMLNode)
    ['{E367DE35-FBCA-40F2-83E6-1CF122F40620}']
    { Property Accessors }
    function Get_NumberSuffixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberSuffixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberSuffixSeparator: UnicodeString read Get_NumberSuffixSeparator write Set_NumberSuffixSeparator;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLPremiseNumberSuffix_xalList }

  IXMLPremiseNumberSuffix_xalList = interface(IXMLNodeCollection)
    ['{20047C3F-E697-4370-81E4-0399D68BB583}']
    { Methods & Properties }
    function Add: IXMLPremiseNumberSuffix_xal;
    function Insert(const Index: Integer): IXMLPremiseNumberSuffix_xal;

    function Get_Item(Index: Integer): IXMLPremiseNumberSuffix_xal;
    property Items[Index: Integer]: IXMLPremiseNumberSuffix_xal read Get_Item; default;
  end;

{ IXMLPremiseNumberRangeTo_xal }

  IXMLPremiseNumberRangeTo_xal = interface(IXMLNode)
    ['{ADBECD95-A452-4226-A626-81FBFECA5BA5}']
    { Property Accessors }
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
    function Get_PremiseNumber: IXMLPremiseNumber_xalList;
    function Get_PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
    { Methods & Properties }
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList read Get_PremiseNumberPrefix;
    property PremiseNumber: IXMLPremiseNumber_xalList read Get_PremiseNumber;
    property PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList read Get_PremiseNumberSuffix;
  end;

{ IXMLSubPremiseType_xal }

  IXMLSubPremiseType_xal = interface(IXMLNode)
    ['{71D85ABA-F34E-4908-8715-9CBE99585624}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_SubPremiseName: IXMLSubPremiseName_xalList;
    function Get_SubPremiseLocation: IXMLSubPremiseLocation_xal;
    function Get_SubPremiseNumber: IXMLSubPremiseNumber_xalList;
    function Get_SubPremiseNumberPrefix: IXMLSubPremiseNumberPrefix_xalList;
    function Get_SubPremiseNumberSuffix: IXMLSubPremiseNumberSuffix_xalList;
    function Get_BuildingName: IXMLBuildingNameType_xalList;
    function Get_Firm: IXMLFirmType_xal;
    function Get_MailStop: IXMLMailStopType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    function Get_SubPremise: IXMLSubPremiseType_xal;
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property AddressLine: IXMLAddressLine_xalList read Get_AddressLine;
    property SubPremiseName: IXMLSubPremiseName_xalList read Get_SubPremiseName;
    property SubPremiseLocation: IXMLSubPremiseLocation_xal read Get_SubPremiseLocation;
    property SubPremiseNumber: IXMLSubPremiseNumber_xalList read Get_SubPremiseNumber;
    property SubPremiseNumberPrefix: IXMLSubPremiseNumberPrefix_xalList read Get_SubPremiseNumberPrefix;
    property SubPremiseNumberSuffix: IXMLSubPremiseNumberSuffix_xalList read Get_SubPremiseNumberSuffix;
    property BuildingName: IXMLBuildingNameType_xalList read Get_BuildingName;
    property Firm: IXMLFirmType_xal read Get_Firm;
    property MailStop: IXMLMailStopType_xal read Get_MailStop;
    property PostalCode: IXMLPostalCode_xal read Get_PostalCode;
    property SubPremise: IXMLSubPremiseType_xal read Get_SubPremise;
  end;

{ IXMLSubPremiseType_xalList }

  IXMLSubPremiseType_xalList = interface(IXMLNodeCollection)
    ['{3C978D92-9B3E-484C-A5C1-B7CAF458BA9E}']
    { Methods & Properties }
    function Add: IXMLSubPremiseType_xal;
    function Insert(const Index: Integer): IXMLSubPremiseType_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseType_xal;
    property Items[Index: Integer]: IXMLSubPremiseType_xal read Get_Item; default;
  end;

{ IXMLSubPremiseName_xal }

  IXMLSubPremiseName_xal = interface(IXMLNode)
    ['{62421AEE-951C-40D5-9B36-BF9776171F1C}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_TypeOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_TypeOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property TypeOccurrence: UnicodeString read Get_TypeOccurrence write Set_TypeOccurrence;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLSubPremiseName_xalList }

  IXMLSubPremiseName_xalList = interface(IXMLNodeCollection)
    ['{88B6277B-2D5C-4374-A370-FB581C01B344}']
    { Methods & Properties }
    function Add: IXMLSubPremiseName_xal;
    function Insert(const Index: Integer): IXMLSubPremiseName_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseName_xal;
    property Items[Index: Integer]: IXMLSubPremiseName_xal read Get_Item; default;
  end;

{ IXMLSubPremiseLocation_xal }

  IXMLSubPremiseLocation_xal = interface(IXMLNode)
    ['{31DC9415-5641-4A2A-8B9D-24B9F653D81A}']
    { Property Accessors }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLSubPremiseNumber_xal }

  IXMLSubPremiseNumber_xal = interface(IXMLNode)
    ['{030C1160-C13C-4F7D-AE0D-17ED599B76B2}']
    { Property Accessors }
    function Get_Indicator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_NumberTypeOccurrence: UnicodeString;
    function Get_PremiseNumberSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_NumberTypeOccurrence(Value: UnicodeString);
    procedure Set_PremiseNumberSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property Indicator: UnicodeString read Get_Indicator write Set_Indicator;
    property IndicatorOccurrence: UnicodeString read Get_IndicatorOccurrence write Set_IndicatorOccurrence;
    property NumberTypeOccurrence: UnicodeString read Get_NumberTypeOccurrence write Set_NumberTypeOccurrence;
    property PremiseNumberSeparator: UnicodeString read Get_PremiseNumberSeparator write Set_PremiseNumberSeparator;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLSubPremiseNumber_xalList }

  IXMLSubPremiseNumber_xalList = interface(IXMLNodeCollection)
    ['{77EACF64-945D-47F5-80E0-FCAF6F18511D}']
    { Methods & Properties }
    function Add: IXMLSubPremiseNumber_xal;
    function Insert(const Index: Integer): IXMLSubPremiseNumber_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseNumber_xal;
    property Items[Index: Integer]: IXMLSubPremiseNumber_xal read Get_Item; default;
  end;

{ IXMLSubPremiseNumberPrefix_xal }

  IXMLSubPremiseNumberPrefix_xal = interface(IXMLNode)
    ['{26F14F36-78D7-42F0-A492-FA701B0172D4}']
    { Property Accessors }
    function Get_NumberPrefixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberPrefixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberPrefixSeparator: UnicodeString read Get_NumberPrefixSeparator write Set_NumberPrefixSeparator;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLSubPremiseNumberPrefix_xalList }

  IXMLSubPremiseNumberPrefix_xalList = interface(IXMLNodeCollection)
    ['{4B9E5591-1DF3-4A99-8F61-96C8EF8A38C1}']
    { Methods & Properties }
    function Add: IXMLSubPremiseNumberPrefix_xal;
    function Insert(const Index: Integer): IXMLSubPremiseNumberPrefix_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseNumberPrefix_xal;
    property Items[Index: Integer]: IXMLSubPremiseNumberPrefix_xal read Get_Item; default;
  end;

{ IXMLSubPremiseNumberSuffix_xal }

  IXMLSubPremiseNumberSuffix_xal = interface(IXMLNode)
    ['{15C79FF8-F423-401E-B8F7-88F997B1FEAD}']
    { Property Accessors }
    function Get_NumberSuffixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberSuffixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    { Methods & Properties }
    property NumberSuffixSeparator: UnicodeString read Get_NumberSuffixSeparator write Set_NumberSuffixSeparator;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Code: UnicodeString read Get_Code write Set_Code;
  end;

{ IXMLSubPremiseNumberSuffix_xalList }

  IXMLSubPremiseNumberSuffix_xalList = interface(IXMLNodeCollection)
    ['{AB16447A-010D-45AE-A0AB-A96843B58D4E}']
    { Methods & Properties }
    function Add: IXMLSubPremiseNumberSuffix_xal;
    function Insert(const Index: Integer): IXMLSubPremiseNumberSuffix_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseNumberSuffix_xal;
    property Items[Index: Integer]: IXMLSubPremiseNumberSuffix_xal read Get_Item; default;
  end;

{ IXMLAbstractViewType }

  IXMLAbstractViewType = interface(IXMLAbstractObjectType)
    ['{EFAFE1AC-2802-4C9E-95E7-340CB8D1A52A}']
    { Property Accessors }
    function Get_AbstractTimePrimitiveGroup: IXMLAbstractTimePrimitiveType;
    function Get_AbstractViewSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractViewObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractTimePrimitiveGroup: IXMLAbstractTimePrimitiveType read Get_AbstractTimePrimitiveGroup;
    property AbstractViewSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractViewSimpleExtensionGroup;
    property AbstractViewObjectExtensionGroup: IXMLString_List read Get_AbstractViewObjectExtensionGroup;
  end;

{ IXMLAbstractTimePrimitiveType }

  IXMLAbstractTimePrimitiveType = interface(IXMLAbstractObjectType)
    ['{AFBB647F-1F15-44F5-B7EC-0FDBDB90268B}']
    { Property Accessors }
    function Get_AbstractTimePrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractTimePrimitiveObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractTimePrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractTimePrimitiveSimpleExtensionGroup;
    property AbstractTimePrimitiveObjectExtensionGroup: IXMLString_List read Get_AbstractTimePrimitiveObjectExtensionGroup;
  end;

{ IXMLAbstractStyleSelectorType }

  IXMLAbstractStyleSelectorType = interface(IXMLAbstractObjectType)
    ['{AB0BD903-B5FF-48CA-AC2D-C569441D2C2B}']
    { Property Accessors }
    function Get_AbstractStyleSelectorSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractStyleSelectorObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractStyleSelectorSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractStyleSelectorSimpleExtensionGroup;
    property AbstractStyleSelectorObjectExtensionGroup: IXMLString_List read Get_AbstractStyleSelectorObjectExtensionGroup;
  end;

{ IXMLAbstractStyleSelectorTypeList }

  IXMLAbstractStyleSelectorTypeList = interface(IXMLNodeCollection)
    ['{C761AF4A-35F3-4F72-8F86-5C8A67B05A7C}']
    { Methods & Properties }
    function Add: IXMLAbstractStyleSelectorType;
    function Insert(const Index: Integer): IXMLAbstractStyleSelectorType;

    function Get_Item(Index: Integer): IXMLAbstractStyleSelectorType;
    property Items[Index: Integer]: IXMLAbstractStyleSelectorType read Get_Item; default;
  end;

{ IXMLRegionType }

  IXMLRegionType = interface(IXMLAbstractObjectType)
    ['{0FA847CB-2451-45A9-AD8C-89C8E947E6AB}']
    { Property Accessors }
    function Get_AbstractExtentGroup: IXMLAbstractExtentType;
    function Get_Lod: IXMLLodType;
    function Get_RegionSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_RegionObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractExtentGroup: IXMLAbstractExtentType read Get_AbstractExtentGroup;
    property Lod: IXMLLodType read Get_Lod;
    property RegionSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_RegionSimpleExtensionGroup;
    property RegionObjectExtensionGroup: IXMLString_List read Get_RegionObjectExtensionGroup;
  end;

{ IXMLAbstractExtentType }

  IXMLAbstractExtentType = interface(IXMLAbstractObjectType)
    ['{F3C23758-2FA5-4DCE-A15E-FF66BAB8F250}']
    { Property Accessors }
    function Get_AbstractExtentSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractExtentObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractExtentSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractExtentSimpleExtensionGroup;
    property AbstractExtentObjectExtensionGroup: IXMLString_List read Get_AbstractExtentObjectExtensionGroup;
  end;

{ IXMLLodType }

  IXMLLodType = interface(IXMLAbstractObjectType)
    ['{CB27F3FF-A35F-43E1-9DAC-2FB548AD3F5C}']
    { Property Accessors }
    function Get_MinLodPixels: Double;
    function Get_MaxLodPixels: Double;
    function Get_MinFadeExtent: Double;
    function Get_MaxFadeExtent: Double;
    function Get_LodSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LodObjectExtensionGroup: IXMLString_List;
    procedure Set_MinLodPixels(Value: Double);
    procedure Set_MaxLodPixels(Value: Double);
    procedure Set_MinFadeExtent(Value: Double);
    procedure Set_MaxFadeExtent(Value: Double);
    { Methods & Properties }
    property MinLodPixels: Double read Get_MinLodPixels write Set_MinLodPixels;
    property MaxLodPixels: Double read Get_MaxLodPixels write Set_MaxLodPixels;
    property MinFadeExtent: Double read Get_MinFadeExtent write Set_MinFadeExtent;
    property MaxFadeExtent: Double read Get_MaxFadeExtent write Set_MaxFadeExtent;
    property LodSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LodSimpleExtensionGroup;
    property LodObjectExtensionGroup: IXMLString_List read Get_LodObjectExtensionGroup;
  end;

{ IXMLLookAtType }

  IXMLLookAtType = interface(IXMLAbstractViewType)
    ['{16EA1449-AF86-4447-B7DF-23817D4B98F5}']
    { Property Accessors }
    function Get_Longitude: Double;
    function Get_Latitude: Double;
    function Get_Altitude: Double;
    function Get_Heading: Double;
    function Get_Tilt: Double;
    function Get_Range: Double;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_HorizFov: Double;
    function Get_LookAtSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LookAtObjectExtensionGroup: IXMLString_List;
    procedure Set_Longitude(Value: Double);
    procedure Set_Latitude(Value: Double);
    procedure Set_Altitude(Value: Double);
    procedure Set_Heading(Value: Double);
    procedure Set_Tilt(Value: Double);
    procedure Set_Range(Value: Double);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_HorizFov(Value: Double);
    { Methods & Properties }
    property Longitude: Double read Get_Longitude write Set_Longitude;
    property Latitude: Double read Get_Latitude write Set_Latitude;
    property Altitude: Double read Get_Altitude write Set_Altitude;
    property Heading: Double read Get_Heading write Set_Heading;
    property Tilt: Double read Get_Tilt write Set_Tilt;
    property Range: Double read Get_Range write Set_Range;
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property HorizFov: Double read Get_HorizFov write Set_HorizFov;
    property LookAtSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LookAtSimpleExtensionGroup;
    property LookAtObjectExtensionGroup: IXMLString_List read Get_LookAtObjectExtensionGroup;
  end;

{ IXMLCameraType }

  IXMLCameraType = interface(IXMLAbstractViewType)
    ['{6065D5AD-C02E-4ABC-989E-741DF6261779}']
    { Property Accessors }
    function Get_Longitude: Double;
    function Get_Latitude: Double;
    function Get_Altitude: Double;
    function Get_Heading: Double;
    function Get_Tilt: Double;
    function Get_Roll: Double;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_HorizFov: Double;
    function Get_CameraSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_CameraObjectExtensionGroup: IXMLString_List;
    procedure Set_Longitude(Value: Double);
    procedure Set_Latitude(Value: Double);
    procedure Set_Altitude(Value: Double);
    procedure Set_Heading(Value: Double);
    procedure Set_Tilt(Value: Double);
    procedure Set_Roll(Value: Double);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_HorizFov(Value: Double);
    { Methods & Properties }
    property Longitude: Double read Get_Longitude write Set_Longitude;
    property Latitude: Double read Get_Latitude write Set_Latitude;
    property Altitude: Double read Get_Altitude write Set_Altitude;
    property Heading: Double read Get_Heading write Set_Heading;
    property Tilt: Double read Get_Tilt write Set_Tilt;
    property Roll: Double read Get_Roll write Set_Roll;
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property HorizFov: Double read Get_HorizFov write Set_HorizFov;
    property CameraSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_CameraSimpleExtensionGroup;
    property CameraObjectExtensionGroup: IXMLString_List read Get_CameraObjectExtensionGroup;
  end;

{ IXMLMetadataType }

  IXMLMetadataType = interface(IXMLNode)
    ['{E12B1CC7-0D05-4A6D-8B29-7C41FB2DA1FE}']
  end;

{ IXMLExtendedDataType }

  IXMLExtendedDataType = interface(IXMLNode)
    ['{3C2BB89D-4675-4525-9978-6BB1FB2CEAE1}']
    { Property Accessors }
    function Get_Data: IXMLDataTypeList;
    function Get_SchemaData: IXMLSchemaDataTypeList;
    { Methods & Properties }
    property Data: IXMLDataTypeList read Get_Data;
    property SchemaData: IXMLSchemaDataTypeList read Get_SchemaData;
  end;

{ IXMLDataType }

  IXMLDataType = interface(IXMLAbstractObjectType)
    ['{0A3C8260-CF4B-4DF8-9AC4-796FB917906E}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Uom: UnicodeString;
    function Get_DisplayName: UnicodeString;
    function Get_Value: Variant;
    function Get_DataExtension: IXMLString_List;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_DisplayName(Value: UnicodeString);
    procedure Set_Value(Value: Variant);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Uom: UnicodeString read Get_Uom write Set_Uom;
    property DisplayName: UnicodeString read Get_DisplayName write Set_DisplayName;
    property Value: Variant read Get_Value write Set_Value;
    property DataExtension: IXMLString_List read Get_DataExtension;
  end;

{ IXMLDataTypeList }

  IXMLDataTypeList = interface(IXMLNodeCollection)
    ['{94628520-4E36-44A8-8FD4-601A0EBBB96A}']
    { Methods & Properties }
    function Add: IXMLDataType;
    function Insert(const Index: Integer): IXMLDataType;

    function Get_Item(Index: Integer): IXMLDataType;
    property Items[Index: Integer]: IXMLDataType read Get_Item; default;
  end;

{ IXMLSchemaDataType }

  IXMLSchemaDataType = interface(IXMLAbstractObjectType)
    ['{659E9EAF-CA4D-4F85-AE6A-C74A3D023969}']
    { Property Accessors }
    function Get_SchemaUrl: UnicodeString;
    function Get_SimpleData: IXMLSimpleDataTypeList;
    function Get_SimpleArrayData: IXMLSimpleArrayDataTypeList;
    function Get_SchemaDataExtension: IXMLString_List;
    procedure Set_SchemaUrl(Value: UnicodeString);
    { Methods & Properties }
    property SchemaUrl: UnicodeString read Get_SchemaUrl write Set_SchemaUrl;
    property SimpleData: IXMLSimpleDataTypeList read Get_SimpleData;
    property SimpleArrayData: IXMLSimpleArrayDataTypeList read Get_SimpleArrayData;
    property SchemaDataExtension: IXMLString_List read Get_SchemaDataExtension;
  end;

{ IXMLSchemaDataTypeList }

  IXMLSchemaDataTypeList = interface(IXMLNodeCollection)
    ['{E42E15EA-FB01-4C69-90D9-565995B2E829}']
    { Methods & Properties }
    function Add: IXMLSchemaDataType;
    function Insert(const Index: Integer): IXMLSchemaDataType;

    function Get_Item(Index: Integer): IXMLSchemaDataType;
    property Items[Index: Integer]: IXMLSchemaDataType read Get_Item; default;
  end;

{ IXMLSimpleDataType }

  IXMLSimpleDataType = interface(IXMLNode)
    ['{5D512302-2B70-4DA9-9B75-CD7349F932F0}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
  end;

{ IXMLSimpleDataTypeList }

  IXMLSimpleDataTypeList = interface(IXMLNodeCollection)
    ['{BED6EE3D-F8A6-4D7E-84B4-B9FDE7E39AAA}']
    { Methods & Properties }
    function Add: IXMLSimpleDataType;
    function Insert(const Index: Integer): IXMLSimpleDataType;

    function Get_Item(Index: Integer): IXMLSimpleDataType;
    property Items[Index: Integer]: IXMLSimpleDataType read Get_Item; default;
  end;

{ IXMLSimpleArrayDataType }

  IXMLSimpleArrayDataType = interface(IXMLAbstractObjectType)
    ['{2F27E2AE-4519-4106-87CB-FD7231360CC7}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Value: IXMLAnySimpleTypeList;
    function Get_SimpleArrayDataExtension: IXMLString_List;
    procedure Set_Name(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Value: IXMLAnySimpleTypeList read Get_Value;
    property SimpleArrayDataExtension: IXMLString_List read Get_SimpleArrayDataExtension;
  end;

{ IXMLSimpleArrayDataTypeList }

  IXMLSimpleArrayDataTypeList = interface(IXMLNodeCollection)
    ['{04925349-2663-4E82-80E4-598D16440C9C}']
    { Methods & Properties }
    function Add: IXMLSimpleArrayDataType;
    function Insert(const Index: Integer): IXMLSimpleArrayDataType;

    function Get_Item(Index: Integer): IXMLSimpleArrayDataType;
    property Items[Index: Integer]: IXMLSimpleArrayDataType read Get_Item; default;
  end;

{ IXMLAbstractContainerType }

  IXMLAbstractContainerType = interface(IXMLAbstractFeatureType)
    ['{76FA95EE-756B-454C-A921-362C0AFD8F81}']
    { Property Accessors }
    function Get_AbstractContainerSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractContainerObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractContainerSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractContainerSimpleExtensionGroup;
    property AbstractContainerObjectExtensionGroup: IXMLString_List read Get_AbstractContainerObjectExtensionGroup;
  end;

{ IXMLAbstractContainerTypeList }

  IXMLAbstractContainerTypeList = interface(IXMLNodeCollection)
    ['{1CFE0546-2084-4959-84B5-AB99C5CBEA6E}']
    { Methods & Properties }
    function Add: IXMLAbstractContainerType;
    function Insert(const Index: Integer): IXMLAbstractContainerType;

    function Get_Item(Index: Integer): IXMLAbstractContainerType;
    property Items[Index: Integer]: IXMLAbstractContainerType read Get_Item; default;
  end;

{ IXMLAbstractGeometryType }

  IXMLAbstractGeometryType = interface(IXMLAbstractObjectType)
    ['{19E45C2C-B332-45A8-9778-3D5101CEB81E}']
    { Property Accessors }
    function Get_AbstractGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractGeometryObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractGeometrySimpleExtensionGroup;
    property AbstractGeometryObjectExtensionGroup: IXMLString_List read Get_AbstractGeometryObjectExtensionGroup;
  end;

{ IXMLAbstractGeometryTypeList }

  IXMLAbstractGeometryTypeList = interface(IXMLNodeCollection)
    ['{F8DBAEA0-A88B-4988-AB33-A8B1626FF66E}']
    { Methods & Properties }
    function Add: IXMLAbstractGeometryType;
    function Insert(const Index: Integer): IXMLAbstractGeometryType;

    function Get_Item(Index: Integer): IXMLAbstractGeometryType;
    property Items[Index: Integer]: IXMLAbstractGeometryType read Get_Item; default;
  end;

{ IXMLAbstractOverlayType }

  IXMLAbstractOverlayType = interface(IXMLAbstractFeatureType)
    ['{0659BFA5-DFE1-4876-9D11-5DF79A14FCEE}']
    { Property Accessors }
    function Get_Color: UnicodeString;
    function Get_DrawOrder: Integer;
    function Get_Icon: IXMLLinkType;
    function Get_AbstractOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractOverlayObjectExtensionGroup: IXMLString_List;
    procedure Set_Color(Value: UnicodeString);
    procedure Set_DrawOrder(Value: Integer);
    { Methods & Properties }
    property Color: UnicodeString read Get_Color write Set_Color;
    property DrawOrder: Integer read Get_DrawOrder write Set_DrawOrder;
    property Icon: IXMLLinkType read Get_Icon;
    property AbstractOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractOverlaySimpleExtensionGroup;
    property AbstractOverlayObjectExtensionGroup: IXMLString_List read Get_AbstractOverlayObjectExtensionGroup;
  end;

{ IXMLBasicLinkType }

  IXMLBasicLinkType = interface(IXMLAbstractObjectType)
    ['{5D8EF127-C233-4092-8765-CA5D04CFFC41}']
    { Property Accessors }
    function Get_Href: UnicodeString;
    function Get_BasicLinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_BasicLinkObjectExtensionGroup: IXMLString_List;
    procedure Set_Href(Value: UnicodeString);
    { Methods & Properties }
    property Href: UnicodeString read Get_Href write Set_Href;
    property BasicLinkSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_BasicLinkSimpleExtensionGroup;
    property BasicLinkObjectExtensionGroup: IXMLString_List read Get_BasicLinkObjectExtensionGroup;
  end;

{ IXMLLinkType }

  IXMLLinkType = interface(IXMLBasicLinkType)
    ['{517F13BB-87CF-4437-A1B1-922989D6498E}']
    { Property Accessors }
    function Get_AbstractRefreshMode: UnicodeString;
    function Get_RefreshInterval: Double;
    function Get_AbstractViewRefreshMode: UnicodeString;
    function Get_ViewRefreshTime: Double;
    function Get_ViewBoundScale: Double;
    function Get_ViewFormat: UnicodeString;
    function Get_HttpQuery: UnicodeString;
    function Get_LinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LinkObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractRefreshMode(Value: UnicodeString);
    procedure Set_RefreshInterval(Value: Double);
    procedure Set_AbstractViewRefreshMode(Value: UnicodeString);
    procedure Set_ViewRefreshTime(Value: Double);
    procedure Set_ViewBoundScale(Value: Double);
    procedure Set_ViewFormat(Value: UnicodeString);
    procedure Set_HttpQuery(Value: UnicodeString);
    { Methods & Properties }
    property AbstractRefreshMode: UnicodeString read Get_AbstractRefreshMode write Set_AbstractRefreshMode;
    property RefreshInterval: Double read Get_RefreshInterval write Set_RefreshInterval;
    property AbstractViewRefreshMode: UnicodeString read Get_AbstractViewRefreshMode write Set_AbstractViewRefreshMode;
    property ViewRefreshTime: Double read Get_ViewRefreshTime write Set_ViewRefreshTime;
    property ViewBoundScale: Double read Get_ViewBoundScale write Set_ViewBoundScale;
    property ViewFormat: UnicodeString read Get_ViewFormat write Set_ViewFormat;
    property HttpQuery: UnicodeString read Get_HttpQuery write Set_HttpQuery;
    property LinkSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LinkSimpleExtensionGroup;
    property LinkObjectExtensionGroup: IXMLString_List read Get_LinkObjectExtensionGroup;
  end;

{ IXMLKmlType }

  IXMLKmlType = interface(IXMLNode)
    ['{62A1DDA6-91A4-49F3-905E-35B6EF02D4D7}']
    { Property Accessors }
    function Get_Hint: UnicodeString;
    function Get_Version: UnicodeString;
    function Get_NetworkLinkControl: IXMLNetworkLinkControlType;
    function Get_AbstractFeatureGroup: IXMLAbstractFeatureType;
    function Get_KmlSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_KmlObjectExtensionGroup: IXMLString_List;
    procedure Set_Hint(Value: UnicodeString);
    procedure Set_Version(Value: UnicodeString);
    { Methods & Properties }
    property Hint: UnicodeString read Get_Hint write Set_Hint;
    property Version: UnicodeString read Get_Version write Set_Version;
    property NetworkLinkControl: IXMLNetworkLinkControlType read Get_NetworkLinkControl;
    property AbstractFeatureGroup: IXMLAbstractFeatureType read Get_AbstractFeatureGroup;
    property KmlSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_KmlSimpleExtensionGroup;
    property KmlObjectExtensionGroup: IXMLString_List read Get_KmlObjectExtensionGroup;
  end;

{ IXMLNetworkLinkControlType }

  IXMLNetworkLinkControlType = interface(IXMLNode)
    ['{27308C58-5B74-4C6E-A357-E49BF4F49CA7}']
    { Property Accessors }
    function Get_MinRefreshPeriod: Double;
    function Get_MaxSessionLength: Double;
    function Get_Cookie: UnicodeString;
    function Get_Message: UnicodeString;
    function Get_LinkName: UnicodeString;
    function Get_LinkDescription: UnicodeString;
    function Get_LinkSnippet: IXMLSnippetType;
    function Get_Expires: UnicodeString;
    function Get_Update: IXMLUpdateType;
    function Get_AbstractViewGroup: IXMLAbstractViewType;
    function Get_NetworkLinkControlSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_NetworkLinkControlObjectExtensionGroup: IXMLString_List;
    procedure Set_MinRefreshPeriod(Value: Double);
    procedure Set_MaxSessionLength(Value: Double);
    procedure Set_Cookie(Value: UnicodeString);
    procedure Set_Message(Value: UnicodeString);
    procedure Set_LinkName(Value: UnicodeString);
    procedure Set_LinkDescription(Value: UnicodeString);
    procedure Set_Expires(Value: UnicodeString);
    { Methods & Properties }
    property MinRefreshPeriod: Double read Get_MinRefreshPeriod write Set_MinRefreshPeriod;
    property MaxSessionLength: Double read Get_MaxSessionLength write Set_MaxSessionLength;
    property Cookie: UnicodeString read Get_Cookie write Set_Cookie;
    property Message: UnicodeString read Get_Message write Set_Message;
    property LinkName: UnicodeString read Get_LinkName write Set_LinkName;
    property LinkDescription: UnicodeString read Get_LinkDescription write Set_LinkDescription;
    property LinkSnippet: IXMLSnippetType read Get_LinkSnippet;
    property Expires: UnicodeString read Get_Expires write Set_Expires;
    property Update: IXMLUpdateType read Get_Update;
    property AbstractViewGroup: IXMLAbstractViewType read Get_AbstractViewGroup;
    property NetworkLinkControlSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_NetworkLinkControlSimpleExtensionGroup;
    property NetworkLinkControlObjectExtensionGroup: IXMLString_List read Get_NetworkLinkControlObjectExtensionGroup;
  end;

{ IXMLUpdateType }

  IXMLUpdateType = interface(IXMLNode)
    ['{14639648-7797-4B0E-9779-330E646B944C}']
    { Property Accessors }
    function Get_TargetHref: UnicodeString;
    function Get_AbstractUpdateOptionGroup: IXMLAnyTypeList;
    function Get_UpdateExtensionGroup: IXMLString_List;
    procedure Set_TargetHref(Value: UnicodeString);
    { Methods & Properties }
    property TargetHref: UnicodeString read Get_TargetHref write Set_TargetHref;
    property AbstractUpdateOptionGroup: IXMLAnyTypeList read Get_AbstractUpdateOptionGroup;
    property UpdateExtensionGroup: IXMLString_List read Get_UpdateExtensionGroup;
  end;

{ IXMLDocumentType }

  IXMLDocumentType = interface(IXMLAbstractContainerType)
    ['{2FCA9F10-BB3B-44BC-A020-4D446260552D}']
    { Property Accessors }
    function Get_Schema: IXMLSchemaTypeList;
    function Get_AbstractFeatureGroup: IXMLAbstractFeatureTypeList;
    function Get_DocumentSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_DocumentObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property Schema: IXMLSchemaTypeList read Get_Schema;
    property AbstractFeatureGroup: IXMLAbstractFeatureTypeList read Get_AbstractFeatureGroup;
    property DocumentSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_DocumentSimpleExtensionGroup;
    property DocumentObjectExtensionGroup: IXMLString_List read Get_DocumentObjectExtensionGroup;
  end;

{ IXMLSchemaType }

  IXMLSchemaType = interface(IXMLNode)
    ['{38F32EC9-5B1F-476A-BCB8-4E08562AA03A}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Id: UnicodeString;
    function Get_SimpleField: IXMLSimpleFieldTypeList;
    function Get_SimpleArrayField: IXMLSimpleArrayFieldTypeList;
    function Get_SchemaExtension: IXMLString_List;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Id(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Id: UnicodeString read Get_Id write Set_Id;
    property SimpleField: IXMLSimpleFieldTypeList read Get_SimpleField;
    property SimpleArrayField: IXMLSimpleArrayFieldTypeList read Get_SimpleArrayField;
    property SchemaExtension: IXMLString_List read Get_SchemaExtension;
  end;

{ IXMLSchemaTypeList }

  IXMLSchemaTypeList = interface(IXMLNodeCollection)
    ['{B7569CB6-6C35-4E77-802D-D60CE2EEE4FE}']
    { Methods & Properties }
    function Add: IXMLSchemaType;
    function Insert(const Index: Integer): IXMLSchemaType;

    function Get_Item(Index: Integer): IXMLSchemaType;
    property Items[Index: Integer]: IXMLSchemaType read Get_Item; default;
  end;

{ IXMLSimpleFieldType }

  IXMLSimpleFieldType = interface(IXMLNode)
    ['{66E26818-ECA4-4692-A808-3EF63B03A112}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_Uom: UnicodeString;
    function Get_DisplayName: UnicodeString;
    function Get_SimpleFieldExtension: IXMLString_List;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_DisplayName(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Name: UnicodeString read Get_Name write Set_Name;
    property Uom: UnicodeString read Get_Uom write Set_Uom;
    property DisplayName: UnicodeString read Get_DisplayName write Set_DisplayName;
    property SimpleFieldExtension: IXMLString_List read Get_SimpleFieldExtension;
  end;

{ IXMLSimpleFieldTypeList }

  IXMLSimpleFieldTypeList = interface(IXMLNodeCollection)
    ['{9726D6D7-6D0F-4F14-A74B-33F7AD7EA730}']
    { Methods & Properties }
    function Add: IXMLSimpleFieldType;
    function Insert(const Index: Integer): IXMLSimpleFieldType;

    function Get_Item(Index: Integer): IXMLSimpleFieldType;
    property Items[Index: Integer]: IXMLSimpleFieldType read Get_Item; default;
  end;

{ IXMLSimpleArrayFieldType }

  IXMLSimpleArrayFieldType = interface(IXMLNode)
    ['{43D7A07D-6F40-46C0-BCFC-BD9A5EBF0288}']
    { Property Accessors }
    function Get_Type_: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_Uom: UnicodeString;
    function Get_DisplayName: UnicodeString;
    function Get_SimpleArrayFieldExtension: IXMLString_List;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_DisplayName(Value: UnicodeString);
    { Methods & Properties }
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property Name: UnicodeString read Get_Name write Set_Name;
    property Uom: UnicodeString read Get_Uom write Set_Uom;
    property DisplayName: UnicodeString read Get_DisplayName write Set_DisplayName;
    property SimpleArrayFieldExtension: IXMLString_List read Get_SimpleArrayFieldExtension;
  end;

{ IXMLSimpleArrayFieldTypeList }

  IXMLSimpleArrayFieldTypeList = interface(IXMLNodeCollection)
    ['{9B457560-1EE2-4B80-9725-63029FBD4517}']
    { Methods & Properties }
    function Add: IXMLSimpleArrayFieldType;
    function Insert(const Index: Integer): IXMLSimpleArrayFieldType;

    function Get_Item(Index: Integer): IXMLSimpleArrayFieldType;
    property Items[Index: Integer]: IXMLSimpleArrayFieldType read Get_Item; default;
  end;

{ IXMLFolderType }

  IXMLFolderType = interface(IXMLAbstractContainerType)
    ['{C07ACB6F-442B-48B1-9F98-803B1F6D270C}']
    { Property Accessors }
    function Get_AbstractFeatureGroup: IXMLAbstractFeatureTypeList;
    function Get_FolderSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_FolderObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractFeatureGroup: IXMLAbstractFeatureTypeList read Get_AbstractFeatureGroup;
    property FolderSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_FolderSimpleExtensionGroup;
    property FolderObjectExtensionGroup: IXMLString_List read Get_FolderObjectExtensionGroup;
  end;

{ IXMLPlacemarkType }

  IXMLPlacemarkType = interface(IXMLAbstractFeatureType)
    ['{688A89FE-B2CD-4216-BA74-DAB169D2E4E8}']
    { Property Accessors }
    function Get_AbstractGeometryGroup: IXMLAbstractGeometryType;
    function Get_PlacemarkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PlacemarkObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractGeometryGroup: IXMLAbstractGeometryType read Get_AbstractGeometryGroup;
    property PlacemarkSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_PlacemarkSimpleExtensionGroup;
    property PlacemarkObjectExtensionGroup: IXMLString_List read Get_PlacemarkObjectExtensionGroup;
  end;

{ IXMLNetworkLinkType }

  IXMLNetworkLinkType = interface(IXMLAbstractFeatureType)
    ['{04539327-28A8-453D-9D30-75DD5B1CF633}']
    { Property Accessors }
    function Get_RefreshVisibility: Boolean;
    function Get_FlyToView: Boolean;
    function Get_AbstractLinkGroup: IXMLAbstractObjectType;
    function Get_NetworkLinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_NetworkLinkObjectExtensionGroup: IXMLString_List;
    procedure Set_RefreshVisibility(Value: Boolean);
    procedure Set_FlyToView(Value: Boolean);
    { Methods & Properties }
    property RefreshVisibility: Boolean read Get_RefreshVisibility write Set_RefreshVisibility;
    property FlyToView: Boolean read Get_FlyToView write Set_FlyToView;
    property AbstractLinkGroup: IXMLAbstractObjectType read Get_AbstractLinkGroup;
    property NetworkLinkSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_NetworkLinkSimpleExtensionGroup;
    property NetworkLinkObjectExtensionGroup: IXMLString_List read Get_NetworkLinkObjectExtensionGroup;
  end;

{ IXMLAbstractLatLonBoxType }

  IXMLAbstractLatLonBoxType = interface(IXMLAbstractExtentType)
    ['{CA9E39A7-0FEB-48ED-9DD6-3FD770DDE3D2}']
    { Property Accessors }
    function Get_North: Double;
    function Get_South: Double;
    function Get_East: Double;
    function Get_West: Double;
    function Get_AbstractLatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractLatLonBoxObjectExtensionGroup: IXMLString_List;
    procedure Set_North(Value: Double);
    procedure Set_South(Value: Double);
    procedure Set_East(Value: Double);
    procedure Set_West(Value: Double);
    { Methods & Properties }
    property North: Double read Get_North write Set_North;
    property South: Double read Get_South write Set_South;
    property East: Double read Get_East write Set_East;
    property West: Double read Get_West write Set_West;
    property AbstractLatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractLatLonBoxSimpleExtensionGroup;
    property AbstractLatLonBoxObjectExtensionGroup: IXMLString_List read Get_AbstractLatLonBoxObjectExtensionGroup;
  end;

{ IXMLLatLonAltBoxType }

  IXMLLatLonAltBoxType = interface(IXMLAbstractLatLonBoxType)
    ['{B5ECA08B-D025-4354-AD3A-B713DB27C414}']
    { Property Accessors }
    function Get_MinAltitude: Double;
    function Get_MaxAltitude: Double;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_LatLonAltBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LatLonAltBoxObjectExtensionGroup: IXMLString_List;
    procedure Set_MinAltitude(Value: Double);
    procedure Set_MaxAltitude(Value: Double);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    { Methods & Properties }
    property MinAltitude: Double read Get_MinAltitude write Set_MinAltitude;
    property MaxAltitude: Double read Get_MaxAltitude write Set_MaxAltitude;
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property LatLonAltBoxSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LatLonAltBoxSimpleExtensionGroup;
    property LatLonAltBoxObjectExtensionGroup: IXMLString_List read Get_LatLonAltBoxObjectExtensionGroup;
  end;

{ IXMLMultiGeometryType }

  IXMLMultiGeometryType = interface(IXMLAbstractGeometryType)
    ['{C94380A7-9D40-430E-A992-A26EA4ED8448}']
    { Property Accessors }
    function Get_AbstractGeometryGroup: IXMLAbstractGeometryTypeList;
    function Get_MultiGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_MultiGeometryObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractGeometryGroup: IXMLAbstractGeometryTypeList read Get_AbstractGeometryGroup;
    property MultiGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList read Get_MultiGeometrySimpleExtensionGroup;
    property MultiGeometryObjectExtensionGroup: IXMLString_List read Get_MultiGeometryObjectExtensionGroup;
  end;

{ IXMLMultiGeometryTypeList }

  IXMLMultiGeometryTypeList = interface(IXMLNodeCollection)
    ['{154A8CF9-8078-4716-95B3-E526201117EF}']
    { Methods & Properties }
    function Add: IXMLMultiGeometryType;
    function Insert(const Index: Integer): IXMLMultiGeometryType;

    function Get_Item(Index: Integer): IXMLMultiGeometryType;
    property Items[Index: Integer]: IXMLMultiGeometryType read Get_Item; default;
  end;

{ IXMLPointType }

  IXMLPointType = interface(IXMLAbstractGeometryType)
    ['{8FA3A519-BF7E-48EB-BCEF-9853DE73A202}']
    { Property Accessors }
    function Get_Extrude: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Coordinates: UnicodeString;
    function Get_PointSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PointObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_Coordinates(Value: UnicodeString);
    { Methods & Properties }
    property Extrude: Boolean read Get_Extrude write Set_Extrude;
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property Coordinates: UnicodeString read Get_Coordinates write Set_Coordinates;
    property PointSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_PointSimpleExtensionGroup;
    property PointObjectExtensionGroup: IXMLString_List read Get_PointObjectExtensionGroup;
  end;

{ IXMLLineStringType }

  IXMLLineStringType = interface(IXMLAbstractGeometryType)
    ['{38720908-B88E-45E5-8006-BB92536DF66E}']
    { Property Accessors }
    function Get_Extrude: Boolean;
    function Get_Tessellate: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Coordinates: UnicodeString;
    function Get_AltitudeOffset: Double;
    function Get_LineStringSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LineStringObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_Tessellate(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_Coordinates(Value: UnicodeString);
    procedure Set_AltitudeOffset(Value: Double);
    { Methods & Properties }
    property Extrude: Boolean read Get_Extrude write Set_Extrude;
    property Tessellate: Boolean read Get_Tessellate write Set_Tessellate;
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property Coordinates: UnicodeString read Get_Coordinates write Set_Coordinates;
    property AltitudeOffset: Double read Get_AltitudeOffset write Set_AltitudeOffset;
    property LineStringSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LineStringSimpleExtensionGroup;
    property LineStringObjectExtensionGroup: IXMLString_List read Get_LineStringObjectExtensionGroup;
  end;

{ IXMLLinearRingType }

  IXMLLinearRingType = interface(IXMLAbstractGeometryType)
    ['{6B6299A8-82D0-4826-A481-895BFFC9037A}']
    { Property Accessors }
    function Get_Extrude: Boolean;
    function Get_Tessellate: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Coordinates: UnicodeString;
    function Get_AltitudeOffset: Double;
    function Get_LinearRingSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LinearRingObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_Tessellate(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_Coordinates(Value: UnicodeString);
    procedure Set_AltitudeOffset(Value: Double);
    { Methods & Properties }
    property Extrude: Boolean read Get_Extrude write Set_Extrude;
    property Tessellate: Boolean read Get_Tessellate write Set_Tessellate;
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property Coordinates: UnicodeString read Get_Coordinates write Set_Coordinates;
    property AltitudeOffset: Double read Get_AltitudeOffset write Set_AltitudeOffset;
    property LinearRingSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LinearRingSimpleExtensionGroup;
    property LinearRingObjectExtensionGroup: IXMLString_List read Get_LinearRingObjectExtensionGroup;
  end;

{ IXMLPolygonType }

  IXMLPolygonType = interface(IXMLAbstractGeometryType)
    ['{8A789FD7-7115-42C9-BBEA-0F30085BB0A9}']
    { Property Accessors }
    function Get_Extrude: Boolean;
    function Get_Tessellate: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_OuterBoundaryIs: IXMLBoundaryType;
    function Get_InnerBoundaryIs: IXMLBoundaryTypeList;
    function Get_PolygonSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PolygonObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_Tessellate(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    { Methods & Properties }
    property Extrude: Boolean read Get_Extrude write Set_Extrude;
    property Tessellate: Boolean read Get_Tessellate write Set_Tessellate;
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property OuterBoundaryIs: IXMLBoundaryType read Get_OuterBoundaryIs;
    property InnerBoundaryIs: IXMLBoundaryTypeList read Get_InnerBoundaryIs;
    property PolygonSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_PolygonSimpleExtensionGroup;
    property PolygonObjectExtensionGroup: IXMLString_List read Get_PolygonObjectExtensionGroup;
  end;

{ IXMLBoundaryType }

  IXMLBoundaryType = interface(IXMLNode)
    ['{6160E555-7B5E-4152-A745-F81315934480}']
    { Property Accessors }
    function Get_LinearRing: IXMLLinearRingType;
    function Get_BoundarySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_BoundaryObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property LinearRing: IXMLLinearRingType read Get_LinearRing;
    property BoundarySimpleExtensionGroup: IXMLAnySimpleTypeList read Get_BoundarySimpleExtensionGroup;
    property BoundaryObjectExtensionGroup: IXMLString_List read Get_BoundaryObjectExtensionGroup;
  end;

{ IXMLBoundaryTypeList }

  IXMLBoundaryTypeList = interface(IXMLNodeCollection)
    ['{CAFBCB74-21DD-4F84-A106-B87CFCA6EFEE}']
    { Methods & Properties }
    function Add: IXMLBoundaryType;
    function Insert(const Index: Integer): IXMLBoundaryType;

    function Get_Item(Index: Integer): IXMLBoundaryType;
    property Items[Index: Integer]: IXMLBoundaryType read Get_Item; default;
  end;

{ IXMLModelType }

  IXMLModelType = interface(IXMLAbstractGeometryType)
    ['{E19FF118-0BD9-4D0A-A0C2-4F3A0B9F4A56}']
    { Property Accessors }
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Location: IXMLLocationType;
    function Get_Orientation: IXMLOrientationType;
    function Get_Scale: IXMLScaleType;
    function Get_Link: IXMLLinkType;
    function Get_ResourceMap: IXMLResourceMapType;
    function Get_ModelSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ModelObjectExtensionGroup: IXMLString_List;
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    { Methods & Properties }
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property Location: IXMLLocationType read Get_Location;
    property Orientation: IXMLOrientationType read Get_Orientation;
    property Scale: IXMLScaleType read Get_Scale;
    property Link: IXMLLinkType read Get_Link;
    property ResourceMap: IXMLResourceMapType read Get_ResourceMap;
    property ModelSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_ModelSimpleExtensionGroup;
    property ModelObjectExtensionGroup: IXMLString_List read Get_ModelObjectExtensionGroup;
  end;

{ IXMLLocationType }

  IXMLLocationType = interface(IXMLAbstractObjectType)
    ['{80002AFE-A9FA-4E6A-8CEE-F8A61E95E271}']
    { Property Accessors }
    function Get_Longitude: Double;
    function Get_Latitude: Double;
    function Get_Altitude: Double;
    function Get_LocationSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LocationObjectExtensionGroup: IXMLString_List;
    procedure Set_Longitude(Value: Double);
    procedure Set_Latitude(Value: Double);
    procedure Set_Altitude(Value: Double);
    { Methods & Properties }
    property Longitude: Double read Get_Longitude write Set_Longitude;
    property Latitude: Double read Get_Latitude write Set_Latitude;
    property Altitude: Double read Get_Altitude write Set_Altitude;
    property LocationSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LocationSimpleExtensionGroup;
    property LocationObjectExtensionGroup: IXMLString_List read Get_LocationObjectExtensionGroup;
  end;

{ IXMLOrientationType }

  IXMLOrientationType = interface(IXMLAbstractObjectType)
    ['{1154CBB8-29F9-4F04-9E4B-213D1AF024B1}']
    { Property Accessors }
    function Get_Heading: Double;
    function Get_Tilt: Double;
    function Get_Roll: Double;
    function Get_OrientationSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_OrientationObjectExtensionGroup: IXMLString_List;
    procedure Set_Heading(Value: Double);
    procedure Set_Tilt(Value: Double);
    procedure Set_Roll(Value: Double);
    { Methods & Properties }
    property Heading: Double read Get_Heading write Set_Heading;
    property Tilt: Double read Get_Tilt write Set_Tilt;
    property Roll: Double read Get_Roll write Set_Roll;
    property OrientationSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_OrientationSimpleExtensionGroup;
    property OrientationObjectExtensionGroup: IXMLString_List read Get_OrientationObjectExtensionGroup;
  end;

{ IXMLScaleType }

  IXMLScaleType = interface(IXMLAbstractObjectType)
    ['{0991064D-95D5-44C8-8E7F-CCFE8404A005}']
    { Property Accessors }
    function Get_X: Double;
    function Get_Y: Double;
    function Get_Z: Double;
    function Get_ScaleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ScaleObjectExtensionGroup: IXMLString_List;
    procedure Set_X(Value: Double);
    procedure Set_Y(Value: Double);
    procedure Set_Z(Value: Double);
    { Methods & Properties }
    property X: Double read Get_X write Set_X;
    property Y: Double read Get_Y write Set_Y;
    property Z: Double read Get_Z write Set_Z;
    property ScaleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_ScaleSimpleExtensionGroup;
    property ScaleObjectExtensionGroup: IXMLString_List read Get_ScaleObjectExtensionGroup;
  end;

{ IXMLResourceMapType }

  IXMLResourceMapType = interface(IXMLAbstractObjectType)
    ['{9A151333-66E5-4D03-8FA6-02A176979A4E}']
    { Property Accessors }
    function Get_Alias: IXMLAliasTypeList;
    function Get_ResourceMapSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ResourceMapObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property Alias: IXMLAliasTypeList read Get_Alias;
    property ResourceMapSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_ResourceMapSimpleExtensionGroup;
    property ResourceMapObjectExtensionGroup: IXMLString_List read Get_ResourceMapObjectExtensionGroup;
  end;

{ IXMLAliasType }

  IXMLAliasType = interface(IXMLAbstractObjectType)
    ['{65F6CFAE-A764-48A7-82E1-C1C6D4236E51}']
    { Property Accessors }
    function Get_TargetHref: UnicodeString;
    function Get_SourceHref: UnicodeString;
    function Get_AliasSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AliasObjectExtensionGroup: IXMLString_List;
    procedure Set_TargetHref(Value: UnicodeString);
    procedure Set_SourceHref(Value: UnicodeString);
    { Methods & Properties }
    property TargetHref: UnicodeString read Get_TargetHref write Set_TargetHref;
    property SourceHref: UnicodeString read Get_SourceHref write Set_SourceHref;
    property AliasSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AliasSimpleExtensionGroup;
    property AliasObjectExtensionGroup: IXMLString_List read Get_AliasObjectExtensionGroup;
  end;

{ IXMLAliasTypeList }

  IXMLAliasTypeList = interface(IXMLNodeCollection)
    ['{46FDB5A4-DFA9-49AF-BC21-D8E6A8E5A3C7}']
    { Methods & Properties }
    function Add: IXMLAliasType;
    function Insert(const Index: Integer): IXMLAliasType;

    function Get_Item(Index: Integer): IXMLAliasType;
    property Items[Index: Integer]: IXMLAliasType read Get_Item; default;
  end;

{ IXMLTrackType }

  IXMLTrackType = interface(IXMLAbstractGeometryType)
    ['{3E4FE52A-8268-4741-84DD-E5D840983579}']
    { Property Accessors }
    function Get_Extrude: Boolean;
    function Get_Tessellate: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_When: IXMLDateTimeTypeList;
    function Get_Coord: IXMLString_List;
    function Get_Angles: IXMLString_List;
    function Get_Model: IXMLModelType;
    function Get_ExtendedData: IXMLExtendedDataType;
    function Get_TrackSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TrackObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_Tessellate(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    { Methods & Properties }
    property Extrude: Boolean read Get_Extrude write Set_Extrude;
    property Tessellate: Boolean read Get_Tessellate write Set_Tessellate;
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property When: IXMLDateTimeTypeList read Get_When;
    property Coord: IXMLString_List read Get_Coord;
    property Angles: IXMLString_List read Get_Angles;
    property Model: IXMLModelType read Get_Model;
    property ExtendedData: IXMLExtendedDataType read Get_ExtendedData;
    property TrackSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_TrackSimpleExtensionGroup;
    property TrackObjectExtensionGroup: IXMLString_List read Get_TrackObjectExtensionGroup;
  end;

{ IXMLTrackTypeList }

  IXMLTrackTypeList = interface(IXMLNodeCollection)
    ['{D057F6A3-905A-4AAE-B38E-9404D43E53CF}']
    { Methods & Properties }
    function Add: IXMLTrackType;
    function Insert(const Index: Integer): IXMLTrackType;

    function Get_Item(Index: Integer): IXMLTrackType;
    property Items[Index: Integer]: IXMLTrackType read Get_Item; default;
  end;

{ IXMLMultiTrackType }

  IXMLMultiTrackType = interface(IXMLAbstractGeometryType)
    ['{BB14C902-0764-49AB-89A4-1372950E8CB4}']
    { Property Accessors }
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Interpolate: Boolean;
    function Get_Track: IXMLTrackTypeList;
    function Get_MultiTrackSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_MultiTrackObjectExtensionGroup: IXMLString_List;
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_Interpolate(Value: Boolean);
    { Methods & Properties }
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property Interpolate: Boolean read Get_Interpolate write Set_Interpolate;
    property Track: IXMLTrackTypeList read Get_Track;
    property MultiTrackSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_MultiTrackSimpleExtensionGroup;
    property MultiTrackObjectExtensionGroup: IXMLString_List read Get_MultiTrackObjectExtensionGroup;
  end;

{ IXMLMultiTrackTypeList }

  IXMLMultiTrackTypeList = interface(IXMLNodeCollection)
    ['{7DB204D6-1E58-4634-BD7A-5F83F8AB8028}']
    { Methods & Properties }
    function Add: IXMLMultiTrackType;
    function Insert(const Index: Integer): IXMLMultiTrackType;

    function Get_Item(Index: Integer): IXMLMultiTrackType;
    property Items[Index: Integer]: IXMLMultiTrackType read Get_Item; default;
  end;

{ IXMLGroundOverlayType }

  IXMLGroundOverlayType = interface(IXMLAbstractOverlayType)
    ['{C202AB50-E9DA-457A-A437-E1295214DE1A}']
    { Property Accessors }
    function Get_Altitude: Double;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_AbstractExtentGroup: IXMLAbstractExtentType;
    function Get_GroundOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_GroundOverlayObjectExtensionGroup: IXMLString_List;
    procedure Set_Altitude(Value: Double);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    { Methods & Properties }
    property Altitude: Double read Get_Altitude write Set_Altitude;
    property AltitudeMode: UnicodeString read Get_AltitudeMode write Set_AltitudeMode;
    property SeaFloorAltitudeMode: UnicodeString read Get_SeaFloorAltitudeMode write Set_SeaFloorAltitudeMode;
    property AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AltitudeModeSimpleExtensionGroup;
    property AltitudeModeObjectExtensionGroup: IXMLString_List read Get_AltitudeModeObjectExtensionGroup;
    property AbstractExtentGroup: IXMLAbstractExtentType read Get_AbstractExtentGroup;
    property GroundOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList read Get_GroundOverlaySimpleExtensionGroup;
    property GroundOverlayObjectExtensionGroup: IXMLString_List read Get_GroundOverlayObjectExtensionGroup;
  end;

{ IXMLLatLonQuadType }

  IXMLLatLonQuadType = interface(IXMLAbstractExtentType)
    ['{3072F19A-A1B3-4DFA-A9FD-3DD3F3D037D7}']
    { Property Accessors }
    function Get_Coordinates: UnicodeString;
    function Get_LatLonQuadSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LatLonQuadObjectExtensionGroup: IXMLString_List;
    procedure Set_Coordinates(Value: UnicodeString);
    { Methods & Properties }
    property Coordinates: UnicodeString read Get_Coordinates write Set_Coordinates;
    property LatLonQuadSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LatLonQuadSimpleExtensionGroup;
    property LatLonQuadObjectExtensionGroup: IXMLString_List read Get_LatLonQuadObjectExtensionGroup;
  end;

{ IXMLLatLonBoxType }

  IXMLLatLonBoxType = interface(IXMLAbstractLatLonBoxType)
    ['{FABAF8DB-CC6F-43CE-830F-468F8BE12603}']
    { Property Accessors }
    function Get_Rotation: Double;
    function Get_LatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LatLonBoxObjectExtensionGroup: IXMLString_List;
    procedure Set_Rotation(Value: Double);
    { Methods & Properties }
    property Rotation: Double read Get_Rotation write Set_Rotation;
    property LatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LatLonBoxSimpleExtensionGroup;
    property LatLonBoxObjectExtensionGroup: IXMLString_List read Get_LatLonBoxObjectExtensionGroup;
  end;

{ IXMLScreenOverlayType }

  IXMLScreenOverlayType = interface(IXMLAbstractOverlayType)
    ['{6A9594C6-A182-4A93-9983-869AD7152938}']
    { Property Accessors }
    function Get_OverlayXY: IXMLVec2Type;
    function Get_ScreenXY: IXMLVec2Type;
    function Get_RotationXY: IXMLVec2Type;
    function Get_Size: IXMLVec2Type;
    function Get_Rotation: Double;
    function Get_ScreenOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ScreenOverlayObjectExtensionGroup: IXMLString_List;
    procedure Set_Rotation(Value: Double);
    { Methods & Properties }
    property OverlayXY: IXMLVec2Type read Get_OverlayXY;
    property ScreenXY: IXMLVec2Type read Get_ScreenXY;
    property RotationXY: IXMLVec2Type read Get_RotationXY;
    property Size: IXMLVec2Type read Get_Size;
    property Rotation: Double read Get_Rotation write Set_Rotation;
    property ScreenOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList read Get_ScreenOverlaySimpleExtensionGroup;
    property ScreenOverlayObjectExtensionGroup: IXMLString_List read Get_ScreenOverlayObjectExtensionGroup;
  end;

{ IXMLPhotoOverlayType }

  IXMLPhotoOverlayType = interface(IXMLAbstractOverlayType)
    ['{9D087264-99C3-4F68-A484-6F446D089BC0}']
    { Property Accessors }
    function Get_Rotation: Double;
    function Get_ViewVolume: IXMLViewVolumeType;
    function Get_ImagePyramid: IXMLImagePyramidType;
    function Get_Point: IXMLPointType;
    function Get_AbstractShape: UnicodeString;
    function Get_PhotoOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PhotoOverlayObjectExtensionGroup: IXMLString_List;
    procedure Set_Rotation(Value: Double);
    procedure Set_AbstractShape(Value: UnicodeString);
    { Methods & Properties }
    property Rotation: Double read Get_Rotation write Set_Rotation;
    property ViewVolume: IXMLViewVolumeType read Get_ViewVolume;
    property ImagePyramid: IXMLImagePyramidType read Get_ImagePyramid;
    property Point: IXMLPointType read Get_Point;
    property AbstractShape: UnicodeString read Get_AbstractShape write Set_AbstractShape;
    property PhotoOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList read Get_PhotoOverlaySimpleExtensionGroup;
    property PhotoOverlayObjectExtensionGroup: IXMLString_List read Get_PhotoOverlayObjectExtensionGroup;
  end;

{ IXMLViewVolumeType }

  IXMLViewVolumeType = interface(IXMLAbstractObjectType)
    ['{7D57D47D-7724-4FDB-98BB-A39DF12AF9A3}']
    { Property Accessors }
    function Get_LeftFov: Double;
    function Get_RightFov: Double;
    function Get_BottomFov: Double;
    function Get_TopFov: Double;
    function Get_Near: Double;
    function Get_ViewVolumeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ViewVolumeObjectExtensionGroup: IXMLString_List;
    procedure Set_LeftFov(Value: Double);
    procedure Set_RightFov(Value: Double);
    procedure Set_BottomFov(Value: Double);
    procedure Set_TopFov(Value: Double);
    procedure Set_Near(Value: Double);
    { Methods & Properties }
    property LeftFov: Double read Get_LeftFov write Set_LeftFov;
    property RightFov: Double read Get_RightFov write Set_RightFov;
    property BottomFov: Double read Get_BottomFov write Set_BottomFov;
    property TopFov: Double read Get_TopFov write Set_TopFov;
    property Near: Double read Get_Near write Set_Near;
    property ViewVolumeSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_ViewVolumeSimpleExtensionGroup;
    property ViewVolumeObjectExtensionGroup: IXMLString_List read Get_ViewVolumeObjectExtensionGroup;
  end;

{ IXMLImagePyramidType }

  IXMLImagePyramidType = interface(IXMLAbstractObjectType)
    ['{826FEBB3-4505-4BD7-A6C8-AB5137636150}']
    { Property Accessors }
    function Get_TileSize: Integer;
    function Get_MaxWidth: Integer;
    function Get_MaxHeight: Integer;
    function Get_AbstractGridOrigin: UnicodeString;
    function Get_ImagePyramidSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ImagePyramidObjectExtensionGroup: IXMLString_List;
    procedure Set_TileSize(Value: Integer);
    procedure Set_MaxWidth(Value: Integer);
    procedure Set_MaxHeight(Value: Integer);
    procedure Set_AbstractGridOrigin(Value: UnicodeString);
    { Methods & Properties }
    property TileSize: Integer read Get_TileSize write Set_TileSize;
    property MaxWidth: Integer read Get_MaxWidth write Set_MaxWidth;
    property MaxHeight: Integer read Get_MaxHeight write Set_MaxHeight;
    property AbstractGridOrigin: UnicodeString read Get_AbstractGridOrigin write Set_AbstractGridOrigin;
    property ImagePyramidSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_ImagePyramidSimpleExtensionGroup;
    property ImagePyramidObjectExtensionGroup: IXMLString_List read Get_ImagePyramidObjectExtensionGroup;
  end;

{ IXMLStyleType }

  IXMLStyleType = interface(IXMLAbstractStyleSelectorType)
    ['{70C5DFE5-F2A6-48EA-AF32-549F55A1F380}']
    { Property Accessors }
    function Get_IconStyle: IXMLIconStyleType;
    function Get_LabelStyle: IXMLLabelStyleType;
    function Get_LineStyle: IXMLLineStyleType;
    function Get_PolyStyle: IXMLPolyStyleType;
    function Get_BalloonStyle: IXMLBalloonStyleType;
    function Get_ListStyle: IXMLListStyleType;
    function Get_StyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_StyleObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property IconStyle: IXMLIconStyleType read Get_IconStyle;
    property LabelStyle: IXMLLabelStyleType read Get_LabelStyle;
    property LineStyle: IXMLLineStyleType read Get_LineStyle;
    property PolyStyle: IXMLPolyStyleType read Get_PolyStyle;
    property BalloonStyle: IXMLBalloonStyleType read Get_BalloonStyle;
    property ListStyle: IXMLListStyleType read Get_ListStyle;
    property StyleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_StyleSimpleExtensionGroup;
    property StyleObjectExtensionGroup: IXMLString_List read Get_StyleObjectExtensionGroup;
  end;

{ IXMLAbstractSubStyleType }

  IXMLAbstractSubStyleType = interface(IXMLAbstractObjectType)
    ['{90DF9175-C839-4C9C-9F59-E9F38AD3DFD6}']
    { Property Accessors }
    function Get_AbstractSubStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractSubStyleObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractSubStyleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractSubStyleSimpleExtensionGroup;
    property AbstractSubStyleObjectExtensionGroup: IXMLString_List read Get_AbstractSubStyleObjectExtensionGroup;
  end;

{ IXMLAbstractColorStyleType }

  IXMLAbstractColorStyleType = interface(IXMLAbstractSubStyleType)
    ['{2161172A-82B3-4C87-9F88-D013FC470663}']
    { Property Accessors }
    function Get_Color: UnicodeString;
    function Get_AbstractColorMode: UnicodeString;
    function Get_AbstractColorStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractColorStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Color(Value: UnicodeString);
    procedure Set_AbstractColorMode(Value: UnicodeString);
    { Methods & Properties }
    property Color: UnicodeString read Get_Color write Set_Color;
    property AbstractColorMode: UnicodeString read Get_AbstractColorMode write Set_AbstractColorMode;
    property AbstractColorStyleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractColorStyleSimpleExtensionGroup;
    property AbstractColorStyleObjectExtensionGroup: IXMLString_List read Get_AbstractColorStyleObjectExtensionGroup;
  end;

{ IXMLIconStyleType }

  IXMLIconStyleType = interface(IXMLAbstractColorStyleType)
    ['{371862ED-403E-4A27-A0B7-14224B2B2141}']
    { Property Accessors }
    function Get_Scale: Double;
    function Get_Heading: Double;
    function Get_Icon: IXMLBasicLinkType;
    function Get_HotSpot: IXMLVec2Type;
    function Get_IconStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_IconStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Scale(Value: Double);
    procedure Set_Heading(Value: Double);
    { Methods & Properties }
    property Scale: Double read Get_Scale write Set_Scale;
    property Heading: Double read Get_Heading write Set_Heading;
    property Icon: IXMLBasicLinkType read Get_Icon;
    property HotSpot: IXMLVec2Type read Get_HotSpot;
    property IconStyleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_IconStyleSimpleExtensionGroup;
    property IconStyleObjectExtensionGroup: IXMLString_List read Get_IconStyleObjectExtensionGroup;
  end;

{ IXMLLabelStyleType }

  IXMLLabelStyleType = interface(IXMLAbstractColorStyleType)
    ['{4C037FDB-A61D-4EBB-BDFC-3D4D10C68D5F}']
    { Property Accessors }
    function Get_Scale: Double;
    function Get_LabelStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LabelStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Scale(Value: Double);
    { Methods & Properties }
    property Scale: Double read Get_Scale write Set_Scale;
    property LabelStyleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LabelStyleSimpleExtensionGroup;
    property LabelStyleObjectExtensionGroup: IXMLString_List read Get_LabelStyleObjectExtensionGroup;
  end;

{ IXMLLineStyleType }

  IXMLLineStyleType = interface(IXMLAbstractColorStyleType)
    ['{B424E89E-FB41-45DB-AEF1-5A6CA2FABC32}']
    { Property Accessors }
    function Get_Width: Double;
    function Get_LineStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LineStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Width(Value: Double);
    { Methods & Properties }
    property Width: Double read Get_Width write Set_Width;
    property LineStyleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_LineStyleSimpleExtensionGroup;
    property LineStyleObjectExtensionGroup: IXMLString_List read Get_LineStyleObjectExtensionGroup;
  end;

{ IXMLPolyStyleType }

  IXMLPolyStyleType = interface(IXMLAbstractColorStyleType)
    ['{2BFF5803-0FD2-4B73-BDCE-5488B31601BA}']
    { Property Accessors }
    function Get_Fill: Boolean;
    function Get_Outline: Boolean;
    function Get_PolyStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PolyStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Fill(Value: Boolean);
    procedure Set_Outline(Value: Boolean);
    { Methods & Properties }
    property Fill: Boolean read Get_Fill write Set_Fill;
    property Outline: Boolean read Get_Outline write Set_Outline;
    property PolyStyleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_PolyStyleSimpleExtensionGroup;
    property PolyStyleObjectExtensionGroup: IXMLString_List read Get_PolyStyleObjectExtensionGroup;
  end;

{ IXMLBalloonStyleType }

  IXMLBalloonStyleType = interface(IXMLAbstractSubStyleType)
    ['{52F071F4-9F9D-46C8-B636-8BDA72A3B28A}']
    { Property Accessors }
    function Get_AbstractBgColorGroup: UnicodeString;
    function Get_TextColor: UnicodeString;
    function Get_Text: UnicodeString;
    function Get_AbstractDisplayMode: UnicodeString;
    function Get_BalloonStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_BalloonStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractBgColorGroup(Value: UnicodeString);
    procedure Set_TextColor(Value: UnicodeString);
    procedure Set_Text(Value: UnicodeString);
    procedure Set_AbstractDisplayMode(Value: UnicodeString);
    { Methods & Properties }
    property AbstractBgColorGroup: UnicodeString read Get_AbstractBgColorGroup write Set_AbstractBgColorGroup;
    property TextColor: UnicodeString read Get_TextColor write Set_TextColor;
    property Text: UnicodeString read Get_Text write Set_Text;
    property AbstractDisplayMode: UnicodeString read Get_AbstractDisplayMode write Set_AbstractDisplayMode;
    property BalloonStyleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_BalloonStyleSimpleExtensionGroup;
    property BalloonStyleObjectExtensionGroup: IXMLString_List read Get_BalloonStyleObjectExtensionGroup;
  end;

{ IXMLListStyleType }

  IXMLListStyleType = interface(IXMLAbstractSubStyleType)
    ['{F0620F3C-DE18-4A57-AA29-C73AD94FA46D}']
    { Property Accessors }
    function Get_AbstractListItemType: UnicodeString;
    function Get_BgColor: UnicodeString;
    function Get_ItemIcon: IXMLItemIconTypeList;
    function Get_MaxSnippetLines: Integer;
    function Get_ListStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ListStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractListItemType(Value: UnicodeString);
    procedure Set_BgColor(Value: UnicodeString);
    procedure Set_MaxSnippetLines(Value: Integer);
    { Methods & Properties }
    property AbstractListItemType: UnicodeString read Get_AbstractListItemType write Set_AbstractListItemType;
    property BgColor: UnicodeString read Get_BgColor write Set_BgColor;
    property ItemIcon: IXMLItemIconTypeList read Get_ItemIcon;
    property MaxSnippetLines: Integer read Get_MaxSnippetLines write Set_MaxSnippetLines;
    property ListStyleSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_ListStyleSimpleExtensionGroup;
    property ListStyleObjectExtensionGroup: IXMLString_List read Get_ListStyleObjectExtensionGroup;
  end;

{ IXMLItemIconType }

  IXMLItemIconType = interface(IXMLAbstractObjectType)
    ['{55E9B6B5-BEC2-4CA4-9539-809880A83376}']
    { Property Accessors }
    function Get_AbstractState: Variant;
    function Get_Href: UnicodeString;
    function Get_ItemIconSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ItemIconObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractState(Value: Variant);
    procedure Set_Href(Value: UnicodeString);
    { Methods & Properties }
    property AbstractState: Variant read Get_AbstractState write Set_AbstractState;
    property Href: UnicodeString read Get_Href write Set_Href;
    property ItemIconSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_ItemIconSimpleExtensionGroup;
    property ItemIconObjectExtensionGroup: IXMLString_List read Get_ItemIconObjectExtensionGroup;
  end;

{ IXMLItemIconTypeList }

  IXMLItemIconTypeList = interface(IXMLNodeCollection)
    ['{E5BA16ED-1763-4831-9C93-CFB3B7133E69}']
    { Methods & Properties }
    function Add: IXMLItemIconType;
    function Insert(const Index: Integer): IXMLItemIconType;

    function Get_Item(Index: Integer): IXMLItemIconType;
    property Items[Index: Integer]: IXMLItemIconType read Get_Item; default;
  end;

{ IXMLStyleMapType }

  IXMLStyleMapType = interface(IXMLAbstractStyleSelectorType)
    ['{5EE14F99-5B3E-4D52-91BF-CD9A1218F46B}']
    { Property Accessors }
    function Get_Pair: IXMLPairTypeList;
    function Get_StyleMapSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_StyleMapObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property Pair: IXMLPairTypeList read Get_Pair;
    property StyleMapSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_StyleMapSimpleExtensionGroup;
    property StyleMapObjectExtensionGroup: IXMLString_List read Get_StyleMapObjectExtensionGroup;
  end;

{ IXMLPairType }

  IXMLPairType = interface(IXMLAbstractObjectType)
    ['{DD667253-92A4-4F3D-9073-0263AB7EFCD4}']
    { Property Accessors }
    function Get_key: UnicodeString;
    function Get_StyleUrl: UnicodeString;
    function Get_AbstractStyleSelectorGroup: IXMLAbstractStyleSelectorType;
    function Get_PairSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PairObjectExtensionGroup: IXMLString_List;
    procedure Set_key(Value: UnicodeString);
    procedure Set_StyleUrl(Value: UnicodeString);
    { Methods & Properties }
    property key: UnicodeString read Get_key write Set_key;
    property StyleUrl: UnicodeString read Get_StyleUrl write Set_StyleUrl;
    property AbstractStyleSelectorGroup: IXMLAbstractStyleSelectorType read Get_AbstractStyleSelectorGroup;
    property PairSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_PairSimpleExtensionGroup;
    property PairObjectExtensionGroup: IXMLString_List read Get_PairObjectExtensionGroup;
  end;

{ IXMLPairTypeList }

  IXMLPairTypeList = interface(IXMLNodeCollection)
    ['{D4EB0FA1-DFAC-4AC4-8E8D-C3EA0F0F2222}']
    { Methods & Properties }
    function Add: IXMLPairType;
    function Insert(const Index: Integer): IXMLPairType;

    function Get_Item(Index: Integer): IXMLPairType;
    property Items[Index: Integer]: IXMLPairType read Get_Item; default;
  end;

{ IXMLTimeStampType }

  IXMLTimeStampType = interface(IXMLAbstractTimePrimitiveType)
    ['{CC90F04B-3024-43D9-806B-C2B0A7C8BD10}']
    { Property Accessors }
    function Get_When: UnicodeString;
    function Get_TimeStampSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TimeStampObjectExtensionGroup: IXMLString_List;
    procedure Set_When(Value: UnicodeString);
    { Methods & Properties }
    property When: UnicodeString read Get_When write Set_When;
    property TimeStampSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_TimeStampSimpleExtensionGroup;
    property TimeStampObjectExtensionGroup: IXMLString_List read Get_TimeStampObjectExtensionGroup;
  end;

{ IXMLTimeSpanType }

  IXMLTimeSpanType = interface(IXMLAbstractTimePrimitiveType)
    ['{B1F50CB2-E906-451C-B12E-0F317AA62FA8}']
    { Property Accessors }
    function Get_Begin_: UnicodeString;
    function Get_End_: UnicodeString;
    function Get_TimeSpanSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TimeSpanObjectExtensionGroup: IXMLString_List;
    procedure Set_Begin_(Value: UnicodeString);
    procedure Set_End_(Value: UnicodeString);
    { Methods & Properties }
    property Begin_: UnicodeString read Get_Begin_ write Set_Begin_;
    property End_: UnicodeString read Get_End_ write Set_End_;
    property TimeSpanSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_TimeSpanSimpleExtensionGroup;
    property TimeSpanObjectExtensionGroup: IXMLString_List read Get_TimeSpanObjectExtensionGroup;
  end;

{ IXMLCreateType }

  IXMLCreateType = interface(IXMLNode)
    ['{F5A67F77-BEEA-44B4-A20C-D37761AB337F}']
    { Property Accessors }
    function Get_AbstractContainerGroup: IXMLAbstractContainerTypeList;
    function Get_MultiTrack: IXMLMultiTrackTypeList;
    function Get_MultiGeometry: IXMLMultiGeometryTypeList;
    { Methods & Properties }
    property AbstractContainerGroup: IXMLAbstractContainerTypeList read Get_AbstractContainerGroup;
    property MultiTrack: IXMLMultiTrackTypeList read Get_MultiTrack;
    property MultiGeometry: IXMLMultiGeometryTypeList read Get_MultiGeometry;
  end;

{ IXMLDeleteType }

  IXMLDeleteType = interface(IXMLNode)
    ['{E776C6C5-67E3-49BF-8D38-EE7E4539086F}']
    { Property Accessors }
    function Get_AbstractFeatureGroup: IXMLAbstractFeatureTypeList;
    function Get_AbstractGeometryGroup: IXMLAbstractGeometryTypeList;
    { Methods & Properties }
    property AbstractFeatureGroup: IXMLAbstractFeatureTypeList read Get_AbstractFeatureGroup;
    property AbstractGeometryGroup: IXMLAbstractGeometryTypeList read Get_AbstractGeometryGroup;
  end;

{ IXMLChangeType }

  IXMLChangeType = interface(IXMLNodeCollection)
    ['{1EDDB85E-088C-4E2B-A79D-5ACCBB1B9791}']
    { Property Accessors }
    function Get_AbstractObjectGroup(Index: Integer): IXMLAbstractObjectType;
    { Methods & Properties }
    function Add: IXMLAbstractObjectType;
    function Insert(const Index: Integer): IXMLAbstractObjectType;
    property AbstractObjectGroup[Index: Integer]: IXMLAbstractObjectType read Get_AbstractObjectGroup; default;
  end;

{ IXMLAbstractTourPrimitiveType }

  IXMLAbstractTourPrimitiveType = interface(IXMLAbstractObjectType)
    ['{67BC8B37-70E0-445D-A9F5-38E779D405F1}']
    { Property Accessors }
    function Get_AbstractTourPrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractTourPrimitiveObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractTourPrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AbstractTourPrimitiveSimpleExtensionGroup;
    property AbstractTourPrimitiveObjectExtensionGroup: IXMLString_List read Get_AbstractTourPrimitiveObjectExtensionGroup;
  end;

{ IXMLAbstractTourPrimitiveTypeList }

  IXMLAbstractTourPrimitiveTypeList = interface(IXMLNodeCollection)
    ['{B4E8F7FC-50D6-4AC9-B70A-2F7FB6D6AB32}']
    { Methods & Properties }
    function Add: IXMLAbstractTourPrimitiveType;
    function Insert(const Index: Integer): IXMLAbstractTourPrimitiveType;

    function Get_Item(Index: Integer): IXMLAbstractTourPrimitiveType;
    property Items[Index: Integer]: IXMLAbstractTourPrimitiveType read Get_Item; default;
  end;

{ IXMLAnimatedUpdateType }

  IXMLAnimatedUpdateType = interface(IXMLAbstractTourPrimitiveType)
    ['{A2E28A24-55F9-4316-B9EB-A80961013A93}']
    { Property Accessors }
    function Get_Duration: Double;
    function Get_Update: IXMLUpdateType;
    function Get_DelayedStart: Double;
    function Get_AnimatedUpdateSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AnimatedUpdateObjectExtensionGroup: IXMLString_List;
    procedure Set_Duration(Value: Double);
    procedure Set_DelayedStart(Value: Double);
    { Methods & Properties }
    property Duration: Double read Get_Duration write Set_Duration;
    property Update: IXMLUpdateType read Get_Update;
    property DelayedStart: Double read Get_DelayedStart write Set_DelayedStart;
    property AnimatedUpdateSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_AnimatedUpdateSimpleExtensionGroup;
    property AnimatedUpdateObjectExtensionGroup: IXMLString_List read Get_AnimatedUpdateObjectExtensionGroup;
  end;

{ IXMLFlyToType }

  IXMLFlyToType = interface(IXMLAbstractTourPrimitiveType)
    ['{20346892-9E03-4DC7-B32A-33A4B57E6351}']
    { Property Accessors }
    function Get_Duration: Double;
    function Get_AbstractFlyToMode: UnicodeString;
    function Get_AbstractViewGroup: IXMLAbstractViewType;
    function Get_FlyToSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_FlyToObjectExtensionGroup: IXMLString_List;
    procedure Set_Duration(Value: Double);
    procedure Set_AbstractFlyToMode(Value: UnicodeString);
    { Methods & Properties }
    property Duration: Double read Get_Duration write Set_Duration;
    property AbstractFlyToMode: UnicodeString read Get_AbstractFlyToMode write Set_AbstractFlyToMode;
    property AbstractViewGroup: IXMLAbstractViewType read Get_AbstractViewGroup;
    property FlyToSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_FlyToSimpleExtensionGroup;
    property FlyToObjectExtensionGroup: IXMLString_List read Get_FlyToObjectExtensionGroup;
  end;

{ IXMLPlaylistType }

  IXMLPlaylistType = interface(IXMLAbstractObjectType)
    ['{76A25037-10AA-46C3-A93B-1F7DB48724B6}']
    { Property Accessors }
    function Get_AbstractTourPrimitiveGroup: IXMLAbstractTourPrimitiveTypeList;
    function Get_PlaylistSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PlaylistObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property AbstractTourPrimitiveGroup: IXMLAbstractTourPrimitiveTypeList read Get_AbstractTourPrimitiveGroup;
    property PlaylistSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_PlaylistSimpleExtensionGroup;
    property PlaylistObjectExtensionGroup: IXMLString_List read Get_PlaylistObjectExtensionGroup;
  end;

{ IXMLSoundCueType }

  IXMLSoundCueType = interface(IXMLAbstractTourPrimitiveType)
    ['{1F00D1E3-1E49-41E2-A589-CF62763FDC2A}']
    { Property Accessors }
    function Get_Href: UnicodeString;
    function Get_DelayedStart: Double;
    function Get_SoundCueSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_SoundCueObjectExtensionGroup: IXMLString_List;
    procedure Set_Href(Value: UnicodeString);
    procedure Set_DelayedStart(Value: Double);
    { Methods & Properties }
    property Href: UnicodeString read Get_Href write Set_Href;
    property DelayedStart: Double read Get_DelayedStart write Set_DelayedStart;
    property SoundCueSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_SoundCueSimpleExtensionGroup;
    property SoundCueObjectExtensionGroup: IXMLString_List read Get_SoundCueObjectExtensionGroup;
  end;

{ IXMLTourType }

  IXMLTourType = interface(IXMLAbstractFeatureType)
    ['{C9604741-720D-48CD-BAC0-B0E463BA0575}']
    { Property Accessors }
    function Get_Playlist: IXMLPlaylistType;
    function Get_TourSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TourObjectExtensionGroup: IXMLString_List;
    { Methods & Properties }
    property Playlist: IXMLPlaylistType read Get_Playlist;
    property TourSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_TourSimpleExtensionGroup;
    property TourObjectExtensionGroup: IXMLString_List read Get_TourObjectExtensionGroup;
  end;

{ IXMLTourControlType }

  IXMLTourControlType = interface(IXMLAbstractTourPrimitiveType)
    ['{C8D65235-A748-4A70-B619-C20392CF34B3}']
    { Property Accessors }
    function Get_AbstractPlayMode: UnicodeString;
    function Get_TourControlSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TourControlObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractPlayMode(Value: UnicodeString);
    { Methods & Properties }
    property AbstractPlayMode: UnicodeString read Get_AbstractPlayMode write Set_AbstractPlayMode;
    property TourControlSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_TourControlSimpleExtensionGroup;
    property TourControlObjectExtensionGroup: IXMLString_List read Get_TourControlObjectExtensionGroup;
  end;

{ IXMLWaitType }

  IXMLWaitType = interface(IXMLAbstractTourPrimitiveType)
    ['{52291C56-803A-43ED-94C5-615AAC3FD535}']
    { Property Accessors }
    function Get_Duration: Double;
    function Get_WaitSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_WaitObjectExtensionGroup: IXMLString_List;
    procedure Set_Duration(Value: Double);
    { Methods & Properties }
    property Duration: Double read Get_Duration write Set_Duration;
    property WaitSimpleExtensionGroup: IXMLAnySimpleTypeList read Get_WaitSimpleExtensionGroup;
    property WaitObjectExtensionGroup: IXMLString_List read Get_WaitObjectExtensionGroup;
  end;

{ IXMLAtomEmailAddressList }

  IXMLAtomEmailAddressList = interface(IXMLNodeCollection)
    ['{12CE633A-830D-4486-BE75-3DE29B8664FD}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ IXMLDateTimeTypeList }

  IXMLDateTimeTypeList = interface(IXMLNodeCollection)
    ['{4D6C626A-3F8D-4047-9327-2B18D9FB1C7E}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ IXMLAnyTypeList }

  IXMLAnyTypeList = interface(IXMLNodeCollection)
    ['{3FECD960-D93B-4175-9026-8A52984D5237}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ IXMLAnySimpleTypeList }

  IXMLAnySimpleTypeList = interface(IXMLNodeCollection)
    ['{E97AC6F8-4CBE-4061-84C9-1757B822493A}']
    { Methods & Properties }
    function Add(const Value: Variant): IXMLNode;
    function Insert(const Index: Integer; const Value: Variant): IXMLNode;

    function Get_Item(Index: Integer): Variant;
    property Items[Index: Integer]: Variant read Get_Item; default;
  end;

{ IXMLString_List }

  IXMLString_List = interface(IXMLNodeCollection)
    ['{E88ECD2F-A6AA-4919-85FE-75E723DFF2B6}']
    { Methods & Properties }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
    property Items[Index: Integer]: UnicodeString read Get_Item; default;
  end;

{ Forward Decls }

  TXMLAbstractObjectType = class;
  TXMLVec2Type = class;
  TXMLSnippetType = class;
  TXMLAbstractFeatureType = class;
  TXMLAbstractFeatureTypeList = class;
  TXMLAtomPersonConstruct_atom = class;
  TXMLLink_atom = class;
  TXMLAddressDetails_xal = class;
  TXMLPostalServiceElements_xal = class;
  TXMLAddressIdentifier_xal = class;
  TXMLAddressIdentifier_xalList = class;
  TXMLEndorsementLineCode_xal = class;
  TXMLKeyLineCode_xal = class;
  TXMLBarcode_xal = class;
  TXMLSortingCode_xal = class;
  TXMLAddressLatitude_xal = class;
  TXMLAddressLatitudeDirection_xal = class;
  TXMLAddressLongitude_xal = class;
  TXMLAddressLongitudeDirection_xal = class;
  TXMLSupplementaryPostalServiceData_xal = class;
  TXMLSupplementaryPostalServiceData_xalList = class;
  TXMLAddress_xal = class;
  TXMLAddressLinesType_xal = class;
  TXMLAddressLine_xal = class;
  TXMLAddressLine_xalList = class;
  TXMLCountry_xal = class;
  TXMLCountryNameCode_xal = class;
  TXMLCountryNameCode_xalList = class;
  TXMLCountryName_xal = class;
  TXMLCountryName_xalList = class;
  TXMLAdministrativeArea_xal = class;
  TXMLAdministrativeAreaName_xal = class;
  TXMLAdministrativeAreaName_xalList = class;
  TXMLSubAdministrativeArea_xal = class;
  TXMLSubAdministrativeAreaName_xal = class;
  TXMLSubAdministrativeAreaName_xalList = class;
  TXMLLocality_xal = class;
  TXMLLocalityName_xal = class;
  TXMLLocalityName_xalList = class;
  TXMLPostBox_xal = class;
  TXMLPostBoxNumber_xal = class;
  TXMLPostBoxNumberPrefix_xal = class;
  TXMLPostBoxNumberSuffix_xal = class;
  TXMLPostBoxNumberExtension_xal = class;
  TXMLFirmType_xal = class;
  TXMLFirmName_xal = class;
  TXMLFirmName_xalList = class;
  TXMLDepartment_xal = class;
  TXMLDepartment_xalList = class;
  TXMLDepartmentName_xal = class;
  TXMLDepartmentName_xalList = class;
  TXMLMailStopType_xal = class;
  TXMLMailStopName_xal = class;
  TXMLMailStopNumber_xal = class;
  TXMLPostalCode_xal = class;
  TXMLPostalCodeNumber_xal = class;
  TXMLPostalCodeNumber_xalList = class;
  TXMLPostalCodeNumberExtension_xal = class;
  TXMLPostalCodeNumberExtension_xalList = class;
  TXMLPostTown_xal = class;
  TXMLPostTownName_xal = class;
  TXMLPostTownName_xalList = class;
  TXMLPostTownSuffix_xal = class;
  TXMLLargeMailUserType_xal = class;
  TXMLLargeMailUserName_xal = class;
  TXMLLargeMailUserName_xalList = class;
  TXMLLargeMailUserIdentifier_xal = class;
  TXMLBuildingNameType_xal = class;
  TXMLBuildingNameType_xalList = class;
  TXMLThoroughfare_xal = class;
  TXMLThoroughfareNumber_xal = class;
  TXMLThoroughfareNumber_xalList = class;
  TXMLThoroughfareNumberRange_xal = class;
  TXMLThoroughfareNumberRange_xalList = class;
  TXMLThoroughfareNumberFrom_xal = class;
  TXMLThoroughfareNumberPrefix_xal = class;
  TXMLThoroughfareNumberPrefix_xalList = class;
  TXMLThoroughfareNumberSuffix_xal = class;
  TXMLThoroughfareNumberSuffix_xalList = class;
  TXMLThoroughfareNumberTo_xal = class;
  TXMLThoroughfarePreDirectionType_xal = class;
  TXMLThoroughfareLeadingTypeType_xal = class;
  TXMLThoroughfareNameType_xal = class;
  TXMLThoroughfareNameType_xalList = class;
  TXMLThoroughfareTrailingTypeType_xal = class;
  TXMLThoroughfarePostDirectionType_xal = class;
  TXMLDependentThoroughfare_xal = class;
  TXMLDependentLocalityType_xal = class;
  TXMLDependentLocalityName_xal = class;
  TXMLDependentLocalityName_xalList = class;
  TXMLDependentLocalityNumber_xal = class;
  TXMLPostOffice_xal = class;
  TXMLPostOfficeName_xal = class;
  TXMLPostOfficeName_xalList = class;
  TXMLPostOfficeNumber_xal = class;
  TXMLPostalRouteType_xal = class;
  TXMLPostalRouteName_xal = class;
  TXMLPostalRouteName_xalList = class;
  TXMLPostalRouteNumber_xal = class;
  TXMLPremise_xal = class;
  TXMLPremiseName_xal = class;
  TXMLPremiseName_xalList = class;
  TXMLPremiseLocation_xal = class;
  TXMLPremiseNumber_xal = class;
  TXMLPremiseNumber_xalList = class;
  TXMLPremiseNumberRange_xal = class;
  TXMLPremiseNumberRangeFrom_xal = class;
  TXMLPremiseNumberPrefix_xal = class;
  TXMLPremiseNumberPrefix_xalList = class;
  TXMLPremiseNumberSuffix_xal = class;
  TXMLPremiseNumberSuffix_xalList = class;
  TXMLPremiseNumberRangeTo_xal = class;
  TXMLSubPremiseType_xal = class;
  TXMLSubPremiseType_xalList = class;
  TXMLSubPremiseName_xal = class;
  TXMLSubPremiseName_xalList = class;
  TXMLSubPremiseLocation_xal = class;
  TXMLSubPremiseNumber_xal = class;
  TXMLSubPremiseNumber_xalList = class;
  TXMLSubPremiseNumberPrefix_xal = class;
  TXMLSubPremiseNumberPrefix_xalList = class;
  TXMLSubPremiseNumberSuffix_xal = class;
  TXMLSubPremiseNumberSuffix_xalList = class;
  TXMLAbstractViewType = class;
  TXMLAbstractTimePrimitiveType = class;
  TXMLAbstractStyleSelectorType = class;
  TXMLAbstractStyleSelectorTypeList = class;
  TXMLRegionType = class;
  TXMLAbstractExtentType = class;
  TXMLLodType = class;
  TXMLLookAtType = class;
  TXMLCameraType = class;
  TXMLMetadataType = class;
  TXMLExtendedDataType = class;
  TXMLDataType = class;
  TXMLDataTypeList = class;
  TXMLSchemaDataType = class;
  TXMLSchemaDataTypeList = class;
  TXMLSimpleDataType = class;
  TXMLSimpleDataTypeList = class;
  TXMLSimpleArrayDataType = class;
  TXMLSimpleArrayDataTypeList = class;
  TXMLAbstractContainerType = class;
  TXMLAbstractContainerTypeList = class;
  TXMLAbstractGeometryType = class;
  TXMLAbstractGeometryTypeList = class;
  TXMLAbstractOverlayType = class;
  TXMLBasicLinkType = class;
  TXMLLinkType = class;
  TXMLKmlType = class;
  TXMLNetworkLinkControlType = class;
  TXMLUpdateType = class;
  TXMLDocumentType = class;
  TXMLSchemaType = class;
  TXMLSchemaTypeList = class;
  TXMLSimpleFieldType = class;
  TXMLSimpleFieldTypeList = class;
  TXMLSimpleArrayFieldType = class;
  TXMLSimpleArrayFieldTypeList = class;
  TXMLFolderType = class;
  TXMLPlacemarkType = class;
  TXMLNetworkLinkType = class;
  TXMLAbstractLatLonBoxType = class;
  TXMLLatLonAltBoxType = class;
  TXMLMultiGeometryType = class;
  TXMLMultiGeometryTypeList = class;
  TXMLPointType = class;
  TXMLLineStringType = class;
  TXMLLinearRingType = class;
  TXMLPolygonType = class;
  TXMLBoundaryType = class;
  TXMLBoundaryTypeList = class;
  TXMLModelType = class;
  TXMLLocationType = class;
  TXMLOrientationType = class;
  TXMLScaleType = class;
  TXMLResourceMapType = class;
  TXMLAliasType = class;
  TXMLAliasTypeList = class;
  TXMLTrackType = class;
  TXMLTrackTypeList = class;
  TXMLMultiTrackType = class;
  TXMLMultiTrackTypeList = class;
  TXMLGroundOverlayType = class;
  TXMLLatLonQuadType = class;
  TXMLLatLonBoxType = class;
  TXMLScreenOverlayType = class;
  TXMLPhotoOverlayType = class;
  TXMLViewVolumeType = class;
  TXMLImagePyramidType = class;
  TXMLStyleType = class;
  TXMLAbstractSubStyleType = class;
  TXMLAbstractColorStyleType = class;
  TXMLIconStyleType = class;
  TXMLLabelStyleType = class;
  TXMLLineStyleType = class;
  TXMLPolyStyleType = class;
  TXMLBalloonStyleType = class;
  TXMLListStyleType = class;
  TXMLItemIconType = class;
  TXMLItemIconTypeList = class;
  TXMLStyleMapType = class;
  TXMLPairType = class;
  TXMLPairTypeList = class;
  TXMLTimeStampType = class;
  TXMLTimeSpanType = class;
  TXMLCreateType = class;
  TXMLDeleteType = class;
  TXMLChangeType = class;
  TXMLAbstractTourPrimitiveType = class;
  TXMLAbstractTourPrimitiveTypeList = class;
  TXMLAnimatedUpdateType = class;
  TXMLFlyToType = class;
  TXMLPlaylistType = class;
  TXMLSoundCueType = class;
  TXMLTourType = class;
  TXMLTourControlType = class;
  TXMLWaitType = class;
  TXMLAtomEmailAddressList = class;
  TXMLDateTimeTypeList = class;
  TXMLAnyTypeList = class;
  TXMLAnySimpleTypeList = class;
  TXMLString_List = class;

{ TXMLAbstractObjectType }

  TXMLAbstractObjectType = class(TXMLNodeCollection, IXMLAbstractObjectType)
  protected
    { IXMLAbstractObjectType }
    function Get_Id: UnicodeString;
    function Get_TargetId: UnicodeString;
    function Get_ObjectSimpleExtensionGroup(Index: Integer): Variant;
    procedure Set_Id(Value: UnicodeString);
    procedure Set_TargetId(Value: UnicodeString);
    function Add(const ObjectSimpleExtensionGroup: Variant): IXMLNode;
    function Insert(const Index: Integer; const ObjectSimpleExtensionGroup: Variant): IXMLNode;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLVec2Type }

  TXMLVec2Type = class(TXMLNode, IXMLVec2Type)
  protected
    { IXMLVec2Type }
    function Get_X: Double;
    function Get_Y: Double;
    function Get_Xunits: UnicodeString;
    function Get_Yunits: UnicodeString;
    procedure Set_X(Value: Double);
    procedure Set_Y(Value: Double);
    procedure Set_Xunits(Value: UnicodeString);
    procedure Set_Yunits(Value: UnicodeString);
  end;

{ TXMLSnippetType }

  TXMLSnippetType = class(TXMLNode, IXMLSnippetType)
  protected
    { IXMLSnippetType }
    function Get_MaxLines: Integer;
    procedure Set_MaxLines(Value: Integer);
  end;

{ TXMLAbstractFeatureType }

  TXMLAbstractFeatureType = class(TXMLAbstractObjectType, IXMLAbstractFeatureType)
  private
    FAbstractStyleSelectorGroup: IXMLAbstractStyleSelectorTypeList;
    FAbstractFeatureSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractFeatureObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractFeatureType }
    function Get_Name: UnicodeString;
    function Get_Visibility: Boolean;
    function Get_BalloonVisibility: Boolean;
    function Get_Open: Boolean;
    function Get_Author: IXMLAtomPersonConstruct_atom;
    function Get_Link: IXMLLink_atom;
    function Get_Address: UnicodeString;
    function Get_AddressDetails: IXMLAddressDetails_xal;
    function Get_PhoneNumber: UnicodeString;
    function Get_AbstractSnippetGroup: UnicodeString;
    function Get_Description: UnicodeString;
    function Get_AbstractViewGroup: IXMLAbstractViewType;
    function Get_AbstractTimePrimitiveGroup: IXMLAbstractTimePrimitiveType;
    function Get_StyleUrl: UnicodeString;
    function Get_AbstractStyleSelectorGroup: IXMLAbstractStyleSelectorTypeList;
    function Get_Region: IXMLRegionType;
    function Get_AbstractExtendedDataGroup: UnicodeString;
    function Get_AbstractFeatureSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractFeatureObjectExtensionGroup: IXMLString_List;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Visibility(Value: Boolean);
    procedure Set_BalloonVisibility(Value: Boolean);
    procedure Set_Open(Value: Boolean);
    procedure Set_Address(Value: UnicodeString);
    procedure Set_PhoneNumber(Value: UnicodeString);
    procedure Set_AbstractSnippetGroup(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    procedure Set_StyleUrl(Value: UnicodeString);
    procedure Set_AbstractExtendedDataGroup(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractFeatureTypeList }

  TXMLAbstractFeatureTypeList = class(TXMLNodeCollection, IXMLAbstractFeatureTypeList)
  protected
    { IXMLAbstractFeatureTypeList }
    function Add: IXMLAbstractFeatureType;
    function Insert(const Index: Integer): IXMLAbstractFeatureType;

    function Get_Item(Index: Integer): IXMLAbstractFeatureType;
  end;

{ TXMLAtomPersonConstruct_atom }

  TXMLAtomPersonConstruct_atom = class(TXMLNode, IXMLAtomPersonConstruct_atom)
  private
    FName: IXMLString_List;
    FUri: IXMLString_List;
    FEmail: IXMLAtomEmailAddressList;
  protected
    { IXMLAtomPersonConstruct_atom }
    function Get_Name: IXMLString_List;
    function Get_Uri: IXMLString_List;
    function Get_Email: IXMLAtomEmailAddressList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLink_atom }

  TXMLLink_atom = class(TXMLNode, IXMLLink_atom)
  protected
    { IXMLLink_atom }
    function Get_Href: UnicodeString;
    function Get_Rel: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Hreflang: UnicodeString;
    function Get_Title: UnicodeString;
    function Get_Length: UnicodeString;
    procedure Set_Href(Value: UnicodeString);
    procedure Set_Rel(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Hreflang(Value: UnicodeString);
    procedure Set_Title(Value: UnicodeString);
    procedure Set_Length(Value: UnicodeString);
  end;

{ TXMLAddressDetails_xal }

  TXMLAddressDetails_xal = class(TXMLNode, IXMLAddressDetails_xal)
  protected
    { IXMLAddressDetails_xal }
    function Get_AddressType: UnicodeString;
    function Get_CurrentStatus: UnicodeString;
    function Get_ValidFromDate: UnicodeString;
    function Get_ValidToDate: UnicodeString;
    function Get_Usage: UnicodeString;
    function Get_Code: UnicodeString;
    function Get_AddressDetailsKey: UnicodeString;
    function Get_PostalServiceElements: IXMLPostalServiceElements_xal;
    function Get_Address: IXMLAddress_xal;
    function Get_AddressLines: IXMLAddressLinesType_xal;
    function Get_Country: IXMLCountry_xal;
    function Get_AdministrativeArea: IXMLAdministrativeArea_xal;
    function Get_Locality: IXMLLocality_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
    procedure Set_AddressType(Value: UnicodeString);
    procedure Set_CurrentStatus(Value: UnicodeString);
    procedure Set_ValidFromDate(Value: UnicodeString);
    procedure Set_ValidToDate(Value: UnicodeString);
    procedure Set_Usage(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
    procedure Set_AddressDetailsKey(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPostalServiceElements_xal }

  TXMLPostalServiceElements_xal = class(TXMLNode, IXMLPostalServiceElements_xal)
  private
    FAddressIdentifier: IXMLAddressIdentifier_xalList;
    FSupplementaryPostalServiceData: IXMLSupplementaryPostalServiceData_xalList;
  protected
    { IXMLPostalServiceElements_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressIdentifier: IXMLAddressIdentifier_xalList;
    function Get_EndorsementLineCode: IXMLEndorsementLineCode_xal;
    function Get_KeyLineCode: IXMLKeyLineCode_xal;
    function Get_Barcode: IXMLBarcode_xal;
    function Get_SortingCode: IXMLSortingCode_xal;
    function Get_AddressLatitude: IXMLAddressLatitude_xal;
    function Get_AddressLatitudeDirection: IXMLAddressLatitudeDirection_xal;
    function Get_AddressLongitude: IXMLAddressLongitude_xal;
    function Get_AddressLongitudeDirection: IXMLAddressLongitudeDirection_xal;
    function Get_SupplementaryPostalServiceData: IXMLSupplementaryPostalServiceData_xalList;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAddressIdentifier_xal }

  TXMLAddressIdentifier_xal = class(TXMLNode, IXMLAddressIdentifier_xal)
  protected
    { IXMLAddressIdentifier_xal }
    function Get_IdentifierType: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_IdentifierType(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLAddressIdentifier_xalList }

  TXMLAddressIdentifier_xalList = class(TXMLNodeCollection, IXMLAddressIdentifier_xalList)
  protected
    { IXMLAddressIdentifier_xalList }
    function Add: IXMLAddressIdentifier_xal;
    function Insert(const Index: Integer): IXMLAddressIdentifier_xal;

    function Get_Item(Index: Integer): IXMLAddressIdentifier_xal;
  end;

{ TXMLEndorsementLineCode_xal }

  TXMLEndorsementLineCode_xal = class(TXMLNode, IXMLEndorsementLineCode_xal)
  protected
    { IXMLEndorsementLineCode_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLKeyLineCode_xal }

  TXMLKeyLineCode_xal = class(TXMLNode, IXMLKeyLineCode_xal)
  protected
    { IXMLKeyLineCode_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLBarcode_xal }

  TXMLBarcode_xal = class(TXMLNode, IXMLBarcode_xal)
  protected
    { IXMLBarcode_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLSortingCode_xal }

  TXMLSortingCode_xal = class(TXMLNode, IXMLSortingCode_xal)
  protected
    { IXMLSortingCode_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLAddressLatitude_xal }

  TXMLAddressLatitude_xal = class(TXMLNode, IXMLAddressLatitude_xal)
  protected
    { IXMLAddressLatitude_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLAddressLatitudeDirection_xal }

  TXMLAddressLatitudeDirection_xal = class(TXMLNode, IXMLAddressLatitudeDirection_xal)
  protected
    { IXMLAddressLatitudeDirection_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLAddressLongitude_xal }

  TXMLAddressLongitude_xal = class(TXMLNode, IXMLAddressLongitude_xal)
  protected
    { IXMLAddressLongitude_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLAddressLongitudeDirection_xal }

  TXMLAddressLongitudeDirection_xal = class(TXMLNode, IXMLAddressLongitudeDirection_xal)
  protected
    { IXMLAddressLongitudeDirection_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLSupplementaryPostalServiceData_xal }

  TXMLSupplementaryPostalServiceData_xal = class(TXMLNode, IXMLSupplementaryPostalServiceData_xal)
  protected
    { IXMLSupplementaryPostalServiceData_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLSupplementaryPostalServiceData_xalList }

  TXMLSupplementaryPostalServiceData_xalList = class(TXMLNodeCollection, IXMLSupplementaryPostalServiceData_xalList)
  protected
    { IXMLSupplementaryPostalServiceData_xalList }
    function Add: IXMLSupplementaryPostalServiceData_xal;
    function Insert(const Index: Integer): IXMLSupplementaryPostalServiceData_xal;

    function Get_Item(Index: Integer): IXMLSupplementaryPostalServiceData_xal;
  end;

{ TXMLAddress_xal }

  TXMLAddress_xal = class(TXMLNode, IXMLAddress_xal)
  protected
    { IXMLAddress_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLAddressLinesType_xal }

  TXMLAddressLinesType_xal = class(TXMLNodeCollection, IXMLAddressLinesType_xal)
  protected
    { IXMLAddressLinesType_xal }
    function Get_AddressLine(Index: Integer): IXMLAddressLine_xal;
    function Add: IXMLAddressLine_xal;
    function Insert(const Index: Integer): IXMLAddressLine_xal;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAddressLine_xal }

  TXMLAddressLine_xal = class(TXMLNode, IXMLAddressLine_xal)
  protected
    { IXMLAddressLine_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLAddressLine_xalList }

  TXMLAddressLine_xalList = class(TXMLNodeCollection, IXMLAddressLine_xalList)
  protected
    { IXMLAddressLine_xalList }
    function Add: IXMLAddressLine_xal;
    function Insert(const Index: Integer): IXMLAddressLine_xal;

    function Get_Item(Index: Integer): IXMLAddressLine_xal;
  end;

{ TXMLCountry_xal }

  TXMLCountry_xal = class(TXMLNode, IXMLCountry_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FCountryNameCode: IXMLCountryNameCode_xalList;
    FCountryName: IXMLCountryName_xalList;
  protected
    { IXMLCountry_xal }
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_CountryNameCode: IXMLCountryNameCode_xalList;
    function Get_CountryName: IXMLCountryName_xalList;
    function Get_AdministrativeArea: IXMLAdministrativeArea_xal;
    function Get_Locality: IXMLLocality_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCountryNameCode_xal }

  TXMLCountryNameCode_xal = class(TXMLNode, IXMLCountryNameCode_xal)
  protected
    { IXMLCountryNameCode_xal }
    function Get_Scheme: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Scheme(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLCountryNameCode_xalList }

  TXMLCountryNameCode_xalList = class(TXMLNodeCollection, IXMLCountryNameCode_xalList)
  protected
    { IXMLCountryNameCode_xalList }
    function Add: IXMLCountryNameCode_xal;
    function Insert(const Index: Integer): IXMLCountryNameCode_xal;

    function Get_Item(Index: Integer): IXMLCountryNameCode_xal;
  end;

{ TXMLCountryName_xal }

  TXMLCountryName_xal = class(TXMLNode, IXMLCountryName_xal)
  protected
    { IXMLCountryName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLCountryName_xalList }

  TXMLCountryName_xalList = class(TXMLNodeCollection, IXMLCountryName_xalList)
  protected
    { IXMLCountryName_xalList }
    function Add: IXMLCountryName_xal;
    function Insert(const Index: Integer): IXMLCountryName_xal;

    function Get_Item(Index: Integer): IXMLCountryName_xal;
  end;

{ TXMLAdministrativeArea_xal }

  TXMLAdministrativeArea_xal = class(TXMLNode, IXMLAdministrativeArea_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FAdministrativeAreaName: IXMLAdministrativeAreaName_xalList;
  protected
    { IXMLAdministrativeArea_xal }
    function Get_Type_: UnicodeString;
    function Get_UsageType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_AdministrativeAreaName: IXMLAdministrativeAreaName_xalList;
    function Get_SubAdministrativeArea: IXMLSubAdministrativeArea_xal;
    function Get_Locality: IXMLLocality_xal;
    function Get_PostOffice: IXMLPostOffice_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_UsageType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAdministrativeAreaName_xal }

  TXMLAdministrativeAreaName_xal = class(TXMLNode, IXMLAdministrativeAreaName_xal)
  protected
    { IXMLAdministrativeAreaName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLAdministrativeAreaName_xalList }

  TXMLAdministrativeAreaName_xalList = class(TXMLNodeCollection, IXMLAdministrativeAreaName_xalList)
  protected
    { IXMLAdministrativeAreaName_xalList }
    function Add: IXMLAdministrativeAreaName_xal;
    function Insert(const Index: Integer): IXMLAdministrativeAreaName_xal;

    function Get_Item(Index: Integer): IXMLAdministrativeAreaName_xal;
  end;

{ TXMLSubAdministrativeArea_xal }

  TXMLSubAdministrativeArea_xal = class(TXMLNode, IXMLSubAdministrativeArea_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FSubAdministrativeAreaName: IXMLSubAdministrativeAreaName_xalList;
  protected
    { IXMLSubAdministrativeArea_xal }
    function Get_Type_: UnicodeString;
    function Get_UsageType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_SubAdministrativeAreaName: IXMLSubAdministrativeAreaName_xalList;
    function Get_Locality: IXMLLocality_xal;
    function Get_PostOffice: IXMLPostOffice_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_UsageType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSubAdministrativeAreaName_xal }

  TXMLSubAdministrativeAreaName_xal = class(TXMLNode, IXMLSubAdministrativeAreaName_xal)
  protected
    { IXMLSubAdministrativeAreaName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLSubAdministrativeAreaName_xalList }

  TXMLSubAdministrativeAreaName_xalList = class(TXMLNodeCollection, IXMLSubAdministrativeAreaName_xalList)
  protected
    { IXMLSubAdministrativeAreaName_xalList }
    function Add: IXMLSubAdministrativeAreaName_xal;
    function Insert(const Index: Integer): IXMLSubAdministrativeAreaName_xal;

    function Get_Item(Index: Integer): IXMLSubAdministrativeAreaName_xal;
  end;

{ TXMLLocality_xal }

  TXMLLocality_xal = class(TXMLNode, IXMLLocality_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FLocalityName: IXMLLocalityName_xalList;
  protected
    { IXMLLocality_xal }
    function Get_Type_: UnicodeString;
    function Get_UsageType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_LocalityName: IXMLLocalityName_xalList;
    function Get_PostBox: IXMLPostBox_xal;
    function Get_LargeMailUser: IXMLLargeMailUserType_xal;
    function Get_PostOffice: IXMLPostOffice_xal;
    function Get_PostalRoute: IXMLPostalRouteType_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
    function Get_Premise: IXMLPremise_xal;
    function Get_DependentLocality: IXMLDependentLocalityType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_UsageType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLocalityName_xal }

  TXMLLocalityName_xal = class(TXMLNode, IXMLLocalityName_xal)
  protected
    { IXMLLocalityName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLLocalityName_xalList }

  TXMLLocalityName_xalList = class(TXMLNodeCollection, IXMLLocalityName_xalList)
  protected
    { IXMLLocalityName_xalList }
    function Add: IXMLLocalityName_xal;
    function Insert(const Index: Integer): IXMLLocalityName_xal;

    function Get_Item(Index: Integer): IXMLLocalityName_xal;
  end;

{ TXMLPostBox_xal }

  TXMLPostBox_xal = class(TXMLNode, IXMLPostBox_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
  protected
    { IXMLPostBox_xal }
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostBoxNumber: IXMLPostBoxNumber_xal;
    function Get_PostBoxNumberPrefix: IXMLPostBoxNumberPrefix_xal;
    function Get_PostBoxNumberSuffix: IXMLPostBoxNumberSuffix_xal;
    function Get_PostBoxNumberExtension: IXMLPostBoxNumberExtension_xal;
    function Get_Firm: IXMLFirmType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPostBoxNumber_xal }

  TXMLPostBoxNumber_xal = class(TXMLNode, IXMLPostBoxNumber_xal)
  protected
    { IXMLPostBoxNumber_xal }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostBoxNumberPrefix_xal }

  TXMLPostBoxNumberPrefix_xal = class(TXMLNode, IXMLPostBoxNumberPrefix_xal)
  protected
    { IXMLPostBoxNumberPrefix_xal }
    function Get_NumberPrefixSeparator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberPrefixSeparator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostBoxNumberSuffix_xal }

  TXMLPostBoxNumberSuffix_xal = class(TXMLNode, IXMLPostBoxNumberSuffix_xal)
  protected
    { IXMLPostBoxNumberSuffix_xal }
    function Get_NumberSuffixSeparator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberSuffixSeparator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostBoxNumberExtension_xal }

  TXMLPostBoxNumberExtension_xal = class(TXMLNode, IXMLPostBoxNumberExtension_xal)
  protected
    { IXMLPostBoxNumberExtension_xal }
    function Get_NumberExtensionSeparator: UnicodeString;
    procedure Set_NumberExtensionSeparator(Value: UnicodeString);
  end;

{ TXMLFirmType_xal }

  TXMLFirmType_xal = class(TXMLNode, IXMLFirmType_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FFirmName: IXMLFirmName_xalList;
    FDepartment: IXMLDepartment_xalList;
  protected
    { IXMLFirmType_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_FirmName: IXMLFirmName_xalList;
    function Get_Department: IXMLDepartment_xalList;
    function Get_MailStop: IXMLMailStopType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFirmName_xal }

  TXMLFirmName_xal = class(TXMLNode, IXMLFirmName_xal)
  protected
    { IXMLFirmName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLFirmName_xalList }

  TXMLFirmName_xalList = class(TXMLNodeCollection, IXMLFirmName_xalList)
  protected
    { IXMLFirmName_xalList }
    function Add: IXMLFirmName_xal;
    function Insert(const Index: Integer): IXMLFirmName_xal;

    function Get_Item(Index: Integer): IXMLFirmName_xal;
  end;

{ TXMLDepartment_xal }

  TXMLDepartment_xal = class(TXMLNode, IXMLDepartment_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FDepartmentName: IXMLDepartmentName_xalList;
  protected
    { IXMLDepartment_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_DepartmentName: IXMLDepartmentName_xalList;
    function Get_MailStop: IXMLMailStopType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDepartment_xalList }

  TXMLDepartment_xalList = class(TXMLNodeCollection, IXMLDepartment_xalList)
  protected
    { IXMLDepartment_xalList }
    function Add: IXMLDepartment_xal;
    function Insert(const Index: Integer): IXMLDepartment_xal;

    function Get_Item(Index: Integer): IXMLDepartment_xal;
  end;

{ TXMLDepartmentName_xal }

  TXMLDepartmentName_xal = class(TXMLNode, IXMLDepartmentName_xal)
  protected
    { IXMLDepartmentName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLDepartmentName_xalList }

  TXMLDepartmentName_xalList = class(TXMLNodeCollection, IXMLDepartmentName_xalList)
  protected
    { IXMLDepartmentName_xalList }
    function Add: IXMLDepartmentName_xal;
    function Insert(const Index: Integer): IXMLDepartmentName_xal;

    function Get_Item(Index: Integer): IXMLDepartmentName_xal;
  end;

{ TXMLMailStopType_xal }

  TXMLMailStopType_xal = class(TXMLNode, IXMLMailStopType_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
  protected
    { IXMLMailStopType_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_MailStopName: IXMLMailStopName_xal;
    function Get_MailStopNumber: IXMLMailStopNumber_xal;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMailStopName_xal }

  TXMLMailStopName_xal = class(TXMLNode, IXMLMailStopName_xal)
  protected
    { IXMLMailStopName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLMailStopNumber_xal }

  TXMLMailStopNumber_xal = class(TXMLNode, IXMLMailStopNumber_xal)
  protected
    { IXMLMailStopNumber_xal }
    function Get_NameNumberSeparator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NameNumberSeparator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostalCode_xal }

  TXMLPostalCode_xal = class(TXMLNode, IXMLPostalCode_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FPostalCodeNumber: IXMLPostalCodeNumber_xalList;
    FPostalCodeNumberExtension: IXMLPostalCodeNumberExtension_xalList;
  protected
    { IXMLPostalCode_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostalCodeNumber: IXMLPostalCodeNumber_xalList;
    function Get_PostalCodeNumberExtension: IXMLPostalCodeNumberExtension_xalList;
    function Get_PostTown: IXMLPostTown_xal;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPostalCodeNumber_xal }

  TXMLPostalCodeNumber_xal = class(TXMLNode, IXMLPostalCodeNumber_xal)
  protected
    { IXMLPostalCodeNumber_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostalCodeNumber_xalList }

  TXMLPostalCodeNumber_xalList = class(TXMLNodeCollection, IXMLPostalCodeNumber_xalList)
  protected
    { IXMLPostalCodeNumber_xalList }
    function Add: IXMLPostalCodeNumber_xal;
    function Insert(const Index: Integer): IXMLPostalCodeNumber_xal;

    function Get_Item(Index: Integer): IXMLPostalCodeNumber_xal;
  end;

{ TXMLPostalCodeNumberExtension_xal }

  TXMLPostalCodeNumberExtension_xal = class(TXMLNode, IXMLPostalCodeNumberExtension_xal)
  protected
    { IXMLPostalCodeNumberExtension_xal }
    function Get_Type_: UnicodeString;
    function Get_NumberExtensionSeparator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_NumberExtensionSeparator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostalCodeNumberExtension_xalList }

  TXMLPostalCodeNumberExtension_xalList = class(TXMLNodeCollection, IXMLPostalCodeNumberExtension_xalList)
  protected
    { IXMLPostalCodeNumberExtension_xalList }
    function Add: IXMLPostalCodeNumberExtension_xal;
    function Insert(const Index: Integer): IXMLPostalCodeNumberExtension_xal;

    function Get_Item(Index: Integer): IXMLPostalCodeNumberExtension_xal;
  end;

{ TXMLPostTown_xal }

  TXMLPostTown_xal = class(TXMLNode, IXMLPostTown_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FPostTownName: IXMLPostTownName_xalList;
  protected
    { IXMLPostTown_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostTownName: IXMLPostTownName_xalList;
    function Get_PostTownSuffix: IXMLPostTownSuffix_xal;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPostTownName_xal }

  TXMLPostTownName_xal = class(TXMLNode, IXMLPostTownName_xal)
  protected
    { IXMLPostTownName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostTownName_xalList }

  TXMLPostTownName_xalList = class(TXMLNodeCollection, IXMLPostTownName_xalList)
  protected
    { IXMLPostTownName_xalList }
    function Add: IXMLPostTownName_xal;
    function Insert(const Index: Integer): IXMLPostTownName_xal;

    function Get_Item(Index: Integer): IXMLPostTownName_xal;
  end;

{ TXMLPostTownSuffix_xal }

  TXMLPostTownSuffix_xal = class(TXMLNode, IXMLPostTownSuffix_xal)
  protected
    { IXMLPostTownSuffix_xal }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLLargeMailUserType_xal }

  TXMLLargeMailUserType_xal = class(TXMLNode, IXMLLargeMailUserType_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FLargeMailUserName: IXMLLargeMailUserName_xalList;
    FBuildingName: IXMLBuildingNameType_xalList;
  protected
    { IXMLLargeMailUserType_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_LargeMailUserName: IXMLLargeMailUserName_xalList;
    function Get_LargeMailUserIdentifier: IXMLLargeMailUserIdentifier_xal;
    function Get_BuildingName: IXMLBuildingNameType_xalList;
    function Get_Department: IXMLDepartment_xal;
    function Get_PostBox: IXMLPostBox_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLargeMailUserName_xal }

  TXMLLargeMailUserName_xal = class(TXMLNode, IXMLLargeMailUserName_xal)
  protected
    { IXMLLargeMailUserName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLLargeMailUserName_xalList }

  TXMLLargeMailUserName_xalList = class(TXMLNodeCollection, IXMLLargeMailUserName_xalList)
  protected
    { IXMLLargeMailUserName_xalList }
    function Add: IXMLLargeMailUserName_xal;
    function Insert(const Index: Integer): IXMLLargeMailUserName_xal;

    function Get_Item(Index: Integer): IXMLLargeMailUserName_xal;
  end;

{ TXMLLargeMailUserIdentifier_xal }

  TXMLLargeMailUserIdentifier_xal = class(TXMLNode, IXMLLargeMailUserIdentifier_xal)
  protected
    { IXMLLargeMailUserIdentifier_xal }
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLBuildingNameType_xal }

  TXMLBuildingNameType_xal = class(TXMLNode, IXMLBuildingNameType_xal)
  protected
    { IXMLBuildingNameType_xal }
    function Get_Type_: UnicodeString;
    function Get_TypeOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_TypeOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLBuildingNameType_xalList }

  TXMLBuildingNameType_xalList = class(TXMLNodeCollection, IXMLBuildingNameType_xalList)
  protected
    { IXMLBuildingNameType_xalList }
    function Add: IXMLBuildingNameType_xal;
    function Insert(const Index: Integer): IXMLBuildingNameType_xal;

    function Get_Item(Index: Integer): IXMLBuildingNameType_xal;
  end;

{ TXMLThoroughfare_xal }

  TXMLThoroughfare_xal = class(TXMLNode, IXMLThoroughfare_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FThoroughfareNumber: IXMLThoroughfareNumber_xalList;
    FThoroughfareNumberRange: IXMLThoroughfareNumberRange_xalList;
    FThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
    FThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
    FThoroughfareName: IXMLThoroughfareNameType_xalList;
  protected
    { IXMLThoroughfare_xal }
    function Get_Type_: UnicodeString;
    function Get_DependentThoroughfares: UnicodeString;
    function Get_DependentThoroughfaresIndicator: UnicodeString;
    function Get_DependentThoroughfaresConnector: UnicodeString;
    function Get_DependentThoroughfaresType: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfareNumber: IXMLThoroughfareNumber_xalList;
    function Get_ThoroughfareNumberRange: IXMLThoroughfareNumberRange_xalList;
    function Get_ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
    function Get_ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
    function Get_ThoroughfarePreDirection: IXMLThoroughfarePreDirectionType_xal;
    function Get_ThoroughfareLeadingType: IXMLThoroughfareLeadingTypeType_xal;
    function Get_ThoroughfareName: IXMLThoroughfareNameType_xalList;
    function Get_ThoroughfareTrailingType: IXMLThoroughfareTrailingTypeType_xal;
    function Get_ThoroughfarePostDirection: IXMLThoroughfarePostDirectionType_xal;
    function Get_DependentThoroughfare: IXMLDependentThoroughfare_xal;
    function Get_DependentLocality: IXMLDependentLocalityType_xal;
    function Get_Premise: IXMLPremise_xal;
    function Get_Firm: IXMLFirmType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_DependentThoroughfares(Value: UnicodeString);
    procedure Set_DependentThoroughfaresIndicator(Value: UnicodeString);
    procedure Set_DependentThoroughfaresConnector(Value: UnicodeString);
    procedure Set_DependentThoroughfaresType(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLThoroughfareNumber_xal }

  TXMLThoroughfareNumber_xal = class(TXMLNode, IXMLThoroughfareNumber_xal)
  protected
    { IXMLThoroughfareNumber_xal }
    function Get_NumberType: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_NumberOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberType(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_NumberOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLThoroughfareNumber_xalList }

  TXMLThoroughfareNumber_xalList = class(TXMLNodeCollection, IXMLThoroughfareNumber_xalList)
  protected
    { IXMLThoroughfareNumber_xalList }
    function Add: IXMLThoroughfareNumber_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNumber_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNumber_xal;
  end;

{ TXMLThoroughfareNumberRange_xal }

  TXMLThoroughfareNumberRange_xal = class(TXMLNode, IXMLThoroughfareNumberRange_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
  protected
    { IXMLThoroughfareNumberRange_xal }
    function Get_RangeType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_Separator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_NumberRangeOccurrence: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfareNumberFrom: IXMLThoroughfareNumberFrom_xal;
    function Get_ThoroughfareNumberTo: IXMLThoroughfareNumberTo_xal;
    procedure Set_RangeType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_Separator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_NumberRangeOccurrence(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLThoroughfareNumberRange_xalList }

  TXMLThoroughfareNumberRange_xalList = class(TXMLNodeCollection, IXMLThoroughfareNumberRange_xalList)
  protected
    { IXMLThoroughfareNumberRange_xalList }
    function Add: IXMLThoroughfareNumberRange_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNumberRange_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNumberRange_xal;
  end;

{ TXMLThoroughfareNumberFrom_xal }

  TXMLThoroughfareNumberFrom_xal = class(TXMLNode, IXMLThoroughfareNumberFrom_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
    FThoroughfareNumber: IXMLThoroughfareNumber_xalList;
    FThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
  protected
    { IXMLThoroughfareNumberFrom_xal }
    function Get_Code: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
    function Get_ThoroughfareNumber: IXMLThoroughfareNumber_xalList;
    function Get_ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
    procedure Set_Code(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLThoroughfareNumberPrefix_xal }

  TXMLThoroughfareNumberPrefix_xal = class(TXMLNode, IXMLThoroughfareNumberPrefix_xal)
  protected
    { IXMLThoroughfareNumberPrefix_xal }
    function Get_NumberPrefixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberPrefixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLThoroughfareNumberPrefix_xalList }

  TXMLThoroughfareNumberPrefix_xalList = class(TXMLNodeCollection, IXMLThoroughfareNumberPrefix_xalList)
  protected
    { IXMLThoroughfareNumberPrefix_xalList }
    function Add: IXMLThoroughfareNumberPrefix_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNumberPrefix_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNumberPrefix_xal;
  end;

{ TXMLThoroughfareNumberSuffix_xal }

  TXMLThoroughfareNumberSuffix_xal = class(TXMLNode, IXMLThoroughfareNumberSuffix_xal)
  protected
    { IXMLThoroughfareNumberSuffix_xal }
    function Get_NumberSuffixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberSuffixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLThoroughfareNumberSuffix_xalList }

  TXMLThoroughfareNumberSuffix_xalList = class(TXMLNodeCollection, IXMLThoroughfareNumberSuffix_xalList)
  protected
    { IXMLThoroughfareNumberSuffix_xalList }
    function Add: IXMLThoroughfareNumberSuffix_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNumberSuffix_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNumberSuffix_xal;
  end;

{ TXMLThoroughfareNumberTo_xal }

  TXMLThoroughfareNumberTo_xal = class(TXMLNode, IXMLThoroughfareNumberTo_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
    FThoroughfareNumber: IXMLThoroughfareNumber_xalList;
    FThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
  protected
    { IXMLThoroughfareNumberTo_xal }
    function Get_Code: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
    function Get_ThoroughfareNumber: IXMLThoroughfareNumber_xalList;
    function Get_ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
    procedure Set_Code(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLThoroughfarePreDirectionType_xal }

  TXMLThoroughfarePreDirectionType_xal = class(TXMLNode, IXMLThoroughfarePreDirectionType_xal)
  protected
    { IXMLThoroughfarePreDirectionType_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLThoroughfareLeadingTypeType_xal }

  TXMLThoroughfareLeadingTypeType_xal = class(TXMLNode, IXMLThoroughfareLeadingTypeType_xal)
  protected
    { IXMLThoroughfareLeadingTypeType_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLThoroughfareNameType_xal }

  TXMLThoroughfareNameType_xal = class(TXMLNode, IXMLThoroughfareNameType_xal)
  protected
    { IXMLThoroughfareNameType_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLThoroughfareNameType_xalList }

  TXMLThoroughfareNameType_xalList = class(TXMLNodeCollection, IXMLThoroughfareNameType_xalList)
  protected
    { IXMLThoroughfareNameType_xalList }
    function Add: IXMLThoroughfareNameType_xal;
    function Insert(const Index: Integer): IXMLThoroughfareNameType_xal;

    function Get_Item(Index: Integer): IXMLThoroughfareNameType_xal;
  end;

{ TXMLThoroughfareTrailingTypeType_xal }

  TXMLThoroughfareTrailingTypeType_xal = class(TXMLNode, IXMLThoroughfareTrailingTypeType_xal)
  protected
    { IXMLThoroughfareTrailingTypeType_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLThoroughfarePostDirectionType_xal }

  TXMLThoroughfarePostDirectionType_xal = class(TXMLNode, IXMLThoroughfarePostDirectionType_xal)
  protected
    { IXMLThoroughfarePostDirectionType_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLDependentThoroughfare_xal }

  TXMLDependentThoroughfare_xal = class(TXMLNode, IXMLDependentThoroughfare_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FThoroughfareName: IXMLThoroughfareNameType_xalList;
  protected
    { IXMLDependentThoroughfare_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_ThoroughfarePreDirection: IXMLThoroughfarePreDirectionType_xal;
    function Get_ThoroughfareLeadingType: IXMLThoroughfareLeadingTypeType_xal;
    function Get_ThoroughfareName: IXMLThoroughfareNameType_xalList;
    function Get_ThoroughfareTrailingType: IXMLThoroughfareTrailingTypeType_xal;
    function Get_ThoroughfarePostDirection: IXMLThoroughfarePostDirectionType_xal;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDependentLocalityType_xal }

  TXMLDependentLocalityType_xal = class(TXMLNode, IXMLDependentLocalityType_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FDependentLocalityName: IXMLDependentLocalityName_xalList;
  protected
    { IXMLDependentLocalityType_xal }
    function Get_Type_: UnicodeString;
    function Get_UsageType: UnicodeString;
    function Get_Connector: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_DependentLocalityName: IXMLDependentLocalityName_xalList;
    function Get_DependentLocalityNumber: IXMLDependentLocalityNumber_xal;
    function Get_PostBox: IXMLPostBox_xal;
    function Get_LargeMailUser: IXMLLargeMailUserType_xal;
    function Get_PostOffice: IXMLPostOffice_xal;
    function Get_PostalRoute: IXMLPostalRouteType_xal;
    function Get_Thoroughfare: IXMLThoroughfare_xal;
    function Get_Premise: IXMLPremise_xal;
    function Get_DependentLocality: IXMLDependentLocalityType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_UsageType(Value: UnicodeString);
    procedure Set_Connector(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDependentLocalityName_xal }

  TXMLDependentLocalityName_xal = class(TXMLNode, IXMLDependentLocalityName_xal)
  protected
    { IXMLDependentLocalityName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLDependentLocalityName_xalList }

  TXMLDependentLocalityName_xalList = class(TXMLNodeCollection, IXMLDependentLocalityName_xalList)
  protected
    { IXMLDependentLocalityName_xalList }
    function Add: IXMLDependentLocalityName_xal;
    function Insert(const Index: Integer): IXMLDependentLocalityName_xal;

    function Get_Item(Index: Integer): IXMLDependentLocalityName_xal;
  end;

{ TXMLDependentLocalityNumber_xal }

  TXMLDependentLocalityNumber_xal = class(TXMLNode, IXMLDependentLocalityNumber_xal)
  protected
    { IXMLDependentLocalityNumber_xal }
    function Get_NameNumberOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NameNumberOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostOffice_xal }

  TXMLPostOffice_xal = class(TXMLNode, IXMLPostOffice_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FPostOfficeName: IXMLPostOfficeName_xalList;
  protected
    { IXMLPostOffice_xal }
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostOfficeName: IXMLPostOfficeName_xalList;
    function Get_PostOfficeNumber: IXMLPostOfficeNumber_xal;
    function Get_PostalRoute: IXMLPostalRouteType_xal;
    function Get_PostBox: IXMLPostBox_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPostOfficeName_xal }

  TXMLPostOfficeName_xal = class(TXMLNode, IXMLPostOfficeName_xal)
  protected
    { IXMLPostOfficeName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostOfficeName_xalList }

  TXMLPostOfficeName_xalList = class(TXMLNodeCollection, IXMLPostOfficeName_xalList)
  protected
    { IXMLPostOfficeName_xalList }
    function Add: IXMLPostOfficeName_xal;
    function Insert(const Index: Integer): IXMLPostOfficeName_xal;

    function Get_Item(Index: Integer): IXMLPostOfficeName_xal;
  end;

{ TXMLPostOfficeNumber_xal }

  TXMLPostOfficeNumber_xal = class(TXMLNode, IXMLPostOfficeNumber_xal)
  protected
    { IXMLPostOfficeNumber_xal }
    function Get_Indicator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostalRouteType_xal }

  TXMLPostalRouteType_xal = class(TXMLNode, IXMLPostalRouteType_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FPostalRouteName: IXMLPostalRouteName_xalList;
  protected
    { IXMLPostalRouteType_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PostalRouteName: IXMLPostalRouteName_xalList;
    function Get_PostalRouteNumber: IXMLPostalRouteNumber_xal;
    function Get_PostBox: IXMLPostBox_xal;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPostalRouteName_xal }

  TXMLPostalRouteName_xal = class(TXMLNode, IXMLPostalRouteName_xal)
  protected
    { IXMLPostalRouteName_xal }
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPostalRouteName_xalList }

  TXMLPostalRouteName_xalList = class(TXMLNodeCollection, IXMLPostalRouteName_xalList)
  protected
    { IXMLPostalRouteName_xalList }
    function Add: IXMLPostalRouteName_xal;
    function Insert(const Index: Integer): IXMLPostalRouteName_xal;

    function Get_Item(Index: Integer): IXMLPostalRouteName_xal;
  end;

{ TXMLPostalRouteNumber_xal }

  TXMLPostalRouteNumber_xal = class(TXMLNode, IXMLPostalRouteNumber_xal)
  protected
    { IXMLPostalRouteNumber_xal }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPremise_xal }

  TXMLPremise_xal = class(TXMLNode, IXMLPremise_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FPremiseName: IXMLPremiseName_xalList;
    FPremiseNumber: IXMLPremiseNumber_xalList;
    FPremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
    FPremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
    FBuildingName: IXMLBuildingNameType_xalList;
    FSubPremise: IXMLSubPremiseType_xalList;
  protected
    { IXMLPremise_xal }
    function Get_Type_: UnicodeString;
    function Get_PremiseDependency: UnicodeString;
    function Get_PremiseDependencyType: UnicodeString;
    function Get_PremiseThoroughfareConnector: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PremiseName: IXMLPremiseName_xalList;
    function Get_PremiseLocation: IXMLPremiseLocation_xal;
    function Get_PremiseNumber: IXMLPremiseNumber_xalList;
    function Get_PremiseNumberRange: IXMLPremiseNumberRange_xal;
    function Get_PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
    function Get_PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
    function Get_BuildingName: IXMLBuildingNameType_xalList;
    function Get_SubPremise: IXMLSubPremiseType_xalList;
    function Get_Firm: IXMLFirmType_xal;
    function Get_MailStop: IXMLMailStopType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    function Get_Premise: IXMLPremise_xal;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_PremiseDependency(Value: UnicodeString);
    procedure Set_PremiseDependencyType(Value: UnicodeString);
    procedure Set_PremiseThoroughfareConnector(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPremiseName_xal }

  TXMLPremiseName_xal = class(TXMLNode, IXMLPremiseName_xal)
  protected
    { IXMLPremiseName_xal }
    function Get_Type_: UnicodeString;
    function Get_TypeOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_TypeOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPremiseName_xalList }

  TXMLPremiseName_xalList = class(TXMLNodeCollection, IXMLPremiseName_xalList)
  protected
    { IXMLPremiseName_xalList }
    function Add: IXMLPremiseName_xal;
    function Insert(const Index: Integer): IXMLPremiseName_xal;

    function Get_Item(Index: Integer): IXMLPremiseName_xal;
  end;

{ TXMLPremiseLocation_xal }

  TXMLPremiseLocation_xal = class(TXMLNode, IXMLPremiseLocation_xal)
  protected
    { IXMLPremiseLocation_xal }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPremiseNumber_xal }

  TXMLPremiseNumber_xal = class(TXMLNode, IXMLPremiseNumber_xal)
  protected
    { IXMLPremiseNumber_xal }
    function Get_NumberType: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_NumberTypeOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberType(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_NumberTypeOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPremiseNumber_xalList }

  TXMLPremiseNumber_xalList = class(TXMLNodeCollection, IXMLPremiseNumber_xalList)
  protected
    { IXMLPremiseNumber_xalList }
    function Add: IXMLPremiseNumber_xal;
    function Insert(const Index: Integer): IXMLPremiseNumber_xal;

    function Get_Item(Index: Integer): IXMLPremiseNumber_xal;
  end;

{ TXMLPremiseNumberRange_xal }

  TXMLPremiseNumberRange_xal = class(TXMLNode, IXMLPremiseNumberRange_xal)
  protected
    { IXMLPremiseNumberRange_xal }
    function Get_RangeType: UnicodeString;
    function Get_Indicator: UnicodeString;
    function Get_Separator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_IndicatorOccurence: UnicodeString;
    function Get_NumberRangeOccurence: UnicodeString;
    function Get_PremiseNumberRangeFrom: IXMLPremiseNumberRangeFrom_xal;
    function Get_PremiseNumberRangeTo: IXMLPremiseNumberRangeTo_xal;
    procedure Set_RangeType(Value: UnicodeString);
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_Separator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_IndicatorOccurence(Value: UnicodeString);
    procedure Set_NumberRangeOccurence(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPremiseNumberRangeFrom_xal }

  TXMLPremiseNumberRangeFrom_xal = class(TXMLNode, IXMLPremiseNumberRangeFrom_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FPremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
    FPremiseNumber: IXMLPremiseNumber_xalList;
    FPremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
  protected
    { IXMLPremiseNumberRangeFrom_xal }
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
    function Get_PremiseNumber: IXMLPremiseNumber_xalList;
    function Get_PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPremiseNumberPrefix_xal }

  TXMLPremiseNumberPrefix_xal = class(TXMLNode, IXMLPremiseNumberPrefix_xal)
  protected
    { IXMLPremiseNumberPrefix_xal }
    function Get_NumberPrefixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberPrefixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPremiseNumberPrefix_xalList }

  TXMLPremiseNumberPrefix_xalList = class(TXMLNodeCollection, IXMLPremiseNumberPrefix_xalList)
  protected
    { IXMLPremiseNumberPrefix_xalList }
    function Add: IXMLPremiseNumberPrefix_xal;
    function Insert(const Index: Integer): IXMLPremiseNumberPrefix_xal;

    function Get_Item(Index: Integer): IXMLPremiseNumberPrefix_xal;
  end;

{ TXMLPremiseNumberSuffix_xal }

  TXMLPremiseNumberSuffix_xal = class(TXMLNode, IXMLPremiseNumberSuffix_xal)
  protected
    { IXMLPremiseNumberSuffix_xal }
    function Get_NumberSuffixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberSuffixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLPremiseNumberSuffix_xalList }

  TXMLPremiseNumberSuffix_xalList = class(TXMLNodeCollection, IXMLPremiseNumberSuffix_xalList)
  protected
    { IXMLPremiseNumberSuffix_xalList }
    function Add: IXMLPremiseNumberSuffix_xal;
    function Insert(const Index: Integer): IXMLPremiseNumberSuffix_xal;

    function Get_Item(Index: Integer): IXMLPremiseNumberSuffix_xal;
  end;

{ TXMLPremiseNumberRangeTo_xal }

  TXMLPremiseNumberRangeTo_xal = class(TXMLNode, IXMLPremiseNumberRangeTo_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FPremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
    FPremiseNumber: IXMLPremiseNumber_xalList;
    FPremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
  protected
    { IXMLPremiseNumberRangeTo_xal }
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
    function Get_PremiseNumber: IXMLPremiseNumber_xalList;
    function Get_PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSubPremiseType_xal }

  TXMLSubPremiseType_xal = class(TXMLNode, IXMLSubPremiseType_xal)
  private
    FAddressLine: IXMLAddressLine_xalList;
    FSubPremiseName: IXMLSubPremiseName_xalList;
    FSubPremiseNumber: IXMLSubPremiseNumber_xalList;
    FSubPremiseNumberPrefix: IXMLSubPremiseNumberPrefix_xalList;
    FSubPremiseNumberSuffix: IXMLSubPremiseNumberSuffix_xalList;
    FBuildingName: IXMLBuildingNameType_xalList;
  protected
    { IXMLSubPremiseType_xal }
    function Get_Type_: UnicodeString;
    function Get_AddressLine: IXMLAddressLine_xalList;
    function Get_SubPremiseName: IXMLSubPremiseName_xalList;
    function Get_SubPremiseLocation: IXMLSubPremiseLocation_xal;
    function Get_SubPremiseNumber: IXMLSubPremiseNumber_xalList;
    function Get_SubPremiseNumberPrefix: IXMLSubPremiseNumberPrefix_xalList;
    function Get_SubPremiseNumberSuffix: IXMLSubPremiseNumberSuffix_xalList;
    function Get_BuildingName: IXMLBuildingNameType_xalList;
    function Get_Firm: IXMLFirmType_xal;
    function Get_MailStop: IXMLMailStopType_xal;
    function Get_PostalCode: IXMLPostalCode_xal;
    function Get_SubPremise: IXMLSubPremiseType_xal;
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSubPremiseType_xalList }

  TXMLSubPremiseType_xalList = class(TXMLNodeCollection, IXMLSubPremiseType_xalList)
  protected
    { IXMLSubPremiseType_xalList }
    function Add: IXMLSubPremiseType_xal;
    function Insert(const Index: Integer): IXMLSubPremiseType_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseType_xal;
  end;

{ TXMLSubPremiseName_xal }

  TXMLSubPremiseName_xal = class(TXMLNode, IXMLSubPremiseName_xal)
  protected
    { IXMLSubPremiseName_xal }
    function Get_Type_: UnicodeString;
    function Get_TypeOccurrence: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_TypeOccurrence(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLSubPremiseName_xalList }

  TXMLSubPremiseName_xalList = class(TXMLNodeCollection, IXMLSubPremiseName_xalList)
  protected
    { IXMLSubPremiseName_xalList }
    function Add: IXMLSubPremiseName_xal;
    function Insert(const Index: Integer): IXMLSubPremiseName_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseName_xal;
  end;

{ TXMLSubPremiseLocation_xal }

  TXMLSubPremiseLocation_xal = class(TXMLNode, IXMLSubPremiseLocation_xal)
  protected
    { IXMLSubPremiseLocation_xal }
    function Get_Code: UnicodeString;
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLSubPremiseNumber_xal }

  TXMLSubPremiseNumber_xal = class(TXMLNode, IXMLSubPremiseNumber_xal)
  protected
    { IXMLSubPremiseNumber_xal }
    function Get_Indicator: UnicodeString;
    function Get_IndicatorOccurrence: UnicodeString;
    function Get_NumberTypeOccurrence: UnicodeString;
    function Get_PremiseNumberSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_Indicator(Value: UnicodeString);
    procedure Set_IndicatorOccurrence(Value: UnicodeString);
    procedure Set_NumberTypeOccurrence(Value: UnicodeString);
    procedure Set_PremiseNumberSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLSubPremiseNumber_xalList }

  TXMLSubPremiseNumber_xalList = class(TXMLNodeCollection, IXMLSubPremiseNumber_xalList)
  protected
    { IXMLSubPremiseNumber_xalList }
    function Add: IXMLSubPremiseNumber_xal;
    function Insert(const Index: Integer): IXMLSubPremiseNumber_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseNumber_xal;
  end;

{ TXMLSubPremiseNumberPrefix_xal }

  TXMLSubPremiseNumberPrefix_xal = class(TXMLNode, IXMLSubPremiseNumberPrefix_xal)
  protected
    { IXMLSubPremiseNumberPrefix_xal }
    function Get_NumberPrefixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberPrefixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLSubPremiseNumberPrefix_xalList }

  TXMLSubPremiseNumberPrefix_xalList = class(TXMLNodeCollection, IXMLSubPremiseNumberPrefix_xalList)
  protected
    { IXMLSubPremiseNumberPrefix_xalList }
    function Add: IXMLSubPremiseNumberPrefix_xal;
    function Insert(const Index: Integer): IXMLSubPremiseNumberPrefix_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseNumberPrefix_xal;
  end;

{ TXMLSubPremiseNumberSuffix_xal }

  TXMLSubPremiseNumberSuffix_xal = class(TXMLNode, IXMLSubPremiseNumberSuffix_xal)
  protected
    { IXMLSubPremiseNumberSuffix_xal }
    function Get_NumberSuffixSeparator: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_Code: UnicodeString;
    procedure Set_NumberSuffixSeparator(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Code(Value: UnicodeString);
  end;

{ TXMLSubPremiseNumberSuffix_xalList }

  TXMLSubPremiseNumberSuffix_xalList = class(TXMLNodeCollection, IXMLSubPremiseNumberSuffix_xalList)
  protected
    { IXMLSubPremiseNumberSuffix_xalList }
    function Add: IXMLSubPremiseNumberSuffix_xal;
    function Insert(const Index: Integer): IXMLSubPremiseNumberSuffix_xal;

    function Get_Item(Index: Integer): IXMLSubPremiseNumberSuffix_xal;
  end;

{ TXMLAbstractViewType }

  TXMLAbstractViewType = class(TXMLAbstractObjectType, IXMLAbstractViewType)
  private
    FAbstractViewSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractViewObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractViewType }
    function Get_AbstractTimePrimitiveGroup: IXMLAbstractTimePrimitiveType;
    function Get_AbstractViewSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractViewObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractTimePrimitiveType }

  TXMLAbstractTimePrimitiveType = class(TXMLAbstractObjectType, IXMLAbstractTimePrimitiveType)
  private
    FAbstractTimePrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractTimePrimitiveObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractTimePrimitiveType }
    function Get_AbstractTimePrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractTimePrimitiveObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractStyleSelectorType }

  TXMLAbstractStyleSelectorType = class(TXMLAbstractObjectType, IXMLAbstractStyleSelectorType)
  private
    FAbstractStyleSelectorSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractStyleSelectorObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractStyleSelectorType }
    function Get_AbstractStyleSelectorSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractStyleSelectorObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractStyleSelectorTypeList }

  TXMLAbstractStyleSelectorTypeList = class(TXMLNodeCollection, IXMLAbstractStyleSelectorTypeList)
  protected
    { IXMLAbstractStyleSelectorTypeList }
    function Add: IXMLAbstractStyleSelectorType;
    function Insert(const Index: Integer): IXMLAbstractStyleSelectorType;

    function Get_Item(Index: Integer): IXMLAbstractStyleSelectorType;
  end;

{ TXMLRegionType }

  TXMLRegionType = class(TXMLAbstractObjectType, IXMLRegionType)
  private
    FRegionSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FRegionObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLRegionType }
    function Get_AbstractExtentGroup: IXMLAbstractExtentType;
    function Get_Lod: IXMLLodType;
    function Get_RegionSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_RegionObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractExtentType }

  TXMLAbstractExtentType = class(TXMLAbstractObjectType, IXMLAbstractExtentType)
  private
    FAbstractExtentSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractExtentObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractExtentType }
    function Get_AbstractExtentSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractExtentObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLodType }

  TXMLLodType = class(TXMLAbstractObjectType, IXMLLodType)
  private
    FLodSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLodObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLodType }
    function Get_MinLodPixels: Double;
    function Get_MaxLodPixels: Double;
    function Get_MinFadeExtent: Double;
    function Get_MaxFadeExtent: Double;
    function Get_LodSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LodObjectExtensionGroup: IXMLString_List;
    procedure Set_MinLodPixels(Value: Double);
    procedure Set_MaxLodPixels(Value: Double);
    procedure Set_MinFadeExtent(Value: Double);
    procedure Set_MaxFadeExtent(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLookAtType }

  TXMLLookAtType = class(TXMLAbstractViewType, IXMLLookAtType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FLookAtSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLookAtObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLookAtType }
    function Get_Longitude: Double;
    function Get_Latitude: Double;
    function Get_Altitude: Double;
    function Get_Heading: Double;
    function Get_Tilt: Double;
    function Get_Range: Double;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_HorizFov: Double;
    function Get_LookAtSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LookAtObjectExtensionGroup: IXMLString_List;
    procedure Set_Longitude(Value: Double);
    procedure Set_Latitude(Value: Double);
    procedure Set_Altitude(Value: Double);
    procedure Set_Heading(Value: Double);
    procedure Set_Tilt(Value: Double);
    procedure Set_Range(Value: Double);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_HorizFov(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCameraType }

  TXMLCameraType = class(TXMLAbstractViewType, IXMLCameraType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FCameraSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FCameraObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLCameraType }
    function Get_Longitude: Double;
    function Get_Latitude: Double;
    function Get_Altitude: Double;
    function Get_Heading: Double;
    function Get_Tilt: Double;
    function Get_Roll: Double;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_HorizFov: Double;
    function Get_CameraSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_CameraObjectExtensionGroup: IXMLString_List;
    procedure Set_Longitude(Value: Double);
    procedure Set_Latitude(Value: Double);
    procedure Set_Altitude(Value: Double);
    procedure Set_Heading(Value: Double);
    procedure Set_Tilt(Value: Double);
    procedure Set_Roll(Value: Double);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_HorizFov(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMetadataType }

  TXMLMetadataType = class(TXMLNode, IXMLMetadataType)
  protected
    { IXMLMetadataType }
  end;

{ TXMLExtendedDataType }

  TXMLExtendedDataType = class(TXMLNode, IXMLExtendedDataType)
  private
    FData: IXMLDataTypeList;
    FSchemaData: IXMLSchemaDataTypeList;
  protected
    { IXMLExtendedDataType }
    function Get_Data: IXMLDataTypeList;
    function Get_SchemaData: IXMLSchemaDataTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDataType }

  TXMLDataType = class(TXMLAbstractObjectType, IXMLDataType)
  private
    FDataExtension: IXMLString_List;
  protected
    { IXMLDataType }
    function Get_Name: UnicodeString;
    function Get_Uom: UnicodeString;
    function Get_DisplayName: UnicodeString;
    function Get_Value: Variant;
    function Get_DataExtension: IXMLString_List;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_DisplayName(Value: UnicodeString);
    procedure Set_Value(Value: Variant);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDataTypeList }

  TXMLDataTypeList = class(TXMLNodeCollection, IXMLDataTypeList)
  protected
    { IXMLDataTypeList }
    function Add: IXMLDataType;
    function Insert(const Index: Integer): IXMLDataType;

    function Get_Item(Index: Integer): IXMLDataType;
  end;

{ TXMLSchemaDataType }

  TXMLSchemaDataType = class(TXMLAbstractObjectType, IXMLSchemaDataType)
  private
    FSimpleData: IXMLSimpleDataTypeList;
    FSimpleArrayData: IXMLSimpleArrayDataTypeList;
    FSchemaDataExtension: IXMLString_List;
  protected
    { IXMLSchemaDataType }
    function Get_SchemaUrl: UnicodeString;
    function Get_SimpleData: IXMLSimpleDataTypeList;
    function Get_SimpleArrayData: IXMLSimpleArrayDataTypeList;
    function Get_SchemaDataExtension: IXMLString_List;
    procedure Set_SchemaUrl(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSchemaDataTypeList }

  TXMLSchemaDataTypeList = class(TXMLNodeCollection, IXMLSchemaDataTypeList)
  protected
    { IXMLSchemaDataTypeList }
    function Add: IXMLSchemaDataType;
    function Insert(const Index: Integer): IXMLSchemaDataType;

    function Get_Item(Index: Integer): IXMLSchemaDataType;
  end;

{ TXMLSimpleDataType }

  TXMLSimpleDataType = class(TXMLNode, IXMLSimpleDataType)
  protected
    { IXMLSimpleDataType }
    function Get_Name: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
  end;

{ TXMLSimpleDataTypeList }

  TXMLSimpleDataTypeList = class(TXMLNodeCollection, IXMLSimpleDataTypeList)
  protected
    { IXMLSimpleDataTypeList }
    function Add: IXMLSimpleDataType;
    function Insert(const Index: Integer): IXMLSimpleDataType;

    function Get_Item(Index: Integer): IXMLSimpleDataType;
  end;

{ TXMLSimpleArrayDataType }

  TXMLSimpleArrayDataType = class(TXMLAbstractObjectType, IXMLSimpleArrayDataType)
  private
    FValue: IXMLAnySimpleTypeList;
    FSimpleArrayDataExtension: IXMLString_List;
  protected
    { IXMLSimpleArrayDataType }
    function Get_Name: UnicodeString;
    function Get_Value: IXMLAnySimpleTypeList;
    function Get_SimpleArrayDataExtension: IXMLString_List;
    procedure Set_Name(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSimpleArrayDataTypeList }

  TXMLSimpleArrayDataTypeList = class(TXMLNodeCollection, IXMLSimpleArrayDataTypeList)
  protected
    { IXMLSimpleArrayDataTypeList }
    function Add: IXMLSimpleArrayDataType;
    function Insert(const Index: Integer): IXMLSimpleArrayDataType;

    function Get_Item(Index: Integer): IXMLSimpleArrayDataType;
  end;

{ TXMLAbstractContainerType }

  TXMLAbstractContainerType = class(TXMLAbstractFeatureType, IXMLAbstractContainerType)
  private
    FAbstractContainerSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractContainerObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractContainerType }
    function Get_AbstractContainerSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractContainerObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractContainerTypeList }

  TXMLAbstractContainerTypeList = class(TXMLNodeCollection, IXMLAbstractContainerTypeList)
  protected
    { IXMLAbstractContainerTypeList }
    function Add: IXMLAbstractContainerType;
    function Insert(const Index: Integer): IXMLAbstractContainerType;

    function Get_Item(Index: Integer): IXMLAbstractContainerType;
  end;

{ TXMLAbstractGeometryType }

  TXMLAbstractGeometryType = class(TXMLAbstractObjectType, IXMLAbstractGeometryType)
  private
    FAbstractGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractGeometryObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractGeometryType }
    function Get_AbstractGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractGeometryObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractGeometryTypeList }

  TXMLAbstractGeometryTypeList = class(TXMLNodeCollection, IXMLAbstractGeometryTypeList)
  protected
    { IXMLAbstractGeometryTypeList }
    function Add: IXMLAbstractGeometryType;
    function Insert(const Index: Integer): IXMLAbstractGeometryType;

    function Get_Item(Index: Integer): IXMLAbstractGeometryType;
  end;

{ TXMLAbstractOverlayType }

  TXMLAbstractOverlayType = class(TXMLAbstractFeatureType, IXMLAbstractOverlayType)
  private
    FAbstractOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractOverlayObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractOverlayType }
    function Get_Color: UnicodeString;
    function Get_DrawOrder: Integer;
    function Get_Icon: IXMLLinkType;
    function Get_AbstractOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractOverlayObjectExtensionGroup: IXMLString_List;
    procedure Set_Color(Value: UnicodeString);
    procedure Set_DrawOrder(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBasicLinkType }

  TXMLBasicLinkType = class(TXMLAbstractObjectType, IXMLBasicLinkType)
  private
    FBasicLinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FBasicLinkObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLBasicLinkType }
    function Get_Href: UnicodeString;
    function Get_BasicLinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_BasicLinkObjectExtensionGroup: IXMLString_List;
    procedure Set_Href(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLinkType }

  TXMLLinkType = class(TXMLBasicLinkType, IXMLLinkType)
  private
    FLinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLinkObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLinkType }
    function Get_AbstractRefreshMode: UnicodeString;
    function Get_RefreshInterval: Double;
    function Get_AbstractViewRefreshMode: UnicodeString;
    function Get_ViewRefreshTime: Double;
    function Get_ViewBoundScale: Double;
    function Get_ViewFormat: UnicodeString;
    function Get_HttpQuery: UnicodeString;
    function Get_LinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LinkObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractRefreshMode(Value: UnicodeString);
    procedure Set_RefreshInterval(Value: Double);
    procedure Set_AbstractViewRefreshMode(Value: UnicodeString);
    procedure Set_ViewRefreshTime(Value: Double);
    procedure Set_ViewBoundScale(Value: Double);
    procedure Set_ViewFormat(Value: UnicodeString);
    procedure Set_HttpQuery(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLKmlType }

  TXMLKmlType = class(TXMLNode, IXMLKmlType)
  private
    FKmlSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FKmlObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLKmlType }
    function Get_Hint: UnicodeString;
    function Get_Version: UnicodeString;
    function Get_NetworkLinkControl: IXMLNetworkLinkControlType;
    function Get_AbstractFeatureGroup: IXMLAbstractFeatureType;
    function Get_KmlSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_KmlObjectExtensionGroup: IXMLString_List;
    procedure Set_Hint(Value: UnicodeString);
    procedure Set_Version(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLNetworkLinkControlType }

  TXMLNetworkLinkControlType = class(TXMLNode, IXMLNetworkLinkControlType)
  private
    FNetworkLinkControlSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FNetworkLinkControlObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLNetworkLinkControlType }
    function Get_MinRefreshPeriod: Double;
    function Get_MaxSessionLength: Double;
    function Get_Cookie: UnicodeString;
    function Get_Message: UnicodeString;
    function Get_LinkName: UnicodeString;
    function Get_LinkDescription: UnicodeString;
    function Get_LinkSnippet: IXMLSnippetType;
    function Get_Expires: UnicodeString;
    function Get_Update: IXMLUpdateType;
    function Get_AbstractViewGroup: IXMLAbstractViewType;
    function Get_NetworkLinkControlSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_NetworkLinkControlObjectExtensionGroup: IXMLString_List;
    procedure Set_MinRefreshPeriod(Value: Double);
    procedure Set_MaxSessionLength(Value: Double);
    procedure Set_Cookie(Value: UnicodeString);
    procedure Set_Message(Value: UnicodeString);
    procedure Set_LinkName(Value: UnicodeString);
    procedure Set_LinkDescription(Value: UnicodeString);
    procedure Set_Expires(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLUpdateType }

  TXMLUpdateType = class(TXMLNode, IXMLUpdateType)
  private
    FAbstractUpdateOptionGroup: IXMLAnyTypeList;
    FUpdateExtensionGroup: IXMLString_List;
  protected
    { IXMLUpdateType }
    function Get_TargetHref: UnicodeString;
    function Get_AbstractUpdateOptionGroup: IXMLAnyTypeList;
    function Get_UpdateExtensionGroup: IXMLString_List;
    procedure Set_TargetHref(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDocumentType }

  TXMLDocumentType = class(TXMLAbstractContainerType, IXMLDocumentType)
  private
    FSchema: IXMLSchemaTypeList;
    FAbstractFeatureGroup: IXMLAbstractFeatureTypeList;
    FDocumentSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FDocumentObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLDocumentType }
    function Get_Schema: IXMLSchemaTypeList;
    function Get_AbstractFeatureGroup: IXMLAbstractFeatureTypeList;
    function Get_DocumentSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_DocumentObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSchemaType }

  TXMLSchemaType = class(TXMLNode, IXMLSchemaType)
  private
    FSimpleField: IXMLSimpleFieldTypeList;
    FSimpleArrayField: IXMLSimpleArrayFieldTypeList;
    FSchemaExtension: IXMLString_List;
  protected
    { IXMLSchemaType }
    function Get_Name: UnicodeString;
    function Get_Id: UnicodeString;
    function Get_SimpleField: IXMLSimpleFieldTypeList;
    function Get_SimpleArrayField: IXMLSimpleArrayFieldTypeList;
    function Get_SchemaExtension: IXMLString_List;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Id(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSchemaTypeList }

  TXMLSchemaTypeList = class(TXMLNodeCollection, IXMLSchemaTypeList)
  protected
    { IXMLSchemaTypeList }
    function Add: IXMLSchemaType;
    function Insert(const Index: Integer): IXMLSchemaType;

    function Get_Item(Index: Integer): IXMLSchemaType;
  end;

{ TXMLSimpleFieldType }

  TXMLSimpleFieldType = class(TXMLNode, IXMLSimpleFieldType)
  private
    FSimpleFieldExtension: IXMLString_List;
  protected
    { IXMLSimpleFieldType }
    function Get_Type_: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_Uom: UnicodeString;
    function Get_DisplayName: UnicodeString;
    function Get_SimpleFieldExtension: IXMLString_List;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_DisplayName(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSimpleFieldTypeList }

  TXMLSimpleFieldTypeList = class(TXMLNodeCollection, IXMLSimpleFieldTypeList)
  protected
    { IXMLSimpleFieldTypeList }
    function Add: IXMLSimpleFieldType;
    function Insert(const Index: Integer): IXMLSimpleFieldType;

    function Get_Item(Index: Integer): IXMLSimpleFieldType;
  end;

{ TXMLSimpleArrayFieldType }

  TXMLSimpleArrayFieldType = class(TXMLNode, IXMLSimpleArrayFieldType)
  private
    FSimpleArrayFieldExtension: IXMLString_List;
  protected
    { IXMLSimpleArrayFieldType }
    function Get_Type_: UnicodeString;
    function Get_Name: UnicodeString;
    function Get_Uom: UnicodeString;
    function Get_DisplayName: UnicodeString;
    function Get_SimpleArrayFieldExtension: IXMLString_List;
    procedure Set_Type_(Value: UnicodeString);
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Uom(Value: UnicodeString);
    procedure Set_DisplayName(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSimpleArrayFieldTypeList }

  TXMLSimpleArrayFieldTypeList = class(TXMLNodeCollection, IXMLSimpleArrayFieldTypeList)
  protected
    { IXMLSimpleArrayFieldTypeList }
    function Add: IXMLSimpleArrayFieldType;
    function Insert(const Index: Integer): IXMLSimpleArrayFieldType;

    function Get_Item(Index: Integer): IXMLSimpleArrayFieldType;
  end;

{ TXMLFolderType }

  TXMLFolderType = class(TXMLAbstractContainerType, IXMLFolderType)
  private
    FAbstractFeatureGroup: IXMLAbstractFeatureTypeList;
    FFolderSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FFolderObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLFolderType }
    function Get_AbstractFeatureGroup: IXMLAbstractFeatureTypeList;
    function Get_FolderSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_FolderObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPlacemarkType }

  TXMLPlacemarkType = class(TXMLAbstractFeatureType, IXMLPlacemarkType)
  private
    FPlacemarkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FPlacemarkObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLPlacemarkType }
    function Get_AbstractGeometryGroup: IXMLAbstractGeometryType;
    function Get_PlacemarkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PlacemarkObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLNetworkLinkType }

  TXMLNetworkLinkType = class(TXMLAbstractFeatureType, IXMLNetworkLinkType)
  private
    FNetworkLinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FNetworkLinkObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLNetworkLinkType }
    function Get_RefreshVisibility: Boolean;
    function Get_FlyToView: Boolean;
    function Get_AbstractLinkGroup: IXMLAbstractObjectType;
    function Get_NetworkLinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_NetworkLinkObjectExtensionGroup: IXMLString_List;
    procedure Set_RefreshVisibility(Value: Boolean);
    procedure Set_FlyToView(Value: Boolean);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractLatLonBoxType }

  TXMLAbstractLatLonBoxType = class(TXMLAbstractExtentType, IXMLAbstractLatLonBoxType)
  private
    FAbstractLatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractLatLonBoxObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractLatLonBoxType }
    function Get_North: Double;
    function Get_South: Double;
    function Get_East: Double;
    function Get_West: Double;
    function Get_AbstractLatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractLatLonBoxObjectExtensionGroup: IXMLString_List;
    procedure Set_North(Value: Double);
    procedure Set_South(Value: Double);
    procedure Set_East(Value: Double);
    procedure Set_West(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLatLonAltBoxType }

  TXMLLatLonAltBoxType = class(TXMLAbstractLatLonBoxType, IXMLLatLonAltBoxType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FLatLonAltBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLatLonAltBoxObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLatLonAltBoxType }
    function Get_MinAltitude: Double;
    function Get_MaxAltitude: Double;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_LatLonAltBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LatLonAltBoxObjectExtensionGroup: IXMLString_List;
    procedure Set_MinAltitude(Value: Double);
    procedure Set_MaxAltitude(Value: Double);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMultiGeometryType }

  TXMLMultiGeometryType = class(TXMLAbstractGeometryType, IXMLMultiGeometryType)
  private
    FAbstractGeometryGroup: IXMLAbstractGeometryTypeList;
    FMultiGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList;
    FMultiGeometryObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLMultiGeometryType }
    function Get_AbstractGeometryGroup: IXMLAbstractGeometryTypeList;
    function Get_MultiGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_MultiGeometryObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMultiGeometryTypeList }

  TXMLMultiGeometryTypeList = class(TXMLNodeCollection, IXMLMultiGeometryTypeList)
  protected
    { IXMLMultiGeometryTypeList }
    function Add: IXMLMultiGeometryType;
    function Insert(const Index: Integer): IXMLMultiGeometryType;

    function Get_Item(Index: Integer): IXMLMultiGeometryType;
  end;

{ TXMLPointType }

  TXMLPointType = class(TXMLAbstractGeometryType, IXMLPointType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FPointSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FPointObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLPointType }
    function Get_Extrude: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Coordinates: UnicodeString;
    function Get_PointSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PointObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_Coordinates(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineStringType }

  TXMLLineStringType = class(TXMLAbstractGeometryType, IXMLLineStringType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FLineStringSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLineStringObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLineStringType }
    function Get_Extrude: Boolean;
    function Get_Tessellate: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Coordinates: UnicodeString;
    function Get_AltitudeOffset: Double;
    function Get_LineStringSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LineStringObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_Tessellate(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_Coordinates(Value: UnicodeString);
    procedure Set_AltitudeOffset(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLinearRingType }

  TXMLLinearRingType = class(TXMLAbstractGeometryType, IXMLLinearRingType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FLinearRingSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLinearRingObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLinearRingType }
    function Get_Extrude: Boolean;
    function Get_Tessellate: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Coordinates: UnicodeString;
    function Get_AltitudeOffset: Double;
    function Get_LinearRingSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LinearRingObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_Tessellate(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_Coordinates(Value: UnicodeString);
    procedure Set_AltitudeOffset(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPolygonType }

  TXMLPolygonType = class(TXMLAbstractGeometryType, IXMLPolygonType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FInnerBoundaryIs: IXMLBoundaryTypeList;
    FPolygonSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FPolygonObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLPolygonType }
    function Get_Extrude: Boolean;
    function Get_Tessellate: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_OuterBoundaryIs: IXMLBoundaryType;
    function Get_InnerBoundaryIs: IXMLBoundaryTypeList;
    function Get_PolygonSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PolygonObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_Tessellate(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBoundaryType }

  TXMLBoundaryType = class(TXMLNode, IXMLBoundaryType)
  private
    FBoundarySimpleExtensionGroup: IXMLAnySimpleTypeList;
    FBoundaryObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLBoundaryType }
    function Get_LinearRing: IXMLLinearRingType;
    function Get_BoundarySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_BoundaryObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBoundaryTypeList }

  TXMLBoundaryTypeList = class(TXMLNodeCollection, IXMLBoundaryTypeList)
  protected
    { IXMLBoundaryTypeList }
    function Add: IXMLBoundaryType;
    function Insert(const Index: Integer): IXMLBoundaryType;

    function Get_Item(Index: Integer): IXMLBoundaryType;
  end;

{ TXMLModelType }

  TXMLModelType = class(TXMLAbstractGeometryType, IXMLModelType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FModelSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FModelObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLModelType }
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Location: IXMLLocationType;
    function Get_Orientation: IXMLOrientationType;
    function Get_Scale: IXMLScaleType;
    function Get_Link: IXMLLinkType;
    function Get_ResourceMap: IXMLResourceMapType;
    function Get_ModelSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ModelObjectExtensionGroup: IXMLString_List;
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLocationType }

  TXMLLocationType = class(TXMLAbstractObjectType, IXMLLocationType)
  private
    FLocationSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLocationObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLocationType }
    function Get_Longitude: Double;
    function Get_Latitude: Double;
    function Get_Altitude: Double;
    function Get_LocationSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LocationObjectExtensionGroup: IXMLString_List;
    procedure Set_Longitude(Value: Double);
    procedure Set_Latitude(Value: Double);
    procedure Set_Altitude(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLOrientationType }

  TXMLOrientationType = class(TXMLAbstractObjectType, IXMLOrientationType)
  private
    FOrientationSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FOrientationObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLOrientationType }
    function Get_Heading: Double;
    function Get_Tilt: Double;
    function Get_Roll: Double;
    function Get_OrientationSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_OrientationObjectExtensionGroup: IXMLString_List;
    procedure Set_Heading(Value: Double);
    procedure Set_Tilt(Value: Double);
    procedure Set_Roll(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLScaleType }

  TXMLScaleType = class(TXMLAbstractObjectType, IXMLScaleType)
  private
    FScaleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FScaleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLScaleType }
    function Get_X: Double;
    function Get_Y: Double;
    function Get_Z: Double;
    function Get_ScaleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ScaleObjectExtensionGroup: IXMLString_List;
    procedure Set_X(Value: Double);
    procedure Set_Y(Value: Double);
    procedure Set_Z(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLResourceMapType }

  TXMLResourceMapType = class(TXMLAbstractObjectType, IXMLResourceMapType)
  private
    FAlias: IXMLAliasTypeList;
    FResourceMapSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FResourceMapObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLResourceMapType }
    function Get_Alias: IXMLAliasTypeList;
    function Get_ResourceMapSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ResourceMapObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAliasType }

  TXMLAliasType = class(TXMLAbstractObjectType, IXMLAliasType)
  private
    FAliasSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAliasObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAliasType }
    function Get_TargetHref: UnicodeString;
    function Get_SourceHref: UnicodeString;
    function Get_AliasSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AliasObjectExtensionGroup: IXMLString_List;
    procedure Set_TargetHref(Value: UnicodeString);
    procedure Set_SourceHref(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAliasTypeList }

  TXMLAliasTypeList = class(TXMLNodeCollection, IXMLAliasTypeList)
  protected
    { IXMLAliasTypeList }
    function Add: IXMLAliasType;
    function Insert(const Index: Integer): IXMLAliasType;

    function Get_Item(Index: Integer): IXMLAliasType;
  end;

{ TXMLTrackType }

  TXMLTrackType = class(TXMLAbstractGeometryType, IXMLTrackType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FWhen: IXMLDateTimeTypeList;
    FCoord: IXMLString_List;
    FAngles: IXMLString_List;
    FTrackSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FTrackObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLTrackType }
    function Get_Extrude: Boolean;
    function Get_Tessellate: Boolean;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_When: IXMLDateTimeTypeList;
    function Get_Coord: IXMLString_List;
    function Get_Angles: IXMLString_List;
    function Get_Model: IXMLModelType;
    function Get_ExtendedData: IXMLExtendedDataType;
    function Get_TrackSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TrackObjectExtensionGroup: IXMLString_List;
    procedure Set_Extrude(Value: Boolean);
    procedure Set_Tessellate(Value: Boolean);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTrackTypeList }

  TXMLTrackTypeList = class(TXMLNodeCollection, IXMLTrackTypeList)
  protected
    { IXMLTrackTypeList }
    function Add: IXMLTrackType;
    function Insert(const Index: Integer): IXMLTrackType;

    function Get_Item(Index: Integer): IXMLTrackType;
  end;

{ TXMLMultiTrackType }

  TXMLMultiTrackType = class(TXMLAbstractGeometryType, IXMLMultiTrackType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FTrack: IXMLTrackTypeList;
    FMultiTrackSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FMultiTrackObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLMultiTrackType }
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_Interpolate: Boolean;
    function Get_Track: IXMLTrackTypeList;
    function Get_MultiTrackSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_MultiTrackObjectExtensionGroup: IXMLString_List;
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
    procedure Set_Interpolate(Value: Boolean);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLMultiTrackTypeList }

  TXMLMultiTrackTypeList = class(TXMLNodeCollection, IXMLMultiTrackTypeList)
  protected
    { IXMLMultiTrackTypeList }
    function Add: IXMLMultiTrackType;
    function Insert(const Index: Integer): IXMLMultiTrackType;

    function Get_Item(Index: Integer): IXMLMultiTrackType;
  end;

{ TXMLGroundOverlayType }

  TXMLGroundOverlayType = class(TXMLAbstractOverlayType, IXMLGroundOverlayType)
  private
    FAltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAltitudeModeObjectExtensionGroup: IXMLString_List;
    FGroundOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    FGroundOverlayObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLGroundOverlayType }
    function Get_Altitude: Double;
    function Get_AltitudeMode: UnicodeString;
    function Get_SeaFloorAltitudeMode: UnicodeString;
    function Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
    function Get_AbstractExtentGroup: IXMLAbstractExtentType;
    function Get_GroundOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_GroundOverlayObjectExtensionGroup: IXMLString_List;
    procedure Set_Altitude(Value: Double);
    procedure Set_AltitudeMode(Value: UnicodeString);
    procedure Set_SeaFloorAltitudeMode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLatLonQuadType }

  TXMLLatLonQuadType = class(TXMLAbstractExtentType, IXMLLatLonQuadType)
  private
    FLatLonQuadSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLatLonQuadObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLatLonQuadType }
    function Get_Coordinates: UnicodeString;
    function Get_LatLonQuadSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LatLonQuadObjectExtensionGroup: IXMLString_List;
    procedure Set_Coordinates(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLatLonBoxType }

  TXMLLatLonBoxType = class(TXMLAbstractLatLonBoxType, IXMLLatLonBoxType)
  private
    FLatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLatLonBoxObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLatLonBoxType }
    function Get_Rotation: Double;
    function Get_LatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LatLonBoxObjectExtensionGroup: IXMLString_List;
    procedure Set_Rotation(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLScreenOverlayType }

  TXMLScreenOverlayType = class(TXMLAbstractOverlayType, IXMLScreenOverlayType)
  private
    FScreenOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    FScreenOverlayObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLScreenOverlayType }
    function Get_OverlayXY: IXMLVec2Type;
    function Get_ScreenXY: IXMLVec2Type;
    function Get_RotationXY: IXMLVec2Type;
    function Get_Size: IXMLVec2Type;
    function Get_Rotation: Double;
    function Get_ScreenOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ScreenOverlayObjectExtensionGroup: IXMLString_List;
    procedure Set_Rotation(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPhotoOverlayType }

  TXMLPhotoOverlayType = class(TXMLAbstractOverlayType, IXMLPhotoOverlayType)
  private
    FPhotoOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    FPhotoOverlayObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLPhotoOverlayType }
    function Get_Rotation: Double;
    function Get_ViewVolume: IXMLViewVolumeType;
    function Get_ImagePyramid: IXMLImagePyramidType;
    function Get_Point: IXMLPointType;
    function Get_AbstractShape: UnicodeString;
    function Get_PhotoOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PhotoOverlayObjectExtensionGroup: IXMLString_List;
    procedure Set_Rotation(Value: Double);
    procedure Set_AbstractShape(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLViewVolumeType }

  TXMLViewVolumeType = class(TXMLAbstractObjectType, IXMLViewVolumeType)
  private
    FViewVolumeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FViewVolumeObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLViewVolumeType }
    function Get_LeftFov: Double;
    function Get_RightFov: Double;
    function Get_BottomFov: Double;
    function Get_TopFov: Double;
    function Get_Near: Double;
    function Get_ViewVolumeSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ViewVolumeObjectExtensionGroup: IXMLString_List;
    procedure Set_LeftFov(Value: Double);
    procedure Set_RightFov(Value: Double);
    procedure Set_BottomFov(Value: Double);
    procedure Set_TopFov(Value: Double);
    procedure Set_Near(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLImagePyramidType }

  TXMLImagePyramidType = class(TXMLAbstractObjectType, IXMLImagePyramidType)
  private
    FImagePyramidSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FImagePyramidObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLImagePyramidType }
    function Get_TileSize: Integer;
    function Get_MaxWidth: Integer;
    function Get_MaxHeight: Integer;
    function Get_AbstractGridOrigin: UnicodeString;
    function Get_ImagePyramidSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ImagePyramidObjectExtensionGroup: IXMLString_List;
    procedure Set_TileSize(Value: Integer);
    procedure Set_MaxWidth(Value: Integer);
    procedure Set_MaxHeight(Value: Integer);
    procedure Set_AbstractGridOrigin(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLStyleType }

  TXMLStyleType = class(TXMLAbstractStyleSelectorType, IXMLStyleType)
  private
    FStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FStyleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLStyleType }
    function Get_IconStyle: IXMLIconStyleType;
    function Get_LabelStyle: IXMLLabelStyleType;
    function Get_LineStyle: IXMLLineStyleType;
    function Get_PolyStyle: IXMLPolyStyleType;
    function Get_BalloonStyle: IXMLBalloonStyleType;
    function Get_ListStyle: IXMLListStyleType;
    function Get_StyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_StyleObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractSubStyleType }

  TXMLAbstractSubStyleType = class(TXMLAbstractObjectType, IXMLAbstractSubStyleType)
  private
    FAbstractSubStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractSubStyleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractSubStyleType }
    function Get_AbstractSubStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractSubStyleObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractColorStyleType }

  TXMLAbstractColorStyleType = class(TXMLAbstractSubStyleType, IXMLAbstractColorStyleType)
  private
    FAbstractColorStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractColorStyleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractColorStyleType }
    function Get_Color: UnicodeString;
    function Get_AbstractColorMode: UnicodeString;
    function Get_AbstractColorStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractColorStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Color(Value: UnicodeString);
    procedure Set_AbstractColorMode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLIconStyleType }

  TXMLIconStyleType = class(TXMLAbstractColorStyleType, IXMLIconStyleType)
  private
    FIconStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FIconStyleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLIconStyleType }
    function Get_Scale: Double;
    function Get_Heading: Double;
    function Get_Icon: IXMLBasicLinkType;
    function Get_HotSpot: IXMLVec2Type;
    function Get_IconStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_IconStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Scale(Value: Double);
    procedure Set_Heading(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLabelStyleType }

  TXMLLabelStyleType = class(TXMLAbstractColorStyleType, IXMLLabelStyleType)
  private
    FLabelStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLabelStyleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLabelStyleType }
    function Get_Scale: Double;
    function Get_LabelStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LabelStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Scale(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLLineStyleType }

  TXMLLineStyleType = class(TXMLAbstractColorStyleType, IXMLLineStyleType)
  private
    FLineStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FLineStyleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLLineStyleType }
    function Get_Width: Double;
    function Get_LineStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_LineStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Width(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPolyStyleType }

  TXMLPolyStyleType = class(TXMLAbstractColorStyleType, IXMLPolyStyleType)
  private
    FPolyStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FPolyStyleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLPolyStyleType }
    function Get_Fill: Boolean;
    function Get_Outline: Boolean;
    function Get_PolyStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PolyStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_Fill(Value: Boolean);
    procedure Set_Outline(Value: Boolean);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBalloonStyleType }

  TXMLBalloonStyleType = class(TXMLAbstractSubStyleType, IXMLBalloonStyleType)
  private
    FBalloonStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FBalloonStyleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLBalloonStyleType }
    function Get_AbstractBgColorGroup: UnicodeString;
    function Get_TextColor: UnicodeString;
    function Get_Text: UnicodeString;
    function Get_AbstractDisplayMode: UnicodeString;
    function Get_BalloonStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_BalloonStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractBgColorGroup(Value: UnicodeString);
    procedure Set_TextColor(Value: UnicodeString);
    procedure Set_Text(Value: UnicodeString);
    procedure Set_AbstractDisplayMode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLListStyleType }

  TXMLListStyleType = class(TXMLAbstractSubStyleType, IXMLListStyleType)
  private
    FItemIcon: IXMLItemIconTypeList;
    FListStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FListStyleObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLListStyleType }
    function Get_AbstractListItemType: UnicodeString;
    function Get_BgColor: UnicodeString;
    function Get_ItemIcon: IXMLItemIconTypeList;
    function Get_MaxSnippetLines: Integer;
    function Get_ListStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ListStyleObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractListItemType(Value: UnicodeString);
    procedure Set_BgColor(Value: UnicodeString);
    procedure Set_MaxSnippetLines(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLItemIconType }

  TXMLItemIconType = class(TXMLAbstractObjectType, IXMLItemIconType)
  private
    FItemIconSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FItemIconObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLItemIconType }
    function Get_AbstractState: Variant;
    function Get_Href: UnicodeString;
    function Get_ItemIconSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_ItemIconObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractState(Value: Variant);
    procedure Set_Href(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLItemIconTypeList }

  TXMLItemIconTypeList = class(TXMLNodeCollection, IXMLItemIconTypeList)
  protected
    { IXMLItemIconTypeList }
    function Add: IXMLItemIconType;
    function Insert(const Index: Integer): IXMLItemIconType;

    function Get_Item(Index: Integer): IXMLItemIconType;
  end;

{ TXMLStyleMapType }

  TXMLStyleMapType = class(TXMLAbstractStyleSelectorType, IXMLStyleMapType)
  private
    FPair: IXMLPairTypeList;
    FStyleMapSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FStyleMapObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLStyleMapType }
    function Get_Pair: IXMLPairTypeList;
    function Get_StyleMapSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_StyleMapObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPairType }

  TXMLPairType = class(TXMLAbstractObjectType, IXMLPairType)
  private
    FPairSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FPairObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLPairType }
    function Get_key: UnicodeString;
    function Get_StyleUrl: UnicodeString;
    function Get_AbstractStyleSelectorGroup: IXMLAbstractStyleSelectorType;
    function Get_PairSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PairObjectExtensionGroup: IXMLString_List;
    procedure Set_key(Value: UnicodeString);
    procedure Set_StyleUrl(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPairTypeList }

  TXMLPairTypeList = class(TXMLNodeCollection, IXMLPairTypeList)
  protected
    { IXMLPairTypeList }
    function Add: IXMLPairType;
    function Insert(const Index: Integer): IXMLPairType;

    function Get_Item(Index: Integer): IXMLPairType;
  end;

{ TXMLTimeStampType }

  TXMLTimeStampType = class(TXMLAbstractTimePrimitiveType, IXMLTimeStampType)
  private
    FTimeStampSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FTimeStampObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLTimeStampType }
    function Get_When: UnicodeString;
    function Get_TimeStampSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TimeStampObjectExtensionGroup: IXMLString_List;
    procedure Set_When(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTimeSpanType }

  TXMLTimeSpanType = class(TXMLAbstractTimePrimitiveType, IXMLTimeSpanType)
  private
    FTimeSpanSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FTimeSpanObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLTimeSpanType }
    function Get_Begin_: UnicodeString;
    function Get_End_: UnicodeString;
    function Get_TimeSpanSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TimeSpanObjectExtensionGroup: IXMLString_List;
    procedure Set_Begin_(Value: UnicodeString);
    procedure Set_End_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCreateType }

  TXMLCreateType = class(TXMLNode, IXMLCreateType)
  private
    FAbstractContainerGroup: IXMLAbstractContainerTypeList;
    FMultiTrack: IXMLMultiTrackTypeList;
    FMultiGeometry: IXMLMultiGeometryTypeList;
  protected
    { IXMLCreateType }
    function Get_AbstractContainerGroup: IXMLAbstractContainerTypeList;
    function Get_MultiTrack: IXMLMultiTrackTypeList;
    function Get_MultiGeometry: IXMLMultiGeometryTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDeleteType }

  TXMLDeleteType = class(TXMLNode, IXMLDeleteType)
  private
    FAbstractFeatureGroup: IXMLAbstractFeatureTypeList;
    FAbstractGeometryGroup: IXMLAbstractGeometryTypeList;
  protected
    { IXMLDeleteType }
    function Get_AbstractFeatureGroup: IXMLAbstractFeatureTypeList;
    function Get_AbstractGeometryGroup: IXMLAbstractGeometryTypeList;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLChangeType }

  TXMLChangeType = class(TXMLNodeCollection, IXMLChangeType)
  protected
    { IXMLChangeType }
    function Get_AbstractObjectGroup(Index: Integer): IXMLAbstractObjectType;
    function Add: IXMLAbstractObjectType;
    function Insert(const Index: Integer): IXMLAbstractObjectType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractTourPrimitiveType }

  TXMLAbstractTourPrimitiveType = class(TXMLAbstractObjectType, IXMLAbstractTourPrimitiveType)
  private
    FAbstractTourPrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAbstractTourPrimitiveObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAbstractTourPrimitiveType }
    function Get_AbstractTourPrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AbstractTourPrimitiveObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAbstractTourPrimitiveTypeList }

  TXMLAbstractTourPrimitiveTypeList = class(TXMLNodeCollection, IXMLAbstractTourPrimitiveTypeList)
  protected
    { IXMLAbstractTourPrimitiveTypeList }
    function Add: IXMLAbstractTourPrimitiveType;
    function Insert(const Index: Integer): IXMLAbstractTourPrimitiveType;

    function Get_Item(Index: Integer): IXMLAbstractTourPrimitiveType;
  end;

{ TXMLAnimatedUpdateType }

  TXMLAnimatedUpdateType = class(TXMLAbstractTourPrimitiveType, IXMLAnimatedUpdateType)
  private
    FAnimatedUpdateSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FAnimatedUpdateObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLAnimatedUpdateType }
    function Get_Duration: Double;
    function Get_Update: IXMLUpdateType;
    function Get_DelayedStart: Double;
    function Get_AnimatedUpdateSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_AnimatedUpdateObjectExtensionGroup: IXMLString_List;
    procedure Set_Duration(Value: Double);
    procedure Set_DelayedStart(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLFlyToType }

  TXMLFlyToType = class(TXMLAbstractTourPrimitiveType, IXMLFlyToType)
  private
    FFlyToSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FFlyToObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLFlyToType }
    function Get_Duration: Double;
    function Get_AbstractFlyToMode: UnicodeString;
    function Get_AbstractViewGroup: IXMLAbstractViewType;
    function Get_FlyToSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_FlyToObjectExtensionGroup: IXMLString_List;
    procedure Set_Duration(Value: Double);
    procedure Set_AbstractFlyToMode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPlaylistType }

  TXMLPlaylistType = class(TXMLAbstractObjectType, IXMLPlaylistType)
  private
    FAbstractTourPrimitiveGroup: IXMLAbstractTourPrimitiveTypeList;
    FPlaylistSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FPlaylistObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLPlaylistType }
    function Get_AbstractTourPrimitiveGroup: IXMLAbstractTourPrimitiveTypeList;
    function Get_PlaylistSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_PlaylistObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSoundCueType }

  TXMLSoundCueType = class(TXMLAbstractTourPrimitiveType, IXMLSoundCueType)
  private
    FSoundCueSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FSoundCueObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLSoundCueType }
    function Get_Href: UnicodeString;
    function Get_DelayedStart: Double;
    function Get_SoundCueSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_SoundCueObjectExtensionGroup: IXMLString_List;
    procedure Set_Href(Value: UnicodeString);
    procedure Set_DelayedStart(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTourType }

  TXMLTourType = class(TXMLAbstractFeatureType, IXMLTourType)
  private
    FTourSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FTourObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLTourType }
    function Get_Playlist: IXMLPlaylistType;
    function Get_TourSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TourObjectExtensionGroup: IXMLString_List;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTourControlType }

  TXMLTourControlType = class(TXMLAbstractTourPrimitiveType, IXMLTourControlType)
  private
    FTourControlSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FTourControlObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLTourControlType }
    function Get_AbstractPlayMode: UnicodeString;
    function Get_TourControlSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_TourControlObjectExtensionGroup: IXMLString_List;
    procedure Set_AbstractPlayMode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLWaitType }

  TXMLWaitType = class(TXMLAbstractTourPrimitiveType, IXMLWaitType)
  private
    FWaitSimpleExtensionGroup: IXMLAnySimpleTypeList;
    FWaitObjectExtensionGroup: IXMLString_List;
  protected
    { IXMLWaitType }
    function Get_Duration: Double;
    function Get_WaitSimpleExtensionGroup: IXMLAnySimpleTypeList;
    function Get_WaitObjectExtensionGroup: IXMLString_List;
    procedure Set_Duration(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLAtomEmailAddressList }

  TXMLAtomEmailAddressList = class(TXMLNodeCollection, IXMLAtomEmailAddressList)
  protected
    { IXMLAtomEmailAddressList }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
  end;

{ TXMLDateTimeTypeList }

  TXMLDateTimeTypeList = class(TXMLNodeCollection, IXMLDateTimeTypeList)
  protected
    { IXMLDateTimeTypeList }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
  end;

{ TXMLAnyTypeList }

  TXMLAnyTypeList = class(TXMLNodeCollection, IXMLAnyTypeList)
  protected
    { IXMLAnyTypeList }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
  end;

{ TXMLAnySimpleTypeList }

  TXMLAnySimpleTypeList = class(TXMLNodeCollection, IXMLAnySimpleTypeList)
  protected
    { IXMLAnySimpleTypeList }
    function Add(const Value: Variant): IXMLNode;
    function Insert(const Index: Integer; const Value: Variant): IXMLNode;

    function Get_Item(Index: Integer): Variant;
  end;

{ TXMLString_List }

  TXMLString_List = class(TXMLNodeCollection, IXMLString_List)
  protected
    { IXMLString_List }
    function Add(const Value: UnicodeString): IXMLNode;
    function Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;

    function Get_Item(Index: Integer): UnicodeString;
  end;

{ Global Functions }

function GetDocument(Doc: IXMLDocument): IXMLDocumentType;
function LoadDocument(const FileName: string): IXMLDocumentType;
function NewDocument: IXMLDocumentType;

const
  TargetNamespace = 'http://www.opengis.net/kml/2.2';

implementation

{ Global Functions }

function GetDocument(Doc: IXMLDocument): IXMLDocumentType;
begin
  Result := Doc.GetDocBinding('Document', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
end;

function LoadDocument(const FileName: string): IXMLDocumentType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('Document', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
end;

function NewDocument: IXMLDocumentType;
begin
  Result := NewXMLDocument.GetDocBinding('Document', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
end;

{ TXMLAbstractObjectType }

procedure TXMLAbstractObjectType.AfterConstruction;
begin
  ItemTag := 'ObjectSimpleExtensionGroup';
  ItemInterface := IXMLNode;
  inherited;
end;

function TXMLAbstractObjectType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['id'].Text;
end;

procedure TXMLAbstractObjectType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('id', Value);
end;

function TXMLAbstractObjectType.Get_TargetId: UnicodeString;
begin
  Result := AttributeNodes['targetId'].Text;
end;

procedure TXMLAbstractObjectType.Set_TargetId(Value: UnicodeString);
begin
  SetAttribute('targetId', Value);
end;

function TXMLAbstractObjectType.Get_ObjectSimpleExtensionGroup(Index: Integer): Variant;
begin
  Result := List[Index].NodeValue;
end;

function TXMLAbstractObjectType.Add(const ObjectSimpleExtensionGroup: Variant): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := ObjectSimpleExtensionGroup;
end;

function TXMLAbstractObjectType.Insert(const Index: Integer; const ObjectSimpleExtensionGroup: Variant): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := ObjectSimpleExtensionGroup;
end;

{ TXMLVec2Type }

function TXMLVec2Type.Get_X: Double;
begin
  Result := AttributeNodes[WideString('x')].NodeValue;
end;

procedure TXMLVec2Type.Set_X(Value: Double);
begin
  SetAttribute(WideString('x'), Value);
end;

function TXMLVec2Type.Get_Y: Double;
begin
  Result := AttributeNodes[WideString('y')].NodeValue;
end;

procedure TXMLVec2Type.Set_Y(Value: Double);
begin
  SetAttribute(WideString('y'), Value);
end;

function TXMLVec2Type.Get_Xunits: UnicodeString;
begin
  Result := AttributeNodes['xunits'].Text;
end;

procedure TXMLVec2Type.Set_Xunits(Value: UnicodeString);
begin
  SetAttribute('xunits', Value);
end;

function TXMLVec2Type.Get_Yunits: UnicodeString;
begin
  Result := AttributeNodes['yunits'].Text;
end;

procedure TXMLVec2Type.Set_Yunits(Value: UnicodeString);
begin
  SetAttribute('yunits', Value);
end;

{ TXMLSnippetType }

function TXMLSnippetType.Get_MaxLines: Integer;
begin
  Result := AttributeNodes['maxLines'].NodeValue;
end;

procedure TXMLSnippetType.Set_MaxLines(Value: Integer);
begin
  SetAttribute('maxLines', Value);
end;

{ TXMLAbstractFeatureType }

procedure TXMLAbstractFeatureType.AfterConstruction;
begin
  RegisterChildNode('author', TXMLAtomPersonConstruct_atom);
  RegisterChildNode('link', TXMLLink_atom);
  RegisterChildNode('AddressDetails', TXMLAddressDetails_xal);
  RegisterChildNode('AbstractViewGroup', TXMLAbstractViewType);
  RegisterChildNode('AbstractTimePrimitiveGroup', TXMLAbstractTimePrimitiveType);
  RegisterChildNode('AbstractStyleSelectorGroup', TXMLAbstractStyleSelectorType);
  RegisterChildNode('Region', TXMLRegionType);
  FAbstractStyleSelectorGroup := CreateCollection(TXMLAbstractStyleSelectorTypeList, IXMLAbstractStyleSelectorType, 'AbstractStyleSelectorGroup') as IXMLAbstractStyleSelectorTypeList;
  FAbstractFeatureSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractFeatureSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractFeatureObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractFeatureObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractFeatureType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['name'].Text;
end;

procedure TXMLAbstractFeatureType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['name'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_Visibility: Boolean;
begin
  Result := ChildNodes['visibility'].NodeValue;
end;

procedure TXMLAbstractFeatureType.Set_Visibility(Value: Boolean);
begin
  ChildNodes['visibility'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_BalloonVisibility: Boolean;
begin
  Result := ChildNodes['balloonVisibility'].NodeValue;
end;

procedure TXMLAbstractFeatureType.Set_BalloonVisibility(Value: Boolean);
begin
  ChildNodes['balloonVisibility'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_Open: Boolean;
begin
  Result := ChildNodes['open'].NodeValue;
end;

procedure TXMLAbstractFeatureType.Set_Open(Value: Boolean);
begin
  ChildNodes['open'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_Author: IXMLAtomPersonConstruct_atom;
begin
  Result := ChildNodes['author'] as IXMLAtomPersonConstruct_atom;
end;

function TXMLAbstractFeatureType.Get_Link: IXMLLink_atom;
begin
  Result := ChildNodes['link'] as IXMLLink_atom;
end;

function TXMLAbstractFeatureType.Get_Address: UnicodeString;
begin
  Result := ChildNodes['address'].Text;
end;

procedure TXMLAbstractFeatureType.Set_Address(Value: UnicodeString);
begin
  ChildNodes['address'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_AddressDetails: IXMLAddressDetails_xal;
begin
  Result := ChildNodes['AddressDetails'] as IXMLAddressDetails_xal;
end;

function TXMLAbstractFeatureType.Get_PhoneNumber: UnicodeString;
begin
  Result := ChildNodes['phoneNumber'].Text;
end;

procedure TXMLAbstractFeatureType.Set_PhoneNumber(Value: UnicodeString);
begin
  ChildNodes['phoneNumber'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_AbstractSnippetGroup: UnicodeString;
begin
  Result := ChildNodes['AbstractSnippetGroup'].Text;
end;

procedure TXMLAbstractFeatureType.Set_AbstractSnippetGroup(Value: UnicodeString);
begin
  ChildNodes['AbstractSnippetGroup'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['description'].Text;
end;

procedure TXMLAbstractFeatureType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['description'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_AbstractViewGroup: IXMLAbstractViewType;
begin
  Result := ChildNodes['AbstractViewGroup'] as IXMLAbstractViewType;
end;

function TXMLAbstractFeatureType.Get_AbstractTimePrimitiveGroup: IXMLAbstractTimePrimitiveType;
begin
  Result := ChildNodes['AbstractTimePrimitiveGroup'] as IXMLAbstractTimePrimitiveType;
end;

function TXMLAbstractFeatureType.Get_StyleUrl: UnicodeString;
begin
  Result := ChildNodes['styleUrl'].Text;
end;

procedure TXMLAbstractFeatureType.Set_StyleUrl(Value: UnicodeString);
begin
  ChildNodes['styleUrl'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_AbstractStyleSelectorGroup: IXMLAbstractStyleSelectorTypeList;
begin
  Result := FAbstractStyleSelectorGroup;
end;

function TXMLAbstractFeatureType.Get_Region: IXMLRegionType;
begin
  Result := ChildNodes['Region'] as IXMLRegionType;
end;

function TXMLAbstractFeatureType.Get_AbstractExtendedDataGroup: UnicodeString;
begin
  Result := ChildNodes['AbstractExtendedDataGroup'].Text;
end;

procedure TXMLAbstractFeatureType.Set_AbstractExtendedDataGroup(Value: UnicodeString);
begin
  ChildNodes['AbstractExtendedDataGroup'].NodeValue := Value;
end;

function TXMLAbstractFeatureType.Get_AbstractFeatureSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractFeatureSimpleExtensionGroup;
end;

function TXMLAbstractFeatureType.Get_AbstractFeatureObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractFeatureObjectExtensionGroup;
end;

{ TXMLAbstractFeatureTypeList }

function TXMLAbstractFeatureTypeList.Add: IXMLAbstractFeatureType;
begin
  Result := AddItem(-1) as IXMLAbstractFeatureType;
end;

function TXMLAbstractFeatureTypeList.Insert(const Index: Integer): IXMLAbstractFeatureType;
begin
  Result := AddItem(Index) as IXMLAbstractFeatureType;
end;

function TXMLAbstractFeatureTypeList.Get_Item(Index: Integer): IXMLAbstractFeatureType;
begin
  Result := List[Index] as IXMLAbstractFeatureType;
end;

{ TXMLAtomPersonConstruct_atom }

procedure TXMLAtomPersonConstruct_atom.AfterConstruction;
begin
  FName := CreateCollection(TXMLString_List, IXMLNode, 'name') as IXMLString_List;
  FUri := CreateCollection(TXMLString_List, IXMLNode, 'uri') as IXMLString_List;
  FEmail := CreateCollection(TXMLAtomEmailAddressList, IXMLNode, 'email') as IXMLAtomEmailAddressList;
  inherited;
end;

function TXMLAtomPersonConstruct_atom.Get_Name: IXMLString_List;
begin
  Result := FName;
end;

function TXMLAtomPersonConstruct_atom.Get_Uri: IXMLString_List;
begin
  Result := FUri;
end;

function TXMLAtomPersonConstruct_atom.Get_Email: IXMLAtomEmailAddressList;
begin
  Result := FEmail;
end;

{ TXMLLink_atom }

function TXMLLink_atom.Get_Href: UnicodeString;
begin
  Result := AttributeNodes['href'].Text;
end;

procedure TXMLLink_atom.Set_Href(Value: UnicodeString);
begin
  SetAttribute('href', Value);
end;

function TXMLLink_atom.Get_Rel: UnicodeString;
begin
  Result := AttributeNodes['rel'].Text;
end;

procedure TXMLLink_atom.Set_Rel(Value: UnicodeString);
begin
  SetAttribute('rel', Value);
end;

function TXMLLink_atom.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['type'].Text;
end;

procedure TXMLLink_atom.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('type', Value);
end;

function TXMLLink_atom.Get_Hreflang: UnicodeString;
begin
  Result := AttributeNodes['hreflang'].Text;
end;

procedure TXMLLink_atom.Set_Hreflang(Value: UnicodeString);
begin
  SetAttribute('hreflang', Value);
end;

function TXMLLink_atom.Get_Title: UnicodeString;
begin
  Result := AttributeNodes['title'].Text;
end;

procedure TXMLLink_atom.Set_Title(Value: UnicodeString);
begin
  SetAttribute('title', Value);
end;

function TXMLLink_atom.Get_Length: UnicodeString;
begin
  Result := AttributeNodes['length'].Text;
end;

procedure TXMLLink_atom.Set_Length(Value: UnicodeString);
begin
  SetAttribute('length', Value);
end;

{ TXMLAddressDetails_xal }

procedure TXMLAddressDetails_xal.AfterConstruction;
begin
  RegisterChildNode('PostalServiceElements', TXMLPostalServiceElements_xal);
  RegisterChildNode('Address', TXMLAddress_xal);
  RegisterChildNode('AddressLines', TXMLAddressLinesType_xal);
  RegisterChildNode('Country', TXMLCountry_xal);
  RegisterChildNode('AdministrativeArea', TXMLAdministrativeArea_xal);
  RegisterChildNode('Locality', TXMLLocality_xal);
  RegisterChildNode('Thoroughfare', TXMLThoroughfare_xal);
  inherited;
end;

function TXMLAddressDetails_xal.Get_AddressType: UnicodeString;
begin
  Result := AttributeNodes['AddressType'].Text;
end;

procedure TXMLAddressDetails_xal.Set_AddressType(Value: UnicodeString);
begin
  SetAttribute('AddressType', Value);
end;

function TXMLAddressDetails_xal.Get_CurrentStatus: UnicodeString;
begin
  Result := AttributeNodes['CurrentStatus'].Text;
end;

procedure TXMLAddressDetails_xal.Set_CurrentStatus(Value: UnicodeString);
begin
  SetAttribute('CurrentStatus', Value);
end;

function TXMLAddressDetails_xal.Get_ValidFromDate: UnicodeString;
begin
  Result := AttributeNodes['ValidFromDate'].Text;
end;

procedure TXMLAddressDetails_xal.Set_ValidFromDate(Value: UnicodeString);
begin
  SetAttribute('ValidFromDate', Value);
end;

function TXMLAddressDetails_xal.Get_ValidToDate: UnicodeString;
begin
  Result := AttributeNodes['ValidToDate'].Text;
end;

procedure TXMLAddressDetails_xal.Set_ValidToDate(Value: UnicodeString);
begin
  SetAttribute('ValidToDate', Value);
end;

function TXMLAddressDetails_xal.Get_Usage: UnicodeString;
begin
  Result := AttributeNodes['Usage'].Text;
end;

procedure TXMLAddressDetails_xal.Set_Usage(Value: UnicodeString);
begin
  SetAttribute('Usage', Value);
end;

function TXMLAddressDetails_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLAddressDetails_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

function TXMLAddressDetails_xal.Get_AddressDetailsKey: UnicodeString;
begin
  Result := AttributeNodes['AddressDetailsKey'].Text;
end;

procedure TXMLAddressDetails_xal.Set_AddressDetailsKey(Value: UnicodeString);
begin
  SetAttribute('AddressDetailsKey', Value);
end;

function TXMLAddressDetails_xal.Get_PostalServiceElements: IXMLPostalServiceElements_xal;
begin
  Result := ChildNodes['PostalServiceElements'] as IXMLPostalServiceElements_xal;
end;

function TXMLAddressDetails_xal.Get_Address: IXMLAddress_xal;
begin
  Result := ChildNodes['Address'] as IXMLAddress_xal;
end;

function TXMLAddressDetails_xal.Get_AddressLines: IXMLAddressLinesType_xal;
begin
  Result := ChildNodes['AddressLines'] as IXMLAddressLinesType_xal;
end;

function TXMLAddressDetails_xal.Get_Country: IXMLCountry_xal;
begin
  Result := ChildNodes['Country'] as IXMLCountry_xal;
end;

function TXMLAddressDetails_xal.Get_AdministrativeArea: IXMLAdministrativeArea_xal;
begin
  Result := ChildNodes['AdministrativeArea'] as IXMLAdministrativeArea_xal;
end;

function TXMLAddressDetails_xal.Get_Locality: IXMLLocality_xal;
begin
  Result := ChildNodes['Locality'] as IXMLLocality_xal;
end;

function TXMLAddressDetails_xal.Get_Thoroughfare: IXMLThoroughfare_xal;
begin
  Result := ChildNodes['Thoroughfare'] as IXMLThoroughfare_xal;
end;

{ TXMLPostalServiceElements_xal }

procedure TXMLPostalServiceElements_xal.AfterConstruction;
begin
  RegisterChildNode('AddressIdentifier', TXMLAddressIdentifier_xal);
  RegisterChildNode('EndorsementLineCode', TXMLEndorsementLineCode_xal);
  RegisterChildNode('KeyLineCode', TXMLKeyLineCode_xal);
  RegisterChildNode('Barcode', TXMLBarcode_xal);
  RegisterChildNode('SortingCode', TXMLSortingCode_xal);
  RegisterChildNode('AddressLatitude', TXMLAddressLatitude_xal);
  RegisterChildNode('AddressLatitudeDirection', TXMLAddressLatitudeDirection_xal);
  RegisterChildNode('AddressLongitude', TXMLAddressLongitude_xal);
  RegisterChildNode('AddressLongitudeDirection', TXMLAddressLongitudeDirection_xal);
  RegisterChildNode('SupplementaryPostalServiceData', TXMLSupplementaryPostalServiceData_xal);
  FAddressIdentifier := CreateCollection(TXMLAddressIdentifier_xalList, IXMLAddressIdentifier_xal, 'AddressIdentifier') as IXMLAddressIdentifier_xalList;
  FSupplementaryPostalServiceData := CreateCollection(TXMLSupplementaryPostalServiceData_xalList, IXMLSupplementaryPostalServiceData_xal, 'SupplementaryPostalServiceData') as IXMLSupplementaryPostalServiceData_xalList;
  inherited;
end;

function TXMLPostalServiceElements_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostalServiceElements_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostalServiceElements_xal.Get_AddressIdentifier: IXMLAddressIdentifier_xalList;
begin
  Result := FAddressIdentifier;
end;

function TXMLPostalServiceElements_xal.Get_EndorsementLineCode: IXMLEndorsementLineCode_xal;
begin
  Result := ChildNodes['EndorsementLineCode'] as IXMLEndorsementLineCode_xal;
end;

function TXMLPostalServiceElements_xal.Get_KeyLineCode: IXMLKeyLineCode_xal;
begin
  Result := ChildNodes['KeyLineCode'] as IXMLKeyLineCode_xal;
end;

function TXMLPostalServiceElements_xal.Get_Barcode: IXMLBarcode_xal;
begin
  Result := ChildNodes['Barcode'] as IXMLBarcode_xal;
end;

function TXMLPostalServiceElements_xal.Get_SortingCode: IXMLSortingCode_xal;
begin
  Result := ChildNodes['SortingCode'] as IXMLSortingCode_xal;
end;

function TXMLPostalServiceElements_xal.Get_AddressLatitude: IXMLAddressLatitude_xal;
begin
  Result := ChildNodes['AddressLatitude'] as IXMLAddressLatitude_xal;
end;

function TXMLPostalServiceElements_xal.Get_AddressLatitudeDirection: IXMLAddressLatitudeDirection_xal;
begin
  Result := ChildNodes['AddressLatitudeDirection'] as IXMLAddressLatitudeDirection_xal;
end;

function TXMLPostalServiceElements_xal.Get_AddressLongitude: IXMLAddressLongitude_xal;
begin
  Result := ChildNodes['AddressLongitude'] as IXMLAddressLongitude_xal;
end;

function TXMLPostalServiceElements_xal.Get_AddressLongitudeDirection: IXMLAddressLongitudeDirection_xal;
begin
  Result := ChildNodes['AddressLongitudeDirection'] as IXMLAddressLongitudeDirection_xal;
end;

function TXMLPostalServiceElements_xal.Get_SupplementaryPostalServiceData: IXMLSupplementaryPostalServiceData_xalList;
begin
  Result := FSupplementaryPostalServiceData;
end;

{ TXMLAddressIdentifier_xal }

function TXMLAddressIdentifier_xal.Get_IdentifierType: UnicodeString;
begin
  Result := AttributeNodes['IdentifierType'].Text;
end;

procedure TXMLAddressIdentifier_xal.Set_IdentifierType(Value: UnicodeString);
begin
  SetAttribute('IdentifierType', Value);
end;

function TXMLAddressIdentifier_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLAddressIdentifier_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLAddressIdentifier_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLAddressIdentifier_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLAddressIdentifier_xalList }

function TXMLAddressIdentifier_xalList.Add: IXMLAddressIdentifier_xal;
begin
  Result := AddItem(-1) as IXMLAddressIdentifier_xal;
end;

function TXMLAddressIdentifier_xalList.Insert(const Index: Integer): IXMLAddressIdentifier_xal;
begin
  Result := AddItem(Index) as IXMLAddressIdentifier_xal;
end;

function TXMLAddressIdentifier_xalList.Get_Item(Index: Integer): IXMLAddressIdentifier_xal;
begin
  Result := List[Index] as IXMLAddressIdentifier_xal;
end;

{ TXMLEndorsementLineCode_xal }

function TXMLEndorsementLineCode_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLEndorsementLineCode_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLEndorsementLineCode_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLEndorsementLineCode_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLKeyLineCode_xal }

function TXMLKeyLineCode_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLKeyLineCode_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLKeyLineCode_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLKeyLineCode_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLBarcode_xal }

function TXMLBarcode_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLBarcode_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLBarcode_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLBarcode_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLSortingCode_xal }

function TXMLSortingCode_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLSortingCode_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLSortingCode_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLSortingCode_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLAddressLatitude_xal }

function TXMLAddressLatitude_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLAddressLatitude_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLAddressLatitude_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLAddressLatitude_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLAddressLatitudeDirection_xal }

function TXMLAddressLatitudeDirection_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLAddressLatitudeDirection_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLAddressLatitudeDirection_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLAddressLatitudeDirection_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLAddressLongitude_xal }

function TXMLAddressLongitude_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLAddressLongitude_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLAddressLongitude_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLAddressLongitude_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLAddressLongitudeDirection_xal }

function TXMLAddressLongitudeDirection_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLAddressLongitudeDirection_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLAddressLongitudeDirection_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLAddressLongitudeDirection_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLSupplementaryPostalServiceData_xal }

function TXMLSupplementaryPostalServiceData_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLSupplementaryPostalServiceData_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLSupplementaryPostalServiceData_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLSupplementaryPostalServiceData_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLSupplementaryPostalServiceData_xalList }

function TXMLSupplementaryPostalServiceData_xalList.Add: IXMLSupplementaryPostalServiceData_xal;
begin
  Result := AddItem(-1) as IXMLSupplementaryPostalServiceData_xal;
end;

function TXMLSupplementaryPostalServiceData_xalList.Insert(const Index: Integer): IXMLSupplementaryPostalServiceData_xal;
begin
  Result := AddItem(Index) as IXMLSupplementaryPostalServiceData_xal;
end;

function TXMLSupplementaryPostalServiceData_xalList.Get_Item(Index: Integer): IXMLSupplementaryPostalServiceData_xal;
begin
  Result := List[Index] as IXMLSupplementaryPostalServiceData_xal;
end;

{ TXMLAddress_xal }

function TXMLAddress_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLAddress_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLAddress_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLAddress_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLAddressLinesType_xal }

procedure TXMLAddressLinesType_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  ItemTag := 'AddressLine';
  ItemInterface := IXMLAddressLine_xal;
  inherited;
end;

function TXMLAddressLinesType_xal.Get_AddressLine(Index: Integer): IXMLAddressLine_xal;
begin
  Result := List[Index] as IXMLAddressLine_xal;
end;

function TXMLAddressLinesType_xal.Add: IXMLAddressLine_xal;
begin
  Result := AddItem(-1) as IXMLAddressLine_xal;
end;

function TXMLAddressLinesType_xal.Insert(const Index: Integer): IXMLAddressLine_xal;
begin
  Result := AddItem(Index) as IXMLAddressLine_xal;
end;

{ TXMLAddressLine_xal }

function TXMLAddressLine_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLAddressLine_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLAddressLine_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLAddressLine_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLAddressLine_xalList }

function TXMLAddressLine_xalList.Add: IXMLAddressLine_xal;
begin
  Result := AddItem(-1) as IXMLAddressLine_xal;
end;

function TXMLAddressLine_xalList.Insert(const Index: Integer): IXMLAddressLine_xal;
begin
  Result := AddItem(Index) as IXMLAddressLine_xal;
end;

function TXMLAddressLine_xalList.Get_Item(Index: Integer): IXMLAddressLine_xal;
begin
  Result := List[Index] as IXMLAddressLine_xal;
end;

{ TXMLCountry_xal }

procedure TXMLCountry_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('CountryNameCode', TXMLCountryNameCode_xal);
  RegisterChildNode('CountryName', TXMLCountryName_xal);
  RegisterChildNode('AdministrativeArea', TXMLAdministrativeArea_xal);
  RegisterChildNode('Locality', TXMLLocality_xal);
  RegisterChildNode('Thoroughfare', TXMLThoroughfare_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FCountryNameCode := CreateCollection(TXMLCountryNameCode_xalList, IXMLCountryNameCode_xal, 'CountryNameCode') as IXMLCountryNameCode_xalList;
  FCountryName := CreateCollection(TXMLCountryName_xalList, IXMLCountryName_xal, 'CountryName') as IXMLCountryName_xalList;
  inherited;
end;

function TXMLCountry_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLCountry_xal.Get_CountryNameCode: IXMLCountryNameCode_xalList;
begin
  Result := FCountryNameCode;
end;

function TXMLCountry_xal.Get_CountryName: IXMLCountryName_xalList;
begin
  Result := FCountryName;
end;

function TXMLCountry_xal.Get_AdministrativeArea: IXMLAdministrativeArea_xal;
begin
  Result := ChildNodes['AdministrativeArea'] as IXMLAdministrativeArea_xal;
end;

function TXMLCountry_xal.Get_Locality: IXMLLocality_xal;
begin
  Result := ChildNodes['Locality'] as IXMLLocality_xal;
end;

function TXMLCountry_xal.Get_Thoroughfare: IXMLThoroughfare_xal;
begin
  Result := ChildNodes['Thoroughfare'] as IXMLThoroughfare_xal;
end;

{ TXMLCountryNameCode_xal }

function TXMLCountryNameCode_xal.Get_Scheme: UnicodeString;
begin
  Result := AttributeNodes['Scheme'].Text;
end;

procedure TXMLCountryNameCode_xal.Set_Scheme(Value: UnicodeString);
begin
  SetAttribute('Scheme', Value);
end;

function TXMLCountryNameCode_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLCountryNameCode_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLCountryNameCode_xalList }

function TXMLCountryNameCode_xalList.Add: IXMLCountryNameCode_xal;
begin
  Result := AddItem(-1) as IXMLCountryNameCode_xal;
end;

function TXMLCountryNameCode_xalList.Insert(const Index: Integer): IXMLCountryNameCode_xal;
begin
  Result := AddItem(Index) as IXMLCountryNameCode_xal;
end;

function TXMLCountryNameCode_xalList.Get_Item(Index: Integer): IXMLCountryNameCode_xal;
begin
  Result := List[Index] as IXMLCountryNameCode_xal;
end;

{ TXMLCountryName_xal }

function TXMLCountryName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLCountryName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLCountryName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLCountryName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLCountryName_xalList }

function TXMLCountryName_xalList.Add: IXMLCountryName_xal;
begin
  Result := AddItem(-1) as IXMLCountryName_xal;
end;

function TXMLCountryName_xalList.Insert(const Index: Integer): IXMLCountryName_xal;
begin
  Result := AddItem(Index) as IXMLCountryName_xal;
end;

function TXMLCountryName_xalList.Get_Item(Index: Integer): IXMLCountryName_xal;
begin
  Result := List[Index] as IXMLCountryName_xal;
end;

{ TXMLAdministrativeArea_xal }

procedure TXMLAdministrativeArea_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('AdministrativeAreaName', TXMLAdministrativeAreaName_xal);
  RegisterChildNode('SubAdministrativeArea', TXMLSubAdministrativeArea_xal);
  RegisterChildNode('Locality', TXMLLocality_xal);
  RegisterChildNode('PostOffice', TXMLPostOffice_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FAdministrativeAreaName := CreateCollection(TXMLAdministrativeAreaName_xalList, IXMLAdministrativeAreaName_xal, 'AdministrativeAreaName') as IXMLAdministrativeAreaName_xalList;
  inherited;
end;

function TXMLAdministrativeArea_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLAdministrativeArea_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLAdministrativeArea_xal.Get_UsageType: UnicodeString;
begin
  Result := AttributeNodes['UsageType'].Text;
end;

procedure TXMLAdministrativeArea_xal.Set_UsageType(Value: UnicodeString);
begin
  SetAttribute('UsageType', Value);
end;

function TXMLAdministrativeArea_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLAdministrativeArea_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLAdministrativeArea_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLAdministrativeArea_xal.Get_AdministrativeAreaName: IXMLAdministrativeAreaName_xalList;
begin
  Result := FAdministrativeAreaName;
end;

function TXMLAdministrativeArea_xal.Get_SubAdministrativeArea: IXMLSubAdministrativeArea_xal;
begin
  Result := ChildNodes['SubAdministrativeArea'] as IXMLSubAdministrativeArea_xal;
end;

function TXMLAdministrativeArea_xal.Get_Locality: IXMLLocality_xal;
begin
  Result := ChildNodes['Locality'] as IXMLLocality_xal;
end;

function TXMLAdministrativeArea_xal.Get_PostOffice: IXMLPostOffice_xal;
begin
  Result := ChildNodes['PostOffice'] as IXMLPostOffice_xal;
end;

function TXMLAdministrativeArea_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLAdministrativeAreaName_xal }

function TXMLAdministrativeAreaName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLAdministrativeAreaName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLAdministrativeAreaName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLAdministrativeAreaName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLAdministrativeAreaName_xalList }

function TXMLAdministrativeAreaName_xalList.Add: IXMLAdministrativeAreaName_xal;
begin
  Result := AddItem(-1) as IXMLAdministrativeAreaName_xal;
end;

function TXMLAdministrativeAreaName_xalList.Insert(const Index: Integer): IXMLAdministrativeAreaName_xal;
begin
  Result := AddItem(Index) as IXMLAdministrativeAreaName_xal;
end;

function TXMLAdministrativeAreaName_xalList.Get_Item(Index: Integer): IXMLAdministrativeAreaName_xal;
begin
  Result := List[Index] as IXMLAdministrativeAreaName_xal;
end;

{ TXMLSubAdministrativeArea_xal }

procedure TXMLSubAdministrativeArea_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('SubAdministrativeAreaName', TXMLSubAdministrativeAreaName_xal);
  RegisterChildNode('Locality', TXMLLocality_xal);
  RegisterChildNode('PostOffice', TXMLPostOffice_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FSubAdministrativeAreaName := CreateCollection(TXMLSubAdministrativeAreaName_xalList, IXMLSubAdministrativeAreaName_xal, 'SubAdministrativeAreaName') as IXMLSubAdministrativeAreaName_xalList;
  inherited;
end;

function TXMLSubAdministrativeArea_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLSubAdministrativeArea_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLSubAdministrativeArea_xal.Get_UsageType: UnicodeString;
begin
  Result := AttributeNodes['UsageType'].Text;
end;

procedure TXMLSubAdministrativeArea_xal.Set_UsageType(Value: UnicodeString);
begin
  SetAttribute('UsageType', Value);
end;

function TXMLSubAdministrativeArea_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLSubAdministrativeArea_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLSubAdministrativeArea_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLSubAdministrativeArea_xal.Get_SubAdministrativeAreaName: IXMLSubAdministrativeAreaName_xalList;
begin
  Result := FSubAdministrativeAreaName;
end;

function TXMLSubAdministrativeArea_xal.Get_Locality: IXMLLocality_xal;
begin
  Result := ChildNodes['Locality'] as IXMLLocality_xal;
end;

function TXMLSubAdministrativeArea_xal.Get_PostOffice: IXMLPostOffice_xal;
begin
  Result := ChildNodes['PostOffice'] as IXMLPostOffice_xal;
end;

function TXMLSubAdministrativeArea_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLSubAdministrativeAreaName_xal }

function TXMLSubAdministrativeAreaName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLSubAdministrativeAreaName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLSubAdministrativeAreaName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLSubAdministrativeAreaName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLSubAdministrativeAreaName_xalList }

function TXMLSubAdministrativeAreaName_xalList.Add: IXMLSubAdministrativeAreaName_xal;
begin
  Result := AddItem(-1) as IXMLSubAdministrativeAreaName_xal;
end;

function TXMLSubAdministrativeAreaName_xalList.Insert(const Index: Integer): IXMLSubAdministrativeAreaName_xal;
begin
  Result := AddItem(Index) as IXMLSubAdministrativeAreaName_xal;
end;

function TXMLSubAdministrativeAreaName_xalList.Get_Item(Index: Integer): IXMLSubAdministrativeAreaName_xal;
begin
  Result := List[Index] as IXMLSubAdministrativeAreaName_xal;
end;

{ TXMLLocality_xal }

procedure TXMLLocality_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('LocalityName', TXMLLocalityName_xal);
  RegisterChildNode('PostBox', TXMLPostBox_xal);
  RegisterChildNode('LargeMailUser', TXMLLargeMailUserType_xal);
  RegisterChildNode('PostOffice', TXMLPostOffice_xal);
  RegisterChildNode('PostalRoute', TXMLPostalRouteType_xal);
  RegisterChildNode('Thoroughfare', TXMLThoroughfare_xal);
  RegisterChildNode('Premise', TXMLPremise_xal);
  RegisterChildNode('DependentLocality', TXMLDependentLocalityType_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FLocalityName := CreateCollection(TXMLLocalityName_xalList, IXMLLocalityName_xal, 'LocalityName') as IXMLLocalityName_xalList;
  inherited;
end;

function TXMLLocality_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLLocality_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLLocality_xal.Get_UsageType: UnicodeString;
begin
  Result := AttributeNodes['UsageType'].Text;
end;

procedure TXMLLocality_xal.Set_UsageType(Value: UnicodeString);
begin
  SetAttribute('UsageType', Value);
end;

function TXMLLocality_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLLocality_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLLocality_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLLocality_xal.Get_LocalityName: IXMLLocalityName_xalList;
begin
  Result := FLocalityName;
end;

function TXMLLocality_xal.Get_PostBox: IXMLPostBox_xal;
begin
  Result := ChildNodes['PostBox'] as IXMLPostBox_xal;
end;

function TXMLLocality_xal.Get_LargeMailUser: IXMLLargeMailUserType_xal;
begin
  Result := ChildNodes['LargeMailUser'] as IXMLLargeMailUserType_xal;
end;

function TXMLLocality_xal.Get_PostOffice: IXMLPostOffice_xal;
begin
  Result := ChildNodes['PostOffice'] as IXMLPostOffice_xal;
end;

function TXMLLocality_xal.Get_PostalRoute: IXMLPostalRouteType_xal;
begin
  Result := ChildNodes['PostalRoute'] as IXMLPostalRouteType_xal;
end;

function TXMLLocality_xal.Get_Thoroughfare: IXMLThoroughfare_xal;
begin
  Result := ChildNodes['Thoroughfare'] as IXMLThoroughfare_xal;
end;

function TXMLLocality_xal.Get_Premise: IXMLPremise_xal;
begin
  Result := ChildNodes['Premise'] as IXMLPremise_xal;
end;

function TXMLLocality_xal.Get_DependentLocality: IXMLDependentLocalityType_xal;
begin
  Result := ChildNodes['DependentLocality'] as IXMLDependentLocalityType_xal;
end;

function TXMLLocality_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLLocalityName_xal }

function TXMLLocalityName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLLocalityName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLLocalityName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLLocalityName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLLocalityName_xalList }

function TXMLLocalityName_xalList.Add: IXMLLocalityName_xal;
begin
  Result := AddItem(-1) as IXMLLocalityName_xal;
end;

function TXMLLocalityName_xalList.Insert(const Index: Integer): IXMLLocalityName_xal;
begin
  Result := AddItem(Index) as IXMLLocalityName_xal;
end;

function TXMLLocalityName_xalList.Get_Item(Index: Integer): IXMLLocalityName_xal;
begin
  Result := List[Index] as IXMLLocalityName_xal;
end;

{ TXMLPostBox_xal }

procedure TXMLPostBox_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('PostBoxNumber', TXMLPostBoxNumber_xal);
  RegisterChildNode('PostBoxNumberPrefix', TXMLPostBoxNumberPrefix_xal);
  RegisterChildNode('PostBoxNumberSuffix', TXMLPostBoxNumberSuffix_xal);
  RegisterChildNode('PostBoxNumberExtension', TXMLPostBoxNumberExtension_xal);
  RegisterChildNode('Firm', TXMLFirmType_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  inherited;
end;

function TXMLPostBox_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostBox_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostBox_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLPostBox_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLPostBox_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLPostBox_xal.Get_PostBoxNumber: IXMLPostBoxNumber_xal;
begin
  Result := ChildNodes['PostBoxNumber'] as IXMLPostBoxNumber_xal;
end;

function TXMLPostBox_xal.Get_PostBoxNumberPrefix: IXMLPostBoxNumberPrefix_xal;
begin
  Result := ChildNodes['PostBoxNumberPrefix'] as IXMLPostBoxNumberPrefix_xal;
end;

function TXMLPostBox_xal.Get_PostBoxNumberSuffix: IXMLPostBoxNumberSuffix_xal;
begin
  Result := ChildNodes['PostBoxNumberSuffix'] as IXMLPostBoxNumberSuffix_xal;
end;

function TXMLPostBox_xal.Get_PostBoxNumberExtension: IXMLPostBoxNumberExtension_xal;
begin
  Result := ChildNodes['PostBoxNumberExtension'] as IXMLPostBoxNumberExtension_xal;
end;

function TXMLPostBox_xal.Get_Firm: IXMLFirmType_xal;
begin
  Result := ChildNodes['Firm'] as IXMLFirmType_xal;
end;

function TXMLPostBox_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLPostBoxNumber_xal }

function TXMLPostBoxNumber_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostBoxNumber_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostBoxNumberPrefix_xal }

function TXMLPostBoxNumberPrefix_xal.Get_NumberPrefixSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberPrefixSeparator'].Text;
end;

procedure TXMLPostBoxNumberPrefix_xal.Set_NumberPrefixSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberPrefixSeparator', Value);
end;

function TXMLPostBoxNumberPrefix_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostBoxNumberPrefix_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostBoxNumberSuffix_xal }

function TXMLPostBoxNumberSuffix_xal.Get_NumberSuffixSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberSuffixSeparator'].Text;
end;

procedure TXMLPostBoxNumberSuffix_xal.Set_NumberSuffixSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberSuffixSeparator', Value);
end;

function TXMLPostBoxNumberSuffix_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostBoxNumberSuffix_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostBoxNumberExtension_xal }

function TXMLPostBoxNumberExtension_xal.Get_NumberExtensionSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberExtensionSeparator'].Text;
end;

procedure TXMLPostBoxNumberExtension_xal.Set_NumberExtensionSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberExtensionSeparator', Value);
end;

{ TXMLFirmType_xal }

procedure TXMLFirmType_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('FirmName', TXMLFirmName_xal);
  RegisterChildNode('Department', TXMLDepartment_xal);
  RegisterChildNode('MailStop', TXMLMailStopType_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FFirmName := CreateCollection(TXMLFirmName_xalList, IXMLFirmName_xal, 'FirmName') as IXMLFirmName_xalList;
  FDepartment := CreateCollection(TXMLDepartment_xalList, IXMLDepartment_xal, 'Department') as IXMLDepartment_xalList;
  inherited;
end;

function TXMLFirmType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLFirmType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLFirmType_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLFirmType_xal.Get_FirmName: IXMLFirmName_xalList;
begin
  Result := FFirmName;
end;

function TXMLFirmType_xal.Get_Department: IXMLDepartment_xalList;
begin
  Result := FDepartment;
end;

function TXMLFirmType_xal.Get_MailStop: IXMLMailStopType_xal;
begin
  Result := ChildNodes['MailStop'] as IXMLMailStopType_xal;
end;

function TXMLFirmType_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLFirmName_xal }

function TXMLFirmName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLFirmName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLFirmName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLFirmName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLFirmName_xalList }

function TXMLFirmName_xalList.Add: IXMLFirmName_xal;
begin
  Result := AddItem(-1) as IXMLFirmName_xal;
end;

function TXMLFirmName_xalList.Insert(const Index: Integer): IXMLFirmName_xal;
begin
  Result := AddItem(Index) as IXMLFirmName_xal;
end;

function TXMLFirmName_xalList.Get_Item(Index: Integer): IXMLFirmName_xal;
begin
  Result := List[Index] as IXMLFirmName_xal;
end;

{ TXMLDepartment_xal }

procedure TXMLDepartment_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('DepartmentName', TXMLDepartmentName_xal);
  RegisterChildNode('MailStop', TXMLMailStopType_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FDepartmentName := CreateCollection(TXMLDepartmentName_xalList, IXMLDepartmentName_xal, 'DepartmentName') as IXMLDepartmentName_xalList;
  inherited;
end;

function TXMLDepartment_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLDepartment_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLDepartment_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLDepartment_xal.Get_DepartmentName: IXMLDepartmentName_xalList;
begin
  Result := FDepartmentName;
end;

function TXMLDepartment_xal.Get_MailStop: IXMLMailStopType_xal;
begin
  Result := ChildNodes['MailStop'] as IXMLMailStopType_xal;
end;

function TXMLDepartment_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLDepartment_xalList }

function TXMLDepartment_xalList.Add: IXMLDepartment_xal;
begin
  Result := AddItem(-1) as IXMLDepartment_xal;
end;

function TXMLDepartment_xalList.Insert(const Index: Integer): IXMLDepartment_xal;
begin
  Result := AddItem(Index) as IXMLDepartment_xal;
end;

function TXMLDepartment_xalList.Get_Item(Index: Integer): IXMLDepartment_xal;
begin
  Result := List[Index] as IXMLDepartment_xal;
end;

{ TXMLDepartmentName_xal }

function TXMLDepartmentName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLDepartmentName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLDepartmentName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLDepartmentName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLDepartmentName_xalList }

function TXMLDepartmentName_xalList.Add: IXMLDepartmentName_xal;
begin
  Result := AddItem(-1) as IXMLDepartmentName_xal;
end;

function TXMLDepartmentName_xalList.Insert(const Index: Integer): IXMLDepartmentName_xal;
begin
  Result := AddItem(Index) as IXMLDepartmentName_xal;
end;

function TXMLDepartmentName_xalList.Get_Item(Index: Integer): IXMLDepartmentName_xal;
begin
  Result := List[Index] as IXMLDepartmentName_xal;
end;

{ TXMLMailStopType_xal }

procedure TXMLMailStopType_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('MailStopName', TXMLMailStopName_xal);
  RegisterChildNode('MailStopNumber', TXMLMailStopNumber_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  inherited;
end;

function TXMLMailStopType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLMailStopType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLMailStopType_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLMailStopType_xal.Get_MailStopName: IXMLMailStopName_xal;
begin
  Result := ChildNodes['MailStopName'] as IXMLMailStopName_xal;
end;

function TXMLMailStopType_xal.Get_MailStopNumber: IXMLMailStopNumber_xal;
begin
  Result := ChildNodes['MailStopNumber'] as IXMLMailStopNumber_xal;
end;

{ TXMLMailStopName_xal }

function TXMLMailStopName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLMailStopName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLMailStopName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLMailStopName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLMailStopNumber_xal }

function TXMLMailStopNumber_xal.Get_NameNumberSeparator: UnicodeString;
begin
  Result := AttributeNodes['NameNumberSeparator'].Text;
end;

procedure TXMLMailStopNumber_xal.Set_NameNumberSeparator(Value: UnicodeString);
begin
  SetAttribute('NameNumberSeparator', Value);
end;

function TXMLMailStopNumber_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLMailStopNumber_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostalCode_xal }

procedure TXMLPostalCode_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('PostalCodeNumber', TXMLPostalCodeNumber_xal);
  RegisterChildNode('PostalCodeNumberExtension', TXMLPostalCodeNumberExtension_xal);
  RegisterChildNode('PostTown', TXMLPostTown_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FPostalCodeNumber := CreateCollection(TXMLPostalCodeNumber_xalList, IXMLPostalCodeNumber_xal, 'PostalCodeNumber') as IXMLPostalCodeNumber_xalList;
  FPostalCodeNumberExtension := CreateCollection(TXMLPostalCodeNumberExtension_xalList, IXMLPostalCodeNumberExtension_xal, 'PostalCodeNumberExtension') as IXMLPostalCodeNumberExtension_xalList;
  inherited;
end;

function TXMLPostalCode_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostalCode_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostalCode_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLPostalCode_xal.Get_PostalCodeNumber: IXMLPostalCodeNumber_xalList;
begin
  Result := FPostalCodeNumber;
end;

function TXMLPostalCode_xal.Get_PostalCodeNumberExtension: IXMLPostalCodeNumberExtension_xalList;
begin
  Result := FPostalCodeNumberExtension;
end;

function TXMLPostalCode_xal.Get_PostTown: IXMLPostTown_xal;
begin
  Result := ChildNodes['PostTown'] as IXMLPostTown_xal;
end;

{ TXMLPostalCodeNumber_xal }

function TXMLPostalCodeNumber_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostalCodeNumber_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostalCodeNumber_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostalCodeNumber_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostalCodeNumber_xalList }

function TXMLPostalCodeNumber_xalList.Add: IXMLPostalCodeNumber_xal;
begin
  Result := AddItem(-1) as IXMLPostalCodeNumber_xal;
end;

function TXMLPostalCodeNumber_xalList.Insert(const Index: Integer): IXMLPostalCodeNumber_xal;
begin
  Result := AddItem(Index) as IXMLPostalCodeNumber_xal;
end;

function TXMLPostalCodeNumber_xalList.Get_Item(Index: Integer): IXMLPostalCodeNumber_xal;
begin
  Result := List[Index] as IXMLPostalCodeNumber_xal;
end;

{ TXMLPostalCodeNumberExtension_xal }

function TXMLPostalCodeNumberExtension_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostalCodeNumberExtension_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostalCodeNumberExtension_xal.Get_NumberExtensionSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberExtensionSeparator'].Text;
end;

procedure TXMLPostalCodeNumberExtension_xal.Set_NumberExtensionSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberExtensionSeparator', Value);
end;

function TXMLPostalCodeNumberExtension_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostalCodeNumberExtension_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostalCodeNumberExtension_xalList }

function TXMLPostalCodeNumberExtension_xalList.Add: IXMLPostalCodeNumberExtension_xal;
begin
  Result := AddItem(-1) as IXMLPostalCodeNumberExtension_xal;
end;

function TXMLPostalCodeNumberExtension_xalList.Insert(const Index: Integer): IXMLPostalCodeNumberExtension_xal;
begin
  Result := AddItem(Index) as IXMLPostalCodeNumberExtension_xal;
end;

function TXMLPostalCodeNumberExtension_xalList.Get_Item(Index: Integer): IXMLPostalCodeNumberExtension_xal;
begin
  Result := List[Index] as IXMLPostalCodeNumberExtension_xal;
end;

{ TXMLPostTown_xal }

procedure TXMLPostTown_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('PostTownName', TXMLPostTownName_xal);
  RegisterChildNode('PostTownSuffix', TXMLPostTownSuffix_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FPostTownName := CreateCollection(TXMLPostTownName_xalList, IXMLPostTownName_xal, 'PostTownName') as IXMLPostTownName_xalList;
  inherited;
end;

function TXMLPostTown_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostTown_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostTown_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLPostTown_xal.Get_PostTownName: IXMLPostTownName_xalList;
begin
  Result := FPostTownName;
end;

function TXMLPostTown_xal.Get_PostTownSuffix: IXMLPostTownSuffix_xal;
begin
  Result := ChildNodes['PostTownSuffix'] as IXMLPostTownSuffix_xal;
end;

{ TXMLPostTownName_xal }

function TXMLPostTownName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostTownName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostTownName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostTownName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostTownName_xalList }

function TXMLPostTownName_xalList.Add: IXMLPostTownName_xal;
begin
  Result := AddItem(-1) as IXMLPostTownName_xal;
end;

function TXMLPostTownName_xalList.Insert(const Index: Integer): IXMLPostTownName_xal;
begin
  Result := AddItem(Index) as IXMLPostTownName_xal;
end;

function TXMLPostTownName_xalList.Get_Item(Index: Integer): IXMLPostTownName_xal;
begin
  Result := List[Index] as IXMLPostTownName_xal;
end;

{ TXMLPostTownSuffix_xal }

function TXMLPostTownSuffix_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostTownSuffix_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLLargeMailUserType_xal }

procedure TXMLLargeMailUserType_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('LargeMailUserName', TXMLLargeMailUserName_xal);
  RegisterChildNode('LargeMailUserIdentifier', TXMLLargeMailUserIdentifier_xal);
  RegisterChildNode('BuildingName', TXMLBuildingNameType_xal);
  RegisterChildNode('Department', TXMLDepartment_xal);
  RegisterChildNode('PostBox', TXMLPostBox_xal);
  RegisterChildNode('Thoroughfare', TXMLThoroughfare_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FLargeMailUserName := CreateCollection(TXMLLargeMailUserName_xalList, IXMLLargeMailUserName_xal, 'LargeMailUserName') as IXMLLargeMailUserName_xalList;
  FBuildingName := CreateCollection(TXMLBuildingNameType_xalList, IXMLBuildingNameType_xal, 'BuildingName') as IXMLBuildingNameType_xalList;
  inherited;
end;

function TXMLLargeMailUserType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLLargeMailUserType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLLargeMailUserType_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLLargeMailUserType_xal.Get_LargeMailUserName: IXMLLargeMailUserName_xalList;
begin
  Result := FLargeMailUserName;
end;

function TXMLLargeMailUserType_xal.Get_LargeMailUserIdentifier: IXMLLargeMailUserIdentifier_xal;
begin
  Result := ChildNodes['LargeMailUserIdentifier'] as IXMLLargeMailUserIdentifier_xal;
end;

function TXMLLargeMailUserType_xal.Get_BuildingName: IXMLBuildingNameType_xalList;
begin
  Result := FBuildingName;
end;

function TXMLLargeMailUserType_xal.Get_Department: IXMLDepartment_xal;
begin
  Result := ChildNodes['Department'] as IXMLDepartment_xal;
end;

function TXMLLargeMailUserType_xal.Get_PostBox: IXMLPostBox_xal;
begin
  Result := ChildNodes['PostBox'] as IXMLPostBox_xal;
end;

function TXMLLargeMailUserType_xal.Get_Thoroughfare: IXMLThoroughfare_xal;
begin
  Result := ChildNodes['Thoroughfare'] as IXMLThoroughfare_xal;
end;

function TXMLLargeMailUserType_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLLargeMailUserName_xal }

function TXMLLargeMailUserName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLLargeMailUserName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLLargeMailUserName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLLargeMailUserName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLLargeMailUserName_xalList }

function TXMLLargeMailUserName_xalList.Add: IXMLLargeMailUserName_xal;
begin
  Result := AddItem(-1) as IXMLLargeMailUserName_xal;
end;

function TXMLLargeMailUserName_xalList.Insert(const Index: Integer): IXMLLargeMailUserName_xal;
begin
  Result := AddItem(Index) as IXMLLargeMailUserName_xal;
end;

function TXMLLargeMailUserName_xalList.Get_Item(Index: Integer): IXMLLargeMailUserName_xal;
begin
  Result := List[Index] as IXMLLargeMailUserName_xal;
end;

{ TXMLLargeMailUserIdentifier_xal }

function TXMLLargeMailUserIdentifier_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLLargeMailUserIdentifier_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLLargeMailUserIdentifier_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLLargeMailUserIdentifier_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLLargeMailUserIdentifier_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLLargeMailUserIdentifier_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLBuildingNameType_xal }

function TXMLBuildingNameType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLBuildingNameType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLBuildingNameType_xal.Get_TypeOccurrence: UnicodeString;
begin
  Result := AttributeNodes['TypeOccurrence'].Text;
end;

procedure TXMLBuildingNameType_xal.Set_TypeOccurrence(Value: UnicodeString);
begin
  SetAttribute('TypeOccurrence', Value);
end;

function TXMLBuildingNameType_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLBuildingNameType_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLBuildingNameType_xalList }

function TXMLBuildingNameType_xalList.Add: IXMLBuildingNameType_xal;
begin
  Result := AddItem(-1) as IXMLBuildingNameType_xal;
end;

function TXMLBuildingNameType_xalList.Insert(const Index: Integer): IXMLBuildingNameType_xal;
begin
  Result := AddItem(Index) as IXMLBuildingNameType_xal;
end;

function TXMLBuildingNameType_xalList.Get_Item(Index: Integer): IXMLBuildingNameType_xal;
begin
  Result := List[Index] as IXMLBuildingNameType_xal;
end;

{ TXMLThoroughfare_xal }

procedure TXMLThoroughfare_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('ThoroughfareNumber', TXMLThoroughfareNumber_xal);
  RegisterChildNode('ThoroughfareNumberRange', TXMLThoroughfareNumberRange_xal);
  RegisterChildNode('ThoroughfareNumberPrefix', TXMLThoroughfareNumberPrefix_xal);
  RegisterChildNode('ThoroughfareNumberSuffix', TXMLThoroughfareNumberSuffix_xal);
  RegisterChildNode('ThoroughfarePreDirection', TXMLThoroughfarePreDirectionType_xal);
  RegisterChildNode('ThoroughfareLeadingType', TXMLThoroughfareLeadingTypeType_xal);
  RegisterChildNode('ThoroughfareName', TXMLThoroughfareNameType_xal);
  RegisterChildNode('ThoroughfareTrailingType', TXMLThoroughfareTrailingTypeType_xal);
  RegisterChildNode('ThoroughfarePostDirection', TXMLThoroughfarePostDirectionType_xal);
  RegisterChildNode('DependentThoroughfare', TXMLDependentThoroughfare_xal);
  RegisterChildNode('DependentLocality', TXMLDependentLocalityType_xal);
  RegisterChildNode('Premise', TXMLPremise_xal);
  RegisterChildNode('Firm', TXMLFirmType_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FThoroughfareNumber := CreateCollection(TXMLThoroughfareNumber_xalList, IXMLThoroughfareNumber_xal, 'ThoroughfareNumber') as IXMLThoroughfareNumber_xalList;
  FThoroughfareNumberRange := CreateCollection(TXMLThoroughfareNumberRange_xalList, IXMLThoroughfareNumberRange_xal, 'ThoroughfareNumberRange') as IXMLThoroughfareNumberRange_xalList;
  FThoroughfareNumberPrefix := CreateCollection(TXMLThoroughfareNumberPrefix_xalList, IXMLThoroughfareNumberPrefix_xal, 'ThoroughfareNumberPrefix') as IXMLThoroughfareNumberPrefix_xalList;
  FThoroughfareNumberSuffix := CreateCollection(TXMLThoroughfareNumberSuffix_xalList, IXMLThoroughfareNumberSuffix_xal, 'ThoroughfareNumberSuffix') as IXMLThoroughfareNumberSuffix_xalList;
  FThoroughfareName := CreateCollection(TXMLThoroughfareNameType_xalList, IXMLThoroughfareNameType_xal, 'ThoroughfareName') as IXMLThoroughfareNameType_xalList;
  inherited;
end;

function TXMLThoroughfare_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfare_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfare_xal.Get_DependentThoroughfares: UnicodeString;
begin
  Result := AttributeNodes['DependentThoroughfares'].Text;
end;

procedure TXMLThoroughfare_xal.Set_DependentThoroughfares(Value: UnicodeString);
begin
  SetAttribute('DependentThoroughfares', Value);
end;

function TXMLThoroughfare_xal.Get_DependentThoroughfaresIndicator: UnicodeString;
begin
  Result := AttributeNodes['DependentThoroughfaresIndicator'].Text;
end;

procedure TXMLThoroughfare_xal.Set_DependentThoroughfaresIndicator(Value: UnicodeString);
begin
  SetAttribute('DependentThoroughfaresIndicator', Value);
end;

function TXMLThoroughfare_xal.Get_DependentThoroughfaresConnector: UnicodeString;
begin
  Result := AttributeNodes['DependentThoroughfaresConnector'].Text;
end;

procedure TXMLThoroughfare_xal.Set_DependentThoroughfaresConnector(Value: UnicodeString);
begin
  SetAttribute('DependentThoroughfaresConnector', Value);
end;

function TXMLThoroughfare_xal.Get_DependentThoroughfaresType: UnicodeString;
begin
  Result := AttributeNodes['DependentThoroughfaresType'].Text;
end;

procedure TXMLThoroughfare_xal.Set_DependentThoroughfaresType(Value: UnicodeString);
begin
  SetAttribute('DependentThoroughfaresType', Value);
end;

function TXMLThoroughfare_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLThoroughfare_xal.Get_ThoroughfareNumber: IXMLThoroughfareNumber_xalList;
begin
  Result := FThoroughfareNumber;
end;

function TXMLThoroughfare_xal.Get_ThoroughfareNumberRange: IXMLThoroughfareNumberRange_xalList;
begin
  Result := FThoroughfareNumberRange;
end;

function TXMLThoroughfare_xal.Get_ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
begin
  Result := FThoroughfareNumberPrefix;
end;

function TXMLThoroughfare_xal.Get_ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
begin
  Result := FThoroughfareNumberSuffix;
end;

function TXMLThoroughfare_xal.Get_ThoroughfarePreDirection: IXMLThoroughfarePreDirectionType_xal;
begin
  Result := ChildNodes['ThoroughfarePreDirection'] as IXMLThoroughfarePreDirectionType_xal;
end;

function TXMLThoroughfare_xal.Get_ThoroughfareLeadingType: IXMLThoroughfareLeadingTypeType_xal;
begin
  Result := ChildNodes['ThoroughfareLeadingType'] as IXMLThoroughfareLeadingTypeType_xal;
end;

function TXMLThoroughfare_xal.Get_ThoroughfareName: IXMLThoroughfareNameType_xalList;
begin
  Result := FThoroughfareName;
end;

function TXMLThoroughfare_xal.Get_ThoroughfareTrailingType: IXMLThoroughfareTrailingTypeType_xal;
begin
  Result := ChildNodes['ThoroughfareTrailingType'] as IXMLThoroughfareTrailingTypeType_xal;
end;

function TXMLThoroughfare_xal.Get_ThoroughfarePostDirection: IXMLThoroughfarePostDirectionType_xal;
begin
  Result := ChildNodes['ThoroughfarePostDirection'] as IXMLThoroughfarePostDirectionType_xal;
end;

function TXMLThoroughfare_xal.Get_DependentThoroughfare: IXMLDependentThoroughfare_xal;
begin
  Result := ChildNodes['DependentThoroughfare'] as IXMLDependentThoroughfare_xal;
end;

function TXMLThoroughfare_xal.Get_DependentLocality: IXMLDependentLocalityType_xal;
begin
  Result := ChildNodes['DependentLocality'] as IXMLDependentLocalityType_xal;
end;

function TXMLThoroughfare_xal.Get_Premise: IXMLPremise_xal;
begin
  Result := ChildNodes['Premise'] as IXMLPremise_xal;
end;

function TXMLThoroughfare_xal.Get_Firm: IXMLFirmType_xal;
begin
  Result := ChildNodes['Firm'] as IXMLFirmType_xal;
end;

function TXMLThoroughfare_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLThoroughfareNumber_xal }

function TXMLThoroughfareNumber_xal.Get_NumberType: UnicodeString;
begin
  Result := AttributeNodes['NumberType'].Text;
end;

procedure TXMLThoroughfareNumber_xal.Set_NumberType(Value: UnicodeString);
begin
  SetAttribute('NumberType', Value);
end;

function TXMLThoroughfareNumber_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfareNumber_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfareNumber_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLThoroughfareNumber_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLThoroughfareNumber_xal.Get_IndicatorOccurrence: UnicodeString;
begin
  Result := AttributeNodes['IndicatorOccurrence'].Text;
end;

procedure TXMLThoroughfareNumber_xal.Set_IndicatorOccurrence(Value: UnicodeString);
begin
  SetAttribute('IndicatorOccurrence', Value);
end;

function TXMLThoroughfareNumber_xal.Get_NumberOccurrence: UnicodeString;
begin
  Result := AttributeNodes['NumberOccurrence'].Text;
end;

procedure TXMLThoroughfareNumber_xal.Set_NumberOccurrence(Value: UnicodeString);
begin
  SetAttribute('NumberOccurrence', Value);
end;

function TXMLThoroughfareNumber_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfareNumber_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLThoroughfareNumber_xalList }

function TXMLThoroughfareNumber_xalList.Add: IXMLThoroughfareNumber_xal;
begin
  Result := AddItem(-1) as IXMLThoroughfareNumber_xal;
end;

function TXMLThoroughfareNumber_xalList.Insert(const Index: Integer): IXMLThoroughfareNumber_xal;
begin
  Result := AddItem(Index) as IXMLThoroughfareNumber_xal;
end;

function TXMLThoroughfareNumber_xalList.Get_Item(Index: Integer): IXMLThoroughfareNumber_xal;
begin
  Result := List[Index] as IXMLThoroughfareNumber_xal;
end;

{ TXMLThoroughfareNumberRange_xal }

procedure TXMLThoroughfareNumberRange_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('ThoroughfareNumberFrom', TXMLThoroughfareNumberFrom_xal);
  RegisterChildNode('ThoroughfareNumberTo', TXMLThoroughfareNumberTo_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  inherited;
end;

function TXMLThoroughfareNumberRange_xal.Get_RangeType: UnicodeString;
begin
  Result := AttributeNodes['RangeType'].Text;
end;

procedure TXMLThoroughfareNumberRange_xal.Set_RangeType(Value: UnicodeString);
begin
  SetAttribute('RangeType', Value);
end;

function TXMLThoroughfareNumberRange_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLThoroughfareNumberRange_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLThoroughfareNumberRange_xal.Get_Separator: UnicodeString;
begin
  Result := AttributeNodes['Separator'].Text;
end;

procedure TXMLThoroughfareNumberRange_xal.Set_Separator(Value: UnicodeString);
begin
  SetAttribute('Separator', Value);
end;

function TXMLThoroughfareNumberRange_xal.Get_IndicatorOccurrence: UnicodeString;
begin
  Result := AttributeNodes['IndicatorOccurrence'].Text;
end;

procedure TXMLThoroughfareNumberRange_xal.Set_IndicatorOccurrence(Value: UnicodeString);
begin
  SetAttribute('IndicatorOccurrence', Value);
end;

function TXMLThoroughfareNumberRange_xal.Get_NumberRangeOccurrence: UnicodeString;
begin
  Result := AttributeNodes['NumberRangeOccurrence'].Text;
end;

procedure TXMLThoroughfareNumberRange_xal.Set_NumberRangeOccurrence(Value: UnicodeString);
begin
  SetAttribute('NumberRangeOccurrence', Value);
end;

function TXMLThoroughfareNumberRange_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfareNumberRange_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfareNumberRange_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfareNumberRange_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

function TXMLThoroughfareNumberRange_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLThoroughfareNumberRange_xal.Get_ThoroughfareNumberFrom: IXMLThoroughfareNumberFrom_xal;
begin
  Result := ChildNodes['ThoroughfareNumberFrom'] as IXMLThoroughfareNumberFrom_xal;
end;

function TXMLThoroughfareNumberRange_xal.Get_ThoroughfareNumberTo: IXMLThoroughfareNumberTo_xal;
begin
  Result := ChildNodes['ThoroughfareNumberTo'] as IXMLThoroughfareNumberTo_xal;
end;

{ TXMLThoroughfareNumberRange_xalList }

function TXMLThoroughfareNumberRange_xalList.Add: IXMLThoroughfareNumberRange_xal;
begin
  Result := AddItem(-1) as IXMLThoroughfareNumberRange_xal;
end;

function TXMLThoroughfareNumberRange_xalList.Insert(const Index: Integer): IXMLThoroughfareNumberRange_xal;
begin
  Result := AddItem(Index) as IXMLThoroughfareNumberRange_xal;
end;

function TXMLThoroughfareNumberRange_xalList.Get_Item(Index: Integer): IXMLThoroughfareNumberRange_xal;
begin
  Result := List[Index] as IXMLThoroughfareNumberRange_xal;
end;

{ TXMLThoroughfareNumberFrom_xal }

procedure TXMLThoroughfareNumberFrom_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('ThoroughfareNumberPrefix', TXMLThoroughfareNumberPrefix_xal);
  RegisterChildNode('ThoroughfareNumber', TXMLThoroughfareNumber_xal);
  RegisterChildNode('ThoroughfareNumberSuffix', TXMLThoroughfareNumberSuffix_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FThoroughfareNumberPrefix := CreateCollection(TXMLThoroughfareNumberPrefix_xalList, IXMLThoroughfareNumberPrefix_xal, 'ThoroughfareNumberPrefix') as IXMLThoroughfareNumberPrefix_xalList;
  FThoroughfareNumber := CreateCollection(TXMLThoroughfareNumber_xalList, IXMLThoroughfareNumber_xal, 'ThoroughfareNumber') as IXMLThoroughfareNumber_xalList;
  FThoroughfareNumberSuffix := CreateCollection(TXMLThoroughfareNumberSuffix_xalList, IXMLThoroughfareNumberSuffix_xal, 'ThoroughfareNumberSuffix') as IXMLThoroughfareNumberSuffix_xalList;
  inherited;
end;

function TXMLThoroughfareNumberFrom_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfareNumberFrom_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

function TXMLThoroughfareNumberFrom_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLThoroughfareNumberFrom_xal.Get_ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
begin
  Result := FThoroughfareNumberPrefix;
end;

function TXMLThoroughfareNumberFrom_xal.Get_ThoroughfareNumber: IXMLThoroughfareNumber_xalList;
begin
  Result := FThoroughfareNumber;
end;

function TXMLThoroughfareNumberFrom_xal.Get_ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
begin
  Result := FThoroughfareNumberSuffix;
end;

{ TXMLThoroughfareNumberPrefix_xal }

function TXMLThoroughfareNumberPrefix_xal.Get_NumberPrefixSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberPrefixSeparator'].Text;
end;

procedure TXMLThoroughfareNumberPrefix_xal.Set_NumberPrefixSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberPrefixSeparator', Value);
end;

function TXMLThoroughfareNumberPrefix_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfareNumberPrefix_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfareNumberPrefix_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfareNumberPrefix_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLThoroughfareNumberPrefix_xalList }

function TXMLThoroughfareNumberPrefix_xalList.Add: IXMLThoroughfareNumberPrefix_xal;
begin
  Result := AddItem(-1) as IXMLThoroughfareNumberPrefix_xal;
end;

function TXMLThoroughfareNumberPrefix_xalList.Insert(const Index: Integer): IXMLThoroughfareNumberPrefix_xal;
begin
  Result := AddItem(Index) as IXMLThoroughfareNumberPrefix_xal;
end;

function TXMLThoroughfareNumberPrefix_xalList.Get_Item(Index: Integer): IXMLThoroughfareNumberPrefix_xal;
begin
  Result := List[Index] as IXMLThoroughfareNumberPrefix_xal;
end;

{ TXMLThoroughfareNumberSuffix_xal }

function TXMLThoroughfareNumberSuffix_xal.Get_NumberSuffixSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberSuffixSeparator'].Text;
end;

procedure TXMLThoroughfareNumberSuffix_xal.Set_NumberSuffixSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberSuffixSeparator', Value);
end;

function TXMLThoroughfareNumberSuffix_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfareNumberSuffix_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfareNumberSuffix_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfareNumberSuffix_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLThoroughfareNumberSuffix_xalList }

function TXMLThoroughfareNumberSuffix_xalList.Add: IXMLThoroughfareNumberSuffix_xal;
begin
  Result := AddItem(-1) as IXMLThoroughfareNumberSuffix_xal;
end;

function TXMLThoroughfareNumberSuffix_xalList.Insert(const Index: Integer): IXMLThoroughfareNumberSuffix_xal;
begin
  Result := AddItem(Index) as IXMLThoroughfareNumberSuffix_xal;
end;

function TXMLThoroughfareNumberSuffix_xalList.Get_Item(Index: Integer): IXMLThoroughfareNumberSuffix_xal;
begin
  Result := List[Index] as IXMLThoroughfareNumberSuffix_xal;
end;

{ TXMLThoroughfareNumberTo_xal }

procedure TXMLThoroughfareNumberTo_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('ThoroughfareNumberPrefix', TXMLThoroughfareNumberPrefix_xal);
  RegisterChildNode('ThoroughfareNumber', TXMLThoroughfareNumber_xal);
  RegisterChildNode('ThoroughfareNumberSuffix', TXMLThoroughfareNumberSuffix_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FThoroughfareNumberPrefix := CreateCollection(TXMLThoroughfareNumberPrefix_xalList, IXMLThoroughfareNumberPrefix_xal, 'ThoroughfareNumberPrefix') as IXMLThoroughfareNumberPrefix_xalList;
  FThoroughfareNumber := CreateCollection(TXMLThoroughfareNumber_xalList, IXMLThoroughfareNumber_xal, 'ThoroughfareNumber') as IXMLThoroughfareNumber_xalList;
  FThoroughfareNumberSuffix := CreateCollection(TXMLThoroughfareNumberSuffix_xalList, IXMLThoroughfareNumberSuffix_xal, 'ThoroughfareNumberSuffix') as IXMLThoroughfareNumberSuffix_xalList;
  inherited;
end;

function TXMLThoroughfareNumberTo_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfareNumberTo_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

function TXMLThoroughfareNumberTo_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLThoroughfareNumberTo_xal.Get_ThoroughfareNumberPrefix: IXMLThoroughfareNumberPrefix_xalList;
begin
  Result := FThoroughfareNumberPrefix;
end;

function TXMLThoroughfareNumberTo_xal.Get_ThoroughfareNumber: IXMLThoroughfareNumber_xalList;
begin
  Result := FThoroughfareNumber;
end;

function TXMLThoroughfareNumberTo_xal.Get_ThoroughfareNumberSuffix: IXMLThoroughfareNumberSuffix_xalList;
begin
  Result := FThoroughfareNumberSuffix;
end;

{ TXMLThoroughfarePreDirectionType_xal }

function TXMLThoroughfarePreDirectionType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfarePreDirectionType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfarePreDirectionType_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfarePreDirectionType_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLThoroughfareLeadingTypeType_xal }

function TXMLThoroughfareLeadingTypeType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfareLeadingTypeType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfareLeadingTypeType_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfareLeadingTypeType_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLThoroughfareNameType_xal }

function TXMLThoroughfareNameType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfareNameType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfareNameType_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfareNameType_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLThoroughfareNameType_xalList }

function TXMLThoroughfareNameType_xalList.Add: IXMLThoroughfareNameType_xal;
begin
  Result := AddItem(-1) as IXMLThoroughfareNameType_xal;
end;

function TXMLThoroughfareNameType_xalList.Insert(const Index: Integer): IXMLThoroughfareNameType_xal;
begin
  Result := AddItem(Index) as IXMLThoroughfareNameType_xal;
end;

function TXMLThoroughfareNameType_xalList.Get_Item(Index: Integer): IXMLThoroughfareNameType_xal;
begin
  Result := List[Index] as IXMLThoroughfareNameType_xal;
end;

{ TXMLThoroughfareTrailingTypeType_xal }

function TXMLThoroughfareTrailingTypeType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfareTrailingTypeType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfareTrailingTypeType_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfareTrailingTypeType_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLThoroughfarePostDirectionType_xal }

function TXMLThoroughfarePostDirectionType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLThoroughfarePostDirectionType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLThoroughfarePostDirectionType_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLThoroughfarePostDirectionType_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLDependentThoroughfare_xal }

procedure TXMLDependentThoroughfare_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('ThoroughfarePreDirection', TXMLThoroughfarePreDirectionType_xal);
  RegisterChildNode('ThoroughfareLeadingType', TXMLThoroughfareLeadingTypeType_xal);
  RegisterChildNode('ThoroughfareName', TXMLThoroughfareNameType_xal);
  RegisterChildNode('ThoroughfareTrailingType', TXMLThoroughfareTrailingTypeType_xal);
  RegisterChildNode('ThoroughfarePostDirection', TXMLThoroughfarePostDirectionType_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FThoroughfareName := CreateCollection(TXMLThoroughfareNameType_xalList, IXMLThoroughfareNameType_xal, 'ThoroughfareName') as IXMLThoroughfareNameType_xalList;
  inherited;
end;

function TXMLDependentThoroughfare_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLDependentThoroughfare_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLDependentThoroughfare_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLDependentThoroughfare_xal.Get_ThoroughfarePreDirection: IXMLThoroughfarePreDirectionType_xal;
begin
  Result := ChildNodes['ThoroughfarePreDirection'] as IXMLThoroughfarePreDirectionType_xal;
end;

function TXMLDependentThoroughfare_xal.Get_ThoroughfareLeadingType: IXMLThoroughfareLeadingTypeType_xal;
begin
  Result := ChildNodes['ThoroughfareLeadingType'] as IXMLThoroughfareLeadingTypeType_xal;
end;

function TXMLDependentThoroughfare_xal.Get_ThoroughfareName: IXMLThoroughfareNameType_xalList;
begin
  Result := FThoroughfareName;
end;

function TXMLDependentThoroughfare_xal.Get_ThoroughfareTrailingType: IXMLThoroughfareTrailingTypeType_xal;
begin
  Result := ChildNodes['ThoroughfareTrailingType'] as IXMLThoroughfareTrailingTypeType_xal;
end;

function TXMLDependentThoroughfare_xal.Get_ThoroughfarePostDirection: IXMLThoroughfarePostDirectionType_xal;
begin
  Result := ChildNodes['ThoroughfarePostDirection'] as IXMLThoroughfarePostDirectionType_xal;
end;

{ TXMLDependentLocalityType_xal }

procedure TXMLDependentLocalityType_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('DependentLocalityName', TXMLDependentLocalityName_xal);
  RegisterChildNode('DependentLocalityNumber', TXMLDependentLocalityNumber_xal);
  RegisterChildNode('PostBox', TXMLPostBox_xal);
  RegisterChildNode('LargeMailUser', TXMLLargeMailUserType_xal);
  RegisterChildNode('PostOffice', TXMLPostOffice_xal);
  RegisterChildNode('PostalRoute', TXMLPostalRouteType_xal);
  RegisterChildNode('Thoroughfare', TXMLThoroughfare_xal);
  RegisterChildNode('Premise', TXMLPremise_xal);
  RegisterChildNode('DependentLocality', TXMLDependentLocalityType_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FDependentLocalityName := CreateCollection(TXMLDependentLocalityName_xalList, IXMLDependentLocalityName_xal, 'DependentLocalityName') as IXMLDependentLocalityName_xalList;
  inherited;
end;

function TXMLDependentLocalityType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLDependentLocalityType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLDependentLocalityType_xal.Get_UsageType: UnicodeString;
begin
  Result := AttributeNodes['UsageType'].Text;
end;

procedure TXMLDependentLocalityType_xal.Set_UsageType(Value: UnicodeString);
begin
  SetAttribute('UsageType', Value);
end;

function TXMLDependentLocalityType_xal.Get_Connector: UnicodeString;
begin
  Result := AttributeNodes['Connector'].Text;
end;

procedure TXMLDependentLocalityType_xal.Set_Connector(Value: UnicodeString);
begin
  SetAttribute('Connector', Value);
end;

function TXMLDependentLocalityType_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLDependentLocalityType_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLDependentLocalityType_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLDependentLocalityType_xal.Get_DependentLocalityName: IXMLDependentLocalityName_xalList;
begin
  Result := FDependentLocalityName;
end;

function TXMLDependentLocalityType_xal.Get_DependentLocalityNumber: IXMLDependentLocalityNumber_xal;
begin
  Result := ChildNodes['DependentLocalityNumber'] as IXMLDependentLocalityNumber_xal;
end;

function TXMLDependentLocalityType_xal.Get_PostBox: IXMLPostBox_xal;
begin
  Result := ChildNodes['PostBox'] as IXMLPostBox_xal;
end;

function TXMLDependentLocalityType_xal.Get_LargeMailUser: IXMLLargeMailUserType_xal;
begin
  Result := ChildNodes['LargeMailUser'] as IXMLLargeMailUserType_xal;
end;

function TXMLDependentLocalityType_xal.Get_PostOffice: IXMLPostOffice_xal;
begin
  Result := ChildNodes['PostOffice'] as IXMLPostOffice_xal;
end;

function TXMLDependentLocalityType_xal.Get_PostalRoute: IXMLPostalRouteType_xal;
begin
  Result := ChildNodes['PostalRoute'] as IXMLPostalRouteType_xal;
end;

function TXMLDependentLocalityType_xal.Get_Thoroughfare: IXMLThoroughfare_xal;
begin
  Result := ChildNodes['Thoroughfare'] as IXMLThoroughfare_xal;
end;

function TXMLDependentLocalityType_xal.Get_Premise: IXMLPremise_xal;
begin
  Result := ChildNodes['Premise'] as IXMLPremise_xal;
end;

function TXMLDependentLocalityType_xal.Get_DependentLocality: IXMLDependentLocalityType_xal;
begin
  Result := ChildNodes['DependentLocality'] as IXMLDependentLocalityType_xal;
end;

function TXMLDependentLocalityType_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLDependentLocalityName_xal }

function TXMLDependentLocalityName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLDependentLocalityName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLDependentLocalityName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLDependentLocalityName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLDependentLocalityName_xalList }

function TXMLDependentLocalityName_xalList.Add: IXMLDependentLocalityName_xal;
begin
  Result := AddItem(-1) as IXMLDependentLocalityName_xal;
end;

function TXMLDependentLocalityName_xalList.Insert(const Index: Integer): IXMLDependentLocalityName_xal;
begin
  Result := AddItem(Index) as IXMLDependentLocalityName_xal;
end;

function TXMLDependentLocalityName_xalList.Get_Item(Index: Integer): IXMLDependentLocalityName_xal;
begin
  Result := List[Index] as IXMLDependentLocalityName_xal;
end;

{ TXMLDependentLocalityNumber_xal }

function TXMLDependentLocalityNumber_xal.Get_NameNumberOccurrence: UnicodeString;
begin
  Result := AttributeNodes['NameNumberOccurrence'].Text;
end;

procedure TXMLDependentLocalityNumber_xal.Set_NameNumberOccurrence(Value: UnicodeString);
begin
  SetAttribute('NameNumberOccurrence', Value);
end;

function TXMLDependentLocalityNumber_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLDependentLocalityNumber_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostOffice_xal }

procedure TXMLPostOffice_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('PostOfficeName', TXMLPostOfficeName_xal);
  RegisterChildNode('PostOfficeNumber', TXMLPostOfficeNumber_xal);
  RegisterChildNode('PostalRoute', TXMLPostalRouteType_xal);
  RegisterChildNode('PostBox', TXMLPostBox_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FPostOfficeName := CreateCollection(TXMLPostOfficeName_xalList, IXMLPostOfficeName_xal, 'PostOfficeName') as IXMLPostOfficeName_xalList;
  inherited;
end;

function TXMLPostOffice_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostOffice_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostOffice_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLPostOffice_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLPostOffice_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLPostOffice_xal.Get_PostOfficeName: IXMLPostOfficeName_xalList;
begin
  Result := FPostOfficeName;
end;

function TXMLPostOffice_xal.Get_PostOfficeNumber: IXMLPostOfficeNumber_xal;
begin
  Result := ChildNodes['PostOfficeNumber'] as IXMLPostOfficeNumber_xal;
end;

function TXMLPostOffice_xal.Get_PostalRoute: IXMLPostalRouteType_xal;
begin
  Result := ChildNodes['PostalRoute'] as IXMLPostalRouteType_xal;
end;

function TXMLPostOffice_xal.Get_PostBox: IXMLPostBox_xal;
begin
  Result := ChildNodes['PostBox'] as IXMLPostBox_xal;
end;

function TXMLPostOffice_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

{ TXMLPostOfficeName_xal }

function TXMLPostOfficeName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostOfficeName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostOfficeName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostOfficeName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostOfficeName_xalList }

function TXMLPostOfficeName_xalList.Add: IXMLPostOfficeName_xal;
begin
  Result := AddItem(-1) as IXMLPostOfficeName_xal;
end;

function TXMLPostOfficeName_xalList.Insert(const Index: Integer): IXMLPostOfficeName_xal;
begin
  Result := AddItem(Index) as IXMLPostOfficeName_xal;
end;

function TXMLPostOfficeName_xalList.Get_Item(Index: Integer): IXMLPostOfficeName_xal;
begin
  Result := List[Index] as IXMLPostOfficeName_xal;
end;

{ TXMLPostOfficeNumber_xal }

function TXMLPostOfficeNumber_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLPostOfficeNumber_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLPostOfficeNumber_xal.Get_IndicatorOccurrence: UnicodeString;
begin
  Result := AttributeNodes['IndicatorOccurrence'].Text;
end;

procedure TXMLPostOfficeNumber_xal.Set_IndicatorOccurrence(Value: UnicodeString);
begin
  SetAttribute('IndicatorOccurrence', Value);
end;

function TXMLPostOfficeNumber_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostOfficeNumber_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostalRouteType_xal }

procedure TXMLPostalRouteType_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('PostalRouteName', TXMLPostalRouteName_xal);
  RegisterChildNode('PostalRouteNumber', TXMLPostalRouteNumber_xal);
  RegisterChildNode('PostBox', TXMLPostBox_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FPostalRouteName := CreateCollection(TXMLPostalRouteName_xalList, IXMLPostalRouteName_xal, 'PostalRouteName') as IXMLPostalRouteName_xalList;
  inherited;
end;

function TXMLPostalRouteType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostalRouteType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostalRouteType_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLPostalRouteType_xal.Get_PostalRouteName: IXMLPostalRouteName_xalList;
begin
  Result := FPostalRouteName;
end;

function TXMLPostalRouteType_xal.Get_PostalRouteNumber: IXMLPostalRouteNumber_xal;
begin
  Result := ChildNodes['PostalRouteNumber'] as IXMLPostalRouteNumber_xal;
end;

function TXMLPostalRouteType_xal.Get_PostBox: IXMLPostBox_xal;
begin
  Result := ChildNodes['PostBox'] as IXMLPostBox_xal;
end;

{ TXMLPostalRouteName_xal }

function TXMLPostalRouteName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPostalRouteName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPostalRouteName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostalRouteName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPostalRouteName_xalList }

function TXMLPostalRouteName_xalList.Add: IXMLPostalRouteName_xal;
begin
  Result := AddItem(-1) as IXMLPostalRouteName_xal;
end;

function TXMLPostalRouteName_xalList.Insert(const Index: Integer): IXMLPostalRouteName_xal;
begin
  Result := AddItem(Index) as IXMLPostalRouteName_xal;
end;

function TXMLPostalRouteName_xalList.Get_Item(Index: Integer): IXMLPostalRouteName_xal;
begin
  Result := List[Index] as IXMLPostalRouteName_xal;
end;

{ TXMLPostalRouteNumber_xal }

function TXMLPostalRouteNumber_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPostalRouteNumber_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPremise_xal }

procedure TXMLPremise_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('PremiseName', TXMLPremiseName_xal);
  RegisterChildNode('PremiseLocation', TXMLPremiseLocation_xal);
  RegisterChildNode('PremiseNumber', TXMLPremiseNumber_xal);
  RegisterChildNode('PremiseNumberRange', TXMLPremiseNumberRange_xal);
  RegisterChildNode('PremiseNumberPrefix', TXMLPremiseNumberPrefix_xal);
  RegisterChildNode('PremiseNumberSuffix', TXMLPremiseNumberSuffix_xal);
  RegisterChildNode('BuildingName', TXMLBuildingNameType_xal);
  RegisterChildNode('SubPremise', TXMLSubPremiseType_xal);
  RegisterChildNode('Firm', TXMLFirmType_xal);
  RegisterChildNode('MailStop', TXMLMailStopType_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  RegisterChildNode('Premise', TXMLPremise_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FPremiseName := CreateCollection(TXMLPremiseName_xalList, IXMLPremiseName_xal, 'PremiseName') as IXMLPremiseName_xalList;
  FPremiseNumber := CreateCollection(TXMLPremiseNumber_xalList, IXMLPremiseNumber_xal, 'PremiseNumber') as IXMLPremiseNumber_xalList;
  FPremiseNumberPrefix := CreateCollection(TXMLPremiseNumberPrefix_xalList, IXMLPremiseNumberPrefix_xal, 'PremiseNumberPrefix') as IXMLPremiseNumberPrefix_xalList;
  FPremiseNumberSuffix := CreateCollection(TXMLPremiseNumberSuffix_xalList, IXMLPremiseNumberSuffix_xal, 'PremiseNumberSuffix') as IXMLPremiseNumberSuffix_xalList;
  FBuildingName := CreateCollection(TXMLBuildingNameType_xalList, IXMLBuildingNameType_xal, 'BuildingName') as IXMLBuildingNameType_xalList;
  FSubPremise := CreateCollection(TXMLSubPremiseType_xalList, IXMLSubPremiseType_xal, 'SubPremise') as IXMLSubPremiseType_xalList;
  inherited;
end;

function TXMLPremise_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPremise_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPremise_xal.Get_PremiseDependency: UnicodeString;
begin
  Result := AttributeNodes['PremiseDependency'].Text;
end;

procedure TXMLPremise_xal.Set_PremiseDependency(Value: UnicodeString);
begin
  SetAttribute('PremiseDependency', Value);
end;

function TXMLPremise_xal.Get_PremiseDependencyType: UnicodeString;
begin
  Result := AttributeNodes['PremiseDependencyType'].Text;
end;

procedure TXMLPremise_xal.Set_PremiseDependencyType(Value: UnicodeString);
begin
  SetAttribute('PremiseDependencyType', Value);
end;

function TXMLPremise_xal.Get_PremiseThoroughfareConnector: UnicodeString;
begin
  Result := AttributeNodes['PremiseThoroughfareConnector'].Text;
end;

procedure TXMLPremise_xal.Set_PremiseThoroughfareConnector(Value: UnicodeString);
begin
  SetAttribute('PremiseThoroughfareConnector', Value);
end;

function TXMLPremise_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLPremise_xal.Get_PremiseName: IXMLPremiseName_xalList;
begin
  Result := FPremiseName;
end;

function TXMLPremise_xal.Get_PremiseLocation: IXMLPremiseLocation_xal;
begin
  Result := ChildNodes['PremiseLocation'] as IXMLPremiseLocation_xal;
end;

function TXMLPremise_xal.Get_PremiseNumber: IXMLPremiseNumber_xalList;
begin
  Result := FPremiseNumber;
end;

function TXMLPremise_xal.Get_PremiseNumberRange: IXMLPremiseNumberRange_xal;
begin
  Result := ChildNodes['PremiseNumberRange'] as IXMLPremiseNumberRange_xal;
end;

function TXMLPremise_xal.Get_PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
begin
  Result := FPremiseNumberPrefix;
end;

function TXMLPremise_xal.Get_PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
begin
  Result := FPremiseNumberSuffix;
end;

function TXMLPremise_xal.Get_BuildingName: IXMLBuildingNameType_xalList;
begin
  Result := FBuildingName;
end;

function TXMLPremise_xal.Get_SubPremise: IXMLSubPremiseType_xalList;
begin
  Result := FSubPremise;
end;

function TXMLPremise_xal.Get_Firm: IXMLFirmType_xal;
begin
  Result := ChildNodes['Firm'] as IXMLFirmType_xal;
end;

function TXMLPremise_xal.Get_MailStop: IXMLMailStopType_xal;
begin
  Result := ChildNodes['MailStop'] as IXMLMailStopType_xal;
end;

function TXMLPremise_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

function TXMLPremise_xal.Get_Premise: IXMLPremise_xal;
begin
  Result := ChildNodes['Premise'] as IXMLPremise_xal;
end;

{ TXMLPremiseName_xal }

function TXMLPremiseName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPremiseName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPremiseName_xal.Get_TypeOccurrence: UnicodeString;
begin
  Result := AttributeNodes['TypeOccurrence'].Text;
end;

procedure TXMLPremiseName_xal.Set_TypeOccurrence(Value: UnicodeString);
begin
  SetAttribute('TypeOccurrence', Value);
end;

function TXMLPremiseName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPremiseName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPremiseName_xalList }

function TXMLPremiseName_xalList.Add: IXMLPremiseName_xal;
begin
  Result := AddItem(-1) as IXMLPremiseName_xal;
end;

function TXMLPremiseName_xalList.Insert(const Index: Integer): IXMLPremiseName_xal;
begin
  Result := AddItem(Index) as IXMLPremiseName_xal;
end;

function TXMLPremiseName_xalList.Get_Item(Index: Integer): IXMLPremiseName_xal;
begin
  Result := List[Index] as IXMLPremiseName_xal;
end;

{ TXMLPremiseLocation_xal }

function TXMLPremiseLocation_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPremiseLocation_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPremiseNumber_xal }

function TXMLPremiseNumber_xal.Get_NumberType: UnicodeString;
begin
  Result := AttributeNodes['NumberType'].Text;
end;

procedure TXMLPremiseNumber_xal.Set_NumberType(Value: UnicodeString);
begin
  SetAttribute('NumberType', Value);
end;

function TXMLPremiseNumber_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPremiseNumber_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPremiseNumber_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLPremiseNumber_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLPremiseNumber_xal.Get_IndicatorOccurrence: UnicodeString;
begin
  Result := AttributeNodes['IndicatorOccurrence'].Text;
end;

procedure TXMLPremiseNumber_xal.Set_IndicatorOccurrence(Value: UnicodeString);
begin
  SetAttribute('IndicatorOccurrence', Value);
end;

function TXMLPremiseNumber_xal.Get_NumberTypeOccurrence: UnicodeString;
begin
  Result := AttributeNodes['NumberTypeOccurrence'].Text;
end;

procedure TXMLPremiseNumber_xal.Set_NumberTypeOccurrence(Value: UnicodeString);
begin
  SetAttribute('NumberTypeOccurrence', Value);
end;

function TXMLPremiseNumber_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPremiseNumber_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPremiseNumber_xalList }

function TXMLPremiseNumber_xalList.Add: IXMLPremiseNumber_xal;
begin
  Result := AddItem(-1) as IXMLPremiseNumber_xal;
end;

function TXMLPremiseNumber_xalList.Insert(const Index: Integer): IXMLPremiseNumber_xal;
begin
  Result := AddItem(Index) as IXMLPremiseNumber_xal;
end;

function TXMLPremiseNumber_xalList.Get_Item(Index: Integer): IXMLPremiseNumber_xal;
begin
  Result := List[Index] as IXMLPremiseNumber_xal;
end;

{ TXMLPremiseNumberRange_xal }

procedure TXMLPremiseNumberRange_xal.AfterConstruction;
begin
  RegisterChildNode('PremiseNumberRangeFrom', TXMLPremiseNumberRangeFrom_xal);
  RegisterChildNode('PremiseNumberRangeTo', TXMLPremiseNumberRangeTo_xal);
  inherited;
end;

function TXMLPremiseNumberRange_xal.Get_RangeType: UnicodeString;
begin
  Result := AttributeNodes['RangeType'].Text;
end;

procedure TXMLPremiseNumberRange_xal.Set_RangeType(Value: UnicodeString);
begin
  SetAttribute('RangeType', Value);
end;

function TXMLPremiseNumberRange_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLPremiseNumberRange_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLPremiseNumberRange_xal.Get_Separator: UnicodeString;
begin
  Result := AttributeNodes['Separator'].Text;
end;

procedure TXMLPremiseNumberRange_xal.Set_Separator(Value: UnicodeString);
begin
  SetAttribute('Separator', Value);
end;

function TXMLPremiseNumberRange_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPremiseNumberRange_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPremiseNumberRange_xal.Get_IndicatorOccurence: UnicodeString;
begin
  Result := AttributeNodes['IndicatorOccurence'].Text;
end;

procedure TXMLPremiseNumberRange_xal.Set_IndicatorOccurence(Value: UnicodeString);
begin
  SetAttribute('IndicatorOccurence', Value);
end;

function TXMLPremiseNumberRange_xal.Get_NumberRangeOccurence: UnicodeString;
begin
  Result := AttributeNodes['NumberRangeOccurence'].Text;
end;

procedure TXMLPremiseNumberRange_xal.Set_NumberRangeOccurence(Value: UnicodeString);
begin
  SetAttribute('NumberRangeOccurence', Value);
end;

function TXMLPremiseNumberRange_xal.Get_PremiseNumberRangeFrom: IXMLPremiseNumberRangeFrom_xal;
begin
  Result := ChildNodes['PremiseNumberRangeFrom'] as IXMLPremiseNumberRangeFrom_xal;
end;

function TXMLPremiseNumberRange_xal.Get_PremiseNumberRangeTo: IXMLPremiseNumberRangeTo_xal;
begin
  Result := ChildNodes['PremiseNumberRangeTo'] as IXMLPremiseNumberRangeTo_xal;
end;

{ TXMLPremiseNumberRangeFrom_xal }

procedure TXMLPremiseNumberRangeFrom_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('PremiseNumberPrefix', TXMLPremiseNumberPrefix_xal);
  RegisterChildNode('PremiseNumber', TXMLPremiseNumber_xal);
  RegisterChildNode('PremiseNumberSuffix', TXMLPremiseNumberSuffix_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FPremiseNumberPrefix := CreateCollection(TXMLPremiseNumberPrefix_xalList, IXMLPremiseNumberPrefix_xal, 'PremiseNumberPrefix') as IXMLPremiseNumberPrefix_xalList;
  FPremiseNumber := CreateCollection(TXMLPremiseNumber_xalList, IXMLPremiseNumber_xal, 'PremiseNumber') as IXMLPremiseNumber_xalList;
  FPremiseNumberSuffix := CreateCollection(TXMLPremiseNumberSuffix_xalList, IXMLPremiseNumberSuffix_xal, 'PremiseNumberSuffix') as IXMLPremiseNumberSuffix_xalList;
  inherited;
end;

function TXMLPremiseNumberRangeFrom_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLPremiseNumberRangeFrom_xal.Get_PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
begin
  Result := FPremiseNumberPrefix;
end;

function TXMLPremiseNumberRangeFrom_xal.Get_PremiseNumber: IXMLPremiseNumber_xalList;
begin
  Result := FPremiseNumber;
end;

function TXMLPremiseNumberRangeFrom_xal.Get_PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
begin
  Result := FPremiseNumberSuffix;
end;

{ TXMLPremiseNumberPrefix_xal }

function TXMLPremiseNumberPrefix_xal.Get_NumberPrefixSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberPrefixSeparator'].Text;
end;

procedure TXMLPremiseNumberPrefix_xal.Set_NumberPrefixSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberPrefixSeparator', Value);
end;

function TXMLPremiseNumberPrefix_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPremiseNumberPrefix_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPremiseNumberPrefix_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPremiseNumberPrefix_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPremiseNumberPrefix_xalList }

function TXMLPremiseNumberPrefix_xalList.Add: IXMLPremiseNumberPrefix_xal;
begin
  Result := AddItem(-1) as IXMLPremiseNumberPrefix_xal;
end;

function TXMLPremiseNumberPrefix_xalList.Insert(const Index: Integer): IXMLPremiseNumberPrefix_xal;
begin
  Result := AddItem(Index) as IXMLPremiseNumberPrefix_xal;
end;

function TXMLPremiseNumberPrefix_xalList.Get_Item(Index: Integer): IXMLPremiseNumberPrefix_xal;
begin
  Result := List[Index] as IXMLPremiseNumberPrefix_xal;
end;

{ TXMLPremiseNumberSuffix_xal }

function TXMLPremiseNumberSuffix_xal.Get_NumberSuffixSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberSuffixSeparator'].Text;
end;

procedure TXMLPremiseNumberSuffix_xal.Set_NumberSuffixSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberSuffixSeparator', Value);
end;

function TXMLPremiseNumberSuffix_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLPremiseNumberSuffix_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLPremiseNumberSuffix_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLPremiseNumberSuffix_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLPremiseNumberSuffix_xalList }

function TXMLPremiseNumberSuffix_xalList.Add: IXMLPremiseNumberSuffix_xal;
begin
  Result := AddItem(-1) as IXMLPremiseNumberSuffix_xal;
end;

function TXMLPremiseNumberSuffix_xalList.Insert(const Index: Integer): IXMLPremiseNumberSuffix_xal;
begin
  Result := AddItem(Index) as IXMLPremiseNumberSuffix_xal;
end;

function TXMLPremiseNumberSuffix_xalList.Get_Item(Index: Integer): IXMLPremiseNumberSuffix_xal;
begin
  Result := List[Index] as IXMLPremiseNumberSuffix_xal;
end;

{ TXMLPremiseNumberRangeTo_xal }

procedure TXMLPremiseNumberRangeTo_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('PremiseNumberPrefix', TXMLPremiseNumberPrefix_xal);
  RegisterChildNode('PremiseNumber', TXMLPremiseNumber_xal);
  RegisterChildNode('PremiseNumberSuffix', TXMLPremiseNumberSuffix_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FPremiseNumberPrefix := CreateCollection(TXMLPremiseNumberPrefix_xalList, IXMLPremiseNumberPrefix_xal, 'PremiseNumberPrefix') as IXMLPremiseNumberPrefix_xalList;
  FPremiseNumber := CreateCollection(TXMLPremiseNumber_xalList, IXMLPremiseNumber_xal, 'PremiseNumber') as IXMLPremiseNumber_xalList;
  FPremiseNumberSuffix := CreateCollection(TXMLPremiseNumberSuffix_xalList, IXMLPremiseNumberSuffix_xal, 'PremiseNumberSuffix') as IXMLPremiseNumberSuffix_xalList;
  inherited;
end;

function TXMLPremiseNumberRangeTo_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLPremiseNumberRangeTo_xal.Get_PremiseNumberPrefix: IXMLPremiseNumberPrefix_xalList;
begin
  Result := FPremiseNumberPrefix;
end;

function TXMLPremiseNumberRangeTo_xal.Get_PremiseNumber: IXMLPremiseNumber_xalList;
begin
  Result := FPremiseNumber;
end;

function TXMLPremiseNumberRangeTo_xal.Get_PremiseNumberSuffix: IXMLPremiseNumberSuffix_xalList;
begin
  Result := FPremiseNumberSuffix;
end;

{ TXMLSubPremiseType_xal }

procedure TXMLSubPremiseType_xal.AfterConstruction;
begin
  RegisterChildNode('AddressLine', TXMLAddressLine_xal);
  RegisterChildNode('SubPremiseName', TXMLSubPremiseName_xal);
  RegisterChildNode('SubPremiseLocation', TXMLSubPremiseLocation_xal);
  RegisterChildNode('SubPremiseNumber', TXMLSubPremiseNumber_xal);
  RegisterChildNode('SubPremiseNumberPrefix', TXMLSubPremiseNumberPrefix_xal);
  RegisterChildNode('SubPremiseNumberSuffix', TXMLSubPremiseNumberSuffix_xal);
  RegisterChildNode('BuildingName', TXMLBuildingNameType_xal);
  RegisterChildNode('Firm', TXMLFirmType_xal);
  RegisterChildNode('MailStop', TXMLMailStopType_xal);
  RegisterChildNode('PostalCode', TXMLPostalCode_xal);
  RegisterChildNode('SubPremise', TXMLSubPremiseType_xal);
  FAddressLine := CreateCollection(TXMLAddressLine_xalList, IXMLAddressLine_xal, 'AddressLine') as IXMLAddressLine_xalList;
  FSubPremiseName := CreateCollection(TXMLSubPremiseName_xalList, IXMLSubPremiseName_xal, 'SubPremiseName') as IXMLSubPremiseName_xalList;
  FSubPremiseNumber := CreateCollection(TXMLSubPremiseNumber_xalList, IXMLSubPremiseNumber_xal, 'SubPremiseNumber') as IXMLSubPremiseNumber_xalList;
  FSubPremiseNumberPrefix := CreateCollection(TXMLSubPremiseNumberPrefix_xalList, IXMLSubPremiseNumberPrefix_xal, 'SubPremiseNumberPrefix') as IXMLSubPremiseNumberPrefix_xalList;
  FSubPremiseNumberSuffix := CreateCollection(TXMLSubPremiseNumberSuffix_xalList, IXMLSubPremiseNumberSuffix_xal, 'SubPremiseNumberSuffix') as IXMLSubPremiseNumberSuffix_xalList;
  FBuildingName := CreateCollection(TXMLBuildingNameType_xalList, IXMLBuildingNameType_xal, 'BuildingName') as IXMLBuildingNameType_xalList;
  inherited;
end;

function TXMLSubPremiseType_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLSubPremiseType_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLSubPremiseType_xal.Get_AddressLine: IXMLAddressLine_xalList;
begin
  Result := FAddressLine;
end;

function TXMLSubPremiseType_xal.Get_SubPremiseName: IXMLSubPremiseName_xalList;
begin
  Result := FSubPremiseName;
end;

function TXMLSubPremiseType_xal.Get_SubPremiseLocation: IXMLSubPremiseLocation_xal;
begin
  Result := ChildNodes['SubPremiseLocation'] as IXMLSubPremiseLocation_xal;
end;

function TXMLSubPremiseType_xal.Get_SubPremiseNumber: IXMLSubPremiseNumber_xalList;
begin
  Result := FSubPremiseNumber;
end;

function TXMLSubPremiseType_xal.Get_SubPremiseNumberPrefix: IXMLSubPremiseNumberPrefix_xalList;
begin
  Result := FSubPremiseNumberPrefix;
end;

function TXMLSubPremiseType_xal.Get_SubPremiseNumberSuffix: IXMLSubPremiseNumberSuffix_xalList;
begin
  Result := FSubPremiseNumberSuffix;
end;

function TXMLSubPremiseType_xal.Get_BuildingName: IXMLBuildingNameType_xalList;
begin
  Result := FBuildingName;
end;

function TXMLSubPremiseType_xal.Get_Firm: IXMLFirmType_xal;
begin
  Result := ChildNodes['Firm'] as IXMLFirmType_xal;
end;

function TXMLSubPremiseType_xal.Get_MailStop: IXMLMailStopType_xal;
begin
  Result := ChildNodes['MailStop'] as IXMLMailStopType_xal;
end;

function TXMLSubPremiseType_xal.Get_PostalCode: IXMLPostalCode_xal;
begin
  Result := ChildNodes['PostalCode'] as IXMLPostalCode_xal;
end;

function TXMLSubPremiseType_xal.Get_SubPremise: IXMLSubPremiseType_xal;
begin
  Result := ChildNodes['SubPremise'] as IXMLSubPremiseType_xal;
end;

{ TXMLSubPremiseType_xalList }

function TXMLSubPremiseType_xalList.Add: IXMLSubPremiseType_xal;
begin
  Result := AddItem(-1) as IXMLSubPremiseType_xal;
end;

function TXMLSubPremiseType_xalList.Insert(const Index: Integer): IXMLSubPremiseType_xal;
begin
  Result := AddItem(Index) as IXMLSubPremiseType_xal;
end;

function TXMLSubPremiseType_xalList.Get_Item(Index: Integer): IXMLSubPremiseType_xal;
begin
  Result := List[Index] as IXMLSubPremiseType_xal;
end;

{ TXMLSubPremiseName_xal }

function TXMLSubPremiseName_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLSubPremiseName_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLSubPremiseName_xal.Get_TypeOccurrence: UnicodeString;
begin
  Result := AttributeNodes['TypeOccurrence'].Text;
end;

procedure TXMLSubPremiseName_xal.Set_TypeOccurrence(Value: UnicodeString);
begin
  SetAttribute('TypeOccurrence', Value);
end;

function TXMLSubPremiseName_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLSubPremiseName_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLSubPremiseName_xalList }

function TXMLSubPremiseName_xalList.Add: IXMLSubPremiseName_xal;
begin
  Result := AddItem(-1) as IXMLSubPremiseName_xal;
end;

function TXMLSubPremiseName_xalList.Insert(const Index: Integer): IXMLSubPremiseName_xal;
begin
  Result := AddItem(Index) as IXMLSubPremiseName_xal;
end;

function TXMLSubPremiseName_xalList.Get_Item(Index: Integer): IXMLSubPremiseName_xal;
begin
  Result := List[Index] as IXMLSubPremiseName_xal;
end;

{ TXMLSubPremiseLocation_xal }

function TXMLSubPremiseLocation_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLSubPremiseLocation_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLSubPremiseNumber_xal }

function TXMLSubPremiseNumber_xal.Get_Indicator: UnicodeString;
begin
  Result := AttributeNodes['Indicator'].Text;
end;

procedure TXMLSubPremiseNumber_xal.Set_Indicator(Value: UnicodeString);
begin
  SetAttribute('Indicator', Value);
end;

function TXMLSubPremiseNumber_xal.Get_IndicatorOccurrence: UnicodeString;
begin
  Result := AttributeNodes['IndicatorOccurrence'].Text;
end;

procedure TXMLSubPremiseNumber_xal.Set_IndicatorOccurrence(Value: UnicodeString);
begin
  SetAttribute('IndicatorOccurrence', Value);
end;

function TXMLSubPremiseNumber_xal.Get_NumberTypeOccurrence: UnicodeString;
begin
  Result := AttributeNodes['NumberTypeOccurrence'].Text;
end;

procedure TXMLSubPremiseNumber_xal.Set_NumberTypeOccurrence(Value: UnicodeString);
begin
  SetAttribute('NumberTypeOccurrence', Value);
end;

function TXMLSubPremiseNumber_xal.Get_PremiseNumberSeparator: UnicodeString;
begin
  Result := AttributeNodes['PremiseNumberSeparator'].Text;
end;

procedure TXMLSubPremiseNumber_xal.Set_PremiseNumberSeparator(Value: UnicodeString);
begin
  SetAttribute('PremiseNumberSeparator', Value);
end;

function TXMLSubPremiseNumber_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLSubPremiseNumber_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLSubPremiseNumber_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLSubPremiseNumber_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLSubPremiseNumber_xalList }

function TXMLSubPremiseNumber_xalList.Add: IXMLSubPremiseNumber_xal;
begin
  Result := AddItem(-1) as IXMLSubPremiseNumber_xal;
end;

function TXMLSubPremiseNumber_xalList.Insert(const Index: Integer): IXMLSubPremiseNumber_xal;
begin
  Result := AddItem(Index) as IXMLSubPremiseNumber_xal;
end;

function TXMLSubPremiseNumber_xalList.Get_Item(Index: Integer): IXMLSubPremiseNumber_xal;
begin
  Result := List[Index] as IXMLSubPremiseNumber_xal;
end;

{ TXMLSubPremiseNumberPrefix_xal }

function TXMLSubPremiseNumberPrefix_xal.Get_NumberPrefixSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberPrefixSeparator'].Text;
end;

procedure TXMLSubPremiseNumberPrefix_xal.Set_NumberPrefixSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberPrefixSeparator', Value);
end;

function TXMLSubPremiseNumberPrefix_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLSubPremiseNumberPrefix_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLSubPremiseNumberPrefix_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLSubPremiseNumberPrefix_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLSubPremiseNumberPrefix_xalList }

function TXMLSubPremiseNumberPrefix_xalList.Add: IXMLSubPremiseNumberPrefix_xal;
begin
  Result := AddItem(-1) as IXMLSubPremiseNumberPrefix_xal;
end;

function TXMLSubPremiseNumberPrefix_xalList.Insert(const Index: Integer): IXMLSubPremiseNumberPrefix_xal;
begin
  Result := AddItem(Index) as IXMLSubPremiseNumberPrefix_xal;
end;

function TXMLSubPremiseNumberPrefix_xalList.Get_Item(Index: Integer): IXMLSubPremiseNumberPrefix_xal;
begin
  Result := List[Index] as IXMLSubPremiseNumberPrefix_xal;
end;

{ TXMLSubPremiseNumberSuffix_xal }

function TXMLSubPremiseNumberSuffix_xal.Get_NumberSuffixSeparator: UnicodeString;
begin
  Result := AttributeNodes['NumberSuffixSeparator'].Text;
end;

procedure TXMLSubPremiseNumberSuffix_xal.Set_NumberSuffixSeparator(Value: UnicodeString);
begin
  SetAttribute('NumberSuffixSeparator', Value);
end;

function TXMLSubPremiseNumberSuffix_xal.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['Type'].Text;
end;

procedure TXMLSubPremiseNumberSuffix_xal.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('Type', Value);
end;

function TXMLSubPremiseNumberSuffix_xal.Get_Code: UnicodeString;
begin
  Result := AttributeNodes['Code'].Text;
end;

procedure TXMLSubPremiseNumberSuffix_xal.Set_Code(Value: UnicodeString);
begin
  SetAttribute('Code', Value);
end;

{ TXMLSubPremiseNumberSuffix_xalList }

function TXMLSubPremiseNumberSuffix_xalList.Add: IXMLSubPremiseNumberSuffix_xal;
begin
  Result := AddItem(-1) as IXMLSubPremiseNumberSuffix_xal;
end;

function TXMLSubPremiseNumberSuffix_xalList.Insert(const Index: Integer): IXMLSubPremiseNumberSuffix_xal;
begin
  Result := AddItem(Index) as IXMLSubPremiseNumberSuffix_xal;
end;

function TXMLSubPremiseNumberSuffix_xalList.Get_Item(Index: Integer): IXMLSubPremiseNumberSuffix_xal;
begin
  Result := List[Index] as IXMLSubPremiseNumberSuffix_xal;
end;

{ TXMLAbstractViewType }

procedure TXMLAbstractViewType.AfterConstruction;
begin
  RegisterChildNode('AbstractTimePrimitiveGroup', TXMLAbstractTimePrimitiveType);
  FAbstractViewSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractViewSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractViewObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractViewObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractViewType.Get_AbstractTimePrimitiveGroup: IXMLAbstractTimePrimitiveType;
begin
  Result := ChildNodes['AbstractTimePrimitiveGroup'] as IXMLAbstractTimePrimitiveType;
end;

function TXMLAbstractViewType.Get_AbstractViewSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractViewSimpleExtensionGroup;
end;

function TXMLAbstractViewType.Get_AbstractViewObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractViewObjectExtensionGroup;
end;

{ TXMLAbstractTimePrimitiveType }

procedure TXMLAbstractTimePrimitiveType.AfterConstruction;
begin
  FAbstractTimePrimitiveSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractTimePrimitiveSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractTimePrimitiveObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractTimePrimitiveObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractTimePrimitiveType.Get_AbstractTimePrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractTimePrimitiveSimpleExtensionGroup;
end;

function TXMLAbstractTimePrimitiveType.Get_AbstractTimePrimitiveObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractTimePrimitiveObjectExtensionGroup;
end;

{ TXMLAbstractStyleSelectorType }

procedure TXMLAbstractStyleSelectorType.AfterConstruction;
begin
  FAbstractStyleSelectorSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractStyleSelectorSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractStyleSelectorObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractStyleSelectorObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractStyleSelectorType.Get_AbstractStyleSelectorSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractStyleSelectorSimpleExtensionGroup;
end;

function TXMLAbstractStyleSelectorType.Get_AbstractStyleSelectorObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractStyleSelectorObjectExtensionGroup;
end;

{ TXMLAbstractStyleSelectorTypeList }

function TXMLAbstractStyleSelectorTypeList.Add: IXMLAbstractStyleSelectorType;
begin
  Result := AddItem(-1) as IXMLAbstractStyleSelectorType;
end;

function TXMLAbstractStyleSelectorTypeList.Insert(const Index: Integer): IXMLAbstractStyleSelectorType;
begin
  Result := AddItem(Index) as IXMLAbstractStyleSelectorType;
end;

function TXMLAbstractStyleSelectorTypeList.Get_Item(Index: Integer): IXMLAbstractStyleSelectorType;
begin
  Result := List[Index] as IXMLAbstractStyleSelectorType;
end;

{ TXMLRegionType }

procedure TXMLRegionType.AfterConstruction;
begin
  RegisterChildNode('AbstractExtentGroup', TXMLAbstractExtentType);
  RegisterChildNode('Lod', TXMLLodType);
  FRegionSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'RegionSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FRegionObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'RegionObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLRegionType.Get_AbstractExtentGroup: IXMLAbstractExtentType;
begin
  Result := ChildNodes['AbstractExtentGroup'] as IXMLAbstractExtentType;
end;

function TXMLRegionType.Get_Lod: IXMLLodType;
begin
  Result := ChildNodes['Lod'] as IXMLLodType;
end;

function TXMLRegionType.Get_RegionSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FRegionSimpleExtensionGroup;
end;

function TXMLRegionType.Get_RegionObjectExtensionGroup: IXMLString_List;
begin
  Result := FRegionObjectExtensionGroup;
end;

{ TXMLAbstractExtentType }

procedure TXMLAbstractExtentType.AfterConstruction;
begin
  FAbstractExtentSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractExtentSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractExtentObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractExtentObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractExtentType.Get_AbstractExtentSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractExtentSimpleExtensionGroup;
end;

function TXMLAbstractExtentType.Get_AbstractExtentObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractExtentObjectExtensionGroup;
end;

{ TXMLLodType }

procedure TXMLLodType.AfterConstruction;
begin
  FLodSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LodSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLodObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LodObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLodType.Get_MinLodPixels: Double;
begin
  Result := ChildNodes['minLodPixels'].NodeValue;
end;

procedure TXMLLodType.Set_MinLodPixels(Value: Double);
begin
  ChildNodes['minLodPixels'].NodeValue := Value;
end;

function TXMLLodType.Get_MaxLodPixels: Double;
begin
  Result := ChildNodes['maxLodPixels'].NodeValue;
end;

procedure TXMLLodType.Set_MaxLodPixels(Value: Double);
begin
  ChildNodes['maxLodPixels'].NodeValue := Value;
end;

function TXMLLodType.Get_MinFadeExtent: Double;
begin
  Result := ChildNodes['minFadeExtent'].NodeValue;
end;

procedure TXMLLodType.Set_MinFadeExtent(Value: Double);
begin
  ChildNodes['minFadeExtent'].NodeValue := Value;
end;

function TXMLLodType.Get_MaxFadeExtent: Double;
begin
  Result := ChildNodes['maxFadeExtent'].NodeValue;
end;

procedure TXMLLodType.Set_MaxFadeExtent(Value: Double);
begin
  ChildNodes['maxFadeExtent'].NodeValue := Value;
end;

function TXMLLodType.Get_LodSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLodSimpleExtensionGroup;
end;

function TXMLLodType.Get_LodObjectExtensionGroup: IXMLString_List;
begin
  Result := FLodObjectExtensionGroup;
end;

{ TXMLLookAtType }

procedure TXMLLookAtType.AfterConstruction;
begin
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FLookAtSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LookAtSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLookAtObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LookAtObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLookAtType.Get_Longitude: Double;
begin
  Result := ChildNodes['longitude'].NodeValue;
end;

procedure TXMLLookAtType.Set_Longitude(Value: Double);
begin
  ChildNodes['longitude'].NodeValue := Value;
end;

function TXMLLookAtType.Get_Latitude: Double;
begin
  Result := ChildNodes['latitude'].NodeValue;
end;

procedure TXMLLookAtType.Set_Latitude(Value: Double);
begin
  ChildNodes['latitude'].NodeValue := Value;
end;

function TXMLLookAtType.Get_Altitude: Double;
begin
  Result := ChildNodes['altitude'].NodeValue;
end;

procedure TXMLLookAtType.Set_Altitude(Value: Double);
begin
  ChildNodes['altitude'].NodeValue := Value;
end;

function TXMLLookAtType.Get_Heading: Double;
begin
  Result := ChildNodes['heading'].NodeValue;
end;

procedure TXMLLookAtType.Set_Heading(Value: Double);
begin
  ChildNodes['heading'].NodeValue := Value;
end;

function TXMLLookAtType.Get_Tilt: Double;
begin
  Result := ChildNodes['tilt'].NodeValue;
end;

procedure TXMLLookAtType.Set_Tilt(Value: Double);
begin
  ChildNodes['tilt'].NodeValue := Value;
end;

function TXMLLookAtType.Get_Range: Double;
begin
  Result := ChildNodes['range'].NodeValue;
end;

procedure TXMLLookAtType.Set_Range(Value: Double);
begin
  ChildNodes['range'].NodeValue := Value;
end;

function TXMLLookAtType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLLookAtType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLLookAtType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLLookAtType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLLookAtType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLLookAtType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLLookAtType.Get_HorizFov: Double;
begin
  Result := ChildNodes['horizFov'].NodeValue;
end;

procedure TXMLLookAtType.Set_HorizFov(Value: Double);
begin
  ChildNodes['horizFov'].NodeValue := Value;
end;

function TXMLLookAtType.Get_LookAtSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLookAtSimpleExtensionGroup;
end;

function TXMLLookAtType.Get_LookAtObjectExtensionGroup: IXMLString_List;
begin
  Result := FLookAtObjectExtensionGroup;
end;

{ TXMLCameraType }

procedure TXMLCameraType.AfterConstruction;
begin
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FCameraSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'CameraSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FCameraObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'CameraObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLCameraType.Get_Longitude: Double;
begin
  Result := ChildNodes['longitude'].NodeValue;
end;

procedure TXMLCameraType.Set_Longitude(Value: Double);
begin
  ChildNodes['longitude'].NodeValue := Value;
end;

function TXMLCameraType.Get_Latitude: Double;
begin
  Result := ChildNodes['latitude'].NodeValue;
end;

procedure TXMLCameraType.Set_Latitude(Value: Double);
begin
  ChildNodes['latitude'].NodeValue := Value;
end;

function TXMLCameraType.Get_Altitude: Double;
begin
  Result := ChildNodes['altitude'].NodeValue;
end;

procedure TXMLCameraType.Set_Altitude(Value: Double);
begin
  ChildNodes['altitude'].NodeValue := Value;
end;

function TXMLCameraType.Get_Heading: Double;
begin
  Result := ChildNodes['heading'].NodeValue;
end;

procedure TXMLCameraType.Set_Heading(Value: Double);
begin
  ChildNodes['heading'].NodeValue := Value;
end;

function TXMLCameraType.Get_Tilt: Double;
begin
  Result := ChildNodes['tilt'].NodeValue;
end;

procedure TXMLCameraType.Set_Tilt(Value: Double);
begin
  ChildNodes['tilt'].NodeValue := Value;
end;

function TXMLCameraType.Get_Roll: Double;
begin
  Result := ChildNodes['roll'].NodeValue;
end;

procedure TXMLCameraType.Set_Roll(Value: Double);
begin
  ChildNodes['roll'].NodeValue := Value;
end;

function TXMLCameraType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLCameraType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLCameraType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLCameraType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLCameraType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLCameraType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLCameraType.Get_HorizFov: Double;
begin
  Result := ChildNodes['horizFov'].NodeValue;
end;

procedure TXMLCameraType.Set_HorizFov(Value: Double);
begin
  ChildNodes['horizFov'].NodeValue := Value;
end;

function TXMLCameraType.Get_CameraSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FCameraSimpleExtensionGroup;
end;

function TXMLCameraType.Get_CameraObjectExtensionGroup: IXMLString_List;
begin
  Result := FCameraObjectExtensionGroup;
end;

{ TXMLMetadataType }

{ TXMLExtendedDataType }

procedure TXMLExtendedDataType.AfterConstruction;
begin
  RegisterChildNode('Data', TXMLDataType);
  RegisterChildNode('SchemaData', TXMLSchemaDataType);
  FData := CreateCollection(TXMLDataTypeList, IXMLDataType, 'Data') as IXMLDataTypeList;
  FSchemaData := CreateCollection(TXMLSchemaDataTypeList, IXMLSchemaDataType, 'SchemaData') as IXMLSchemaDataTypeList;
  inherited;
end;

function TXMLExtendedDataType.Get_Data: IXMLDataTypeList;
begin
  Result := FData;
end;

function TXMLExtendedDataType.Get_SchemaData: IXMLSchemaDataTypeList;
begin
  Result := FSchemaData;
end;

{ TXMLDataType }

procedure TXMLDataType.AfterConstruction;
begin
  FDataExtension := CreateCollection(TXMLString_List, IXMLNode, 'DataExtension') as IXMLString_List;
  inherited;
end;

function TXMLDataType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLDataType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLDataType.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLDataType.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

function TXMLDataType.Get_DisplayName: UnicodeString;
begin
  Result := ChildNodes['displayName'].Text;
end;

procedure TXMLDataType.Set_DisplayName(Value: UnicodeString);
begin
  ChildNodes['displayName'].NodeValue := Value;
end;

function TXMLDataType.Get_Value: Variant;
begin
  Result := ChildNodes['value'].NodeValue;
end;

procedure TXMLDataType.Set_Value(Value: Variant);
begin
  ChildNodes['value'].NodeValue := Value;
end;

function TXMLDataType.Get_DataExtension: IXMLString_List;
begin
  Result := FDataExtension;
end;

{ TXMLDataTypeList }

function TXMLDataTypeList.Add: IXMLDataType;
begin
  Result := AddItem(-1) as IXMLDataType;
end;

function TXMLDataTypeList.Insert(const Index: Integer): IXMLDataType;
begin
  Result := AddItem(Index) as IXMLDataType;
end;

function TXMLDataTypeList.Get_Item(Index: Integer): IXMLDataType;
begin
  Result := List[Index] as IXMLDataType;
end;

{ TXMLSchemaDataType }

procedure TXMLSchemaDataType.AfterConstruction;
begin
  RegisterChildNode('SimpleData', TXMLSimpleDataType);
  RegisterChildNode('SimpleArrayData', TXMLSimpleArrayDataType);
  FSimpleData := CreateCollection(TXMLSimpleDataTypeList, IXMLSimpleDataType, 'SimpleData') as IXMLSimpleDataTypeList;
  FSimpleArrayData := CreateCollection(TXMLSimpleArrayDataTypeList, IXMLSimpleArrayDataType, 'SimpleArrayData') as IXMLSimpleArrayDataTypeList;
  FSchemaDataExtension := CreateCollection(TXMLString_List, IXMLNode, 'SchemaDataExtension') as IXMLString_List;
  inherited;
end;

function TXMLSchemaDataType.Get_SchemaUrl: UnicodeString;
begin
  Result := AttributeNodes['schemaUrl'].Text;
end;

procedure TXMLSchemaDataType.Set_SchemaUrl(Value: UnicodeString);
begin
  SetAttribute('schemaUrl', Value);
end;

function TXMLSchemaDataType.Get_SimpleData: IXMLSimpleDataTypeList;
begin
  Result := FSimpleData;
end;

function TXMLSchemaDataType.Get_SimpleArrayData: IXMLSimpleArrayDataTypeList;
begin
  Result := FSimpleArrayData;
end;

function TXMLSchemaDataType.Get_SchemaDataExtension: IXMLString_List;
begin
  Result := FSchemaDataExtension;
end;

{ TXMLSchemaDataTypeList }

function TXMLSchemaDataTypeList.Add: IXMLSchemaDataType;
begin
  Result := AddItem(-1) as IXMLSchemaDataType;
end;

function TXMLSchemaDataTypeList.Insert(const Index: Integer): IXMLSchemaDataType;
begin
  Result := AddItem(Index) as IXMLSchemaDataType;
end;

function TXMLSchemaDataTypeList.Get_Item(Index: Integer): IXMLSchemaDataType;
begin
  Result := List[Index] as IXMLSchemaDataType;
end;

{ TXMLSimpleDataType }

function TXMLSimpleDataType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLSimpleDataType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

{ TXMLSimpleDataTypeList }

function TXMLSimpleDataTypeList.Add: IXMLSimpleDataType;
begin
  Result := AddItem(-1) as IXMLSimpleDataType;
end;

function TXMLSimpleDataTypeList.Insert(const Index: Integer): IXMLSimpleDataType;
begin
  Result := AddItem(Index) as IXMLSimpleDataType;
end;

function TXMLSimpleDataTypeList.Get_Item(Index: Integer): IXMLSimpleDataType;
begin
  Result := List[Index] as IXMLSimpleDataType;
end;

{ TXMLSimpleArrayDataType }

procedure TXMLSimpleArrayDataType.AfterConstruction;
begin
  FValue := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'value') as IXMLAnySimpleTypeList;
  FSimpleArrayDataExtension := CreateCollection(TXMLString_List, IXMLNode, 'SimpleArrayDataExtension') as IXMLString_List;
  inherited;
end;

function TXMLSimpleArrayDataType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLSimpleArrayDataType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLSimpleArrayDataType.Get_Value: IXMLAnySimpleTypeList;
begin
  Result := FValue;
end;

function TXMLSimpleArrayDataType.Get_SimpleArrayDataExtension: IXMLString_List;
begin
  Result := FSimpleArrayDataExtension;
end;

{ TXMLSimpleArrayDataTypeList }

function TXMLSimpleArrayDataTypeList.Add: IXMLSimpleArrayDataType;
begin
  Result := AddItem(-1) as IXMLSimpleArrayDataType;
end;

function TXMLSimpleArrayDataTypeList.Insert(const Index: Integer): IXMLSimpleArrayDataType;
begin
  Result := AddItem(Index) as IXMLSimpleArrayDataType;
end;

function TXMLSimpleArrayDataTypeList.Get_Item(Index: Integer): IXMLSimpleArrayDataType;
begin
  Result := List[Index] as IXMLSimpleArrayDataType;
end;

{ TXMLAbstractContainerType }

procedure TXMLAbstractContainerType.AfterConstruction;
begin
  FAbstractContainerSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractContainerSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractContainerObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractContainerObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractContainerType.Get_AbstractContainerSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractContainerSimpleExtensionGroup;
end;

function TXMLAbstractContainerType.Get_AbstractContainerObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractContainerObjectExtensionGroup;
end;

{ TXMLAbstractContainerTypeList }

function TXMLAbstractContainerTypeList.Add: IXMLAbstractContainerType;
begin
  Result := AddItem(-1) as IXMLAbstractContainerType;
end;

function TXMLAbstractContainerTypeList.Insert(const Index: Integer): IXMLAbstractContainerType;
begin
  Result := AddItem(Index) as IXMLAbstractContainerType;
end;

function TXMLAbstractContainerTypeList.Get_Item(Index: Integer): IXMLAbstractContainerType;
begin
  Result := List[Index] as IXMLAbstractContainerType;
end;

{ TXMLAbstractGeometryType }

procedure TXMLAbstractGeometryType.AfterConstruction;
begin
  FAbstractGeometrySimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractGeometrySimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractGeometryObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractGeometryObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractGeometryType.Get_AbstractGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractGeometrySimpleExtensionGroup;
end;

function TXMLAbstractGeometryType.Get_AbstractGeometryObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractGeometryObjectExtensionGroup;
end;

{ TXMLAbstractGeometryTypeList }

function TXMLAbstractGeometryTypeList.Add: IXMLAbstractGeometryType;
begin
  Result := AddItem(-1) as IXMLAbstractGeometryType;
end;

function TXMLAbstractGeometryTypeList.Insert(const Index: Integer): IXMLAbstractGeometryType;
begin
  Result := AddItem(Index) as IXMLAbstractGeometryType;
end;

function TXMLAbstractGeometryTypeList.Get_Item(Index: Integer): IXMLAbstractGeometryType;
begin
  Result := List[Index] as IXMLAbstractGeometryType;
end;

{ TXMLAbstractOverlayType }

procedure TXMLAbstractOverlayType.AfterConstruction;
begin
  RegisterChildNode('Icon', TXMLLinkType);
  FAbstractOverlaySimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractOverlaySimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractOverlayObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractOverlayObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractOverlayType.Get_Color: UnicodeString;
begin
  Result := ChildNodes['color'].Text;
end;

procedure TXMLAbstractOverlayType.Set_Color(Value: UnicodeString);
begin
  ChildNodes['color'].NodeValue := Value;
end;

function TXMLAbstractOverlayType.Get_DrawOrder: Integer;
begin
  Result := ChildNodes['drawOrder'].NodeValue;
end;

procedure TXMLAbstractOverlayType.Set_DrawOrder(Value: Integer);
begin
  ChildNodes['drawOrder'].NodeValue := Value;
end;

function TXMLAbstractOverlayType.Get_Icon: IXMLLinkType;
begin
  Result := ChildNodes['Icon'] as IXMLLinkType;
end;

function TXMLAbstractOverlayType.Get_AbstractOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractOverlaySimpleExtensionGroup;
end;

function TXMLAbstractOverlayType.Get_AbstractOverlayObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractOverlayObjectExtensionGroup;
end;

{ TXMLBasicLinkType }

procedure TXMLBasicLinkType.AfterConstruction;
begin
  FBasicLinkSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'BasicLinkSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FBasicLinkObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'BasicLinkObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLBasicLinkType.Get_Href: UnicodeString;
begin
  Result := ChildNodes['href'].Text;
end;

procedure TXMLBasicLinkType.Set_Href(Value: UnicodeString);
begin
  ChildNodes['href'].NodeValue := Value;
end;

function TXMLBasicLinkType.Get_BasicLinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FBasicLinkSimpleExtensionGroup;
end;

function TXMLBasicLinkType.Get_BasicLinkObjectExtensionGroup: IXMLString_List;
begin
  Result := FBasicLinkObjectExtensionGroup;
end;

{ TXMLLinkType }

procedure TXMLLinkType.AfterConstruction;
begin
  FLinkSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LinkSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLinkObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LinkObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLinkType.Get_AbstractRefreshMode: UnicodeString;
begin
  Result := ChildNodes['abstractRefreshMode'].Text;
end;

procedure TXMLLinkType.Set_AbstractRefreshMode(Value: UnicodeString);
begin
  ChildNodes['abstractRefreshMode'].NodeValue := Value;
end;

function TXMLLinkType.Get_RefreshInterval: Double;
begin
  Result := ChildNodes['refreshInterval'].NodeValue;
end;

procedure TXMLLinkType.Set_RefreshInterval(Value: Double);
begin
  ChildNodes['refreshInterval'].NodeValue := Value;
end;

function TXMLLinkType.Get_AbstractViewRefreshMode: UnicodeString;
begin
  Result := ChildNodes['abstractViewRefreshMode'].Text;
end;

procedure TXMLLinkType.Set_AbstractViewRefreshMode(Value: UnicodeString);
begin
  ChildNodes['abstractViewRefreshMode'].NodeValue := Value;
end;

function TXMLLinkType.Get_ViewRefreshTime: Double;
begin
  Result := ChildNodes['viewRefreshTime'].NodeValue;
end;

procedure TXMLLinkType.Set_ViewRefreshTime(Value: Double);
begin
  ChildNodes['viewRefreshTime'].NodeValue := Value;
end;

function TXMLLinkType.Get_ViewBoundScale: Double;
begin
  Result := ChildNodes['viewBoundScale'].NodeValue;
end;

procedure TXMLLinkType.Set_ViewBoundScale(Value: Double);
begin
  ChildNodes['viewBoundScale'].NodeValue := Value;
end;

function TXMLLinkType.Get_ViewFormat: UnicodeString;
begin
  Result := ChildNodes['viewFormat'].Text;
end;

procedure TXMLLinkType.Set_ViewFormat(Value: UnicodeString);
begin
  ChildNodes['viewFormat'].NodeValue := Value;
end;

function TXMLLinkType.Get_HttpQuery: UnicodeString;
begin
  Result := ChildNodes['httpQuery'].Text;
end;

procedure TXMLLinkType.Set_HttpQuery(Value: UnicodeString);
begin
  ChildNodes['httpQuery'].NodeValue := Value;
end;

function TXMLLinkType.Get_LinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLinkSimpleExtensionGroup;
end;

function TXMLLinkType.Get_LinkObjectExtensionGroup: IXMLString_List;
begin
  Result := FLinkObjectExtensionGroup;
end;

{ TXMLKmlType }

procedure TXMLKmlType.AfterConstruction;
begin
  RegisterChildNode('NetworkLinkControl', TXMLNetworkLinkControlType);
  RegisterChildNode('AbstractFeatureGroup', TXMLAbstractFeatureType);
  FKmlSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'KmlSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FKmlObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'KmlObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLKmlType.Get_Hint: UnicodeString;
begin
  Result := AttributeNodes['hint'].Text;
end;

procedure TXMLKmlType.Set_Hint(Value: UnicodeString);
begin
  SetAttribute('hint', Value);
end;

function TXMLKmlType.Get_Version: UnicodeString;
begin
  Result := AttributeNodes['version'].Text;
end;

procedure TXMLKmlType.Set_Version(Value: UnicodeString);
begin
  SetAttribute('version', Value);
end;

function TXMLKmlType.Get_NetworkLinkControl: IXMLNetworkLinkControlType;
begin
  Result := ChildNodes['NetworkLinkControl'] as IXMLNetworkLinkControlType;
end;

function TXMLKmlType.Get_AbstractFeatureGroup: IXMLAbstractFeatureType;
begin
  Result := ChildNodes['AbstractFeatureGroup'] as IXMLAbstractFeatureType;
end;

function TXMLKmlType.Get_KmlSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FKmlSimpleExtensionGroup;
end;

function TXMLKmlType.Get_KmlObjectExtensionGroup: IXMLString_List;
begin
  Result := FKmlObjectExtensionGroup;
end;

{ TXMLNetworkLinkControlType }

procedure TXMLNetworkLinkControlType.AfterConstruction;
begin
  RegisterChildNode('linkSnippet', TXMLSnippetType);
  RegisterChildNode('Update', TXMLUpdateType);
  RegisterChildNode('AbstractViewGroup', TXMLAbstractViewType);
  FNetworkLinkControlSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'NetworkLinkControlSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FNetworkLinkControlObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'NetworkLinkControlObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLNetworkLinkControlType.Get_MinRefreshPeriod: Double;
begin
  Result := ChildNodes['minRefreshPeriod'].NodeValue;
end;

procedure TXMLNetworkLinkControlType.Set_MinRefreshPeriod(Value: Double);
begin
  ChildNodes['minRefreshPeriod'].NodeValue := Value;
end;

function TXMLNetworkLinkControlType.Get_MaxSessionLength: Double;
begin
  Result := ChildNodes['maxSessionLength'].NodeValue;
end;

procedure TXMLNetworkLinkControlType.Set_MaxSessionLength(Value: Double);
begin
  ChildNodes['maxSessionLength'].NodeValue := Value;
end;

function TXMLNetworkLinkControlType.Get_Cookie: UnicodeString;
begin
  Result := ChildNodes['cookie'].Text;
end;

procedure TXMLNetworkLinkControlType.Set_Cookie(Value: UnicodeString);
begin
  ChildNodes['cookie'].NodeValue := Value;
end;

function TXMLNetworkLinkControlType.Get_Message: UnicodeString;
begin
  Result := ChildNodes['message'].Text;
end;

procedure TXMLNetworkLinkControlType.Set_Message(Value: UnicodeString);
begin
  ChildNodes['message'].NodeValue := Value;
end;

function TXMLNetworkLinkControlType.Get_LinkName: UnicodeString;
begin
  Result := ChildNodes['linkName'].Text;
end;

procedure TXMLNetworkLinkControlType.Set_LinkName(Value: UnicodeString);
begin
  ChildNodes['linkName'].NodeValue := Value;
end;

function TXMLNetworkLinkControlType.Get_LinkDescription: UnicodeString;
begin
  Result := ChildNodes['linkDescription'].Text;
end;

procedure TXMLNetworkLinkControlType.Set_LinkDescription(Value: UnicodeString);
begin
  ChildNodes['linkDescription'].NodeValue := Value;
end;

function TXMLNetworkLinkControlType.Get_LinkSnippet: IXMLSnippetType;
begin
  Result := ChildNodes['linkSnippet'] as IXMLSnippetType;
end;

function TXMLNetworkLinkControlType.Get_Expires: UnicodeString;
begin
  Result := ChildNodes['expires'].Text;
end;

procedure TXMLNetworkLinkControlType.Set_Expires(Value: UnicodeString);
begin
  ChildNodes['expires'].NodeValue := Value;
end;

function TXMLNetworkLinkControlType.Get_Update: IXMLUpdateType;
begin
  Result := ChildNodes['Update'] as IXMLUpdateType;
end;

function TXMLNetworkLinkControlType.Get_AbstractViewGroup: IXMLAbstractViewType;
begin
  Result := ChildNodes['AbstractViewGroup'] as IXMLAbstractViewType;
end;

function TXMLNetworkLinkControlType.Get_NetworkLinkControlSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FNetworkLinkControlSimpleExtensionGroup;
end;

function TXMLNetworkLinkControlType.Get_NetworkLinkControlObjectExtensionGroup: IXMLString_List;
begin
  Result := FNetworkLinkControlObjectExtensionGroup;
end;

{ TXMLUpdateType }

procedure TXMLUpdateType.AfterConstruction;
begin
  FAbstractUpdateOptionGroup := CreateCollection(TXMLAnyTypeList, IXMLNode, 'AbstractUpdateOptionGroup') as IXMLAnyTypeList;
  FUpdateExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'UpdateExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLUpdateType.Get_TargetHref: UnicodeString;
begin
  Result := ChildNodes['targetHref'].Text;
end;

procedure TXMLUpdateType.Set_TargetHref(Value: UnicodeString);
begin
  ChildNodes['targetHref'].NodeValue := Value;
end;

function TXMLUpdateType.Get_AbstractUpdateOptionGroup: IXMLAnyTypeList;
begin
  Result := FAbstractUpdateOptionGroup;
end;

function TXMLUpdateType.Get_UpdateExtensionGroup: IXMLString_List;
begin
  Result := FUpdateExtensionGroup;
end;

{ TXMLDocumentType }

procedure TXMLDocumentType.AfterConstruction;
begin
  RegisterChildNode('Schema', TXMLSchemaType);
  RegisterChildNode('AbstractFeatureGroup', TXMLAbstractFeatureType);
  FSchema := CreateCollection(TXMLSchemaTypeList, IXMLSchemaType, 'Schema') as IXMLSchemaTypeList;
  FAbstractFeatureGroup := CreateCollection(TXMLAbstractFeatureTypeList, IXMLAbstractFeatureType, 'AbstractFeatureGroup') as IXMLAbstractFeatureTypeList;
  FDocumentSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'DocumentSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FDocumentObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'DocumentObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLDocumentType.Get_Schema: IXMLSchemaTypeList;
begin
  Result := FSchema;
end;

function TXMLDocumentType.Get_AbstractFeatureGroup: IXMLAbstractFeatureTypeList;
begin
  Result := FAbstractFeatureGroup;
end;

function TXMLDocumentType.Get_DocumentSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FDocumentSimpleExtensionGroup;
end;

function TXMLDocumentType.Get_DocumentObjectExtensionGroup: IXMLString_List;
begin
  Result := FDocumentObjectExtensionGroup;
end;

{ TXMLSchemaType }

procedure TXMLSchemaType.AfterConstruction;
begin
  RegisterChildNode('SimpleField', TXMLSimpleFieldType);
  RegisterChildNode('SimpleArrayField', TXMLSimpleArrayFieldType);
  FSimpleField := CreateCollection(TXMLSimpleFieldTypeList, IXMLSimpleFieldType, 'SimpleField') as IXMLSimpleFieldTypeList;
  FSimpleArrayField := CreateCollection(TXMLSimpleArrayFieldTypeList, IXMLSimpleArrayFieldType, 'SimpleArrayField') as IXMLSimpleArrayFieldTypeList;
  FSchemaExtension := CreateCollection(TXMLString_List, IXMLNode, 'SchemaExtension') as IXMLString_List;
  inherited;
end;

function TXMLSchemaType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLSchemaType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLSchemaType.Get_Id: UnicodeString;
begin
  Result := AttributeNodes['id'].Text;
end;

procedure TXMLSchemaType.Set_Id(Value: UnicodeString);
begin
  SetAttribute('id', Value);
end;

function TXMLSchemaType.Get_SimpleField: IXMLSimpleFieldTypeList;
begin
  Result := FSimpleField;
end;

function TXMLSchemaType.Get_SimpleArrayField: IXMLSimpleArrayFieldTypeList;
begin
  Result := FSimpleArrayField;
end;

function TXMLSchemaType.Get_SchemaExtension: IXMLString_List;
begin
  Result := FSchemaExtension;
end;

{ TXMLSchemaTypeList }

function TXMLSchemaTypeList.Add: IXMLSchemaType;
begin
  Result := AddItem(-1) as IXMLSchemaType;
end;

function TXMLSchemaTypeList.Insert(const Index: Integer): IXMLSchemaType;
begin
  Result := AddItem(Index) as IXMLSchemaType;
end;

function TXMLSchemaTypeList.Get_Item(Index: Integer): IXMLSchemaType;
begin
  Result := List[Index] as IXMLSchemaType;
end;

{ TXMLSimpleFieldType }

procedure TXMLSimpleFieldType.AfterConstruction;
begin
  FSimpleFieldExtension := CreateCollection(TXMLString_List, IXMLNode, 'SimpleFieldExtension') as IXMLString_List;
  inherited;
end;

function TXMLSimpleFieldType.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['type'].Text;
end;

procedure TXMLSimpleFieldType.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('type', Value);
end;

function TXMLSimpleFieldType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLSimpleFieldType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLSimpleFieldType.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLSimpleFieldType.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

function TXMLSimpleFieldType.Get_DisplayName: UnicodeString;
begin
  Result := ChildNodes['displayName'].Text;
end;

procedure TXMLSimpleFieldType.Set_DisplayName(Value: UnicodeString);
begin
  ChildNodes['displayName'].NodeValue := Value;
end;

function TXMLSimpleFieldType.Get_SimpleFieldExtension: IXMLString_List;
begin
  Result := FSimpleFieldExtension;
end;

{ TXMLSimpleFieldTypeList }

function TXMLSimpleFieldTypeList.Add: IXMLSimpleFieldType;
begin
  Result := AddItem(-1) as IXMLSimpleFieldType;
end;

function TXMLSimpleFieldTypeList.Insert(const Index: Integer): IXMLSimpleFieldType;
begin
  Result := AddItem(Index) as IXMLSimpleFieldType;
end;

function TXMLSimpleFieldTypeList.Get_Item(Index: Integer): IXMLSimpleFieldType;
begin
  Result := List[Index] as IXMLSimpleFieldType;
end;

{ TXMLSimpleArrayFieldType }

procedure TXMLSimpleArrayFieldType.AfterConstruction;
begin
  FSimpleArrayFieldExtension := CreateCollection(TXMLString_List, IXMLNode, 'SimpleArrayFieldExtension') as IXMLString_List;
  inherited;
end;

function TXMLSimpleArrayFieldType.Get_Type_: UnicodeString;
begin
  Result := AttributeNodes['type'].Text;
end;

procedure TXMLSimpleArrayFieldType.Set_Type_(Value: UnicodeString);
begin
  SetAttribute('type', Value);
end;

function TXMLSimpleArrayFieldType.Get_Name: UnicodeString;
begin
  Result := AttributeNodes['name'].Text;
end;

procedure TXMLSimpleArrayFieldType.Set_Name(Value: UnicodeString);
begin
  SetAttribute('name', Value);
end;

function TXMLSimpleArrayFieldType.Get_Uom: UnicodeString;
begin
  Result := AttributeNodes['uom'].Text;
end;

procedure TXMLSimpleArrayFieldType.Set_Uom(Value: UnicodeString);
begin
  SetAttribute('uom', Value);
end;

function TXMLSimpleArrayFieldType.Get_DisplayName: UnicodeString;
begin
  Result := ChildNodes['displayName'].Text;
end;

procedure TXMLSimpleArrayFieldType.Set_DisplayName(Value: UnicodeString);
begin
  ChildNodes['displayName'].NodeValue := Value;
end;

function TXMLSimpleArrayFieldType.Get_SimpleArrayFieldExtension: IXMLString_List;
begin
  Result := FSimpleArrayFieldExtension;
end;

{ TXMLSimpleArrayFieldTypeList }

function TXMLSimpleArrayFieldTypeList.Add: IXMLSimpleArrayFieldType;
begin
  Result := AddItem(-1) as IXMLSimpleArrayFieldType;
end;

function TXMLSimpleArrayFieldTypeList.Insert(const Index: Integer): IXMLSimpleArrayFieldType;
begin
  Result := AddItem(Index) as IXMLSimpleArrayFieldType;
end;

function TXMLSimpleArrayFieldTypeList.Get_Item(Index: Integer): IXMLSimpleArrayFieldType;
begin
  Result := List[Index] as IXMLSimpleArrayFieldType;
end;

{ TXMLFolderType }

procedure TXMLFolderType.AfterConstruction;
begin
  RegisterChildNode('AbstractFeatureGroup', TXMLAbstractFeatureType);
  FAbstractFeatureGroup := CreateCollection(TXMLAbstractFeatureTypeList, IXMLAbstractFeatureType, 'AbstractFeatureGroup') as IXMLAbstractFeatureTypeList;
  FFolderSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'FolderSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FFolderObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'FolderObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLFolderType.Get_AbstractFeatureGroup: IXMLAbstractFeatureTypeList;
begin
  Result := FAbstractFeatureGroup;
end;

function TXMLFolderType.Get_FolderSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FFolderSimpleExtensionGroup;
end;

function TXMLFolderType.Get_FolderObjectExtensionGroup: IXMLString_List;
begin
  Result := FFolderObjectExtensionGroup;
end;

{ TXMLPlacemarkType }

procedure TXMLPlacemarkType.AfterConstruction;
begin
  RegisterChildNode('AbstractGeometryGroup', TXMLAbstractGeometryType);
  FPlacemarkSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'PlacemarkSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FPlacemarkObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'PlacemarkObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLPlacemarkType.Get_AbstractGeometryGroup: IXMLAbstractGeometryType;
begin
  Result := ChildNodes['AbstractGeometryGroup'] as IXMLAbstractGeometryType;
end;

function TXMLPlacemarkType.Get_PlacemarkSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FPlacemarkSimpleExtensionGroup;
end;

function TXMLPlacemarkType.Get_PlacemarkObjectExtensionGroup: IXMLString_List;
begin
  Result := FPlacemarkObjectExtensionGroup;
end;

{ TXMLNetworkLinkType }

procedure TXMLNetworkLinkType.AfterConstruction;
begin
  RegisterChildNode('AbstractLinkGroup', TXMLAbstractObjectType);
  FNetworkLinkSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'NetworkLinkSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FNetworkLinkObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'NetworkLinkObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLNetworkLinkType.Get_RefreshVisibility: Boolean;
begin
  Result := ChildNodes['refreshVisibility'].NodeValue;
end;

procedure TXMLNetworkLinkType.Set_RefreshVisibility(Value: Boolean);
begin
  ChildNodes['refreshVisibility'].NodeValue := Value;
end;

function TXMLNetworkLinkType.Get_FlyToView: Boolean;
begin
  Result := ChildNodes['flyToView'].NodeValue;
end;

procedure TXMLNetworkLinkType.Set_FlyToView(Value: Boolean);
begin
  ChildNodes['flyToView'].NodeValue := Value;
end;

function TXMLNetworkLinkType.Get_AbstractLinkGroup: IXMLAbstractObjectType;
begin
  Result := ChildNodes['AbstractLinkGroup'] as IXMLAbstractObjectType;
end;

function TXMLNetworkLinkType.Get_NetworkLinkSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FNetworkLinkSimpleExtensionGroup;
end;

function TXMLNetworkLinkType.Get_NetworkLinkObjectExtensionGroup: IXMLString_List;
begin
  Result := FNetworkLinkObjectExtensionGroup;
end;

{ TXMLAbstractLatLonBoxType }

procedure TXMLAbstractLatLonBoxType.AfterConstruction;
begin
  FAbstractLatLonBoxSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractLatLonBoxSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractLatLonBoxObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractLatLonBoxObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractLatLonBoxType.Get_North: Double;
begin
  Result := ChildNodes['north'].NodeValue;
end;

procedure TXMLAbstractLatLonBoxType.Set_North(Value: Double);
begin
  ChildNodes['north'].NodeValue := Value;
end;

function TXMLAbstractLatLonBoxType.Get_South: Double;
begin
  Result := ChildNodes['south'].NodeValue;
end;

procedure TXMLAbstractLatLonBoxType.Set_South(Value: Double);
begin
  ChildNodes['south'].NodeValue := Value;
end;

function TXMLAbstractLatLonBoxType.Get_East: Double;
begin
  Result := ChildNodes['east'].NodeValue;
end;

procedure TXMLAbstractLatLonBoxType.Set_East(Value: Double);
begin
  ChildNodes['east'].NodeValue := Value;
end;

function TXMLAbstractLatLonBoxType.Get_West: Double;
begin
  Result := ChildNodes['west'].NodeValue;
end;

procedure TXMLAbstractLatLonBoxType.Set_West(Value: Double);
begin
  ChildNodes['west'].NodeValue := Value;
end;

function TXMLAbstractLatLonBoxType.Get_AbstractLatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractLatLonBoxSimpleExtensionGroup;
end;

function TXMLAbstractLatLonBoxType.Get_AbstractLatLonBoxObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractLatLonBoxObjectExtensionGroup;
end;

{ TXMLLatLonAltBoxType }

procedure TXMLLatLonAltBoxType.AfterConstruction;
begin
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FLatLonAltBoxSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LatLonAltBoxSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLatLonAltBoxObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LatLonAltBoxObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLatLonAltBoxType.Get_MinAltitude: Double;
begin
  Result := ChildNodes['minAltitude'].NodeValue;
end;

procedure TXMLLatLonAltBoxType.Set_MinAltitude(Value: Double);
begin
  ChildNodes['minAltitude'].NodeValue := Value;
end;

function TXMLLatLonAltBoxType.Get_MaxAltitude: Double;
begin
  Result := ChildNodes['maxAltitude'].NodeValue;
end;

procedure TXMLLatLonAltBoxType.Set_MaxAltitude(Value: Double);
begin
  ChildNodes['maxAltitude'].NodeValue := Value;
end;

function TXMLLatLonAltBoxType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLLatLonAltBoxType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLLatLonAltBoxType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLLatLonAltBoxType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLLatLonAltBoxType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLLatLonAltBoxType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLLatLonAltBoxType.Get_LatLonAltBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLatLonAltBoxSimpleExtensionGroup;
end;

function TXMLLatLonAltBoxType.Get_LatLonAltBoxObjectExtensionGroup: IXMLString_List;
begin
  Result := FLatLonAltBoxObjectExtensionGroup;
end;

{ TXMLMultiGeometryType }

procedure TXMLMultiGeometryType.AfterConstruction;
begin
  RegisterChildNode('AbstractGeometryGroup', TXMLAbstractGeometryType);
  FAbstractGeometryGroup := CreateCollection(TXMLAbstractGeometryTypeList, IXMLAbstractGeometryType, 'AbstractGeometryGroup') as IXMLAbstractGeometryTypeList;
  FMultiGeometrySimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'MultiGeometrySimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FMultiGeometryObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'MultiGeometryObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLMultiGeometryType.Get_AbstractGeometryGroup: IXMLAbstractGeometryTypeList;
begin
  Result := FAbstractGeometryGroup;
end;

function TXMLMultiGeometryType.Get_MultiGeometrySimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FMultiGeometrySimpleExtensionGroup;
end;

function TXMLMultiGeometryType.Get_MultiGeometryObjectExtensionGroup: IXMLString_List;
begin
  Result := FMultiGeometryObjectExtensionGroup;
end;

{ TXMLMultiGeometryTypeList }

function TXMLMultiGeometryTypeList.Add: IXMLMultiGeometryType;
begin
  Result := AddItem(-1) as IXMLMultiGeometryType;
end;

function TXMLMultiGeometryTypeList.Insert(const Index: Integer): IXMLMultiGeometryType;
begin
  Result := AddItem(Index) as IXMLMultiGeometryType;
end;

function TXMLMultiGeometryTypeList.Get_Item(Index: Integer): IXMLMultiGeometryType;
begin
  Result := List[Index] as IXMLMultiGeometryType;
end;

{ TXMLPointType }

procedure TXMLPointType.AfterConstruction;
begin
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FPointSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'PointSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FPointObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'PointObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLPointType.Get_Extrude: Boolean;
begin
  Result := ChildNodes['extrude'].NodeValue;
end;

procedure TXMLPointType.Set_Extrude(Value: Boolean);
begin
  ChildNodes['extrude'].NodeValue := Value;
end;

function TXMLPointType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLPointType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLPointType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLPointType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLPointType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLPointType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLPointType.Get_Coordinates: UnicodeString;
begin
  Result := ChildNodes['coordinates'].Text;
end;

procedure TXMLPointType.Set_Coordinates(Value: UnicodeString);
begin
  ChildNodes['coordinates'].NodeValue := Value;
end;

function TXMLPointType.Get_PointSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FPointSimpleExtensionGroup;
end;

function TXMLPointType.Get_PointObjectExtensionGroup: IXMLString_List;
begin
  Result := FPointObjectExtensionGroup;
end;

{ TXMLLineStringType }

procedure TXMLLineStringType.AfterConstruction;
begin
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FLineStringSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LineStringSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLineStringObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LineStringObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLineStringType.Get_Extrude: Boolean;
begin
  Result := ChildNodes['extrude'].NodeValue;
end;

procedure TXMLLineStringType.Set_Extrude(Value: Boolean);
begin
  ChildNodes['extrude'].NodeValue := Value;
end;

function TXMLLineStringType.Get_Tessellate: Boolean;
begin
  Result := ChildNodes['tessellate'].NodeValue;
end;

procedure TXMLLineStringType.Set_Tessellate(Value: Boolean);
begin
  ChildNodes['tessellate'].NodeValue := Value;
end;

function TXMLLineStringType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLLineStringType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLLineStringType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLLineStringType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLLineStringType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLLineStringType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLLineStringType.Get_Coordinates: UnicodeString;
begin
  Result := ChildNodes['coordinates'].Text;
end;

procedure TXMLLineStringType.Set_Coordinates(Value: UnicodeString);
begin
  ChildNodes['coordinates'].NodeValue := Value;
end;

function TXMLLineStringType.Get_AltitudeOffset: Double;
begin
  Result := ChildNodes['altitudeOffset'].NodeValue;
end;

procedure TXMLLineStringType.Set_AltitudeOffset(Value: Double);
begin
  ChildNodes['altitudeOffset'].NodeValue := Value;
end;

function TXMLLineStringType.Get_LineStringSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLineStringSimpleExtensionGroup;
end;

function TXMLLineStringType.Get_LineStringObjectExtensionGroup: IXMLString_List;
begin
  Result := FLineStringObjectExtensionGroup;
end;

{ TXMLLinearRingType }

procedure TXMLLinearRingType.AfterConstruction;
begin
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FLinearRingSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LinearRingSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLinearRingObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LinearRingObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLinearRingType.Get_Extrude: Boolean;
begin
  Result := ChildNodes['extrude'].NodeValue;
end;

procedure TXMLLinearRingType.Set_Extrude(Value: Boolean);
begin
  ChildNodes['extrude'].NodeValue := Value;
end;

function TXMLLinearRingType.Get_Tessellate: Boolean;
begin
  Result := ChildNodes['tessellate'].NodeValue;
end;

procedure TXMLLinearRingType.Set_Tessellate(Value: Boolean);
begin
  ChildNodes['tessellate'].NodeValue := Value;
end;

function TXMLLinearRingType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLLinearRingType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLLinearRingType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLLinearRingType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLLinearRingType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLLinearRingType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLLinearRingType.Get_Coordinates: UnicodeString;
begin
  Result := ChildNodes['coordinates'].Text;
end;

procedure TXMLLinearRingType.Set_Coordinates(Value: UnicodeString);
begin
  ChildNodes['coordinates'].NodeValue := Value;
end;

function TXMLLinearRingType.Get_AltitudeOffset: Double;
begin
  Result := ChildNodes['altitudeOffset'].NodeValue;
end;

procedure TXMLLinearRingType.Set_AltitudeOffset(Value: Double);
begin
  ChildNodes['altitudeOffset'].NodeValue := Value;
end;

function TXMLLinearRingType.Get_LinearRingSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLinearRingSimpleExtensionGroup;
end;

function TXMLLinearRingType.Get_LinearRingObjectExtensionGroup: IXMLString_List;
begin
  Result := FLinearRingObjectExtensionGroup;
end;

{ TXMLPolygonType }

procedure TXMLPolygonType.AfterConstruction;
begin
  RegisterChildNode('outerBoundaryIs', TXMLBoundaryType);
  RegisterChildNode('innerBoundaryIs', TXMLBoundaryType);
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FInnerBoundaryIs := CreateCollection(TXMLBoundaryTypeList, IXMLBoundaryType, 'innerBoundaryIs') as IXMLBoundaryTypeList;
  FPolygonSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'PolygonSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FPolygonObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'PolygonObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLPolygonType.Get_Extrude: Boolean;
begin
  Result := ChildNodes['extrude'].NodeValue;
end;

procedure TXMLPolygonType.Set_Extrude(Value: Boolean);
begin
  ChildNodes['extrude'].NodeValue := Value;
end;

function TXMLPolygonType.Get_Tessellate: Boolean;
begin
  Result := ChildNodes['tessellate'].NodeValue;
end;

procedure TXMLPolygonType.Set_Tessellate(Value: Boolean);
begin
  ChildNodes['tessellate'].NodeValue := Value;
end;

function TXMLPolygonType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLPolygonType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLPolygonType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLPolygonType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLPolygonType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLPolygonType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLPolygonType.Get_OuterBoundaryIs: IXMLBoundaryType;
begin
  Result := ChildNodes['outerBoundaryIs'] as IXMLBoundaryType;
end;

function TXMLPolygonType.Get_InnerBoundaryIs: IXMLBoundaryTypeList;
begin
  Result := FInnerBoundaryIs;
end;

function TXMLPolygonType.Get_PolygonSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FPolygonSimpleExtensionGroup;
end;

function TXMLPolygonType.Get_PolygonObjectExtensionGroup: IXMLString_List;
begin
  Result := FPolygonObjectExtensionGroup;
end;

{ TXMLBoundaryType }

procedure TXMLBoundaryType.AfterConstruction;
begin
  RegisterChildNode('LinearRing', TXMLLinearRingType);
  FBoundarySimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'BoundarySimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FBoundaryObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'BoundaryObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLBoundaryType.Get_LinearRing: IXMLLinearRingType;
begin
  Result := ChildNodes['LinearRing'] as IXMLLinearRingType;
end;

function TXMLBoundaryType.Get_BoundarySimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FBoundarySimpleExtensionGroup;
end;

function TXMLBoundaryType.Get_BoundaryObjectExtensionGroup: IXMLString_List;
begin
  Result := FBoundaryObjectExtensionGroup;
end;

{ TXMLBoundaryTypeList }

function TXMLBoundaryTypeList.Add: IXMLBoundaryType;
begin
  Result := AddItem(-1) as IXMLBoundaryType;
end;

function TXMLBoundaryTypeList.Insert(const Index: Integer): IXMLBoundaryType;
begin
  Result := AddItem(Index) as IXMLBoundaryType;
end;

function TXMLBoundaryTypeList.Get_Item(Index: Integer): IXMLBoundaryType;
begin
  Result := List[Index] as IXMLBoundaryType;
end;

{ TXMLModelType }

procedure TXMLModelType.AfterConstruction;
begin
  RegisterChildNode('Location', TXMLLocationType);
  RegisterChildNode('Orientation', TXMLOrientationType);
  RegisterChildNode('Scale', TXMLScaleType);
  RegisterChildNode('Link', TXMLLinkType);
  RegisterChildNode('ResourceMap', TXMLResourceMapType);
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FModelSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'ModelSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FModelObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'ModelObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLModelType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLModelType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLModelType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLModelType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLModelType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLModelType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLModelType.Get_Location: IXMLLocationType;
begin
  Result := ChildNodes['Location'] as IXMLLocationType;
end;

function TXMLModelType.Get_Orientation: IXMLOrientationType;
begin
  Result := ChildNodes['Orientation'] as IXMLOrientationType;
end;

function TXMLModelType.Get_Scale: IXMLScaleType;
begin
  Result := ChildNodes['Scale'] as IXMLScaleType;
end;

function TXMLModelType.Get_Link: IXMLLinkType;
begin
  Result := ChildNodes['Link'] as IXMLLinkType;
end;

function TXMLModelType.Get_ResourceMap: IXMLResourceMapType;
begin
  Result := ChildNodes['ResourceMap'] as IXMLResourceMapType;
end;

function TXMLModelType.Get_ModelSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FModelSimpleExtensionGroup;
end;

function TXMLModelType.Get_ModelObjectExtensionGroup: IXMLString_List;
begin
  Result := FModelObjectExtensionGroup;
end;

{ TXMLLocationType }

procedure TXMLLocationType.AfterConstruction;
begin
  FLocationSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LocationSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLocationObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LocationObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLocationType.Get_Longitude: Double;
begin
  Result := ChildNodes['longitude'].NodeValue;
end;

procedure TXMLLocationType.Set_Longitude(Value: Double);
begin
  ChildNodes['longitude'].NodeValue := Value;
end;

function TXMLLocationType.Get_Latitude: Double;
begin
  Result := ChildNodes['latitude'].NodeValue;
end;

procedure TXMLLocationType.Set_Latitude(Value: Double);
begin
  ChildNodes['latitude'].NodeValue := Value;
end;

function TXMLLocationType.Get_Altitude: Double;
begin
  Result := ChildNodes['altitude'].NodeValue;
end;

procedure TXMLLocationType.Set_Altitude(Value: Double);
begin
  ChildNodes['altitude'].NodeValue := Value;
end;

function TXMLLocationType.Get_LocationSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLocationSimpleExtensionGroup;
end;

function TXMLLocationType.Get_LocationObjectExtensionGroup: IXMLString_List;
begin
  Result := FLocationObjectExtensionGroup;
end;

{ TXMLOrientationType }

procedure TXMLOrientationType.AfterConstruction;
begin
  FOrientationSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'OrientationSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FOrientationObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'OrientationObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLOrientationType.Get_Heading: Double;
begin
  Result := ChildNodes['heading'].NodeValue;
end;

procedure TXMLOrientationType.Set_Heading(Value: Double);
begin
  ChildNodes['heading'].NodeValue := Value;
end;

function TXMLOrientationType.Get_Tilt: Double;
begin
  Result := ChildNodes['tilt'].NodeValue;
end;

procedure TXMLOrientationType.Set_Tilt(Value: Double);
begin
  ChildNodes['tilt'].NodeValue := Value;
end;

function TXMLOrientationType.Get_Roll: Double;
begin
  Result := ChildNodes['roll'].NodeValue;
end;

procedure TXMLOrientationType.Set_Roll(Value: Double);
begin
  ChildNodes['roll'].NodeValue := Value;
end;

function TXMLOrientationType.Get_OrientationSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FOrientationSimpleExtensionGroup;
end;

function TXMLOrientationType.Get_OrientationObjectExtensionGroup: IXMLString_List;
begin
  Result := FOrientationObjectExtensionGroup;
end;

{ TXMLScaleType }

procedure TXMLScaleType.AfterConstruction;
begin
  FScaleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'ScaleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FScaleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'ScaleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLScaleType.Get_X: Double;
begin
  Result := ChildNodes[WideString('x')].NodeValue;
end;

procedure TXMLScaleType.Set_X(Value: Double);
begin
  ChildNodes[WideString('x')].NodeValue := Value;
end;

function TXMLScaleType.Get_Y: Double;
begin
  Result := ChildNodes[WideString('y')].NodeValue;
end;

procedure TXMLScaleType.Set_Y(Value: Double);
begin
  ChildNodes[WideString('y')].NodeValue := Value;
end;

function TXMLScaleType.Get_Z: Double;
begin
  Result := ChildNodes[WideString('z')].NodeValue;
end;

procedure TXMLScaleType.Set_Z(Value: Double);
begin
  ChildNodes[WideString('z')].NodeValue := Value;
end;

function TXMLScaleType.Get_ScaleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FScaleSimpleExtensionGroup;
end;

function TXMLScaleType.Get_ScaleObjectExtensionGroup: IXMLString_List;
begin
  Result := FScaleObjectExtensionGroup;
end;

{ TXMLResourceMapType }

procedure TXMLResourceMapType.AfterConstruction;
begin
  RegisterChildNode('Alias', TXMLAliasType);
  FAlias := CreateCollection(TXMLAliasTypeList, IXMLAliasType, 'Alias') as IXMLAliasTypeList;
  FResourceMapSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'ResourceMapSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FResourceMapObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'ResourceMapObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLResourceMapType.Get_Alias: IXMLAliasTypeList;
begin
  Result := FAlias;
end;

function TXMLResourceMapType.Get_ResourceMapSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FResourceMapSimpleExtensionGroup;
end;

function TXMLResourceMapType.Get_ResourceMapObjectExtensionGroup: IXMLString_List;
begin
  Result := FResourceMapObjectExtensionGroup;
end;

{ TXMLAliasType }

procedure TXMLAliasType.AfterConstruction;
begin
  FAliasSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AliasSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAliasObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AliasObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAliasType.Get_TargetHref: UnicodeString;
begin
  Result := ChildNodes['targetHref'].Text;
end;

procedure TXMLAliasType.Set_TargetHref(Value: UnicodeString);
begin
  ChildNodes['targetHref'].NodeValue := Value;
end;

function TXMLAliasType.Get_SourceHref: UnicodeString;
begin
  Result := ChildNodes['sourceHref'].Text;
end;

procedure TXMLAliasType.Set_SourceHref(Value: UnicodeString);
begin
  ChildNodes['sourceHref'].NodeValue := Value;
end;

function TXMLAliasType.Get_AliasSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAliasSimpleExtensionGroup;
end;

function TXMLAliasType.Get_AliasObjectExtensionGroup: IXMLString_List;
begin
  Result := FAliasObjectExtensionGroup;
end;

{ TXMLAliasTypeList }

function TXMLAliasTypeList.Add: IXMLAliasType;
begin
  Result := AddItem(-1) as IXMLAliasType;
end;

function TXMLAliasTypeList.Insert(const Index: Integer): IXMLAliasType;
begin
  Result := AddItem(Index) as IXMLAliasType;
end;

function TXMLAliasTypeList.Get_Item(Index: Integer): IXMLAliasType;
begin
  Result := List[Index] as IXMLAliasType;
end;

{ TXMLTrackType }

procedure TXMLTrackType.AfterConstruction;
begin
  RegisterChildNode('Model', TXMLModelType);
  RegisterChildNode('ExtendedData', TXMLExtendedDataType);
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FWhen := CreateCollection(TXMLDateTimeTypeList, IXMLNode, 'when') as IXMLDateTimeTypeList;
  FCoord := CreateCollection(TXMLString_List, IXMLNode, 'coord') as IXMLString_List;
  FAngles := CreateCollection(TXMLString_List, IXMLNode, 'angles') as IXMLString_List;
  FTrackSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'TrackSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FTrackObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'TrackObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLTrackType.Get_Extrude: Boolean;
begin
  Result := ChildNodes['extrude'].NodeValue;
end;

procedure TXMLTrackType.Set_Extrude(Value: Boolean);
begin
  ChildNodes['extrude'].NodeValue := Value;
end;

function TXMLTrackType.Get_Tessellate: Boolean;
begin
  Result := ChildNodes['tessellate'].NodeValue;
end;

procedure TXMLTrackType.Set_Tessellate(Value: Boolean);
begin
  ChildNodes['tessellate'].NodeValue := Value;
end;

function TXMLTrackType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLTrackType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLTrackType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLTrackType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLTrackType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLTrackType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLTrackType.Get_When: IXMLDateTimeTypeList;
begin
  Result := FWhen;
end;

function TXMLTrackType.Get_Coord: IXMLString_List;
begin
  Result := FCoord;
end;

function TXMLTrackType.Get_Angles: IXMLString_List;
begin
  Result := FAngles;
end;

function TXMLTrackType.Get_Model: IXMLModelType;
begin
  Result := ChildNodes['Model'] as IXMLModelType;
end;

function TXMLTrackType.Get_ExtendedData: IXMLExtendedDataType;
begin
  Result := ChildNodes['ExtendedData'] as IXMLExtendedDataType;
end;

function TXMLTrackType.Get_TrackSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FTrackSimpleExtensionGroup;
end;

function TXMLTrackType.Get_TrackObjectExtensionGroup: IXMLString_List;
begin
  Result := FTrackObjectExtensionGroup;
end;

{ TXMLTrackTypeList }

function TXMLTrackTypeList.Add: IXMLTrackType;
begin
  Result := AddItem(-1) as IXMLTrackType;
end;

function TXMLTrackTypeList.Insert(const Index: Integer): IXMLTrackType;
begin
  Result := AddItem(Index) as IXMLTrackType;
end;

function TXMLTrackTypeList.Get_Item(Index: Integer): IXMLTrackType;
begin
  Result := List[Index] as IXMLTrackType;
end;

{ TXMLMultiTrackType }

procedure TXMLMultiTrackType.AfterConstruction;
begin
  RegisterChildNode('Track', TXMLTrackType);
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FTrack := CreateCollection(TXMLTrackTypeList, IXMLTrackType, 'Track') as IXMLTrackTypeList;
  FMultiTrackSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'MultiTrackSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FMultiTrackObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'MultiTrackObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLMultiTrackType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLMultiTrackType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLMultiTrackType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLMultiTrackType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLMultiTrackType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLMultiTrackType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLMultiTrackType.Get_Interpolate: Boolean;
begin
  Result := ChildNodes['interpolate'].NodeValue;
end;

procedure TXMLMultiTrackType.Set_Interpolate(Value: Boolean);
begin
  ChildNodes['interpolate'].NodeValue := Value;
end;

function TXMLMultiTrackType.Get_Track: IXMLTrackTypeList;
begin
  Result := FTrack;
end;

function TXMLMultiTrackType.Get_MultiTrackSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FMultiTrackSimpleExtensionGroup;
end;

function TXMLMultiTrackType.Get_MultiTrackObjectExtensionGroup: IXMLString_List;
begin
  Result := FMultiTrackObjectExtensionGroup;
end;

{ TXMLMultiTrackTypeList }

function TXMLMultiTrackTypeList.Add: IXMLMultiTrackType;
begin
  Result := AddItem(-1) as IXMLMultiTrackType;
end;

function TXMLMultiTrackTypeList.Insert(const Index: Integer): IXMLMultiTrackType;
begin
  Result := AddItem(Index) as IXMLMultiTrackType;
end;

function TXMLMultiTrackTypeList.Get_Item(Index: Integer): IXMLMultiTrackType;
begin
  Result := List[Index] as IXMLMultiTrackType;
end;

{ TXMLGroundOverlayType }

procedure TXMLGroundOverlayType.AfterConstruction;
begin
  RegisterChildNode('AbstractExtentGroup', TXMLAbstractExtentType);
  FAltitudeModeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AltitudeModeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAltitudeModeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AltitudeModeObjectExtensionGroup') as IXMLString_List;
  FGroundOverlaySimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'GroundOverlaySimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FGroundOverlayObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'GroundOverlayObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLGroundOverlayType.Get_Altitude: Double;
begin
  Result := ChildNodes['altitude'].NodeValue;
end;

procedure TXMLGroundOverlayType.Set_Altitude(Value: Double);
begin
  ChildNodes['altitude'].NodeValue := Value;
end;

function TXMLGroundOverlayType.Get_AltitudeMode: UnicodeString;
begin
  Result := ChildNodes['altitudeMode'].Text;
end;

procedure TXMLGroundOverlayType.Set_AltitudeMode(Value: UnicodeString);
begin
  ChildNodes['altitudeMode'].NodeValue := Value;
end;

function TXMLGroundOverlayType.Get_SeaFloorAltitudeMode: UnicodeString;
begin
  Result := ChildNodes['seaFloorAltitudeMode'].Text;
end;

procedure TXMLGroundOverlayType.Set_SeaFloorAltitudeMode(Value: UnicodeString);
begin
  ChildNodes['seaFloorAltitudeMode'].NodeValue := Value;
end;

function TXMLGroundOverlayType.Get_AltitudeModeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAltitudeModeSimpleExtensionGroup;
end;

function TXMLGroundOverlayType.Get_AltitudeModeObjectExtensionGroup: IXMLString_List;
begin
  Result := FAltitudeModeObjectExtensionGroup;
end;

function TXMLGroundOverlayType.Get_AbstractExtentGroup: IXMLAbstractExtentType;
begin
  Result := ChildNodes['AbstractExtentGroup'] as IXMLAbstractExtentType;
end;

function TXMLGroundOverlayType.Get_GroundOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FGroundOverlaySimpleExtensionGroup;
end;

function TXMLGroundOverlayType.Get_GroundOverlayObjectExtensionGroup: IXMLString_List;
begin
  Result := FGroundOverlayObjectExtensionGroup;
end;

{ TXMLLatLonQuadType }

procedure TXMLLatLonQuadType.AfterConstruction;
begin
  FLatLonQuadSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LatLonQuadSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLatLonQuadObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LatLonQuadObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLatLonQuadType.Get_Coordinates: UnicodeString;
begin
  Result := ChildNodes['coordinates'].Text;
end;

procedure TXMLLatLonQuadType.Set_Coordinates(Value: UnicodeString);
begin
  ChildNodes['coordinates'].NodeValue := Value;
end;

function TXMLLatLonQuadType.Get_LatLonQuadSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLatLonQuadSimpleExtensionGroup;
end;

function TXMLLatLonQuadType.Get_LatLonQuadObjectExtensionGroup: IXMLString_List;
begin
  Result := FLatLonQuadObjectExtensionGroup;
end;

{ TXMLLatLonBoxType }

procedure TXMLLatLonBoxType.AfterConstruction;
begin
  FLatLonBoxSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LatLonBoxSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLatLonBoxObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LatLonBoxObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLatLonBoxType.Get_Rotation: Double;
begin
  Result := ChildNodes['rotation'].NodeValue;
end;

procedure TXMLLatLonBoxType.Set_Rotation(Value: Double);
begin
  ChildNodes['rotation'].NodeValue := Value;
end;

function TXMLLatLonBoxType.Get_LatLonBoxSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLatLonBoxSimpleExtensionGroup;
end;

function TXMLLatLonBoxType.Get_LatLonBoxObjectExtensionGroup: IXMLString_List;
begin
  Result := FLatLonBoxObjectExtensionGroup;
end;

{ TXMLScreenOverlayType }

procedure TXMLScreenOverlayType.AfterConstruction;
begin
  RegisterChildNode('overlayXY', TXMLVec2Type);
  RegisterChildNode('screenXY', TXMLVec2Type);
  RegisterChildNode('rotationXY', TXMLVec2Type);
  RegisterChildNode('size', TXMLVec2Type);
  FScreenOverlaySimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'ScreenOverlaySimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FScreenOverlayObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'ScreenOverlayObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLScreenOverlayType.Get_OverlayXY: IXMLVec2Type;
begin
  Result := ChildNodes['overlayXY'] as IXMLVec2Type;
end;

function TXMLScreenOverlayType.Get_ScreenXY: IXMLVec2Type;
begin
  Result := ChildNodes['screenXY'] as IXMLVec2Type;
end;

function TXMLScreenOverlayType.Get_RotationXY: IXMLVec2Type;
begin
  Result := ChildNodes['rotationXY'] as IXMLVec2Type;
end;

function TXMLScreenOverlayType.Get_Size: IXMLVec2Type;
begin
  Result := ChildNodes['size'] as IXMLVec2Type;
end;

function TXMLScreenOverlayType.Get_Rotation: Double;
begin
  Result := ChildNodes['rotation'].NodeValue;
end;

procedure TXMLScreenOverlayType.Set_Rotation(Value: Double);
begin
  ChildNodes['rotation'].NodeValue := Value;
end;

function TXMLScreenOverlayType.Get_ScreenOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FScreenOverlaySimpleExtensionGroup;
end;

function TXMLScreenOverlayType.Get_ScreenOverlayObjectExtensionGroup: IXMLString_List;
begin
  Result := FScreenOverlayObjectExtensionGroup;
end;

{ TXMLPhotoOverlayType }

procedure TXMLPhotoOverlayType.AfterConstruction;
begin
  RegisterChildNode('ViewVolume', TXMLViewVolumeType);
  RegisterChildNode('ImagePyramid', TXMLImagePyramidType);
  RegisterChildNode('Point', TXMLPointType);
  FPhotoOverlaySimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'PhotoOverlaySimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FPhotoOverlayObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'PhotoOverlayObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLPhotoOverlayType.Get_Rotation: Double;
begin
  Result := ChildNodes['rotation'].NodeValue;
end;

procedure TXMLPhotoOverlayType.Set_Rotation(Value: Double);
begin
  ChildNodes['rotation'].NodeValue := Value;
end;

function TXMLPhotoOverlayType.Get_ViewVolume: IXMLViewVolumeType;
begin
  Result := ChildNodes['ViewVolume'] as IXMLViewVolumeType;
end;

function TXMLPhotoOverlayType.Get_ImagePyramid: IXMLImagePyramidType;
begin
  Result := ChildNodes['ImagePyramid'] as IXMLImagePyramidType;
end;

function TXMLPhotoOverlayType.Get_Point: IXMLPointType;
begin
  Result := ChildNodes['Point'] as IXMLPointType;
end;

function TXMLPhotoOverlayType.Get_AbstractShape: UnicodeString;
begin
  Result := ChildNodes['abstractShape'].Text;
end;

procedure TXMLPhotoOverlayType.Set_AbstractShape(Value: UnicodeString);
begin
  ChildNodes['abstractShape'].NodeValue := Value;
end;

function TXMLPhotoOverlayType.Get_PhotoOverlaySimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FPhotoOverlaySimpleExtensionGroup;
end;

function TXMLPhotoOverlayType.Get_PhotoOverlayObjectExtensionGroup: IXMLString_List;
begin
  Result := FPhotoOverlayObjectExtensionGroup;
end;

{ TXMLViewVolumeType }

procedure TXMLViewVolumeType.AfterConstruction;
begin
  FViewVolumeSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'ViewVolumeSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FViewVolumeObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'ViewVolumeObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLViewVolumeType.Get_LeftFov: Double;
begin
  Result := ChildNodes['leftFov'].NodeValue;
end;

procedure TXMLViewVolumeType.Set_LeftFov(Value: Double);
begin
  ChildNodes['leftFov'].NodeValue := Value;
end;

function TXMLViewVolumeType.Get_RightFov: Double;
begin
  Result := ChildNodes['rightFov'].NodeValue;
end;

procedure TXMLViewVolumeType.Set_RightFov(Value: Double);
begin
  ChildNodes['rightFov'].NodeValue := Value;
end;

function TXMLViewVolumeType.Get_BottomFov: Double;
begin
  Result := ChildNodes['bottomFov'].NodeValue;
end;

procedure TXMLViewVolumeType.Set_BottomFov(Value: Double);
begin
  ChildNodes['bottomFov'].NodeValue := Value;
end;

function TXMLViewVolumeType.Get_TopFov: Double;
begin
  Result := ChildNodes['topFov'].NodeValue;
end;

procedure TXMLViewVolumeType.Set_TopFov(Value: Double);
begin
  ChildNodes['topFov'].NodeValue := Value;
end;

function TXMLViewVolumeType.Get_Near: Double;
begin
  Result := ChildNodes['near'].NodeValue;
end;

procedure TXMLViewVolumeType.Set_Near(Value: Double);
begin
  ChildNodes['near'].NodeValue := Value;
end;

function TXMLViewVolumeType.Get_ViewVolumeSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FViewVolumeSimpleExtensionGroup;
end;

function TXMLViewVolumeType.Get_ViewVolumeObjectExtensionGroup: IXMLString_List;
begin
  Result := FViewVolumeObjectExtensionGroup;
end;

{ TXMLImagePyramidType }

procedure TXMLImagePyramidType.AfterConstruction;
begin
  FImagePyramidSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'ImagePyramidSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FImagePyramidObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'ImagePyramidObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLImagePyramidType.Get_TileSize: Integer;
begin
  Result := ChildNodes['tileSize'].NodeValue;
end;

procedure TXMLImagePyramidType.Set_TileSize(Value: Integer);
begin
  ChildNodes['tileSize'].NodeValue := Value;
end;

function TXMLImagePyramidType.Get_MaxWidth: Integer;
begin
  Result := ChildNodes['maxWidth'].NodeValue;
end;

procedure TXMLImagePyramidType.Set_MaxWidth(Value: Integer);
begin
  ChildNodes['maxWidth'].NodeValue := Value;
end;

function TXMLImagePyramidType.Get_MaxHeight: Integer;
begin
  Result := ChildNodes['maxHeight'].NodeValue;
end;

procedure TXMLImagePyramidType.Set_MaxHeight(Value: Integer);
begin
  ChildNodes['maxHeight'].NodeValue := Value;
end;

function TXMLImagePyramidType.Get_AbstractGridOrigin: UnicodeString;
begin
  Result := ChildNodes['abstractGridOrigin'].Text;
end;

procedure TXMLImagePyramidType.Set_AbstractGridOrigin(Value: UnicodeString);
begin
  ChildNodes['abstractGridOrigin'].NodeValue := Value;
end;

function TXMLImagePyramidType.Get_ImagePyramidSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FImagePyramidSimpleExtensionGroup;
end;

function TXMLImagePyramidType.Get_ImagePyramidObjectExtensionGroup: IXMLString_List;
begin
  Result := FImagePyramidObjectExtensionGroup;
end;

{ TXMLStyleType }

procedure TXMLStyleType.AfterConstruction;
begin
  RegisterChildNode('IconStyle', TXMLIconStyleType);
  RegisterChildNode('LabelStyle', TXMLLabelStyleType);
  RegisterChildNode('LineStyle', TXMLLineStyleType);
  RegisterChildNode('PolyStyle', TXMLPolyStyleType);
  RegisterChildNode('BalloonStyle', TXMLBalloonStyleType);
  RegisterChildNode('ListStyle', TXMLListStyleType);
  FStyleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'StyleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FStyleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'StyleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLStyleType.Get_IconStyle: IXMLIconStyleType;
begin
  Result := ChildNodes['IconStyle'] as IXMLIconStyleType;
end;

function TXMLStyleType.Get_LabelStyle: IXMLLabelStyleType;
begin
  Result := ChildNodes['LabelStyle'] as IXMLLabelStyleType;
end;

function TXMLStyleType.Get_LineStyle: IXMLLineStyleType;
begin
  Result := ChildNodes['LineStyle'] as IXMLLineStyleType;
end;

function TXMLStyleType.Get_PolyStyle: IXMLPolyStyleType;
begin
  Result := ChildNodes['PolyStyle'] as IXMLPolyStyleType;
end;

function TXMLStyleType.Get_BalloonStyle: IXMLBalloonStyleType;
begin
  Result := ChildNodes['BalloonStyle'] as IXMLBalloonStyleType;
end;

function TXMLStyleType.Get_ListStyle: IXMLListStyleType;
begin
  Result := ChildNodes['ListStyle'] as IXMLListStyleType;
end;

function TXMLStyleType.Get_StyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FStyleSimpleExtensionGroup;
end;

function TXMLStyleType.Get_StyleObjectExtensionGroup: IXMLString_List;
begin
  Result := FStyleObjectExtensionGroup;
end;

{ TXMLAbstractSubStyleType }

procedure TXMLAbstractSubStyleType.AfterConstruction;
begin
  FAbstractSubStyleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractSubStyleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractSubStyleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractSubStyleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractSubStyleType.Get_AbstractSubStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractSubStyleSimpleExtensionGroup;
end;

function TXMLAbstractSubStyleType.Get_AbstractSubStyleObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractSubStyleObjectExtensionGroup;
end;

{ TXMLAbstractColorStyleType }

procedure TXMLAbstractColorStyleType.AfterConstruction;
begin
  FAbstractColorStyleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractColorStyleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractColorStyleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractColorStyleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractColorStyleType.Get_Color: UnicodeString;
begin
  Result := ChildNodes['color'].Text;
end;

procedure TXMLAbstractColorStyleType.Set_Color(Value: UnicodeString);
begin
  ChildNodes['color'].NodeValue := Value;
end;

function TXMLAbstractColorStyleType.Get_AbstractColorMode: UnicodeString;
begin
  Result := ChildNodes['abstractColorMode'].Text;
end;

procedure TXMLAbstractColorStyleType.Set_AbstractColorMode(Value: UnicodeString);
begin
  ChildNodes['abstractColorMode'].NodeValue := Value;
end;

function TXMLAbstractColorStyleType.Get_AbstractColorStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractColorStyleSimpleExtensionGroup;
end;

function TXMLAbstractColorStyleType.Get_AbstractColorStyleObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractColorStyleObjectExtensionGroup;
end;

{ TXMLIconStyleType }

procedure TXMLIconStyleType.AfterConstruction;
begin
  RegisterChildNode('Icon', TXMLBasicLinkType);
  RegisterChildNode('hotSpot', TXMLVec2Type);
  FIconStyleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'IconStyleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FIconStyleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'IconStyleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLIconStyleType.Get_Scale: Double;
begin
  Result := ChildNodes['scale'].NodeValue;
end;

procedure TXMLIconStyleType.Set_Scale(Value: Double);
begin
  ChildNodes['scale'].NodeValue := Value;
end;

function TXMLIconStyleType.Get_Heading: Double;
begin
  Result := ChildNodes['heading'].NodeValue;
end;

procedure TXMLIconStyleType.Set_Heading(Value: Double);
begin
  ChildNodes['heading'].NodeValue := Value;
end;

function TXMLIconStyleType.Get_Icon: IXMLBasicLinkType;
begin
  Result := ChildNodes['Icon'] as IXMLBasicLinkType;
end;

function TXMLIconStyleType.Get_HotSpot: IXMLVec2Type;
begin
  Result := ChildNodes['hotSpot'] as IXMLVec2Type;
end;

function TXMLIconStyleType.Get_IconStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FIconStyleSimpleExtensionGroup;
end;

function TXMLIconStyleType.Get_IconStyleObjectExtensionGroup: IXMLString_List;
begin
  Result := FIconStyleObjectExtensionGroup;
end;

{ TXMLLabelStyleType }

procedure TXMLLabelStyleType.AfterConstruction;
begin
  FLabelStyleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LabelStyleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLabelStyleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LabelStyleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLabelStyleType.Get_Scale: Double;
begin
  Result := ChildNodes['scale'].NodeValue;
end;

procedure TXMLLabelStyleType.Set_Scale(Value: Double);
begin
  ChildNodes['scale'].NodeValue := Value;
end;

function TXMLLabelStyleType.Get_LabelStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLabelStyleSimpleExtensionGroup;
end;

function TXMLLabelStyleType.Get_LabelStyleObjectExtensionGroup: IXMLString_List;
begin
  Result := FLabelStyleObjectExtensionGroup;
end;

{ TXMLLineStyleType }

procedure TXMLLineStyleType.AfterConstruction;
begin
  FLineStyleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'LineStyleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FLineStyleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'LineStyleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLLineStyleType.Get_Width: Double;
begin
  Result := ChildNodes['width'].NodeValue;
end;

procedure TXMLLineStyleType.Set_Width(Value: Double);
begin
  ChildNodes['width'].NodeValue := Value;
end;

function TXMLLineStyleType.Get_LineStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FLineStyleSimpleExtensionGroup;
end;

function TXMLLineStyleType.Get_LineStyleObjectExtensionGroup: IXMLString_List;
begin
  Result := FLineStyleObjectExtensionGroup;
end;

{ TXMLPolyStyleType }

procedure TXMLPolyStyleType.AfterConstruction;
begin
  FPolyStyleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'PolyStyleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FPolyStyleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'PolyStyleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLPolyStyleType.Get_Fill: Boolean;
begin
  Result := ChildNodes['fill'].NodeValue;
end;

procedure TXMLPolyStyleType.Set_Fill(Value: Boolean);
begin
  ChildNodes['fill'].NodeValue := Value;
end;

function TXMLPolyStyleType.Get_Outline: Boolean;
begin
  Result := ChildNodes['outline'].NodeValue;
end;

procedure TXMLPolyStyleType.Set_Outline(Value: Boolean);
begin
  ChildNodes['outline'].NodeValue := Value;
end;

function TXMLPolyStyleType.Get_PolyStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FPolyStyleSimpleExtensionGroup;
end;

function TXMLPolyStyleType.Get_PolyStyleObjectExtensionGroup: IXMLString_List;
begin
  Result := FPolyStyleObjectExtensionGroup;
end;

{ TXMLBalloonStyleType }

procedure TXMLBalloonStyleType.AfterConstruction;
begin
  FBalloonStyleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'BalloonStyleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FBalloonStyleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'BalloonStyleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLBalloonStyleType.Get_AbstractBgColorGroup: UnicodeString;
begin
  Result := ChildNodes['AbstractBgColorGroup'].Text;
end;

procedure TXMLBalloonStyleType.Set_AbstractBgColorGroup(Value: UnicodeString);
begin
  ChildNodes['AbstractBgColorGroup'].NodeValue := Value;
end;

function TXMLBalloonStyleType.Get_TextColor: UnicodeString;
begin
  Result := ChildNodes['textColor'].Text;
end;

procedure TXMLBalloonStyleType.Set_TextColor(Value: UnicodeString);
begin
  ChildNodes['textColor'].NodeValue := Value;
end;

function TXMLBalloonStyleType.Get_Text: UnicodeString;
begin
  Result := ChildNodes['text'].Text;
end;

procedure TXMLBalloonStyleType.Set_Text(Value: UnicodeString);
begin
  ChildNodes['text'].NodeValue := Value;
end;

function TXMLBalloonStyleType.Get_AbstractDisplayMode: UnicodeString;
begin
  Result := ChildNodes['abstractDisplayMode'].Text;
end;

procedure TXMLBalloonStyleType.Set_AbstractDisplayMode(Value: UnicodeString);
begin
  ChildNodes['abstractDisplayMode'].NodeValue := Value;
end;

function TXMLBalloonStyleType.Get_BalloonStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FBalloonStyleSimpleExtensionGroup;
end;

function TXMLBalloonStyleType.Get_BalloonStyleObjectExtensionGroup: IXMLString_List;
begin
  Result := FBalloonStyleObjectExtensionGroup;
end;

{ TXMLListStyleType }

procedure TXMLListStyleType.AfterConstruction;
begin
  RegisterChildNode('ItemIcon', TXMLItemIconType);
  FItemIcon := CreateCollection(TXMLItemIconTypeList, IXMLItemIconType, 'ItemIcon') as IXMLItemIconTypeList;
  FListStyleSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'ListStyleSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FListStyleObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'ListStyleObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLListStyleType.Get_AbstractListItemType: UnicodeString;
begin
  Result := ChildNodes['abstractListItemType'].Text;
end;

procedure TXMLListStyleType.Set_AbstractListItemType(Value: UnicodeString);
begin
  ChildNodes['abstractListItemType'].NodeValue := Value;
end;

function TXMLListStyleType.Get_BgColor: UnicodeString;
begin
  Result := ChildNodes['bgColor'].Text;
end;

procedure TXMLListStyleType.Set_BgColor(Value: UnicodeString);
begin
  ChildNodes['bgColor'].NodeValue := Value;
end;

function TXMLListStyleType.Get_ItemIcon: IXMLItemIconTypeList;
begin
  Result := FItemIcon;
end;

function TXMLListStyleType.Get_MaxSnippetLines: Integer;
begin
  Result := ChildNodes['maxSnippetLines'].NodeValue;
end;

procedure TXMLListStyleType.Set_MaxSnippetLines(Value: Integer);
begin
  ChildNodes['maxSnippetLines'].NodeValue := Value;
end;

function TXMLListStyleType.Get_ListStyleSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FListStyleSimpleExtensionGroup;
end;

function TXMLListStyleType.Get_ListStyleObjectExtensionGroup: IXMLString_List;
begin
  Result := FListStyleObjectExtensionGroup;
end;

{ TXMLItemIconType }

procedure TXMLItemIconType.AfterConstruction;
begin
  FItemIconSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'ItemIconSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FItemIconObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'ItemIconObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLItemIconType.Get_AbstractState: Variant;
begin
  Result := ChildNodes['abstractState'].NodeValue;
end;

procedure TXMLItemIconType.Set_AbstractState(Value: Variant);
begin
  ChildNodes['abstractState'].NodeValue := Value;
end;

function TXMLItemIconType.Get_Href: UnicodeString;
begin
  Result := ChildNodes['href'].Text;
end;

procedure TXMLItemIconType.Set_Href(Value: UnicodeString);
begin
  ChildNodes['href'].NodeValue := Value;
end;

function TXMLItemIconType.Get_ItemIconSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FItemIconSimpleExtensionGroup;
end;

function TXMLItemIconType.Get_ItemIconObjectExtensionGroup: IXMLString_List;
begin
  Result := FItemIconObjectExtensionGroup;
end;

{ TXMLItemIconTypeList }

function TXMLItemIconTypeList.Add: IXMLItemIconType;
begin
  Result := AddItem(-1) as IXMLItemIconType;
end;

function TXMLItemIconTypeList.Insert(const Index: Integer): IXMLItemIconType;
begin
  Result := AddItem(Index) as IXMLItemIconType;
end;

function TXMLItemIconTypeList.Get_Item(Index: Integer): IXMLItemIconType;
begin
  Result := List[Index] as IXMLItemIconType;
end;

{ TXMLStyleMapType }

procedure TXMLStyleMapType.AfterConstruction;
begin
  RegisterChildNode('Pair', TXMLPairType);
  FPair := CreateCollection(TXMLPairTypeList, IXMLPairType, 'Pair') as IXMLPairTypeList;
  FStyleMapSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'StyleMapSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FStyleMapObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'StyleMapObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLStyleMapType.Get_Pair: IXMLPairTypeList;
begin
  Result := FPair;
end;

function TXMLStyleMapType.Get_StyleMapSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FStyleMapSimpleExtensionGroup;
end;

function TXMLStyleMapType.Get_StyleMapObjectExtensionGroup: IXMLString_List;
begin
  Result := FStyleMapObjectExtensionGroup;
end;

{ TXMLPairType }

procedure TXMLPairType.AfterConstruction;
begin
  RegisterChildNode('AbstractStyleSelectorGroup', TXMLAbstractStyleSelectorType);
  FPairSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'PairSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FPairObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'PairObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLPairType.Get_key: UnicodeString;
begin
  Result := ChildNodes['key'].Text;
end;

procedure TXMLPairType.Set_key(Value: UnicodeString);
begin
  ChildNodes['key'].NodeValue := Value;
end;

function TXMLPairType.Get_StyleUrl: UnicodeString;
begin
  Result := ChildNodes['styleUrl'].Text;
end;

procedure TXMLPairType.Set_StyleUrl(Value: UnicodeString);
begin
  ChildNodes['styleUrl'].NodeValue := Value;
end;

function TXMLPairType.Get_AbstractStyleSelectorGroup: IXMLAbstractStyleSelectorType;
begin
  Result := ChildNodes['AbstractStyleSelectorGroup'] as IXMLAbstractStyleSelectorType;
end;

function TXMLPairType.Get_PairSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FPairSimpleExtensionGroup;
end;

function TXMLPairType.Get_PairObjectExtensionGroup: IXMLString_List;
begin
  Result := FPairObjectExtensionGroup;
end;

{ TXMLPairTypeList }

function TXMLPairTypeList.Add: IXMLPairType;
begin
  Result := AddItem(-1) as IXMLPairType;
end;

function TXMLPairTypeList.Insert(const Index: Integer): IXMLPairType;
begin
  Result := AddItem(Index) as IXMLPairType;
end;

function TXMLPairTypeList.Get_Item(Index: Integer): IXMLPairType;
begin
  Result := List[Index] as IXMLPairType;
end;

{ TXMLTimeStampType }

procedure TXMLTimeStampType.AfterConstruction;
begin
  FTimeStampSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'TimeStampSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FTimeStampObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'TimeStampObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLTimeStampType.Get_When: UnicodeString;
begin
  Result := ChildNodes['when'].Text;
end;

procedure TXMLTimeStampType.Set_When(Value: UnicodeString);
begin
  ChildNodes['when'].NodeValue := Value;
end;

function TXMLTimeStampType.Get_TimeStampSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FTimeStampSimpleExtensionGroup;
end;

function TXMLTimeStampType.Get_TimeStampObjectExtensionGroup: IXMLString_List;
begin
  Result := FTimeStampObjectExtensionGroup;
end;

{ TXMLTimeSpanType }

procedure TXMLTimeSpanType.AfterConstruction;
begin
  FTimeSpanSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'TimeSpanSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FTimeSpanObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'TimeSpanObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLTimeSpanType.Get_Begin_: UnicodeString;
begin
  Result := ChildNodes['begin'].Text;
end;

procedure TXMLTimeSpanType.Set_Begin_(Value: UnicodeString);
begin
  ChildNodes['begin'].NodeValue := Value;
end;

function TXMLTimeSpanType.Get_End_: UnicodeString;
begin
  Result := ChildNodes['end'].Text;
end;

procedure TXMLTimeSpanType.Set_End_(Value: UnicodeString);
begin
  ChildNodes['end'].NodeValue := Value;
end;

function TXMLTimeSpanType.Get_TimeSpanSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FTimeSpanSimpleExtensionGroup;
end;

function TXMLTimeSpanType.Get_TimeSpanObjectExtensionGroup: IXMLString_List;
begin
  Result := FTimeSpanObjectExtensionGroup;
end;

{ TXMLCreateType }

procedure TXMLCreateType.AfterConstruction;
begin
  RegisterChildNode('AbstractContainerGroup', TXMLAbstractContainerType);
  RegisterChildNode('MultiTrack', TXMLMultiTrackType);
  RegisterChildNode('MultiGeometry', TXMLMultiGeometryType);
  FAbstractContainerGroup := CreateCollection(TXMLAbstractContainerTypeList, IXMLAbstractContainerType, 'AbstractContainerGroup') as IXMLAbstractContainerTypeList;
  FMultiTrack := CreateCollection(TXMLMultiTrackTypeList, IXMLMultiTrackType, 'MultiTrack') as IXMLMultiTrackTypeList;
  FMultiGeometry := CreateCollection(TXMLMultiGeometryTypeList, IXMLMultiGeometryType, 'MultiGeometry') as IXMLMultiGeometryTypeList;
  inherited;
end;

function TXMLCreateType.Get_AbstractContainerGroup: IXMLAbstractContainerTypeList;
begin
  Result := FAbstractContainerGroup;
end;

function TXMLCreateType.Get_MultiTrack: IXMLMultiTrackTypeList;
begin
  Result := FMultiTrack;
end;

function TXMLCreateType.Get_MultiGeometry: IXMLMultiGeometryTypeList;
begin
  Result := FMultiGeometry;
end;

{ TXMLDeleteType }

procedure TXMLDeleteType.AfterConstruction;
begin
  RegisterChildNode('AbstractFeatureGroup', TXMLAbstractFeatureType);
  RegisterChildNode('AbstractGeometryGroup', TXMLAbstractGeometryType);
  FAbstractFeatureGroup := CreateCollection(TXMLAbstractFeatureTypeList, IXMLAbstractFeatureType, 'AbstractFeatureGroup') as IXMLAbstractFeatureTypeList;
  FAbstractGeometryGroup := CreateCollection(TXMLAbstractGeometryTypeList, IXMLAbstractGeometryType, 'AbstractGeometryGroup') as IXMLAbstractGeometryTypeList;
  inherited;
end;

function TXMLDeleteType.Get_AbstractFeatureGroup: IXMLAbstractFeatureTypeList;
begin
  Result := FAbstractFeatureGroup;
end;

function TXMLDeleteType.Get_AbstractGeometryGroup: IXMLAbstractGeometryTypeList;
begin
  Result := FAbstractGeometryGroup;
end;

{ TXMLChangeType }

procedure TXMLChangeType.AfterConstruction;
begin
  RegisterChildNode('AbstractObjectGroup', TXMLAbstractObjectType);
  ItemTag := 'AbstractObjectGroup';
  ItemInterface := IXMLAbstractObjectType;
  inherited;
end;

function TXMLChangeType.Get_AbstractObjectGroup(Index: Integer): IXMLAbstractObjectType;
begin
  Result := List[Index] as IXMLAbstractObjectType;
end;

function TXMLChangeType.Add: IXMLAbstractObjectType;
begin
  Result := AddItem(-1) as IXMLAbstractObjectType;
end;

function TXMLChangeType.Insert(const Index: Integer): IXMLAbstractObjectType;
begin
  Result := AddItem(Index) as IXMLAbstractObjectType;
end;

{ TXMLAbstractTourPrimitiveType }

procedure TXMLAbstractTourPrimitiveType.AfterConstruction;
begin
  FAbstractTourPrimitiveSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AbstractTourPrimitiveSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAbstractTourPrimitiveObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AbstractTourPrimitiveObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAbstractTourPrimitiveType.Get_AbstractTourPrimitiveSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAbstractTourPrimitiveSimpleExtensionGroup;
end;

function TXMLAbstractTourPrimitiveType.Get_AbstractTourPrimitiveObjectExtensionGroup: IXMLString_List;
begin
  Result := FAbstractTourPrimitiveObjectExtensionGroup;
end;

{ TXMLAbstractTourPrimitiveTypeList }

function TXMLAbstractTourPrimitiveTypeList.Add: IXMLAbstractTourPrimitiveType;
begin
  Result := AddItem(-1) as IXMLAbstractTourPrimitiveType;
end;

function TXMLAbstractTourPrimitiveTypeList.Insert(const Index: Integer): IXMLAbstractTourPrimitiveType;
begin
  Result := AddItem(Index) as IXMLAbstractTourPrimitiveType;
end;

function TXMLAbstractTourPrimitiveTypeList.Get_Item(Index: Integer): IXMLAbstractTourPrimitiveType;
begin
  Result := List[Index] as IXMLAbstractTourPrimitiveType;
end;

{ TXMLAnimatedUpdateType }

procedure TXMLAnimatedUpdateType.AfterConstruction;
begin
  RegisterChildNode('Update', TXMLUpdateType);
  FAnimatedUpdateSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'AnimatedUpdateSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FAnimatedUpdateObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'AnimatedUpdateObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLAnimatedUpdateType.Get_Duration: Double;
begin
  Result := ChildNodes['duration'].NodeValue;
end;

procedure TXMLAnimatedUpdateType.Set_Duration(Value: Double);
begin
  ChildNodes['duration'].NodeValue := Value;
end;

function TXMLAnimatedUpdateType.Get_Update: IXMLUpdateType;
begin
  Result := ChildNodes['Update'] as IXMLUpdateType;
end;

function TXMLAnimatedUpdateType.Get_DelayedStart: Double;
begin
  Result := ChildNodes['delayedStart'].NodeValue;
end;

procedure TXMLAnimatedUpdateType.Set_DelayedStart(Value: Double);
begin
  ChildNodes['delayedStart'].NodeValue := Value;
end;

function TXMLAnimatedUpdateType.Get_AnimatedUpdateSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FAnimatedUpdateSimpleExtensionGroup;
end;

function TXMLAnimatedUpdateType.Get_AnimatedUpdateObjectExtensionGroup: IXMLString_List;
begin
  Result := FAnimatedUpdateObjectExtensionGroup;
end;

{ TXMLFlyToType }

procedure TXMLFlyToType.AfterConstruction;
begin
  RegisterChildNode('AbstractViewGroup', TXMLAbstractViewType);
  FFlyToSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'FlyToSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FFlyToObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'FlyToObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLFlyToType.Get_Duration: Double;
begin
  Result := ChildNodes['duration'].NodeValue;
end;

procedure TXMLFlyToType.Set_Duration(Value: Double);
begin
  ChildNodes['duration'].NodeValue := Value;
end;

function TXMLFlyToType.Get_AbstractFlyToMode: UnicodeString;
begin
  Result := ChildNodes['abstractFlyToMode'].Text;
end;

procedure TXMLFlyToType.Set_AbstractFlyToMode(Value: UnicodeString);
begin
  ChildNodes['abstractFlyToMode'].NodeValue := Value;
end;

function TXMLFlyToType.Get_AbstractViewGroup: IXMLAbstractViewType;
begin
  Result := ChildNodes['AbstractViewGroup'] as IXMLAbstractViewType;
end;

function TXMLFlyToType.Get_FlyToSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FFlyToSimpleExtensionGroup;
end;

function TXMLFlyToType.Get_FlyToObjectExtensionGroup: IXMLString_List;
begin
  Result := FFlyToObjectExtensionGroup;
end;

{ TXMLPlaylistType }

procedure TXMLPlaylistType.AfterConstruction;
begin
  RegisterChildNode('AbstractTourPrimitiveGroup', TXMLAbstractTourPrimitiveType);
  FAbstractTourPrimitiveGroup := CreateCollection(TXMLAbstractTourPrimitiveTypeList, IXMLAbstractTourPrimitiveType, 'AbstractTourPrimitiveGroup') as IXMLAbstractTourPrimitiveTypeList;
  FPlaylistSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'PlaylistSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FPlaylistObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'PlaylistObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLPlaylistType.Get_AbstractTourPrimitiveGroup: IXMLAbstractTourPrimitiveTypeList;
begin
  Result := FAbstractTourPrimitiveGroup;
end;

function TXMLPlaylistType.Get_PlaylistSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FPlaylistSimpleExtensionGroup;
end;

function TXMLPlaylistType.Get_PlaylistObjectExtensionGroup: IXMLString_List;
begin
  Result := FPlaylistObjectExtensionGroup;
end;

{ TXMLSoundCueType }

procedure TXMLSoundCueType.AfterConstruction;
begin
  FSoundCueSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'SoundCueSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FSoundCueObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'SoundCueObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLSoundCueType.Get_Href: UnicodeString;
begin
  Result := ChildNodes['href'].Text;
end;

procedure TXMLSoundCueType.Set_Href(Value: UnicodeString);
begin
  ChildNodes['href'].NodeValue := Value;
end;

function TXMLSoundCueType.Get_DelayedStart: Double;
begin
  Result := ChildNodes['delayedStart'].NodeValue;
end;

procedure TXMLSoundCueType.Set_DelayedStart(Value: Double);
begin
  ChildNodes['delayedStart'].NodeValue := Value;
end;

function TXMLSoundCueType.Get_SoundCueSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FSoundCueSimpleExtensionGroup;
end;

function TXMLSoundCueType.Get_SoundCueObjectExtensionGroup: IXMLString_List;
begin
  Result := FSoundCueObjectExtensionGroup;
end;

{ TXMLTourType }

procedure TXMLTourType.AfterConstruction;
begin
  RegisterChildNode('Playlist', TXMLPlaylistType);
  FTourSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'TourSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FTourObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'TourObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLTourType.Get_Playlist: IXMLPlaylistType;
begin
  Result := ChildNodes['Playlist'] as IXMLPlaylistType;
end;

function TXMLTourType.Get_TourSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FTourSimpleExtensionGroup;
end;

function TXMLTourType.Get_TourObjectExtensionGroup: IXMLString_List;
begin
  Result := FTourObjectExtensionGroup;
end;

{ TXMLTourControlType }

procedure TXMLTourControlType.AfterConstruction;
begin
  FTourControlSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'TourControlSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FTourControlObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'TourControlObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLTourControlType.Get_AbstractPlayMode: UnicodeString;
begin
  Result := ChildNodes['abstractPlayMode'].Text;
end;

procedure TXMLTourControlType.Set_AbstractPlayMode(Value: UnicodeString);
begin
  ChildNodes['abstractPlayMode'].NodeValue := Value;
end;

function TXMLTourControlType.Get_TourControlSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FTourControlSimpleExtensionGroup;
end;

function TXMLTourControlType.Get_TourControlObjectExtensionGroup: IXMLString_List;
begin
  Result := FTourControlObjectExtensionGroup;
end;

{ TXMLWaitType }

procedure TXMLWaitType.AfterConstruction;
begin
  FWaitSimpleExtensionGroup := CreateCollection(TXMLAnySimpleTypeList, IXMLNode, 'WaitSimpleExtensionGroup') as IXMLAnySimpleTypeList;
  FWaitObjectExtensionGroup := CreateCollection(TXMLString_List, IXMLNode, 'WaitObjectExtensionGroup') as IXMLString_List;
  inherited;
end;

function TXMLWaitType.Get_Duration: Double;
begin
  Result := ChildNodes['duration'].NodeValue;
end;

procedure TXMLWaitType.Set_Duration(Value: Double);
begin
  ChildNodes['duration'].NodeValue := Value;
end;

function TXMLWaitType.Get_WaitSimpleExtensionGroup: IXMLAnySimpleTypeList;
begin
  Result := FWaitSimpleExtensionGroup;
end;

function TXMLWaitType.Get_WaitObjectExtensionGroup: IXMLString_List;
begin
  Result := FWaitObjectExtensionGroup;
end;

{ TXMLAtomEmailAddressList }

function TXMLAtomEmailAddressList.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLAtomEmailAddressList.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLAtomEmailAddressList.Get_Item(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

{ TXMLDateTimeTypeList }

function TXMLDateTimeTypeList.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLDateTimeTypeList.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLDateTimeTypeList.Get_Item(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

{ TXMLAnyTypeList }

function TXMLAnyTypeList.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLAnyTypeList.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLAnyTypeList.Get_Item(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

{ TXMLAnySimpleTypeList }

function TXMLAnySimpleTypeList.Add(const Value: Variant): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLAnySimpleTypeList.Insert(const Index: Integer; const Value: Variant): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLAnySimpleTypeList.Get_Item(Index: Integer): Variant;
begin
  Result := List[Index].NodeValue;
end;

{ TXMLString_List }

function TXMLString_List.Add(const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(-1);
  Result.NodeValue := Value;
end;

function TXMLString_List.Insert(const Index: Integer; const Value: UnicodeString): IXMLNode;
begin
  Result := AddItem(Index);
  Result.NodeValue := Value;
end;

function TXMLString_List.Get_Item(Index: Integer): UnicodeString;
begin
  Result := List[Index].NodeValue;
end;

end.
