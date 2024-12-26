unit UFrmTripManager;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.WebView2,
  System.SysUtils, System.Variants, System.Classes, System.ImageList,
  WinApi.ShlObj, System.Win.ComObj, Winapi.ActiveX,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.ImgList, Vcl.Grids, Vcl.ValEdit, Vcl.Menus, Vcl.Mask, Vcl.Buttons, Vcl.Edge, Vcl.Shell.ShellCtrls,
  Vcl.ToolWin, Vcl.ButtonGroup,
  TripManager_ShellList,
  BCHexEditor,  UnitMtpDevice, mtp_helper, ListViewSort, UnitTripObjects, UnitGpi, Monitor;

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

  DefaultCoordinates      = '48.854918, 2.346558'; // Somewhere in Paris
  SavedMapPosition_Key    = 'SavedMapPosition';

  CurrentTrip             = 'CurrentTrip';
  CurrentGPI              = 'CurrentGPI';
  FileSysTrip             = 'FileSys';

  TripManagerReg_Key      = 'Software\TDBware\TripManager';
  PrefFileSysFolder_Key   = 'PrefFileSysFolder';
  PrefDev_Key             = 'PrefDevice';
  PrefDevTripsFolder_Key  = 'PrefDeviceTripsFolder';
  PrefDevGpxFolder_Key    = 'PrefDeviceGpxFolder';
  PrefDevPoiFolder_Key    = 'PrefDevicePoiFolder';
  WarnModel_Key           = 'WarnModel';

  BooleanValues: array[boolean] of string = ('False', 'True');

type
  TMapReq = record
    Coords: string;
    Desc: string;
    Zoom: string;
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
    PageControl1: TPageControl;
    TsTripGpiInfo: TTabSheet;
    VSplitterTree_Grid: TSplitter;
    TvTrip: TTreeView;
    VlTripInfo: TValueListEditor;
    PctHexOsm: TPageControl;
    TsHex: TTabSheet;
    TsOSMMap: TTabSheet;
    AdvPanel_MapTop: TPanel;
    EditMapCoords: TEdit;
    AdvPanel_MapBottom: TPanel;
    EditMapBounds: TLabeledEdit;
    EdgeBrowser1: TEdgeBrowser;
    CmbDevices: TComboBox;
    PnlXTLeft: TPanel;
    PnlFileSys: TPanel;
    ShellTreeView1: TShellTreeView;
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
    Splitter1: TSplitter;
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
    Delete1: TMenuItem;
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
    BtnTransferToDevice: TButton;
    PnlTopFiller: TPanel;
    BtnRefreshFileSys: TButton;
    PnlBotFileSys: TPanel;
    Panel1: TPanel;
    BtnOpenTemp: TButton;
    MapTimer: TTimer;
    BtnCreateAdditional: TButton;
    PnlTripGpiInfo: TPanel;
    CmbModel: TComboBox;
    BtnPostProcess: TButton;
    ChkWatch: TCheckBox;
    PostProcessTimer: TTimer;
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
    procedure VlTripInfoSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
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
    procedure Delete1Click(Sender: TObject);
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
    procedure CreateAdditionalClick(Sender: TObject);
    procedure BtnRefreshFileSysClick(Sender: TObject);
    procedure AdvPanel_MapTopResize(Sender: TObject);
    procedure ShellTreeView1CustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure EdDeviceFolderKeyPress(Sender: TObject; var Key: Char);
    procedure EdFileSysFolderKeyPress(Sender: TObject; var Key: Char);
    procedure MapTimerTimer(Sender: TObject);
    procedure ShellListView1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure BtnTransferToDeviceClick(Sender: TObject);
    procedure ShellListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure LstFilesKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ChkWatchClick(Sender: TObject);
    procedure PostProcessTimerTimer(Sender: TObject);
    procedure ShellListView1DblClick(Sender: TObject);

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

    FMapReq: TMapReq;

    EdgeZoom: double;
    WarnRecalc: integer; // MrNone, MrYes, MrNo, mrIgnore
    WarnModel: boolean;
    WarnOverWrite: integer;  // MrNone, MrYes, MrNo, mrYesToAll, mrNoToAll
    ModifiedList: TStringList;
    DirectoryMonitor: TDirectoryMonitor;
    procedure DirectoryEvent(Sender: TObject; Action: TDirectoryMonitorAction; const FileName: WideString);

    procedure FileSysDrop(var Msg: TWMDROPFILES); message WM_DROPFILES;
    procedure ClearSelHexEdit;
    procedure SyncHexEdit(Sender: TObject);
    procedure HexEditKeyPress(Sender: TObject; var Key: Char);
    procedure LoadHex(const FileName: string);
    procedure LoadTripOnMap(CurrentTrip: TTripList; Id: string);
    procedure LoadGpiOnMap(CurrentGpi: TPOIList; Id: string);
    procedure MapRequest(const Coords, Desc, Zoom: string);

    procedure SaveTripGpiFile;
    procedure LoadTripFile(const FileName: string; const FromDevice: boolean);
    procedure LoadGpiFile(const FileName: string; const FromDevice: boolean);

    procedure FreeCustomData(const ACustomData: pointer);
    procedure FreeDevices;
    procedure GuessModel(const FriendlyName: string);
    procedure SelectDevice(const Indx: integer);
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
    procedure ReloadFileList;
    procedure SetCheckMark(const AListItem: TListItem; const NewValue: boolean);
    procedure CheckFile(const AListItem: TListItem);
    procedure SetImported(const AListItem: TListItem; const NewValue: boolean);
    procedure GroupTrips(Group: Boolean);
    procedure SetRouteParm(ARouteParm: TRouteParm; Value: byte);
    procedure CheckTrips;
    procedure ShowWarnRecalc;
    procedure ShowWarnOverWrite(const AFile: string);
    procedure ReadSettings;
    procedure ClearTripInfo;
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
  public
    { Public declarations }
    DeviceFolder: array[0..2] of string;
    procedure SetFixedPrefs;
    procedure CheckSupportedModel;
  end;

var
  FrmTripManager: TFrmTripManager;

implementation

uses
  System.StrUtils, System.UITypes, System.DateUtils, winapi.ShellAPI, Vcl.Clipbrd,
  UnitStringUtils, UnitOSMMap, UnitGpx, MsgLoop,
  UFrmDateDialog, UFrmPostProcess, UFrmAdditional, UFrmTransferOptions;

const
  DupeCount = 10;

{$R *.dfm}

