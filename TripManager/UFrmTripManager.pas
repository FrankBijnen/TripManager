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

  Monitor, BCHexEditor, mtp_helper, TripManager_ShellTree, TripManager_ShellList, TripManager_ValEdit,
  UnitListViewSort, UnitMtpDevice, UnitTripObjects, UnitGpxDefs, UnitGpxObjects, UnitGpi, UnitUSBEvent;

const
  SelectMTPDevice         = 'Select an MTP device';
  UpDirString             = '..';

  GpxExtension            = 'gpx';
  GpxMask                 = '*.' + GpxExtension;

  TripExtension           = 'trip';
  TripMask                = '*.' + TripExtension;

  GPIExtension            = 'gpi';
  GPIMask                 = '*.' + GPIExtension;
  UnlExtension            = 'unl';

  HtmlExtension           = 'html';
  KmlExtension            = 'kml';

  CurrentTrip             = 'CurrentTrip';
  CurrentGPI              = 'CurrentGPI';
  FileSysTrip             = 'FileSys';
  CompareTrip             = 'Compare';

  WM_DIRCHANGED           = WM_USER + 1;
  WM_ADDRLOOKUP           = WM_USER + 2;

  TripNameCol             = 5;
  TripNameColWidth        = 250;

type
  TMapReq = record
    Coords: string;
    Desc: string;
    Zoom: string;
    TimeOut: string;
  end;

  TDirType = (NoDir, Up, Down);
  TListFilesDir = (lfCurrent, lfUp, lfDown);

  TRouteParm = (RoutePref, TransportMode);

  TCoordinatesAppliedEvent = procedure(Sender: Tobject; Coords: string) of object;

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
    CmbDevices: TComboBox;
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
    EdFileSysFolder: TEdit;
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
    Settransportationmodeofselectedtrips1: TMenuItem;
    Automotive1: TMenuItem;
    MotorCycling1: TMenuItem;
    OffRoad1: TMenuItem;
    Setroutepreferenceofselectedtrips1: TMenuItem;
    Fastertime1: TMenuItem;
    Shorterdistance1: TMenuItem;
    Directrouting1: TMenuItem;
    Curvyroads1: TMenuItem;
    BtnFromDev: TButton;
    BtnToDev: TButton;
    PnlTopFiller: TPanel;
    BtnRefreshFileSys: TButton;
    PnlBotFileSys: TPanel;
    Panel1: TPanel;
    BtnOpenTemp: TButton;
    MapTimer: TTimer;
    PnlTripGpiInfo: TPanel;
    CmbModel: TComboBox;
    BtnPostProcess: TButton;
    ChkWatch: TCheckBox;
    OpenTrip: TOpenDialog;
    ActionMainMenuBar: TActionMainMenuBar;
    ActionManager: TActionManager;
    Action1: TAction;
    Action2: TAction;
    PopupTripInfo: TPopupMenu;
    CopyValueFromTrip: TMenuItem;
    Action3: TAction;
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
    procedure BtnAddToMapClick(Sender: TObject);
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
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure CopyValueFromTripClick(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
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
  private
    { Private declarations }
    PrefDevice: string;
    DeviceFile: Boolean;
    HexEditFile: string;

    CurrentDevice: TMTP_Device;
    FSavedParent: WideString;
    FSavedFolderId: WideString;

    FCurrentPath: WideString;
    DeviceList: Tlist;
    FSortSpecification: TSortSpecification;
    HexEdit: TBCHexEditor;
    ATripList: TTripList;
    APOIList: TPOIList;

    WarnRecalc: integer; // MrNone, MrYes, MrNo, mrIgnore
    WarnModel: boolean;
    WarnOverWrite: integer;  // MrNone, MrYes, MrNo, mrYesToAll, mrNoToAll
    ModifiedList: TStringList;
    DirectoryMonitor: TDirectoryMonitor;

    FOnCoordinatesApplied: TCoordinatesAppliedEvent;
    FMapReq: TMapReq;
    EdgeZoom: double;
    RoutePointTimeOut: string;
    GeoSearchTimeOut: string;
    USBEvent: TUSBEvent;
    procedure DirectoryEvent(Sender: TObject; Action: TDirectoryMonitorAction; const FileName: WideString);
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
    procedure MapRequest(const Coords, Desc, TimeOut: string;
                         const ZoomLevel: string = '');
    procedure SaveTripGpiFile;
    procedure LoadTripFile(const FileName: string; const FromDevice: boolean);
    procedure LoadGpiFile(const FileName: string; const FromDevice: boolean);

    procedure FreeDeviceData(const ACustomData: pointer);
    procedure FreeDevices;
    procedure GuessModel(const FriendlyName: string);
    function DeviceIdInList(const DeviceName: string): integer;
    procedure SelectDevice(const Indx: integer); overload;
    procedure SelectDevice(const Device: string); overload;
    function GetItemType(const AListview: TListView): TDirType;

    procedure CloseDevice;
    function CheckDevice(RaiseException: boolean = true): boolean;
    procedure GetDeviceList;
    function GetDevicePath(const CompletePath: string): string;
    function GetSelectedFile: string;
    procedure SetSelectedFile(AFile: string);

    procedure SetCurrentPath(const APath: string);
    function CopyFileToTmp(const AListItem: TListItem): string;
    procedure CopyFileFromTmp(const LocalFile: string; const AListItem: TListItem);
    procedure ListFiles(const ListFilesDir: TListFilesDir = TListFilesDir.lfCurrent);
    procedure DeleteObjects(const AllowRecurse: boolean);
    procedure ReloadFileList;
    procedure SetCheckMark(const AListItem: TListItem; const NewValue: boolean);
    procedure CheckFile(const AListItem: TListItem);
    procedure SetImported(const AListItem: TListItem; const NewValue: boolean);
    procedure GroupTrips(Group: Boolean);
    procedure SetRouteParm(ARouteParm: TRouteParm; Value: byte);
    procedure CheckTrips;
    procedure CheckSupportedModel(const ZumoModel: TZumoModel; const AllFuncs: array of TGPXFunc);

    procedure ShowWarnRecalc;
    procedure ShowWarnOverWrite(const AFile: string);
    procedure ReadDefaultFolders;
    procedure ReadColumnSettings;
    procedure WriteColumnSettings;
    procedure OnSetPostProcessPrefs(Sender: TObject);
    procedure ReadSettings;
    procedure ClearTripInfo;
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
    property OnCoordinatesApplied: TCoordinatesAppliedEvent read FOnCoordinatesApplied write FOnCoordinatesApplied;
  end;

var
  FrmTripManager: TFrmTripManager;

implementation

uses
  System.StrUtils, System.UITypes, System.DateUtils, System.TypInfo,
  Winapi.ShellAPI, Vcl.Clipbrd,
  MsgLoop, UnitProcessOptions, UnitRegistry, UnitRegistryKeys, UnitStringUtils, UnitOSMMap, UnitGeoCode, UnitVerySimpleXml,
  UnitGpxTripCompare,
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

procedure TFrmTripManager.CheckSupportedModel(const ZumoModel: TZumoModel; const AllFuncs: array of TGPXFunc);
var
  Rc: integer;
  GPXFunc: TGPXFunc;
begin
  if not WarnModel then
    exit;

  for GPXFunc in AllFuncs do
  begin
    case GPXFunc of
      TGPXFunc.CreateTrips:
      begin
        case ZumoModel of
          TZumoModel.XT,
          TZumoModel.XT2,
          TZumoModel.Tread2:;  // Fall thru
          else
            begin
              Rc := MessageDlg('Trip files created may not work for selected model.',
                               TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbIgnore], 0);
              if (Rc = ID_IGNORE) then
                SetRegistry(Reg_WarnModel_Key, 'False');
              WarnModel := false;
            end;
        end;
      end;
    end;
  end;
