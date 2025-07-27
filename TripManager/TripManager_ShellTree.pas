unit TripManager_ShellTree;

interface

uses
  System.Classes, System.Types,
  Winapi.ShlObj,
  Vcl.Shell.ShellCtrls, Vcl.ComCtrls;

const
  sfsNeedsCheck = -2;

type
  TShellTreeView = class(Vcl.Shell.ShellCtrls.TShellTreeView)
  private
  protected
    procedure InitNode(NewNode: TTreeNode; ID: PItemIDList; ParentNode: TTreeNode); override;
    function CustomDrawItem(Node: TTreeNode; State: TCustomDrawState;
      Stage: TCustomDrawStage; var PaintImages: Boolean): Boolean; override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
  public
    property OnCustomDrawItem;
  end;

implementation

uses
  Winapi.Windows, Winapi.CommCtrl;

function GetIShellFolder(IFolder: IShellFolder; PIDL: PItemIDList): IShellFolder;
begin
  result := nil;
  if Assigned(IFolder) then
    IFolder.BindToObject(PIDL, nil, IID_IShellFolder, Pointer(Result));
end;

function HasDirAttribute(ADir: string): boolean;
var
  Attrs: DWORD;
begin
  Attrs := GetFileAttributes(PChar(ADir));
  result := ((Attrs and FILE_ATTRIBUTE_DIRECTORY) <> 0);
end;

procedure TShellTreeView.InitNode(NewNode: TTreeNode; ID: PItemIDList; ParentNode: TTreeNode);
var
  CanAdd: Boolean;
  NewFolder: IShellFolder;
  AFolder: TShellFolder;
  NewShellFolder: TShellFolder;
begin
  // Performance optimization only for directories.
  if (otNonFolders in ObjectTypes) then
  begin
    inherited InitNode(NewNode, ID, ParentNode);
    exit;
  end;

  // Init the node with Data
  AFolder := TShellFolder(ParentNode.Data);
  NewFolder := GetIShellFolder(AFolder.ShellFolder, ID);
  NewNode.Data := TShellFolder.Create(AFolder, ID, NewFolder);
  NewShellFolder := TShellFolder(NewNode.Data);

  // Archives (TAR, ZIP TGZ etc.) may be reported as folders in TCustomShellTreeView.PopulateNode
  // Resulting in needlessly scanning large files
  if (HasDirAttribute(NewShellFolder.PathName) = false) then
    NewNode.Delete // AFolder does not have Directory Attribute. Dont show in Treeview
  else
  begin
    // Set text
    NewNode.Text := NewShellFolder.DisplayName;

    // Use StateIndex as a flag to indicate that this node needs to be examined
    // StateIndex is not used in TShellTreeview
    NewNode.StateIndex := sfsNeedsCheck;

    // Image and selected index
    // Dont care for SHGFI_OPENICON, rarely used
    if UseShellImages and
       not Assigned(Images) then
    begin
      NewNode.ImageIndex := NewShellFolder.ImageIndex(false);
      NewNode.SelectedIndex := NewNode.ImageIndex;
    end;

    // Assume the node has Children. Will be set later correctly.
    // Needed for SetPathFromId to work
    NewNode.HasChildren := true;

    // Call OnAddFolder.
    // Note: HasChildren has not been set correctly.
    CanAdd := True;
    if Assigned(OnAddFolder) then
       OnAddFolder(Self, NewShellFolder, CanAdd);
    if not CanAdd then
      NewNode.Delete;
  end;

end;

// Do the check for children deferred. Only when scrolled in view.
function TShellTreeView.CustomDrawItem(Node: TTreeNode; State: TCustomDrawState;
  Stage: TCustomDrawStage; var PaintImages: Boolean): Boolean;
var
  prc: Trect;
  AFolder: TShellFolder;
begin
  if not (otNonFolders in ObjectTypes) and // Performance optimization only for directories.
     (Stage = TCustomDrawStage.cdPrePaint) and
     (Node.Data <> nil) and
     (Node.StateIndex = sfsNeedsCheck) then
  begin
    if TreeView_GetItemRect(Handle, Node.ItemId, prc, false) then // Only check items in view
    begin
      // Only do the check 1 time.
      Node.StateIndex := Node.StateIndex + 1;

      // Get Folder
      AFolder := TShellFolder(Node.Data);

      // Has subfoldere?
      if (otFolders in ObjectTypes) then
        Node.HasChildren := AFolder.SubFolders;

      // Dont care if the folder is shared, or has non folder subitems
    end;
  end;

  result := inherited CustomDrawItem(Node, State, Stage, PaintImages);
end;

procedure TShellTreeView.DoContextPopup(MousePos: TPoint; var Handled: boolean);
var
  RightClickSave: boolean;
begin
  // RightClickSelect needs to be disabled within this method.
  // 'Selected' will be set to FRClickNode, leading to all kind of AV's (Especially WIN64)
  // See Vcl.ComCtrls at around line 12551 CNNotify, Case NM_RCLICK:
  RightClickSave := RightClickSelect;
  RightClickSelect := false;

  try

   inherited;

  finally
    RightClickSelect := RightClickSave;
  end;
end;

end.