type
  TGridSelItem = class(TObject)
  private
    FBaseItem: TBaseItem;
    FSelStart: integer;
    FSelLength: integer;
  public
    constructor Create(ABaseItem: TBaseItem;
                       ASelLength: integer = -1;
                       ASelStart: integer = -1); overload;
    constructor Create(ASelLength, ASelStart: integer); overload;
    property BaseItem: TBaseItem read FBaseItem;
    property SelStart: integer read FSelStart;
    property SelLength: integer read FSelLength;
    class function GridSelItem(AValueListEditor: TValueListEditor; ARow: integer): TGridSelItem;
    class function BaseDataItem(AValueListEditor: TValueListEditor; ARow: integer): TBaseDataItem;
  end;

constructor TGridSelItem.Create(ABaseItem: TBaseItem;
                                ASelLength: integer = -1;
                                ASelStart: integer = -1);
begin
  inherited Create;
  FBaseItem := ABaseItem;

  FSelStart := integer(FBaseItem.SelStart);
  if (ASelStart <> -1) then
    FSelStart := FSelStart + ASelStart;

  FSelLength := ASelLength;
  if (FSelLength = -1) then
    FSelLength := integer(FBaseItem.SelEnd) - FSelStart;
end;

constructor TGridSelItem.Create(ASelLength, ASelStart: integer);
begin
  inherited Create;
  FBaseItem := nil;
  FSelStart := ASelStart;
  FSelLength := ASelLength;
end;


class function TGridSelItem.GridSelItem(AValueListEditor: TValueListEditor; ARow: integer): TGridSelItem;
begin
  result := nil;

  if (ARow < 0) or
     (ARow > AValueListEditor.Strings.Count -1) then
    exit;

  if (AValueListEditor.Strings.Objects[ARow] <> nil) and
     (AValueListEditor.Strings.Objects[ARow] is TGridSelItem)  then
    result := TGridSelItem(AValueListEditor.Strings.Objects[ARow]);
end;

class function TGridSelItem.BaseDataItem(AValueListEditor: TValueListEditor; ARow: integer): TBaseDataItem;
var
  AGridSel: TGridSelItem;
begin
  result := nil;
  AGridSel := TGridSelItem.GridSelItem(AValueListEditor, ARow);
  if not Assigned(AGridSel) then
    exit;

  if (AGridSel.FBaseItem <> nil) and
     (AGridSel.FBaseItem is TBaseDataItem) then
    result := TBaseDataItem(AGridSel.FBaseItem);
end;

function OffsetInRecord(const Base; const Field): integer;
begin
  result := integer(@Field) - integer(@Base);
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

procedure TFrmTripManager.CheckSupportedModel;
var
  Rc: integer;
begin
  if not WarnModel then
    exit;
  if (CmbModel.ItemIndex <> Ord(TZumoModel.XT)) then
  begin
    Rc := MessageDlg('Trip files created may not work for selected model.', TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbIgnore], 0);
    if (Rc = ID_IGNORE) then
      SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, WarnModel_Key, 'False');
    WarnModel := false;
  end;
end;

procedure TFrmTripManager.GuessModel(const FriendlyName: string);
begin
  CmbModel.ItemIndex := Ord(TZumoModel.Unknown);
  if (ContainsText(FriendlyName, XT2Name)) then
    CmbModel.ItemIndex := Ord(TZumoModel.XT2)
  else if (ContainsText(FriendlyName, XTName)) then
    CmbModel.ItemIndex := Ord(TZumoModel.XT);
end;

procedure TFrmTripManager.CloseDevice;
begin
  try
    if Assigned(CurrentDevice) and
       Assigned(CurrentDevice.PortableDev) then
      CurrentDevice.PortableDev.Close;
  except

  end;
  CurrentDevice := nil;
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
              (GetFirstStorageID(CurrentDevice.PortableDev) <> '');
    if (not result) and
       (RaiseException) then
      raise exception.Create('No MTP Device opened.');
  finally
    SetCursor(CrNormal);
  end;
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
  finally
    LstFiles.Tag := 0;
  end;
  CheckDevice;
  SetCurrentPath(DeviceFolder[BgDevice.ItemIndex]);
  ListFiles;
end;

procedure TFrmTripManager.BtnApplyCoordsClick(Sender: TObject);
var
  ABaseDataItem: TBaseDataItem;
begin
  ABaseDataItem := TGridSelItem.BaseDataItem(VlTripInfo, VlTripInfo.Row -1);
  if Assigned(ABaseDataItem) and
     (ABaseDataItem is TmScPosn) then
  begin
    TmScPosn(ABaseDataItem).MapCoords := EditMapCoords.Text;
    VlTripInfo.Cells[1, VlTripInfo.Row] := TmScPosn(ABaseDataItem).AsString;
    BtnSaveTripValues.Enabled := true;
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
        TransferNewFileToDevice(CurrentDevice.PortableDev, AFolder.PathName, FSavedFolderId)
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
        TransferExistingFileToDevice(CurrentDevice.PortableDev, AFolder.PathName, FSavedFolderId, CurrentItem);
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

procedure TFrmTripManager.BtnTransferToDeviceClick(Sender: TObject);
var
  CrWait, CRNormal: HCURSOR;
  GPXFile, TempFile, CurrentObjectId, SavedFolderId: string;
  AnItem: TListItem;
  Fs: TSearchRec;
  Rc: integer;
begin
  if (ShellListView1.SelectedFolder = nil) then
    exit;
  if (FrmTransferOptions.ShowModal <> ID_OK) then
    exit;

  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  SavedFolderId := FSavedFolderId;
  WarnOverWrite := mrNone;

  try
    ForceOutDir := GetRoutesTmp;
    ZumoModel := TZumoModel(CmbModel.ItemIndex);
    CheckSupportedModel;
    for AnItem in ShellListView1.Items do
    begin
      if (AnItem.Selected = false) then
        continue;
      if (ShellListView1.Folders[AnItem.Index].IsFolder) then
        continue;

      GPXFile := ShellListView1.Folders[AnItem.Index].PathName;
      if not (ContainsText(ExtractFileExt(GPXFile), GpxExtension)) then
        continue;

      DeleteTempFiles(ForceOutDir, '*.*');

      DoFunction(FrmTransferOptions.Funcs, GPXFile);
      if (FrmTransferOptions.CompleteRoute) then
        CopyFile(PWideChar(GPXFile), PWideChar(IncludeTrailingPathDelimiter(ForceOutDir) + ExtractFilename(GPXFile)), false);

      Rc := FindFirst(ForceOutDir + '\*.*', faAnyFile - faDirectory, Fs);
      while (Rc = 0) do
      begin
        TempFile := Fs.Name;
        if (ContainsText(ExtractFileExt(Fs.Name), TripExtension)) then
          SetCurrentPath(DeviceFolder[0])
        else if (ContainsText(ExtractFileExt(Fs.Name), GpxExtension)) then
          SetCurrentPath(DeviceFolder[1])
        else if (ContainsText(ExtractFileExt(Fs.Name), GPIExtension)) then
          SetCurrentPath(DeviceFolder[2]);

        CurrentObjectid := GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, TempFile);
        if (CurrentObjectid <> '') then
        begin
          ShowWarnOverWrite(TempFile);
          if (WarnOverWrite in [mrNo, mrNoToAll]) then
          begin
            Rc := FindNext(Fs);
            continue;
          end;
          DelFileFromDevice(CurrentDevice.PortableDev, CurrentObjectid);
        end;

        EdFileSysFolder.Text := Format('Transferring %s', [TempFile]);
        EdFileSysFolder.Update;
        TempFile := IncludeTrailingPathDelimiter(ForceOutDir) + TempFile;

        TransferNewFileToDevice(CurrentDevice.PortableDev, TempFile, FSavedFolderId);
        Rc := FindNext(Fs);
      end;
      FindClose(Fs);
    end;
  finally
    SetCursor(CrNormal);
  end;
  EdFileSysFolder.Text := ShellTreeView1.Path;
  FSavedFolderId := SavedFolderId;
  ListFiles;
