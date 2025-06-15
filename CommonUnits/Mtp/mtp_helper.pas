unit mtp_helper;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Winapi.ActiveX, System.Win.ComObj, Vcl.ComCtrls,
  PortableDeviceApiLib_TLB, UnitMtpDevice;

// based upon:
// http://cgeers.com/2011/05/22/enumerating-windows-portable-devices/
// http://cgeers.com/2011/06/05/wpd-enumerating-content/
// http://chocotooth.blogspot.com/2011/05/controlling-digital-camera-with-delphi_10.html
// http://chocotooth.blogspot.com/2011/07/controlling-digital-camera-with-delphi.html
// https://github.com/notpod/wpd-lib/blob/master/wpd-lib/WindowsPortableDevice.cs
// http://gzune.googlecode.com/svn/trunk/zUnlock/portabledeviceconstants.cs

const
  CLIENT_NAME : WideString = 'TDbware';
  CLIENT_MAJOR_VER = 1;
  CLIENT_MINOR_VER = 0;
  CLIENT_REVISION  = 0;

const
  CLASS_PortableDeviceValues: TGUID = '{0c15d503-d017-47ce-9016-7b3f978721cc}';
  CLASS_PortableDevicePropVariantCollection: TGUID = '{08a99e2f-6d6d-4b80-af5a-baf2bcbe4cb9}';
  CLASS_PortableDeviceKeyCollection: TGUID = '{de2d022d-2480-43be-97f0-d1fa2cf98f4f}';
  CLASS_IPortableDeviceDataStream: TGUID = '{88e04db3-1012-4d64-9996-f703a950d3f4}';