end;

procedure TFrmTripManager.GuessModel(const FriendlyName: string);
begin
  CmbModel.ItemIndex := Ord(TZumoModel.Unknown);
  if (ContainsText(FriendlyName, Tread2_Name)) then
    CmbModel.ItemIndex := Ord(TZumoModel.Tread2)
  else if (ContainsText(FriendlyName, XT2_Name)) then
    CmbModel.ItemIndex := Ord(TZumoModel.XT2)
  else if (ContainsText(FriendlyName, XT_Name)) then
    CmbModel.ItemIndex := Ord(TZumoModel.XT);
  SetRegistry(Reg_CurrentDevice, FriendlyName);
  SetRegistry(Reg_ZumoModel, CmbModel.Text);
end;

// No need to close manually.
procedure TFrmTripManager.CloseDevice;
begin
  CurrentDevice := nil;
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

procedure TFrmTripManager.Action1Execute(Sender: TObject);
begin
  ShowMessage(VerInfo);
end;

procedure TFrmTripManager.Action2Execute(Sender: TObject);
begin
  ShellExecute(0, 'Open',
               'https://htmlpreview.github.io/?https://github.com/FrankBijnen/TripManager/blob/main/TripManager/docs/README.md',
               '','', SW_SHOWNORMAL);
end;

procedure TFrmTripManager.Action3Execute(Sender: TObject);
begin
  ParseLatLon(EditMapCoords.Text, FrmAdvSettings.SampleLat, FrmAdvSettings.SampleLon);
  FrmAdvSettings.SampleTrip := ATripList;
  if FrmAdvSettings.ShowModal = mrOk then
    ReadSettings;

  BgDeviceClick(BgDevice);
end;

procedure TFrmTripManager.AdvPanel_MapTopResize(Sender: TObject);
var SizeLeft: integer;
begin
  SizeLeft := AdvPanel_MapTop.Width - (PnlRoutePoint.Left + PnlRoutePoint.Width);
  LblRoute.Width := SizeLeft div 2;
end;

procedure TFrmTripManager.BgDeviceClick(Sender: TObject);
begin
  LstFiles.Tag := 1;
  try
    LstFiles.Checkboxes := (BgDevice.ItemIndex = 0);
    if (LstFiles.Columns.Count > TripNameCol) then
    begin
      if (BgDevice.ItemIndex = 0) then
        LstFiles.Columns[TripNameCol].Width := TripNameColWidth
      else
        LstFiles.Columns[TripNameCol].Width := 0;
    end;
  finally
    LstFiles.Tag := 0;
  end;
  if CheckDevice(false) then
  begin
    SetCurrentPath(DeviceFolder[BgDevice.ItemIndex]);
    ListFiles;
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
    LoadTripOnMap(ATripList, CurrentTrip);
    BtnSaveTripValues.Enabled := true;
  end;

begin
  // Updating location for Trip Editor
  if (Assigned(FOnCoordinatesApplied)) then
  begin
    FOnCoordinatesApplied(Self, EditMapCoords.Text);

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
    EdDeviceFolder.Text := FCurrentPath;
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
  if (CreateOSMMapHtml(GetRegistry(Reg_SavedMapPosition_Key, Reg_DefaultCoordinates))) then
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
  GPXFile, TempFile, CurrentObjectId, SavedFolderId: string;
  AnItem: TListItem;
  Fs: TSearchRec;
  Rc: integer;