end;

procedure TFrmTripManager.BtnRefreshClick(Sender: TObject);
var
  ConnectionOK: boolean;
begin
  try
    ConnectionOK := (CurrentDevice <> nil) and
                    (CurrentDevice.PortableDev <> nil);
    ConnectionOK := ConnectionOK and
                    (GetFirstStorageID(CurrentDevice.PortableDev) <> '');
  except
    CurrentDevice := nil; // Prevent needless tries
    ConnectionOK := false;
  end;

  if (ConnectionOK) then
    ReloadFileList
  else
    GetDeviceList;
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
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefDev_Key, CurrentDevice.FriendlyName);
  GuessModel(CurrentDevice.FriendlyName);

  case (BgDevice.ItemIndex) of
    0: SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefDevTripsFolder_Key, GetDevicePath(FCurrentPath));
    1: SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefDevGpxFolder_Key, GetDevicePath(FCurrentPath));
    2: SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefDevPoiFolder_Key, GetDevicePath(FCurrentPath));
  end;
end;

procedure TFrmTripManager.BtnOpenTempClick(Sender: TObject);
begin
  ShellExecute(0, 'OPEN', PWideChar(CreatedTempPath), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrmTripManager.PostProcessClick(Sender: TObject);
var
  AnItem: TListItem;
  Ext: string;
  CrNormal,CrWait: HCURSOR;
begin
  if FrmPostProcess.ShowModal <> ID_OK then
    exit;

  if (ShellListView1.SelectedFolder = nil) then
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
        DoFunction([Unglitch], ShellListView1.Folders[AnItem.Index].PathName);
    end;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripManager.PostProcessTimerTimer(Sender: TObject);
var
  ProcessModified: TStringList;
  AGpx: string;
begin
  TTimer(Sender).Enabled := false;

  // Stop directory monitor.
  // If not we will get an event when postprocessing.
  DirectoryMonitor.Stop;
  while DirectoryMonitor.Active do
  begin
    Sleep(50);
    ProcessMessages;
  end;

  ProcessModified := TStringList.Create;
  try
    // Copy the modified list
    System.TMonitor.Enter(ModifiedList);
    try
      ProcessModified.Text := ModifiedList.Text;
      ModifiedList.Clear;
    finally
      System.TMonitor.Exit(ModifiedList);
    end;

    // Bring to front by switching FormStyle
    Self.FormStyle := fsStayOnTop;
    Self.FormStyle := fsNormal;

    // PostProcess
    if FrmPostProcess.ShowModal <> ID_OK then
      exit;
    for AGpx in ProcessModified do
      DoFunction([Unglitch], AGpx);

  finally
    ProcessModified.Free;
    DirectoryMonitor.Start;
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
    if (SameText(Parm2, 'false')) then
      LblRoutePoint.Text := Parm1
    else
      LblRoute.Text := Parm1;
    exit;
  end;

  AdjustLatLon(Parm1, Parm2, Coord_Decimals);
  EditMapCoords.Text := Parm1 + ', ' + Parm2;
  if (Msg = OSMCtrlClick) then
  begin
    MapRequest(EditMapCoords.Text, OSMCtrlClick, InitialZoom_Point);
    exit;
  end;

end;

procedure TFrmTripManager.EdgeBrowser1ZoomFactorChanged(Sender: TCustomEdgeBrowser; AZoomFactor: Double);
begin
  EdgeZoom := AZoomFactor;
end;

procedure TFrmTripManager.EditMapCoordsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_Return) and
     (EditMapCoords.Text <> '') then
    MapRequest(EditMapCoords.Text, EditMapCoords.Text, InitialZoom_Out);
end;

procedure TFrmTripManager.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseDevice;
  EdgeBrowser1.CloseBrowserProcess; // Close Edge. Else we can not remove the tempdir.
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, SavedMapPosition_Key, EditMapCoords.Text);
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

  HexEdit := TBCHexEditor.Create(Self);
  HexEdit.Parent := HexPanel;
  HexEdit.Align := alClient;
  HexEdit.OnKeyPress := HexEditKeyPress;

  ShellListView1.DragSource := true;
  ShellListView1.ColumnSorted := true;
  InitSortSpec(LstFiles.Columns[0], true, FSortSpecification);
  ReadSettings;

  EdgeBrowser1.UserDataFolder := CreatedTempPath;
  ATripList := TTripList.Create;
  APOIList := TPOIList.Create;

  try
    AFilePath := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefFileSysFolder_Key);
    if (AFilePath <> '') and
       (DirectoryExists(AFilePath)) then
      ShellTreeView1.Path := AFilePath;
  except
    ShellTreeView1.Root := 'rfDesktop';
  end;
  BgDevice.ItemIndex := 0; //Default to GPX
  GetDeviceList;
end;

procedure TFrmTripManager.FormDestroy(Sender: TObject);
begin
  if (DirectoryMonitor.Active) then
    DirectoryMonitor.Stop;
  DirectoryMonitor.Free;
  ModifiedList.Free;

  FreeDevices;
  ATripList.Free;
  APOIList.Free;
  ClearTripInfo;
end;

procedure TFrmTripManager.FormShow(Sender: TObject);
begin
  PageControl1.ActivePageIndex := 0;
  PctHexOsm.ActivePageIndex := 1;
end;

procedure TFrmTripManager.FreeCustomData(const ACustomData: pointer);
begin
  if (Assigned(ACustomData)) then
    TMTP_Device(ACustomData).Free;
end;

procedure TFrmTripManager.FreeDevices;
var Indx: integer;
begin
  if (Assigned(DeviceList)) then
  begin
    for Indx := 0 to DeviceList.Count - 1 do
      FreeCustomData(DeviceList[Indx]);
    FreeAndNil(DeviceList);
  end;
  CmbDevices.Items.Clear;
end;

