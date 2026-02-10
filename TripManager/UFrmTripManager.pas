unit UFrmTripManager;

{$IFDEF DEBUG}
{.$DEFINE DEBUG_TRANSFER}  // Creates the files in temp, but does not transfer.
{$ENDIF}

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.WebView2, WinApi.ShlObj, System.Win.ComObj, Winapi.ActiveX,

  System.SysUtils, System.Variants, System.Classes, System.ImageList, System.Actions,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ImgList,
  Vcl.Grids, Vcl.ValEdit, Vcl.Menus, Vcl.Mask, Vcl.Buttons, Vcl.Edge, Vcl.Shell.ShellCtrls, Vcl.ToolWin,
  Vcl.ButtonGroup, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.DBGrids, Vcl.DBCtrls,
  Data.Db, Datasnap.DBClient,
  Monitor, BCHexEditor, mtp_helper, TripManager_ShellTree, TripManager_ShellList, TripManager_ValEdit, TripManager_ComboBox,
  UnitListViewSort, UnitMtpDevice, UnitTripDefs, UnitTripObjects, UnitGpxDefs, UnitGpxObjects, UnitGpi,
  UnitUSBEvent, Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.VirtualImageList;

const
  SelectMTPDevice         = 'Select an MTP device';
  UpDirString             = '..';

  GpxExtension            = '.gpx';
  GpxMask                 = '*' + GpxExtension;

  TripExtension           = '.trip';
  TripMask                = '*' + TripExtension;

  GPIExtension            = '.gpi';
  GPIMask                 = '*' + GPIExtension;
  UnlExtension            = '.unl';

  HtmlExtension           = '.html';
  KmlExtension            = '.kml';
  FitExtension            = '.fit';
  DBExtension             = '.db';
  CurrentMapItem          = 'CurrentMapItem';

  FileSysTrip             = 'FileSys';
  CompareTrip             = 'Compare';

  WM_DIRCHANGED           = WM_USER + 1;
  WM_ADDRLOOKUP           = WM_USER + 2;

  TripNameCol             = 5;
  TripNameColWidth        = 250;

  OnlineHelp              = 'https://frankbijnen.github.io/TripManager/';
  LocalHelp               = 'ChmDocs/TripManager.chm';