begin
  if (ShellListView1.SelectedFolder = nil) then
    exit;

  // Revert to default (startup) locations
  ReadDefaultFolders;
  FrmSendTo.HasCurrentDevice := CheckDevice(false);

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
    CheckSupportedModel(TZumoModel(CmbModel.ItemIndex), FrmSendTo.Funcs);

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
                                      SetProcessOptions.SetSendToPrefs, SetProcessOptions.SavePrefs,
                                      GetRoutesTmp, nil, AnItem.Index);

            // Need to copy the complete route?
            if (GetRegistry(Reg_FuncCompleteRoute, false)) then
              CopyFile(PWideChar(GPXFile), PWideChar(IncludeTrailingPathDelimiter(GetRoutesTmp) + ExtractFilename(GPXFile)), false);

            {$IFNDEF DEBUG_TRANSFER}
            // The Temp directory 'Routes' now has all the files to send.
            // Do the transfer, based on Extension.
            Rc := FindFirst(GetRoutesTmp + '\*.*', faAnyFile - faDirectory, Fs);
            while (Rc = 0) do
            begin
              TempFile := Fs.Name;
              if (ContainsText(ExtractFileExt(Fs.Name), TripExtension)) then
                SetCurrentPath(DeviceFolder[0])
              else if (ContainsText(ExtractFileExt(Fs.Name), GpxExtension)) then
                SetCurrentPath(DeviceFolder[1])
              else if (ContainsText(ExtractFileExt(Fs.Name), GPIExtension)) then
                SetCurrentPath(DeviceFolder[2])
              else
                continue;

              // Overwrite?
              CurrentObjectid := GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, TempFile);
              if (CurrentObjectid <> '') then
              begin
                ShowWarnOverWrite(TempFile);
                if (WarnOverWrite in [mrNo, mrNoToAll]) then
                begin
                  Rc := FindNext(Fs);
                  continue;
                end;
                if (not DelFromDevice(CurrentDevice.PortableDev, CurrentObjectid)) then
                  raise Exception.Create(Format('Could not remove file: %s on %s', [TempFile, CurrentDevice.FriendlyName]));
              end;

              // Transfer
              EdFileSysFolder.Text := Format('Transferring %s', [TempFile]);
              EdFileSysFolder.Update;
              TempFile := IncludeTrailingPathDelimiter(GetRoutesTmp) + TempFile;

              // Did the transfer work?
              if (TransferNewFileToDevice(CurrentDevice.PortableDev, TempFile, FSavedFolderId) = '') then
                raise Exception.Create(Format('Could not overwrite file: %s on %s',
                                              [ExtractFileName(TempFile), CurrentDevice.FriendlyName]));

              Rc := FindNext(Fs);
            end;
            FindClose(Fs);
            {$ENDIF}
          end;
        TSendToDest.stWindows:
          begin
            TGPXFile.PerformFunctions(FrmSendTo.Funcs, GPXFile,
                                      SetProcessOptions.SetSendToPrefs, SetProcessOptions.SavePrefs,
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
  DeviceName: string;
begin
  if Assigned(CurrentDevice) then
    DeviceName := CurrentDevice.FriendlyName
  else
    DeviceName := PrefDevice;

  GetDeviceList;
  try
    SelectDevice(DeviceName);
    if CheckDevice(false) then
      ReloadFileList;
  except
    CurrentDevice := nil; // Prevent needless tries
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

procedure TFrmTripManager.EditTrip(NewFile: boolean);
begin
// Clear treeview to avoid AV's when the TripList's items are deleted
  TvTrip.Items.Clear;
  ClearTripInfo;

// Create new empty triplist?
  if not Assigned(ATripList) then
    ATripList := TTripList.Create;
  if (NewFile) then
    ATripList.CreateTemplate(TZumoModel(CmbModel.ItemIndex), FrmNewTrip.EdNewTrip.Text);

// Set FrmTripEditor Params
  FrmTripEditor.CurTripList := ATripList;
  FrmTripEditor.CurPath := ShellTreeView1.Path;
  FrmTripEditor.CurFile := HexEditFile;
  FrmTripEditor.CurDevice := DeviceFile;
  FrmTripEditor.CurNewFile := NewFile;

// Set FrmTripEditor Events
  FrmTripEditor.OnTripFileCanceled := TripFileCanceled;
  FrmTripEditor.OnTripFileUpdating := TripFileUpdating;
  FrmTripEditor.OnTripFileUpdated := TripFileUpdated;
  FrmTripEditor.OnRoutePointsShowing := RoutePointsShowing;

// Set DmRoutePoints events
  DmRoutePoints.OnGetMapCoords := GetMapCoords;
  DmRoutePoints.OnRouteUpdated := ReloadTripOnMap;

// Position left from the map.
  FrmTripEditor.Top := Top;
  FrmTripEditor.Left := Left;
  FrmTripEditor.Show;
end;

procedure TFrmTripManager.ReloadTripOnMap(Sender: TObject);
begin
  DmRoutePoints.SaveTrip;
  FrmTripEditor.CurTripList.ForceRecalc;
  LoadTripOnMap(FrmTripEditor.CurTripList, CurrentTrip);
end;

procedure TFrmTripManager.RoutePointsShowing(Sender: TObject; Showing: boolean);
var
  CurSel: integer;
begin
  if Showing then
  begin
    OnCoordinatesApplied := DmRoutePoints.CoordinatesApplied;
    DmRoutePoints.OnRoutePointUpdated := RoutePointUpdated;
  end
  else
  begin
    DmRoutePoints.OnRoutePointUpdated := nil;
    OnCoordinatesApplied := nil;
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
begin
  if not Assigned(ATripList) or
     (ATripList.ItemList.Count = 0) then
    exit;

  SaveTrip.Filter := '*.gpx|*.gpx';
  SaveTrip.InitialDir := ShellTreeView1.Path;
  SaveTrip.FileName := ChangeFileExt(ExtractFileName(HexEditFile), '.gpx');
  if not SaveTrip.Execute then
    exit;

  ATripList.SaveAsGPX(SaveTrip.FileName);
end;

procedure TFrmTripManager.CompareWithGpx(Sender: TObject);
var
  GPXFileObj: TGPXTripCompare;
  CrWait, CrNormal: HCURSOR;
  OsmTrack: TStringList;
  GpxSelected: boolean;
  TagsToShow: TTagsToShow;
  AnItem: TListItem;
begin
  if (ATripList = nil) or
    (ATripList.GetItem('mAllRoutes') = nil) then
    exit;

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
    GpxSelected := GPXFileObj.ShowSelectTracks('Compare with GPX: ' + ExtractFileName(OpenTrip.FileName),
                                               'Select 1 Route or Track',
                                                TagsToShow, ATripList.GetValue('mTripName'));
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
      DeleteCompareFiles;
      OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s%s',
                                              [App_Prefix,
                                              CompareTrip,
                                              ExtractFileName(OpenTrip.FileName),
                                              GetTracksExt]));
      Clipboard.AsText := FrmShowLog.LbLog.Items.Text;
      FrmShowLog.FSyncTreeview := SyncDiff;
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
begin
  CheckDevice;

  // Save Device settings
  SetRegistry(Reg_PrefDev_Key, CurrentDevice.FriendlyName);
  case (BgDevice.ItemIndex) of
    0: SetRegistry(Reg_PrefDevTripsFolder_Key, GetDevicePath(FCurrentPath));
    1: SetRegistry(Reg_PrefDevGpxFolder_Key, GetDevicePath(FCurrentPath));
    2: SetRegistry(Reg_PrefDevPoiFolder_Key, GetDevicePath(FCurrentPath));
  end;

  PrefDevice := GetRegistry(Reg_PrefDev_Key, XT_Name);
  GuessModel(PrefDevice);
  ReadDefaultFolders;
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