procedure TFrmTripManager.GetDeviceList;
var Indx: integer;
begin
  FreeDevices;
  LstFiles.Clear;
  CmbDevices.Text := SelectMTPDevice;
  DeviceList := GetDevices;
  for Indx := 0 to DeviceList.Count - 1 do
  begin
    CmbDevices.Items.Add(TMTP_Device(DeviceList[Indx]).FriendlyName + ' (' + TMTP_Device(DeviceList[Indx]).Description + ')');

    // Does this device match our registry setting? Select right away
    if (PrefDevice = TMTP_Device(DeviceList[Indx]).FriendlyName) then
    begin
      CmbDevices.ItemIndex := Indx;
      SelectDevice(Indx);

      // Get files
      ListFiles;
    end;
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
  CurrentDevice.PortableDev := nil;
  if not ConnectToDevice(CurrentDevice.Device, CurrentDevice.PortableDev, false) then
    raise exception.Create(Format('Device %s could not be opened.', [CurrentDevice.FriendlyName]));

  // Guess model from FriendlyName
  GuessModel(CurrentDevice.FriendlyName);

  // Need to set the folder?
  if (DeviceFolder[BgDevice.ItemIndex] <> '') then
    SetCurrentPath(DeviceFolder[BgDevice.ItemIndex]);
end;

procedure TFrmTripManager.CmbDevicesChange(Sender: TObject);
begin
  if (CmbDevices.ItemIndex > -1) and
     (CmbDevices.ItemIndex < CmbDevices.Items.Count) then
  begin
    SelectDevice(CmbDevices.ItemIndex);

    ListFiles;
  end;
end;

function TFrmTripManager.GetDevicePath(const CompletePath: string): string;
var P: integer;
begin
  result := CompletePath;
  P := Pos('\', result);
  if (P > 1) then
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

  ADateTime := TmArrival.CardinalAsDateTime(Arrival.AsUnixDateTime);
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
        Arrival.AsUnixDateTime := TmArrival.DateTimeAsCardinal(ADateTime);
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
begin
  BtnTransferToDevice.Enabled := false;
  BtnAddToMap.Enabled :=  false;
  BtnPostProcess.Enabled := false;
  BtnCreateAdditional.Enabled := false;

  if (ShellListView1.SelectedFolder = nil) then
    exit;

  Ext := ExtractFileExt(ShellListView1.SelectedFolder.PathName);
  BtnPostProcess.Enabled := ContainsText(Ext, GpxExtension) and
                         not (ShellListView1.SelectedFolder.IsFolder);
  BtnCreateAdditional.Enabled := BtnPostProcess.Enabled;
  BtnTransferToDevice.Enabled := BtnPostProcess.Enabled;
  BtnAddToMap.Enabled := BtnPostProcess.Enabled and
                         (ShellListView1.SelCount = 1);

  if (ContainsText(Ext, TripExtension)) then
    LoadTripFile(ShellListView1.SelectedFolder.PathName, false);
  if (ContainsText(Ext, GPIExtension)) then
    LoadGPiFile(ShellListView1.SelectedFolder.PathName, false);
end;

procedure TFrmTripManager.ShellListView1ColumnClick(Sender: TObject; Column: TListColumn);
begin
  ShellListView1.ColumnClick(Column);
end;

procedure TFrmTripManager.ShellListView1DblClick(Sender: TObject);
begin
  if (ShellListView1.SelectedFolder = nil) then
    exit;
  if (ShellListView1.SelectedFolder.IsFolder) then
    ShellTreeView1.Path := ShellListView1.SelectedFolder.PathName
  else
    ShellExecute(0, 'OPEN', PWideChar(ShellListView1.SelectedFolder.PathName), '' ,'', SW_SHOWNORMAL);
end;

procedure TFrmTripManager.ShellListView1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssCtrl in Shift) and
     (Key = Ord('A')) then
    ShellListView1.SelectAll;
  ShellListView1Click(Sender);
end;

procedure TFrmTripManager.ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if (Self.Showing) then
    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefFileSysFolder_Key, ShellTreeView1.Path);
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
  MapRequest(GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, SavedMapPosition_Key, DefaultCoordinates), '', InitialZoom_Saved);
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
      EnableBalloon := false;
      EnableTimeout := false;
      DoFunction([CreateOSMPoints], ShellListView1.SelectedFolder.PathName, OsmTrack);
      OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s%s',
                                              [App_Prefix,
                                              FileSysTrip,
                                              ExtractFileName(ShellListView1.SelectedFolder.PathName),
                                              GetTracksExt]));
    end;
    ShowPointsOnMap(EdgeBrowser1);
  finally
    OsmTrack.Free;
  end;
end;

procedure TFrmTripManager.LoadTripOnMap(CurrentTrip: TTripList; Id: string);
var
  OsmTrack: TStringList;
begin
  if not Assigned(CurrentTrip) then
    exit;
  OsmTrack := TStringList.Create;
  try
    CurrentTrip.CreateOSMPoints(OsmTrack);
    OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s', [App_Prefix, Id, GetTracksExt]));
    ShowPointsOnMap(EdgeBrowser1);
  finally
    OsmTrack.Free;
  end;
end;

procedure TFrmTripManager.LoadGpiOnMap(CurrentGpi: TPOIList; Id: string);
var
  OsmTrack: TStringList;
  AGPXwayPoint: TGPXWayPoint;
  Cnt: integer;
begin
  if not Assigned(CurrentGpi) then
    exit;

  OsmTrack := TStringList.Create;
  try
    Cnt := 0;
    for AGPXwayPoint in CurrentGpi do
    begin
      OsmTrack.Add(Format('AddPOI(%d, "%s", %s, %s, "./%s.png");',
                          [Cnt, EscapeDQuote(string(AGPXwayPoint.Name)), AGPXwayPoint.Lat, AGPXwayPoint.Lon, AGPXwayPoint.Symbol] ));
	  Inc(Cnt);	
    end;
    OsmTrack.SaveToFile(GetOSMTemp + Format('\%s_%s%s', [App_Prefix, Id, GetTracksExt]));
    ShowPointsOnMap(EdgeBrowser1);
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
    DirectoryMonitor.Active := ChkWatch.Checked;
  if (DirectoryMonitor.Active) then
    ShellListView1.ClearSelection;
end;