type
  // Get Access to Col of DBGrid
  TDBGrid = class(Vcl.DBGrids.TDBGrid)
  end;

  TMapReq = record
    Coords: string;
    Desc: string;
    Zoom: string;
    TimeOut: string;
  end;

  TDirType = (NoDir, Up, Down);
  TListFilesDir = (lfCurrent, lfUp, lfDown);

  TRouteParm = (RoutePref, TransportMode);

  TFrmTripManager = class(TForm)
    HSplitterDevFiles_Info: TSplitter;
    ImageList: TImageList;
    HexPanel: TPanel;
    VSplitterTripInfo_HexOSM: TSplitter;
    PnlHexEditTrip: TPanel;
    PnlXTAndFileSys: TPanel;
    LstFiles: TListView;
    VSplitterDev_Files: TSplitter;
    PCTTripInfo: TPageControl;
    TsTripGpiInfo: TTabSheet;
    VSplitterTree_Grid: TSplitter;
    TvTrip: TTreeView;
    VlTripInfo: TripManager_ValEdit.TValueListEditor;
    PctHexOsm: TPageControl;
    TsHex: TTabSheet;
    TsOSMMap: TTabSheet;
    AdvPanel_MapTop: TPanel;
    EditMapCoords: TEdit;
    AdvPanel_MapBottom: TPanel;
    EditMapBounds: TEdit;
    EdgeBrowser1: TEdgeBrowser;
    CmbDevices: TripManager_ComboBox.TComboBox;
    PnlXTLeft: TPanel;
    PnlFileSys: TPanel;
    ShellTreeView1: TripManager_ShellTree.TShellTreeView;
    VSplitterFile_Sys: TSplitter;
    ShellListView1: TripManager_ShellList.TShellListView;
    PnlXt2FileSys: TPanel;
    PnlFileSysFunc: TPanel;
    BtnAddToMap: TButton;
    BtnSaveTripGpiFile: TButton;
    PnlVlTripInfo: TPanel;
    PnlVlTripInfoTop: TPanel;
    BtnSaveTripValues: TButton;
    BtnApplyCoords: TButton;
    LblRoutePoint: TEdit;
    PnlCoordinates: TPanel;
    PnlRoutePoint: TPanel;
    SpeedBtn_MapClear: TSpeedButton;
    LblRoute: TEdit;
    EdDeviceFolder: TEdit;
    PnlDeviceTop: TPanel;
    BtnRefresh: TButton;
    EdFileSysFolder: TripManager_ComboBox.TComboBox;
    BgDevice: TButtonGroup;
    BtnSetDeviceDefault: TButton;
    DeviceMenu: TPopupMenu;
    FileFunctions1: TMenuItem;
    N1: TMenuItem;
    TripFunctions1: TMenuItem;
    BtnFunctions: TButton;
    N3: TMenuItem;
    Setselectedtripstosaved1: TMenuItem;
    Setselectedtripstoimported1: TMenuItem;
    DeleteFiles: TMenuItem;
    N2: TMenuItem;
    Rename1: TMenuItem;
    TripGpiTimer: TTimer;
    N4: TMenuItem;
    Setdeparturedatetimeofselected1: TMenuItem;
    N5: TMenuItem;
    Renameselectedtripfilestotripname1: TMenuItem;
    Groupselectedtrips1: TMenuItem;
    Ungroupselectedtrips1: TMenuItem;
    N6: TMenuItem;
    MnuSetTransportMode: TMenuItem;
    Automotive1: TMenuItem;
    MotorCycling1: TMenuItem;
    OffRoad1: TMenuItem;
    MnuSetRoutePref: TMenuItem;
    Fastertime1: TMenuItem;
    Shorterdistance1: TMenuItem;
    Directrouting1: TMenuItem;
    Curvyroads1: TMenuItem;
    BtnFromDev: TButton;
    BtnToDev: TButton;
    PnlTopFiller: TPanel;
    BtnRefreshFileSys: TButton;
    PnlBotFileSys: TPanel;
    BtnOpenTemp: TButton;
    MapTimer: TTimer;
    PnlTripGpiInfo: TPanel;
    CmbModel: TripManager_ComboBox.TComboBox;
    BtnPostProcess: TButton;
    ChkWatch: TCheckBox;
    OpenTrip: TOpenDialog;
    ActionMainMenuBar: TActionMainMenuBar;
    ActionManager: TActionManager;
    ActAbout: TAction;
    ActOnline: TAction;
    PopupTripInfo: TPopupMenu;
    CopyValueFromTrip: TMenuItem;
    ActSettings: TAction;
    N7: TMenuItem;
    SaveCSV1: TMenuItem;
    SaveTrip: TSaveDialog;
    SaveGPX1: TMenuItem;
    BtnGeoSearch: TSpeedButton;
    BtnTripEditor: TButton;
    SpltRoutePoint: TSplitter;
    PopupTripEdit: TPopupMenu;
    MnuTripNewMTP: TMenuItem;
    MnuTripEdit: TMenuItem;
    NewtripWindows1: TMenuItem;
    ChkZoomToPoint: TCheckBox;
    SbPostProcess: TStatusBar;
    LblBounds: TLabel;
    StatusTimer: TTimer;
    BtnSendTo: TButton;
    N8: TMenuItem;
    MnuCompareGpxRoute: TMenuItem;
    N9: TMenuItem;
    DeleteDirs: TMenuItem;
    NewDirectory: TMenuItem;
    MnuNextDiff: TMenuItem;
    MnuPrevDiff: TMenuItem;
    MnuCompareGpxTrack: TMenuItem;
    CompareTriptoGPX1: TMenuItem;
    N11: TMenuItem;
    N10: TMenuItem;
    CheckandFixcurrentgpx1: TMenuItem;
    TsSQlite: TTabSheet;
    PnlSQliteTop: TPanel;
    DbgDeviceDb: TDBGrid;
    DsDeviceDb: TDataSource;
    CdsDeviceDb: TClientDataSet;
    DBMemo: TMemo;
    SpltGridBlob: TSplitter;
    SaveBlob: TSaveDialog;
    MemoSQL: TMemo;
    PnlQuickSql: TPanel;
    LblSqlResults: TLabel;
    PnlQuickSqlGo: TPanel;
    CmbSQliteTabs: TComboBox;
    BitBtnSQLGo: TBitBtn;
    ActInstalledDoc: TAction;
    N12: TMenuItem;
    MnuTripOverview: TMenuItem;
    N13: TMenuItem;
    Explore1: TMenuItem;
    MnuQueryDeviceDb: TMenuItem;
    N14: TMenuItem;
    PopupAddToMap: TPopupMenu;
    MnuAddtoMap: TMenuItem;
    MnuOpenInKurviger: TMenuItem;
    N15: TMenuItem;
    TsExplore: TTabSheet;
    CompareEploredbwithTrips1: TMenuItem;
    LvExplore: TListView;
    PnlExploreTop: TPanel;
    VirtualImageListExplore: TVirtualImageList;
    ImageCollectionExplore: TImageCollection;
    SpbRefreshExplore: TSpeedButton;
    SpbCorrectUuid: TSpeedButton;
    Exploredb1: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    OpeninKurviger1: TMenuItem;
    Addtomap1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure LstFilesDblClick(Sender: TObject);
    procedure LstFilesDeletion(Sender: TObject; Item: TListItem);
    procedure LstFilesColumnClick(Sender: TObject; Column: TListColumn);
    procedure LstFilesCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure LstFilesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure LstFilesItemChecked(Sender: TObject; Item: TListItem);
    procedure FormShow(Sender: TObject);
    procedure BtnSaveTripGpiFileClick(Sender: TObject);
    procedure ValueListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TvTripChange(Sender: TObject; Node: TTreeNode);
    procedure EdgeBrowser1CreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
    procedure EdgeBrowser1NavigationStarting(Sender: TCustomEdgeBrowser; Args: TNavigationStartingEventArgs);
    procedure EdgeBrowser1WebMessageReceived(Sender: TCustomEdgeBrowser; Args: TWebMessageReceivedEventArgs);
    procedure EdgeBrowser1ZoomFactorChanged(Sender: TCustomEdgeBrowser; AZoomFactor: Double);
    procedure EditMapCoordsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CmbDevicesChange(Sender: TObject);
    procedure ShellListView1AddFolder(Sender: TObject; AFolder: TShellFolder; var CanAdd: Boolean);
    procedure ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ShellListView1Click(Sender: TObject);
    procedure SpeedBtn_MapClearClick(Sender: TObject);
    procedure VlTripInfoStringsChange(Sender: TObject);
    procedure VlTripInfoEditButtonClick(Sender: TObject);
    procedure BtnSaveTripValuesClick(Sender: TObject);
    procedure BtnApplyCoordsClick(Sender: TObject);
    procedure TvTripCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure BtnFunctionsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetSelectedTrips(Sender: TObject);
    procedure BtnSetDeviceDefaultClick(Sender: TObject);
    procedure TripGpiTimerTimer(Sender: TObject);
    procedure DeleteFilesClick(Sender: TObject);
    procedure RenameFile(Sender: TObject);
    procedure Setdeparturedatetimeofselected1Click(Sender: TObject);
    procedure Renameselectedtripfilestotripname1Click(Sender: TObject);
    procedure Groupselectedtrips1Click(Sender: TObject);
    procedure Ungroupselectedtrips1Click(Sender: TObject);
    procedure TransportModeClick(Sender: TObject);
    procedure RoutePreferenceClick(Sender: TObject);
    procedure PostProcessClick(Sender: TObject);
    procedure BgDeviceClick(Sender: TObject);
    procedure BtnOpenTempClick(Sender: TObject);
    procedure DeviceMenuPopup(Sender: TObject);
    procedure BtnFromDevClick(Sender: TObject);
    procedure BtnToDevClick(Sender: TObject);
    procedure BtnRefreshFileSysClick(Sender: TObject);
    procedure AdvPanel_MapTopResize(Sender: TObject);
    procedure ShellTreeView1CustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure EdDeviceFolderKeyPress(Sender: TObject; var Key: Char);
    procedure EdFileSysFolderKeyPress(Sender: TObject; var Key: Char);
    procedure MapTimerTimer(Sender: TObject);
    procedure ShellListView1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ShellListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure LstFilesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ChkWatchClick(Sender: TObject);
    procedure ShellListView1DblClick(Sender: TObject);
    procedure ActAboutExecute(Sender: TObject);
    procedure ActOnlineExecute(Sender: TObject);
    procedure CopyValueFromTripClick(Sender: TObject);
    procedure ActSettingsExecute(Sender: TObject);
    procedure SaveCSV1Click(Sender: TObject);
    procedure SaveGPX1Click(Sender: TObject);
    procedure BtnGeoSearchClick(Sender: TObject);
    procedure BtnTripEditorMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MnuTripEditClick(Sender: TObject);
    procedure MnuTripNewMTPClick(Sender: TObject);
    procedure NewtripWindows1Click(Sender: TObject);
    procedure PopupTripEditPopup(Sender: TObject);
    procedure PCTTripInfoResize(Sender: TObject);
    procedure ShellListView1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure StatusTimerTimer(Sender: TObject);
    procedure CmbModelChange(Sender: TObject);
    procedure BtnSendToClick(Sender: TObject);
    procedure VlTripInfoBeforeDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect; State: TGridDrawState);
    procedure CompareWithGpx(Sender: TObject);
    procedure PopupTripInfoPopup(Sender: TObject);
    procedure DeleteDirsClick(Sender: TObject);
    procedure NewDirectoryClick(Sender: TObject);
    procedure MnuNextDiffClick(Sender: TObject);
    procedure MnuPrevDiffClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CheckandFixcurrentgpx1Click(Sender: TObject);
    procedure BgDeviceItemsTripsClick(Sender: TObject);
    procedure CmbSQliteTabsChange(Sender: TObject);
    procedure CdsDeviceDbAfterOpen(DataSet: TDataSet);
    procedure CdsDeviceDbAfterScroll(DataSet: TDataSet);
    procedure DbgDeviceDbColEnter(Sender: TObject);
    procedure DBMemoDblClick(Sender: TObject);
    procedure BitBtnSQLGoClick(Sender: TObject);
    procedure MemoSQLKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActInstalledDocExecute(Sender: TObject);
    procedure ActInstalledDocUpdate(Sender: TObject);
    procedure BgDeviceItemsPoiClick(Sender: TObject);
    procedure MnuTripOverviewClick(Sender: TObject);
    procedure EdFileSysFolderCloseUp(Sender: TObject);
    procedure BgDeviceItemsGpxClick(Sender: TObject);
    procedure BtnAddToMapMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MnuAddtoMapClick(Sender: TObject);
    procedure MnuOpenInKurvigerClick(Sender: TObject);
    procedure CompareEploredbwithTrips1Click(Sender: TObject);
    procedure SpbRefreshExploreClick(Sender: TObject);
    procedure SpbCorrectUuidClick(Sender: TObject);
    procedure QueryDeviceClick(Sender: TObject);
    procedure ShowDeviceFilesOnMap(Sender: TObject);
    procedure PnlDeviceTopResize(Sender: TObject);
  private
    { Private declarations }
    DeviceFile: Boolean;
    HexEditFile: string;
    SqlFile: string;
    ExploreList: TStringList;

    CurrentDevice: TMTP_Device;
    FSavedParent: WideString;
    FSavedFolderId: WideString;

    FCurrentPath: WideString;
    DeviceList: TList;
    FSortSpecification: TSortSpecification;
    HexEdit: TBCHexEditor;
    ATripList: TTripList;
    APOIList: TPOIList;
    AFitInfo: TStringList;

    WarnRecalc: integer; // MrNone, MrYes, MrNo, mrIgnore
    WarnOverWrite: integer;  // MrNone, MrYes, MrNo, mrYesToAll, mrNoToAll
    ModifiedList: TStringList;
    DirectoryMonitor: TDirectoryMonitor;

    FMapReq: TMapReq;
    EdgeZoom: double;
    RoutePointTimeOut: string;
    GeoSearchTimeOut: string;
    USBEvent: TUSBEvent;

    procedure DirectoryEvent(Sender: TObject; Action: TDirectoryMonitorAction; const FileName: WideString);
    function WaitForDevice(const DeviceToWaitFor: string): integer;
    procedure USBChangeEvent(const Inserted : boolean; const DeviceName, VendorId, ProductId: string);
    procedure ConnectedDeviceChanged(const Device, Status: string);
    procedure FileSysDrop(var Msg: TWMDROPFILES); message WM_DROPFILES;
    function SelectedScPosn: TmScPosn;
    function SelectedLocation: TLocation;
    procedure EnableApplyCoords;
    procedure ClearSelHexEdit;
    procedure SyncHexEdit(Sender: TObject);
    procedure VlTripInfoSelectionMoved(Sender: TObject);
    procedure HexEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure HexEditKeyPress(Sender: TObject; var Key: Char);
    procedure LoadHex(const FileName: string);
    procedure LoadTripOnMap(CurrentTrip: TTripList; Id: string);
    procedure LoadGpiOnMap(CurrentGpi: TPOIList; Id: string);
    procedure LoadFitOnMap(FitAsGpxFile: string; Id: string);
    procedure AddToMap(FileName: string);
    procedure DeviceFilesOnMap(Tag: integer);

    procedure OpenInKurviger(const FileName: string);
    procedure MapRequest(const Coords, Desc, TimeOut: string;
                         const ZoomLevel: string = '');
    procedure SaveTripGpiFile;
    procedure LoadTripFile(const FileName: string; const FromDevice: boolean);
    procedure LoadGpiFile(const FileName: string; const FromDevice: boolean);
    procedure LoadFitFile(const FileName: string; const FromDevice: boolean);
    procedure LoadSqlFile(const FileName: string; const FromDevice: boolean);
    procedure FreeDeviceData(const ACustomData: pointer);
    procedure FreeDevices;
    function CopyDeviceFile(const APath, AFile: string): boolean;
    procedure GetBlob(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure GetGUID(Sender: TField; var Text: string; DisplayText: Boolean);
    function GetDbPath: string;
    procedure ClearDeviceDbFiles;
    procedure RebuildTransportAndRoutePrefMenu;
    procedure RebuildDeviceDbMenu;
    procedure ReadDeviceDB;
    procedure ReadGarminDevice(const ModelDescription: string);
    procedure GuessModel(const DisplayedDevice: string);
    procedure SelectDevice(const Indx: integer);
    procedure SelectKnownDevice;
    procedure SelectDeviceById(const Device: string);
    function GetItemType(const AListview: TListView): TDirType;
    procedure CloseDevice;
    function CheckDevice(RaiseException: boolean = true): boolean;
    procedure GetDeviceList(KeepDevice: string = '');
    function GetDevicePath(const CompletePath: string): string;
    procedure SetDeviceDisplayPath;
    function GetSelectedFile: string;
    procedure SetSelectedFile(AFile: string);
    procedure SetCurrentPath(const APath: string);
    function CopyFileToTmp(const AListItem: TListItem): string;
    procedure CopyFileFromTmp(const LocalFile: string; const AListItem: TListItem);
    procedure ListFiles(const ListFilesDir: TListFilesDir = TListFilesDir.lfCurrent);
    procedure DeleteObjects(const AllowRecurse: boolean);
    procedure ReloadFileList;
    procedure SetCheckMark(const AListItem: TListItem; const NewValue: boolean);
    procedure SetImported(const AListItem: TListItem; const NewValue: boolean);
    procedure GroupTrips(Group: Boolean);
    procedure SetRouteParm(ARouteParm: TRouteParm; Value: byte);
    procedure CheckExploreDb;
    function CheckTrip(const AListItem: TListItem; const ALocalFile: string = ''): boolean;
    procedure CheckTrips;
    procedure RecreateTrips;
    procedure ShowWarnRecalc;
    procedure ShowWarnOverWrite(const AFile: string);
    procedure ReadDefaultFolders;
    procedure SetDeviceListColumns;
    procedure ReadColumnSettings;
    procedure WriteColumnSettings;
    procedure OnSetPostProcessPrefs(Sender: TObject);
    procedure OnSetSendToPrefs(Sender: TObject);
    procedure ReadSettings;
    procedure ClearTripInfo;
    procedure InstallTripEdit;
    procedure EditTrip(NewFile: boolean);
    procedure SyncDiff(Sender: TObject);
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure WMDirChanged(var Msg: TMessage); message WM_DIRCHANGED;
    procedure WMAddrLookUp(var Msg: TMessage); message WM_ADDRLOOKUP;
  public
    { Public declarations }
    DeviceFolder: array[0..2] of string;
    procedure ReloadTripOnMap(Sender: TObject);
    procedure RoutePointsShowing(Sender: TObject; Showing: boolean);
    procedure RoutePointUpdated(Sender: TObject);
    procedure TripFileUpdating(Sender: TObject);
    procedure TripFileCanceled(Sender: TObject);
    procedure TripFileUpdated(Sender: TObject);
    function GetMapCoords: string;
  end;

var
  FrmTripManager: TFrmTripManager;

implementation

uses
  System.StrUtils, System.UITypes, System.DateUtils, System.TypInfo, System.IOUtils, System.Generics.Collections,
  Winapi.ShellAPI,
  Vcl.Clipbrd,
  MsgLoop, UnitProcessOptions, UnitRegistry, UnitRegistryKeys, UnitStringUtils, UnitSqlite,
  UnitOSMMap, UnitGeoCode, UnitVerySimpleXml, UnitRedirect, UnitGpxTripCompare, UnitModelConv,
  UDmRoutePoints, TripManager_GridSelItem,
  UFrmDateDialog, UFrmPostProcess, UFrmSendTo, UFrmAdvSettings, UFrmTripEditor, UFrmNewTrip,
  UFrmSelectGPX, UFrmShowLog, UFrmEditRoutePref;

const
  DupeCount = 10;

{$R *.dfm}

var
  FormatSettings: TFormatSettings;

function OffsetInRecord(const Base; const Field): IntPtr;
begin
  result := IntPtr(@Field) - IntPtr(@Base);
end;

procedure DeleteTempFiles(const ATempPath, AMask: string);
var
  Fs: TSearchRec;
  Rc: integer;
begin
  Rc := FindFirst(IncludeTrailingPathDelimiter(ATempPath) + AMask, faAnyFile - faDirectory, Fs);
  while (Rc = 0) do
  begin
    DeleteFile(IncludeTrailingPathDelimiter(ATempPath) + Fs.Name);
    Rc := FindNext(Fs);
  end;
  FindClose(Fs);
end;

procedure DeleteCompareFiles;
begin
  DeleteTempFiles(GetOSMTemp, Format('\%s_%s%s%s',
                                     [App_Prefix,
                                     CompareTrip,
                                     '*',
                                     GetTracksExt]));
end;

procedure DeleteTripTrackFiles;
begin
  DeleteTempFiles(GetOSMTemp, Format('\%s_%s_track%s', [App_Prefix, CurrentMapItem, GetTracksExt]));
end;

function TFrmTripManager.CopyDeviceFile(const APath, AFile: string): boolean;
var
  CurrentObjectId, FolderId: widestring;
  FriendlyPath: string;
begin
  result := false;
  if not CheckDevice(false) then
    exit;

  FolderId := GetIdForPath(CurrentDevice.PortableDev, APath, FriendlyPath);
  if (FolderId = '') then
    exit;

  // Get Id of File
  CurrentObjectId := GetIdForFile(CurrentDevice.PortableDev, FolderId, AFile);
  if (CurrentObjectId = '') then
    exit;

  ForceDirectories(GetDeviceTmp);
  if not GetFileFromDevice(CurrentDevice.PortableDev, CurrentObjectId, GetDeviceTmp, AFile) then
    exit;

  result := true;
end;

function TFrmTripManager.GetDbPath: string;
var
  ModelIndex: integer;
  SubKey, DbPath: string;
  LDelim: integer;
begin
  // Location of SQLite. Normally Internal Storage\.System\SQlite but taken from settings
  ModelIndex := GetRegistry(Reg_CurrentModel, 0);

  SubKey := IntToStr(ModelIndex);
  DbPath := ExcludeTrailingPathDelimiter(GetRegistry(Reg_PrefDevTripsFolder_Key,
                                         TModelConv.GetKnownPath(ModelIndex, 0),
                                         SubKey));
  LDelim := LastDelimiter('\', DbPath) -1;
  DbPath := Copy(DbPath, 1, LDelim) + '\SQlite';
  if (GetIdForPath(CurrentDevice.PortableDev, DbPath, result) = '') then
    result := '';
end;

procedure TFrmTripManager.ReadDeviceDB;
var
  DBPath: string;
  NewVehicle_Profile, OldVehicle_Profile: TVehicleProfile;
  ModelIndex, DefAdvLevel: integer;
begin
  ClearDeviceDbFiles;
  if not CheckDevice(false) then
    exit;

  // Needed for checking if the connected Device needs reading SQlite
  ModelIndex := GetRegistry(Reg_CurrentModel, 0);

  // SQLite path
  DBPath := GetDbPath;
  if (DBPath = '') then
    exit;

  // Copy settings.db, Update Avoidances changed
  if (TModelConv.Display2Garmin(ModelIndex) in [TGarminModel.XT2, TGarminModel.Tread2]) and
     (CopyDeviceFile(DBPath, SettingsDb)) then
    SetRegistry(Reg_AvoidancesChangedTimeAtSave, GetAvoidancesChanged(GetDeviceTmp + SettingsDb));

  // Copy vehicle_profile.db
  if (TModelConv.Display2Garmin(ModelIndex) in [TGarminModel.XT2, TGarminModel.Tread2]) and
     (CopyDeviceFile(DBPath, ProfileDb)) then
  begin
    OldVehicle_Profile.GUID             := UTF8String(GetRegistry(Reg_VehicleProfileGuid, ''));
    OldVehicle_Profile.Vehicle_Id       := GetRegistry(Reg_VehicleId, 0);
    OldVehicle_Profile.TruckType        := GetRegistry(Reg_VehicleProfileTruckType, 0);
    OldVehicle_Profile.Name             := UTF8String(GetRegistry(Reg_VehicleProfileName, ''));
    OldVehicle_Profile.VehicleType      := GetRegistry(Reg_VehicleType, 0);
    OldVehicle_Profile.TransportMode    := GetRegistry(Reg_VehicleTransportMode, 0);

    NewVehicle_Profile := GetVehicleProfile(GetDeviceTmp + ProfileDb, TModelConv.Display2Garmin(ModelIndex));

    if (NewVehicle_Profile.Valid) and
       (NewVehicle_Profile.Changed(OldVehicle_Profile)) then
    begin
      // Update Vehicle profile
      SetRegistry(Reg_VehicleProfileGuid,       string(NewVehicle_Profile.GUID));
      SetRegistry(Reg_VehicleId,                NewVehicle_Profile.Vehicle_Id);
      SetRegistry(Reg_VehicleProfileTruckType,  NewVehicle_Profile.TruckType);
      SetRegistry(Reg_VehicleProfileName,       string(NewVehicle_Profile.Name));
      SetRegistry(Reg_VehicleType,              NewVehicle_Profile.VehicleType);
      SetRegistry(Reg_VehicleTransportMode,     NewVehicle_Profile.TransportMode);

      // Changed Vehicle profile. Set hash to 0
      SetRegistry(Reg_VehicleProfileHash, 0);

      // Only load Default Adventurous level from profile if invalid
      DefAdvLevel := GetRegistry(Reg_DefAdvLevel, 0);
      if not (DefAdvLevel in [1..4]) then
        SetRegistry(Reg_DefAdvLevel,            NewVehicle_Profile.AdventurousLevel +1);
    end;
  end;

  // Copy explore.db
  if (GetRegistry(Reg_EnableExploreFuncs, false)) and
     (TModelConv.Display2Garmin(ModelIndex) in [TGarminModel.XT, TGarminModel.XT2, TGarminModel.Tread2]) and
     (CopyDeviceFile(DBPath, ExploreDb)) then
    GetExploreList(IncludeTrailingPathDelimiter(GetDeviceTmp) + ExploreDb, ExploreList);

  RebuildDeviceDbMenu;
end;

procedure TFrmTripManager.ReadGarminDevice(const ModelDescription: string);
var
  CurDevId, DevId: integer;
  NFile, FriendlyPath: string;
  XmlDoc: TXmlVSDocument;
  DeviceNode, ModelNode, MassStorageNode: TXmlVSNode;

  function GetPath(CheckNode: TXmlVSNode; AName, Direction, AExt: string): string;
  var
    NewPath, FriendlyPath: string;
    DataTypeNode, FileNode, LocationNode: TXmlVSNode;
  begin
    result := '';
    for DataTypeNode in CheckNode.ChildNodes do
    begin
      if not (SameText(FindSubNodeValue(DataTypeNode, 'Name'), AName)) then
        continue;
      for FileNode in DataTypeNode.ChildNodes do
      begin
        if (FindSubNodeValue(FileNode, 'TransferDirection') <> Direction) then
          continue;
        LocationNode := FileNode.Find('Location');
        if (Assigned(LocationNode)) and
           (SameText(FindSubNodeValue(LocationNode, 'FileExtension'), AExt)) then
        begin
          NewPath := ReplaceAll(FindSubNodeValue(LocationNode, 'Path'), ['/'], ['\']);
          result := Format('%s%s', [NonMTPRoot, NewPath]);
          if (GetIdForPath(CurrentDevice.PortableDev, result, FriendlyPath) <> '') then
            exit
          else
            exit(Format('%s%s', [InternalStorage, NewPath]));
        end;
      end;
    end;
  end;

begin

  GarminDevice.Init;
  GarminDevice.ModelDescription := ModelDescription;
  GarminDevice.GarminModel := TModelConv.GetModelFromGarminDevice(GarminDevice);

  // Need a device to check better
  if not CheckDevice(false) then
    exit;

  // Location of GarminDevice.Xml
  NFile := GarminDeviceXML;

  // Copy and read GarminDevice.xml
  CurDevId := CurrentDevice.Id;
  DeleteFile(GetDeviceTmp + NFile);
  try
    if not (CopyDeviceFile(NonMTPRoot + GarminPath, NFile)) and
       not (CopyDeviceFile(InternalStorage + GarminPath, NFile)) then
    begin
      // There is no garmindevice in ?:\Garmin, or Internal Storage\Garmin
      // Check other devices with the same serialId.
      // It could be the SD Card, or a hidden MTP partition as found with the 595
      for DevId := 0 to DeviceList.Count -1 do
      begin
        if DevId = CurDevId then
          continue;
        if (TMTP_Device(DeviceList[DevId]).Serial = TMTP_Device(DeviceList[CurDevId]).Serial) then
        begin
          CurrentDevice := DeviceList[DevId];
          if (ConnectToDevice(CurrentDevice.Device, CurrentDevice.PortableDev, true)) then
          begin
            if (CopyDeviceFile(NonMTPRoot + GarminPath, NFile)) or
               (CopyDeviceFile(InternalStorage + GarminPath, NFile)) then
             break;
          end;
        end;
      end;
    end;
  finally
    CurrentDevice := DeviceList[CurDevId];
  end;

  // Do we have the XML?
  if (FileExists(GetDeviceTmp + NFile)) then
  begin
    XmlDoc := TXmlVSDocument.Create;
    try
      XmlDoc.LoadFromFile(GetDeviceTmp + NFile);
      DeviceNode := XmlDoc.ChildNodes.Find('Device');
      if (DeviceNode = nil) then
        exit;
      ModelNode := DeviceNode.Find('Model');
      if (ModelNode = nil) then
        exit;
      MassStorageNode := DeviceNode.Find('MassStorageMode');

      // Update model from GarminDevice.xml
      GarminDevice.ModelDescription := FindSubNodeValue(ModelNode, 'Description');
      GarminDevice.PartNumber := FindSubNodeValue(ModelNode, 'PartNumber');
      GarminDevice.GarminModel := TModelConv.GetModelFromGarminDevice(GarminDevice);

      case GarminDevice.GarminModel of
        TGarminModel.Zumo595,
        TGarminModel.Zumo590,
        TGarminModel.Drive51,
        TGarminModel.Zumo3x0,
        TGarminModel.Nuvi2595:
          if (GetIdForPath(CurrentDevice.PortableDev, NonMTPRoot + SystemTripsPath, FriendlyPath) = '') then
            GarminDevice.GarminModel := TGarminModel.GarminGeneric; // No .System\Trips. Use it as a Generic Garmin
        TGarminModel.Unknown:
          GarminDevice.GarminModel := TModelConv.GuessGarminOrEdge(GarminDevice.ModelDescription);
      end;

      // Get default paths
      if (Assigned(MassStorageNode)) then
      begin
        GarminDevice.GpxPath := GetPath(MassStorageNode, 'GPSData', 'InputToUnit', 'gpx');
        GarminDevice.GpiPath := GetPath(MassStorageNode, 'CustomPOI', 'InputToUnit', 'gpi');
        GarminDevice.CoursePath := GetPath(MassStorageNode, 'FIT_TYPE_6', 'OutputFromUnit', 'fit');
        GarminDevice.NewFilesPath := GetPath(MassStorageNode, 'FIT_TYPE_6', 'InputToUnit', 'fit');
        GarminDevice.ActivitiesPath := GetPath(MassStorageNode, 'FIT_TYPE_4', 'OutputFromUnit', 'fit');
      end;
    finally
      XmlDoc.Free;
    end;
  end;

end;

procedure TFrmTripManager.GuessModel(const DisplayedDevice: string);
var
  ModelIndex: integer;
begin
  ReadGarminDevice(DisplayedDevice);

  ModelIndex := TModelConv.Garmin2Display(GarminDevice.GarminModel);

  // Change description for 'old' Garmin units and Edge
  CmbModel.items[TModelConv.Garmin2Display(TGarminModel.GarminEdge)] := Edge_Name;
  CmbModel.items[TModelConv.Garmin2Display(TGarminModel.GarminGeneric)] := Garmin_Name;
  if (ModelIndex = TModelConv.Garmin2Display(TGarminModel.GarminEdge)) or
     (ModelIndex = TModelConv.Garmin2Display(TGarminModel.GarminGeneric)) then
  begin
    if (DisplayedDevice <> CmbModel.Items[ModelIndex]) and
       (GarminDevice.ModelDescription <> '') then
      CmbModel.Items[ModelIndex] := GarminDevice.ModelDescription;
  end;
  CmbModel.AdjustWidths;

  // Model changed?
  if (ModelIndex <> CmbModel.ItemIndex) then
  begin
    CmbModel.ItemIndex := ModelIndex;
    CmbModelChange(CmbModel);
  end;

  SetRegistry(Reg_CurrentModel, ModelIndex);
  ReadDefaultFolders;
end;

// No need to close manually.
procedure TFrmTripManager.CloseDevice;
begin
  CurrentDevice := nil;
end;

procedure TFrmTripManager.GetBlob(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := ReplaceAll(Copy(Sender.AsString, 1, 1024), [#0, #9, #10], ['.', '.', ' ']);
end;

procedure TFrmTripManager.GetGUID(Sender: TField; var Text: string; DisplayText: Boolean);
var
  B: TBytes;
  Index: integer;
begin
  Text := '';
  B := Sender.AsBytes;
  if Length(B) < 16 then
    exit;
  for Index := 0 to 3 do
    Text := Text + IntToHex(B[Index], 2);
  Text := text + '-';
  for Index := 4 to 5 do
    Text := Text + IntToHex(B[Index], 2);
  Text := text + '-';
  for Index := 6 to 7 do
    Text := Text + IntToHex(B[Index], 2);
  Text := text + '-';
  for Index := 8 to 9 do
    Text := Text + IntToHex(B[Index], 2);
  Text := text + '-';
  for Index := 10 to 15 do
    Text := Text + IntToHex(B[Index], 2);
  Text := LowerCase(Text);
end;

procedure TFrmTripManager.CdsDeviceDbAfterOpen(DataSet: TDataSet);
var
  AField: TField;
begin
  for AField in DataSet.Fields do
  begin
    if (AField is TBlobField) then
    begin
      if (ContainsText(Afield.FieldName, 'UID')) then
      begin
        AField.OnGetText := GetGUID;
        Afield.DisplayWidth := 40;
      end
      else
      begin
        AField.OnGetText := GetBlob;
        AField.Tag := 1;
      end;
    end;
  end;
end;

procedure TFrmTripManager.CdsDeviceDbAfterScroll(DataSet: TDataSet);
var
  AField: TField;
  B: TBytes;
  Index: integer;
  TmpText: string;
begin
  if (Dataset.ControlsDisabled) then
    exit;

  AField := Dataset.FieldByName(DbgDeviceDb.Columns[DbgDeviceDb.Col -1].FieldName);
  if (AField.Tag = 1) then
  begin
    TmpText := Format('%sChars (Max. 1024):%s%s%s', [#10, #10, AField.DisplayText, #10]);

    B := AField.AsBytes;
    TmpText := Format('Blob size: %d (Double Click to save to file)%sHex Dump:%s', [Length(B), TmpText, #10]);
    for Index := 0 to Length(B) -1 do
    begin
      TmpText := TmpText + IntToHex(B[Index], 2);
      if ((Index+1) mod 4 = 0) then
        TmpText := TmpText + ' ';
    end;
    DBMemo.Lines.Text := TmpText;
  end
  else
    DBMemo.Lines.Text := Afield.DisplayText;
end;

procedure TFrmTripManager.DBMemoDblClick(Sender: TObject);
var
  AField: TField;
begin
  SaveBlob.InitialDir := ShellTreeView1.Path;
  AField := CdsDeviceDb.FieldByName(DbgDeviceDb.Columns[DbgDeviceDb.Col -1].FieldName);
  SaveBlob.FileName := Afield.FieldName;
  if (SaveBlob.Execute) then
    TFile.WriteAllBytes(SaveBlob.FileName, AField.AsBytes);
end;

procedure TFrmTripManager.CheckandFixcurrentgpx1Click(Sender: TObject);
var
  CurrentObjectId, FolderId: widestring;
  NFile, FriendlyPath: string;
  GpxFile: TGPXFile;
  FixMessages: TStringList;
  Rc: integer;
begin
  CheckDevice;

  FolderId := GetIdForPath(CurrentDevice.PortableDev, DeviceFolder[1], FriendlyPath);
  if (FolderId = '') then
    raise exception.Create(DeviceFolder[1] + ' not found');

  // Get Id of File
  NFile := 'Current.gpx';
  CurrentObjectId := GetIdForFile(CurrentDevice.PortableDev, FolderId, NFile);
  if (CurrentObjectId = '') then
    raise exception.Create(NFile + ' not found');

  if not GetFileFromDevice(CurrentDevice.PortableDev, CurrentObjectId, CreatedTempPath, NFile) then
    raise Exception.Create(Format('Copy %s from %s failed', [NFile, CurrentDevice.Device]));

  FixMessages := TStringList.Create;
  GpxFile := TGPXFile.Create(CreatedTempPath + NFile, '', nil, nil, FixMessages);
  try
    GpxFile.AnalyzeGpx;
    if (FixMessages.Text = '') then
    begin
      MessageDlg('No problems found', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
      exit;
    end;

    Rc := MessageDlg(FixMessages.Text + #10 + 'Continue with Fix?',
                     TMsgDlgType.mtWarning, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0);
    if (Rc = ID_YES) then
    begin
      GpxFile.FixCurrentGPX;
      if not DelFromDevice(CurrentDevice.PortableDev, CurrentObjectId) then
        raise exception.Create(Format('Deleting file %s failed', [NFile]));

      if (TransferNewFileToDevice(CurrentDevice.PortableDev, CreatedTempPath + NFile, FolderId) = '') then
        raise exception.Create(Format('Writing file %s failed', [NFile]));

      MessageDlg('Fix complete. Restart BaseCamp!', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
    end;
  finally
    GpxFile.Free;
    FixMessages.Free;
    DeleteFile(CreatedTempPath + NFile);
  end;

end;

function TFrmTripManager.CheckDevice(RaiseException: boolean = true): boolean;
var
  CrWait, CrNormal: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    result := Assigned(CurrentDevice) and
              Assigned(CurrentDevice.PortableDev) and
              (FirstStorageIds(CurrentDevice.PortableDev) <> nil);
    if (not result) and
       (RaiseException) then
      raise exception.Create('No MTP Device opened.');
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.ActAboutExecute(Sender: TObject);
begin
  ShowMessage(VerInfo);
end;

procedure TFrmTripManager.ActOnlineExecute(Sender: TObject);
begin
  ShellExecute(0, 'Open', OnlineHelp, '','', SW_SHOWNORMAL);
end;

procedure TFrmTripManager.ActSettingsExecute(Sender: TObject);
begin
  ParseLatLon(EditMapCoords.Text, FrmAdvSettings.SampleLat, FrmAdvSettings.SampleLon);
  FrmAdvSettings.SampleTrip := ATripList;
  if FrmAdvSettings.ShowModal = mrOk then
    ReadSettings;

  BgDeviceClick(BgDevice);
end;

procedure TFrmTripManager.ActInstalledDocExecute(Sender: TObject);
begin
  ShellExecute(0, 'Open', PChar(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + LocalHelp),
               '','', SW_SHOWNORMAL);
end;

procedure TFrmTripManager.ActInstalledDocUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FileExists(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + LocalHelp);
end;

procedure TFrmTripManager.AdvPanel_MapTopResize(Sender: TObject);
var
  SizeLeft: integer;
begin
  SizeLeft := AdvPanel_MapTop.Width - (PnlRoutePoint.Left + PnlRoutePoint.Width);
  LblRoute.Width := SizeLeft div 2;
end;

procedure TFrmTripManager.BgDeviceClick(Sender: TObject);
begin
  SetDeviceListColumns;

  if CheckDevice(false) then
  begin
    SetCurrentPath(DeviceFolder[BgDevice.ItemIndex]);
    ListFiles;
  end;
end;

procedure TFrmTripManager.BgDeviceItemsTripsClick(Sender: TObject);
begin
  if (GetRegistry(Reg_EnableTripFuncs, false) = false) and
     (GetRegistry(Reg_EnableFitFuncs, false) = false)  then
    Abort;
end;

procedure TFrmTripManager.BgDeviceItemsGpxClick(Sender: TObject);
begin
  if (GetRegistry(Reg_EnableGpxFuncs, false) = false) then
    Abort;
end;

procedure TFrmTripManager.BgDeviceItemsPoiClick(Sender: TObject);
begin
  if (GetRegistry(Reg_EnableGpiFuncs, false) = false) then
    Abort;
end;

procedure TFrmTripManager.BitBtnSQLGoClick(Sender: TObject);
var
  CrWait, CrNormal: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);

  LblSqlResults.Caption := Format('Executing: %s', [MemoSQL.Lines.Text]);
  LblSqlResults.Update;
  try
    DBMemo.Lines.Clear;
    if not StartsText('select', MemoSQL.Lines.Text) then
      LblSqlResults.Caption := Format('Records affected: %d',
                                      [ExecUpdateSql(SqlFile, MemoSQL.Lines.Text)])
    else
      LblSqlResults.Caption := Format('Records selected: %d',
                                      [CDSFromQuery(SqlFile, MemoSQL.Lines.Text, CdsDeviceDb)]);
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.BtnApplyCoordsClick(Sender: TObject);
var
  ALocation: TLocation;
  AmScPosn: TmScPosn;
  LocationScPosn: TmScPosn;

  procedure LocationUpdated;
  begin
    ATripList.ForceRecalc;
    LoadTripOnMap(ATripList, CurrentMapItem);
    BtnSaveTripValues.Enabled := true;
  end;

begin
  // Updating location for Trip Editor
  if (FrmTripEditor.Showing) then
  begin
    DmRoutePoints.CoordinatesApplied(Self, EditMapCoords.Text);
    exit;
  end;

  // Updating location for Compare
  if (FrmShowLog.Showing) then
  begin
    FrmShowLog.CoordinatesApplied(Self, EditMapCoords.Text);
    exit;
  end;

  // Updating location for TvTrip
  ALocation := SelectedLocation;
  if (Assigned(ALocation)) then
  begin
    LocationScPosn := ALocation.LocationTmScPosn;
    if (LocationScPosn <> nil) then
    begin
      LocationScPosn.MapCoords := EditMapCoords.Text;
      LocationUpdated;

      // Will update the Grid and the Map
      if (Assigned(TvTrip.OnChange)) then
        TvTrip.OnChange(TvTrip, TvTrip.Selected);
    end;

    exit;
  end;

  // Updating location for vlTripInfo
  AmScPosn := SelectedScPosn;
  if (Assigned(AmScPosn)) then
  begin
    AmScPosn.MapCoords := EditMapCoords.Text;
    VlTripInfo.Cells[1, VlTripInfo.Row] := AmScPosn.AsString;
    BtnSaveTripValues.Enabled := true;;

    exit;
  end;

end;

procedure TFrmTripManager.BtnFromDevClick(Sender: TObject);
var
  AnItem: TListItem;
  ABase_Data: TBASE_Data;
  CrWait, CrNormal: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try

    CheckDevice;

    WarnOverWrite := mrNone;
    for AnItem in LstFiles.Items do
    begin
      if (AnItem.Selected = false) then
        continue;
      ABase_Data := TBASE_Data(AnItem.Data);
      if (ABase_Data.IsFolder) then
        continue;

      if (FileExists(IncludeTrailingPathDelimiter(ShellTreeView1.Path) + AnItem.Caption)) then
      begin
        ShowWarnOverWrite(AnItem.Caption);
        if (WarnOverWrite in [mrNo, mrNoToAll]) then
          continue;
      end;

      EdDeviceFolder.Text := Format('Transferring %s', [AnItem.Caption]);
      EdDeviceFolder.Update;

      GetFileFromDevice(CurrentDevice.PortableDev, ABase_Data.ObjectId, ShellTreeView1.Path, AnItem.Caption);
    end;
    SetDeviceDisplayPath;
    ShellListView1.Refresh;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.BtnToDevClick(Sender: TObject);
var
  AnItem, CurrentItem: TlistItem;
  AFolder: TShellFolder;
  CurrentObjectId, NFile: string;
  Index: integer;
  CrWait, CrNormal: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try

    CheckDevice;

    WarnOverWrite := mrNone;
    for AnItem in ShellListView1.Items do
    begin
      if (AnItem.Selected = false) then
        continue;
      AFolder := ShellListView1.Folders[AnItem.Index];
      if (AFolder.IsFolder) then
        continue;

      NFile := ExtractFileName(AFolder.PathName);
      CurrentObjectId := GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, NFile);
      if (CurrentObjectId = '') then
      begin
        EdFileSysFolder.Text := Format('Transferring %s', [NFile]);
        EdFileSysFolder.Update;
        if (TransferNewFileToDevice(CurrentDevice.PortableDev, AFolder.PathName, FSavedFolderId) = '') then
          raise exception.Create('Writing file failed');
      end
      else
      begin
        ShowWarnOverWrite(NFile);
        SetCursor(CrWait);

        if (WarnOverWrite in [mrNo, mrNoToAll]) then
          continue;

        CurrentItem := nil;
        for Index := 0 to LstFiles.Items.Count -1 do
        begin
          if (LstFiles.Items[Index].Caption = NFile) then
          begin
            CurrentItem := LstFiles.Items[Index];
            break;
          end;
        end;
        if (CurrentItem = nil) then
          raise exception.Create('Overwrite file failed');
        EdFileSysFolder.Text := Format('Transferring %s', [NFile]);
        EdFileSysFolder.Update;
        if (not TransferExistingFileToDevice(CurrentDevice.PortableDev, AFolder.PathName, FSavedFolderId, CurrentItem)) then
          raise exception.Create('Overwrite file failed');
      end;
    end;

    EdFileSysFolder.Text := ShellTreeView1.Path;
    ReloadFileList;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.BtnFunctionsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Pt: TPoint;
begin
  CheckDevice;
  Pt.X := X;
  Pt.Y := Y;
  Pt := TButton(Sender).ClientToScreen(Pt);
  DeviceMenu.Popup(Pt.X, Pt.Y);
end;

procedure TFrmTripManager.BtnGeoSearchClick(Sender: TObject);
var
  Lat, Lon: string;
  Place: TPlace;
begin
  if (CreateOSMMapHtml) then
    EdgeBrowser1.Navigate(GetHtmlTmp);

  GetCoordsOfPlace('', Lat, Lon);
  if (Lat <> '') and
     (Lon <> '') then
  begin
    Place := GetPlaceOfCoords(Lat, Lon);
    Clipboard.AsText := Place.DisplayPlace;
    MapRequest(Format('%s, %s', [Lat, Lon]), TPlace.UnEscape(Place.HtmlPlace), GeoSearchTimeOut, 'true'); // Always zoom
  end;
end;

procedure TFrmTripManager.BtnSendToClick(Sender: TObject);
var
  CrWait, CRNormal: HCURSOR;
  GPXFile, TempFile, TempExt, CurrentObjectId, SavedFolderId: string;
  AnItem: TListItem;
  Fs: TSearchRec;
  Rc: integer;
begin
  if (ShellListView1.SelectedFolder = nil) then
    exit;

  // Revert to default (startup) locations
  ReadDefaultFolders;
  FrmSendTo.HasCurrentDevice := CheckDevice(false);
  if (FrmSendTo.HasCurrentDevice) then
    FrmSendTo.DisplayedDevice := CurrentDevice.DisplayedDevice;
  if (FrmSendTo.ShowModal <> ID_OK) then
    exit;

  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  SavedFolderId := FSavedFolderId;
  WarnOverWrite := mrNone;

  try
{$IFNDEF DEBUG_TRANSFER}
    // Also checks for connected MTP
    if (FrmSendTo.SendToDest = TSendToDest.stDevice) then
      BgDeviceClick(BgDevice);
{$ENDIF}

    for AnItem in ShellListView1.Items do
    begin
      if (AnItem.Selected = false) then
        continue;
      if (ShellListView1.Folders[AnItem.Index].IsFolder) then
        continue;
      GPXFile := ShellListView1.Folders[AnItem.Index].PathName;
      if not (ContainsText(ExtractFileExt(GPXFile), GpxExtension)) then
        continue;

      case FrmSendTo.SendToDest of
        TSendToDest.stDevice:
          begin
            // Clean up 'Routes' Temp directory.
            DeleteTempFiles(GetRoutesTmp, '*.*');
            TGPXFile.PerformFunctions(FrmSendTo.Funcs, GPXFile,
                                      OnSetSendToPrefs, SetProcessOptions.SavePrefs,
                                      GetRoutesTmp, nil, AnItem.Index);

            {$IFNDEF DEBUG_TRANSFER}
            // The Temp directory 'Routes' now has all the files to send.
            // Do the transfer, based on Extension.
            Rc := FindFirst(GetRoutesTmp + '\*.*', faAnyFile - faDirectory, Fs);
            while (Rc = 0) do
            begin
              // Save the File name and Extension. The rest of the loop must use these vars.
              TempFile := Fs.Name;
              TempExt := ExtractFileExt(TempFile);

              // Make sure we read the next, so we can use Continue in the loop
              Rc := FindNext(Fs);

              if (ContainsText(TempExt, TripExtension)) then
                SetCurrentPath(DeviceFolder[0])
              else if (ContainsText(TempExt, GpxExtension)) or
                      (ContainsText(TempExt, FitExtension)) then
                SetCurrentPath(DeviceFolder[1])
              else if (ContainsText(TempExt, GPIExtension)) then
                SetCurrentPath(DeviceFolder[2])
              else
                continue;

              // Overwrite?
              CurrentObjectid := GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, TempFile);
              if (CurrentObjectid <> '') then
              begin
                ShowWarnOverWrite(TempFile);
                if (WarnOverWrite in [mrNo, mrNoToAll]) then
                  continue;
                if (not DelFromDevice(CurrentDevice.PortableDev, CurrentObjectid)) then
                  raise Exception.Create(Format('Could not remove file: %s on %s', [TempFile, CurrentDevice.DisplayedDevice]));
              end;

              // Transfer
              EdFileSysFolder.Text := Format('Transferring %s', [TempFile]);
              EdFileSysFolder.Update;
              TempFile := IncludeTrailingPathDelimiter(GetRoutesTmp) + TempFile;

              // Did the transfer work?
              if (TransferNewFileToDevice(CurrentDevice.PortableDev, TempFile, FSavedFolderId) = '') then
                raise Exception.Create(Format('Could not overwrite file: %s on %s',
                                              [ExtractFileName(TempFile), CurrentDevice.DisplayedDevice]));
            end;
            FindClose(Fs);
            {$ENDIF}
          end;
        TSendToDest.stWindows:
          begin
            TGPXFile.PerformFunctions(FrmSendTo.Funcs, GPXFile,
                                      OnSetSendToPrefs, SetProcessOptions.SavePrefs,
                                      '', nil, AnItem.Index);
          end;
      end;
    end;
  finally
    EdFileSysFolder.Text := ShellTreeView1.Path;
    FSavedFolderId := SavedFolderId;
    SetCursor(CrNormal);
  end;

  case FrmSendTo.SendToDest of
    TSendToDest.stDevice:
      {$IFNDEF DEBUG_TRANSFER}ListFiles{$ENDIF};
    TSendToDest.stWindows:
      BtnRefreshFileSysClick(Sender);
  end;

end;

procedure TFrmTripManager.BtnRefreshClick(Sender: TObject);
var
  HasMtpDevice: boolean;
  DeviceId: string;
begin
  HasMtpDevice := Assigned(CurrentDevice);
  if HasMtpDevice then
    DeviceId := CurrentDevice.Device
  else
    DeviceId := '';

  GetDeviceList;
  try
    SelectDeviceById(DeviceId);
    if CheckDevice(false) then
    begin
      if not (HasMtpDevice) then  // No device was connected, now it is. Read settings.
        ReadDeviceDB;
      ReloadFileList;
    end;
  except
    CloseDevice;  // Prevent needless tries
  end;
end;

function TFrmTripManager.GetSelectedFile: string;
begin
  result := '';
  if (ShellListView1.SelectedFolder <> nil) then
    result := ShellListView1.SelectedFolder.PathName;
end;

procedure TFrmTripManager.SetSelectedFile(AFile: string);
var
  Index: integer;
begin
  if (AFile = '') then
    exit;

 for Index := 0 to ShellListView1.Items.Count -1 do
  begin
    if (ShellListView1.Folders[Index].PathName = AFile) then
    begin
      ShellListView1.Items[Index].Selected := true;
      break;
    end;
  end;

  ShellListView1.SetFocus;
end;

procedure TFrmTripManager.BtnRefreshFileSysClick(Sender: TObject);
var
  SavedPath: string;
  SelName: string;
begin
  SavedPath := ShellTreeView1.Path;
  SelName := GetSelectedFile;

  try
    ShellTreeView1.ObjectTypes := ShellTreeView1.ObjectTypes;
  finally
    ShellTreeView1.Path := SavedPath;

    // Refresh ShellList retaining selection
    ShellListView1.Refresh;
    SetSelectedFile(SelName);
  end;
end;

procedure TFrmTripManager.RoutePointUpdated(Sender: TObject);
begin
  MapRequest(DmRoutePoints.CdsRoutePoints.FieldByName('Coords').AsString,
             DmRoutePoints.CdsRoutePoints.FieldByName('Name').AsString,
             RoutePointTimeOut);
end;

function TFrmTripManager.GetMapCoords: string;
begin
  result := EditMapCoords.Text;
end;

procedure TFrmTripManager.InstallTripEdit;
begin
// Set FrmTripEditor Events
  FrmTripEditor.OnTripFileCanceled := TripFileCanceled;
  FrmTripEditor.OnTripFileUpdating := TripFileUpdating;
  FrmTripEditor.OnTripFileUpdated := TripFileUpdated;
  FrmTripEditor.OnRoutePointsShowing := RoutePointsShowing;

// Set DmRoutePoints events
  DmRoutePoints.OnGetMapCoords := GetMapCoords;
  DmRoutePoints.OnRouteUpdated := ReloadTripOnMap;
  DmRoutePoints.UuidList := ExploreList;
end;

procedure TFrmTripManager.EditTrip(NewFile: boolean);
begin
// Create new empty triplist?
  if not Assigned(ATripList) then
    ATripList := TTripList.Create;
  if (NewFile) then
    ATripList.CreateTemplate(TModelConv.Display2Trip(GetRegistry(Reg_CurrentModel, 0)), FrmNewTrip.EdNewTrip.Text);

// Set FrmTripEditor Params
  FrmTripEditor.CurTripList := ATripList;
  FrmTripEditor.CurPath := ShellTreeView1.Path;
  FrmTripEditor.CurFile := HexEditFile;
  FrmTripEditor.CurDevice := DeviceFile;
  FrmTripEditor.CurNewFile := NewFile;

// Set FrmTripEditor Events
  InstallTripEdit;

// Position left from the map.
  FrmTripEditor.Top := Top;
  FrmTripEditor.Left := Left;
end;

procedure TFrmTripManager.ReloadTripOnMap(Sender: TObject);
var
  ATripList: TTripList;
begin
  DmRoutePoints.SaveTrip;
  ATripList := TTripList(FrmTripEditor.CurTripList);
  ATripList.ForceRecalc;
  LoadTripOnMap(ATripList, CurrentMapItem);
end;

procedure TFrmTripManager.RoutePointsShowing(Sender: TObject; Showing: boolean);
var
  CurSel: integer;
begin
  if Showing then
    DmRoutePoints.OnRoutePointUpdated := RoutePointUpdated
  else
  begin
    DmRoutePoints.OnRoutePointUpdated := nil;
    if (DeviceFile) and
       (BgDevice.ItemIndex = 0) then
    begin
      // Save currently selected trip
      if Assigned(LstFiles.Selected) then
        CurSel := LstFiles.Selected.Index
      else
        CurSel := -1;

      ReloadFileList;
      // Need to (re)select?
      if (CurSel > -1) and
         (CurSel < LstFiles.items.Count) then
        LstFiles.Items[CurSel].Selected := true;
    end;
  end;

  EnableApplyCoords;
end;

procedure TFrmTripManager.TripFileUpdating(Sender: TObject);
begin
  TvTrip.Items.Clear;
  ClearTripInfo;
end;

procedure TFrmTripManager.TripFileCanceled(Sender: TObject);
begin
  if (FileExists(FrmTripEditor.CurFile)) then
    LoadTripFile(FrmTripEditor.CurFile, FrmTripEditor.CurDevice);
end;

procedure TFrmTripManager.TripFileUpdated(Sender: TObject);
begin
  if (FrmTripEditor.CurNewFile = false) then
  begin
    ShowWarnRecalc;
    if (WarnRecalc = mrNo) then
      exit;
  end;

  ATripList.ForceRecalc;
  ATripList.SaveToFile(HexEditFile);
  if not (DeviceFile) then
    BtnRefreshFileSysClick(Sender)
  else
  begin
    if (FrmTripEditor.CurNewFile = false) then
      CopyFileFromTmp(HexEditFile, LstFiles.Selected)
    else
    begin
      if (TransferNewFileToDevice(CurrentDevice.PortableDev, HexEditFile, FSavedFolderId) = '') then
        raise exception.Create('Writing file failed');
    end;
  end;
end;

procedure TFrmTripManager.BtnTripEditorMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Pt: TPoint;
begin
  Pt.X := X;
  Pt.Y := Y;
  Pt := TButton(Sender).ClientToScreen(Pt);
  PopupTripEdit.Popup(Pt.X, Pt.Y);
end;

procedure TFrmTripManager.SaveCSV1Click(Sender: TObject);
begin
  SaveTrip.Filter := '*.csv|*.csv';
  SaveTrip.InitialDir := ShellTreeView1.Path;
  SaveTrip.FileName := ChangeFileExt(ExtractFileName(HexEditFile), '.csv');
  if not SaveTrip.Execute then
    exit;

  VlTripInfo.SaveAsCSV(SaveTrip.FileName);
end;

procedure TFrmTripManager.SaveGPX1Click(Sender: TObject);
var
  GPIRec: TGPI;
begin
  SaveTrip.Filter := '*.gpx|*.gpx';
  SaveTrip.InitialDir := ShellTreeView1.Path;
  SaveTrip.FileName := ChangeFileExt(ExtractFileName(HexEditFile), '.gpx');
  if not SaveTrip.Execute then
    exit;

  if (APOIList <> nil) and
     (APOIList.Count > 0) then
    GPIRec.SaveGpx(SaveTrip.FileName, APOIList, TProcessOptions.GetCatSymbol)
  else if (Assigned(ATripList) and
          (ATripList.ItemList.Count > 0)) then
    ATripList.SaveAsGPX(SaveTrip.FileName);
end;

procedure TFrmTripManager.CompareEploredbwithTrips1Click(Sender: TObject);
begin
  CheckExploreDb;
  TsExplore.TabVisible := true;
  PctHexOsm.ActivePage := TsExplore;
end;

procedure TFrmTripManager.CheckExploreDb;
var
  AnITem, OrgItem, DupItem: TListItem;
  ExploreIndex, TripIndex, DupIndex: integer;
  TmpExploreList: TStringList;
  PerfectList: Tlist<TlistItem>;
  CrNormal, CrWait: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  LvExplore.Items.BeginUpdate;
  PerfectList := TList<TListItem>.Create;
  TmpExploreList := TStringList.Create;
  try
    SpbCorrectUuid.Enabled := false;
    LvExplore.Items.Clear;

    // GroupId
    // 0: In Explore, not in Trips
    // 1: In Trips, in Explore, but multiple trips with same trip name
    // 2: In Explore, in Trip, but Uuid is different
    // 3: In Trips, not in Explore
    // 4: In Explore, in Trip, Uuid is Equal

    for ExploreIndex := 0 to ExploreList.Count -1 do
    begin
      AnITem := LvExplore.Items.Add;
      AnITem.Caption := ExploreList.KeyNames[ExploreIndex];
      AnITem.SubItems.Add(ExploreList.ValueFromIndex[ExploreIndex]);

      AnITem.GroupID := 0;
      for TripIndex := 0 to LstFiles.Items.Count -1 do
      begin
        if (TMTP_Data(LstFiles.Items[TripIndex].Data).IsFolder) then
          continue;

        if (Sametext(LstFiles.Items[TripIndex].SubItems[TripNameCol -1], ExploreList.KeyNames[ExploreIndex])) then
        begin
          AnITem.SubItems.Add(LstFiles.Items[TripIndex].Caption);
          AnITem.SubItems.Add(TMTP_Data(LstFiles.Items[TripIndex].Data).ExploreUUID);
          if (TMTP_Data(LstFiles.Items[TripIndex].Data).ExploreUUID = ExploreList.ValueFromIndex[ExploreIndex]) then
          begin
            PerfectList.Add(AnITem);
            AnITem.GroupID := 4;
          end
          else
            AnITem.GroupID := 2;
          break;
        end;
      end;
      SpbCorrectUuid.Enabled := SpbCorrectUuid.Enabled or
                                (AnITem.GroupId = 2);
      AnITem.ImageIndex := AnITem.GroupId;
    end;

    // Use TmpExploreList to match tripname only once.
    // A matched trip is deleted from the list, to prevent that
    TmpExploreList.NameValueSeparator := #9;
    TmpExploreList.Sorted := true;
    TmpExploreList.Duplicates := TDuplicates.dupIgnore;
    TmpExploreList.Text := ExploreList.Text;

    for TripIndex := 0 to LstFiles.Items.Count -1 do
    begin
      if (TMTP_Data(LstFiles.Items[TripIndex].Data).IsFolder) then
        continue;
      ExploreIndex := TmpExploreList.IndexOfName(LstFiles.Items[TripIndex].SubItems[TripNameCol -1]);
      if (ExploreIndex < 0) then
      begin
        // Trip not in Explore
        AnITem := LvExplore.Items.Add;
        AnITem.Caption := LstFiles.Items[TripIndex].SubItems[TripNameCol -1];
        AnITem.SubItems.Add('');
        AnITem.SubItems.Add(LstFiles.Items[TripIndex].Caption);
        AnITem.SubItems.Add(TMTP_Data(LstFiles.Items[TripIndex].Data).ExploreUUID);

        // Check in complete Explore List.
        // If found, that means multiple trips with same trip name exist.
        DupIndex := ExploreList.IndexOfName(LstFiles.Items[TripIndex].SubItems[TripNameCol -1]);
        if (DupIndex > -1) then
        begin
          AnITem.SubItems[0] := ExploreList.ValueFromIndex[DupIndex];
          AnITem.GroupId := 1;
        end
        else
          AnITem.GroupId := 3;
        AnITem.ImageIndex := AnITem.GroupId;
      end
      else
        TmpExploreList.Delete(ExploreIndex);
    end;

    // Add the item from the correct(matching) to the duplicates group.
    for OrgItem in PerfectList do
    begin
      for AnITem in LvExplore.Items do
      begin
        if (AnITem.GroupID <> 1) or
           (AnITem.Caption <> OrgItem.Caption) then
          continue;
        DupItem := LvExplore.Items.Add;
        DupItem.Assign(AnITem);
        DupItem.SubItems[1] := OrgItem.SubItems[1];
        break;
      end;
    end;

    if (LvExplore.Items.Count > 0) then
      LvExplore.Items[0].Selected := true;
  finally
    TmpExploreList.Free;
    PerfectList.Free;
    LvExplore.Items.EndUpdate;
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.CompareWithGpx(Sender: TObject);
var
  GPXFileObj: TGPXTripCompare;
  CrWait, CrNormal: HCURSOR;
  OsmTrack: TStringList;
  GpxSelected: boolean;
  TagsToShow: TTagsToShow;
  AnItem: TListItem;
  Index: integer;
begin
  if (ATripList = nil) or
    (ATripList.GetItem('mAllRoutes') = nil) then
    exit;

  // Handlers
  EditTrip(false);

  TagsToShow := TTagsToShow(TMenuItem(Sender).Tag);  //Rte = 20, Track = 30
  OpenTrip.DefaultExt := GpxExtension;
  OpenTrip.Filter := GpxMask + '|' + GpxMask;
  OpenTrip.InitialDir := ShellTreeView1.Path;

  // Select the fist GPX
  for AnItem in ShellListView1.Items do
  begin
    if EndsText(GpxExtension, ExtractFileExt(ShellListView1.Folders[AnItem.Index].PathName)) then
    begin
      OpenTrip.FileName := ExtractFileName(ShellListView1.Folders[AnItem.Index].PathName);
      break;
    end;
  end;

  if not OpenTrip.Execute then
    exit;

  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);

  OsmTrack := TStringList.Create;

  GPXFileObj := TGPXTripCompare.Create(OpenTrip.FileName, ATripList, FrmShowLog.GpxRptList);
  try
    GPXFileObj.AnalyzeGpx;
    GpxSelected := GPXFileObj.ShowSelectTracks(TagsToShow,
                                              'Compare with GPX: ' + ExtractFileName(OpenTrip.FileName),
                                              'Use the Checkboxes to select 1 Route or Track',
                                               ATripList.TripName, nil);
    if (GpXSelected) then
    begin
      SetCursor(CrWait);
      FrmShowLog.ClearLog;
      case (TagsToShow) of
        TTagsToShow.Rte:
          GPXFileObj.CompareGpxRoute(FrmShowLog.LbLog.Items, OsmTrack);
        TTagsToShow.RteTrk:
          GPXFileObj.CompareGpxTrack(FrmShowLog.LbLog.Items, OsmTrack);
      end;

      for Index := 0 to FrmShowLog.LbLog.Items.Count -1 do
        FrmShowLog.LbLog.Header[Index] := not (ContainsText(FrmShowLog.LbLog.Items[Index], TripFile)) and
                                          not (ContainsText(FrmShowLog.LbLog.Items[Index], GpxFile));

      DeleteCompareFiles;
      OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s%s',
                                              [App_Prefix,
                                              CompareTrip,
                                              ExtractFileName(OpenTrip.FileName),
                                              GetTracksExt]));
      Clipboard.AsText := FrmShowLog.LbLog.Items.Text;
      FrmShowLog.FSyncTreeview := SyncDiff;
      FrmShowLog.CompareGpx := OpenTrip.FileName;
      FrmShowLog.Show;
    end;
  finally
    OsmTrack.Free;
    GPXFileObj.Free;

    TvTrip.Invalidate;
    VlTripInfo.Invalidate;

    SetCursor(CrNormal);
    if (CreateOSMMapHtml) then
      EdgeBrowser1.Navigate(GetHtmlTmp);
  end;
end;

procedure TFrmTripManager.SaveTripGpiFile;
var
  Ext: string;
begin
  // Only if loaded from device
  if (DeviceFile) then
    CopyFileFromTmp(HexEditFile, LstFiles.Selected);

  // Reload changes
  Ext := ExtractFileExt(HexEditFile);
  if (ContainsText(Ext, TripExtension)) then
    LoadTripFile(HexEditFile, DeviceFile)
  else if (ContainsText(Ext, GPIExtension)) then
    LoadGpiFile(HexEditFile, DeviceFile);
end;

procedure TFrmTripManager.BtnSaveTripValuesClick(Sender: TObject);
begin
  ShowWarnRecalc;
  if (WarnRecalc = mrNo) then
    exit;

  ATripList.ForceRecalc;
  ATripList.SaveToFile(HexEditFile);
  SaveTripGpiFile;
end;

procedure TFrmTripManager.BtnSetDeviceDefaultClick(Sender: TObject);
var
  CurrentDevicePath: string;
  ModelIndex: integer;
  SubKey: string;
begin
  // Need a device
  if (not CheckDevice(false)) then
    exit;

  CurrentDevicePath := GetDevicePath(FCurrentPath);
  // Make drive letter a ?. Allow WildCard.
  if (Copy(CurrentDevicePath, 2, 2) = ':\') then
    CurrentDevicePath[1] := '?';

  // Save Device settings
  ModelIndex := CmbModel.ItemIndex;
  SubKey := IntToStr(ModelIndex);
  case (BgDevice.ItemIndex) of
    0: SetRegistry(Reg_PrefDevTripsFolder_Key, CurrentDevicePath, SubKey);
    1: SetRegistry(Reg_PrefDevGpxFolder_Key, CurrentDevicePath, SubKey);
    2: SetRegistry(Reg_PrefDevPoiFolder_Key, CurrentDevicePath, SubKey);
  end;
end;

procedure TFrmTripManager.BtnOpenTempClick(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', PWideChar(CreatedTempPath), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrmTripManager.PCTTripInfoResize(Sender: TObject);
begin
  SbPostProcess.Panels[0].Width := PCTTripInfo.Width div 2;
  SbPostProcess.Panels[1].Width := PCTTripInfo.Width div 2;
end;

procedure TFrmTripManager.PnlDeviceTopResize(Sender: TObject);
begin
  CmbDevices.DropDownWidth := Max(CmbDevices.ItemsWidth, CmbDevices.Width);
end;

procedure TFrmTripManager.PopupTripEditPopup(Sender: TObject);
begin
  MnuTripNewMTP.Enabled := CheckDevice(false);
end;

procedure TFrmTripManager.PopupTripInfoPopup(Sender: TObject);
begin
  SaveGPX1.Enabled := ( (ATripList <> nil) and (ATripList.ItemList.Count > 0)) or
                      ( (APOIList <> nil)  and (APOIList.Count > 0));

  MnuCompareGpxRoute.Enabled := SaveGPX1.Enabled;
  MnuCompareGpxTrack.Enabled := SaveGPX1.Enabled;

  MnuPrevDiff.ShortCut := TextToShortCut('Alt+Up'); // Tshortcut(32806);
  MnuNextDiff.ShortCut := TextToShortCut('Alt+Down'); //Tshortcut(32808);
end;

procedure TFrmTripManager.PostProcessClick(Sender: TObject);
var
  AnItem: TListItem;
  Ext: string;
  CrNormal,CrWait: HCURSOR;
begin
  DirectoryMonitor.Active := false;
  try
    if (ShellListView1.SelectedFolder = nil) then
      exit;

    if FrmPostProcess.ShowModal <> ID_OK then
      exit;
    CrWait := LoadCursor(0,IDC_WAIT);
    CrNormal := SetCursor(CrWait);
    try
      for AnItem in ShellListView1.Items do
      begin
        if (AnItem.Selected = false) then
          continue;
        if (ShellListView1.Folders[AnItem.Index].IsFolder) then
          continue;
        Ext := ExtractFileExt(ShellListView1.Folders[AnItem.Index].PathName);
        if (ContainsText(Ext, GpxExtension)) then
        begin
          SbPostProcess.Panels[0].Text := ShellListView1.Folders[AnItem.Index].PathName;
          ProcessMessages;
          TGPXFile.PerformFunctions([PostProcess], ShellListView1.Folders[AnItem.Index].PathName,
                                    OnSetPostProcessPrefs, SetProcessOptions.SavePrefs);
        end;
      end;
    finally
      SbPostProcess.Panels[0].Text := '';
      SbPostProcess.Panels[1].Text := '';
      SetCursor(CrNormal);
    end;
  finally
    DirectoryMonitor.Active := ChkWatch.Checked;
  end;
end;

procedure TFrmTripManager.BtnSaveTripGpiFileClick(Sender: TObject);
begin
  HexEdit.SaveToFile(HexEditFile);
  SaveTripGpiFile;
end;

procedure TFrmTripManager.ClearTripInfo;
var
  Index: integer;
begin
  VlTripInfo.Strings.BeginUpdate;
  try
    for Index := 0 to VlTripInfo.Strings.Count -1 do
      FreeAndNil(VlTripInfo.Strings.Objects[Index]);
    VlTripInfo.Strings.Clear;
    VlTripInfo.Row := 1;
  finally
    VlTripInfo.Strings.EndUpdate;
  end;
end;

procedure TFrmTripManager.ShowWarnRecalc;
begin
  case WarnRecalc of
    mrIgnore:
      exit;
  end;
  WarnRecalc := MessageDlg('Saving the trip will force recalculation. OK?',
                   TMsgDlgType.mtWarning,
                    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbIgnore], 0);
end;

procedure TFrmTripManager.ShowWarnOverWrite(const AFile: string);
begin
  case WarnOverWrite of
    mrNoToAll,
    mrYesToAll:
      exit;
  end;
  WarnOverWrite := MessageDlg(Format('Overwrite existing file: %s ?', [AFile]),
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbYesToAll, TMsgDlgBtn.mbNoToAll], 0);
end;

procedure TFrmTripManager.EdDeviceFolderKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    SetCurrentPath(GetDevicePath(EdDeviceFolder.Text));
    ListFiles;
    Key := #0;
  end;
end;

procedure TFrmTripManager.EdFileSysFolderCloseUp(Sender: TObject);
begin
  if (EdFileSysFolder.ItemIndex > -1) then
  begin
    EdFileSysFolder.Text := EdFileSysFolder.Items[EdFileSysFolder.ItemIndex];
    ShellTreeView1.Path := TPath.GetFullPath(EdFileSysFolder.Text);
  end;
end;

procedure TFrmTripManager.EdFileSysFolderKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    ShellTreeView1.Path := TPath.GetFullPath(EdFileSysFolder.Text);
    if not (EdFileSysFolder.DroppedDown) then
      Key := #0;
  end;
end;

procedure TFrmTripManager.EdgeBrowser1CreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
var
  Settings: ICoreWebView2Settings;
begin
  if (AResult <> S_OK) then
  begin
    ShowMessage('Could not load OSM Map');
    exit;
  end;

  if Succeeded(EdgeBrowser1.DefaultInterface.Get_Settings(Settings)) then
    ICoreWebView2Settings2(Settings).Set_UserAgent(PWideChar(UserAgent));
end;

procedure TFrmTripManager.EdgeBrowser1NavigationStarting(Sender: TCustomEdgeBrowser; Args: TNavigationStartingEventArgs);
begin
  Sender.ZoomFactor := EdgeZoom;
end;

procedure TFrmTripManager.EdgeBrowser1WebMessageReceived(Sender: TCustomEdgeBrowser; Args: TWebMessageReceivedEventArgs);
var
  Message: PChar;
  Msg, Parm1, Parm2, Lat, Lon: string;
  Place: TPlace;
begin
  Args.ArgsInterface.Get_webMessageAsJson(Message);
  ParseJsonMessage(Message, Msg, Parm1, Parm2);

  if (Msg = OSMGetBounds) then
  begin
    EditMapBounds.Text := Parm1;

    ParseLatLon(Parm2, Lat, Lon);
    AdjustLatLon(Lat, Lon, Coord_Decimals);
    EditMapCoords.Text := Lat + ', ' + Lon;

    exit;
  end;

  if (Msg = OSMGetRoutePoint) then
  begin
    if (Parm1 <> '') then
      LblRoute.Text := Parm1;
    if (Parm2 <> '') then
      LblRoutePoint.Text := Parm2;
    exit;
  end;

  if (Msg = BaseLayer) then
  begin
    if (Parm1 <> '') then
      SetRegistry(Reg_BaseLayer_Key, Parm1);
    exit;
  end;

  AdjustLatLon(Parm1, Parm2, Coord_Decimals);
  EditMapCoords.Text := Parm1 + ', ' + Parm2;
  if (Msg = OSMCtrlClick) then
  begin
    Place := GetPlaceOfCoords(Parm1, Parm2);
    if (PLace = nil) then
      MapRequest(EditMapCoords.Text, OSMCtrlClick, GeoSearchTimeOut)
    else
    begin
      Clipboard.AsText := Place.DisplayPlace;
      MapRequest(EditMapCoords.Text, Place.HtmlPlace, GeoSearchTimeOut);
    end;
    exit;
  end;

end;

procedure TFrmTripManager.EdgeBrowser1ZoomFactorChanged(Sender: TCustomEdgeBrowser; AZoomFactor: Double);
begin
  EdgeZoom := AZoomFactor;
end;

procedure TFrmTripManager.MnuTripNewMTPClick(Sender: TObject);
begin
  ReadDefaultFolders;
  FrmNewTrip.DevicePath := DeviceFolder[0];

  FrmNewTrip.CurrentDevice := CurrentDevice;
  SetCurrentPath(DeviceFolder[0]);
  FrmNewTrip.SavedFolderId := FSavedFolderId;
  DeviceFile := true;

  if (FrmNewTrip.ShowModal = mrOk) then
  begin
    HexEditFile := ChangeFileExt(IncludeTrailingPathDelimiter(CreatedTempPath) + FrmNewTrip.EdNewTrip.Text, TripExtension);
    EditTrip(true);
    FrmTripEditor.Show;
  end;
end;

procedure TFrmTripManager.NewtripWindows1Click(Sender: TObject);
begin
  FrmNewTrip.SavedFolderId := '';
  FrmNewTrip.CurrentDevice := nil;
  FrmNewTrip.CurPath := ShellTreeView1.Path;
  DeviceFile := false;

  if (FrmNewTrip.ShowModal = mrOk) then
  begin
    HexEditFile := ChangeFileExt(IncludeTrailingPathDelimiter(ShellTreeView1.Path) + FrmNewTrip.EdNewTrip.Text, TripExtension);
    EditTrip(true);
    FrmTripEditor.Show;
  end;
end;

procedure TFrmTripManager.MnuNextDiffClick(Sender: TObject);
var
  ANode: TTreeNode;
begin
  if (TvTrip.Items.Count = 0) then
    exit;
  if (TvTrip.Selected <> nil) then
    ANode := TvTrip.Selected.GetNext
  else
    ANode := TvTrip.Items[0].GetNext;
  while (ANode <> nil) do
  begin
    if (ANode.Data <> nil) and
       (TObject(ANode.Data) is TUdbDir) and
       (TUdbDir(ANode.Data).Status in [TUdbDirStatus.udsRoadNOK,
                                       TUdbDirStatus.UdsRoadOKCoordsNOK,
                                       TUdbDirStatus.udsCoordsNOK,
                                       TUdbDirStatus.udsRoutePointNOK]) then
    begin
      TvTrip.Selected := ANode;
      break;
    end;
    ANode := ANode.GetNext;
  end;
end;

procedure TFrmTripManager.MnuPrevDiffClick(Sender: TObject);
var
  ANode: TTreeNode;
begin
  if (TvTrip.Items.Count = 0) then
    exit;
  if (TvTrip.Selected <> nil) then
    ANode := TvTrip.Selected.GetPrev
  else
    ANode := TvTrip.Items[TvTrip.Items.Count -1].GetPrev;
  while (ANode <> nil) do
  begin
    if (ANode.Data <> nil) and
       (TObject(ANode.Data) is TUdbDir) and
       (TUdbDir(ANode.Data).Status in [TUdbDirStatus.udsRoadNOK,
                                       TUdbDirStatus.UdsRoadOKCoordsNOK,
                                       TUdbDirStatus.udsCoordsNOK,
                                       TUdbDirStatus.udsRoutePointNOK]) then
    begin
      TvTrip.Selected := ANode;
      break;
    end;
    ANode := ANode.GetPrev;
  end;
end;

procedure TFrmTripManager.SyncDiff(Sender: TObject);
var
  ANode: TTreeNode;
  CoordGpx: TCoords;
  BestLat, BestLon: string;
begin
  BtnApplyCoords.Enabled := false;
  if (Assigned(Sender)) and
     (Sender is TXmlVSNode) then
  begin
    BtnApplyCoords.Enabled := true;
    CoordGpx.FromAttributes(TXmlVSNode(Sender).AttributeList);
    CoordGpx.FormatLatLon(BestLat, BestLon);
    MapRequest(BestLat + ', ' + BestLon, TXmlVSNode(Sender).NodeValue, RoutePointTimeOut);
    exit;
  end;

  if (Assigned(Sender)) and
     (Sender is TUdbDir) then
  begin
    BtnApplyCoords.Enabled := true;
    TvTrip.Selected := TvTrip.Items[0];
    ANode := TvTrip.Items[0];
    while (ANode <> nil) do
    begin
      if (ANode.Data <> nil) and
         (TObject(ANode.Data) is TUdbDir) and
         (ANode.Data = Sender) then
      begin
        TvTrip.Selected := ANode;
        break;
      end;
      ANode := ANode.GetNext;
    end;
    exit;
  end;
end;

procedure TFrmTripManager.MnuTripEditClick(Sender: TObject);
begin
  EditTrip(false);
  FrmTripEditor.Show;
end;

procedure TFrmTripManager.EditMapCoordsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_Return) and
     (EditMapCoords.Text <> '') then
    MapRequest(EditMapCoords.Text, EditMapCoords.Text, RoutePointTimeOut);
end;

procedure TFrmTripManager.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  EdgeBrowser1.CloseBrowserProcess; // Close Edge. Else we can not remove the tempdir.
  SetRegistry(Reg_SavedMapPosition_Key, EditMapCoords.Text);

  if (DirectoryMonitor.Active) then
    DirectoryMonitor.Stop;

  CloseDevice;
  WriteColumnSettings;
end;

procedure TFrmTripManager.FormCreate(Sender: TObject);
var
  AFilePath: string;
begin
  DirectoryMonitor := TDirectoryMonitor.Create;
  DirectoryMonitor.Subdirectories := false;
  DirectoryMonitor.Actions := [awChangeCreation, awChangeLastWrite];
  DirectoryMonitor.OnChange := DirectoryEvent;
  ModifiedList := TStringList.Create;
  ModifiedList.Sorted := true;
  ModifiedList.Duplicates := TDuplicates.dupIgnore;

  USBEvent := TUSBEvent.Create;
  USBEvent.OnUSBChange := USBChangeEvent;
  if not USBEvent.RegisterUSBHandler(GUID_DEVINTERFACE_WPD) then
    ShowMessage('Failed to register WPD Events');

  TsSQlite.TabVisible := false;
  HexEdit := TBCHexEditor.Create(Self);
  HexEdit.Parent := HexPanel;
  HexEdit.Align := alClient;
  HexEdit.ShowPositionIfNotFocused := true;
  HexEdit.OnKeyPress := HexEditKeyPress;
  HexEdit.OnKeyDown := HexEditKeyDown;
  VlTripInfo.OnSelectionMoved := VlTripInfoSelectionMoved;
  VlTripInfo.OnBeforeDrawCell := VlTripInfoBeforeDrawCell;

  ShellTreeView1.OnCustomDrawItem := ShellTreeView1CustomDrawItem;
  ShellListView1.DragSource := true;
  ShellListView1.ColumnSorted := true;
  InitSortSpec(LstFiles.Columns[0], true, FSortSpecification);

  TModelConv.CmbModelDevices(CmbModel.Items);
  CmbModel.AdjustWidths;

  ExploreList := TStringList.Create;
  ExploreList.NameValueSeparator := #9;
  ExploreList.Sorted := true;
  ExploreList.Duplicates := TDuplicates.dupIgnore;
  TsExplore.TabVisible := false;

  ReadSettings;

  ATripList := TTripList.Create;
  APOIList := TPOIList.Create;
  AFitInfo := TStringList.Create;

  try
    AFilePath := GetRegistry(Reg_PrefFileSysFolder_Key);
    if (AFilePath <> '') and
       (DirectoryExists(AFilePath)) then
      ShellTreeView1.Path := AFilePath;
  except
    ShellTreeView1.Root := Reg_PrefFileSysFolder_Val;
  end;
  SetDeviceListColumns;
  GetDeviceList;
  SelectKnownDevice;

  // Get files from device
  ClearDeviceDbFiles;  // Should not be there.
  if (CheckDevice(false)) then
  begin
    ReadDeviceDB;
    ListFiles;
  end;
end;

procedure TFrmTripManager.FormDestroy(Sender: TObject);
begin
  DirectoryMonitor.Free;
  ModifiedList.Free;
  ExploreList.Free;

  if not USBEvent.UnRegisterUSBHandler then
    ShowMessage('Failed to unregister USB Events');
  USBEvent.Free;

  ClearTripInfo;
  ATripList.Free;
  APOIList.Free;
  AFitInfo.Free;
  FreeDevices;
end;

procedure TFrmTripManager.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssAlt in Shift) then
  begin
    case Key of
      VK_DOWN:
        begin
          Key := 0;
          MnuNextDiffClick(MnuNextDiff);
        end;
      VK_UP:
        begin
          Key := 0;
          MnuPrevDiffClick(MnuPrevDiff);
        end;
    end;
  end;
  if (ssCtrl in Shift) and
     (ssAlt in Shift) then
  begin
    case Chr(Key) of
      'C':
        begin
          Key := 0;
          CompareWithGpx(MnuCompareGpxTrack);
        end;
      'B':
        begin
          Key := 0;
          CompareWithGpx(MnuCompareGpxRoute);
        end;
    end;
  end;
end;

procedure TFrmTripManager.FormShow(Sender: TObject);
begin
  PCTTripInfo.ActivePageIndex := 0;
  PctHexOsm.ActivePageIndex := 1;
end;

procedure TFrmTripManager.FreeDeviceData(const ACustomData: pointer);
begin
  if (Assigned(ACustomData)) then
  begin
    TMTP_Device(ACustomData).PortableDev := nil;
    TMTP_Device(ACustomData).Free;
  end;
end;

procedure TFrmTripManager.FreeDevices;
var Indx: integer;
begin
  if (Assigned(DeviceList)) then
  begin
    for Indx := 0 to DeviceList.Count - 1 do
      FreeDeviceData(DeviceList[Indx]);
    FreeAndNil(DeviceList);
  end;
  CmbDevices.Items.Clear;
end;

procedure TFrmTripManager.GetDeviceList(KeepDevice: string = '');
var
  Index, DevId: integer;
begin
  // Not really needed
  CloseDevice;

  // Get updated devicelist
  FreeDevices;
  DeviceList := GetDevices;

  // Add to ComboBox
  for Index := 0 to DeviceList.Count - 1 do
    CmbDevices.Items.AddObject(TMTP_Device(DeviceList[Index]).DisplayedDevice, TMTP_Device(DeviceList[Index]));

  // Reopen Device, and reposition ComboBox to new position
  DevId := TMTP_Device.DeviceIdInList(KeepDevice, DeviceList);
  if (DevId < 0) then
  begin
    // Device not found
    CmbDevices.ItemIndex := -1;
    CmbDevices.Text := SelectMTPDevice;
    LstFiles.Clear;
  end
  else
  begin
    // Device is still there. Re-connect and set ComboBox
    CurrentDevice := DeviceList[DevId];
    if (ConnectToDevice(CurrentDevice.Device, CurrentDevice.PortableDev)) then
      CmbDevices.ItemIndex := DevId;
  end;
end;

procedure TFrmTripManager.SelectDevice(const Indx: integer);
begin
  CloseDevice;
  FSavedParent := '';
  FSavedFolderId := '';

  if (Indx < 0) or
     (Indx > DeviceList.Count - 1) then
    exit;

  CurrentDevice := DeviceList[Indx];
  if not ConnectToDevice(CurrentDevice.Device, CurrentDevice.PortableDev, false) then
    raise exception.Create(Format('Device %s could not be opened.', [CurrentDevice.DisplayedDevice]));

  // Guess model from DisplayedDevice
  GuessModel(CurrentDevice.DisplayedDevice);

  // Refresh Trips folder? (Zumo 3x0)
  if (NeedRecreateTrips[TModelConv.Display2Trip(GetRegistry(Reg_CurrentModel, 0))]) then
    RecreateTrips;

  // Need to set the folder?
  if (DeviceFolder[BgDevice.ItemIndex] <> '') then
  begin
    SetCurrentPath(DeviceFolder[BgDevice.ItemIndex]);
    if (CheckDevice(false)) then
      ListFiles;
  end;
end;

procedure TFrmTripManager.SelectKnownDevice;
begin
  CmbDevices.ItemIndex := -1;
  CmbDevices.Text := SelectMTPDevice;
  CmbDevices.ItemIndex := TModelConv.KnownDeviceIndex(DeviceList);
  SelectDevice(CmbDevices.ItemIndex);
end;

procedure TFrmTripManager.SelectDeviceById(const Device: string);
var
  Index: integer;
begin
  if (Device = '') then
  begin
    SelectKnownDevice;
    exit;
  end;

  CmbDevices.ItemIndex := -1;
  CmbDevices.Text := SelectMTPDevice;

  for Index := 0 to DeviceList.Count - 1 do
  begin
    // Does this device match our registry setting? Select right away
    if (TMTP_Device(DeviceList[Index]).Device = Device) then
    begin
      CmbDevices.ItemIndex := Index;
      SelectDevice(Index);
      break;
    end;
  end;
end;

procedure TFrmTripManager.CmbDevicesChange(Sender: TObject);
begin
  if (CmbDevices.ItemIndex > -1) and
     (CmbDevices.ItemIndex < CmbDevices.Items.Count) then
  begin
    SelectDevice(CmbDevices.ItemIndex);
    if (CheckDevice(false)) then
      ReadDeviceDB;
  end;
end;

procedure TFrmTripManager.CmbModelChange(Sender: TObject);
var
  ModelIndex: integer;
  GarminModel: TGarminModel;
begin
  ModelIndex := CmbModel.ItemIndex;
  GarminModel := TModelConv.Display2Garmin(ModelIndex);
  BgDevice.ItemIndex := 0; // Default to trips

  BgDevice.Items[0].Caption := 'Trips';
  BgDevice.Items[1].Caption := 'Gpx';
  BgDevice.Items[2].Caption := 'Poi (Gpi)';
  case GarminModel of
    TGarminModel.Zumo595,
    TGarminModel.Drive51:
      begin
        BgDevice.Items[1].Caption := 'Unused';
        BgDevice.Items[2].Caption := 'Unused';
      end;
    TGarminModel.GarminEdge:
      begin
        BgDevice.Items[0].Caption := 'Courses';
        BgDevice.Items[1].Caption := 'NewFiles';
        BgDevice.Items[2].Caption := 'Activities';
      end;
    TGarminModel.GarminGeneric,
    TGarminModel.Unknown:
      begin
        BgDevice.Items[0].Caption := 'Unused';
        BgDevice.ItemIndex := 1  // Default to GPX, if not trips capable
      end;
  end;

  SetRegistry(Reg_CurrentModel, ModelIndex);
  SetRegistry(Reg_EnableTripFuncs, TModelConv.Display2Trip(ModelIndex) <> TTripModel.Unknown);
  SetRegistry(Reg_EnableGpxFuncs,  TModelConv.GetKnownPath(ModelIndex, 1) <> '');
  SetRegistry(Reg_EnableGpiFuncs,  TModelConv.GetKnownPath(ModelIndex, 2) <> '');
  SetRegistry(Reg_EnableFitFuncs,  (GarminModel in [TGarminModel.GarminEdge]));

  ReadDefaultFolders;
  SetDeviceListColumns;

  // Not all models support all transportation and routing preferences
  // EG: Nuvi does not Motorcycling, but has Economic
  RebuildTransportAndRoutePrefMenu;
end;

procedure TFrmTripManager.CmbSQliteTabsChange(Sender: TObject);
begin
  MemoSQL.Lines.Text := Format('Select * from %s limit 1000;', [CmbSQliteTabs.Text]);
  BitBtnSQLGoClick(BitBtnSQLGo);
end;

function TFrmTripManager.GetDevicePath(const CompletePath: string): string;
var
  P: integer;
begin
  result := CompletePath;

  P := Pos('\', result);
  if (P > 1) and
     (Pos(':\', result) = 0) then
    result := Copy(result, P + 1, Length(result));
end;

procedure TFrmTripManager.SetDeviceDisplayPath;
var
  DevPath: string;
begin
  DevPath := DeviceFolder[BgDevice.ItemIndex];
  if (Pos(':', DevPath) <> 2) then
    DevPath := IncludeTrailingPathDelimiter(CurrentDevice.FriendlyName) + DevPath;
  EdDeviceFolder.Text := DevPath;
end;

procedure TFrmTripManager.SetCurrentPath(const APath: string);
var
  FriendlyPath: string;
begin
  CheckDevice;

  FSavedFolderId := GetIdForPath(CurrentDevice.PortableDev, APath, FriendlyPath);
end;

procedure TFrmTripManager.Setdeparturedatetimeofselected1Click(Sender: TObject);
var
  Arrival: TmArrival;
  ADateTime: TDateTime;
  IncrementDay: boolean;
  Rc: integer;
  AnItem: TListItem;
  ABase_Data: TBASE_Data;
  TmpTripList: TTripList;
  LocalFile: string;
  CrNormal,CrWait: HCURSOR;
begin
  if (LstFiles.Selected = nil) then
    exit;
  if (ATripList = nil) then
    exit;

  Arrival := ATripList.GetArrival;
  if (Arrival = nil) then
    exit;

  ADateTime := TUnixDate.CardinalAsDateTime(Arrival.AsUnixDateTime);
  with TFrmDateDialog.Create(nil) do
  begin
    DtPicker.DateTime := ADateTime;
    ChkIncrement.Visible := (LstFiles.SelCount > 1);
    Rc := ShowModal;
    ADateTime := DtPicker.DateTime;
    IncrementDay := ChkIncrement.Checked;
    Free;
  end;
  if Rc <> ID_OK then
    exit;

  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    TmpTripList := TTripList.Create;
    try
      for AnItem in LstFiles.Items do
      begin
        if (AnItem.Selected = false) then
          continue;
        ABase_Data := TBASE_Data(AnItem.Data);
        if (ABase_Data.IsFolder) then
          continue;

        LocalFile := IncludeTrailingPathDelimiter(CreatedTempPath) + AnItem.Caption;
        TmpTripList.LoadFromFile(LocalFile);
        Arrival := TmpTripList.GetArrival;
        Arrival.AsUnixDateTime := TUnixDate.DateTimeAsCardinal(ADateTime);
        if (IncrementDay) then
          ADateTime := IncDay(ADateTime, 1);
        TmpTripList.SaveToFile(LocalFile);

        CopyFileFromTmp(LocalFile, AnItem);
      end;
    finally
      TmpTripList.Free;
    end;
    ReloadFileList;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.SetSelectedTrips(Sender: TObject);
var AListItem: TListItem;
    CrNormal,CrWait: HCURSOR;
begin
  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    for AListItem in LstFiles.Items do
    begin
      if (AListItem.Selected) then
        SetImported(AListItem, Tbutton(Sender).Tag = 2);
    end;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.ShellListView1AddFolder(Sender: TObject; AFolder: TShellFolder; var CanAdd: Boolean);
var
  Ext: string;
begin
  Ext := ExtractFileExt(AFolder.PathName);
  CanAdd := (AFolder.IsFolder) or
            (ContainsText(Ext, GpxExtension)) or
            (ContainsText(Ext, TripExtension)) or
            (ContainsText(Ext, GPIExtension)) or
            (ContainsText(Ext, HtmlExtension)) or
            (ContainsText(Ext, KmlExtension)) or
            (ContainsText(Ext, FitExtension)) or
            (ContainsText(Ext, DBExtension));

end;

procedure TFrmTripManager.ShellListView1Click(Sender: TObject);
var
  Ext: string;
  AnItem: TlistItem;
  HasGpxSelected, HasTripSelected, HasFitSelected: boolean;
begin
  BtnAddToMap.Enabled :=  false;
  BtnSendTo.Enabled := false;
  BtnPostProcess.Enabled := false;

  if (ShellListView1.SelectedFolder = nil) then
    exit;

  HasGpxSelected := false;
  HasTripSelected := false;
  HasFitSelected := false;
  for AnItem in ShellListView1.Items do
  begin
    if (AnItem.Selected = false) or
       (ShellListView1.Folders[AnItem.Index].IsFolder) then
      continue;

    Ext := ExtractFileExt(ShellListView1.Folders[AnItem.Index].PathName);
    HasGpxSelected := HasGpxSelected or ContainsText(Ext, GpxExtension);
    HasTripSelected := HasTripSelected or ContainsText(Ext, TripExtension);
    HasFitSelected := HasFitSelected or ContainsText(Ext, FitExtension);
  end;

  BtnAddToMap.Enabled := (HasGpxSelected or HasTripSelected or HasFitSelected) and
                         (ShellListView1.SelCount = 1);
  BtnSendTo.Enabled := HasGpxSelected;
  BtnPostProcess.Enabled := HasGpxSelected;

  Ext := ExtractFileExt(ShellListView1.SelectedFolder.PathName);
  if (ContainsText(Ext, TripExtension)) then
    LoadTripFile(ShellListView1.SelectedFolder.PathName, false)
  else if (ContainsText(Ext, GPIExtension)) then
    LoadGPiFile(ShellListView1.SelectedFolder.PathName, false)
  else if (ContainsText(Ext, FitExtension)) then
    LoadFitFile(ShellListView1.SelectedFolder.PathName, false)
  else if (ContainsText(Ext, DBExtension)) then
    LoadSqlFile(ShellListView1.SelectedFolder.PathName, false);
end;

procedure TFrmTripManager.ShellListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  ShellListView1.ColumnClick(Column);
  WriteColumnSettings;
end;

procedure TFrmTripManager.ShellListView1DblClick(Sender: TObject);
begin
  if (ShellListView1.SelectedFolder = nil) then
    exit;
  if (ShellListView1.SelectedFolder.IsFolder) then
    ShellTreeView1.Path := ShellListView1.PathForParsing(ShellListView1.SelectedFolder)
  else
    ShellExecute(0, 'OPEN', PWideChar(ShellListView1.SelectedFolder.PathName), '' ,'', SW_SHOWNORMAL);
end;

procedure TFrmTripManager.ShellListView1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F2) and (ShellListView1.Selected <> nil) then
    ShellListView1.Selected.EditCaption;

  if (ssCtrl in Shift) then
  begin
    case Key of
      Ord('A'):
        begin
          ShellListView1.SelectAll;
          ShellListView1Click(Sender);
        end;
    end;
  end;
end;

procedure TFrmTripManager.ShellListView1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if ShellListView1.IsEditing then
    exit;
  if (ssAlt in Shift) then
    exit;

  case Key of
    VK_HOME,
    VK_END,
    VK_UP,
    VK_DOWN,
    VK_LEFT,
    VK_RIGHT,
    VK_PRIOR,
    VK_NEXT:
      ShellListView1Click(Sender);
  end;
end;

procedure TFrmTripManager.ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if (Self.Showing) then
    SetRegistry(Reg_PrefFileSysFolder_Key, ShellTreeView1.Path);

  EdFileSysFolder.AddFullTextSearch(ShellTreeView1.Path);

  ShellListView1Click(ShellListView1);
  ChkWatch.Checked := false;
  if (DirectoryMonitor <> nil) then
    DirectoryMonitor.Directory := ShellTreeView1.Path;
end;

procedure TFrmTripManager.ShellTreeView1CustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Node.Selected then
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];
end;

procedure TFrmTripManager.SpbCorrectUuidClick(Sender: TObject);
var
  AnITem: TListItem;
  LocalFile: string;
  TmpTriplist: TTripList;
  mExploreUuid: TmExploreUuid;
  CrNormal, CrWait: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  TmpTriplist := TTripList.Create;
  try
    for AnITem in LvExplore.Items do
    begin
      if (AnITem.GroupID <> 1) then
        continue;

      LocalFile := IncludeTrailingPathDelimiter(CreatedTempPath) + AnITem.SubItems[1];
      TmpTriplist.LoadFromFile(LocalFile);
      mExploreUuid := TmpTriplist.GetItem('mExploreUuid') as TmExploreUuid;
      if (mExploreUuid = nil) then
        continue;

      mExploreUuid.AsString := AnITem.SubItems[0];
      TmpTriplist.SaveToFile(LocalFile);

      CopyFileFromTmp(LocalFile, TListItem(AnITem.Data));
    end;
    CheckExploreDb;
  finally
    TmpTriplist.Free;
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.SpbRefreshExploreClick(Sender: TObject);
begin
  CheckExploreDb;
end;

procedure TFrmTripManager.SpeedBtn_MapClearClick(Sender: TObject);
begin
  DeleteTempFiles(GetOSMTemp, GetTracksMask);
  if (CreateOSMMapHtml(GetRegistry(Reg_SavedMapPosition_Key, Reg_DefaultCoordinates))) then
    EdgeBrowser1.Navigate(GetHtmlTmp);
end;

procedure TFrmTripManager.AddToMap(FileName: string);
var
  MapTrip: TTripList;
  OsmTrack: TStringList;
  Ext, ActGpxFile, OOutput, OError: string;
  Rc: DWord;
begin
  Ext := ExtractFileExt(FileName);
  OsmTrack := TStringList.Create;
  try
    if (ContainsText(Ext, TripExtension)) then
    begin
      MapTrip := TTripList.Create;
      try
        if not MapTrip.LoadFromFile(FileName) then
          exit;
        LoadTripOnMap(MapTrip, Format('%s%s', [FileSysTrip, ExtractFileName(FileName)]));
      finally
        MapTrip.Free;
      end;
    end
    else
    begin
      ActGpxFile := FileName;
      if (ContainsText(Ext, FitExtension)) then
      begin
        DeleteTempFiles(GetRoutesTmp, '*.*');
        Sto_RedirectedExecute(Format('Fit2Gpx.exe "%s"', [ActGpxFile]),
                              GetRoutesTmp, OOutput, OError, Rc);
        if (Rc <> 0) then
          raise Exception.Create(OOutput + #10 + OError);
        ActGpxFile := GetRoutesTmp + ChangeFileExt(ExtractFilename(ActGpxFile), GpxExtension);
        TFile.WriteAllText(ActGpxFile, OOutput);
      end;

      TGPXFile.PerformFunctions([CreateOSMPoints], ActGpxFile,
                                 nil, SetProcessOptions.SavePrefs,
                                 '', OsmTrack);
      OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s%s',
                                              [App_Prefix,
                                              FileSysTrip,
                                              ExtractFileName(ActGpxFile),
                                              GetTracksExt]));
    end;

    if (CreateOSMMapHtml) then
      EdgeBrowser1.Navigate(GetHtmlTmp);

  finally
    OsmTrack.Free;
  end;
end;

procedure TFrmTripManager.MnuAddtoMapClick(Sender: TObject);
begin
  AddToMap(ShellListView1.SelectedFolder.PathName);
end;

procedure TFrmTripManager.OpenInKurviger(const FileName: string);
var
  OsmTrack: TStringList;
  TmpTripList: TTripList;
  Url, Ext: string;
begin
  Ext := ExtractFileExt(FileName);
  if (ContainsText(Ext, TripExtension)) then
  begin
    TmpTripList := TTripList.Create;
    try
      TmpTripList.LoadFromFile(FileName);
      ShellExecute(0, 'Open', PChar(TmpTripList.KurvigerUrl), '','', SW_SHOWNORMAL);
    finally
      TmpTripList.Free;
    end;
  end
  else if (ContainsText(Ext, GPXExtension)) then
  begin
    OsmTrack := TStringList.Create;
    try
      TGPXFile.PerformFunctions([CreateKurviger], FileName,
                                 nil, SetProcessOptions.SavePrefs,
                                 '', OsmTrack);
      for Url in OsmTrack do
        ShellExecute(0, 'OPEN', PWideChar(Url), '', '', SW_SHOWNORMAL);

    finally
      OsmTrack.Free;
    end;
  end;
end;

procedure TFrmTripManager.DeviceFilesOnMap(Tag: integer);
var
  AnItem: TlistItem;
  TempFile: string;
begin
  for AnItem in LstFiles.Items do
  begin
    if (AnItem.Selected = false) then
      continue;
    if (TMTP_Data(AnItem.Data).IsFolder) then
      continue;

    if (SameText(TripExtension, AnItem.SubItems[2])) or
       (SameText(GPXExtension, AnItem.SubItems[2])) then
    begin
      TempFile := CopyFileToTmp(AnItem);
      if (TempFile = '') then
        continue;
      case (Tag) of
        1:
          AddToMap(TempFile);
        2:
          OpenInKurviger(TempFile);
      end;
    end;
  end;
end;

procedure TFrmTripManager.ShowDeviceFilesOnMap(Sender: TObject);
begin
  DeviceFilesOnMap(TMenuItem(Sender).Tag);
end;

procedure TFrmTripManager.MnuOpenInKurvigerClick(Sender: TObject);
begin
  OpenInKurviger(ShellListView1.SelectedFolder.PathName);
end;

procedure TFrmTripManager.BtnAddToMapMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ShellListView1.SelectedFolder = nil then
    exit;

  if (ssCtrl in Shift) then
    OpenInKurviger(ShellListView1.SelectedFolder.PathName)
  else
    AddToMap(ShellListView1.SelectedFolder.PathName);
end;

procedure TFrmTripManager.LoadTripOnMap(CurrentTrip: TTripList; Id: string);
var
  OsmTrack: TStringList;
  TrackToRouteInfoMap: TmTrackToRouteInfoMap;
  ProcessOptions: TProcessOptions;
begin
  if not Assigned(CurrentTrip) then
    exit;

  ProcessOptions := TProcessOptions.Create;
  OsmTrack := TStringList.Create;

  try
    DeleteCompareFiles;
    DeleteTripTrackFiles;

    CurrentTrip.CreateOSMPoints(OsmTrack, OSMColor(GetRegistry(Reg_TripColor_Key, Reg_TripColor_Val)));
    OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s', [App_Prefix, Id, GetTracksExt]));
    TrackToRouteInfoMap := CurrentTrip.GetItem('mTrackToRouteInfoMap') as TmTrackToRouteInfoMap;
    if (Assigned(TrackToRouteInfoMap)) and
       (TrackToRouteInfoMap.FTrackHeader.TrackPoints.TrkPntCnt > 0)  then
    begin
      OsmTrack.Text := TrackToRouteInfoMap.GetCoords(ProcessOptions.TripTrackColor);
      OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s_track%s', [App_Prefix, Id, GetTracksExt]));
    end;
    if (CreateOSMMapHtml) then
      EdgeBrowser1.Navigate(GetHtmlTmp);
  finally
    OsmTrack.Free;
    ProcessOptions.Free;
  end;
end;

procedure TFrmTripManager.LoadGpiOnMap(CurrentGpi: TPOIList; Id: string);
var
  OsmTrack: TStringList;
  AGPXwayPoint: TGPXWayPoint;
  Category: string;
begin
  if not Assigned(CurrentGpi) then
    exit;
  OsmTrack := TStringList.Create;
  try
    for AGPXwayPoint in CurrentGpi do
    begin
      Category := Format('Poi Symbol: %s ', [AGPXwayPoint.Symbol]);
      if (AGPXwayPoint.Category <> '') then
        Category := Category + Format('Category: %s ', [AGPXwayPoint.Category]);
      if (AGPXwayPoint.Speed <> 0) then
        Category := Category + Format('Speed: %d ', [AGPXwayPoint.Speed]);
      Category := EscapeDQuote(Category);
      OsmTrack.Add(Format('AddPOI("%s", %s, %s, "./%s.png", "%s");',
                          [EscapeDQuote(string(AGPXwayPoint.Name)),
                           AGPXwayPoint.Lat, AGPXwayPoint.Lon,
                           AGPXwayPoint.Symbol, Category] ));
    end;
    DeleteCompareFiles;
    OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s', [App_Prefix, Id, GetTracksExt]));
    if (CreateOSMMapHtml) then
      EdgeBrowser1.Navigate(GetHtmlTmp);

  finally
    OsmTrack.Free;
  end;
end;

procedure TFrmTripManager.LoadFitOnMap(FitAsGpxFile: string; Id: string);
var
  OsmTrack: TStringList;
begin
  OsmTrack := TStringList.Create;
  try
    TGPXFile.PerformFunctions([CreateOSMPoints], FitAsGpxFile,
                              SetProcessOptions.SetSkipTrackDlgPrefs, SetProcessOptions.SavePrefs,
                              '', OsmTrack);
    OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s', [App_Prefix, Id, GetTracksExt]));

    if (CreateOSMMapHtml) then
      EdgeBrowser1.Navigate(GetHtmlTmp);

  finally
    OsmTrack.Free;
  end;
end;

function TFrmTripManager.CheckTrip(const AListItem: TListItem; const ALocalFile: string = ''): boolean;
var
  TmpTripList: TTripList;
  LocalFile: string;
  Imported: TBooleanItem;
  AMTP_Data: TMTP_Data;
begin
  result := false;

  if (ContainsText(AListItem.SubItems[2], TripExtension) = false) then
    exit;

  if (AListItem.Data <> nil) and
     (TObject(AListItem.Data) is TMTP_Data) then
    AMTP_Data := TMTP_Data(AListItem.Data)
  else
    exit;

  if (AMTP_Data.IsFolder) then
    exit;

  TmpTripList := TTripList.Create;
  try
    if (ALocalFile <> '') then
      // Local file already current
      LocalFile := ALocalFile
    else
      // Copy File to Local directory
      LocalFile := CopyFileToTmp(AListItem);

    if (LocalFile = '') then // Copy failed?
      exit;

    // Check mImported, Calculation and Explore UUID by loading tmp file
    TmpTripList.LoadFromFile(LocalFile);

    // Check Imported/Saved
    Imported := TBooleanItem(TmpTripList.GetItem('mImported'));
    AMTP_Data.IsNotSavedTrip := (Imported <> nil) and
                                Imported.AsBoolean;
    SetCheckMark(AListItem, not AMTP_Data.IsNotSavedTrip);

    // Check Calculated
    AMTP_Data.IsCalculated := TmpTripList.IsCalculated;
    if (AMTP_Data.IsCalculated = false) then
      AListItem.ImageIndex := 2;

    // Save Explore UUID
    AMTP_Data.ExploreUUID := TmpTripList.ExploreUUID;

    // Show trip name
    AListItem.SubItems[TripNameCol -1] := TmpTripList.TripName;

    // File Checked
    result := true;

  finally
    TmpTripList.Free;
  end;
end;

procedure TFrmTripManager.CheckTrips;
var
  AListItem: TListItem;
  CrNormal,CrWait: HCURSOR;
  CanUseStatusBar, TripChecked: boolean;
begin
  if (GetRegistry(Reg_EnableTripFuncs, false) = false) then
    exit;
  if (GetRegistry(Reg_EnableFitFuncs, false) = true) then
    exit;

  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);

  CanUseStatusBar := (SbPostProcess.Panels[0].Text = '') and
                     (SbPostProcess.Panels[1].Text = '');
  if (CanUseStatusBar) then
    SbPostProcess.Panels[1].Text := 'Trip file checked';
  try
    for AListItem in LstFiles.Items do
    begin
      TripChecked := CheckTrip(AListItem);
      if (TripChecked) and
         (CanUseStatusBar) then
      begin
        SbPostProcess.Panels[0].Text := AListItem.Caption;
        SbPostProcess.Update;
      end;
    end;
  finally
    SetCursor(CrNormal);
    StatusTimer.Enabled := false;
    StatusTimer.Enabled := true;
  end;
end;

procedure TFrmTripManager.RecreateTrips;
var
  FriendlyPath, TempFile, SystemPath, SystemTripsPath, LastRefreshFile: string;
  Rc: integer;
  Fs: TSearchRec;
  CrNormal,CrWait: HCURSOR;
  AListItem: TListItem;
  File_Info: TFile_Info;
  LDelim: integer;
  SystemId, SystemTripsId, SystemSqlId: string;
  CompletePath: WideString;
begin
  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);

  try
    // Make sure we do this for the .System\Trips folder
    ReadDefaultFolders;

    SystemTripsId := GetIdForPath(CurrentDevice.PortableDev, DeviceFolder[0], FriendlyPath);
    LDelim := LastDelimiter('\', FriendlyPath) -1;
    SystemPath := Copy(FriendlyPath, 1, LDelim);          // .System
    SystemTripsPath := ExtractFileName(FriendlyPath);     // Trips
    if not SameText(TripsPath, SystemTripsPath) then      // And the sub folder should be Trips
      exit;

    // DateTime of system.db
    SystemSqlId := GetIdForPath(CurrentDevice.PortableDev, GetDbPath, FriendlyPath);
    if (GetIdForFile(CurrentDevice.PortableDev, SystemSqlId, SystemDb, File_Info) = '') then
      exit;

    // Is there a .tmp in trips?
    LastRefreshFile := Format('%10d.tmp', [TUnixDate.DateTimeAsCardinal(File_Info.ObjDate)]);
    if (GetIdForFile(CurrentDevice.PortableDev, SystemTripsId, LastRefreshFile) <> '') then
      exit;

    SbPostProcess.Panels[0].Text := 'Recreating directory';
    SbPostProcess.Panels[1].Text := DeviceFolder[0];
    SbPostProcess.Update;

    // Need to recreate trips
    ReadFilesFromDevice(CurrentDevice.PortableDev, LstFiles.Items, SystemTripsId, CompletePath);

    // Clean temp
    DeleteTempFiles(CreatedTempPath, '*.*');

    // Create lastrefresh file
    TFile.WriteAllText(CreatedTempPath + LastRefreshFile, '');

    // Copy Files to Temp directory
    for AListItem in LstFiles.Items do
    begin
      if (ContainsText(AListItem.SubItems[2], TripExtension) = false) then
        continue;

      TempFile := CopyFileToTmp(AListItem);
      if (TempFile = '') then
        exit;
    end;

    // Delete and recreate .System\Trips
    DelFromDevice(CurrentDevice.PortableDev, SystemTripsId, true);
    SystemId := GetIdForPath(CurrentDevice.PortableDev, SystemPath, FriendlyPath);
    CreatePath(CurrentDevice.PortableDev, SystemId, SystemTripsPath);

    SetCurrentPath(DeviceFolder[0]); // Rescan .System\Trips
    if (TransferNewFileToDevice(CurrentDevice.PortableDev, CreatedTempPath + LastRefreshFile, FSavedFolderId) = '') then
      raise Exception.Create(Format('Could not overwrite file: %s on %s',
                                    [LastRefreshFile, CurrentDevice.DisplayedDevice]));

    Rc := FindFirst(CreatedTempPath + TripMask, faAnyFile - faDirectory, Fs);
    while (Rc = 0) do
    begin
      // Save the File name and Extension. The rest of the loop must use these vars.
      TempFile := Fs.Name;
      // Make sure we read the next, so we can use Continue in the loop
      Rc := FindNext(Fs);

      // Transfer
      TempFile := IncludeTrailingPathDelimiter(CreatedTempPath) + TempFile;

      // Did the transfer work?
      if (TransferNewFileToDevice(CurrentDevice.PortableDev, TempFile, FSavedFolderId) = '') then
        raise Exception.Create(Format('Could not overwrite file: %s on %s',
                                      [ExtractFileName(TempFile), CurrentDevice.DisplayedDevice]));
    end;

    FindClose(Fs);
    SbPostProcess.Panels[0].Text := 'Directory recreated succesfully';
  finally
    SetCursor(CrNormal);
    StatusTimer.Enabled := false;
    StatusTimer.Enabled := true;
  end;
end;

procedure TFrmTripManager.ChkWatchClick(Sender: TObject);
begin
  if (DirectoryMonitor <> nil) then
  begin
    DirectoryMonitor.Active := ChkWatch.Checked;
    if (DirectoryMonitor.Active) then
      ShellListView1.ClearSelection;
  end;
end;

function TFrmTripManager.SelectedScPosn: TmScPosn;
var
  AGridSel: TGridSelItem;
begin
  result := nil;

  AGridSel := TGridSelItem.GridSelItem(VlTripInfo, VlTripInfo.Row -1);
  if (AGridSel <> nil) and
     (AGridSel.BaseItem <> nil) and
     (AGridSel.BaseItem is TmScPosn) then
    exit(TmScPosn(AGridSel.BaseItem));
end;

function TFrmTripManager.SelectedLocation: TLocation;
begin
  result := nil;

  if (TvTrip.Selected = nil) then
    exit;

  if (TvTrip.Selected.Data <> nil) and
     (TObject(TvTrip.Selected.Data) is TLocation) then
    exit(TLocation(TvTrip.Selected.Data));

  if (TvTrip.Selected.Parent <> nil) and
     (TvTrip.Selected.Parent.Data <> nil) and
     (TObject(TvTrip.Selected.Parent.Data) is TLocation) then
    exit(TLocation(TvTrip.Selected.Parent.Data));
end;

procedure TFrmTripManager.EnableApplyCoords;
begin
  BtnApplyCoords.Enabled := FrmTripEditor.Showing or
                            FrmShowLog.Showing or
                            (SelectedLocation <> nil) or
                            (SelectedScPosn <> nil);
end;

procedure TFrmTripManager.QueryDeviceClick(Sender: TObject);
begin
  LoadSqlFile(GetDeviceTmp + StripHotkey(TMenuItem(Sender).Caption), false);
end;

procedure TFrmTripManager.ClearDeviceDbFiles;
begin
  ExploreList.Clear;
  DeleteTempFiles(GetDeviceTmp, '*.db');
  RebuildDeviceDbMenu;
end;

procedure TFrmTripManager.RebuildTransportAndRoutePrefMenu;
var
  ATripModel: TTripModel;
  ASubMenuItem: TMenuItem;
  PickList: TStringList;
  ALine: string;
begin
  PickList := TStringList.Create;
  try
    ATripModel := TModelConv.Display2Trip(GetRegistry(Reg_CurrentModel, 0));

    MnuSetTransportMode.Clear;
    PickList.Text := TmTransportationMode.ModelPickList(ATripModel);
    for ALine in PickList do
    begin
      ASubMenuItem := TMenuItem.Create(MnuSetTransportMode);
      ASubMenuItem.Caption  := ALine;
      ASubMenuItem.Tag      := Ord(TmTransportationMode.TransPortMethod(ALine));
      ASubMenuItem.OnClick  := TransportModeClick;
      MnuSetTransportMode.Add(ASubMenuItem);
    end;

    MnuSetRoutePref.Clear;
    PickList.Text := TmRoutePreference.ModelPickList(ATripModel);
    for ALine in PickList do
    begin
      ASubMenuItem := TMenuItem.Create(MnuSetRoutePref);
      ASubMenuItem.Caption  := ALine;
      ASubMenuItem.Tag      := Ord(TmRoutePreference.RoutePreference(ALine));
      ASubMenuItem.OnClick  := RoutePreferenceClick;
      MnuSetRoutePref.Add(ASubMenuItem);
    end;
  finally
    PickList.Free;
  end;
end;

procedure TFrmTripManager.RebuildDeviceDbMenu;
var
  Rc: integer;
  Fs: TSearchRec;
  ASubMenuItem: TMenuItem;
begin
  MnuQueryDeviceDb.Clear;

  Rc := FindFirst(IncludeTrailingPathDelimiter(GetDeviceTmp) + '*.db', faAnyFile - faDirectory, Fs);
  while (Rc = 0) do
  begin
    ASubMenuItem := TMenuItem.Create(MnuQueryDeviceDb);
    ASubMenuItem.Caption := Fs.Name;
    ASubMenuItem.OnClick := QueryDeviceClick;
    MnuQueryDeviceDb.Add(ASubMenuItem);

    Rc := FindNext(Fs);
  end;
  FindClose(Fs);
end;

procedure TFrmTripManager.ClearSelHexEdit;
begin
  // Default no selection
  if (HexEdit.DataSize > 0) then
  begin
    HexEdit.SelStart := 0;
    HexEdit.SelEnd := -1;
  end;

  EnableApplyCoords;

end;

procedure TFrmTripManager.SyncHexEdit(Sender: TObject);
var
  ANode: TBaseItem;
  HeaderOffset: integer;
  SelStart, SelEnd: integer;
begin

  ClearSelHexEdit;

  ANode := nil;
  SelStart := -1;
  SelEnd := -1;

  if (Sender is TGridSelItem) then
  begin
    ANode := TGridSelItem(Sender).BaseItem;
    SelStart := TGridSelItem(Sender).SelStart;
    SelEnd := SelStart + TGridSelItem(Sender).SelLength;
  end;

  if (Sender is TBaseItem) then
  begin
    ANode := TBaseItem(Sender);
    SelStart := ANode.SelStart;
    SelEnd := ANode.SelEnd;
  end;

  if (Sender is TGPXWayPoint) then
  begin
    SelStart := TGPXWayPoint(Sender).SelStart;
    SelEnd := SelStart + TGPXWayPoint(Sender).SelLength;
  end;

  if (ANode = nil) or
     (ANode is THeader) then
    HeaderOffset := 0
  else
    HeaderOffset := SizeOf(THeaderValue);

  SelStart := SelStart + HeaderOffset;
  if (SelStart < 0) then
    exit;
  if (SelStart >= HexEdit.DataSize) then
    SelStart := HexEdit.DataSize -1;

  SelEnd := SelEnd + HeaderOffset - SizeOf(biInitiator);
  if (SelEnd < SelStart) then
    SelEnd := SelStart;
  if (SelEnd >= HexEdit.DataSize) then
    SelEnd := HexEdit.DataSize -1;

  // Set new selection
  HexEdit.SelStart := SelStart;
  HexEdit.SelEnd := SelEnd;

  // Position selection on top
  if (HexEdit.BytesPerRow > 0) then
    HexEdit.TopRow := SelStart div HexEdit.BytesPerRow;
end;

// Defer loading trips. Speeds up selecting files
procedure TFrmTripManager.TripGpiTimerTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;

  if (LstFiles.Selected = nil) then
    exit;
  if TBASE_Data(LstFiles.Selected.Data).IsFolder then
    exit;

  if (ContainsText(LstFiles.Selected.SubItems[2], TripExtension)) or
     (ContainsText(LstFiles.Selected.SubItems[2], GpiExtension)) or
     (ContainsText(LstFiles.Selected.SubItems[2], FitExtension)) then
  begin
    CopyFileToTmp(LstFiles.Selected);
    if (ContainsText(LstFiles.Selected.SubItems[2], GpiExtension)) then
      LoadGpiFile(IncludeTrailingPathDelimiter(CreatedTempPath) + LstFiles.Selected.Caption, true)
    else if (ContainsText(LstFiles.Selected.SubItems[2], FitExtension)) then
      LoadFitFile(IncludeTrailingPathDelimiter(CreatedTempPath) + LstFiles.Selected.Caption, true)
    else
      LoadTripFile(IncludeTrailingPathDelimiter(CreatedTempPath) + LstFiles.Selected.Caption, true);
  end;
end;

procedure TFrmTripManager.TvTripChange(Sender: TObject; Node: TTreeNode);
var
  AnItem: TBaseItem;
  Index: integer;

  procedure AddBaseData(ABaseData: TBaseDataItem);
  begin
    VlTripInfo.Strings.AddObject(ABaseData.DisplayName + VlTripInfo.Strings.NameValueSeparator + ABaseData.AsString,
                                 TGridSelItem.Create(ABaseData));
  end;

  procedure AddScPosn(AScPosn: TmScPosn);
  begin
    VlTripInfo.Strings.AddPair(AScPosn.DisplayName, AScPosn.AsString,
                               TGridSelItem.Create(AScPosn));
    VlTripInfo.Strings.AddObject(AScPosn.DisplayName + '_LatLon' + VlTripInfo.Strings.NameValueSeparator + AScPosn.MapCoords,
                                 TGridSelItem.Create(AScPosn, AScPosn.LenValue, AScPosn.OffsetValue));
  end;

  procedure AddTrackToRouteInfoMap(ATrackToRouteInfoMap: TmTrackToRouteInfoMap);
  var
    Offset: integer;
    CoordsList: TStringList;
    ACoord: string;
  begin
    CoordsList := TStringList.Create;
    try
      VlTripInfo.Strings.AddPair('*** mTrackToRouteInfoMap', DupeString('-', DupeCount),
                                 TGridSelItem.Create(ATrackToRouteInfoMap));

      if (ATrackToRouteInfoMap.FTrackHeader.TrackPoints.TrkPntCnt > 0) then
      begin
        Offset := ATrackToRouteInfoMap.OffsetValue + OffsetInRecord(ATrackToRouteInfoMap.FTrackHeader,
                                                                    ATrackToRouteInfoMap.FTrackHeader.TrackPoints.ValueLen);
        VlTripInfo.Strings.AddPair('Track size', Format('%d', [Swap32(ATrackToRouteInfoMap.FTrackHeader.TrackPoints.ValueLen)]),
                                   TGridSelItem.Create(ATrackToRouteInfoMap,
                                                       SizeOf(ATrackToRouteInfoMap.FTrackHeader.TrackPoints.ValueLen), Offset));

        Offset := ATrackToRouteInfoMap.OffsetValue + OffsetInRecord(ATrackToRouteInfoMap.FTrackHeader,
                                                                    ATrackToRouteInfoMap.FTrackHeader.TrackPoints.TrkPntCnt);
        VlTripInfo.Strings.AddPair('Track points', Format('%d', [Swap32(ATrackToRouteInfoMap.FTrackHeader.TrackPoints.TrkPntCnt)]),
                                   TGridSelItem.Create(ATrackToRouteInfoMap,
                                                       SizeOf(ATrackToRouteInfoMap.FTrackHeader.TrackPoints.TrkPntCnt), Offset));

        CoordsList.Text := ATrackToRouteInfoMap.GetCoords;
        Offset := SizeOf(ATrackToRouteInfoMap.FTrackHeader);
        for ACoord in CoordsList do
        begin
          VlTripInfo.Strings.AddPair('trkpt', ACoord,
                                     TGridSelItem.Create(ATrackToRouteInfoMap,
                                                         SizeOf(TTrackPoint), ATrackToRouteInfoMap.OffsetValue + Offset));
          Inc(Offset, SizeOf(TTrackPoint));
        end;
      end;
      VlTripInfo.Strings.AddPair('*** End mTrackToRouteInfoMap', DupeString('-', DupeCount),
                                 TGridSelItem.Create(ATrackToRouteInfoMap, 1, ATrackToRouteInfoMap.SelEnd - ATrackToRouteInfoMap.SelStart -1 ));
    finally
      CoordsList.Free;
    end;
  end;

  procedure AddRoutePreferences(ARoutePreferences: TBaseRoutePreferences);
  var
    SegmentNr: integer;
    Segments: TStringList;
    Offset: Cardinal;
  begin
    Segments := TStringList.Create;
    try
      Offset := (ARoutePreferences.SelEnd - ARoutePreferences.SelStart - ARoutePreferences.LenValue) +
                SizeOf(biInitiator);
      if (ARoutePreferences is TmRoutePreferencesAdventurousMode) then
        Segments.Text := ARoutePreferences.GetRoutePrefs(ATripList.GetItem('mRoutePreferences'))
      else
        Segments.Text := ARoutePreferences.GetRoutePrefs;
      VlTripInfo.Strings.AddObject(Format('%s #Segments', [ARoutePreferences.Name]) +
                                     VlTripInfo.Strings.NameValueSeparator +
                                     Format('%d', [ARoutePreferences.Count]),
                                   TGridSelItem.Create(ARoutePreferences));
      Inc(Offset, SizeOf(Cardinal));
      for SegmentNr := 0 to Segments.Count -1 do
      begin
        VlTripInfo.Strings.AddObject(Format('Segment %d', [SegmentNr +1]) + VlTripInfo.Strings.NameValueSeparator + Segments[SegmentNr],
                                     TGridSelItem.Create(ARoutePreferences, SizeOf(Word), Offset));
        Inc(Offset, SizeOf(Word));
      end;
    finally
      Segments.Free;
    end;
  end;

  procedure AddLink(ANode: TTreeNode; ALink: TLink);
  var
    ANitem: TBaseItem;
  begin
    if not Assigned(ANode) then
      exit;

    with ALink do
      VlTripInfo.Strings.AddPair('*** Link', ANode.Text,
                                 TGridSelItem.Create(ALink) );
    for ANitem in ALink.Items do
    begin
      if (ANitem is TBaseDataItem) then
        AddBaseData(TBaseDataItem(ANitem));
    end;

    with ALink do
      VlTripInfo.Strings.AddPair('*** End Link', DupeString('-', DupeCount),
                                 TGridSelItem.Create(ALink, 1,
                                                     (ALink.SelEnd - ALink.SelStart) -1) );
  end;

  procedure AddAllLinks(ANode: TTreeNode; AAllLinks: TmAllLinks);
  var
    ANitem: TBaseItem;
    ChildNode: TTreeNode;
  begin

    VlTripInfo.Strings.AddPair('*** AllLinks header', '',
                               TGridSelItem.Create(AAllLinks));
    ChildNode := Anode.getFirstChild;
    for ANitem in AAllLinks.Links do
    begin
      if (ChildNode = nil) then
        break;
      if (ANitem is TLink) then
      begin
        AddLink(ChildNode, TLink(ANitem));
        ChildNode := Anode.GetNextChild(ChildNode);
      end;
    end;

    VlTripInfo.Strings.AddPair('*** End AllLinks', DupeString('-', DupeCount),
                               TGridSelItem.Create(AAllLinks, 1, AAllLinks.SelEnd - AAllLinks.SelStart -1));
  end;

  procedure AddLocation(ALocation: TLocation; ZoomToPoint: boolean);
  var
    ANitem: TBaseItem;
    LocationName, GpsCoords, RoutePreference, AdventurousLevel: string;
  begin
    LocationName := ALocation.LocationTmName.AsString;
    GpsCoords := ALocation.LocationTmScPosn.MapCoords;

    if (ZoomToPoint) then
      MapRequest(GpsCoords, LocationName, RoutePointTimeOut);

    with ALocation do
    begin
      VlTripInfo.Strings.AddPair('*** Location header', LocationName,
                                 TGridSelItem.Create(ALocation));

      VlTripInfo.Strings.AddPair('ID', string(LocationValue.Id),
                                 TGridSelItem.Create(ALocation,
                                                     SizeOf(LocationValue.ID),
                                                     OffsetInRecord(LocationValue, LocationValue.ID) ));

      VlTripInfo.Strings.AddPair('Size', Format('%d', [LocationValue.Size]),
                                 TGridSelItem.Create(ALocation,
                                                     SizeOf(LocationValue.Size),
                                                     OffsetInRecord(LocationValue, LocationValue.Size) ));

      VlTripInfo.Strings.AddPair('DataType', Format('%d', [LocationValue.DataType]),
                                 TGridSelItem.Create(ALocation, SizeOf(LocationValue.DataType), OffsetInRecord(LocationValue, LocationValue.DataType) ));

      VlTripInfo.Strings.AddPair('Count', Format('%d', [LocationValue.Count]),
                                 TGridSelItem.Create(ALocation,
                                                     SizeOf(LocationValue.Count),
                                                     OffsetInRecord(LocationValue, LocationValue.Count) ));
      if (IntToIdent(Ord(ALocation.RoutePref), RoutePreference, RoutePreferenceMap)) then
      begin
        AdventurousLevel := '';
        if (ALocation.RoutePref = TRoutePreference.rmCurvyRoads) then
           IntToIdent(Ord(ALocation.AdvLevel), AdventurousLevel, AdvLevelMap);

        VlTripInfo.Strings.AddPair('RoutePref', Format('%s %s', [RoutePreference, AdventurousLevel]),
                                   TGridSelItem.Create(ALocation));

      end;
      VlTripInfo.Strings.AddPair('*** End location header', DupeString('-', DupeCount),
                                 TGridSelItem.Create(ALocation, 1, ALocation.SelEnd - ALocation.SelStart -1 ));
    end;

    for ANitem in ALocation.LocationItems do
    begin
      if (AnItem is TmScPosn) then
        AddScPosn(TmScPosn(ANitem))
      else if (ANitem is TBaseDataItem) then
        AddBaseData(TBaseDataItem(ANitem));
    end;

    with ALocation do
      VlTripInfo.Strings.AddPair('*** End location', DupeString('-', DupeCount),
                                 TGridSelItem.Create(ALocation, 1,
                                                     SizeOf(LocationValue.Id) + SizeOf(LocationValue.Size) + LocationValue.Size -1) );
  end;

  procedure AddLocations(AmLocations: TmLocations);
  var
    ANitem: TBaseItem;
  begin
    with AmLocations do
    begin
      VlTripInfo.Strings.AddPair('*** mLocations', DupeString('-', DupeCount),
                                 TGridSelItem.Create(AmLocations));

      VlTripInfo.Strings.AddPair('Size', Format('%d', [LenValue]),
                                 TGridSelItem.Create(AmLocations,
                                                     SizeOf(LenValue),
                                                     AmLocations.OffsetLenValue));

      VlTripInfo.Strings.AddPair('DataType', Format('%d', [DataType]),
                                 TGridSelItem.Create(AmLocations,
                                                     SizeOf(DataType),
                                                     AmLocations.OffsetDataType));

      VlTripInfo.Strings.AddPair('LocationCount', Format('%d', [LocationCount]),
                                 TGridSelItem.Create(AmLocations,
                                                     SizeOf(LocationCount),
                                                     AmLocations.OffsetValue));
    end;

    for ANitem in AmLocations.Locations do
    begin
      if (ANitem is TLocation) then
        AddLocation(TLocation(ANitem), false);
    end;

    VlTripInfo.Strings.AddPair('*** End locations', DupeString('-', DupeCount),
                               TGridSelItem.Create(AmLocations, 1, AmLocations.SelEnd - AmLocations.SelStart -1));
  end;

  procedure AddUdbDir(AnUdbDir: TUdbDir; ZoomToPoint: boolean);
  begin
    VlTripInfo.Strings.AddPair('*** UdbDir', DupeString('-', DupeCount), TGridSelItem.Create(AnUdbDir));
    VlTripInfo.Strings.AddPair('MapSegment + RoadId', AnUdbDir.MapSegRoadDisplay,
                              TGridSelItem.Create(AnUdbDir,
                                                  SizeOf(AnUdbDir.UdbDirValue.SubClass.MapSegment) +
                                                    SizeOf(AnUdbDir.UdbDirValue.SubClass.RoadId),
                                                  OffsetInRecord(AnUdbDir.UdbDirValue.SubClass, AnUdbDir.UdbDirValue.SubClass.MapSegment)));

    VlTripInfo.Strings.AddPair('PointType', AnUdbDir.PointType,
                              TGridSelItem.Create(AnUdbDir,
                                                  SizeOf(AnUdbDir.UdbDirValue.SubClass.PointType),
                                                  OffsetInRecord(AnUdbDir.UdbDirValue.SubClass, AnUdbDir.UdbDirValue.SubClass.PointType)));
    if (AnUdbDir.UdbDirValue.SubClass.PointType = $03) then
      VlTripInfo.Strings.AddPair('Compressed LatLon', AnUdbDir.ComprLatLon,
                                TGridSelItem.Create(AnUdbDir,
                                                    SizeOf(AnUdbDir.UdbDirValue.SubClass.ComprLatLon),
                                                    OffsetInRecord(AnUdbDir.UdbDirValue.SubClass, AnUdbDir.UdbDirValue.SubClass.ComprLatLon)))
    else
    begin
      VlTripInfo.Strings.AddPair('Direction', AnUdbDir.Direction,
                                TGridSelItem.Create(AnUdbDir,
                                                    SizeOf(AnUdbDir.UdbDirValue.SubClass.Direction),
                                                    OffsetInRecord(AnUdbDir.UdbDirValue.SubClass, AnUdbDir.UdbDirValue.SubClass.Direction)));

      VlTripInfo.Strings.AddPair('Subclass Unknown1', Format('%s %s %s',
                                                         [IntToHex(Swap(AnUdbDir.UdbDirValue.SubClass.Time), 4),
                                                          IntToHex(Swap(AnUdbDir.UdbDirValue.SubClass.Unknown2[0]), 4),
                                                          IntToHex(Swap(AnUdbDir.UdbDirValue.SubClass.Unknown2[1]), 4)]
                                                        ),
                                TGridSelItem.Create(AnUdbDir,
                                                    SizeOf(AnUdbDir.UdbDirValue.SubClass.Unknown1),
                                                    OffsetInRecord(AnUdbDir.UdbDirValue.SubClass, AnUdbDir.UdbDirValue.SubClass.Unknown1)));
    end;
    VlTripInfo.Strings.AddPair('Lat, Lon', Format('%s', [AnUdbDir.MapCoords]),
                              TGridSelItem.Create(AnUdbDir,
                                                  SizeOf(AnUdbDir.UdbDirValue.Lat) + SizeOf(AnUdbDir.UdbDirValue.Lon),
                                                  OffsetInRecord(AnUdbDir.UdbDirValue, AnUdbDir.UdbDirValue.Lat)));

    VlTripInfo.Strings.AddPair('UdbDir Unknown1', Format('%s',
                                                         [IntToHex(Swap32(AnUdbDir.UdbDirValue.Unknown1), 8)]
                                                        ),
                              TGridSelItem.Create(AnUdbDir,
                                                  SizeOf(AnUdbDir.UdbDirValue.Unknown1),
                                                  OffsetInRecord(AnUdbDir.UdbDirValue, AnUdbDir.UdbDirValue.Unknown1)));

    VlTripInfo.Strings.AddPair('Time', Format('%d sec.', [AnUdbDir.UdbDirValue.Time]),
                              TGridSelItem.Create(AnUdbDir,
                                                  SizeOf(AnUdbDir.UdbDirValue.Time),
                                                  OffsetInRecord(AnUdbDir.UdbDirValue, AnUdbDir.UdbDirValue.Time)));

    VlTripInfo.Strings.AddPair('UdbDir Unknown2', Format('%d bytes', [Length(AnUdbDir.Unknown2)]),
                              TGridSelItem.Create(AnUdbDir,
                                                  Length(AnUdbDir.Unknown2),
                                                  SizeOf(AnUdbDir.UdbDirValue)));

    VlTripInfo.Strings.AddPair('Address', AnUdbDir.DisplayName,
                              TGridSelItem.Create(AnUdbDir,
                                                  AnUdbDir.DisplayLength, SizeOf(AnUdbDir.UdbDirValue) + Length(AnUdbDir.Unknown2)));

    VlTripInfo.Strings.AddPair('*** End UdbDir', DupeString('-', DupeCount),
                              TGridSelItem.Create(AnUdbDir, 1, SizeOf(AnUdbDir.UdbDirValue) + Length(AnUdbDir.Unknown2) +
                                                               AnUdbDir.NameLength -1));
    if (ZoomToPoint) then
      MapRequest(AnUdbDir.MapCoords,
                 Format('%s<br>%s', [AnUdbDir.DisplayName, AnUdbDir.Direction]), RoutePointTimeOut);
  end;


  procedure AddUdbHandle(AnUdbhandle: TmUdbDataHndl);
  var
    ANitem: TBaseItem;
    OffSetPref, LUnknown2: integer;
  begin
    OffSetPref := - SizeOf(AnUdbhandle.PrefValue);
    VlTripInfo.Strings.AddPair('*** UdbPrefix', DupeString('-', DupeCount),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.PrefValue),
                                                   OffSetPref));

    VlTripInfo.Strings.AddPair('Unknown', Format('0x%s', [IntToHex(AnUdbhandle.PrefValue.Unknown1)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.PrefValue.Unknown1),
                                                   OffSetPref));

    VlTripInfo.Strings.AddPair('PrefixSize', Format('%d', [AnUdbhandle.PrefValue.PrefixSize]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.PrefValue.PrefixSize),
                                                   OffSetPref + OffsetInRecord(AnUdbhandle.PrefValue, AnUdbhandle.PrefValue.PrefixSize) ));

    VlTripInfo.Strings.AddPair('DataType', Format('%d', [AnUdbhandle.PrefValue.DataType]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.PrefValue.DataType),
                                                   OffSetPref + OffsetInRecord(AnUdbhandle.PrefValue, AnUdbhandle.PrefValue.DataType) ));

    VlTripInfo.Strings.AddPair('HandleId', Format('%d', [AnUdbhandle.PrefValue.PrefId]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.PrefValue.PrefId),
                                                   OffSetPref + OffsetInRecord(AnUdbhandle.PrefValue, AnUdbhandle.PrefValue.PrefId) ));

    VlTripInfo.Strings.AddPair('*** UdbHandle', DupeString('-', DupeCount),
                               TGridSelItem.Create(AnUdbhandle));

    VlTripInfo.Strings.AddPair('Size', Format('%d', [AnUdbhandle.LenValue]),
                               TGridSelItem.Create(AnUdbhandle,
                                                    SizeOf(AnUdbhandle.LenValue),
                                                    AnUdbhandle.OffsetLenValue));

    VlTripInfo.Strings.AddPair('DataType', Format('%d', [AnUdbhandle.DataType]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.DataType),
                                                   AnUdbhandle.OffsetDataType));

    VlTripInfo.Strings.AddPair('UdbHandleSize', Format('%d', [AnUdbhandle.UdbHandleValue.UdbHandleSize]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.UdbHandleValue.UdbHandleSize),
                                                   AnUdbhandle.OffsetValue));

    VlTripInfo.Strings.AddPair('Calculation status', Format('0x%s (%s)',
                                                       [IntToHex(AnUdbhandle.UdbHandleValue.CalcStatus, 8), AnUdbhandle.ModelDescription]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.UdbHandleValue.CalcStatus),
                                                   AnUdbhandle.OffsetValue + OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.CalcStatus) ));

    LUnknown2 := Length(AnUdbhandle.UdbHandleValue.Unknown2);
    VlTripInfo.Strings.AddPair('Unknown2', Format('%d bytes', [LUnknown2]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   LUnknown2,
                                                   AnUdbhandle.OffsetValue + OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.Unknown2) ));

    LUnknown2 := LUnknown2 - SizeOf(AnUdbhandle.UdbHandleValue.Unknown2);
    VlTripInfo.Strings.AddPair('UdbDir count', Format('%d', [AnUdbhandle.UdbHandleValue.UDbDirCount]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.UdbHandleValue.UDbDirCount),
                                                   AnUdbhandle.OffsetValue + LUnknown2+ OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.UDbDirCount) ));

    VlTripInfo.Strings.AddPair('Unknown3', Format('%d bytes', [Length(AnUdbhandle.UdbHandleValue.Unknown3)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   Length(AnUdbhandle.UdbHandleValue.Unknown3),
                                                   AnUdbhandle.OffsetValue + LUnknown2 + OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.Unknown3) ));

    VlTripInfo.Strings.AddPair('Unknown3 dist', Format('%d (meters)', [AnUdbhandle.UdbHandleValue.GetUnknown3(AnUdbhandle.DistOffset)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(Cardinal),
                                                   AnUdbhandle.OffsetValue + LUnknown2 +
                                                     OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.Unknown3) +
                                                     AnUdbhandle.DistOffset));

    VlTripInfo.Strings.AddPair('Unknown3 Time', Format('%d (seconds)', [AnUdbhandle.UdbHandleValue.GetUnknown3(AnUdbhandle.TimeOffset)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(Cardinal),
                                                   AnUdbhandle.OffsetValue + LUnknown2 +
                                                     OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.Unknown3) +
                                                     AnUdbhandle.TimeOffset));

    if (AnUdbhandle.ShapeOffset <> 0) then
      VlTripInfo.Strings.AddPair('Unknown3 Shape bitmap', DupeString('-', DupeCount),
                                 TGridSelItem.Create(AnUdbhandle,
                                                     SizeOf(Byte),
                                                     AnUdbhandle.OffsetValue + LUnknown2 +
                                                       OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.Unknown3) +
                                                       IntPtr(AnUdbhandle.ShapeOffset)));
    for ANitem in AnUdbhandle.Items do
    begin
      if (ANitem is TUdbDir) then
        AddUdbDir(TUdbDir(ANitem), false);
    end;

    if (Length(AnUdbhandle.Trailer) > 0) then
      VlTripInfo.Strings.AddPair('Trailer', Format('%d bytes', [Length(AnUdbhandle.Trailer)]),
                                 TGridSelItem.Create(AnUdbhandle,
                                                     Length(AnUdbhandle.Trailer),
                                                     AnUdbhandle.SelEnd - AnUdbhandle.SelStart - Cardinal(Length(AnUdbhandle.Trailer))));

    VlTripInfo.Strings.AddPair('*** End UdbHandle', DupeString('-', DupeCount),
                               TGridSelItem.Create(AnUdbhandle, 1, AnUdbhandle.SelEnd - AnUdbhandle.SelStart -1));
  end;

  procedure AddAllRoutes(AmAllRoutes: TmAllRoutes);
  var
    ANitem: TBaseItem;
  begin
    VlTripInfo.Strings.AddPair('*** AllRoutes', DupeString('-', DupeCount),
                               TGridSelItem.Create(AmAllRoutes));

    VlTripInfo.Strings.AddPair('Size', Format('%d', [AmAllRoutes.LenValue]),
                               TGridSelItem.Create(AmAllRoutes,
                                                   SizeOf(AmAllRoutes.LenValue),
                                                   AmAllRoutes.OffsetLenValue ));

    VlTripInfo.Strings.AddPair('DataType', Format('%d', [AmAllRoutes.DataType]),
                               TGridSelItem.Create(AmAllRoutes,
                                                   SizeOf(AmAllRoutes.DataType),
                                                   AmAllRoutes.OffsetDataType ));

    VlTripInfo.Strings.AddPair('UdbHandleCount', Format('%d', [AmAllRoutes.AllRoutesValue.UdbHandleCount]),
                               TGridSelItem.Create(AmAllRoutes,
                                                   SizeOf(AmAllRoutes.AllRoutesValue.UdbHandleCount),
                                                   AmAllRoutes.OffsetValue ));

    for ANitem in AmAllRoutes.Items do
    begin
      if (ANitem is TmUdbDataHndl) then
        AddUdbHandle(TmUdbDataHndl(ANitem));
    end;

    VlTripInfo.Strings.AddPair('*** End AllRoutes', DupeString('-', DupeCount),
                               TGridSelItem.Create(AmAllRoutes,
                                                   1,
                                                   AmAllRoutes.SelEnd - AmAllRoutes.SelStart -1));
  end;

  procedure AddHeader(AHeader: Theader);
  var
    HeaderValue: THeaderValue;
  begin
    HeaderValue := AHeader.HeaderValue;
    with HeaderValue do
    begin
      VlTripInfo.Strings.AddPair('*** Trip header', DupeString('-', DupeCount),
                                 TGridSelItem.Create(AHeader));
      VlTripInfo.Strings.AddPair('ID', string(ID),
                                 TGridSelItem.Create(AHeader, SizeOf(ID)));
      VlTripInfo.Strings.AddPair('Size',          Format('%d', [SubLength]),
                                 TGridSelItem.Create(AHeader,
                                                     SizeOf(SubLength),
                                                     OffsetInRecord(HeaderValue, SubLength) ));
      VlTripInfo.Strings.AddPair('Datatype',      Format('%d', [HeaderLength]),
                                 TGridSelItem.Create(AHeader,
                                                     SizeOf(HeaderLength),
                                                     OffsetInRecord(HeaderValue, HeaderLength) ));
      VlTripInfo.Strings.AddPair('Item count',    Format('%d', [TotalItems]),
                                 TGridSelItem.Create(AHeader,
                                                     SizeOf(TotalItems),
                                                     OffsetInRecord(HeaderValue, TotalItems) ));
      VlTripInfo.Strings.AddPair('*** End Trip header', DupeString('-', DupeCount),
                                 TGridSelItem.Create(AHeader,
                                                     1,
                                                     AHeader.SelStart + SizeOf(HeaderValue) -1 ));
    end;
  end;

  procedure AddTrip(ATrip: TTripList);
  var
    ANitem: TBaseItem;
  begin
    AddHeader(ATrip.Header);

    for ANitem in ATrip.ItemList do
    begin
      if (ANitem is TmAllRoutes) then
      begin
        AddAllRoutes(TmAllRoutes(ANitem));
        continue;
      end;

      if (ANitem is TmUdbDataHndl) then
      begin
        AddUdbHandle(TmUdbDataHndl(ANitem));
        continue;
      end;

      if (ANitem is TUdbDir) then
      begin
        AddUdbDir(TUdbDir(ANitem), false);
        continue;
      end;

      if (ANitem is TmLocations) then
      begin
        AddLocations(TmLocations(ANitem));
        continue;
      end;

      if (ANitem is TLocation) then
      begin
        AddLocation(TLocation(ANitem), false);
        continue;
      end;

      if (ANitem is TBaseRoutePreferences) then
      begin
        AddRoutePreferences(TBaseRoutePreferences(ANitem));
        continue;
      end;

      if (ANitem is TBaseDataItem) then
      begin
        AddBaseData(TBaseDataItem(ANitem));
        continue;
      end;

    end;
  end;

  procedure AddGPXWayPoint(AGPXWayPoint: TGPXWayPoint; ZoomRequest: boolean);
  begin
    VlTripInfo.Strings.AddPair('Name', string(AGPXWayPoint.Name),
      TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.Category <> '') then
      VlTripInfo.Strings.AddPair('Category', string(AGPXWayPoint.Category),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.Symbol <> '') then
      VlTripInfo.Strings.AddPair('Symbol (Temp path)', string(Format('%s.png', [AGPXWayPoint.Symbol])),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));

    VlTripInfo.Strings.AddPair('Lat, Lon', Format('%s, %s', [AGPXWayPoint.Lat, AGPXWayPoint.Lon]),
      TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.Speed <> 0) then
      VlTripInfo.Strings.AddPair('Speed', Format('%d Km', [AGPXWayPoint.Speed]),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));

    if (AGPXWayPoint.Proximity <> 0) then
      VlTripInfo.Strings.AddPair('Proximity', Format('%d Mtr.', [AGPXWayPoint.Proximity]),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));

    if (AGPXWayPoint.Phone <> '') then
      VlTripInfo.Strings.AddPair('Phone', string(AGPXWayPoint.Phone),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.Email <> '') then
      VlTripInfo.Strings.AddPair('Email', string(AGPXWayPoint.Email),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.Comment <> '') then
      VlTripInfo.Strings.AddPair('Comment', ReplaceAll(string(AGPXWayPoint.Comment), [#10, #13], ['_','']),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.Country <> '') then
      VlTripInfo.Strings.AddPair('Country', string(AGPXWayPoint.Country),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.State <> '') then
      VlTripInfo.Strings.AddPair('State', string(AGPXWayPoint.State),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.PostalCode <> '') then
      VlTripInfo.Strings.AddPair('PostalCode', string(AGPXWayPoint.PostalCode),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.City <> '') then
      VlTripInfo.Strings.AddPair('City', string(AGPXWayPoint.City),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
    if (AGPXWayPoint.Street <> '') or
       (AGPXWayPoint.HouseNbr <> '') then
      VlTripInfo.Strings.AddPair('Street', string(Format('%s %s', [AGPXWayPoint.Street, AGPXWayPoint.HouseNbr])),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));

    if (ZoomRequest) then
      MapRequest(Format('%s, %s',[AGPXWayPoint.Lat, AGPXWayPoint.Lon]),
                 Format('%s', [AGPXWayPoint.Name]), RoutePointTimeOut);

  end;

  procedure AddPOIList(APOIList: TPOIList);
  var
    AGPXWayPoint: TGPXWayPoint;
  begin
    for AGPXWayPoint in APOIList do
    begin
      VlTripInfo.Strings.AddPair('*** Begin POI', DupeString('-', DupeCount),
        TGridSelItem.Create(AGPXWayPoint.SelLength, AGPXWayPoint.SelStart));
      AddGPXWayPoint(AGPXWayPoint, false);
    end;
  end;

  procedure AddStringList(AStringList: TStringList);
  var
    ALine: string;
  begin
    VlTripInfo.Strings.AddPair('*** Begin FIT', DupeString('-', DupeCount));
    for ALine in AStringList do
    begin
      VlTripInfo.Strings.Add(ALine)
    end;
  end;

begin
  VlTripInfo.Strings.BeginUpdate;
  ClearTripInfo;
  VlTripInfo.Tag := 1;
  try
// Trip Data
    if (TObject(Node.Data) is TTripList) then
      AddTrip(TTripList(Node.Data))

    else if (TObject(Node.Data) is TmAllRoutes) then
      AddAllRoutes(TmAllRoutes(Node.Data))

    else if (TObject(Node.Data) is TmUdbDataHndl) then
      AddUdbHandle(TmUdbDataHndl(Node.Data))

    else if (TObject(Node.Data) is TUdbDir) then
      AddUdbDir(TUdbDir(Node.Data), true)

    else if (TObject(Node.Data) is TmAllLinks) then
      AddAllLinks(Node, TmAllLinks(Node.Data))

    else if (TObject(Node.Data) is TLink) then
      AddLink(Node, TLink(Node.Data))

    else if (TObject(Node.Data) is TmLocations) then
      AddLocations(TmLocations(Node.Data))

    else if (TObject(Node.Data) is TLocation) then
      AddLocation(TLocation(Node.Data), true)

    else if (TObject(Node.Data) is TBaseRoutePreferences) then
      AddRoutePreferences(TBaseRoutePreferences(Node.Data))

    else if (TObject(Node.Data) is TmTrackToRouteInfoMap) then
      AddTrackToRouteInfoMap(TmTrackToRouteInfoMap(Node.Data))

    else if (TObject(Node.Data) is TBaseDataItem) then
      AddBaseData(TBaseDataItem(Node.Data))

    else if (TObject(Node.Data) is THeader) then
      AddHeader(THeader(Node.Data))
// GPI data
    else if (TObject(Node.Data) is TPOIList) then
      AddPOIList(TPOIList(Node.Data))
    else if (TObject(Node.Data) is TGPXWayPoint) then
      AddGPXWayPoint(TGPXWayPoint(Node.Data), true)
// Fit Info. Only shown as raw data
    else if (TObject(Node.Data) is TStringList) then
      AddStringList(TStringList(Node.Data));

// Set Editmode of VlTripInfo
    for Index := 0 to VlTripInfo.Strings.Count -1 do
    begin
      AnItem := TGridSelItem.BaseDataItem(VlTripInfo, Index);
      if (AnItem = nil) then
      begin
        VlTripInfo.ItemProps[Index].ReadOnly := true;
        continue;
      end;

      case AnItem.ItemEditMode of
        TItemEditMode.emNone:
          VlTripInfo.ItemProps[Index].ReadOnly := true;
        TItemEditMode.emEdit: // Default
          VlTripInfo.ItemProps[Index].EditStyle := TEditStyle.esSimple;
        TItemEditMode.emButton:
          VlTripInfo.ItemProps[Index].EditStyle := TEditStyle.esEllipsis;
        TItemEditMode.emPickList:
          begin
            VlTripInfo.ItemProps[Index].ReadOnly := true;
            VlTripInfo.ItemProps[Index].EditStyle := TEditStyle.esPickList;
            VlTripInfo.ItemProps[Index].PickList.Text := AnItem.PickList;
          end;
      end;
    end;

  finally
    VlTripInfo.Strings.EndUpdate;
    VlTripInfo.Tag := 0;
  end;
  if (TObject(Node.Data) is TBaseItem) then
    SyncHexEdit(TBaseItem(Node.Data))
  else if (TObject(Node.Data) is TGPXWayPoint) then
    SyncHexEdit(TGPXWayPoint(Node.Data))
  else
    ClearSelHexEdit;
end;

procedure TFrmTripManager.TvTripCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if (Node.Data <> nil) and
     (TObject(Node.Data) is TUdbDir) then
  begin
    if (TUdbDir(Node.Data).UdbDirValue.SubClass.PointType = $3) or
       (TUdbDir(Node.Data).IsTurn)  then
      Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];
    case TUdbDir(Node.Data).Status of
      TUdbDirStatus.udsRoutePointNOK:
        Sender.Canvas.Brush.Color := clWebAqua;
      TUdbDirStatus.udsRoadNOK:
        Sender.Canvas.Brush.Color := clWebRed;
      TUdbDirStatus.UdsRoadOKCoordsNOK:
        Sender.Canvas.Brush.Color := clWebOrange;
      TUdbDirStatus.udsCoordsNOK:
        Sender.Canvas.Brush.Color := clWebYellow;
    end;
  end;
end;

procedure TFrmTripManager.ValueListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and
     (ssCtrl in Shift) then
    with TValueListEditor(Sender) do
      Clipboard.AsText := Cells[Col, Row];
end;

procedure TFrmTripManager.VlTripInfoBeforeDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect; State: TGridDrawState);
var
  AGridSelItem: TGridSelItem;
begin
  AGridSelItem := TGridSelItem.GridSelItem(VlTripInfo, ARow -1);
  if (AGridSelItem = nil) or
     not (AGridSelItem.BaseItem is TUdbDir) then
    exit;
  if (ACol = 0) then
  begin
    case TUdbDir(AGridSelItem.BaseItem).Status of
      TUdbDirStatus.udsRoutePointNOK:
        VlTripInfo.Canvas.Brush.Color := clWebAqua;
      TUdbDirStatus.udsRoadNOK:
        VlTripInfo.Canvas.Brush.Color := clWebRed;
      TUdbDirStatus.UdsRoadOKCoordsNOK:
        VlTripInfo.Canvas.Brush.Color := clWebOrange;
      TUdbDirStatus.udsCoordsNOK:
        VlTripInfo.Canvas.Brush.Color := clWebYellow;
    end;
  end;
end;

procedure TFrmTripManager.VlTripInfoEditButtonClick(Sender: TObject);
var
  ABaseDataItem: TBaseDataItem;
  ADateTime: TDateTime;
  Rc: integer;
begin
  ABaseDataItem := TGridSelItem.BaseDataItem(VlTripInfo, VlTripInfo.Row -1);
  if not Assigned(ABaseDataItem) then
    exit;

  if (ABaseDataItem is TmRoutePreferences) or
     (ABaseDataItem is TmRoutePreferencesAdventurousMode) then
  begin
    FrmEditRoutePref.CurTripList := ATripList;
    if (FrmEditRoutePref.ShowModal = IDOK) and
        (FrmEditRoutePref.VlModified) then
    begin
      BtnSaveTripValues.Enabled := true;
      TvTripChange(TvTrip, TvTrip.Selected);
    end;
  end
  else if (ABaseDataItem is TmScPosn) then
    ShowMessage('Position Map and click on ''Apply Coordinates''.' + #10 +
                'Tip: Use Ctrl + Click on Map to get precise coordinates')
  else if (ABaseDataItem is TUnixDate) then
  begin
    ADateTime := TUnixDate.CardinalAsDateTime(TUnixDate(ABaseDataItem).AsUnixDateTime);
    with TFrmDateDialog.Create(nil) do
    begin
      DtPicker.DateTime := ADateTime;
      Rc := ShowModal;
      ADateTime := DtPicker.DateTime;
      Free;
    end;
    if Rc = ID_OK then
    begin
      TUnixDate(ABaseDataItem).AsUnixDateTime := TUnixDate.DateTimeAsCardinal(ADateTime);
      BtnSaveTripValues.Enabled := true;
      TvTripChange(TvTrip, TvTrip.Selected);
    end;
  end;
end;

procedure TFrmTripManager.HexEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) then
  begin
    case Chr(Key) of
      'C': begin
             if (ssShift in Shift) then
               Clipboard.AsText := String(HexEdit.SelectionAsText)
             else
               Clipboard.AsText := String(HexEdit.SelectionAsHex);
           end;
      'Z': HexEdit.Undo;
      'Y': HexEdit.Redo;
    end;
  end;
