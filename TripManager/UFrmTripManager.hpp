// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmTripManager.pas' rev: 36.00 (Windows)

#ifndef UFrmTripManagerHPP
#define UFrmTripManagerHPP

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
#include <Winapi.WebView2.hpp>
#include <System.SysUtils.hpp>
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <System.ImageList.hpp>
#include <Winapi.ShlObj.hpp>
#include <System.Win.ComObj.hpp>
#include <Winapi.ActiveX.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.ValEdit.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Mask.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Edge.hpp>
#include <Vcl.Shell.ShellCtrls.hpp>
#include <Vcl.ToolWin.hpp>
#include <Vcl.ButtonGroup.hpp>
#include <TripManager_ShellList.hpp>
#include <BCHexEditor.hpp>
#include <UnitMtpDevice.hpp>
#include <mtp_helper.hpp>
#include <ListViewSort.hpp>
#include <unitTripObjects.hpp>
#include <UnitGpi.hpp>
#include <Monitor.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmtripmanager
{
//-- forward type declarations -----------------------------------------------
struct TMapReq;
class DELPHICLASS TFrmTripManager;
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::UnicodeString, 2> Ufrmtripmanager__1;

struct DECLSPEC_DRECORD TMapReq
{
public:
	System::UnicodeString Coords;
	System::UnicodeString Desc;
	System::UnicodeString Zoom;
};


enum DECLSPEC_DENUM TDirType : unsigned char { NoDir, Up, Down };

enum DECLSPEC_DENUM TListFilesDir : unsigned char { lfCurrent, lfUp, lfDown };

enum DECLSPEC_DENUM TRouteParm : unsigned char { RoutePref, TransportMode };

class PASCALIMPLEMENTATION TFrmTripManager : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
	
private:
	typedef System::StaticArray<System::UnicodeString, 3> _TFrmTripManager__1;
	
	
__published:
	Vcl::Extctrls::TSplitter* HSplitterDevFiles_Info;
	Vcl::Controls::TImageList* ImageList;
	Vcl::Extctrls::TPanel* HexPanel;
	Vcl::Extctrls::TSplitter* VSplitterTripInfo_HexOSM;
	Vcl::Extctrls::TPanel* PnlHexEditTrip;
	Vcl::Extctrls::TPanel* PnlXTAndFileSys;
	Vcl::Comctrls::TListView* LstFiles;
	Vcl::Extctrls::TSplitter* VSplitterDev_Files;
	Vcl::Comctrls::TPageControl* PageControl1;
	Vcl::Comctrls::TTabSheet* TsTripGpiInfo;
	Vcl::Extctrls::TSplitter* VSplitterTree_Grid;
	Vcl::Comctrls::TTreeView* TvTrip;
	Vcl::Valedit::TValueListEditor* VlTripInfo;
	Vcl::Comctrls::TPageControl* PctHexOsm;
	Vcl::Comctrls::TTabSheet* TsHex;
	Vcl::Comctrls::TTabSheet* TsOSMMap;
	Vcl::Extctrls::TPanel* AdvPanel_MapTop;
	Vcl::Stdctrls::TEdit* EditMapCoords;
	Vcl::Extctrls::TPanel* AdvPanel_MapBottom;
	Vcl::Extctrls::TLabeledEdit* EditMapBounds;
	Vcl::Edge::TEdgeBrowser* EdgeBrowser1;
	Vcl::Stdctrls::TComboBox* CmbDevices;
	Vcl::Extctrls::TPanel* PnlXTLeft;
	Vcl::Extctrls::TPanel* PnlFileSys;
	Vcl::Shell::Shellctrls::TShellTreeView* ShellTreeView1;
	Vcl::Extctrls::TSplitter* VSplitterFile_Sys;
	Tripmanager_shelllist::TShellListView* ShellListView1;
	Vcl::Extctrls::TPanel* PnlXt2FileSys;
	Vcl::Extctrls::TPanel* PnlFileSysFunc;
	Vcl::Stdctrls::TButton* BtnAddToMap;
	Vcl::Stdctrls::TButton* BtnSaveTripGpiFile;
	Vcl::Extctrls::TPanel* PnlVlTripInfo;
	Vcl::Extctrls::TPanel* PnlVlTripInfoTop;
	Vcl::Stdctrls::TButton* BtnSaveTripValues;
	Vcl::Stdctrls::TButton* BtnApplyCoords;
	Vcl::Stdctrls::TEdit* LblRoutePoint;
	Vcl::Extctrls::TPanel* PnlCoordinates;
	Vcl::Extctrls::TPanel* PnlRoutePoint;
	Vcl::Buttons::TSpeedButton* SpeedBtn_MapClear;
	Vcl::Stdctrls::TEdit* LblRoute;
	Vcl::Extctrls::TSplitter* Splitter1;
	Vcl::Stdctrls::TEdit* EdDeviceFolder;
	Vcl::Extctrls::TPanel* PnlDeviceTop;
	Vcl::Stdctrls::TButton* BtnRefresh;
	Vcl::Stdctrls::TEdit* EdFileSysFolder;
	Vcl::Buttongroup::TButtonGroup* BgDevice;
	Vcl::Stdctrls::TButton* BtnSetDeviceDefault;
	Vcl::Menus::TPopupMenu* DeviceMenu;
	Vcl::Menus::TMenuItem* FileFunctions1;
	Vcl::Menus::TMenuItem* N1;
	Vcl::Menus::TMenuItem* TripFunctions1;
	Vcl::Stdctrls::TButton* BtnFunctions;
	Vcl::Menus::TMenuItem* N3;
	Vcl::Menus::TMenuItem* Setselectedtripstosaved1;
	Vcl::Menus::TMenuItem* Setselectedtripstoimported1;
	Vcl::Menus::TMenuItem* Delete1;
	Vcl::Menus::TMenuItem* N2;
	Vcl::Menus::TMenuItem* Rename1;
	Vcl::Extctrls::TTimer* TripGpiTimer;
	Vcl::Menus::TMenuItem* N4;
	Vcl::Menus::TMenuItem* Setdeparturedatetimeofselected1;
	Vcl::Menus::TMenuItem* N5;
	Vcl::Menus::TMenuItem* Renameselectedtripfilestotripname1;
	Vcl::Menus::TMenuItem* Groupselectedtrips1;
	Vcl::Menus::TMenuItem* Ungroupselectedtrips1;
	Vcl::Menus::TMenuItem* N6;
	Vcl::Menus::TMenuItem* Settransportationmodeofselectedtrips1;
	Vcl::Menus::TMenuItem* Automotive1;
	Vcl::Menus::TMenuItem* MotorCycling1;
	Vcl::Menus::TMenuItem* OffRoad1;
	Vcl::Menus::TMenuItem* Setroutepreferenceofselectedtrips1;
	Vcl::Menus::TMenuItem* Fastertime1;
	Vcl::Menus::TMenuItem* Shorterdistance1;
	Vcl::Menus::TMenuItem* Directrouting1;
	Vcl::Menus::TMenuItem* Curvyroads1;
	Vcl::Stdctrls::TButton* BtnFromDev;
	Vcl::Stdctrls::TButton* BtnToDev;
	Vcl::Stdctrls::TButton* BtnTransferToDevice;
	Vcl::Extctrls::TPanel* PnlTopFiller;
	Vcl::Stdctrls::TButton* BtnRefreshFileSys;
	Vcl::Extctrls::TPanel* PnlBotFileSys;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TButton* BtnOpenTemp;
	Vcl::Extctrls::TTimer* MapTimer;
	Vcl::Stdctrls::TButton* BtnCreateAdditional;
	Vcl::Extctrls::TPanel* PnlTripGpiInfo;
	Vcl::Stdctrls::TComboBox* CmbModel;
	Vcl::Stdctrls::TButton* BtnPostProcess;
	Vcl::Stdctrls::TCheckBox* ChkWatch;
	Vcl::Extctrls::TTimer* PostProcessTimer;
	Vcl::Menus::TMainMenu* MainMenu;
	Vcl::Menus::TMenuItem* Help1;
	Vcl::Menus::TMenuItem* About1;
	Vcl::Menus::TMenuItem* N7;
	Vcl::Menus::TMenuItem* Onlinehelp1;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall BtnRefreshClick(System::TObject* Sender);
	void __fastcall LstFilesDblClick(System::TObject* Sender);
	void __fastcall LstFilesDeletion(System::TObject* Sender, Vcl::Comctrls::TListItem* Item);
	void __fastcall LstFilesColumnClick(System::TObject* Sender, Vcl::Comctrls::TListColumn* Column);
	void __fastcall LstFilesCompare(System::TObject* Sender, Vcl::Comctrls::TListItem* Item1, Vcl::Comctrls::TListItem* Item2, int Data, int &Compare);
	void __fastcall LstFilesSelectItem(System::TObject* Sender, Vcl::Comctrls::TListItem* Item, bool Selected);
	void __fastcall LstFilesItemChecked(System::TObject* Sender, Vcl::Comctrls::TListItem* Item);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall BtnSaveTripGpiFileClick(System::TObject* Sender);
	void __fastcall ValueListKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall TvTripChange(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall VlTripInfoSelectCell(System::TObject* Sender, int ACol, int ARow, bool &CanSelect);
	void __fastcall EdgeBrowser1CreateWebViewCompleted(Vcl::Edge::TCustomEdgeBrowser* Sender, HRESULT AResult);
	void __fastcall EdgeBrowser1NavigationStarting(Vcl::Edge::TCustomEdgeBrowser* Sender, Vcl::Edge::TNavigationStartingEventArgs* Args);
	void __fastcall EdgeBrowser1WebMessageReceived(Vcl::Edge::TCustomEdgeBrowser* Sender, Vcl::Edge::TWebMessageReceivedEventArgs* Args);
	void __fastcall EdgeBrowser1ZoomFactorChanged(Vcl::Edge::TCustomEdgeBrowser* Sender, double AZoomFactor);
	void __fastcall EditMapCoordsKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall CmbDevicesChange(System::TObject* Sender);
	void __fastcall ShellListView1AddFolder(System::TObject* Sender, Vcl::Shell::Shellctrls::TShellFolder* AFolder, bool &CanAdd);
	void __fastcall ShellTreeView1Change(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall ShellListView1Click(System::TObject* Sender);
	void __fastcall BtnAddToMapClick(System::TObject* Sender);
	void __fastcall SpeedBtn_MapClearClick(System::TObject* Sender);
	void __fastcall VlTripInfoStringsChange(System::TObject* Sender);
	void __fastcall VlTripInfoEditButtonClick(System::TObject* Sender);
	void __fastcall BtnSaveTripValuesClick(System::TObject* Sender);
	void __fastcall BtnApplyCoordsClick(System::TObject* Sender);
	void __fastcall TvTripCustomDrawItem(Vcl::Comctrls::TCustomTreeView* Sender, Vcl::Comctrls::TTreeNode* Node, Vcl::Comctrls::TCustomDrawState State, bool &DefaultDraw);
	void __fastcall BtnFunctionsMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall SetSelectedTrips(System::TObject* Sender);
	void __fastcall BtnSetDeviceDefaultClick(System::TObject* Sender);
	void __fastcall TripGpiTimerTimer(System::TObject* Sender);
	void __fastcall Delete1Click(System::TObject* Sender);
	void __fastcall RenameFile(System::TObject* Sender);
	void __fastcall Setdeparturedatetimeofselected1Click(System::TObject* Sender);
	void __fastcall Renameselectedtripfilestotripname1Click(System::TObject* Sender);
	void __fastcall Groupselectedtrips1Click(System::TObject* Sender);
	void __fastcall Ungroupselectedtrips1Click(System::TObject* Sender);
	void __fastcall TransportModeClick(System::TObject* Sender);
	void __fastcall RoutePreferenceClick(System::TObject* Sender);
	void __fastcall PostProcessClick(System::TObject* Sender);
	void __fastcall BgDeviceClick(System::TObject* Sender);
	void __fastcall BtnOpenTempClick(System::TObject* Sender);
	void __fastcall DeviceMenuPopup(System::TObject* Sender);
	void __fastcall BtnFromDevClick(System::TObject* Sender);
	void __fastcall BtnToDevClick(System::TObject* Sender);
	void __fastcall CreateAdditionalClick(System::TObject* Sender);
	void __fastcall BtnRefreshFileSysClick(System::TObject* Sender);
	void __fastcall AdvPanel_MapTopResize(System::TObject* Sender);
	void __fastcall ShellTreeView1CustomDrawItem(Vcl::Comctrls::TCustomTreeView* Sender, Vcl::Comctrls::TTreeNode* Node, Vcl::Comctrls::TCustomDrawState State, bool &DefaultDraw);
	void __fastcall EdDeviceFolderKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall EdFileSysFolderKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall MapTimerTimer(System::TObject* Sender);
	void __fastcall ShellListView1KeyUp(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall BtnTransferToDeviceClick(System::TObject* Sender);
	void __fastcall ShellListView1ColumnClick(System::TObject* Sender, Vcl::Comctrls::TListColumn* Column);
	void __fastcall LstFilesKeyUp(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall ChkWatchClick(System::TObject* Sender);
	void __fastcall PostProcessTimerTimer(System::TObject* Sender);
	void __fastcall ShellListView1DblClick(System::TObject* Sender);
	void __fastcall About1Click(System::TObject* Sender);
	void __fastcall Onlinehelp1Click(System::TObject* Sender);
	
private:
	System::UnicodeString PrefDevice;
	bool DeviceFile;
	System::UnicodeString HexEditFile;
	Unitmtpdevice::TMTP_Device* CurrentDevice;
	System::WideString FSavedParent;
	System::WideString FSavedFolderId;
	System::WideString FCurrentPath;
	System::Classes::TList* DeviceList;
	Listviewsort::TSortSpecification FSortSpecification;
	Bchexeditor::TBCHexEditor* HexEdit;
	Unittripobjects::TTripList* ATripList;
	Unitgpi::TPOIList* APOIList;
	TMapReq FMapReq;
	double EdgeZoom;
	int WarnRecalc;
	bool WarnModel;
	int WarnOverWrite;
	System::Classes::TStringList* ModifiedList;
	Monitor::TDirectoryMonitor* DirectoryMonitor;
	void __fastcall DirectoryEvent(System::TObject* Sender, Monitor::TDirectoryMonitorAction Action, const System::WideString FileName);
	MESSAGE void __fastcall FileSysDrop(Winapi::Messages::TWMDropFiles &Msg);
	void __fastcall ClearSelHexEdit();
	void __fastcall SyncHexEdit(System::TObject* Sender);
	void __fastcall HexEditKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall HexEditKeyPress(System::TObject* Sender, System::WideChar &Key);
	void __fastcall LoadHex(const System::UnicodeString FileName);
	void __fastcall LoadTripOnMap(Unittripobjects::TTripList* CurrentTrip, System::UnicodeString Id);
	void __fastcall LoadGpiOnMap(Unitgpi::TPOIList* CurrentGpi, System::UnicodeString Id);
	void __fastcall MapRequest(const System::UnicodeString Coords, const System::UnicodeString Desc);
	void __fastcall SaveTripGpiFile();
	void __fastcall LoadTripFile(const System::UnicodeString FileName, const bool FromDevice);
	void __fastcall LoadGpiFile(const System::UnicodeString FileName, const bool FromDevice);
	void __fastcall FreeCustomData(const void * ACustomData);
	void __fastcall FreeDevices();
	void __fastcall GuessModel(const System::UnicodeString FriendlyName);
	void __fastcall SelectDevice(const int Indx);
	TDirType __fastcall GetItemType(Vcl::Comctrls::TListView* const AListview);
	void __fastcall CloseDevice();
	bool __fastcall CheckDevice(bool RaiseException = true);
	void __fastcall GetDeviceList();
	System::UnicodeString __fastcall GetDevicePath(const System::UnicodeString CompletePath);
	System::UnicodeString __fastcall GetSelectedFile();
	void __fastcall SetSelectedFile(System::UnicodeString AFile);
	void __fastcall SetCurrentPath(const System::UnicodeString APath);
	System::UnicodeString __fastcall CopyFileToTmp(Vcl::Comctrls::TListItem* const AListItem);
	void __fastcall CopyFileFromTmp(const System::UnicodeString LocalFile, Vcl::Comctrls::TListItem* const AListItem);
	void __fastcall ListFiles(const TListFilesDir ListFilesDir = (TListFilesDir)(0x0));
	void __fastcall ReloadFileList();
	void __fastcall SetCheckMark(Vcl::Comctrls::TListItem* const AListItem, const bool NewValue);
	void __fastcall CheckFile(Vcl::Comctrls::TListItem* const AListItem);
	void __fastcall SetImported(Vcl::Comctrls::TListItem* const AListItem, const bool NewValue);
	void __fastcall GroupTrips(bool Group);
	void __fastcall SetRouteParm(TRouteParm ARouteParm, System::Byte Value);
	void __fastcall CheckTrips();
	void __fastcall ShowWarnRecalc();
	void __fastcall ShowWarnOverWrite(const System::UnicodeString AFile);
	void __fastcall ReadDefaultFolders();
	void __fastcall ReadSettings();
	void __fastcall ClearTripInfo();
	
protected:
	virtual void __fastcall CreateWnd();
	virtual void __fastcall DestroyWnd();
	
public:
	_TFrmTripManager__1 DeviceFolder;
	void __fastcall SetFixedPrefs();
	void __fastcall CheckSupportedModel();
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmTripManager(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmTripManager(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFrmTripManager(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmTripManager() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmTripManager(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define SelectMTPDevice L"Select an MTP device"
#define UpDirString L".."
#define GpxExtension L"gpx"
#define GpxMask L"*.gpx"
#define TripExtension L"trip"
#define TripMask L"*.trip"
#define GPIExtension L"gpi"
#define GPIMask L"*.gpi"
#define UnlExtension L"unl"
#define HtmlExtension L"html"
#define KmlExtension L"kml"
#define DefaultCoordinates L"48.854918, 2.346558"
#define SavedMapPosition_Key L"SavedMapPosition"
#define CurrentTrip L"CurrentTrip"
#define CurrentGPI L"CurrentGPI"
#define FileSysTrip L"FileSys"
#define TripManagerReg_Key L"Software\\TDBware\\TripManager"
#define PrefFileSysFolder_Key L"PrefFileSysFolder"
#define PrefDev_Key L"PrefDevice"
#define PrefDevTripsFolder_Key L"PrefDeviceTripsFolder"
#define PrefDevGpxFolder_Key L"PrefDeviceGpxFolder"
#define PrefDevPoiFolder_Key L"PrefDevicePoiFolder"
#define WarnModel_Key L"WarnModel"
extern DELPHI_PACKAGE Ufrmtripmanager__1 BooleanValues;
extern DELPHI_PACKAGE TFrmTripManager* FrmTripManager;
}	/* namespace Ufrmtripmanager */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMTRIPMANAGER)
using namespace Ufrmtripmanager;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UFrmTripManagerHPP