procedure TFrmTripManager.ClearSelHexEdit;
begin
  // Default no selection
  HexEdit.SelStart := 0;
  HexEdit.SelEnd := -1;
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

  procedure AddLocation(ALocation: TLocation; ZoomToPoint: boolean);
  var
    ANitem: TBaseItem;
    LocationName, GpsCoords: string;
  begin
    // Scan for Location Name and Coords
    LocationName := '';
    for ANitem in ALocation.LocationItems do
    begin
      if (ANitem is TmName) then
        LocationName := TmName(ANitem).AsString;
      if (ANitem is TmScPosn) then
        GpsCoords := TmScPosn(ANitem).MapCoords;
    end;
    if (ZoomToPoint) then
      MapRequest(GpsCoords, LocationName, InitialZoom_Point);

    with ALocation do
    begin
      VlTripInfo.Strings.AddPair('*** Begin location header', LocationName,
                                 TGridSelItem.Create(ALocation));

      VlTripInfo.Strings.AddPair('ID', string(LocationValue.Id),
                                 TGridSelItem.Create(ALocation, SizeOf(LocationValue.ID), OffsetInRecord(LocationValue, LocationValue.ID) ));

      VlTripInfo.Strings.AddPair('Size', Format('%d', [LocationValue.Size]),
                                 TGridSelItem.Create(ALocation, SizeOf(LocationValue.Size), OffsetInRecord(LocationValue, LocationValue.Size) ));

      VlTripInfo.Strings.AddPair('DataType', Format('%d', [LocationValue.DataType]),
                                 TGridSelItem.Create(ALocation, SizeOf(LocationValue.DataType), OffsetInRecord(LocationValue, LocationValue.DataType) ));

      VlTripInfo.Strings.AddPair('Count', Format('%d', [LocationValue.Count]),
                                 TGridSelItem.Create(ALocation, SizeOf(LocationValue.Count), OffsetInRecord(LocationValue, LocationValue.Count) ));

      VlTripInfo.Strings.AddPair('--- End location header', DupeString('-', DupeCount),
                                 TGridSelItem.Create(ALocation, 1, ALocation.SelEnd - ALocation.SelStart -1 ));
    end;
    for ANitem in ALocation.LocationItems do
    begin
      if (ANitem is TBaseDataItem) then
      begin
        AddBaseData(TBaseDataItem(ANitem));
        continue;
      end;
    end;
    with ALocation do
      VlTripInfo.Strings.AddPair('--- End location', DupeString('-', DupeCount),
                                 TGridSelItem.Create(ALocation, 1,
                                                     SizeOf(LocationValue.Id) + SizeOf(LocationValue.Size) + LocationValue.Size -1) );
  end;

  procedure AddLocations(AmLocations: TmLocations);
  var
    ANitem: TBaseItem;
    GridSelStart: integer;
  begin
    with AmLocations do
    begin
      GridSelStart := 0;
      VlTripInfo.Strings.AddPair('*** Begin mLocations', DupeString('-', DupeCount),
                                 TGridSelItem.Create(AmLocations,
                                                     SizeOf(biInitiator) +  SizeOf(LenName) +  LenName + SizeOf(LenValue) +
                                                     SizeOf(DataType) + SizeOf(LocationCount),
                                                     GridSelStart ));
      GridSelStart := GridSelStart + SizeOf(biInitiator) + SizeOf(LenName) + integer(LenName);
      VlTripInfo.Strings.AddPair('Size', Format('Size: %d', [LenValue]),
                                 TGridSelItem.Create(AmLocations, SizeOf(LenValue), GridSelStart));

      GridSelStart := GridSelStart + SizeOf(LenValue);
      VlTripInfo.Strings.AddPair('DataType', Format('%d', [DataType]),
                                 TGridSelItem.Create(AmLocations, SizeOf(DataType), GridSelStart));

      GridSelStart := GridSelStart + SizeOf(DataType);
      VlTripInfo.Strings.AddPair('LocationCount', Format('%d', [LocationCount]),
                                 TGridSelItem.Create(AmLocations, SizeOf(LocationCount), GridSelStart));
    end;

    for ANitem in AmLocations.Locations do
    begin
      if (ANitem is TLocation) then
      begin
        AddLocation(TLocation(ANitem), false);
        continue;
      end;
    end;
    VlTripInfo.Strings.AddPair('--- End locations', DupeString('-', DupeCount),
                               TGridSelItem.Create(AmLocations, 1, AmLocations.SelEnd - AmLocations.SelStart -1));
  end;

  procedure AddUdbDir(AnUdbDir: TUdbDir; ZoomToPoint: boolean);
  begin
    VlTripInfo.Strings.AddPair(AnUdbDir.DisplayName, Format('MapSegment: %s RoadId: %s PointType: %d Lat: %1.5f Lon: %1.5f',
                                 [IntToHex(AnUdbDir.UdbDirValue.SubClass.MapSegment, 8),
                                  IntToHex(AnUdbDir.UdbDirValue.SubClass.RoadId, 8),
                                  AnUdbDir.UdbDirValue.SubClass.PointType,
                                  AnUdbDir.Lat,
                                  AnUdbDir.Lon]),
                               TGridSelItem.Create(AnUdbDir));
    if (ZoomToPoint) then
      MapRequest(AnUdbDir.MapCoords,
                 Format('%s Type:%d', [AnUdbDir.DisplayName,
                                       AnUdbDir.UdbDirValue.SubClass.PointType]),
                 InitialZoom_Point);
  end;


  procedure AddUdbHandle(AnUdbhandle: TmUdbDataHndl);
  var
    ANitem: TBaseItem;
    GridSelStart: integer;
  begin
    GridSelStart := - SizeOf(AnUdbhandle.PrefValue);
    VlTripInfo.Strings.AddPair('*** Begin UdbPrefix', DupeString('-', DupeCount),
                               TGridSelItem.Create(AnUdbhandle, SizeOf(AnUdbhandle.PrefValue), GridSelStart));

    VlTripInfo.Strings.AddPair('Unknown', Format('0x%s', [IntToHex(AnUdbhandle.PrefValue.Unknown1)]),
                               TGridSelItem.Create(AnUdbhandle, SizeOf(AnUdbhandle.PrefValue.Unknown1), GridSelStart));

    GridSelStart := GridSelStart + SizeOf(AnUdbhandle.PrefValue.Unknown1);
    VlTripInfo.Strings.AddPair('PrefixSize', Format('%d', [AnUdbhandle.PrefValue.PrefixSize]),
                               TGridSelItem.Create(AnUdbhandle, SizeOf(AnUdbhandle.PrefValue.PrefixSize), GridSelStart));

    GridSelStart := GridSelStart + SizeOf(AnUdbhandle.PrefValue.PrefixSize);
    VlTripInfo.Strings.AddPair('DataType', Format('%d', [AnUdbhandle.PrefValue.DataType]),
                               TGridSelItem.Create(AnUdbhandle, SizeOf(AnUdbhandle.PrefValue.DataType), GridSelStart));

    GridSelStart := GridSelStart + SizeOf(AnUdbhandle.PrefValue.DataType);
    VlTripInfo.Strings.AddPair('HandleId', Format('%d', [AnUdbhandle.PrefValue.PrefId]),
                               TGridSelItem.Create(AnUdbhandle, SizeOf(AnUdbhandle.PrefValue.PrefId), GridSelStart));

    GridSelStart := 0;
    VlTripInfo.Strings.AddPair('*** Begin UdbHandle', DupeString('-', DupeCount),
                               TGridSelItem.Create(AnUdbhandle,
                                                    SizeOf(AnUdbhandle.LenName) + AnUdbhandle.LenName +
                                                    SizeOf(AnUdbhandle.LenValue) + SizeOf(AnUdbhandle.DataType), GridSelStart));

    GridSelStart := GridSelStart + SizeOf(biInitiator) + SizeOf(AnUdbhandle.LenName) + integer(AnUdbhandle.LenName);

    VlTripInfo.Strings.AddPair('Size', Format('%d', [AnUdbhandle.LenValue]),
                               TGridSelItem.Create(AnUdbhandle,
                                                    SizeOf(AnUdbhandle.LenValue), GridSelStart));
    GridSelStart := GridSelStart + SizeOf(AnUdbhandle.LenValue);

    VlTripInfo.Strings.AddPair('DataType', Format('%d', [AnUdbhandle.DataType]),
                               TGridSelItem.Create(AnUdbhandle,
                                                    SizeOf(AnUdbhandle.DataType), GridSelStart));

    GridSelStart := GridSelStart + SizeOf(AnUdbhandle.DataType);
    VlTripInfo.Strings.AddPair('UdbHandleSize', Format('%d', [AnUdbhandle.UdbHandleValue.UdbHandleSize]),
                               TGridSelItem.Create(AnUdbhandle,
                                                    SizeOf(AnUdbhandle.UdbHandleValue.UdbHandleSize), GridSelStart));

    GridSelStart := GridSelStart + SizeOf(AnUdbhandle.UdbHandleValue.UdbHandleSize);
    VlTripInfo.Strings.AddPair('Calculation status', Format('0x%s (0x0538FEFF=XT 0x05d8FEFF=XT2)', [IntToHex(AnUdbhandle.UdbHandleValue.CalcStatus, 8)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                    SizeOf(AnUdbhandle.UdbHandleValue.CalcStatus), GridSelStart));

    GridSelStart := GridSelStart + SizeOf(AnUdbhandle.UdbHandleValue.CalcStatus);
    VlTripInfo.Strings.AddPair('Unknown2', '150 bytes',
                               TGridSelItem.Create(AnUdbhandle,
                                                    SizeOf(AnUdbhandle.UdbHandleValue.Unknown2), GridSelStart));

    GridSelStart := GridSelStart + SizeOf(AnUdbhandle.UdbHandleValue.Unknown2);
    VlTripInfo.Strings.AddPair('UdbDir count', Format('%d', [AnUdbhandle.UdbHandleValue.UDbDirCount]),
                               TGridSelItem.Create(AnUdbhandle,
                                                    SizeOf(AnUdbhandle.UdbHandleValue.UDbDirCount), GridSelStart));

    GridSelStart := GridSelStart + SizeOf(AnUdbhandle.UdbHandleValue.UDbDirCount);
    VlTripInfo.Strings.AddPair('Unknown3', Format('%d bytes', [Length(AnUdbhandle.UdbHandleValue.Unknown3)]),
                               TGridSelItem.Create(AnUdbhandle,
                                                    Length(AnUdbhandle.UdbHandleValue.Unknown3), GridSelStart));

    for ANitem in AnUdbhandle.Items do
    begin
      if (ANitem is TUdbDir) then
        AddUdbDir(TUdbDir(ANitem), false);
    end;
    VlTripInfo.Strings.AddPair('--- End UdbHandle', DupeString('-', DupeCount),
                               TGridSelItem.Create(AnUdbhandle, 1, AnUdbhandle.SelEnd - AnUdbhandle.SelStart -1));
  end;

  procedure AddAllRoutes(AmAllRoutes: TmAllRoutes);
  var
    ANitem: TBaseItem;
    GridSelStart: integer;
  begin
    GridSelStart := 0;
    VlTripInfo.Strings.AddPair('*** Begin AllRoutes', DupeString('-', DupeCount),
                               TGridSelItem.Create(AmAllRoutes));

    GridSelStart := GridSelStart + SizeOf(biInitiator) + SizeOf(AmAllRoutes.LenName) + integer(AmAllRoutes.LenName);
    VlTripInfo.Strings.AddPair('Size', Format('%d', [AmAllRoutes.LenValue]),
                               TGridSelItem.Create(AmAllRoutes,
                                                   SizeOf(AmAllRoutes.LenValue),
                                                   GridSelStart ));

    GridSelStart := GridSelStart + SizeOf(AmAllRoutes.LenValue);
    VlTripInfo.Strings.AddPair('DataType', Format('%d', [AmAllRoutes.DataType]),
                               TGridSelItem.Create(AmAllRoutes,
                                                   SizeOf(AmAllRoutes.DataType),
                                                   GridSelStart ));

    GridSelStart := GridSelStart + SizeOf(AmAllRoutes.DataType);
    VlTripInfo.Strings.AddPair('UdbHandleCount', Format('%d', [AmAllRoutes.AllRoutesValue.UdbHandleCount]),
                               TGridSelItem.Create(AmAllRoutes,
                                                   SizeOf(AmAllRoutes.AllRoutesValue.UdbHandleCount),
                                                   GridSelStart ));

    for ANitem in AmAllRoutes.Items do
    begin
      if (ANitem is TmUdbDataHndl) then
      begin
        AddUdbHandle(TmUdbDataHndl(ANitem));
        continue;
      end;
    end;
    VlTripInfo.Strings.AddPair('--- End AllRoutes', DupeString('-', DupeCount),
                               TGridSelItem.Create(AmAllRoutes, 1, AmAllRoutes.SelEnd - AmAllRoutes.SelStart -1));
  end;

  procedure AddHeader(AHeader: Theader);
  var
    HeaderValue: THeaderValue;
  begin
    HeaderValue := AHeader.HeaderValue;
    with HeaderValue do
    begin
      VlTripInfo.Strings.AddPair('*** Begin Trip header', DupeString('-', DupeCount),
                                 TGridSelItem.Create(AHeader));
      VlTripInfo.Strings.AddPair('ID', string(ID),
                                 TGridSelItem.Create(AHeader, SizeOf(ID)));
      VlTripInfo.Strings.AddPair('SubLength',     Format('%d', [SubLength]),
                                 TGridSelItem.Create(AHeader, SizeOf(SubLength), OffsetInRecord(HeaderValue, SubLength) ));
      VlTripInfo.Strings.AddPair('HeaderLength',  Format('%d', [HeaderLength]),
                                 TGridSelItem.Create(AHeader, SizeOf(HeaderLength), OffsetInRecord(HeaderValue, HeaderLength) ));
      VlTripInfo.Strings.AddPair('TotalItems',    Format('%d', [TotalItems]),
                                 TGridSelItem.Create(AHeader, SizeOf(TotalItems), OffsetInRecord(HeaderValue, TotalItems) ));
      VlTripInfo.Strings.AddPair('--- End Trip header', DupeString('-', DupeCount),
                                 TGridSelItem.Create(AHeader, 1, AHeader.SelStart + SizeOf(HeaderValue) -1 ));
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
                 Format('%s', [AGPXWayPoint.Name]),
                 InitialZoom_Point);

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
     (TObject(Node.Data) is TUdbDir) and
     ( (TUdbDir(Node.Data).UdbDirValue.SubClass.PointType = $3) or
       (TUdbDir(Node.Data).IsTurn) )  then
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsBold];
end;