procedure TFrmTripManager.PopupTripEditPopup(Sender: TObject);
begin
  MnuTripNewMTP.Enabled := CheckDevice(false);
end;

procedure TFrmTripManager.PopupTripInfoPopup(Sender: TObject);
begin
  SaveGPX1.Enabled := (ATripList <> nil) and
                      (ATripList.ItemList.Count > 0);

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
  case (WarnRecalc) of
    mrIgnore:
      exit;
  end;
  WarnRecalc := MessageDlg('Saving the trip will force recalculation. OK?',
                   TMsgDlgType.mtWarning,
                    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo, TMsgDlgBtn.mbIgnore], 0);
end;

procedure TFrmTripManager.ShowWarnOverWrite(const AFile: string);
begin
  case (WarnOverWrite) of
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

procedure TFrmTripManager.EdFileSysFolderKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
  begin
    ShellTreeView1.Path := EdFileSysFolder.Text;
    Key := #0;
  end;
end;

procedure TFrmTripManager.EdgeBrowser1CreateWebViewCompleted(Sender: TCustomEdgeBrowser; AResult: HRESULT);
begin
  if (AResult <> S_OK) then
    ShowMessage('Could not load OSM Map');
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
    HexEditFile := ChangeFileExt(IncludeTrailingPathDelimiter(CreatedTempPath) + FrmNewTrip.EdNewTrip.Text, '.' + TripExtension);
    EditTrip(true);
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
    HexEditFile := ChangeFileExt(IncludeTrailingPathDelimiter(ShellTreeView1.Path) + FrmNewTrip.EdNewTrip.Text, '.' + TripExtension);
    EditTrip(true);
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
  if (Assigned(Sender)) and
     (Sender is TXmlVSNode) then
  begin
    CoordGpx.FromAttributes(TXmlVSNode(Sender).AttributeList);
    CoordGpx.FormatLatLon(BestLat, BestLon);
    MapRequest(BestLat + ', ' + BestLon, TXmlVSNode(Sender).NodeValue, RoutePointTimeOut);
    exit;
  end;

  if (Assigned(Sender)) and
     (Sender is TUdbDir) then
  begin
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
  ReadSettings;

  ATripList := TTripList.Create;
  APOIList := TPOIList.Create;

  try
    AFilePath := GetRegistry(Reg_PrefFileSysFolder_Key);
    if (AFilePath <> '') and
       (DirectoryExists(AFilePath)) then
      ShellTreeView1.Path := AFilePath;
  except
    ShellTreeView1.Root := Reg_PrefFileSysFolder_Val;
  end;

  BgDevice.ItemIndex := 0; // Default to trips
  GetDeviceList;
  SelectDevice(PrefDevice);
  BgDeviceClick(BgDevice);
end;

procedure TFrmTripManager.FormDestroy(Sender: TObject);
begin
  DirectoryMonitor.Free;
  ModifiedList.Free;
  if not USBEvent.UnRegisterUSBHandler then
    ShowMessage('Failed to unregister USB Events');
  USBEvent.Free;

  ClearTripInfo;
  ATripList.Free;
  APOIList.Free;
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

procedure TFrmTripManager.GetDeviceList;
var
  Index: integer;
begin
  CurrentDevice := nil;
  FreeDevices;
  LstFiles.Clear;
  DeviceList := GetDevices;
  for Index := 0 to DeviceList.Count - 1 do
    CmbDevices.Items.Add(TMTP_Device(DeviceList[Index]).FriendlyName + ' (' + TMTP_Device(DeviceList[Index]).Description + ')');
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
    raise exception.Create(Format('Device %s could not be opened.', [CurrentDevice.FriendlyName]));

  // Guess model from FriendlyName
  GuessModel(CurrentDevice.FriendlyName);

  // Need to set the folder?
  if (DeviceFolder[BgDevice.ItemIndex] <> '') then
    SetCurrentPath(DeviceFolder[BgDevice.ItemIndex]);
end;

procedure TFrmTripManager.SelectDevice(const Device: string);
var
  Index: integer;
begin
  CmbDevices.ItemIndex := -1;
  CmbDevices.Text := SelectMTPDevice;

  for Index := 0 to DeviceList.Count - 1 do
  begin
    // Does this device match our registry setting? Select right away
    if (SameText(TMTP_Device(DeviceList[Index]).FriendlyName, Device)) then
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
    ReadDefaultFolders;
    SelectDevice(CmbDevices.ItemIndex);

    ListFiles;
  end;
end;

procedure TFrmTripManager.CmbModelChange(Sender: TObject);
begin
  SetRegistry(Reg_ZumoModel, CmbModel.Text);
end;