end;

procedure TFrmTripManager.HexEditKeyPress(Sender: TObject; var Key: Char);
begin
  BtnSaveTripGpiFile.Enabled := true;
end;

procedure TFrmTripManager.VlTripInfoSelectionMoved(Sender: TObject);
var
  AGridSel: TGridSelItem;
  AVle: TValueListEditor;
begin
  AVle := TValueListEditor(Sender);
  AGridSel := TGridSelItem.GridSelItem(AVle, AVle.Row -1);
  if not Assigned(AGridSel) then
    exit;

  SyncHexEdit(AGridSel);

  if (AGridSel.BaseItem is TmTrackToRouteInfoMap) and
     (Sametext(AVle.Cells[0, AVle.Row], 'trkpt')) then
    MapRequest(AVle.Cells[1, AVle.Row], Format('%s %s', [AVle.Cells[0, AVle.Row], AVle.Cells[1, AVle.Row]]),
               RoutePointTimeOut);
end;

procedure TFrmTripManager.VlTripInfoStringsChange(Sender: TObject);
var
  ANItem: TBaseDataItem;
  StringRow: integer;
begin
  if VlTripInfo.Tag <> 0 then
    exit;

  StringRow := VlTripInfo.Row -1;
  ANItem := TGridSelItem.BaseDataItem(VlTripInfo, StringRow);
  if (Assigned(ANItem)) and
     (ANItem.AsString <> VlTripInfo.Strings.ValueFromIndex[StringRow]) then
  begin
    ANItem.AsString := VlTripInfo.Strings.ValueFromIndex[StringRow];
    BtnSaveTripValues.Enabled := true;
  end;