procedure TFrmTripManager.ValueListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = Ord('C')) and
     (ssCtrl in Shift) then
    with TValueListEditor(Sender) do
      Clipboard.AsText := Cells[Col, Row];
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

  if (ABaseDataItem is TmScPosn) then
    ShowMessage('Position Map and click on ''Apply Coordinates''.' + #10 +
                'Tip: Use Ctrl + Click on Map to get precise coordinates')
  else if (ABaseDataItem is TmArrival) then
  begin
    ADateTime := TmArrival.CardinalAsDateTime(TmArrival(ABaseDataItem).AsUnixDateTime);
    with TFrmDateDialog.Create(nil) do
    begin
      DtPicker.DateTime := ADateTime;
      Rc := ShowModal;
      ADateTime := DtPicker.DateTime;
      Free;
    end;
    if Rc = ID_OK then
    begin
      TmArrival(ABaseDataItem).AsUnixDateTime := TmArrival.DateTimeAsCardinal(ADateTime);
      BtnSaveTripValues.Enabled := true;
    end;
  end;
end;

procedure TFrmTripManager.HexEditKeyPress(Sender: TObject; var Key: Char);
begin
  BtnSaveTripGpiFile.Enabled := true;
end;

procedure TFrmTripManager.VlTripInfoSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  AGridSel: TGridSelItem;
begin
  BtnApplyCoords.Enabled := false;
  AGridSel := TGridSelItem.GridSelItem(TValueListEditor(Sender), ARow -1);
  if not Assigned(AGridSel) then
    exit;

  SyncHexEdit(AGridSel);

  BtnApplyCoords.Enabled := TGridSelItem.BaseDataItem(TValueListEditor(Sender), ARow -1) is TmScPosn;
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