function TFrmTripManager.GetDevicePath(const CompletePath: string): string;
var P: integer;
begin
  result := CompletePath;
  P := Pos('\', result);
  if (P > 1) and
     (Pos(':\', result) = 0) then
    result := Copy(result, P + 1, Length(result));
end;

procedure TFrmTripManager.SetCurrentPath(const APath: string);
var FriendlyPath: string;
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
            (ContainsText(Ext, KmlExtension));

end;

procedure TFrmTripManager.ShellListView1Click(Sender: TObject);
var
  Ext: string;
  AnItem: TlistItem;
  HasGpxSelected, HasTripSelected: boolean;
begin
  BtnAddToMap.Enabled :=  false;
  BtnSendTo.Enabled := false;
  BtnPostProcess.Enabled := false;

  if (ShellListView1.SelectedFolder = nil) then
    exit;

  HasGpxSelected := false;
  HasTripSelected := false;
  for AnItem in ShellListView1.Items do
  begin
    if (AnItem.Selected = false) or
       (ShellListView1.Folders[AnItem.Index].IsFolder) then
      continue;

    Ext := ExtractFileExt(ShellListView1.Folders[AnItem.Index].PathName);
    HasGpxSelected := HasGpxSelected or ContainsText(Ext, GpxExtension);
    HasTripSelected := HasTripSelected or ContainsText(Ext, TripExtension);
  end;

  BtnAddToMap.Enabled := (HasGpxSelected or HasTripSelected) and
                         (ShellListView1.SelCount = 1);
  BtnSendTo.Enabled := HasGpxSelected;
  BtnPostProcess.Enabled := HasGpxSelected;

  Ext := ExtractFileExt(ShellListView1.SelectedFolder.PathName);
  if (ContainsText(Ext, TripExtension)) then
    LoadTripFile(ShellListView1.SelectedFolder.PathName, false)
  else if (ContainsText(Ext, GPIExtension)) then
    LoadGPiFile(ShellListView1.SelectedFolder.PathName, false);
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
  case Key of
    Ord('A'):
    begin
      if (ssCtrl in Shift) and
         (Key = Ord('A')) then
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
  EdFileSysFolder.Text := ShellTreeView1.Path;
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

procedure TFrmTripManager.SpeedBtn_MapClearClick(Sender: TObject);
begin
  DeleteTempFiles(GetOSMTemp, GetTracksMask);
  if (CreateOSMMapHtml(GetRegistry(Reg_SavedMapPosition_Key, Reg_DefaultCoordinates))) then
    EdgeBrowser1.Navigate(GetHtmlTmp);
end;

procedure TFrmTripManager.BtnAddToMapClick(Sender: TObject);
var
  AStream: TBufferedFileStream;
  MemStream: TMemoryStream;
  MapTrip: TTripList;
  OsmTrack: TStringList;
  Ext: string;
begin
  if ShellListView1.SelectedFolder = nil then
    exit;
  Ext := ExtractFileExt(ShellListView1.SelectedFolder.PathName);
  OsmTrack := TStringList.Create;
  try
    if (ContainsText(Ext, TripExtension)) then
    begin
      AStream := TBufferedFileStream.Create(ShellListView1.SelectedFolder.PathName, fmOpenRead);
      MapTrip := TTripList.Create;
      try
        if not MapTrip.LoadFromStream(AStream) then
          exit;
        MemStream := TMemoryStream.Create;
        try
          ATripList.SaveToStream(MemStream);
        finally
          MemStream.Free;
        end;
        LoadTripOnMap(MapTrip, Format('%s%s', [FileSysTrip, ExtractFileName(ShellListView1.SelectedFolder.PathName)]));
      finally
        MapTrip.Free;
        AStream.Free;
      end;
    end
    else
    begin
      TGPXFile.PerformFunctions([CreateOSMPoints], ShellListView1.SelectedFolder.PathName,
                                nil, SetProcessOptions.SavePrefs,
                                '', OsmTrack);

      OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s%s',
                                              [App_Prefix,
                                              FileSysTrip,
                                              ExtractFileName(ShellListView1.SelectedFolder.PathName),
                                              GetTracksExt]));
    end;

    if (CreateOSMMapHtml) then
      EdgeBrowser1.Navigate(GetHtmlTmp);

  finally
    OsmTrack.Free;
  end;
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
    CurrentTrip.CreateOSMPoints(OsmTrack, OSMColor(GetRegistry(Reg_TripColor_Key, Reg_TripColor_Val)));
    OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s', [App_Prefix, Id, GetTracksExt]));
    TrackToRouteInfoMap := CurrentTrip.GetItem('mTrackToRouteInfoMap') as TmTrackToRouteInfoMap;
    if (Assigned(TrackToRouteInfoMap)) then
    begin
      OsmTrack.Text := TrackToRouteInfoMap.GetCoords(ProcessOptions.TrackColor);
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
begin
  if not Assigned(CurrentGpi) then
    exit;
  OsmTrack := TStringList.Create;
  try
    for AGPXwayPoint in CurrentGpi do
      OsmTrack.Add(Format('AddPOI("%s", %s, %s, "./%s.png");',
                          [EscapeDQuote(string(AGPXwayPoint.Name)), AGPXwayPoint.Lat, AGPXwayPoint.Lon, AGPXwayPoint.Symbol] ));
    DeleteCompareFiles;
    OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s', [App_Prefix, Id, GetTracksExt]));
    if (CreateOSMMapHtml) then
      EdgeBrowser1.Navigate(GetHtmlTmp);

  finally
    OsmTrack.Free;
  end;
end;

procedure TFrmTripManager.CheckTrips;
var AListItem: TListItem;
    CrNormal,CrWait: HCURSOR;
begin
  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    for AListItem in LstFiles.Items do
      CheckFile(AListItem);
  finally
    SetCursor(CrNormal);
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
                            (SelectedLocation <> nil) or
                            (SelectedScPosn <> nil);
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
     (ContainsText(LstFiles.Selected.SubItems[2], GpiExtension)) then
  begin
    CopyFileToTmp(LstFiles.Selected);
    if (ContainsText(LstFiles.Selected.SubItems[2], GpiExtension)) then
      LoadGpiFile(IncludeTrailingPathDelimiter(CreatedTempPath) + LstFiles.Selected.Caption, true)
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
      if (ANitem is TBaseDataItem) then
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

      VlTripInfo.Strings.AddPair('Size', Format('Size: %d', [LenValue]),
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
    VlTripInfo.Strings.AddPair('MapSegment + RoadId', Format('%s %s',
                                 [IntToHex(Swap32(AnUdbDir.UdbDirValue.SubClass.MapSegment), 8),
                                  IntToHex(Swap32(AnUdbDir.UdbDirValue.SubClass.RoadId), 8)]),
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
    VlTripInfo.Strings.AddPair('Coordinates', Format('%s', [AnUdbDir.MapCoords]),
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
    VlTripInfo.Strings.AddPair('Border', Format('%d', [AnUdbDir.UdbDirValue.Border]),
                              TGridSelItem.Create(AnUdbDir,
                                                  SizeOf(AnUdbDir.UdbDirValue.Border),
                                                  OffsetInRecord(AnUdbDir.UdbDirValue, AnUdbDir.UdbDirValue.Border)));
    VlTripInfo.Strings.AddPair('UdbDir Unknown2', Format('%d bytes', [SizeOf(AnUdbDir.UdbDirValue.Unknown2)]
                                                        ),
                              TGridSelItem.Create(AnUdbDir,
                                                  SizeOf(AnUdbDir.UdbDirValue.Unknown2),
                                                  OffsetInRecord(AnUdbDir.UdbDirValue, AnUdbDir.UdbDirValue.Unknown2)));

    VlTripInfo.Strings.AddPair('Address', AnUdbDir.DisplayName,
                              TGridSelItem.Create(AnUdbDir,
                                                  SizeOf(AnUdbDir.UdbDirValue.Name),
                                                  OffsetInRecord(AnUdbDir.UdbDirValue, AnUdbDir.UdbDirValue.Name)));

    VlTripInfo.Strings.AddPair('*** End UdbDir', DupeString('-', DupeCount),
                              TGridSelItem.Create(AnUdbDir, 1, SizeOf(AnUdbDir.UdbDirValue) -1));
    if (ZoomToPoint) then
      MapRequest(AnUdbDir.MapCoords,
                 Format('%s<br>%s', [AnUdbDir.DisplayName, AnUdbDir.Direction]), RoutePointTimeOut);
  end;


  procedure AddUdbHandle(AnUdbhandle: TmUdbDataHndl);
  var
    ANitem: TBaseItem;
    OffSetPref: integer;
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

    VlTripInfo.Strings.AddPair('Calculation status', Format('0x%s (0x0538FEFF=XT 0x05d8FEFF=XT2 0x0574FEFF=Tread 2)', [IntToHex(AnUdbhandle.UdbHandleValue.CalcStatus, 8)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.UdbHandleValue.CalcStatus),
                                                   AnUdbhandle.OffsetValue + OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.CalcStatus) ));

    VlTripInfo.Strings.AddPair('Unknown2', '150 bytes',
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.UdbHandleValue.Unknown2),
                                                   AnUdbhandle.OffsetValue + OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.Unknown2) ));

    VlTripInfo.Strings.AddPair('UdbDir count', Format('%d', [AnUdbhandle.UdbHandleValue.UDbDirCount]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(AnUdbhandle.UdbHandleValue.UDbDirCount),
                                                   AnUdbhandle.OffsetValue + OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.UDbDirCount) ));

    VlTripInfo.Strings.AddPair('Unknown3', Format('%d bytes', [Length(AnUdbhandle.UdbHandleValue.Unknown3)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   Length(AnUdbhandle.UdbHandleValue.Unknown3),
                                                   AnUdbhandle.OffsetValue + OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.Unknown3) ));
    VlTripInfo.Strings.AddPair('Unknown3 dist', Format('%d (meters)', [AnUdbhandle.UdbHandleValue.GetUnknown3(Unknown3DistOffset)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(Cardinal),
                                                   AnUdbhandle.OffsetValue +
                                                     OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.Unknown3) +
                                                     Unknown3DistOffset));
    VlTripInfo.Strings.AddPair('Unknown3 Time', Format('%d (seconds)', [AnUdbhandle.UdbHandleValue.GetUnknown3(Unknown3TimeOffset)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                   SizeOf(Cardinal),
                                                   AnUdbhandle.OffsetValue +
                                                     OffsetInRecord(AnUdbhandle.UdbHandleValue, AnUdbhandle.UdbHandleValue.Unknown3) +
                                                     Unknown3TimeOffset));

    for ANitem in AnUdbhandle.Items do
    begin
      if (ANitem is TUdbDir) then
        AddUdbDir(TUdbDir(ANitem), false);
    end;
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
      VlTripInfo.Strings.AddPair('SubLength',     Format('%d', [SubLength]),
                                 TGridSelItem.Create(AHeader,
                                                     SizeOf(SubLength),
                                                     OffsetInRecord(HeaderValue, SubLength) ));
      VlTripInfo.Strings.AddPair('HeaderLength',  Format('%d', [HeaderLength]),
                                 TGridSelItem.Create(AHeader,
                                                     SizeOf(HeaderLength),
                                                     OffsetInRecord(HeaderValue, HeaderLength) ));
      VlTripInfo.Strings.AddPair('TotalItems',    Format('%d', [TotalItems]),
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
      AddGPXWayPoint(TGPXWayPoint(Node.Data), true);

// Prepare TripInfo
    for Index := 0 to VlTripInfo.Strings.Count -1 do
    begin
      AnItem := TGridSelItem.BaseDataItem(VlTripInfo, Index);
      if (AnItem = nil) then
      begin
        VlTripInfo.ItemProps[Index].ReadOnly := true;
        continue;
      end;

      case (AnItem.EditMode) of
        TEditMode.emNone:
          VlTripInfo.ItemProps[Index].ReadOnly := true;
        TEditMode.emEdit: // Default
          VlTripInfo.ItemProps[Index].EditStyle := TEditStyle.esSimple;
        TEditMode.emButton:
          VlTripInfo.ItemProps[Index].EditStyle := TEditStyle.esEllipsis;
        TEditMode.emPickList:
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
    case (TUdbDir(Node.Data).Status) of
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
    case (TUdbDir(AGridSelItem.BaseItem).Status) of
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
var AMenuItem: TMenuItem;
begin
  for AMenuItem in TPopupMenu(Sender).Items do
  begin
    AMenuItem.Enabled := ((AMenuItem.GroupIndex = 1) and (AMenuItem.Enabled)) or
                         ((AMenuItem.GroupIndex = 2) and DeviceFile and (BgDevice.ItemIndex = 0));
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
                         (ContainsText(ANitem.SubItems[2], GPIExtension))
                       );
      UnlockFiles := UnlockFiles or
         (GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, ChangeFileExt(ANitem.Caption, '.' + UnlExtension) ) <> '');
    end;
    Inc(SelCount);
  end;

  if (SelCount = 0) then
  begin
    MessageDlg(Format('No %s are selected to delete from %s.', [ObjectName[AllowRecurse],
                                                                CurrentDevice.FriendlyName]),
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
                                                           CurrentDevice.FriendlyName]),
                 TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> ID_OK) then
    exit;

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
                                                                        CurrentDevice.FriendlyName]));
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
    NewName := ATripList.GetValue('mTripName') + '.' + TripExtension;

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
        TripName := TmTripName(TmpTripList.GetItem('mTripName')).AsString;
        TripFilename := TripName + '.' + TripExtension;

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