end;

function TFrmTripManager.CopyFileToTmp(const AListItem: TListItem): string;
var
  ABASE_Data_File: TBASE_Data;
  NFile: string;
begin
  result := '';
  CheckDevice;

  // Get Id of File
  ABASE_Data_File := TBASE_Data(TBASE_Data(AListItem.Data));
  if (ABASE_Data_File.IsFolder) then
    exit;

  // Get Name of file
  NFile := AListItem.Caption;

  if not GetFileFromDevice(CurrentDevice.PortableDev, ABASE_Data_File.ObjectId, CreatedTempPath, NFile) then
    raise Exception.Create(Format('Copy %s from %s failed', [NFile, CurrentDevice.Device]));

  result := IncludeTrailingPathDelimiter(CreatedTempPath) + NFile;
end;

procedure TFrmTripManager.CopyValueFromTripClick(Sender: TObject);
var
  ABaseDataItem: TBaseDataItem;
  TmpDataItem, CopyDataItem: TBaseItem;
  TmpTripList, CopyTripList: TTripList;
begin
  ABaseDataItem := TGridSelItem.BaseDataItem(VlTripInfo, VlTripInfo.Row -1);
  if not Assigned(ABaseDataItem) then
    exit;

  OpenTrip.DefaultExt := 'trip';
  OpenTrip.Filter := '*.trip|*.trip';
  OpenTrip.InitialDir := ShellTreeView1.Path;
  if not (OpenTrip.Execute) then
    exit;

  TmpTripList := TTripList.Create;
  CopyTripList := TTripList.Create;
  try
    TmpTripList.LoadFromFile(OpenTrip.FileName);
    CopyTripList.LoadFromFile(HexEditFile);
    TmpDataItem := TmpTripList.GetItem(ABaseDataItem.Name);
    CopyDataItem := CopyTripList.GetItem(ABaseDataItem.Name);
    if (TmpDataItem <> nil) and
       (CopyDataItem <> nil) then
    begin
      TmpTripList.SetItem(ABaseDataItem.Name, CopyDataItem);
      CopyTripList.SetItem(ABaseDataItem.Name, TmpDataItem);
      CopyTripList.SaveToFile(ChangeFileExt(HexEditFile, '') + '_' + string(ABaseDataItem.Name) + ExtractFileExt(HexEditFile));
    end;
  finally
    TmpTripList.Free;
    CopyTripList.Free;
    ShellListView1.Refresh;
  end;