procedure TFrmTripManager.DeviceMenuPopup(Sender: TObject);
var AMenuItem: TMenuItem;
begin
  for AMenuItem in TPopupMenu(Sender).Items do
  begin
    AMenuItem.Enabled := (AMenuItem.GroupIndex = 1) or
                         ((AMenuItem.GroupIndex = 2) and DeviceFile and (BgDevice.ItemIndex = 0));
  end;
end;

procedure TFrmTripManager.Delete1Click(Sender: TObject);
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

  // Count Selected files, excluding folders
  SelCount := 0;
  for ANitem in LstFiles.Items do
  begin
    if not (ANitem.Selected) then
      continue;
    ABase_Data := TBASE_Data(ANitem.Data);
    if (ABase_Data.IsFolder) then
      continue;
    UnSafeExt := not ( (ContainsText(ANitem.SubItems[2], GpxExtension)) or
                       (ContainsText(ANitem.SubItems[2], TripExtension)) or
                       (ContainsText(ANitem.SubItems[2], GPIExtension))
                     );
    UnlockFiles := UnlockFiles or
       (GetIdForFile(CurrentDevice.PortableDev, FSavedFolderId, ChangeFileExt(ANitem.Caption, '.' + UnlExtension) ) <> '');

    Inc(SelCount);
  end;

  if UnlockFiles and (MessageDlg('Selected files have unlock files and are unsafe to delete. Continue?',
                 TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> ID_OK) then
    exit;

  if UnSafeExt and (MessageDlg('Selected files have extensions that are unsafe to delete. Continue?',
                 TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> ID_OK) then
    exit;

  if (MessageDlg(Format('%d Files will be deleted from %s.', [SelCount, CurrentDevice.FriendlyName]),
                 TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0) <> ID_OK) then
    exit;

  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    for ANitem in LstFiles.Items do
    begin
      if not (ANitem.Selected) then
        continue;
      ABase_Data := TBASE_Data(ANitem.Data);
      if (ABase_Data.IsFolder) then
        continue;

      DelFileFromDevice(CurrentDevice.PortableDev, ABase_Data.ObjectId);
    end;
    ReloadFileList;
  finally
    SetCursor(CrNormal);
  end;
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
        AnItem.Caption := TripFilename;
        RenameObject(CurrentDevice.PortableDev, ABase_Data.ObjectId, AnItem.Caption);
        TripFilename := CopyFileToTmp(AnItem);

        // reload trip, and change mFilename
        TmpTripList.LoadFromFile(TripFilename);
        TmFileName (TmpTripList.GetItem('mFileName')).AsString := Format('0:/.System/Trips/%s.trip', [TripName]);
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
    ParentId := TmArrival.DateTimeAsCardinal(Now);
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
var ABASE_Data: TBASE_Data;
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

    // LstFile.Items should contain a least a Caption (Filename) and 4 subitems Date, Time, Ext and Size.
    // ReadFilesFromDevice will populate the data.
    // It returns the Parent ObjectId, we save it to be able to navigate to the parent directory.
    // Defined in the Listview on the form.
    FSavedParent := ReadFilesFromDevice(CurrentDevice.PortableDev, LstFiles.Items, SParent, FCurrentPath);

    // Save Device and folder info
    DeviceFolder[BgDevice.ItemIndex] := GetDevicePath(FCurrentPath);
    EdDeviceFolder.Text := CurrentDevice.FriendlyName + '\' + DeviceFolder[BgDevice.ItemIndex];

    DoListViewSort(LstFiles, LstFiles.Columns[0], true, FSortSpecification);

    case BgDevice.ItemIndex of
      0: CheckTrips;
// Future use
    end;
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
  FreeCustomData(Item.Data);
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

procedure TFrmTripManager.MapRequest(const Coords, Desc, Zoom: string);
begin
  FMapReq.Coords := Coords;
  FMapReq.Desc := Desc;
  FMapReq.Zoom := Zoom;
  MapTimer.Enabled := false;
  MapTimer.Enabled := true;
end;

procedure TFrmTripManager.MapTimerTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  MapGoToPlace(EdgeBrowser1, FMapReq.Coords, FMapReq.Desc, FMapReq.Zoom);
end;

procedure TFrmTripManager.CreateAdditionalClick(Sender: TObject);
var
  AnItem: TListItem;
  Ext: string;
  CrNormal,CrWait: HCURSOR;
begin
  if (ShellListView1.SelectedFolder = nil) then
    exit;
  if FrmAdditional.ShowModal <> ID_OK then
    exit;

  CrWait := LoadCursor(0,IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    ForceOutDir := '';
    ZumoModel := TZumoModel(CmbModel.ItemIndex);
    CheckSupportedModel;

    for AnItem in ShellListView1.Items do
    begin
      if (AnItem.Selected = false) then
        continue;
      if (ShellListView1.Folders[AnItem.Index].IsFolder) then
        continue;
      Ext := ExtractFileExt(ShellListView1.Folders[AnItem.Index].PathName);
      if (ContainsText(Ext, GpxExtension)) then
        DoFunction(FrmAdditional.Funcs, ShellListView1.Folders[AnItem.Index].PathName);
    end;

  finally
    SetCursor(CrNormal);
  end;
  BtnRefreshFileSysClick(Sender);
end;

procedure TFrmTripManager.LoadHex(const FileName: string);
begin
  HexEdit.LoadFromFile(FileName);
  BtnSaveTripGpiFile.Enabled := true;
end;

procedure TFrmTripManager.LoadTripFile(const FileName: string; const FromDevice: boolean);
var
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
  TsTripGpiInfo.Caption := 'Trip info';

  AStream := TBufferedFileStream.Create(FileName, fmOpenRead);
  ATripList.Clear;
  TvTrip.LockDrawing;
  TvTrip.items.BeginUpdate;
  TvTrip.Items.Clear;
  VlTripInfo.Strings.BeginUpdate;
  ClearTripInfo;
  DeviceFile := FromDevice;
  HexEditFile := FileName;

  try
    if not ATripList.LoadFromStream(AStream) then
      raise Exception.Create('Not a valid trip file');
//TODO do calculations in InitFromStream, so we dont need to save to stream to get the sizes
    MemStream := TMemoryStream.Create;
    try
      ATripList.SaveToStream(MemStream);
    finally
      MemStream.Free;
    end;

    RootNode := TvTrip.Items.AddObject(nil, ExtractFileName(FileName), ATripList);
    TvTrip.ShowRoot := true;

    TvTrip.Items.AddChildObject(RootNode, ATripList.Header.ClassName, ATripList.Header);

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
    RootNode.Expand(false);
  finally
    TvTrip.Items.EndUpdate;
    TvTrip.UnlockDrawing;
    VlTripInfo.Strings.EndUpdate;
    AStream.Free;
  end;
  LoadHex(FileName);
  LoadTripOnMap(ATripList, CurrentTrip);
  RootNode.Selected := true;
  BtnSaveTripValues.Enabled := false;
  BtnSaveTripGpiFile.Enabled := false;
end;

procedure TFrmTripManager.LoadGpiFile(const FileName: string; const FromDevice: boolean);
var
  AStream: TBufferedFileStream;
  AGPXWayPoint: TGPXWayPoint;
  RootNode: TTreeNode;
  GPIRec: TGPI;

begin
  TsTripGpiInfo.Caption := 'POI(gpi) info';
  AStream := TBufferedFileStream.Create(FileName, fmOpenRead);

  TvTrip.LockDrawing;
  TvTrip.items.BeginUpdate;
  TvTrip.Items.Clear;
  VlTripInfo.Strings.BeginUpdate;
  ClearTripInfo;
  DeviceFile := FromDevice;
  HexEditFile := FileName;

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

    // Set Check mark
    SetCheckMark(AListItem, not TBooleanItem(TmpTripList.GetItem('mImported')).AsBoolean);

  finally
    TmpTripList.Free;
  end;
end;

procedure TFrmTripManager.SetImported(const AListItem: TListItem; const NewValue: boolean);
var
  TmpTripList: TTripList;
  LocalFile: string;
begin
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

    SetCheckMark(AListItem, not NewValue);
  finally
    TmpTripList.Free;
  end;
end;

procedure TFrmTripManager.SetFixedPrefs;
var
  ProcessWpt: boolean;
  WayPtCat: integer;
  WayPtList: TStringList;
begin
  EnableBalloon := false;
  EnableTimeout := false;
  TimeOut := 0;
  MaxTries := 0;
  DebugComments := 'False';

  KMLTrackColor := '';
  OSMTrackColor := 'Magenta';
  GpiSymbolsDir := Utf8String(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)))) + 'Symbols\80x80\';
  IniProximityStr := '500';

  WayPtList := TStringList.Create;
  try
    WayPtList.Text := ProcessCategoryPick;
    ProcessWpt := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessWpt', BooleanValues[true]) = BooleanValues[true]);
    WayPtCat := WayPtList.IndexOf(GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessCategory', WayPtList[WayPtList.Count -1]));
    ProcessCategory := [];
    if (ProcessWpt) then
    begin
      case WayPtCat of
        1: Include(ProcessCategory, pcSymbol);
        2: Include(ProcessCategory, pcGPX);
        3: begin
             Include(ProcessCategory, pcSymbol);
             Include(ProcessCategory, pcGPX);
            end;
      end;
    end;
  finally
    WayPtList.Free;
  end;
end;


procedure TFrmTripManager.ReadSettings;
begin
  PrefDevice := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefDev_Key, 'zūmo XT');
  GuessModel(PrefDevice);
  DeviceFolder[0] := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefDevTripsFolder_Key, 'Internal Storage\.System\Trips');
  DeviceFolder[1] := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefDevGpxFolder_Key, 'Internal Storage\GPX');
  DeviceFolder[2] := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, PrefDevPoiFolder_Key, 'Internal Storage\POI');
  WarnModel := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, WarnModel_Key, 'True') = 'True');
  WarnRecalc := mrNone;
  SetFixedPrefs;
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
  if (CheckDevice(false)) then
    BtnTransferToDeviceClick(Self);
end;

procedure TFrmTripManager.DirectoryEvent(Sender: TObject; Action: TDirectoryMonitorAction; const FileName: WideString);
var
  Index: integer;
  Ext: string;
  FileFound: boolean;
begin
  Ext := ExtractFileExt(Filename);
  if not (ContainsText(Ext, GpxExtension)) then
    exit;

  System.TMonitor.Enter(ModifiedList);
  try
    ModifiedList.Add(IncludeTrailingPathDelimiter(DirectoryMonitor.Directory) + FileName);
  finally
    System.TMonitor.Exit(ModifiedList);
  end;

  FileFound := false;
  for Index := 0 to ShellListView1.Items.Count -1 do
  begin
    if (ShellListView1.Folders[Index].IsFolder) then
      continue;

    if SameText(FileName, ExtractFileName(ShellListView1.Folders[Index].PathName)) then
    begin
      ShellListView1.Items[Index].Selected := true;
      FileFound := true;
    end;
  end;
  if (FileFound = false) then
    ShellListView1.Refresh;

  PostProcessTimer.Enabled := false;
  PostProcessTimer.Enabled := true;
end;

end.

