// To compile this unit you need to modify the standard Embarcadero control.
// Move EnumColumns from private to protected and add virtual
//     procedure EnumColumns; virtual;
// Declare FoldersList in public
//    property FoldersList: TList read FFolders;
unit TripManager_ShellList;

interface

uses
  System.Classes, System.SysUtils, System.Types,
  Winapi.Windows, Winapi.Messages, Winapi.CommCtrl, Winapi.ShlObj, WinApi.ActiveX,
  Vcl.Shell.ShellCtrls, Vcl.Shell.ShellConsts, Vcl.ComCtrls, Vcl.Controls;

// Extend ShellListview, keeping the same Type. So we dont have to register it in the IDE
// Extended to support:
// Column sorting.
// Multi-select context menu, with custom menu items. (For Refresh and generate thumbs)

type
  THeaderSortState = (hssNone, hssAscending, hssDescending);

  TShellListView = class(Vcl.Shell.ShellCtrls.TShellListView, IDropSource)
  private
    FColumnSorted: boolean;
    FSortColumn: integer;
    FSortState: THeaderSortState;

    ICM2: IContextMenu2;
    FDragStartPos: TPoint;
    FDragSource: boolean;
    FDragStarted: boolean;
    function GiveFeedback(dwEffect: Longint): HResult; stdcall;
    function QueryContinueDrag(fEscapePressed: BOOL; grfKeyState: Longint): HResult; stdcall;
    procedure SetColumnSorted(AValue: boolean);
    function CreateSelectedFileList: TStringList;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure WMNotify(var Msg: TWMNotify); message WM_NOTIFY;

    procedure InitSortSpec(SortColumn: integer; SortState: THeaderSortState);
    procedure Populate; override;
    procedure ColumnSort; virtual;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: boolean); override;
    procedure Edit(const Item: TLVItem); override;

    procedure ShowMultiContextMenu(MousePos: TPoint);
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearSelection; override;
    procedure SelectAll; override;
    procedure Refresh;
    procedure ColumnClick(Column: TListColumn);
    procedure SetFocus; override;

    property ColumnSorted: boolean read FColumnSorted write SetColumnSorted;
    property SortColumn: integer read FSortColumn write FSortColumn;
    property SortState: THeaderSortState read FSortState write FSortState;
    property OnMouseWheel;
    property DragSource: boolean read FDragSource write FDragSource;
  end;

implementation

uses
  System.Win.ComObj, System.UITypes,
  TripManager_MultiContext;

{$IFDEF VER350}
const
  Arrow_Up = #$25b2;
  Arrow_Down = #$25bc;
{$ENDIF}

{ Listview Sort helpers }

function GetListHeaderSortState(HeaderLView: TCustomListView; Column: TListColumn): THeaderSortState;
var
  Header: HWND;
  Item: THDItem;
