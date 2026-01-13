unit UFrmTripEditor;

interface

uses
  System.Classes,
  Winapi.Windows, Winapi.Messages,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Buttons, Vcl.Controls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.DBCtrls,
  Vcl.Mask, Vcl.Menus, Vcl.ToolWin, Vcl.BaseImageCollection, Vcl.ImageCollection, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids,
  Data.DB,
  TripManager_DBGrid,
  UnitTripDefs;

type

  TTripFileUpdate = TNotifyEvent;
  TRoutePointsShowing = procedure(Sender: TObject; Showing: boolean) of object;

  TFrmTripEditor = class(TForm)
    PnlBottom: TPanel;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    DBGRoutePoints: TripManager_DBGrid.TDBGrid;
    PnlRoute: TPanel;
    DbTripName: TDBEdit;
    DBCRoutePreference: TDBComboBox;
    DBCTransportationMode: TDBComboBox;
    DTDepartureDate: TDateTimePicker;
    GrpRoute: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CmbModel: TComboBox;
    PopupGrid: TPopupMenu;
    MoveUp1: TMenuItem;
    MoveDown1: TMenuItem;
    N1: TMenuItem;
    Insert1: TMenuItem;
    Delete1: TMenuItem;
    TBBRoutePoints: TToolBar;
    TbMoveUp: TToolButton;
    TbInsertPoint: TToolButton;
    TbDeletePoint: TToolButton;
    TBMoveDown: TToolButton;
    VirtImgListRoutePoints: TVirtualImageList;
    ImgColRoutePoints: TImageCollection;
    PnlRoutePointsButtons: TPanel;
    PnlFiller: TPanel;
    TbLookupAddress: TToolButton;
    Selectall1: TMenuItem;
    N2: TMenuItem;
    SaveTrip: TSaveDialog;
    TBGPXExp_Imp: TToolButton;
    PopupGPX: TPopupMenu;
    ImportGPX: TMenuItem;
    OpenTrip: TOpenDialog;
    N3: TMenuItem;
    Copy1: TMenuItem;
    Cut1: TMenuItem;
    Paste1: TMenuItem;
    TBCSVExp_Imp: TToolButton;
    PopupCSV: TPopupMenu;
    ImportCSV: TMenuItem;
    ExportCSV: TMenuItem;
    Trk2RtImport1: TMenuItem;
    TbBrowser: TToolButton;
    procedure BtnOkClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure MoveUp1Click(Sender: TObject);
    procedure MoveDown1Click(Sender: TObject);
    procedure Insert1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGRoutePointsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TbInsertPointClick(Sender: TObject);
    procedure TbDeletePointClick(Sender: TObject);
    procedure TbMoveUpClick(Sender: TObject);
    procedure TBMoveDownClick(Sender: TObject);
    procedure TbLookupAddressClick(Sender: TObject);
    procedure Selectall1Click(Sender: TObject);
    procedure ExportGpxClick(Sender: TObject);
    procedure ImportGPXClick(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure PnlRouteResize(Sender: TObject);
    procedure ImportCSVClick(Sender: TObject);
    procedure ExportCSVClick(Sender: TObject);
    procedure Trk2RtImport1Click(Sender: TObject);
    procedure TbBrowserClick(Sender: TObject);
  private
    { Private declarations }
    FTripFileUpdating: TTripFileUpdate;
    FTripFileCanceled: TTripFileUpdate;
    FTripFileUpdated: TTripFileUpdate;
    FRoutePointsShowing: TRoutePointsShowing;
    procedure CopyToClipBoard(Cut: boolean);
    procedure SaveChanges;
  public
    { Public declarations }
    CurPath: string;
    CurTripList: TOBject;
    CurFile: string;
    CurNewFile: boolean;
    CurDevice: boolean;
    CurModel: TTripModel;
    property OnTripFileCanceled: TTripFileUpdate read FTripFileCanceled write FTripFileCanceled;
    property OnTripFileUpdating: TTripFileUpdate read FTripFileUpdating write FTripFileUpdating;
    property OnTripFileUpdated: TTripFileUpdate read FTripFileUpdated write FTripFileUpdated;
    property OnRoutePointsShowing: TRoutePointsShowing read FRoutePointsShowing write FRoutePointsShowing;
  end;

var
  FrmTripEditor: TFrmTripEditor;

implementation

uses
  System.SysUtils, System.Math,
  Winapi.ShellAPI,
  Vcl.Clipbrd,
  UDmRoutePoints, UnitTripObjects, UnitStringUtils, UnitModelConv;

{$R *.dfm}

procedure TFrmTripEditor.BtnCancelClick(Sender: TObject);
begin
// Restore Trip
  if (fsModal in FormState) then
    exit;

  if Assigned(FTripFileCanceled) then
    FTripFileCanceled(Self);

  Close;
end;

procedure TFrmTripEditor.SaveChanges;
begin
  if (DmRoutePoints.CdsRoutePoints.RecordCount < 2) then
    raise Exception.Create('Need at least a begin and end point.');

  if Assigned(FTripFileUpdating) then
    FTripFileUpdating(Self);

  DmRoutePoints.CdsRoute.Edit;
  DmRoutePoints.CdsRouteDepartureDate.AsDateTime := DTDepartureDate.DateTime;
  DmRoutePoints.CdsRoute.Post;

  DmRoutePoints.SaveTrip;
end;

procedure TFrmTripEditor.BtnOkClick(Sender: TObject);
begin
  if (fsModal in FormState) then
    exit;

  SaveChanges;

  if Assigned(FTripFileUpdated) then
    FTripFileUpdated(Self);

  Close;
end;

procedure TFrmTripEditor.CopyToClipBoard(Cut: boolean);
var
  Index: integer;
  MyBook: TBookmark;
  PointsList: TStringList;
begin
  Clipboard.Clear;
  PointsList := TStringList.Create;
  DmRoutePoints.CdsRoutePoints.DisableControls;
  try
    DBGRoutePoints.SelectedRows.CurrentRowSelected := true; // Select at least one row
    for Index := 0 to DBGRoutePoints.SelectedRows.Count -1 do
    begin
      MyBook := DBGRoutePoints.SelectedRows[Index];
      DmRoutePoints.CdsRoutePoints.GotoBookmark(MyBook);
      PointsList.Add(Format('%s%s%s%s%s%s%s%s%s',
                            [DmRoutePoints.CdsRoutePointsName.AsString, #9,
                             DmRoutePoints.CdsRoutePointsViaPoint.AsString, #9,
                             DmRoutePoints.CdsRoutePointsLat.AsString, #9,
                             DmRoutePoints.CdsRoutePointsLon.AsString, #9,
                             DmRoutePoints.CdsRoutePointsAddress.AsString]));
      if (Cut) then
        DmRoutePoints.CdsRoutePoints.Delete;
    end;
    Clipboard.AsText := PointsList.Text;
    DBGRoutePoints.SelectedRows.Clear;
  finally
    DmRoutePoints.CdsRoutePoints.EnableControls;
    if Cut and
       Assigned(DmRoutePoints.OnRouteUpdated) then
      DmRoutePoints.OnRouteUpdated(Self);
    PointsList.Free;
  end;
end;

procedure TFrmTripEditor.Copy1Click(Sender: TObject);
begin
  CopyToClipBoard(false);
end;

procedure TFrmTripEditor.Cut1Click(Sender: TObject);
begin
  CopyToClipBoard(true);
end;

procedure TFrmTripEditor.ImportCSVClick(Sender: TObject);
begin
  OpenTrip.Filter := '*.csv|*.csv';
  OpenTrip.InitialDir := CurPath;
  if not OpenTrip.Execute then
    exit;

  DmRoutePoints.ImportFromCSV(OpenTrip.FileName);
end;

procedure TFrmTripEditor.ImportGPXClick(Sender: TObject);
begin
  OpenTrip.Filter := '*.gpx|*.gpx';
  OpenTrip.InitialDir := CurPath;
  if not OpenTrip.Execute then
    exit;

  DmRoutePoints.ImportFromGPX(OpenTrip.FileName);
end;

procedure TFrmTripEditor.ExportCSVClick(Sender: TObject);
begin
  SaveTrip.Filter := '*.csv|*.csv';
  SaveTrip.InitialDir := CurPath;
  SaveTrip.FileName := ChangeFileExt(ExtractFileName(CurFile), '.csv');
  if not SaveTrip.Execute then
    exit;

  DmRoutePoints.ExportToCSV(SaveTrip.FileName);
end;

procedure TFrmTripEditor.ExportGpxClick(Sender: TObject);
begin
  SaveTrip.Filter := '*.gpx|*.gpx';
  SaveTrip.InitialDir := CurPath;
  SaveTrip.FileName := ChangeFileExt(ExtractFileName(CurFile), '.gpx');
  if not SaveTrip.Execute then
    exit;

  DmRoutePoints.CdsRoute.Edit;
  DmRoutePoints.CdsRouteDepartureDate.AsDateTime := DTDepartureDate.DateTime;
  DmRoutePoints.CdsRoute.Post;

  DmRoutePoints.ExportToGPX(SaveTrip.FileName);
end;

procedure TFrmTripEditor.DBGRoutePointsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NewSelStart: integer;
begin

  if (ssCtrl in Shift) then
  begin
    case Key of
      VK_HOME:
        DmRoutePoints.CdsRoutePoints.First;
      VK_END:
        DmRoutePoints.CdsRoutePoints.Last;
    end;
    exit;
  end;

  case Key of
    VK_DOWN:
      begin
        if (DmRoutePoints.CdsRoutePoints.RecNo = DmRoutePoints.CdsRoutePoints.RecordCount) then
          Key := 0;
      end;
    VK_HOME,
    VK_END,
    VK_INSERT,
    VK_DELETE:
      begin
        if not TDBGrid(Sender).EditorMode then
          TDBGrid(Sender).EditorMode := true;
        if (TDBGrid(Sender).InplaceEditor <> nil) then
        begin
          TDBGrid(Sender).EditorMode := true;
          NewSelStart := 0;
          case Key of
            VK_DELETE:
              begin
                TDBGrid(Sender).InplaceEditor.SelectAll;
                SendMessage(TDBGrid(Sender).InplaceEditor.Handle, WM_CUT, 0 ,0);
              end;
            VK_END:
              NewSelStart := Length(TDBGrid(Sender).InplaceEditor.Text);
          end;
          TDBGrid(Sender).InplaceEditor.SelStart := NewSelStart;
          TDBGrid(Sender).InplaceEditor.SelLength := 0;
          Key := 0;
        end;
      end;
  end;
end;

procedure TFrmTripEditor.FormCreate(Sender: TObject);
begin
  MoveUp1.ShortCut := TextToShortCut('Alt+Up'); // Tshortcut(32806);
  MoveDown1.ShortCut := TextToShortCut('Alt+Down'); //Tshortcut(32808);
end;

procedure TFrmTripEditor.FormHide(Sender: TObject);
begin
  if Assigned(FRoutePointsShowing) then
    FRoutePointsShowing(Self, false);
end;

procedure TFrmTripEditor.FormShow(Sender: TObject);
begin
// Clear treeview to avoid AV's when the TripList's items are deleted
  if Assigned(FTripFileUpdating) then
    FTripFileUpdating(Self);
  if Assigned(FRoutePointsShowing) then
    FRoutePointsShowing(Self, true);

  GrpRoute.Caption := '';
  if (CurDevice) then
    GrpRoute.Caption := 'Device ';
  GrpRoute.Caption := GrpRoute.Caption + ExtractFileName(CurFile);
  DBCRoutePreference.Items.Text := DmRoutePoints.RoutePickList;
  DBCTransportationMode.Items.Text := DmRoutePoints.TransportPickList;
  DmRoutePoints.LoadTrip(CurTripList);
  DTDepartureDate.DateTime := DmRoutePoints.CdsRouteDepartureDate.AsDateTime;
  TModelConv.CmbTripDevices(CmbModel.Items);
  CmbModel.ItemIndex := Ord(TTripList(CurTripList).TripModel);
end;

procedure TFrmTripEditor.Insert1Click(Sender: TObject);
begin
  TbInsertPointClick(Sender);
end;

procedure TFrmTripEditor.Delete1Click(Sender: TObject);
begin
  TbDeletePointClick(Sender);
end;

procedure TFrmTripEditor.MoveDown1Click(Sender: TObject);
begin
  DmRoutePoints.MoveDown(DmRoutePoints.CdsRoutePoints);
end;

procedure TFrmTripEditor.MoveUp1Click(Sender: TObject);
begin
  DmRoutePoints.MoveUp(DmRoutePoints.CdsRoutePoints);
end;

procedure TFrmTripEditor.Paste1Click(Sender: TObject);
var
  PointsList: TStringList;
  PointID, Index: integer;
  ViaShape, ALine: string;
begin
  PointsList := TStringList.Create;
  PointID  := DmRoutePoints.CdsRoutePoints.RecordCount + 1;
  DmRoutePoints.CdsRoutePoints.DisableControls;
  try
    PointsList.Text := Clipboard.AsText;
    for Index := 0 to PointsList.Count -1 do
    begin
      ALine := PointsList[Index];
      DmRoutePoints.CdsRoutePoints.Insert;
      DmRoutePoints.CdsRoutePointsName.AsString := NextField(ALine, #9);
      ViaShape := NextField(ALine, #9);
      DmRoutePoints.CdsRoutePointsLat.AsString := NextField(ALine, #9);
      DmRoutePoints.CdsRoutePointsLon.AsString := NextField(ALine, #9);
      DmRoutePoints.CdsRoutePointsAddress.AsString := NextField(ALine, #9);

      // Allow for missing data
      DmRoutePoints.SetDefaultName(PointID + Index);
      DmRoutePoints.SetBoolValue(ViaShape, DmRoutePoints.CdsRoutePointsViaPoint);
      if (DmRoutePoints.CdsRoutePointsViaPoint.IsNull) then
         DmRoutePoints.CdsRoutePointsViaPoint.AsBoolean := true;

      DmRoutePoints.CdsRoutePoints.Post;
    end;
  finally
    PointsList.Free;
    DmRoutePoints.CdsRoutePoints.EnableControls;
    if Assigned(DmRoutePoints.OnRouteUpdated) then
      DmRoutePoints.OnRouteUpdated(Self);
  end;
end;

procedure TFrmTripEditor.PnlRouteResize(Sender: TObject);
var
  W, X: integer;
begin
  GrpRoute.Width := DBGRoutePoints.Width;
  if (DBGRoutePoints.Columns.Count > 1) then
  begin
    W := 0;
    for X := 0 to DBGRoutePoints.Columns.Count -2 do
      W := W + DBGRoutePoints.Columns[X].Width;
    DBGRoutePoints.Columns[DBGRoutePoints.Columns.Count -1].Width :=
      DBGRoutePoints.ClientWidth - W - GetSystemMetrics(SM_CXVSCROLL) -4;
  end;
end;

procedure TFrmTripEditor.Trk2RtImport1Click(Sender: TObject);
begin
  OpenTrip.Filter := '*.gpx|*.gpx|*.kml|*.kml';
  OpenTrip.InitialDir := CurPath;
  if not OpenTrip.Execute then
    exit;

  DmRoutePoints.Trk2RtImportFromGPX(OpenTrip.FileName, true);
end;

procedure TFrmTripEditor.Selectall1Click(Sender: TObject);
begin
  DmRoutePoints.CdsRoutePoints.DisableControls;
  try
    DmRoutePoints.CdsRoutePoints.First;
    while not DmRoutePoints.CdsRoutePoints.Eof do
    begin
      DBGRoutePoints.SelectedRows.CurrentRowSelected := true;
      DmRoutePoints.CdsRoutePoints.Next;
    end;
  finally
    DmRoutePoints.CdsRoutePoints.EnableControls;
  end;
end;

procedure TFrmTripEditor.TbMoveUpClick(Sender: TObject);
begin
  DBGRoutePoints.SelectedRows.Clear;
  DmRoutePoints.MoveUp(DmRoutePoints.CdsRoutePoints);
end;

procedure TFrmTripEditor.TbBrowserClick(Sender: TObject);
var
  Url: string;
begin
  Url := DmRoutePoints.KurvigerURL;
  ShellExecute(0, 'OPEN', PWideChar(Url), '', '', SW_SHOWNORMAL);
  Clipboard.AsText := Url;
end;

procedure TFrmTripEditor.TbDeletePointClick(Sender: TObject);
var
  Index: integer;
  SavedRecNo: integer;
  CrWait, CrNormal: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  DBGRoutePoints.SelectedRows.CurrentRowSelected := true; // Select at least one row
  SavedRecNo := DmRoutePoints.CdsRoutePoints.RecNo;
  DmRoutePoints.CdsRoutePoints.DisableControls;
  try
    for Index := 0 to DBGRoutePoints.SelectedRows.Count -1 do
    begin
      if (Index = DBGRoutePoints.SelectedRows.Count -1) then
        DmRoutePoints.CdsRoutePoints.EnableControls;
      DmRoutePoints.CdsRoutePoints.GotoBookmark(DBGRoutePoints.SelectedRows[Index]);
      DmRoutePoints.CdsRoutePoints.Delete;
    end;
    DBGRoutePoints.SelectedRows.Clear;
  finally
    if (DmRoutePoints.CdsRoutePoints.ControlsDisabled) then
      DmRoutePoints.CdsRoutePoints.EnableControls;
    if (SavedRecNo > DmRoutePoints.CdsRoutePoints.RecordCount) then
      DmRoutePoints.CdsRoutePoints.Last
    else
      DmRoutePoints.CdsRoutePoints.RecNo := SavedRecNo;
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripEditor.TbInsertPointClick(Sender: TObject);
begin
  DBGRoutePoints.SelectedRows.Clear;
  DmRoutePoints.CdsRoutePoints.Insert;
  DmRoutePoints.CdsRoutePoints.Post;
end;

procedure TFrmTripEditor.TbLookupAddressClick(Sender: TObject);
var
  MyBook: TBookmark;
  Index: integer;
  CrWait, CrNormal: HCURSOR;
begin
  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  MyBook := DmRoutePoints.CdsRoutePoints.GetBookmark;
  try
    if (DmRoutePoints.CdsRoutePoints.state in [dsInsert, dsEdit]) then
      DmRoutePoints.CdsRoutePoints.Post;
    DBGRoutePoints.SelectedRows.CurrentRowSelected := true; // Select at least one row
    for Index := 0 to DBGRoutePoints.SelectedRows.Count -1 do
    begin
      DmRoutePoints.CdsRoutePoints.GotoBookmark(DBGRoutePoints.SelectedRows[Index]);
      DmRoutePoints.CdsRoutePoints.Edit;
      DmRoutePoints.LookUpAddress;
      DmRoutePoints.CdsRoutePoints.Post;
    end;
  finally
    DmRoutePoints.CdsRoutePoints.GotoBookmark(MyBook);
    DmRoutePoints.CdsRoutePoints.FreeBookmark(MyBook);
    SetCursor(CrNormal);
  end;
end;

procedure TFrmTripEditor.TBMoveDownClick(Sender: TObject);
begin
  DBGRoutePoints.SelectedRows.Clear;

  DmRoutePoints.MoveDown(DmRoutePoints.CdsRoutePoints);
end;

end.