procedure TFrmTripManager.GroupTrips(Group: Boolean);
var
  ParentName: string;
  ParentId: Cardinal;

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

        // reload trip, and change mFilename
        TmpTripList.LoadFromFile(TripFilename);
        if (Group) then
          TmParentTripName(TmpTripList.GetItem('mParentTripName')).AsString := ParentName
        else
          TmParentTripName(TmpTripList.GetItem('mParentTripName')).AsString := TmTripName(TmpTripList.GetItem('mTripName')).AsString;
        TmParentTripId(TmpTripList.GetItem('mParentTripId')).AsCardinal := ParentId;
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

        // reload trip, and change mFilename
        TmpTripList.LoadFromFile(TripFilename);
        case ArouteParm of
          TRouteParm.TransportMode:
            TmTransportationMode(TmpTripList.GetItem('mTransportationMode')).AsByte := Value;
          TRouteParm.RoutePref:
            TmRoutePreference(TmpTripList.GetItem('mRoutePreference')).AsByte := Value;
        end;
        TmpTripList.ForceRecalc;
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
end;

procedure TFrmTripManager.ListFiles(const ListFilesDir: TListFilesDir = TListFilesDir.lfCurrent);
var
  ABASE_Data: TBASE_Data;
  SParent: Widestring;
  CrWait, CrNormal: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
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

    LstFiles.Clear;
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
    EdDeviceFolder.Text := CurrentDevice.FriendlyName + '\' + DeviceFolder[BgDevice.ItemIndex];

    // Trips need to be checked, and tripname filled
    case BgDevice.ItemIndex of
      0: CheckTrips;
    // Future use
    end;

    // Now sort
    DoListViewSort(LstFiles, FSortSpecification.Column, FSortSpecification.Ascending, FSortSpecification);

  finally
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
begin              case GetItemType(LstFiles) of
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