end;

procedure TFrmTripManager.DeviceMenuPopup(Sender: TObject);
var
  AMenuItem: TMenuItem;
  ExploreEnabled: boolean;
begin
  ExploreEnabled := GetRegistry(Reg_EnableExploreFuncs, false);
  for AMenuItem in TPopupMenu(Sender).Items do
  begin
    AMenuItem.Enabled := ((AMenuItem.GroupIndex = 1) and (AMenuItem.Enabled)) or
                         ((AMenuItem.GroupIndex = 2) and DeviceFile and (BgDevice.ItemIndex = 0)) or
                         ((AMenuItem.GroupIndex = 3) and
                          (ExploreEnabled) and
                          (BgDevice.ItemIndex = 0) and
                          (FileExists(GetDeviceTmp + ExploreDb)));
  end;
end;

procedure TFrmTripManager.DeleteObjects(const AllowRecurse: boolean);
const
  ObjectName: array[boolean] of string = ('Files', 'Folders + Sub folders');
var
  ANitem: TlistItem;
  ABase_Data: TBASE_Data;
  SelCount: integer;
  UnSafeExt: boolean;
  UnlockFiles: boolean;
  CrWait, CrNormal: HCURSOR;
begin
  UnSafeExt := false;
  UnlockFiles := false;

  // Count Selected Files, or Directories
  SelCount := 0;
  for ANitem in LstFiles.Items do
  begin
    if not (ANitem.Selected) then
      continue;
    // Check file, or dir
    ABase_Data := TBASE_Data(ANitem.Data);
    if (ABase_Data.IsFolder <> AllowRecurse) then
      continue;

    // Extension check only for file
    if (AllowRecurse = false) then
    begin
      UnSafeExt := not ( (ContainsText(ANitem.SubItems[2], GpxExtension)) or
                         (ContainsText(ANitem.SubItems[2], TripExtension)) or
                         (ContainsText(ANitem.SubItems[2], GPIExtension)) or
                         (ContainsText(ANitem.SubItems[2], FITExtension))
                       );
      UnlockFiles := UnlockFiles or
         (GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, ChangeFileExt(ANitem.Caption, UnlExtension) ) <> '');
    end;
    Inc(SelCount);
  end;

  if (SelCount = 0) then
  begin
    MessageDlg(Format('No %s are selected to delete from %s.', [ObjectName[AllowRecurse],
                                                                CurrentDevice.DisplayedDevice]),
                 TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
    exit;
  end;

  // Extension check only for file
  if (AllowRecurse = false) then
  begin
    if UnlockFiles and (MessageDlg('Selected files have unlock files and are unsafe to delete. Continue?',
                   TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> ID_OK) then
      exit;

    if UnSafeExt and (MessageDlg('Selected files have extensions that are unsafe to delete. Continue?',
                   TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> ID_OK) then
      exit;
  end;

  // Prompt for verification
  if (MessageDlg(Format('%d %s will be deleted from %s.', [SelCount,
                                                           ObjectName[AllowRecurse],
                                                           CurrentDevice.DisplayedDevice]),
                 TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> ID_OK) then
    exit;

  if (AllowRecurse) then
  begin
    if (MessageDlg('This will allow you to delete files that have unsafe extensions to delete. Continue?',
                   TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> ID_OK) then
      exit;
  end;

  // Do the work
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    for ANitem in LstFiles.Items do
    begin
      if not (ANitem.Selected) then
        continue;
      ABase_Data := TBASE_Data(ANitem.Data);
      if (ABase_Data.IsFolder <> AllowRecurse) then
        continue;

      if not DelFromDevice(CurrentDevice.PortableDev, ABase_Data.ObjectId, AllowRecurse) then
        raise Exception.Create(Format('Could not remove %s: %s on %s', [ObjectName[AllowRecurse],
                                                                        ANitem.Caption,
                                                                        CurrentDevice.DisplayedDevice]));
    end;

    ReloadFileList;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.DeleteFilesClick(Sender: TObject);
begin
  DeleteObjects(false);
end;

procedure TFrmTripManager.DbgDeviceDbColEnter(Sender: TObject);
begin
  CdsDeviceDbAfterScroll(CdsDeviceDb);
end;

procedure TFrmTripManager.DeleteDirsClick(Sender: TObject);
begin
  DeleteObjects(true);
end;

procedure TFrmTripManager.NewDirectoryClick(Sender: TObject);
var
  NewName: string;
begin
  CheckDevice;
  if not (InputQuery('Create folder', 'Type a name', NewName)) then
    exit;

  if not CreatePath(CurrentDevice.PortableDev, FSavedFolderId, NewName) then
    raise Exception.Create('Folder could not be created!');

  ReloadFileList;
end;

procedure TFrmTripManager.RenameFile(Sender: TObject);
var
  OldName, NewName: string;
  CrWait, CrNormal: HCURSOR;
begin
  if (LstFiles.Selected = nil) then
    exit;

  OldName := LstFiles.Selected.Caption;
  NewName := OldName;
  if (ContainsText(LstFiles.Selected.SubItems[2], TripExtension)) and
     (Assigned(ATripList)) then
    NewName := ATripList.TripName + TripExtension;

  if not (InputQuery('Rename file.', Format('Type a new name for %s', [OldName]), NewName)) then
    exit;

  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    if (GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, NewName) <> '') then
      raise exception.Create(Format('File %s exists!', [NewName]));

    if not RenameObject(CurrentDevice.PortableDev, TBASE_Data(LstFiles.Selected.Data).ObjectId, NewName) then
      raise exception.Create('Rename failed on device');

    ReloadFileList;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.Renameselectedtripfilestotripname1Click(Sender: TObject);
var
  TripName: string;
  TripFileName: string;
  AnItem: TListItem;
  ABase_Data: TBASE_Data;
  TmpTripList: TTripList;
  CrWait, CrNormal: HCURSOR;
begin
  if (LstFiles.Selected = nil) then
    exit;

  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    TmpTripList := TTripList.Create;
    try
      for AnItem in LstFiles.Items do
      begin
        if (AnItem.Selected = false) then
          continue;
        ABase_Data := TBASE_Data(AnItem.Data);
        if (ABase_Data.IsFolder) then
          continue;

        // Get current trip name
        TripFileName := IncludeTrailingPathDelimiter(CreatedTempPath) + AnItem.Caption;
        TmpTripList.LoadFromFile(TripFileName);
        TripName := TmpTripList.TripName;
        TripFilename := TripName + TripExtension;

        // Check already exists
        if (GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, TripFilename) <> '') then
          raise exception.Create(Format('File %s exists!', [TripFilename]));

        // Rename
        AnItem.Caption := TripFilename; // Change caption
        if not RenameObject(CurrentDevice.PortableDev, ABase_Data.ObjectId, TripFilename) then
          raise exception.Create('Rename failed on device');

        GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, TripFilename, AnItem); // Get modified data

        // reload trip, and change mFilename
        TripFilename := CopyFileToTmp(AnItem);  // First copy to tmp
        TmpTripList.LoadFromFile(TripFilename);
        TmFileName(TmpTripList.GetItem('mFileName')).AsString := Format('0:/.System/Trips/%s.trip', [TripName]);
        TmpTripList.SaveToFile(TripFilename);

        // Write back to dev
        CopyFileFromTmp(TripFilename, AnItem);
      end;
    finally
      TmpTripList.Free;
    end;
    ReloadFileList;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.MnuTripOverviewClick(Sender: TObject);
begin
  SaveTrip.Filter := '*.csv|*.csv';
  SaveTrip.InitialDir := ShellTreeView1.Path;
  SaveTrip.FileName := ChangeFileExt(ExtractFileName(HexEditFile), '.csv');
  if not SaveTrip.Execute then
    exit;

  ATripList.ExportTripInfo(SaveTrip.FileName);
end;

procedure TFrmTripManager.GroupTrips(Group: Boolean);
var
  ParentName: string;
  ParentId: Cardinal;
  mParentTripName: TmParentTripName;
  mParentTripId: TmParentTripId;
  TripFileName: string;
  AnItem: TListItem;
  ABase_Data: TBASE_Data;
  TmpTripList: TTripList;
  CrWait, CrNormal: HCURSOR;
begin
  if (LstFiles.Selected = nil) then
    exit;

  ParentId := 0;
  ParentName := '';
  if (Group) then
  begin
    ParentName := 'Group1';
    if not InputQuery('Group selected trips', 'Group name', ParentName) then
      exit;
    ParentId := TUnixDate.DateTimeAsCardinal(Now);
  end;

  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try

    TmpTripList := TTripList.Create;
    try
      for AnItem in LstFiles.Items do
      begin
        if (AnItem.Selected = false) then
          continue;
        ABase_Data := TBASE_Data(AnItem.Data);
        if (ABase_Data.IsFolder) then
          continue;

        // Get current trip name
        TripFileName := IncludeTrailingPathDelimiter(CreatedTempPath) + AnItem.Caption;

        // reload trip, and change mParentTripName
        TmpTripList.LoadFromFile(TripFilename);

        // Set mParentTripName
        mParentTripName := TmpTripList.GetItem('mParentTripName') as TmParentTripName;
        if not Assigned(mParentTripName) then
          continue;
        if (Group) then
          mParentTripName.AsString := ParentName
        else
          mParentTripName.AsString := TmpTripList.TripName;

        // Set mParentTripId
        mParentTripId := TmpTripList.GetItem('mParentTripId') as TmParentTripId;
        if not Assigned(mParentTripId) then
          continue;
        mParentTripId.AsCardinal := ParentId;

        // Save to tmp
        TmpTripList.SaveToFile(TripFilename);

        // Write to dev
        CopyFileFromTmp(TripFilename, AnItem);
      end;
    finally
      TmpTripList.Free;
    end;
    ReloadFileList;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.Groupselectedtrips1Click(Sender: TObject);
begin
  GroupTrips(true);
end;

procedure TFrmTripManager.Ungroupselectedtrips1Click(Sender: TObject);
begin
  GroupTrips(false);
end;

procedure TFrmTripManager.SetRouteParm(ARouteParm: TRouteParm; Value: byte);
var
  TripFileName: string;
  AnItem: TListItem;
  ARouteParmItem: TByteItem;
  AllLinks: TmAllLinks;
  ABase_Data: TBASE_Data;
  TmpTripList: TTripList;
  CrWait, CrNormal: HCURSOR;
begin
  if (LstFiles.Selected = nil) then
    exit;

  ShowWarnRecalc;
  if (WarnRecalc = mrNo) then
    exit;

  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try

    TmpTripList := TTripList.Create;
    try
      for AnItem in LstFiles.Items do
      begin
        if (AnItem.Selected = false) then
          continue;
        ABase_Data := TBASE_Data(AnItem.Data);
        if (ABase_Data.IsFolder) then
          continue;

        // Get current trip name
        TripFileName := IncludeTrailingPathDelimiter(CreatedTempPath) + AnItem.Caption;

        // reload trip, and change RouteParm
        TmpTripList.LoadFromFile(TripFilename);

        // AllLinks (nuvi2595)
        AllLinks := TmAllLinks(TmpTripList.GetItem('mAllLinks'));
        if (Assigned(AllLinks)) then
        begin
          case ARouteParm of
            TRouteParm.TransportMode:
              AllLinks.DefTransportMode := TTransportMode(Value);
            TRouteParm.RoutePref:
              AllLinks.DefRoutePref := TRoutePreference(Value);
          end;
        end
        else
        begin
          // Others
          ARouteParmItem := nil;
          case ARouteParm of
            TRouteParm.TransportMode:
              ARouteParmItem := TByteItem(TmpTripList.GetItem('mTransportationMode'));
            TRouteParm.RoutePref:
              ARouteParmItem := TByteItem(TmpTripList.GetItem('mRoutePreference'));
          end;
          if (Assigned(ARouteParmItem)) then
            ARouteParmItem.AsByte := Value;
        end;

        // Set to recalc and save
        TmpTripList.ForceRecalc;
        TmpTripList.SaveToFile(TripFilename);

        // Write to device
        CopyFileFromTmp(TripFilename, AnItem);
      end;
    finally
      TmpTripList.Free;
    end;
    ReloadFileList;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.TransportModeClick(Sender: TObject);
begin
  SetRouteParm(TRouteParm.TransportMode, TMenuItem(Sender).Tag);
end;

procedure TFrmTripManager.RoutePreferenceClick(Sender: TObject);
begin
  SetRouteParm(TRouteParm.RoutePref, TMenuItem(Sender).Tag);
end;

procedure TFrmTripManager.CopyFileFromTmp(const LocalFile: string; const AListItem: TListItem);
begin
  CheckDevice;
  if not Assigned(AListItem) then
    raise exception.Create('No item selected.');

  if not TransferExistingFileToDevice(CurrentDevice.PortableDev, LocalFile, FSavedFolderId, AListItem) then
    raise Exception.Create(Format('TransferExistingFileToDevice %s to %s failed', [LocalFile, CurrentDevice.Device]));

  CheckTrip(AListItem, LocalFile);
end;

procedure TFrmTripManager.ListFiles(const ListFilesDir: TListFilesDir = TListFilesDir.lfCurrent);
var
  ABASE_Data: TBASE_Data;
  SParent: Widestring;
  CrWait, CrNormal: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  if (LstFiles.Tag > 0) then
    exit;
  LstFiles.Tag := 1;
  try
    case (ListFilesDir) of
      TListFilesDir.lfUp:
        SParent := FSavedParent;
      TListFilesDir.lfDown:
        begin
          if (LstFiles.ItemIndex >= 0) then
          begin
            ABASE_Data := TBASE_Data(LstFiles.Items.Item[LstFiles.ItemIndex].Data);
            SParent := ABASE_Data.ObjectId;
          end;
        end;
      else
        SParent := FSavedFolderId;
    end;
    FSavedFolderId := SParent;

    VlTripInfo.Strings.BeginUpdate;
    try
      ClearTripInfo;
    finally
      VlTripInfo.Strings.EndUpdate;
    end;
    case BgDevice.ItemIndex of
      0: DeleteTempFiles(CreatedTempPath, TripMask);
      1: DeleteTempFiles(CreatedTempPath, GpxMask);
      2: DeleteTempFiles(CreatedTempPath, GPIMask);
    end;

    // LstFile.Items should contain at least a Caption (Filename) and 4 subitems Date, Time, Ext and Size.
    // ReadFilesFromDevice will populate the data.
    // It returns the Parent ObjectId, we save it to be able to navigate to the parent directory.
    // Defined in the Listview on the form.
    FSavedParent := ReadFilesFromDevice(CurrentDevice.PortableDev, LstFiles.Items, SParent, FCurrentPath);

    // Save Device and folder info
    DeviceFolder[BgDevice.ItemIndex] := GetDevicePath(FCurrentPath);
    SetDeviceDisplayPath;

    // Trips need to be checked, and tripname filled
    case BgDevice.ItemIndex of
      0:  CheckTrips;
    // Future use
    end;

    // Now sort
    DoListViewSort(LstFiles, FSortSpecification.Column, FSortSpecification.Ascending, FSortSpecification);

  finally
    LstFiles.Tag := 0;
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.ReloadFileList;
begin
  ListFiles;
end;

function TFrmTripManager.GetItemType(const AListview: TListView): TDirType;
begin
  result := TDirType.NoDir;   // No directory

  // maybe file is double clicked
  if (AListview.ItemIndex >= 0) and
    (TBASE_Data(AListview.Items.Item[AListview.ItemIndex].Data).IsFolder = false) then
    exit;

  if ((AListview.ItemIndex > -1) and
      (AListview.Items.Item[AListview.ItemIndex].Caption = UpDirString)) then
    result := TDirType.Up     // Need to go up, '..' was chosen
  else
    result := TDirType.Down;  // Need to go down, a directory was chosen.
end;

procedure TFrmTripManager.LstFilesColumnClick(Sender: TObject; Column: TListColumn);
begin
  ListViewColumnClick(LstFiles, Column, FSortSpecification);
end;

procedure TFrmTripManager.LstFilesCompare(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  ListViewCompare(Item1, Item2, FSortSpecification, Data, Compare);
end;

procedure TFrmTripManager.LstFilesDblClick(Sender: TObject);
begin
  case GetItemType(LstFiles) of
    TDirType.Up:
      ListFiles(TListFilesDir.lfUp);
    TDirType.Down:
      ListFiles(TListFilesDir.lfDown);
    TDirType.NoDir:;  // no action
  end;
end;

procedure TFrmTripManager.LstFilesDeletion(Sender: TObject; Item: TListItem);
begin
  if Assigned(Item.Data) then
    FreeAndNil(TMTP_Data(Item.Data));
end;

procedure TFrmTripManager.LstFilesItemChecked(Sender: TObject; Item: TListItem);
begin
  if (TListView(Sender).Tag <> 0) then // Only want to set the Checkmark, Dont execute
    exit;
  if (Item.Data = nil) then
    exit;

  if TBASE_Data(Item.Data).IsFolder then
    exit;

  SetImported(Item, not Item.Checked);

  LoadTripFile(IncludeTrailingPathDelimiter(CreatedTempPath) + Item.Caption, true);
end;

procedure TFrmTripManager.LstFilesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and
     (Key = Ord('A')) then
    LstFiles.SelectAll;
end;

procedure TFrmTripManager.LstFilesSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
  TripGpiTimer.Enabled := false;
  TripGpiTimer.Enabled := true;
end;

procedure TFrmTripManager.MapRequest(const Coords, Desc, TimeOut: string;
                                     const ZoomLevel: string = '');
begin
  FMapReq.Coords := Coords;
  FMapReq.Desc := Desc;
  FMapReq.Zoom := ZoomLevel;
  if (FMapReq.Zoom = '') and
     (ChkZoomToPoint.Checked) then
    FMapReq.Zoom := 'true';
  FMapReq.TimeOut := TimeOut;
  MapTimer.Enabled := false;
  MapTimer.Enabled := true;
end;

procedure TFrmTripManager.MapTimerTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  EdgeBrowser1.ExecuteScript(Format('PopupAtPoint("%s", %s, "%s", %s);', [FMapReq.Desc, FMapReq.Coords, FMapReq.Zoom, FMapReq.TimeOut]));
end;

procedure TFrmTripManager.MemoSQLKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F5) then
    BitBtnSQLGoClick(BitBtnSQLGo);
end;

procedure TFrmTripManager.LoadHex(const FileName: string);
begin
  HexEdit.LoadFromFile(FileName);
  BtnSaveTripGpiFile.Enabled := true;
end;

procedure TFrmTripManager.LoadTripFile(const FileName: string; const FromDevice: boolean);
var
  CrWait, CrNormal: HCURSOR;
  ANItem: TBaseItem;
  CurrentNode: TTreeNode;
  RootNode: TTreeNode;
  TripFileName: string;
  TripName: string;
  ParentTripName: string;

  procedure AddLinks(AParentNode: TTreeNode; ALinkList: TmAllLinks);
  var
    ANItem: TBaseItem;
    LinkCnt: integer;
    LinkName: string;
    RoutePoints: TList<TLocation>;
    mLocations: TmLocations;
  begin
    RoutePoints := Tlist<TLocation>.Create;
    mLocations := TmLocations(ALinkList.TripList.GetItem('mLocations'));
    if (Assigned(mLocations)) then
      mLocations.GetRoutePoints(RoutePoints);
    try
      LinkCnt := 0;
      for ANItem in ALinkList.Links do
      begin
        if ANItem is Tlink then
        begin
          LinkName := Format('Link: %d', [LinkCnt]);
          if (LinkCnt < RoutePoints.Count) then
            LinkName := RoutePoints[LinkCnt].LocationTmName.AsString;
          TvTrip.Items.AddChildObject(AParentNode, LinkName, ANItem);
        end;
        Inc(LinkCnt);
      end;
      AParentNode.Expand(false);
    finally
      RoutePoints.Free;
    end;
  end;

  procedure AddLocations(AParentNode: TTreeNode; ALocationList: TmLocations);
  var
    ANItem: TBaseItem;
    CurrentLocation: TTreeNode;
    FirstLocation: boolean;
  begin
    CurrentLocation := nil;
    FirstLocation := true;
    for ANItem in ALocationList.Locations do
    begin
      if ANItem is TLocation then
      begin
        CurrentLocation := TvTrip.Items.AddChildObject(AParentNode, string(TLocation(ANItem).LocationValue.id), ANItem);
        continue;
      end;
      if (ANItem is TBaseDataItem) and
         (Assigned(CurrentLocation))then
      begin
        if (FirstLocation) and
           (ANItem is TmArrival) then
        begin
          FirstLocation := false;
          if (TmArrival(ANItem).AsUnixDateTime <> 0) then
            PnlTripGpiInfo.Caption := PnlTripGpiInfo.Caption + ', Departure: ' + TmArrival(ANItem).AsString;
        end;
        TvTrip.Items.AddChildObject(CurrentLocation, TBaseDataItem(ANItem).DisplayName, ANItem);
        if (ANItem is TmName) then
          CurrentLocation.Text := CurrentLocation.Text + ' (' + TmName(ANItem).AsString + ')';
      end;
    end;
    AParentNode.Expand(false);
  end;

  procedure AddRoutes(AParentNode: TTreeNode; ARouteList: TmAllRoutes);
  var
    AnUdbHandle: TmUdbDataHndl;
    AnUdbDir: TUdbDir;
    CurrentUdbNode: TTreeNode;
  begin
    for AnUdbHandle in ARouteList.Items do
    begin
      CurrentUdbNode := TvTrip.Items.AddChildObject(AParentNode, AnUdbHandle.DisplayName, AnUdbHandle);
      for AnUdbDir in AnUdbHandle.Items do
        TvTrip.Items.AddChildObject(CurrentUdbNode, AnUdbDir.DisplayName, AnUdbDir);
    end;
    AParentNode.Expand(false);
  end;

begin
  // Prevent AV's in Compare when a new trip file is loaded.
  if (FrmShowLog.Showing) then
  begin
    if (MessageDlg('Loading a new trip file will close the Compare. Continue?',
                   TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) = mrCancel) then
      exit;
    FrmShowLog.Close;
  end;

  CrWait := LoadCursor(0, IDC_WAIT);
  CRNormal := SetCursor(CrWait);

  TsSQlite.TabVisible := false;
  TsTripGpiInfo.Caption := 'Trip info';

  ATripList.Clear;
  if (Assigned(APOIList)) then
    APOIList.Clear;
  if (Assigned(AFitInfo)) then
    AFitInfo.Clear;

  TvTrip.Items.BeginUpdate;
  TvTrip.Items.Clear;

  VlTripInfo.Strings.BeginUpdate;
  ClearTripInfo;

  try
    if not ATripList.LoadFromFile(FileName) then
      raise Exception.Create('Not a valid trip file');

    DeviceFile := FromDevice;
    HexEditFile := FileName;

    if (DeviceFile) and
       (ATripList.IsCalculated = false) then
    begin
      SbPostProcess.Panels[0].Text := 'Not a calculated trip. Marked with !';
      SbPostProcess.Panels[1].Text := 'BaseCamp may have problems reading current.gpx';
      StatusTimer.Enabled := false;
      StatusTimer.Enabled := true;
    end;

    LoadHex(FileName);
    LoadTripOnMap(ATripList, CurrentMapItem);

    CopyValueFromTrip.Enabled := not DeviceFile;
    if (DeviceFile) then
      PnlTripGpiInfo.Color := clLime
    else
      PnlTripGpiInfo.Color := clAqua;

    TripName := ATripList.TripName;
    ParentTripName := ATripList.GetValue('mParentTripName');

    TripFileName := ExtractFileName(FileName);
    if SameText(ChangeFileExt(TripFileName, ''), TripName) then
      TripFileName := ''
    else
      TripFileName := Format('%s, ', [TripFileName]);
    if (ParentTripName = TripName) then
      ParentTripName := ''
    else
      ParentTripName := Format(', (%s)', [ParentTripName]);
    PnlTripGpiInfo.Caption := Format('%sTrip: %s%s', [TripFileName, TripName, ParentTripName]);

    RootNode := TvTrip.Items.AddObject(nil, ExtractFileName(FileName), ATripList);
    TvTrip.Items.AddChildObject(RootNode,
                                Format('%s (%s)', [ATripList.Header.ClassName, ATripList.ModelDescription]),
                                ATripList.Header);

    for ANItem in ATripList.ItemList do
    begin
      if (ANItem is TBaseDataItem) then
      begin
        with TBaseDataItem(ANItem) do
        begin
          CurrentNode := TvTrip.Items.AddChildObject(RootNode, DisplayName + '=' + AsString, ANItem);
          if (ANItem is TmAllLinks) then
            AddLinks(CurrentNode, TmAllLinks(AnItem));
          if (ANItem is TmLocations) then
            AddLocations(CurrentNode, TmLocations(AnItem));
          if (ANItem is TmAllRoutes) then
            AddRoutes(CurrentNode, TmAllRoutes(AnItem));
        end;
      end;
    end;

    RootNode.Selected := true;
    RootNode.Expand(false);
  finally
    VlTripInfo.Strings.EndUpdate;
    TvTrip.Items.EndUpdate;

    BtnSaveTripValues.Enabled := false;
    BtnSaveTripGpiFile.Enabled := false;
    MnuTripEdit.Enabled := true;

    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.LoadGpiFile(const FileName: string; const FromDevice: boolean);
var
  AStream: TBufferedFileStream;
  AGPXWayPoint: TGPXWayPoint;
  RootNode: TTreeNode;
  GPIRec: TGPI;
begin
  TsSQlite.TabVisible := false;
  if (Assigned(ATripList)) then
    ATripList.Clear;
  if (Assigned(AFitInfo)) then
    AFitInfo.Clear;

  TsTripGpiInfo.Caption := 'POI(gpi) info';
  AStream := TBufferedFileStream.Create(FileName, fmOpenRead);

  TvTrip.LockDrawing;
  TvTrip.items.BeginUpdate;
  TvTrip.Items.Clear;
  VlTripInfo.Strings.BeginUpdate;
  ClearTripInfo;
  DeviceFile := FromDevice;
  HexEditFile := FileName;
  MnuTripEdit.Enabled := false;

  try
    GPIRec.Read(AStream, APOIList, GetOSMTemp);

    RootNode := TvTrip.Items.AddObject(nil, ExtractFileName(FileName), APOIList);
    TvTrip.ShowRoot := true;

    if (DeviceFile) then
      PnlTripGpiInfo.Color := clLime
    else
      PnlTripGpiInfo.Color := clAqua;
    PnlTripGpiInfo.Caption := '';
    for AGPXWayPoint in APOIList do
    begin
      if (PnlTripGpiInfo.Caption = '') then
        PnlTripGpiInfo.Caption := string(AGPXWayPoint.Category);
      TvTrip.Items.AddChildObject(RootNode, string(AGPXWayPoint.Name), AGPXWayPoint);
    end;

    RootNode.Expand(false);
  finally
    TvTrip.Items.EndUpdate;
    TvTrip.UnlockDrawing;
    VlTripInfo.Strings.EndUpdate;
    AStream.Free;
  end;
  LoadHex(FileName);
  LoadGpiOnMap(APOIList, CurrentMapItem);
  RootNode.Selected := true;
  BtnSaveTripValues.Enabled := false;
  BtnSaveTripGpiFile.Enabled := false;
end;

procedure TFrmTripManager.LoadFitFile(const FileName: string; const FromDevice: boolean);
var
  RootNode: TTreeNode;
  ActGpxFile: string;
  FitInfo, FormattedGpx, OError: string;
  Rc: DWORD;
begin
  TsSQlite.TabVisible := false;
  if (Assigned(ATripList)) then
    ATripList.Clear;
  if (Assigned(APOIList)) then
    APOIList.Clear;

  TsTripGpiInfo.Caption := 'Course(fit) info';
  TvTrip.LockDrawing;
  TvTrip.items.BeginUpdate;
  TvTrip.Items.Clear;
  VlTripInfo.Strings.BeginUpdate;
  ClearTripInfo;
  DeviceFile := FromDevice;
  HexEditFile := FileName;
  MnuTripEdit.Enabled := false;

  try
    Sto_RedirectedExecute(Format('FitInfo.exe "%s"', [FileName]),
                          GetRoutesTmp, FitInfo, OError, Rc);
    if (Rc <> 0) then
      raise Exception.Create(FitInfo + #10 + OError);
    AFitInfo.Text := FitInfo;

    ActGpxFile := GetRoutesTmp + ChangeFileExt(ExtractFilename(FileName), GpxExtension);
    DeleteTempFiles(GetRoutesTmp, '*.*');
    Sto_RedirectedExecute(Format('Fit2Gpx.exe "%s"', [FileName]),
                          GetRoutesTmp, FormattedGpx, OError, Rc);
    if (Rc <> 0) then
      raise Exception.Create(FormattedGpx + #10 + OError);
    TFile.WriteAllText(ActGpxFile, FormattedGpx);

    RootNode := TvTrip.Items.AddObject(nil, ExtractFileName(FileName), AFitInfo);
    TvTrip.ShowRoot := true;

    if (DeviceFile) then
      PnlTripGpiInfo.Color := clLime
    else
      PnlTripGpiInfo.Color := clAqua;
    PnlTripGpiInfo.Caption := '';
    RootNode.Expand(false);
  finally
    TvTrip.Items.EndUpdate;
    TvTrip.UnlockDrawing;
    VlTripInfo.Strings.EndUpdate;
  end;
  LoadHex(FileName);
  LoadFitOnMap(ActGpxFile, CurrentMapItem);
  RootNode.Selected := true;
  BtnSaveTripValues.Enabled := false;
  BtnSaveTripGpiFile.Enabled := false;
end;

procedure TFrmTripManager.LoadSqlFile(const FileName: string; const FromDevice: boolean);
begin
  SqlFile := FileName;
  GetTables(SqlFile, CmbSQliteTabs.Items);
  CmbSQliteTabs.ItemIndex := Min(0, CmbSQliteTabs.Items.Count -1);
  CmbSQliteTabsChange(CmbSQliteTabs);
  TsSQlite.TabVisible := true;
  PctHexOsm.ActivePage := TsSQlite;
end;

procedure TFrmTripManager.SetCheckMark(const AListItem: TListItem; const NewValue: boolean);
begin
  // Set Check marks
  LstFiles.Tag := LstFiles.Tag + 1; // Prevent an action to be executed
  try
    AListItem.Checked := NewValue;
  finally
    LstFiles.Tag := LstFiles.Tag - 1;
  end;
end;

procedure TFrmTripManager.SetImported(const AListItem: TListItem; const NewValue: boolean);
var
  TmpTripList: TTripList;
  LocalFile: string;
  NewCheck: boolean;
  Imported: TBooleanItem;
begin
  NewCheck := NewValue;
  TmpTripList := TTripList.Create;
  try
    // Copy File to Local directory
    LocalFile := CopyFileToTmp(AListItem);
    if (LocalFile = '') then
      exit;

    // Check mImported by loading tmp file
    TmpTripList.LoadFromFile(LocalFile);
    Imported := TBooleanItem(TmpTripList.GetItem('mImported'));
    if (Imported <> nil) then
      Imported.AsBoolean := NewValue;
    TmpTripList.SaveToFile(LocalFile);

    CopyFileFromTmp(LocalFile, AListItem);
    NewCheck := not NewCheck;
  finally
    TmpTripList.Free;
    SetCheckMark(AListItem, NewCheck);
  end;
end;

procedure TFrmTripManager.ReadDefaultFolders;
var
  ModelIndex: integer;
  SubKey: string;
begin
  ModelIndex := GetRegistry(Reg_CurrentModel, 0);
  SubKey := IntToStr(ModelIndex);
  DeviceFolder[0] := GetRegistry(Reg_PrefDevTripsFolder_Key,
                                 TModelConv.GetKnownPath(ModelIndex, 0), SubKey);
  DeviceFolder[1] := GetRegistry(Reg_PrefDevGpxFolder_Key,
                                 TModelConv.GetKnownPath(ModelIndex, 1), SubKey);
  DeviceFolder[2] := GetRegistry(Reg_PrefDevPoiFolder_Key,
                                 TModelConv.GetKnownPath(ModelIndex, 2), SubKey);
end;

procedure TFrmTripManager.SetDeviceListColumns;
var
  ShowTrips: boolean;
begin
  LstFiles.Tag := 1;
  try
    ShowTrips := (BgDevice.ItemIndex = 0) and
                 (GetRegistry(Reg_EnableFitFuncs, false) = false);  // Not for fit files.

    LstFiles.Checkboxes := ShowTrips;

    if (ShowTrips) then
      LstFiles.Columns[TripNameCol].Width := TripNameColWidth
    else
    begin
      LstFiles.Columns[TripNameCol].Width := 0;
      LvExplore.Items.Clear;
      TsExplore.TabVisible := false;
    end;

  finally
    LstFiles.Tag := 0;
  end;
end;

procedure TFrmTripManager.ReadColumnSettings;
var
  ColWidths: string;
  AColWidth, Index: integer;
begin
  ColWidths := GetRegistry(Reg_WidthColumns_Key, Reg_WidthColumns_Val);
  Index := 0;
  while (ColWidths <> '') do
  begin
    AColWidth := StrToIntDef(NextField(ColWidths, ','), 50);
    ShellListView1.Columns[Index].Width := AColWidth;
    Inc(Index);
  end;

  ShellListView1.SortColumn := GetRegistry(Reg_SortColumn_Key, 0);
  if (GetRegistry(Reg_SortAscending_Key, True)) then
    ShellListView1.SortState := THeaderSortState.hssAscending
  else
    ShellListView1.SortState := THeaderSortState.hssDescending;
end;

procedure TFrmTripManager.WriteColumnSettings;
var
  ColWidths: string;
  Index: integer;
begin
  SetRegistry(Reg_SortColumn_Key, ShellListView1.SortColumn);
  SetRegistry(Reg_SortAscending_Key, (ShellListView1.SortState = hssAscending));
  ColWidths := '';
  for Index := 0 to ShellListView1.Columns.Count -1 do
  begin
    if (ColWidths <> '') then
      ColWidths := ColWidths + ',';
    ColWidths := ColWidths + IntToStr(ShellListView1.Columns[Index].Width);
  end;
  SetRegistry(Reg_WidthColumns_Key, ColWidths);
end;

procedure TFrmTripManager.OnSetPostProcessPrefs(Sender: TObject);
begin
  SetProcessOptions.SetPostProcessPrefs(Sender);

  with Sender as TProcessOptions do
  begin
    // Lookup Messages
    LookUpWindow := FrmTripManager.Handle;
    LookUpMessage := UFrmTripManager.WM_ADDRLOOKUP;
  end;
end;

procedure TFrmTripManager.OnSetSendToPrefs(Sender: TObject);
begin
  SetProcessOptions.SetSendToPrefs(Sender);

  with Sender as TProcessOptions do
  begin
    ExploreUUIDList := ExploreList;
  end;
end;

procedure TFrmTripManager.ReadSettings;
var
  ModelIndex: integer;
begin
  TSetProcessOptions.CheckSymbolsDir;

  TModelConv.SetupKnownDevices;
  ModelIndex := GetRegistry(Reg_CurrentModel, 0);
  if (Assigned(CurrentDevice)) then
    GuessModel(CurrentDevice.DisplayedDevice)
  else
    GuessModel(GetRegistry(Reg_PrefDev_Key, TModelConv.GetKnownDevice(ModelIndex), IntToStr(ModelIndex)));

  WarnRecalc := mrNone;
  RoutePointTimeOut := GetRegistry(Reg_RoutePointTimeOut_Key, Reg_RoutePointTimeOut_Val);
  GeoSearchTimeOut := GetRegistry(Reg_GeoSearchTimeOut_Key, Reg_GeoSearchTimeOut_Val);
  ReadGeoCodeSettings;
  BtnGeoSearch.Enabled := (GeoSettings.GeoCodeApiKey <> '');
  DeleteDirs.Enabled := GetRegistry(Reg_EnableDirFuncs, false);
  NewDirectory.Enabled := GetRegistry(Reg_EnableDirFuncs, false);

  if (GetRegistry(Reg_Maximized_Key, False)) then
    WindowState := TWindowState.wsMaximized
  else
    WindowState := TWindowState.wsNormal;
  ReadColumnSettings;

  EdgeBrowser1.UserDataFolder := CreatedTempPath;
  if not Assigned(ATripList) then
  begin
    DeleteTempFiles(GetOSMTemp, GetTracksMask);
    if (CreateOSMMapHtml(GetRegistry(Reg_SavedMapPosition_Key, Reg_DefaultCoordinates))) then
      EdgeBrowser1.Navigate(GetHtmlTmp);
  end;
end;

// Drag and Drop methods
procedure TFrmTripManager.CreateWnd;
begin
  inherited;
  DragAcceptFiles(Handle, True);
end;

procedure TFrmTripManager.DestroyWnd;
begin
  DragAcceptFiles(Handle, False);
  inherited;
end;

procedure TFrmTripManager.FileSysDrop(var Msg: TWMDROPFILES);
var
  NumFiles, FileNum: integer;
  FName: string;
  FNames: TStringList;
  Index: integer;
  HasGpx: boolean;
begin
  HasGpx := false;
  FNames := TStringList.Create;
  try
    NumFiles := DragQueryFile(Msg.Drop, UINT(-1), nil, 0);
    for FileNum := 0 to NumFiles -1 do
    begin
      // Get Filename
      SetLength(FName, DragQueryFile(Msg.Drop, FileNum, nil, 0));
      DragQueryFile(Msg.Drop, FileNum, PChar(FName), Length(FName) +1);

      // Dropped a directory? Just set the path
      if (DirectoryExists(FName)) then
      begin
        ShellTreeView1.Path := FName;
        HasGpx := false;
        break;
      end;

      // First file sets path
      if (FileNum = 0) then
        ShellTreeView1.Path := ExtractFileDir(FName)
      else if (ShellTreeView1.Path <> ExtractFileDir(FName)) then // all files should be in same dir!
        break;
      // Add to selection
      FNames.Add(FName);
      HasGpx := HasGpx or
        ContainsText(ExtractFileExt(FName), GpxExtension);
    end;

    ShellListView1.ClearSelection;
    for Index := 0 to ShellListView1.Items.Count -1 do
      ShellListView1.Items[Index].Selected := (FNames.IndexOf(ShellListView1.Folders[Index].PathName) > -1);

    Application.BringToFront;

  finally
    FNames.Free;
    DragFinish(Msg.Drop);
  end;
  if (HasGpx) then
    PostProcessClick(Self);
end;

procedure TFrmTripManager.WMDirChanged(var Msg: TMessage);
var
  AGpx: string;
begin
  Msg.Result := 0;

  // Show Dialog
  if (FrmPostProcess.Showing) then
    exit;

  // Bring to front by switching FormStyle
  Self.FormStyle := fsStayOnTop;
  Self.FormStyle := fsNormal;

  // PostProcess
  if FrmPostProcess.ShowModal <> ID_OK then
    exit;

  // Stop directory monitor.
  // If not we will get an event when postprocessing.
  System.TMonitor.Enter(ModifiedList);
  DirectoryMonitor.Active := false;
  try
    while (ModifiedList.Count > 0) do
    begin
      AGpx := ModifiedList[0];
      ModifiedList.Delete(0);
      SbPostProcess.Panels[0].Text := AGpx;
      ProcessMessages;
      TGPXFile.PerformFunctions([PostProcess], AGpx,
                                OnSetPostProcessPrefs, SetProcessOptions.SavePrefs);
    end;
  finally
    DirectoryMonitor.Active := ChkWatch.Checked;
    System.TMonitor.Exit(ModifiedList);
    SbPostProcess.Panels[0].Text  := '';
    SbPostProcess.Panels[1].Text  := '';
  end;
end;

procedure TFrmTripManager.WMAddrLookUp(var Msg: TMessage);
begin
  SbPostProcess.Panels[1].Text  := TPlace(Msg.LParam).FormattedAddress;
  ProcessMessages;
  Msg.Result := 0;
end;

procedure TFrmTripManager.DirectoryEvent(Sender: TObject; Action: TDirectoryMonitorAction; const FileName: WideString);
var
  Ext: string;

  procedure SelectModifiedFiles;
  var
    Index: integer;
  begin
    for Index := 0 to ShellListView1.Items.Count -1 do
    begin
      if (ShellListView1.Folders[Index].IsFolder) then
        continue;
      ShellListView1.Items[Index].Selected := ModifiedList.IndexOf(ShellListView1.Folders[Index].PathName) > -1;
    end;
  end;

begin
  // Only want GPX files
  Ext := ExtractFileExt(Filename);
  if not (ContainsText(Ext, GpxExtension)) then
    exit;

  // ModifiedList has duplicates set to dupIgnore to skip multiple events for same file
  System.TMonitor.Enter(ModifiedList);
  try
    ModifiedList.Add(IncludeTrailingPathDelimiter(DirectoryMonitor.Directory) + FileName);
  finally
    System.TMonitor.Exit(ModifiedList);
  end;

  // Is this a new file? Refresh
  if (ShellListView1.FindCaption(0, Filename, true, true, false) = nil) then
    ShellListView1.Refresh;

  // Select the files in the ShellListView
  SelectModifiedFiles;

  PostMessage(Self.Handle, WM_DIRCHANGED, 0, 0);
end;

// Wait until the DeviceName appears in the Devicelist
// EG. Edge in VirtualBox
function TFrmTripManager.WaitForDevice(const DeviceToWaitFor: string): integer;
var
  Retries: integer;
begin
  Retries := 5;
  result := -1;
  while (Retries > 0) do
  begin
    result := TMTP_Device.DeviceIdInList(DeviceToWaitFor, DeviceList); // List after insert
    if (result > -1) then
        break;

    // Device is not (yet) available in DeviceList. Retry a few times
    SbPostProcess.Panels[0].Text := DeviceToWaitFor;
    SbPostProcess.Panels[1].Text := 'Waiting for device to appear';
    SbPostProcess.Update;

    Dec(Retries);
    Sleep(500);
    GetDeviceList;  // Rescan devices. We dont have to keep the current device
  end;
end;

procedure TFrmTripManager.USBChangeEvent(const Inserted : boolean; const DeviceName, VendorId, ProductId: string);
var
  DevIndex : integer;
  SelectedDevice: string;
  ConnectPreferred, CanConnectNewDevice: boolean;
begin
  // Save currently selected device Id
  if Assigned(CurrentDevice) then
    SelectedDevice := CurrentDevice.Device
  else
    SelectedDevice := '';

  // Removed USB device is our connected device?
  if (Inserted = false) and
     (Assigned(CurrentDevice)) and
     (SameText(CurrentDevice.Device, DeviceName)) then
  begin
    DevIndex := TMTP_Device.DeviceIdInList(DeviceName, DeviceList);  // List before remove
    if (DevIndex > -1) then
      ConnectedDeviceChanged(TMTP_Device(DeviceList[DevIndex]).DisplayedDevice, 'Disconnected');
    GetDeviceList;
    exit;
  end;

  // Update the list of devices, keeping SelectedDevice if possible
  GetDeviceList(SelectedDevice);

  ConnectPreferred := (Inserted) and
                      TModelConv.PreferedPartition(SelectedDevice, DeviceName, DeviceList);
  CanConnectNewDevice := (Inserted) and
                      (SelectedDevice = '');

  // No Device was connected and now it is.
  // Or... A Zumo590 System partition was connected, and now a System1 is inserted. Prefer that.
  if (CanConnectNewDevice) or
     (ConnectPreferred) then
  begin
    DevIndex := WaitForDevice(DeviceName);

    // Inserted Device is in the DeviceList and a known device.
    // Note: Sd Cards are not known devices
    if (DevIndex > -1) and
       (TModelConv.IsKnownDevice(TMTP_Device(DeviceList[DevIndex]))) then
    begin
      ConnectedDeviceChanged(TMTP_Device(DeviceList[DevIndex]).DisplayedDevice, 'Connected');
      CmbDevices.ItemIndex := DevIndex;
      CmbDevicesChange(CmbDevices);
    end;
  end;

end;

procedure TFrmTripManager.ConnectedDeviceChanged(const Device, Status: string);
begin
  SbPostProcess.Panels[0].Text := Device;
  SbPostProcess.Panels[1].Text := Status;
  SbPostProcess.Update;

  TvTrip.Items.Clear;
  ClearTripInfo;
  ClearDeviceDbFiles;
  TsExplore.TabVisible := false;

  StatusTimer.Enabled := false;
  StatusTimer.Enabled := true;
end;

procedure TFrmTripManager.StatusTimerTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  SbPostProcess.Panels[0].Text := '';
  SbPostProcess.Panels[1].Text := '';
end;

initialization
  FormatSettings.ThousandSeparator := ',';
  FormatSettings.DecimalSeparator := '.';

end.