const
  GUID_DEVINTERFACE_WPD : TGuid = '{6ac27878-a6fa-4155-ba85-f98f491d4f33}';
  GUID_DEVINTERFACE_WPD_PRIVATE : TGuid = '{ba0c718f-4ded-49b7-bdd3-fabe28661211}';
  GUID_DEVINTERFACE_WPD_SERVICE : TGuid = '{9ef44f80-3d64-4246-a6aa-206f328d1edc}';
  WPD_API_OPTIONS_V1 : TGuid = '{10e54a3e-052d-4777-a13c-de7614be2bc4}';
  WPD_APPOINTMENT_OBJECT_PROPERTIES_V1 : TGuid = '{f99efd03-431d-40d8-a1c9-4e220d9c88d3}';
  WPD_CATEGORY_CAPABILITIES : TGuid = '{0cabec78-6b74-41c6-9216-2639d1fce356}';
  WPD_CATEGORY_COMMON : TGuid = '{f0422a9c-5dc8-4440-b5bd-5df28835658a}';
  WPD_CATEGORY_DEVICE_HINTS : TGuid = '{0d5fb92b-cb46-4c4f-8343-0bc3d3f17c84}';
  WPD_CATEGORY_MEDIA_CAPTURE : TGuid = '{59b433ba-fe44-4d8d-808c-6bcb9b0f15e8}';
  WPD_CATEGORY_NETWORK_CONFIGURATION : TGuid = '{78f9c6fc-79b8-473c-9060-6bd23dd072c4}';
  WPD_CATEGORY_NULL : TGuid = '{00000000-0000-0000-0000-000000000000}';
  WPD_CATEGORY_OBJECT_ENUMERATION : TGuid = '{b7474e91-e7f8-4ad9-b400-ad1a4b58eeec}';
  WPD_CATEGORY_OBJECT_MANAGEMENT : TGuid = '{ef1e43dd-a9ed-4341-8bcc-186192aea089}';
  WPD_CATEGORY_OBJECT_PROPERTIES : TGuid = '{9e5582e4-0814-44e6-981a-b2998d583804}';
  WPD_CATEGORY_OBJECT_PROPERTIES_BULK : TGuid = '{11c824dd-04cd-4e4e-8c7b-f6efb794d84e}';
  WPD_CATEGORY_OBJECT_RESOURCES : TGuid = '{b3a2b22d-a595-4108-be0a-fc3c965f3d4a}';
  WPD_CATEGORY_SERVICE_CAPABILITIES : TGuid = '{24457e74-2e9f-44f9-8c57-1d1bcb170b89}';
  WPD_CATEGORY_SERVICE_COMMON : TGuid = '{322f071d-36ef-477f-b4b5-6f52d734baee}';
  WPD_CATEGORY_SERVICE_METHODS : TGuid = '{2d521ca8-c1b0-4268-a342-cf19321569bc}';
  WPD_CATEGORY_SMS : TGuid = '{afc25d66-fe0d-4114-9097-970c93e920d1}';
  WPD_CATEGORY_STILL_IMAGE_CAPTURE : TGuid = '{4fcd6982-22a2-4b05-a48b-62d38bf27b32}';
  WPD_CATEGORY_STORAGE : TGuid = '{d8f907a6-34cc-45fa-97fb-d007fa47ec94}';
  WPD_CLASS_EXTENSION_OPTIONS_V1 : TGuid = '{6309ffef-a87c-4ca7-8434-797576e40a96}';
  WPD_CLASS_EXTENSION_OPTIONS_V2 : TGuid = '{3e3595da-4d71-49fe-a0b4-d4406c3ae93f}';
  WPD_CLASS_EXTENSION_V1 : TGuid = '{33fb0d11-64a3-4fac-b4c7-3dfeaa99b051}';
  WPD_CLASS_EXTENSION_V2 : TGuid = '{7f0779b5-fa2b-4766-9cb2-f73ba30b6758}';
  WPD_CLIENT_INFORMATION_PROPERTIES_V1 : TGuid = '{204d9f0c-2292-4080-9f42-40664e70f859}';
  WPD_COMMON_INFORMATION_OBJECT_PROPERTIES_V1 : TGuid = '{b28ae94b-05a4-4e8e-be01-72cc7e099d8f}';
  WPD_PROPERTY_COMMON_COMMAND_CATEGORY : TGuid = '{4d545058-1a2e-4106-a357-771e0819fc56}';

  WPD_CONTACT_OBJECT_PROPERTIES_V1 : TGuid = '{fbd4fdab-987d-4777-b3f9-726185a9312b}';

  WPD_CONTENT_TYPE_ALL : TGuid = '{80e170d2-1055-4a3e-b952-82cc4f8a8689}';
  WPD_CONTENT_TYPE_APPOINTMENT : TGuid = '{0fed060e-8793-4b1e-90c9-48ac389ac631}';
  WPD_CONTENT_TYPE_AUDIO : TGuid = '{4ad2c85e-5e2d-45e5-8864-4f229e3c6cf0}';
  WPD_CONTENT_TYPE_AUDIO_ALBUM : TGuid = '{aa18737e-5009-48fa-ae21-85f24383b4e6}';
  WPD_CONTENT_TYPE_CALENDAR : TGuid = '{a1fd5967-6023-49a0-9df1-f8060be751b0}';
  WPD_CONTENT_TYPE_CERTIFICATE : TGuid = '{dc3876e8-a948-4060-9050-cbd77e8a3d87}';
  WPD_CONTENT_TYPE_CONTACT : TGuid = '{eaba8313-4525-4707-9f0e-87c6808e9435}';
  WPD_CONTENT_TYPE_CONTACT_GROUP : TGuid = '{346b8932-4c36-40d8-9415-1828291f9de9}';
  WPD_CONTENT_TYPE_DOCUMENT : TGuid = '{680adf52-950a-4041-9b41-65e393648155}';
  WPD_CONTENT_TYPE_EMAIL : TGuid = '{8038044a-7e51-4f8f-883d-1d0623d14533}';
  WPD_CONTENT_TYPE_FUNCTIONAL_OBJECT : TGuid = '{99ed0160-17ff-4c44-9d98-1d7a6f941921}';
  WPD_CONTENT_TYPE_GENERIC_FILE : TGuid = '{0085e0a6-8d34-45d7-bc5c-447e59c73d48}';
  WPD_CONTENT_TYPE_GENERIC_MESSAGE : TGuid = '{e80eaaf8-b2db-4133-b67e-1bef4b4a6e5f}';
  WPD_CONTENT_TYPE_IMAGE : TGuid = '{ef2107d5-a52a-4243-a26b-62d4176d7603}';
  WPD_CONTENT_TYPE_IMAGE_ALBUM : TGuid = '{75793148-15f5-4a30-a813-54ed8a37e226}';
  WPD_CONTENT_TYPE_MEDIA_CAST : TGuid = '{5e88b3cc-3e65-4e62-bfff-229495253ab0}';
  WPD_CONTENT_TYPE_MEMO : TGuid = '{9cd20ecf-3b50-414f-a641-e473ffe45751}';
  WPD_CONTENT_TYPE_MIXED_CONTENT_ALBUM : TGuid = '{00f0c3ac-a593-49ac-9219-24abca5a2563}';
  WPD_CONTENT_TYPE_NETWORK_ASSOCIATION : TGuid = '{031da7ee-18c8-4205-847e-89a11261d0f3}';
  WPD_CONTENT_TYPE_PLAYLIST : TGuid = '{1a33f7e4-af13-48f5-994e-77369dfe04a3}';
  WPD_CONTENT_TYPE_PROGRAM : TGuid = '{d269f96a-247c-4bff-98fb-97f3c49220e6}';
  WPD_CONTENT_TYPE_SECTION : TGuid = '{821089f5-1d91-4dc9-be3c-bbb1b35b18ce}';
  WPD_CONTENT_TYPE_TASK : TGuid = '{63252f2c-887f-4cb6-b1ac-d29855dcef6c}';
  WPD_CONTENT_TYPE_TELEVISION : TGuid = '{60a169cf-f2ae-4e21-9375-9677f11c1c6e}';
  WPD_CONTENT_TYPE_UNSPECIFIED : TGuid = '{28d8d31e-249c-454e-aabc-34883168e634}';
  WPD_CONTENT_TYPE_VIDEO : TGuid = '{9261b03c-3d78-4519-85e3-02c5e1f50bb9}';
  WPD_CONTENT_TYPE_VIDEO_ALBUM : TGuid = '{012b0db7-d4c1-45d6-b081-94b87779614f}';
  WPD_CONTENT_TYPE_WIRELESS_PROFILE : TGuid = '{0bac070a-9f5f-4da4-a8f6-3de44d68fd6c}';
  WPD_CONTENT_TYPE_FOLDER : TGuid = '{27E2E392-A111-48E0-AB0C-E17705A05F85}';
  WPD_DEVICE_PROPERTIES_V1 : TGuid = '{26d4979a-e643-4626-9e2b-736dc0c92fdc}';
  WPD_DEVICE_PROPERTIES_V2 : TGuid = '{463dd662-7fc4-4291-911c-7f4c9cca9799}';
  WPD_DOCUMENT_OBJECT_PROPERTIES_V1 : TGuid = '{0b110203-eb95-4f02-93e0-97c631493ad5}';
  WPD_EMAIL_OBJECT_PROPERTIES_V1 : TGuid = '{41f8f65a-5484-4782-b13d-4740dd7c37c5}';
  WPD_EVENT_ATTRIBUTES_V1 : TGuid = '{10c96578-2e81-4111-adde-e08ca6138f6d}';
  WPD_EVENT_DEVICE_CAPABILITIES_UPDATED : TGuid = '{36885aa1-cd54-4daa-b3d0-afb3e03f5999}';
  WPD_EVENT_DEVICE_REMOVED : TGuid = '{e4cbca1b-6918-48b9-85ee-02be7c850af9}';
  WPD_EVENT_DEVICE_RESET : TGuid = '{7755cf53-c1ed-44f3-b5a2-451e2c376b27}';
  WPD_EVENT_OBJECT_ADDED : TGuid = '{a726da95-e207-4b02-8d44-bef2e86cbffc}';
  WPD_EVENT_OBJECT_REMOVED : TGuid = '{be82ab88-a52c-4823-96e5-d0272671fc38}';
  WPD_EVENT_OBJECT_TRANSFER_REQUESTED : TGuid = '{8d16a0a1-f2c6-41da-8f19-5e53721adbf2}';
  WPD_EVENT_OBJECT_UPDATED : TGuid = '{1445a759-2e01-485d-9f27-ff07dae697ab}';
  WPD_EVENT_OPTIONS_V1 : TGuid = '{b3d8dad7-a361-4b83-8a48-5b02ce10713b}';
  WPD_EVENT_PROPERTIES_V1 : TGuid = '{15ab1953-f817-4fef-a921-5676e838f6e0}';
  WPD_EVENT_PROPERTIES_V2 : TGuid = '{52807b8a-4914-4323-9b9a-74f654b2b846}';
  WPD_EVENT_SERVICE_METHOD_COMPLETE : TGuid = '{8a33f5f8-0acc-4d9b-9cc4-112d353b86ca}';
  WPD_EVENT_STORAGE_FORMAT : TGuid = '{3782616b-22bc-4474-a251-3070f8d38857}';
  WPD_FOLDER_OBJECT_PROPERTIES_V1 : TGuid = '{7e9a7abf-e568-4b34-aa2f-13bb12ab177d}';
  WPD_FORMAT_ATTRIBUTES_V1 : TGuid = '{a0a02000-bcaf-4be8-b3f5-233f231cf58f}';
  WPD_FUNCTIONAL_CATEGORY_ALL : TGuid = '{2d8a6512-a74c-448e-ba8a-f4ac07c49399}';
  WPD_FUNCTIONAL_CATEGORY_AUDIO_CAPTURE : TGuid = '{3f2a1919-c7c2-4a00-855d-f57cf06debbb}';
  WPD_FUNCTIONAL_CATEGORY_DEVICE : TGuid = '{08ea466b-e3a4-4336-a1f3-a44d2b5c438c}';
  WPD_FUNCTIONAL_CATEGORY_NETWORK_CONFIGURATION : TGuid = '{48f4db72-7c6a-4ab0-9e1a-470e3cdbf26a}';
  WPD_FUNCTIONAL_CATEGORY_RENDERING_INFORMATION : TGuid = '{08600ba4-a7ba-4a01-ab0e-0065d0a356d3}';
  WPD_FUNCTIONAL_CATEGORY_SMS : TGuid = '{0044a0b1-c1e9-4afd-b358-a62c6117c9cf}';
  WPD_FUNCTIONAL_CATEGORY_STILL_IMAGE_CAPTURE : TGuid = '{613ca327-ab93-4900-b4fa-895bb5874b79}';
  WPD_FUNCTIONAL_CATEGORY_STORAGE : TGuid = '{23f05bbc-15de-4c2a-a55b-a9af5ce412ef}';
  WPD_FUNCTIONAL_CATEGORY_VIDEO_CAPTURE : TGuid = '{e23e5f6b-7243-43aa-8df1-0eb3d968a918}';
  WPD_FUNCTIONAL_OBJECT_PROPERTIES_V1 : TGuid = '{8f052d93-abca-4fc5-a5ac-b01df4dbe598}';
  WPD_IMAGE_OBJECT_PROPERTIES_V1 : TGuid = '{63d64908-9fa1-479f-85ba-9952216447db}';
  WPD_MEDIA_PROPERTIES_V1 : TGuid = '{2ed8ba05-0ad3-42dc-b0d0-bc95ac396ac8}';
  WPD_MEMO_OBJECT_PROPERTIES_V1 : TGuid = '{5ffbfc7b-7483-41ad-afb9-da3f4e592b8d}';
  WPD_METHOD_ATTRIBUTES_V1 : TGuid = '{f17a5071-f039-44af-8efe-432cf32e432a}';
  WPD_MUSIC_OBJECT_PROPERTIES_V1 : TGuid = '{b324f56a-dc5d-46e5-b6df-d2ea414888c6}';
  WPD_NETWORK_ASSOCIATION_PROPERTIES_V1 : TGuid = '{e4c93c1f-b203-43f1-a100-5a07d11b0274}';
  WPD_OBJECT_FORMAT_3GP : TGuid = '{b9840000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_AAC : TGuid = '{b9030000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_ABSTRACT_CONTACT : TGuid = '{bb810000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_ABSTRACT_CONTACT_GROUP : TGuid = '{ba060000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_ABSTRACT_MEDIA_CAST : TGuid = '{ba0b0000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_AIFF : TGuid = '{30070000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_ALL : TGuid = '{c1f62eb2-4bb3-479c-9cfa-05b5f3a57b22}';
  WPD_OBJECT_FORMAT_ASF : TGuid = '{300c0000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_ASXPLAYLIST : TGuid = '{ba130000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_AUDIBLE : TGuid = '{b9040000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_AVI : TGuid = '{300a0000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_BMP : TGuid = '{38040000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_CIFF : TGuid = '{38050000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_DPOF : TGuid = '{30060000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_EXECUTABLE : TGuid = '{30030000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_EXIF : TGuid = '{38010000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_FLAC : TGuid = '{b9060000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_FLASHPIX : TGuid = '{38030000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_GIF : TGuid = '{38070000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_HTML : TGuid = '{30050000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_ICALENDAR : TGuid = '{be030000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_ICON : TGuid = '{077232ed-102c-4638-9c22-83f142bfc822}';
  WPD_OBJECT_FORMAT_JFIF : TGuid = '{38080000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_JP2 : TGuid = '{380f0000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_JPX : TGuid = '{38100000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_M3UPLAYLIST : TGuid = '{ba110000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_M4A : TGuid = '{30aba7ac-6ffd-4c23-a359-3e9b52f3f1c8}';
  WPD_OBJECT_FORMAT_MHT_COMPILED_HTML : TGuid = '{ba840000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_MICROSOFT_EXCEL : TGuid = '{ba850000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_MICROSOFT_POWERPOINT : TGuid = '{ba860000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_MICROSOFT_WFC : TGuid = '{b1040000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_MICROSOFT_WORD : TGuid = '{ba830000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_MP2 : TGuid = '{b9830000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_MP3 : TGuid = '{30090000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_MP4 : TGuid = '{b9820000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_MPEG : TGuid = '{300b0000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_MPLPLAYLIST : TGuid = '{ba120000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_NETWORK_ASSOCIATION : TGuid = '{b1020000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_OGG : TGuid = '{b9020000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_PCD : TGuid = '{38090000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_PICT : TGuid = '{380a0000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_PLSPLAYLIST : TGuid = '{ba140000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_PNG : TGuid = '{380b0000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_PROPERTIES_ONLY : TGuid = '{30010000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_SCRIPT : TGuid = '{30020000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_TEXT : TGuid = '{30040000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_TIFF : TGuid = '{380d0000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_TIFFEP : TGuid = '{38020000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_TIFFIT : TGuid = '{380e0000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_UNSPECIFIED : TGuid = '{30000000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_VCALENDAR1 : TGuid = '{be020000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_VCARD2 : TGuid = '{bb820000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_VCARD3 : TGuid = '{bb830000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_WAVE : TGuid = '{30080000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_WINDOWSIMAGEFORMAT : TGuid = '{b8810000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_WMA : TGuid = '{b9010000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_WMV : TGuid = '{b9810000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_WPLPLAYLIST : TGuid = '{ba100000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_X509V3CERTIFICATE : TGuid = '{b1030000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_FORMAT_XML : TGuid = '{ba820000-ae6c-4804-98ba-c57b46965fe7}';
  WPD_OBJECT_PROPERTIES_V1 : TGuid = '{ef6b490d-5cd8-437a-affc-da8b60ee4a3c}';
  WPD_PARAMETER_ATTRIBUTES_V1 : TGuid = '{e6864dd7-f325-45ea-a1d5-97cf73b6ca58}';
  WPD_PROPERTY_ATTRIBUTES_V1 : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTES_V2 : TGuid = '{5d9da160-74ae-43cc-85a9-fe555a80798e}';
  WPD_RENDERING_INFORMATION_OBJECT_PROPERTIES_V1 : TGuid = '{c53d039f-ee23-4a31-8590-7639879870b4}';
  WPD_RESOURCE_ATTRIBUTES_V1 : TGuid = '{1eb6f604-9278-429f-93cc-5bb8c06656b6}';
  WPD_SECTION_OBJECT_PROPERTIES_V1 : TGuid = '{516afd2b-c64e-44f0-98dc-bee1c88f7d66}';
  WPD_SERVICE_PROPERTIES_V1 : TGuid = '{7510698a-cb54-481c-b8db-0d75c93f1c06}';
  WPD_SMS_OBJECT_PROPERTIES_V1 : TGuid = '{7e1074cc-50ff-4dd1-a742-53be6f093a0d}';
  WPD_STILL_IMAGE_CAPTURE_OBJECT_PROPERTIES_V1 : TGuid = '{58c571ec-1bcb-42a7-8ac5-bb291573a260}';
  WPD_STORAGE_OBJECT_PROPERTIES_V1 : TGuid = '{01a3057a-74d6-4e80-bea7-dc4c212ce50a}';
  WPD_TASK_OBJECT_PROPERTIES_V1 : TGuid = '{e354e95e-d8a0-4637-a03a-0cb26838dbc7}';
  WPD_VIDEO_OBJECT_PROPERTIES_V1 : TGuid = '{346f2163-f998-4146-8b01-d19b4c00de9a}';

  WPD_OBJECT_CONTENT_TYPE : PortableDeviceApiLib_TLB._tagpropertykey = (fmtid : '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}'; pid : 7);

  WPD_PROPERTY_NULL_FMTID : TGuid = '{00000000-0000-0000-0000-000000000000}';
  WPD_PROPERTY_NULL_PID = 0;

  WPD_OBJECT_ID_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_ID_PID = 2;

  WPD_OBJECT_PARENT_ID_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_PARENT_ID_PID = 3;

  WPD_OBJECT_NAME_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_NAME_PID = 4;

  WPD_OBJECT_PERSISTENT_UNIQUE_ID_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_PERSISTENT_UNIQUE_ID_PID = 5;

  WPD_OBJECT_FORMAT_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_FORMAT_PID = 6;

  WPD_OBJECT_CONTENT_TYPE_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_CONTENT_TYPE_PID = 7;

  WPD_OBJECT_ISHIDDEN_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_ISHIDDEN_PID = 9;

  WPD_OBJECT_ISSYSTEM_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_ISSYSTEM_PID = 10;

  WPD_OBJECT_SIZE_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_SIZE_PID = 11;

  WPD_OBJECT_ORIGINAL_FILE_NAME_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_ORIGINAL_FILE_NAME_PID = 12;

  WPD_OBJECT_NON_CONSUMABLE_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_NON_CONSUMABLE_PID = 13;

  WPD_OBJECT_REFERENCES_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_REFERENCES_PID = 14;

  WPD_OBJECT_KEYWORDS_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_KEYWORDS_PID = 15;

  WPD_OBJECT_SYNC_ID_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_SYNC_ID_PID = 16;

  WPD_OBJECT_IS_DRM_PROTECTED_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_IS_DRM_PROTECTED_PID = 17;

  WPD_OBJECT_DATE_CREATED_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_DATE_CREATED_PID = 18;

  WPD_OBJECT_DATE_MODIFIED_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_DATE_MODIFIED_PID = 19;

  WPD_OBJECT_DATE_AUTHORED_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_DATE_AUTHORED_PID = 20;

  WPD_OBJECT_BACK_REFERENCES_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_BACK_REFERENCES_PID = 21;

  WPD_OBJECT_CONTAINER_FUNCTIONAL_OBJECT_ID_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_CONTAINER_FUNCTIONAL_OBJECT_ID_PID = 23;

  WPD_OBJECT_GENERATE_THUMBNAIL_FROM_RESOURCE_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_GENERATE_THUMBNAIL_FROM_RESOURCE_PID = 24;

  WPD_OBJECT_HINT_LOCATION_DISPLAY_NAME_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_HINT_LOCATION_DISPLAY_NAME_PID = 25;

  WPD_OBJECT_CAN_DELETE_FMTID : TGuid = '{EF6B490D-5CD8-437A-AFFC-DA8B60EE4A3C}';
  WPD_OBJECT_CAN_DELETE_PID = 26;


  WPD_CLIENT_NAME_FMTID : TGuid = '{204D9F0C-2292-4080-9F42-40664E70F859}';
  WPD_CLIENT_NAME_PID = 2;

  WPD_CLIENT_MAJOR_VERSION_FMTID : TGuid = '{204D9F0C-2292-4080-9F42-40664E70F859}';
  WPD_CLIENT_MAJOR_VERSION_PID = 3;

  WPD_CLIENT_MINOR_VERSION_FMTID : TGuid = '{204D9F0C-2292-4080-9F42-40664E70F859}';
  WPD_CLIENT_MINOR_VERSION_PID = 4;

  WPD_CLIENT_REVISION_FMTID : TGuid = '{204D9F0C-2292-4080-9F42-40664E70F859}';
  WPD_CLIENT_REVISION_PID = 5;

  WPD_CLIENT_DESIRED_ACCESS_FMTID : TGuid = '{204D9F0C-2292-4080-9F42-40664E70F859}';
  WPD_CLIENT_DESIRED_ACCESS_PID = 9;

  WPD_DEVICE_FRIENDLY_NAME_FMTID : TGuid = '{26D4979A-E643-4626-9E2B-736DC0C92FDC}';
  WPD_DEVICE_FRIENDLY_NAME_PID = 12;

  WPD_RESOURCE_DEFAULT_FMTID : TGuid = '{E81E79BE-34F0-41BF-B53F-F1A06AE87842}';
  WPD_RESOURCE_DEFAULT_PID = 0;

  WPD_PROPERTY_ATTRIBUTE_FORM_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_FORM_PID = 2;

  WPD_PROPERTY_ATTRIBUTE_CAN_READ_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_CAN_READ_PID = 3;

  WPD_PROPERTY_ATTRIBUTE_CAN_WRITE_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_CAN_WRITE_PID = 4;

  WPD_PROPERTY_ATTRIBUTE_CAN_DELETE_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_CAN_DELETE_PID = 5;

  WPD_PROPERTY_ATTRIBUTE_DEFAULT_VALUE_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_DEFAULT_VALUE_PID = 6;

  WPD_PROPERTY_ATTRIBUTE_FAST_PROPERTY_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_FAST_PROPERTY_PID = 7;

  WPD_PROPERTY_ATTRIBUTE_RANGE_MIN_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_RANGE_MIN_PID = 8;

  WPD_PROPERTY_ATTRIBUTE_RANGE_MAX_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_RANGE_MAX_PID = 9;

  WPD_PROPERTY_ATTRIBUTE_RANGE_STEP_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_RANGE_STEP_PID = 10;

  WPD_PROPERTY_ATTRIBUTE_ENUMERATION_ELEMENTS_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_ENUMERATION_ELEMENTS_PID = 11;

  WPD_PROPERTY_ATTRIBUTE_REGULAR_EXPRESSION_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_REGULAR_EXPRESSION_PID = 12;

  WPD_PROPERTY_ATTRIBUTE_MAX_SIZE_FMTID : TGuid = '{ab7943d8-6332-445f-a00d-8d5ef1e96f37}';
  WPD_PROPERTY_ATTRIBUTE_MAX_SIZE_PID = 13;

  WPD_DEVICE_OBJECT_ID = 'DEVICE';

function FirstStorageIDs(PortableDev: IMTPDevice; DeviceRoot: string = WPD_DEVICE_OBJECT_ID): IEnumPortableDeviceObjectIDs;
function GetFirstStorageID(PortableDev: IMTPDevice): WideString;
function ReadFilesFromDevice(PortableDev: IMTPDevice;
                             Lst: TListItems;
                             SParent: WideString;
                             var CompletePath: WideString): PWideChar;
function GetIdForPath(PortableDev: IMTPDevice;
                      SPath: WideString;
                      var FriendlyPath: string): string;
function GetIdForFile(PortableDev: IMTPDevice;
                      SPath: WideString;
                      SFile: WideString;
                      AListItem: TListItem = nil): string;
function GetFileFromDevice(PortableDev: IMTPDevice; SFile, SSaveTo, NFile: WideString): Boolean;
function DelFileFromDevice(PortableDev: IMTPDevice; SFile: WideString): Boolean;
function RenameObject(PortableDev: IMTPDevice; ObjectId, NewName: WideString): Boolean;
function TransferNewFileToDevice(PortableDev: IMTPDevice; SFile, SSaveTo: WideString;
                                 NewName: WideString = ''): WideString;
function TransferExistingFileToDevice(PortableDev: IMTPDevice; SFile, SSaveTo: WideString; AListItem: TListItem): Boolean;
function GetDevices: TList;
function ConnectToDevice(SDev: WideString; var PortableDev: IMTPDevice; Readonly: boolean = true): Boolean;

implementation

uses
  System.Math, System.DateUtils, UnitStringUtils;

// For documentation purposes only
function DisplayFunctionalCategory(Cat_Id: WideString): String;
var G: TGuid;
begin
  Result := Cat_Id;
  if Cat_Id='' then
     Exit;

  try
    G := StringToGUID(Cat_Id);

    if IsEqualGUID(WPD_FUNCTIONAL_CATEGORY_ALL, G) then Result := 'WPD_FUNCTIONAL_CATEGORY_ALL'
    else if IsEqualGUID(WPD_FUNCTIONAL_CATEGORY_AUDIO_CAPTURE, G) then Result := 'WPD_FUNCTIONAL_CATEGORY_AUDIO_CAPTURE'
    else if IsEqualGUID(WPD_FUNCTIONAL_CATEGORY_DEVICE, G) then Result := 'WPD_FUNCTIONAL_CATEGORY_DEVICE'
    else if IsEqualGUID(WPD_FUNCTIONAL_CATEGORY_NETWORK_CONFIGURATION, G) then Result := 'WPD_FUNCTIONAL_CATEGORY_NETWORK_CONFIGURATION'
    else if IsEqualGUID(WPD_FUNCTIONAL_CATEGORY_RENDERING_INFORMATION, G) then Result := 'WPD_FUNCTIONAL_CATEGORY_RENDERING_INFORMATION'
    else if IsEqualGUID(WPD_FUNCTIONAL_CATEGORY_SMS, G) then Result := 'WPD_FUNCTIONAL_CATEGORY_SMS'
    else if IsEqualGUID(WPD_FUNCTIONAL_CATEGORY_STILL_IMAGE_CAPTURE, G) then Result := 'WPD_FUNCTIONAL_CATEGORY_STILL_IMAGE_CAPTURE'
    else if IsEqualGUID(WPD_FUNCTIONAL_CATEGORY_STORAGE, G) then Result := 'WPD_FUNCTIONAL_CATEGORY_STORAGE'
    else if IsEqualGUID(WPD_FUNCTIONAL_CATEGORY_VIDEO_CAPTURE, G) then Result := 'WPD_FUNCTIONAL_CATEGORY_VIDEO_CAPTURE';
  except
  end;
end;

function DisplayContentType(Content_Id: WideString): String;
var G: TGuid;
begin
  Result := Content_Id;
  if Content_Id='' then
    Exit;

  try
    G := StringToGUID(Content_Id);

    if IsEqualGUID(WPD_CONTENT_TYPE_ALL, G) then Result := 'WPD_CONTENT_TYPE_ALL'
    else if IsEqualGUID(WPD_CONTENT_TYPE_APPOINTMENT, G) then Result := 'WPD_CONTENT_TYPE_APPOINTMENT'
    else if IsEqualGUID(WPD_CONTENT_TYPE_AUDIO, G) then Result := 'WPD_CONTENT_TYPE_AUDIO'
    else if IsEqualGUID(WPD_CONTENT_TYPE_AUDIO_ALBUM, G) then Result := 'WPD_CONTENT_TYPE_AUDIO_ALBUM'
    else if IsEqualGUID(WPD_CONTENT_TYPE_CALENDAR, G) then Result := 'WPD_CONTENT_TYPE_CALENDAR'
    else if IsEqualGUID(WPD_CONTENT_TYPE_CERTIFICATE, G) then Result := 'WPD_CONTENT_TYPE_CERTIFICATE'
    else if IsEqualGUID(WPD_CONTENT_TYPE_CONTACT, G) then Result := 'WPD_CONTENT_TYPE_CONTACT'
    else if IsEqualGUID(WPD_CONTENT_TYPE_CONTACT_GROUP, G) then Result := 'WPD_CONTENT_TYPE_CONTACT_GROUP'
    else if IsEqualGUID(WPD_CONTENT_TYPE_DOCUMENT, G) then Result := 'WPD_CONTENT_TYPE_DOCUMENT'
    else if IsEqualGUID(WPD_CONTENT_TYPE_EMAIL, G) then Result := 'WPD_CONTENT_TYPE_EMAIL'
    else if IsEqualGUID(WPD_CONTENT_TYPE_FUNCTIONAL_OBJECT, G) then Result := 'WPD_CONTENT_TYPE_FUNCTIONAL_OBJECT'
    else if IsEqualGUID(WPD_CONTENT_TYPE_GENERIC_FILE, G) then Result := 'WPD_CONTENT_TYPE_GENERIC_FILE'
    else if IsEqualGUID(WPD_CONTENT_TYPE_GENERIC_MESSAGE, G) then Result := 'WPD_CONTENT_TYPE_GENERIC_MESSAGE'
    else if IsEqualGUID(WPD_CONTENT_TYPE_IMAGE, G) then Result := 'WPD_CONTENT_TYPE_IMAGE'
    else if IsEqualGUID(WPD_CONTENT_TYPE_IMAGE_ALBUM, G) then Result := 'WPD_CONTENT_TYPE_IMAGE_ALBUM'
    else if IsEqualGUID(WPD_CONTENT_TYPE_MEDIA_CAST, G) then Result := 'WPD_CONTENT_TYPE_MEDIA_CAST'
    else if IsEqualGUID(WPD_CONTENT_TYPE_MEMO, G) then Result := 'WPD_CONTENT_TYPE_MEMO'
    else if IsEqualGUID(WPD_CONTENT_TYPE_MIXED_CONTENT_ALBUM, G) then Result := 'WPD_CONTENT_TYPE_MIXED_CONTENT_ALBUM'
    else if IsEqualGUID(WPD_CONTENT_TYPE_NETWORK_ASSOCIATION, G) then Result := 'WPD_CONTENT_TYPE_NETWORK_ASSOCIATION'
    else if IsEqualGUID(WPD_CONTENT_TYPE_PLAYLIST, G) then Result := 'WPD_CONTENT_TYPE_PLAYLIST'
    else if IsEqualGUID(WPD_CONTENT_TYPE_PROGRAM, G) then Result := 'WPD_CONTENT_TYPE_PROGRAM'
    else if IsEqualGUID(WPD_CONTENT_TYPE_SECTION, G) then Result := 'WPD_CONTENT_TYPE_SECTION'
    else if IsEqualGUID(WPD_CONTENT_TYPE_TASK, G) then Result := 'WPD_CONTENT_TYPE_TASK'
    else if IsEqualGUID(WPD_CONTENT_TYPE_TELEVISION, G) then Result := 'WPD_CONTENT_TYPE_TELEVISION'
    else if IsEqualGUID(WPD_CONTENT_TYPE_UNSPECIFIED, G) then Result := 'WPD_CONTENT_TYPE_UNSPECIFIED'
    else if IsEqualGUID(WPD_CONTENT_TYPE_VIDEO, G) then Result := 'WPD_CONTENT_TYPE_VIDEO'
    else if IsEqualGUID(WPD_CONTENT_TYPE_VIDEO_ALBUM, G) then Result := 'WPD_CONTENT_TYPE_VIDEO_ALBUM'
    else if IsEqualGUID(WPD_CONTENT_TYPE_WIRELESS_PROFILE, G) then Result := 'WPD_CONTENT_TYPE_WIRELESS_PROFILE'
    else if IsEqualGUID(WPD_CONTENT_TYPE_FOLDER, G) then Result := 'WPD_CONTENT_TYPE_FOLDER'
    ;
  except
  end;
end;

function DisplaySupportedCommand(G: TGuid): String;
begin
  Result := GUIDToString(G);

  try
    if IsEqualGUID(WPD_CATEGORY_COMMON, G) then Result := 'WPD_CATEGORY_COMMON'
    else if IsEqualGUID(WPD_CATEGORY_CAPABILITIES, G) then Result := 'WPD_CATEGORY_CAPABILITIES'
    else if IsEqualGUID(WPD_CATEGORY_DEVICE_HINTS, G) then Result := 'WPD_CATEGORY_DEVICE_HINTS'
    else if IsEqualGUID(WPD_CATEGORY_MEDIA_CAPTURE, G) then Result := 'WPD_CATEGORY_MEDIA_CAPTURE'
    else if IsEqualGUID(WPD_CATEGORY_NETWORK_CONFIGURATION, G) then Result := 'WPD_CATEGORY_NETWORK_CONFIGURATION'
    else if IsEqualGUID(WPD_CATEGORY_NULL, G) then Result := 'WPD_CATEGORY_NULL'
    else if IsEqualGUID(WPD_CATEGORY_OBJECT_ENUMERATION, G) then Result := 'WPD_CATEGORY_OBJECT_ENUMERATION'
    else if IsEqualGUID(WPD_CATEGORY_OBJECT_MANAGEMENT, G) then Result := 'WPD_CATEGORY_OBJECT_MANAGEMENT'
    else if IsEqualGUID(WPD_CATEGORY_OBJECT_PROPERTIES, G) then Result := 'WPD_CATEGORY_OBJECT_PROPERTIES'
    else if IsEqualGUID(WPD_CATEGORY_OBJECT_PROPERTIES_BULK, G) then Result := 'WPD_CATEGORY_OBJECT_PROPERTIES_BULK'
    else if IsEqualGUID(WPD_CATEGORY_OBJECT_RESOURCES, G) then Result := 'WPD_CATEGORY_OBJECT_RESOURCES'
    else if IsEqualGUID(WPD_CATEGORY_SERVICE_CAPABILITIES, G) then Result := 'WPD_CATEGORY_SERVICE_CAPABILITIES'
    else if IsEqualGUID(WPD_CATEGORY_SERVICE_COMMON, G) then Result := 'WPD_CATEGORY_SERVICE_COMMON'
    else if IsEqualGUID(WPD_CATEGORY_SERVICE_METHODS, G) then Result := 'WPD_CATEGORY_SERVICE_METHODS'
    else if IsEqualGUID(WPD_CATEGORY_SMS, G) then Result := 'WPD_CATEGORY_SMS'
    else if IsEqualGUID(WPD_CATEGORY_STILL_IMAGE_CAPTURE, G) then Result := 'WPD_CATEGORY_STILL_IMAGE_CAPTURE'
    else if IsEqualGUID(WPD_CATEGORY_STORAGE, G) then Result := 'WPD_CATEGORY_STORAGE'
    ;
  except
  end;
end;

//https://learn.microsoft.com/en-us/windows/win32/wpd_sdk/setting-properties-for-a-single-object
// Notes: if 'NewName' already exists, no error is thrown.
//        For the Zumo XT it is enough to just modify original name. For other device we may need object_name also.
const BoolFalse = 0;

function RenameObject(PortableDev: IMTPDevice; ObjectId, NewName: WideString): boolean;
var Content: IPortableDeviceContent;
    Properties: IPortableDeviceProperties;
    Attributes: IPortableDeviceValues;
    Results: IPortableDeviceValues;
    ObjectPropertiesToWrite: IPortableDeviceValues;
    CanWrite: integer;
    Hr: HResult;

// In PortableDeviceApiLib_TLB some methods have 'var', and thus require a variable.
    ObjectOriginalNameKey: PortableDeviceApiLib_TLB._tagpropertykey;
    CanWriteKey: PortableDeviceApiLib_TLB._tagpropertykey;

begin
  result := false;
  Hr := PortableDev.Content(Content);
  if (Hr <> S_OK) then
    exit;

  Hr := Content.Properties(Properties);
  if (Hr <> S_OK) then
    exit;

// Can we write Original name?
  ObjectOriginalNameKey.fmtid := WPD_OBJECT_ORIGINAL_FILE_NAME_FMTID;
  ObjectOriginalNameKey.pid := WPD_OBJECT_ORIGINAL_FILE_NAME_PID;
  Hr := Properties.GetPropertyAttributes(PwideChar(ObjectId), ObjectOriginalNameKey, Attributes);
  if (Hr <> S_OK) then
    exit;

  CanWriteKey.fmtid := WPD_PROPERTY_ATTRIBUTE_CAN_WRITE_FMTID;
  CanWriteKey.pid := WPD_PROPERTY_ATTRIBUTE_CAN_WRITE_PID;
  Hr := Attributes.GetBoolValue(CanWriteKey, CanWrite);
  if (Hr <> S_OK) or
     (CanWrite = BoolFalse) then
    exit;

// Yes, can modify original name.
  ObjectPropertiesToWrite := CreateComObject(CLASS_PortableDeviceValues) as IPortableDeviceValues;
  Hr := ObjectPropertiesToWrite.SetStringValue(ObjectOriginalNameKey, PWideChar(NewName));
  if (HR <> S_OK) then
    exit;

// Change Original name.
  Hr := Properties.SetValues(PWideChar(ObjectId),
                             ObjectPropertiesToWrite,
                             Results);
  result := (Hr = S_OK);
end;

function GetDevId(RawDevice:string):widestring;
begin
  Result := RawDevice;
  Result := Trim(Copy(Result, Pos(widestring('\\?'), Result), Length(Result)));
end;

function IsDirectory(Prop_Val: IPortableDeviceValues): Boolean;
var Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
    Prop_Guid: TGUID;
begin
  Result := False;

  if VarIsClear(Prop_Val) then
    exit;

  Dev_Val.fmtid := WPD_OBJECT_CONTENT_TYPE_FMTID;
  Dev_Val.pid := WPD_OBJECT_CONTENT_TYPE_PID;
  if Prop_Val.GetGuidValue(Dev_Val, Prop_Guid) <> S_OK then
    exit;

  if IsEqualGUID(Prop_Guid, WPD_CONTENT_TYPE_FOLDER) or
    IsEqualGUID(Prop_Guid, WPD_CONTENT_TYPE_FUNCTIONAL_OBJECT) then
    Result := True;
end;

procedure PropVariantToString(PropVarValue: Tag_Inner_PROPVARIANT; var SVal: WideString);
var PValues: IPortableDeviceValues;
  Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
  Hr: HResult;
  PVal: PWideChar;
begin
  SVal := '';
  PValues :=  CreateComObject(CLASS_PortableDeviceValues) as IPortableDeviceValues;
  if VarIsClear(PValues) then
     Exit;

  // PROPVARIANT into IPortableDeviceValues object
  Dev_Val.fmtid := WPD_OBJECT_ID_FMTID;
  Dev_Val.pid := WPD_OBJECT_ID_PID;
  PValues.SetValue(Dev_Val, PropVarValue);

  //check if it is error code
  if PropVarValue.vt = VT_ERROR then
  begin
    PValues.GetErrorValue(Dev_Val, Hr);
    SVal := SysErrorMessage(Hr);
    exit;
  end;

  // get back string
  PValues.GetStringValue(Dev_Val, PVal);
  SVal := PVal;
end;

procedure DateToPropVar(DateTime: TDateTime; var PropVarValue:Tag_Inner_PROPVARIANT);
begin
  FillChar(PropVarValue, sizeof(PropVarValue), 0);
  PropVarValue.vt := 7;
{$IFDEF USE_WINAPI_PROPVARIANT}
  PropVarValue.date := DateTime;
{$ELSE}
  PropVarValue.__MIDL____MIDL_itf_PortableDeviceApi_0001_00000001.date := DateTime;
{$ENDIF}
end;

function PropVarToDate(PropVarValue:Tag_Inner_PROPVARIANT): TDateTime;
begin
{$IFDEF USE_WINAPI_PROPVARIANT}
  result := PropVarValue.date;
{$ELSE}
  result := PropVarValue.__MIDL____MIDL_itf_PortableDeviceApi_0001_00000001.date
{$ENDIF}
end;

function PropValToName(Prop_Val: IPortableDeviceValues): PWideChar;
var Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
    Hr: Hresult;
begin
  Hr := S_False;
  if (IsDirectory(Prop_Val)) then
  begin
    Dev_Val.fmtid := WPD_OBJECT_NAME_FMTID;
    Dev_Val.pid := WPD_OBJECT_NAME_PID;
    Hr := Prop_Val.GetStringValue(Dev_Val, result);
  end;
  if (Hr <> S_OK) then
  begin
    // Get the (original) name of the object
    Dev_Val.fmtid := WPD_OBJECT_ORIGINAL_FILE_NAME_FMTID;
    Dev_Val.pid := WPD_OBJECT_ORIGINAL_FILE_NAME_PID;
    Hr := Prop_Val.GetStringValue(Dev_Val, result);
  end;
  if (Hr <> S_OK) then
    result := '';
end;

procedure PropVariantInit(out PVar: PROPVARIANT);
begin
  ZeroMemory(@PVar, SizeOf(PROPVARIANT));
end;

procedure StringToPropVariant(SVal: WideString; var PropVarValue: Tag_Inner_PROPVARIANT);
var PValues: IPortableDeviceValues;
    Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
begin
  PValues :=  CreateComObject(CLASS_PortableDeviceValues) as IPortableDeviceValues;
  if VarIsClear(PValues) then Exit;

  // string value into IPortableDeviceValues object
  Dev_Val.fmtid := WPD_OBJECT_ID_FMTID;
  Dev_Val.pid := WPD_OBJECT_ID_PID;
  PValues.SetStringValue(Dev_Val, PWideChar(SVal));

  // get back string into a PROPVARIANT
  PValues.GetValue(Dev_Val, PropVarValue);
end;

function ConnectToDevice(SDev: WideString; var PortableDev: IPortableDevice; Readonly: boolean = true): Boolean;
var PortableDeviceValues: IPortableDeviceValues;
    Hr: HResult;
    Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
begin
  Result := False;
  PortableDev := CoPortableDeviceFTM.Create;

   //create device values:
  PortableDeviceValues := CreateComObject(CLASS_PortableDeviceValues) as IPortableDeviceValues;
  if VarIsClear(PortableDeviceValues) then
    Exit;

  //set some info
  Dev_Val.fmtid := WPD_CLIENT_NAME_FMTID;
  Dev_Val.pid := WPD_CLIENT_NAME_PID;
  PortableDeviceValues.SetStringValue(Dev_Val, PWideChar(CLIENT_NAME));

  Dev_Val.fmtid := WPD_CLIENT_MAJOR_VERSION_FMTID;
  Dev_Val.pid := WPD_CLIENT_MAJOR_VERSION_PID;
  PortableDeviceValues.SetUnsignedIntegerValue(Dev_Val, CLIENT_MAJOR_VER);

  Dev_Val.fmtid := WPD_CLIENT_MINOR_VERSION_FMTID;
  Dev_Val.pid := WPD_CLIENT_MINOR_VERSION_PID;
  PortableDeviceValues.SetUnsignedIntegerValue(Dev_Val, CLIENT_MINOR_VER);

  Dev_Val.fmtid := WPD_CLIENT_REVISION_FMTID;
  Dev_Val.pid := WPD_CLIENT_REVISION_PID;
  PortableDeviceValues.SetUnsignedIntegerValue(Dev_Val, CLIENT_REVISION);

  // Set access
  Dev_Val.fmtid := WPD_CLIENT_DESIRED_ACCESS_FMTID;
  Dev_Val.pid := WPD_CLIENT_DESIRED_ACCESS_PID;
  if (Readonly) then
    PortableDeviceValues.SetUnsignedIntegerValue(Dev_Val, GENERIC_READ)
  else
    PortableDeviceValues.SetUnsignedIntegerValue(Dev_Val, GENERIC_READ + GENERIC_WRITE);

  //open device
  Hr := PortableDev.Open(PWideChar(SDev), PortableDeviceValues);

  //opened ok
  Result := (Hr = S_OK);
end;

procedure EnumFunctionalCategoryObjects(Capabilities: IPortableDeviceCapabilities; SCat: WideString);
var SResultText: WideString;
  PCategoryObjs: IPortableDevicePropVariantCollection;
  ICount: Cardinal;
  I: integer;
  Prop_Var: Tag_Inner_PROPVARIANT;
  GCat: TGuid;
begin
  if SCat='' then
    Exit;

  if VarIsClear(Capabilities) then
    exit;
  GCat := StringToGUID(SCat);
  PCategoryObjs := CreateComObject(CLASS_PortableDevicePropVariantCollection) as IPortableDevicePropVariantCollection;
  if VarIsClear(PCategoryObjs) then
    exit;

  Capabilities.GetFunctionalObjects(GCat, PCategoryObjs);
  if not (Assigned(PCategoryObjs)) then
    exit;

  PCategoryObjs.GetCount(ICount);
  for I := 0 to ICount-1 do
  begin
    PropVariantInit(Winapi.ActiveX.PROPVARIANT(Prop_Var));
    PCategoryObjs.GetAt(I, Prop_Var);
    PropVariantToString(Prop_Var, SResultText);
  end;
end;

procedure EnumContentTypes(Capabilities: IPortableDeviceCapabilities; SCat: WideString);
var SResultText: WideString;
    ContentTypes: IPortableDevicePropVariantCollection;
    ICount: Cardinal;
    I: integer;
    Prop_Var: Tag_Inner_PROPVARIANT;
    GCat: TGuid;
begin
  if SCat = '' then
    exit;

  if VarIsClear(Capabilities) then
    exit;

  GCat := StringToGUID(SCat);
  ContentTypes := CreateComObject(CLASS_PortableDevicePropVariantCollection) as IPortableDevicePropVariantCollection;
  if VarIsClear(ContentTypes) then
    exit;

  Capabilities.GetSupportedContentTypes(GCat, ContentTypes);

  ContentTypes.GetCount(ICount);
  for I := 0 to ICount-1 do
  begin
    PropVariantInit(Winapi.ActiveX.PROPVARIANT(Prop_Var));
    ContentTypes.GetAt(I, Prop_Var);
    PropVariantToString(Prop_Var, SResultText);
  end;
end;

procedure EnumSupportedCommands(Capabilities: IPortableDeviceCapabilities);
var CmdKeys: IPortableDeviceKeyCollection;
    ICount: Cardinal;
    I: integer;
    Cmd_Key: PortableDeviceApiLib_TLB._tagpropertykey;
begin
  if VarIsClear(Capabilities) then
    exit;

  CmdKeys := CreateComObject(CLASS_PortableDeviceKeyCollection) as IPortableDeviceKeyCollection;
  if VarIsClear(CmdKeys) then
    Exit;

  Capabilities.GetSupportedCommands(CmdKeys);

  CmdKeys.GetCount(ICount);
  for I := 0 to ICount-1 do
  begin
    CmdKeys.GetAt(I, Cmd_Key);
  end;
end;

procedure EnumDevCapabilities(PortableDev: IPortableDevice);
var SResultText: WideString;
    Capabilities: IPortableDeviceCapabilities;
    PCategories: IPortableDevicePropVariantCollection;
    ICount: Cardinal;
    I: integer;
    Prop_Var: Tag_Inner_PROPVARIANT;
begin
  if VarIsClear(PortableDev) then
    exit;
  PortableDev.Capabilities(Capabilities);
  if VarIsClear(Capabilities) then
    exit;

  PCategories := CreateComObject(CLASS_PortableDevicePropVariantCollection) as IPortableDevicePropVariantCollection;
  if VarIsClear(PCategories) then
    exit;

  Capabilities.GetFunctionalCategories(PCategories);

  PCategories.GetCount(ICount);
  for I := 0 to ICount-1 do
  begin
    //list categories
    PropVariantInit(Winapi.ActiveX.PROPVARIANT(Prop_Var));
    PCategories.GetAt(I, Prop_Var);
    PropVariantToString(Prop_Var, SResultText);
    //category objects....
    EnumFunctionalCategoryObjects(Capabilities, SResultText);
    //types...
    EnumContentTypes(Capabilities, SResultText);
  end;

  //comands....
  EnumSupportedCommands(Capabilities);
end;

function GetDevices: TList;
var
  PMan: IPortableDeviceManager;
  IDevCount, IDevNameLen: LongWord;
  PDevs: array of PWideChar;
  I: Integer;
  DevFriendlyName: WideString;
  DevDescription: WideString;
  AMTP_Device: TMTP_Device;
begin
  result := Tlist.Create;

  PMan := CoPortableDeviceManager.Create;
  if PMan.RefreshDeviceList <> S_OK then
    exit;
  // Determine how many WPD devices are connected
  IDevCount := 0;
  if PMan.GetDevices(PWideChar(nil^), IDevCount) <> S_OK then
    exit;
  if IDevCount>0 then
  begin
    // Retrieve the device id for each connected device
    SetLength(PDevs, IDevCount);
    if PMan.GetDevices(PDevs[0], IDevCount) <> S_OK then
      exit;

    for I := 0 to IDevCount - 1 do //enumerate the devices:
    begin
      DevFriendlyName := '';
      DevDescription := '';

      //Get Friendly Name
      IDevNameLen := 0;
      if PMan.GetDeviceFriendlyName(PDevs[I], Word(nil^), IDevNameLen) <> S_OK then
        continue;
      SetLength(DevFriendlyName, IDevNameLen);
      PMan.GetDeviceFriendlyName(PDevs[I], PWord(PWideChar(DevFriendlyName))^, IDevNameLen);

      //Get Description
      IDevNameLen := 0;
      if PMan.GetDeviceDescription(PDevs[I], Word(nil^), IDevNameLen) <> S_OK then
        continue;
      SetLength(DevDescription, IDevNameLen);
      PMan.GetDeviceDescription(PDevs[I], PWord(PWideChar(DevDescription))^, IDevNameLen);

      //  Create device object
      AMTP_Device := TMTP_Device.Create;
      AMTP_Device.Description := Trim(DevDescription);
      AMTP_Device.FriendlyName := Trim(DevFriendlyName);
      AMTP_Device.Device := GetDevId(Trim(PDevs[I]));
      AMTP_Device.PortableDev := nil;
      result.Add(AMTP_Device);
    end;
  end;
end;

function FirstStorageIDs(PortableDev: IMTPDevice; DeviceRoot: string = WPD_DEVICE_OBJECT_ID): IEnumPortableDeviceObjectIDs;
var
  Content: IPortableDeviceContent;
  ObjectIds: IEnumPortableDeviceObjectIDs;
begin
  result := nil;
  if (PortableDev.Content(Content) = S_OK) and
     (Content.EnumObjects(0, PWideChar(DeviceRoot), nil, ObjectIds) = S_OK) then
    result := ObjectIds;
end;

function GetFirstStorageID(PortableDev: IMTPDevice): WideString;
var
  ObjectIds: IEnumPortableDeviceObjectIDs;
  ObjectId: PWideChar;
  Fetched: Cardinal;
begin
  Result := WPD_DEVICE_OBJECT_ID;
  ObjectIds := FirstStorageIDs(PortableDev, '');
  if (ObjectIds = nil) then
    exit;

  ObjectIds.Reset;
  ObjectIds.Next(1, ObjectId, Fetched);
  if (Fetched > 0) then
    Result := ObjectId;
end;

procedure FillObjectProperties(ObjId: PWideChar; Prop: IPortableDeviceProperties;
                               AListItems: TListItems; AListItem: TListItem); overload;
var ObjName: PWideChar;
    PropVar: Tag_Inner_PROPVARIANT;
    ObjDate: TDateTime;
    DateOriginal, TimeOriginal: string;
    ObjSize: int64;
    Keys: IPortableDeviceKeyCollection;
    Prop_Val: IPortableDeviceValues;
    Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
    AMTP_Data: TMTP_Data;
    Hr: Hresult;
begin
  //Get object prop.
  Prop.GetSupportedProperties(ObjId, Keys);
  Prop.GetValues(ObjId, Keys, Prop_Val);
  if VarIsClear(Prop_Val) then
    exit;

  // Get the name of the object.
  ObjName := PropValToName(Prop_Val);

  // Get the date and time
  ObjDate := EncodeDate(1899, 12, 30);
  TimeOriginal := '';
  DateOriginal := '';

  // Prefer date authored => date created => date modified
  Dev_Val.fmtid := WPD_OBJECT_DATE_AUTHORED_FMTID;
  Dev_Val.pid := WPD_OBJECT_DATE_AUTHORED_Pid;
  Hr := Prop_Val.GetValue(Dev_Val, PropVar);
  if (HR <> S_OK) then
  begin
    Dev_Val.fmtid := WPD_OBJECT_DATE_CREATED_FMTID;
    Dev_Val.pid := WPD_OBJECT_DATE_CREATED_PID;
    Hr := Prop_Val.GetValue(Dev_Val, PropVar);
  end;
  if (HR <> S_OK) then
  begin
    Dev_Val.fmtid := WPD_OBJECT_DATE_MODIFIED_FMTID;
    Dev_Val.pid := WPD_OBJECT_DATE_MODIFIED_PID;
    Hr := Prop_Val.GetValue(Dev_Val, PropVar);
  end;
  if (HR = S_OK) then
  begin
    ObjDate := PropVarToDate(PropVar);
    TimeOriginal := FormatDateTime('yyyy-MM-DD"T"hh:mm:ss', ObjDate);
    DateOriginal := NextField(TimeOriginal, 'T');
  end;

  // Get the Size
  Dev_Val.fmtid := WPD_OBJECT_SIZE_FMTID;
  Dev_Val.pid := WPD_OBJECT_SIZE_PID;
  Prop_Val.GetSignedLargeIntegerValue(Dev_Val, ObjSize);

  // Fill Listitem
  if (AListItem = nil) then
  begin
    AMTP_Data := TMTP_Data.Create(IsDirectory(Prop_Val), ObjSize, ObjId , ObjDate);
    AMTP_Data.CreateListItem(AListItems, ObjName, [DateOriginal, TimeOriginal, ExtractFileExt(ObjName), SenSize(ObjSize)]);
  end
  else
  begin
    AMTP_Data := TMTP_Data(AListItem.Data);
    AMTP_Data.IsFolder := IsDirectory(Prop_Val);
    AMTP_Data.ObjectId := ObjId;
    AMTP_Data.Created := ObjDate;
    AMTP_Data.SortValue := ObjSize;
    AMTP_Data.UpdateListItem(AListItem, [DateOriginal, TimeOriginal, ExtractFileExt(ObjName), SenSize(ObjSize)]);
  end;
end;

procedure FillObjectProperties(ObjId: PWideChar; Prop: IPortableDeviceProperties;
                               AListItem: TListItem); overload;
begin
  FillObjectProperties(ObjId, Prop, AListItem.Owner, AListItem);
end;

procedure FillObjectProperties(ObjId: PWideChar; Prop: IPortableDeviceProperties;
                               AListItems: TListItems); overload;
begin
  FillObjectProperties(ObjId, Prop, AListItems, nil);
end;

function EnumContentsOfFolder(Content: IPortableDeviceContent;
                              ParentId: WideString;
                              Lst: TListItems;
                              Parents: Widestring = ''): PWideChar;
var ObjectIds: IEnumPortableDeviceObjectIDs;
    ObjId: PWideChar;
    Fetched: Cardinal;
    Keys: IPortableDeviceKeyCollection;
    Prop: IPortableDeviceProperties;
    Prop_Val: IPortableDeviceValues;
    Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
    AMTP_Data: TMTP_Data;
    CrNormal, CrWait: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  result := '';

  try
    if not VarIsClear(Content) then
    begin

      //get content properties
      Content.Properties(Prop);

      if Content.EnumObjects(0, PWideChar(ParentId), nil, ObjectIds) = S_OK then
      begin

        (* Get Parent and store in result. *)
        Prop.GetSupportedProperties(PWideChar(ParentId), Keys);
        Prop.GetValues(PWideChar(ParentId), Keys, Prop_Val);
        Dev_Val.fmtid := WPD_OBJECT_PARENT_ID_FMTID;
        Dev_Val.pid := WPD_OBJECT_PARENT_ID_PID;
        Prop_Val.GetStringValue(Dev_Val, Result);
        (* until here *)

        // Add .. entry (up)
        AMTP_Data := TMTP_Data.Create(true, 0, ParentId, 0);
        AMTP_Data.CreateListItem(Lst, '..', ['', '', '', '']);

        ObjectIds.Reset;

        // Getting and array of Objids maybe faster. We alwayws get 1 object at a time.
        while (ObjectIds.Next(1, ObjId, Fetched) = S_OK) do
        begin
          if (Fetched = 0) then // Does it ever happen?
            break;

          FillObjectProperties(ObjId, Prop, Lst);
        end;
      end;
    end;
  finally
    SetCursor(CrNormal);
  end;
end;

function GetParents(AContent: IPortableDeviceContent; SParent: string; Parents: WideString):string;
var Prop: IPortableDeviceProperties;
    Prop_Val: IPortableDeviceValues;
    Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
    Keys: IPortableDeviceKeyCollection;
    ParentName: PWideChar;
    Hr: Hresult;
begin
  AContent.Properties(Prop);
  Prop.GetSupportedProperties(PWideChar(SParent), Keys);
  Prop.GetValues(PWideChar(SParent), Keys, Prop_Val);
  if (Prop_Val = nil) then
    exit('');

  // Build up path
  result := PropValToName(Prop_Val);
  if (Parents <> '') and
    (result <> '') then
    result := result + '\';
   result := result + Parents;

  Dev_Val.fmtid := WPD_OBJECT_PARENT_ID_FMTID;
  Dev_Val.pid := WPD_OBJECT_PARENT_ID_PID;
  Hr := Prop_Val.GetStringValue(Dev_Val, ParentName);

  if (Hr = S_OK) and
     (ParentName <> '') then
    result := GetParents(AContent, ParentName, result);
end;

function ReadFilesFromDevice(PortableDev: IMTPDevice;
                             Lst: TListItems;
                             SParent: WideString;
                             var CompletePath: WideString):PWideChar;
var Content: IPortableDeviceContent;
    CrNormal, CrWait: HCURSOR;
begin
  Result := '';
  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    if PortableDev.Content(Content) = S_OK then
    begin
      CompletePath := GetParents(Content, SParent, '');
      if (CompletePath = '') then
        SParent := GetFirstStorageID(PortableDev);

      //read content of device
      Result := EnumContentsOfFolder(Content, SParent, Lst);
    end;
  finally
    SetCursor(CrNormal);
  end;
end;

function FindItemInFolder(Content: IPortableDeviceContent;
                          FolderId, FileId: WideString;
                          var FriendlyPath: string): PWideChar;
var ObjectIds: IEnumPortableDeviceObjectIDs;
    ObjId, ObjName, PersistentId: PWideChar;
    PersistentIdString: string;
    Fetched: Cardinal;
    Keys: IPortableDeviceKeyCollection;
    Prop: IPortableDeviceProperties;
    Prop_Val: IPortableDeviceValues;
    Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
begin
  result := '';
  if (FolderId = '') then
    exit;

  ObjName := '';
  try
    if not VarIsClear(Content) then
    begin
      //get content properties
      Content.Properties(Prop);

      if Content.EnumObjects(0, PWideChar(FolderId), nil, ObjectIds) = S_OK then
      begin

        ObjectIds.Reset;
        while (ObjectIds.Next(1, ObjId, Fetched) = S_OK) do
        begin
          if (Fetched = 0) then // Does it ever happen?
            break;
          //Get object prop.
          Prop.GetSupportedProperties(ObjId, Keys);
          Prop.GetValues(ObjId, Keys, Prop_Val);
          ObjName := '';

          if VarIsClear(Prop_Val) then
            continue;

          ObJName := PropValToName(Prop_Val);
          if SameText(FileId, ObjName) then
          begin
            result := ObjId;
            exit;
          end;

          Dev_Val.fmtid := WPD_OBJECT_PERSISTENT_UNIQUE_ID_FMTID;
          Dev_Val.pid := WPD_OBJECT_PERSISTENT_UNIQUE_ID_PID;
          Prop_Val.GetStringValue(Dev_Val, PersistentId);
          PersistentIdString := ReplaceAll(PersistentId, ['%3B%5C'], [':\']);

          if (FileId = PersistentIdString) then
          begin
            result := ObjId;
            exit;
          end;
        end;
      end;
    end;
  finally
    if (result <> '') then
    begin
      if (FriendlyPath <> '') then
        FriendlyPath := FriendlyPath + '\';
      FriendlyPath := FriendlyPath + ObjName;
    end;
  end;
end;

function GetIdForFile(PortableDev: IMTPDevice;
                      SPath: WideString;
                      SFile: WideString;
                      AListItem: TListItem = nil): string;
var Prop: IPortableDeviceProperties;
    Content: IPortableDeviceContent;
    FriendlyName: string;
begin
  if PortableDev.Content(Content) <> S_OK then
    exit;
  result := FindItemInFolder(Content, SPath, SFile, FriendlyName);
  if (AListItem <> nil) then
  begin
    Content.Properties(Prop);
    FillObjectProperties(PWideChar(result), Prop, AListItem);
  end;
end;

function GetIdForPath(PortableDev: IMTPDevice;
                      SPath: WideString;
                      var FriendlyPath: string): string;
var Content: IPortableDeviceContent;
    CrNormal, CrWait: HCURSOR;
    SFolder: string;

    CurPath, CompletePath: string;

    procedure TraversePath(CurPath, Parent, CompletePath: string;
                           var FolderId, FriendlyPath, FileId: string);
    begin
      FolderId := FindItemInFolder(Content, Parent, CurPath, FriendlyPath);
      CurPath := NextField(CompletePath, '\');
      if (CompletePath <> '') then
        TraversePath(CurPath, FolderId, CompletePath, FolderId, FriendlyPath, FileId)
      else
        FileId := FindItemInFolder(Content, FolderId, CurPath, FriendlyPath);
    end;

begin
  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  CompletePath := SPath;
  FriendlyPath := '';
  try
    CurPath := NextField(CompletePath, '\');
    if (CompletePath = '') then
      exit(CurPath);

    //read content of device
    if PortableDev.Content(Content) = S_OK then
      TraversePath(CurPath, GetFirstStorageID(PortableDev), CompletePath, SFolder, FriendlyPath, result);
  finally
    SetCursor(CrNormal);
  end;
end;

function GetFileFromDevice(PortableDev: IMTPDevice; SFile, SSaveTo, NFile: WideString): Boolean;
var Content: IPortableDeviceContent;
    Resources: IPortableDeviceResources;
    ITransferSize, IReadBytes: FixedUInt;
    Res_Prop: PortableDeviceApiLib_TLB._tagpropertykey;
    FDevStream: IStream;
    FFileStream: TFileStream;
    Buf: array of Byte;
    CrNormal,CrWait: HCURSOR;
begin
  Result := False;
  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  //read content of device
  try
    if PortableDev.Content(Content) <> S_OK then
      exit;
    if Content.Transfer(Resources) <> S_OK then
      exit;
    Res_Prop.fmtid := WPD_RESOURCE_DEFAULT_FMTID;
    Res_Prop.pid := WPD_RESOURCE_DEFAULT_PID;

    //request stream
    ITransferSize := 0;
    if Resources.GetStream(PWideChar(SFile), Res_Prop, 0, ITransferSize, FDevStream) = S_OK then
    begin
      SetLength(Buf, ITransferSize);
      FFileStream := TFileStream.Create(IncludeTrailingPathDelimiter(SSaveTo) + NFile, fmCreate);
      try
        //read source stream using buffer
        repeat
          FDevStream.Read(@Buf[0], ITransferSize, @IReadBytes);
          if IReadBytes > 0 then
            FFileStream.Write(Buf[0], IReadBytes);
        until (IReadBytes = 0);

        Result := True;
      finally
        FFileStream.Free;
        FDevStream := nil;
      end;
    end;
  finally
    SetCursor(CrNormal);
  end;
end;

function DelFileFromDevice(PortableDev: IMTPDevice; SFile: WideString): Boolean;
var Content: IPortableDeviceContent;
    Prop_Var: Tag_Inner_PROPVARIANT;
    PFiles, PRes: IPortableDevicePropVariantCollection;
begin
  Result := False;

  if PortableDev.Content(Content) <> S_OK then
    exit;
  PFiles := CreateComObject(CLASS_PortableDevicePropVariantCollection) as IPortableDevicePropVariantCollection;
  if VarIsClear(PFiles) then
    exit;

  //add  file name to list for deleting
  PropVariantInit(Winapi.ActiveX.PROPVARIANT(Prop_Var));
  StringToPropVariant(SFile, Prop_Var);
  PFiles.Add(Prop_Var);

  //delete
  Result := (Content.Delete(0, PFiles, PRes) = S_OK); //recursion ??
end;

procedure GetRequiredPropertiesForContent(Parent: WideString; FileName: WideString;
  ISize: Cardinal; var PPObjectProperties: IPortableDeviceValues);

var Dev_Val: PortableDeviceApiLib_TLB._tagpropertykey;
    PropVar: tag_inner_PROPVARIANT;
begin
  //parent id
  Dev_Val.fmtid := WPD_OBJECT_PARENT_ID_FMTID;
  Dev_Val.pid := WPD_OBJECT_PARENT_ID_PID;
  PPObjectProperties.SetStringValue(Dev_Val, PWideChar(Parent));

  //object name
  Dev_Val.fmtid := WPD_OBJECT_NAME_FMTID;
  Dev_Val.pid := WPD_OBJECT_NAME_PID;
  PPObjectProperties.SetStringValue(Dev_Val, PWideChar(FileName));

  //file name
  Dev_Val.fmtid := WPD_OBJECT_ORIGINAL_FILE_NAME_FMTID;
  Dev_Val.pid := WPD_OBJECT_ORIGINAL_FILE_NAME_PID;
  PPObjectProperties.SetStringValue(Dev_Val, PWideChar(FileName));

  //size
  Dev_Val.fmtid := WPD_OBJECT_SIZE_FMTID;
  Dev_Val.pid := WPD_OBJECT_SIZE_PID;
  PPObjectProperties.SetUnsignedLargeIntegerValue(Dev_Val, ISize);

  // All dates
  DateToPropVar(Now, PropVar);

  Dev_Val.fmtid := WPD_OBJECT_DATE_AUTHORED_FMTID;
  Dev_Val.pid := WPD_OBJECT_DATE_AUTHORED_Pid;
  PPObjectProperties.SetValue(Dev_Val, PropVar);

  Dev_Val.fmtid := WPD_OBJECT_DATE_CREATED_FMTID;
  Dev_Val.pid := WPD_OBJECT_DATE_CREATED_PID;
  PPObjectProperties.SetValue(Dev_Val, PropVar);

  Dev_Val.fmtid := WPD_OBJECT_DATE_MODIFIED_FMTID;
  Dev_Val.pid := WPD_OBJECT_DATE_MODIFIED_PID;
  PPObjectProperties.SetValue(Dev_Val, PropVar);

end;

// See for more info
//https://learn.microsoft.com/en-us/windows/win32/wpd_sdk/transferring-an-image-or-music-file-to-the-device
function TransferNewFileToDevice(PortableDev: IMTPDevice; SFile, SSaveTo: WideString;
                                 NewName: WideString = ''): WideString;
var Content: IPortableDeviceContent;
    PortableStream:  IPortableDeviceDataStream;
    ITransferSize, IReadBytes, IWritten: FixedUint;
    FDevStream: IStream;
    PValues: IPortableDeviceValues;
    FFileStream: TFileStream;
    Buf: array of Byte;
    NameOnDev: WideString;
    PPszCookie: PWideChar;
    ppszObjectID: PWideChar;
    HR: HResult;
begin
  Result := '';
  if PortableDev.Content(Content) <> S_OK then
    exit;

  //required properties for content
  PValues := CreateComObject(CLASS_PortableDeviceValues) as IPortableDeviceValues;
  if VarIsClear(PValues) then
    exit;

  FFileStream := TFileStream.Create(SFile, fmOpenRead);
  try
    NameOnDev := NewName;
    if (NameOnDev = '') then
      NameOnDev := ExtractFileName(SFile);

    GetRequiredPropertiesForContent(SSaveTo, NameOnDev, FFileStream.Size, PValues);

    //create dest. stream
    ITransferSize := 0;
    PPszCookie := '';
    HR := Content.CreateObjectWithPropertiesAndData(PValues, FDevStream, ITransferSize, PPszCookie);
    if (HR <> S_OK) then
      exit;
    if VarIsClear(FDevStream) then
      exit;
    SetLength(Buf, ITransferSize);
    //transfer to dev. stream
    //read source stream using buffer
    repeat
      IReadBytes := FFileStream.Read(Buf[0], ITransferSize);
      if IReadBytes > 0 then
        Hr := FDevStream.Write(@Buf[0], IReadBytes, @IWritten);
    until (IReadBytes = 0) or
          (Hr <> S_OK);

    //commit saving to stream
    if (FDevStream.Commit(0) = S_OK) then
    begin
      // Get newly created Object Id
      FDevStream.QueryInterface(CLASS_IPortableDeviceDataStream, PortableStream);
      if (PortableStream <> nil) then
      begin
        PortableStream.GetObjectID(ppszObjectID);
        result := ppszObjectID;
      end;
    end;
  finally
    FFileStream.Free;
  end;
end;

// - Transfer file to device with a temporary name.
// - Delete the old file
// - Rename temporary to original name.

const TempExtension = '.tmp';

function TransferExistingFileToDevice(PortableDev: IMTPDevice; SFile, SSaveTo: WideString; AListItem: TListItem): Boolean;
var MTP_Data: TMTP_Data;
    Content: IPortableDeviceContent;
    Prop: IPortableDeviceProperties;
    OriginalName: WideString;
    TempName: WideString;
    NewObjectId: WideString;
    OldObjectId: WideString;
begin
  result := false;

  // Need ListItem
  if (AListItem.Data = nil) then
    exit;
  MTP_Data := TMTP_Data(AListItem.Data);
  OldObjectId := MTP_Data.ObjectId;

  // Get interfaces
  if PortableDev.Content(Content) <> S_OK then
    exit;

  if Content.Properties(Prop) <> S_OK then
    exit;

// Set filenames
  OriginalName := ExtractFileName(SFile);
  TempName := ChangeFileExt(OriginalName, TempExtension);

// Copy File to Device. The Filename will exist (shortly) twice.
  NewObjectId := TransferNewFileToDevice(PortableDev, SFile, SSaveTo, TempName);
  if (NewObjectId = '') then
    exit;

// Now delete the old object
// If this fails, for some reason, the file will exist twice on the device.
  if not DelFileFromDevice(PortableDev, OldObjectId) then
    exit;

// Rename back to original file
  if not RenameObject(PortableDev, NewObjectId, OriginalName) then
    exit;

// And get properties
  FillObjectProperties(PWideChar(NewObjectId), Prop, AListItem);

  result := true;
end;

initialization
  OleInitialize(nil);

finalization
  OleUninitialize;

end.