procedure TFrmTripManager.LoadHex(const FileName: string);
begin
  HexEdit.LoadFromFile(FileName);
  BtnSaveTripGpiFile.Enabled := true;
end;

procedure TFrmTripManager.LoadTripFile(const FileName: string; const FromDevice: boolean);
var
  CrWait, CrNormal: HCURSOR;
  AStream: TBufferedFileStream;
  MemStream: TMemoryStream;
  ANItem: TBaseItem;
  CurrentNode: TTreeNode;
  RootNode: TTreeNode;
  TripName: string;
  ParentTripName: string;

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
            PnlTripGpiInfo.Caption := PnlTripGpiInfo.Caption + ', Departure:' + TmArrival(ANItem).AsString;
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
  CrWait := LoadCursor(0, IDC_WAIT);
  CRNormal := SetCursor(CrWait);

  TsTripGpiInfo.Caption := 'Trip info';

  AStream := TBufferedFileStream.Create(FileName, fmOpenRead or fmShareDenyNone);
  ATripList.Clear;

  TvTrip.Items.BeginUpdate;

  VlTripInfo.Strings.BeginUpdate;
  ClearTripInfo;

  try
    if not ATripList.LoadFromStream(AStream) then
      raise Exception.Create('Not a valid trip file');

    //Save, and discard, to stream to get the sizes
    MemStream := TMemoryStream.Create;
    try
      ATripList.SaveToStream(MemStream);
    finally
      MemStream.Free;
    end;

    DeviceFile := FromDevice;
    HexEditFile := FileName;

    if (DeviceFile) and
       (ATripList.CalculatedModel = TZumoModel.Unknown) then
    begin
      SbPostProcess.Panels[0].Text := 'Not calculated trip. Marked with !';
      SbPostProcess.Panels[1].Text := 'BaseCamp may have problems reading current.gpx';
      StatusTimer.Enabled := false;
      StatusTimer.Enabled := true;
    end;

    LoadHex(FileName);
    LoadTripOnMap(ATripList, CurrentTrip);

    CopyValueFromTrip.Enabled := not DeviceFile;
    if (DeviceFile) then
      PnlTripGpiInfo.Color := clLime
    else
      PnlTripGpiInfo.Color := clAqua;
    PnlTripGpiInfo.Caption := ExtractFileName(FileName);

    TripName := ATripList.GetValue('mTripName');
    ParentTripName := ATripList.GetValue('mParentTripName');

    PnlTripGpiInfo.Caption := PnlTripGpiInfo.Caption + ', Trip:' + TripName;
    if (TripName <> ParentTripName) then
      PnlTripGpiInfo.Caption := PnlTripGpiInfo.Caption + ' (' + ParentTripName + ')';

    TvTrip.Items.Clear;
    RootNode := TvTrip.Items.AddObject(nil, ExtractFileName(FileName), ATripList);
    TvTrip.Items.AddChildObject(RootNode, ATripList.Header.ClassName, ATripList.Header);

    for ANItem in ATripList.ItemList do
    begin
      if (ANItem is TBaseDataItem) then
      begin
        with TBaseDataItem(ANItem) do
        begin
          CurrentNode := TvTrip.Items.AddChildObject(RootNode, DisplayName + '=' + AsString, ANItem);
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
    AStream.Free;

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
  if (Assigned(ATripList)) then
    ATripList.Clear;

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
      TvTrip.Items.AddChildObject(RootNode, String(AGPXWayPoint.Name), AGPXWayPoint);
    end;

    RootNode.Expand(false);
  finally
    TvTrip.Items.EndUpdate;
    TvTrip.UnlockDrawing;
    VlTripInfo.Strings.EndUpdate;
    AStream.Free;
  end;
  LoadHex(FileName);
  LoadGpiOnMap(APOIList, CurrentGpi);
  RootNode.Selected := true;
  BtnSaveTripValues.Enabled := false;
  BtnSaveTripGpiFile.Enabled := false;
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