begin
  Header := ListView_GetHeader(HeaderLView.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;
  Header_GetItem(Header, Column.Index, Item);
  if Item.fmt and HDF_SORTUP <> 0 then
    Result := hssAscending
  else if Item.fmt and HDF_SORTDOWN <> 0 then
    Result := hssDescending
  else
    Result := hssNone;
end;

procedure SetListHeaderSortState(HeaderLView: TCustomListView; Column: TListColumn; Value: THeaderSortState);
var
  Header: HWND;
  Item: THDItem;
begin
  Header := ListView_GetHeader(HeaderLView.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;
  Header_GetItem(Header, Column.Index, Item);
  Item.fmt := Item.fmt and not(HDF_SORTUP or HDF_SORTDOWN); // remove both flags
  case Value of
    hssAscending:
      begin
        // Add an arrow to the caption. Using styles doesn't show the arrows in the header
{$IFDEF VER350}
        if (Column.Caption[Length(Column.Caption)] <> Arrow_Up) then
          Column.Caption := Column.Caption + ' ' + Arrow_Up;
{$ENDIF}
        Item.fmt := Item.fmt or HDF_SORTUP;
      end;
    hssDescending:
      begin
        // Add an arrow to the caption.
{$IFDEF VER350}
        if (Column.Caption[Length(Column.Caption)] <> Arrow_Down) then
          Column.Caption := Column.Caption + ' ' + Arrow_Down;
{$ENDIF}
        Item.fmt := Item.fmt or HDF_SORTDOWN;
      end;
  end;
  Header_SetItem(Header, Column.Index, Item);
end;

{ TShellListView }

procedure TShellListView.WMNotify(var Msg: TWMNotify);
var
  Column: TListColumn;
  ResizedColumn: integer;
begin
  inherited;

  case Msg.NMHdr^.code of
    HDN_ENDTRACK,
    HDN_DIVIDERDBLCLICK:
      begin
        ResizedColumn := pHDNotify(Msg.NMHdr)^.Item;
        Column := Columns[ResizedColumn];
        if (Column.Index = FSortColumn) then
        begin
          case (FSortState) of
            THeaderSortState.hssAscending:
              SetListHeaderSortState(Self, Column, hssAscending);
            THeaderSortState.hssDescending:
              SetListHeaderSortState(Self, Column, hssDescending);
          end;
        end;
      end;
    HDN_BEGINTRACK:
      ;
    HDN_TRACK:
      ;
  end;
end;

procedure TShellListView.InitSortSpec(SortColumn: integer; SortState: THeaderSortState);
begin
  FSortColumn := SortColumn;
  FSortState := SortState;
end;

procedure TShellListView.Populate;
begin
  Items.BeginUpdate;
  try
    inherited Populate;
    ColumnSort;
  finally
    Items.EndUpdate;
  end;
end;

procedure TShellListView.ColumnSort;
var
  LocalDescending: boolean;
  LocalCompareColumn: integer;
begin
  // Need to sort on column?
  if (ColumnSorted = false) then
    exit;

  // Sorting column
  LocalCompareColumn := SortColumn;
  if (LocalCompareColumn < Columns.Count) then
    SetListHeaderSortState(Self, Columns[LocalCompareColumn], FSortState);
  LocalDescending := (SortState = THeaderSortState.hssDescending);

  // Use an anonymous method. So we can test for FDoDefault, CompareColumn and SortState
  // Use only 'local variables' within this procedure
  // See also method ListSortFunc in Vcl.Shell.ShellCtrls.pas
  FoldersList.SortList(
    function(Item1, Item2: Pointer): integer
    const
      R: array [boolean] of Byte = (0, 1);
    begin
      result := R[TShellFolder(Item2).IsFolder] - R[TShellFolder(Item1).IsFolder];
      if (result = 0) then
        if (TShellFolder(Item1).ParentShellFolder <> nil) then
          result := Smallint(TShellFolder(Item1).ParentShellFolder.CompareIDs(LocalCompareColumn,
                                                                              TShellFolder(Item1).RelativeID,
                                                                              TShellFolder(Item2).RelativeID));

      // Sort on Filename (Column 0), within CompareColumn
      if (result = 0) and
         (LocalCompareColumn <> 0) then
        result := Smallint(TShellFolder(Item1).ParentShellFolder.CompareIDs(0,
                                                                            TShellFolder(Item1).RelativeID,
                                                                            TShellFolder(Item2).RelativeID));

      // Reverse order
      if (LocalDescending) then
        result := result * -1;
    end);

end;

procedure TShellListView.ShowMultiContextMenu(MousePos: TPoint);
var
  FileList: TStringList;
begin
  if (SelectedFolder = nil) then
    exit;

  FileList := CreateSelectedFileList;
  try
    InvokeMultiContextMenu(Self, SelectedFolder, MousePos, ICM2, FileList);
  finally
    FileList.Free;
  end;
end;

// to handle submenus of context menus.
procedure TShellListView.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_INITMENUPOPUP,
    WM_DRAWITEM,
    WM_MENUCHAR,
    WM_MEASUREITEM:
      if Assigned(ICM2) then
      begin
        ICM2.HandleMenuMsg(Message.Msg, Message.wParam, Message.lParam);
        Message.Result := 0;
      end;
  end;
  inherited;
end;

procedure TShellListView.ClearSelection;
var
  Indx: integer;
begin
  for Indx := 0 to Items.Count -1 do
    ListView_SetItemState(Handle, Indx, 0, LVIS_SELECTED);
end;

procedure TShellListView.SelectAll;
var
  Indx: integer;
begin
  for Indx := 0 to Items.Count -1 do
    ListView_SetItemState(Handle, Indx, LVIS_SELECTED, LVIS_SELECTED);
end;

procedure TShellListView.Refresh;
begin
  ClearSelection;

  inherited Refresh;
end;

function TShellListView.CreateSelectedFileList: TStringList;
var
  Index: integer;
begin
  Result := TStringList.Create;
  for Index := 0 to Items.Count -1 do
    if (ListView_GetItemState(Handle, Index, LVIS_SELECTED) = LVIS_SELECTED) then
      result.AddObject(ExtractFileName(Folders[Index].PathName), Pointer(Folders[Index].RelativeID))
end;

procedure TShellListView.DoContextPopup(MousePos: TPoint; var Handled: boolean);
begin
  ShowMultiContextMenu(MousePos);
  Handled := true;

//  inherited;
end;

procedure TShellListView.Edit(const Item: TLVItem);
begin
  inherited Edit(Item);

  if Assigned(ShellTreeView) and
     Assigned(ShellTreeView.Selected) and
     (Folders[Item.iItem].IsFolder) then
    ShellTreeView.Refresh(ShellTreeView.Selected);
end;

constructor TShellListView.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);

  ICM2 := nil;

  DoubleBuffered := true;
{$IFNDEF VER350}
  DoubleBufferedMode := TDoubleBufferedMode.dbmRequested;
{$ENDIF}
  StyleElements := [seFont, seBorder];
  FDragSource := false;
  FDragStarted := false;
  InitSortSpec(0, THeaderSortState.hssNone);
end;

procedure TShellListView.CreateWnd;
begin
  inherited;

  SetColumnSorted(FColumnSorted); // Disable inherited Sorted?  Note: Populate will not be called when Enabled = false
end;

destructor TShellListView.Destroy;
begin
  inherited;
end;

procedure TShellListView.DestroyWnd;
begin
  inherited DestroyWnd;
end;

procedure TShellListView.ColumnClick(Column: TListColumn);
var
  I: integer;
  Ascending: boolean;
  State: THeaderSortState;
begin
  if (FColumnSorted = false) then
    exit;

  Ascending := GetListHeaderSortState(Self, Column) <> hssAscending;
  for I := 0 to Columns.Count - 1 do
  begin
    if Columns[I] = Column then
    begin
      if Ascending then
        State := hssAscending
      else
        State := hssDescending;
      InitSortSpec(Column.Index, State);
    end
    else
      State := hssNone;
    SetListHeaderSortState(Self, Columns[I], State);
  end;
  EnumColumns;
  Populate;
end;

procedure TShellListView.SetColumnSorted(AValue: boolean);
begin
  if (FColumnSorted <> AValue) then
    FColumnSorted := AValue;
  if (FColumnSorted) and
     (Sorted) then
    Sorted := false;
end;

procedure TShellListView.SetFocus;
begin
// Avoid cannot focus a disabled or invisible window
  if Enabled then
    inherited SetFocus;
end;

function TShellListView.GiveFeedback(dwEffect: Longint): HResult; stdcall;
begin
  Result := DRAGDROP_S_USEDEFAULTCURSORS;
end;

function TShellListView.QueryContinueDrag(fEscapePressed: BOOL; grfKeyState: Longint): HResult; stdcall;
begin
  if fEscapePressed or (grfKeyState and MK_RBUTTON = MK_RBUTTON) then
    Result := DRAGDROP_S_CANCEL
  else if grfKeyState and MK_LBUTTON = 0 then
    Result := DRAGDROP_S_DROP
  else
    Result := S_OK;
end;

procedure TShellListView.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (FDragSource) and
     not (ssDouble in Shift) and
     (Button = mbLeft) then
  begin
    FDragStartPos.X := X;
    FDragStartPos.Y := Y;
    FDragStarted := true;
  end;

  inherited MouseDown(Button, Shift, X, Y);
end;

procedure TShellListView.MouseMove(Shift: TShiftState; X, Y: Integer);
const
  Threshold = 3;
var
  HR: HResult;
  ItemIDListArray: array of PItemIDList;
  Index, Cnt: integer;
  DataObject: IDataObject;
  Effect: Longint;
begin
  inherited MouseMove(Shift, X, Y);

  if (FDragSource = false) or
     (FDragStarted = false) then
    exit;

  if (SelCount > 0) and
     (csLButtonDown in ControlState) and
     ((Abs(X - FDragStartPos.X) >= Threshold) or (Abs(Y - FDragStartPos.Y) >= Threshold)) then
  begin
    Perform(WM_LBUTTONUP, 0, MakeLong(X, Y));
    SetLength(ItemIDListArray, SelCount);
    Cnt := 0;
    for Index := 0 to Items.Count - 1 do
    begin
      if (ListView_GetItemState(Handle, Index, LVIS_SELECTED) = LVIS_SELECTED) then
      begin
        ItemIDListArray[Cnt] := Folders[Index].RelativeID;
        Inc(Cnt);
      end;
    end;

    HR := RootFolder.ShellFolder.GetUIObjectOf(0, SelCount, ItemIDListArray[0], IDataObject, nil, DataObject);
    if (HR = S_OK) then
    begin
      Effect := DROPEFFECT_NONE;
      DoDragDrop(DataObject, Self, DROPEFFECT_COPY, Effect);
    end;
  end;
end;

procedure TShellListView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDragStarted := false;
  inherited MouseUp(Button, Shift, X, Y);;
end;

end.