procedure TFrmTripManager.CheckFile(const AListItem: TListItem);
var TmpTripList: TTripList;
    LocalFile: string;
begin
  if (ContainsText(AListItem.SubItems[2], TripExtension) = false) then
    exit;

  TmpTripList := TTripList.Create;
  try

    // Copy File to Local directory
    LocalFile := CopyFileToTmp(AListItem);
    if (LocalFile = '') then
      exit;

    // Check mImported by loading tmp file
    TmpTripList.LoadFromFile(LocalFile);

    // Set Check mark and calculated status
    if (AListItem.Data <> nil) and
       (TObject(AListItem.Data) is TMTP_Data) then
    with TMTP_Data(AListItem.Data) do
    begin
      IsNotSavedTrip := TBooleanItem(TmpTripList.GetItem('mImported')).AsBoolean;
      SetCheckMark(AListItem, not IsNotSavedTrip);
      CalculatedModel := Ord(TmpTripList.CalculatedModel);
      if (TmpTripList.CalculatedModel = TZumoModel.Unknown) then
        AListItem.ImageIndex := 2;
    end;

    // Show trip name
    if (LstFiles.Columns.Count > TripNameCol) then
      AListItem.SubItems[TripNameCol -1] := TBaseDataItem(TmpTripList.GetItem('mTripName')).AsString;
  finally
    TmpTripList.Free;
  end;
end;

procedure TFrmTripManager.SetImported(const AListItem: TListItem; const NewValue: boolean);
var
  TmpTripList: TTripList;
  LocalFile: string;
  NewCheck: boolean;
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

    TBooleanItem(TmpTripList.GetItem('mImported')).AsBoolean := NewValue;
    TmpTripList.SaveToFile(LocalFile);

    CopyFileFromTmp(LocalFile, AListItem);
    NewCheck := not NewCheck;
  finally
    TmpTripList.Free;
    SetCheckMark(AListItem, NewCheck);
  end;
end;

procedure TFrmTripManager.ReadDefaultFolders;
begin
  DeviceFolder[0] := GetRegistry(Reg_PrefDevTripsFolder_Key, Reg_PrefDevTripsFolder_Val);
  DeviceFolder[1] := GetRegistry(Reg_PrefDevGpxFolder_Key,   Reg_PrefDevGpxFolder_Val);
  DeviceFolder[2] := GetRegistry(Reg_PrefDevPoiFolder_Key,   Reg_PrefDevPoiFolder_Val);
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

procedure TFrmTripManager.ReadSettings;
begin
  PrefDevice := GetRegistry(Reg_PrefDev_Key, XT_Name);
  GuessModel(PrefDevice);
  ReadDefaultFolders;
  WarnModel := GetRegistry(Reg_WarnModel_Key, True);
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

  while (LstFiles.Columns.Count > TripNameCol) do
    LstFiles.Columns.Delete(LstFiles.Columns.Count -1);
  if (GetRegistry(Reg_TripNameInList, true)) then
    LstFiles.Columns.Add.Caption := 'TripName';

  EdgeBrowser1.UserDataFolder := CreatedTempPath;
  if (CreateOSMMapHtml(GetRegistry(Reg_SavedMapPosition_Key, Reg_DefaultCoordinates))) then
    EdgeBrowser1.Navigate(GetHtmlTmp);

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
begin
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
        break;
      end;

      // First file sets path
      if (FileNum = 0) then
        ShellTreeView1.Path := ExtractFileDir(FName)
      else if (ShellTreeView1.Path <> ExtractFileDir(FName)) then // all files should be in same dir!
        break;
      // Add to selection
      FNames.Add(FName);
    end;

    ShellListView1.ClearSelection;
    for Index := 0 to ShellListView1.Items.Count -1 do
      ShellListView1.Items[Index].Selected := (FNames.IndexOf(ShellListView1.Folders[Index].PathName) > -1);

    Application.BringToFront;

  finally
    FNames.Free;
    DragFinish(Msg.Drop);
  end;

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

function TFrmTripManager.DeviceIdInList(const DeviceName: string): integer;
var
  Index: integer;
begin
  result := -1;
  for Index := 0 to DeviceList.Count -1 do
  begin
    if (SameText(TMTP_Device(DeviceList[Index]).Device, DeviceName)) then
      exit(Index);
  end;
end;

procedure TFrmTripManager.USBChangeEvent(const Inserted : boolean; const DeviceName, VendorId, ProductId: string);
var
  Index: integer;
  SelectedDeviceName: string;
begin
  // Save currently selected device name
  if Assigned(CurrentDevice) then
    SelectedDeviceName := CurrentDevice.FriendlyName
  else
    SelectedDeviceName := '';

  // Removed USB device is our connected device?
  if (Inserted = false) and
     (Assigned(CurrentDevice)) and
     (SameText(CurrentDevice.Device, DeviceName)) then
  begin
    Index := DeviceIdInList(DeviceName);  // List before remove
    if (Index > -1) then
      ConnectedDeviceChanged(TMTP_Device(DeviceList[Index]).FriendlyName, 'Disconnected');
  end;

  // rebuild device list
  GetDeviceList;

  // Select the previously selected device and reload the file list
  if (SelectedDeviceName <> '') then
  begin
    SelectDevice(SelectedDeviceName);
    if CheckDevice(false) then
      ReloadFileList;
  end;

  // No Device connected and inserted USB device is our preferred device?
  if (Inserted) and
     (SelectedDeviceName = '') then
  begin
    Index := DeviceIdInList(DeviceName); // List after insert
    if (Index > -1) and
       (TMTP_Device(DeviceList[Index]).FriendlyName = PrefDevice) then
    begin
      ConnectedDeviceChanged(TMTP_Device(DeviceList[Index]).FriendlyName, 'Connected');

      CmbDevices.ItemIndex := Index;
      SelectDevice(Index);
      BgDeviceClick(BgDevice);
    end;
  end;
end;

procedure TFrmTripManager.ConnectedDeviceChanged(const Device, Status: string);
begin
  SbPostProcess.Panels[0].Text := Device;
  SbPostProcess.Panels[1].Text := Status;

  CurrentDevice := nil;
  ReadDefaultFolders;
  TvTrip.Items.Clear;
  ClearTripInfo;

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
