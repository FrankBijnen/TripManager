To compile TripManager you need to install the ShellCtrls, using a slightly modified version of the Embarcadero Shell Controls.
Due to the Copyright statement I can't distribute that source, but the Community Edition comes with the source code of these controls.

- Find the files Vcl.Shell.ShellConsts.pas and Vcl.Shell.ShellCtrls.pas in the Embarcadero Source directory and copy them to this directory.

- Modify the Vcl.Shell.ShellCtrls.pas file.

1) In the 'protected' declarations of TCustomShellTreeView add 'virtual' to 'initnode'.

2) In the 'private' declarations of TCustomShellListView, comment 'procedure EnumColumns'.

//  procedure EnumColumns;

3) In the 'protected' declarations of TCustomShellListView, add 'procedure EnumColumns' decorated with 'virtual'.

    procedure EnumColumns; virtual;

4) In the 'public' declarations of TCustomShellListView, add:

    property FoldersList: TList read FFolders;

Memory Leak fixes

5) In 'function StrRetToString', after 'if Assigned(StrRet.pOleStr) then' replace

     Result := StrRet.pOleStr

with this block

//        Result := StrRet.pOleStr
      begin
        Result := StrRet.pOleStr;
        CoTaskMemFree(StrRet.pOleStr);
      end

6) In 'procedure TCustomShellListView.Populate;', after 'AFolder := TShellFolder.Create(FRootFolder, ID, NewFolder);'

add this line

        CoTaskMemFree(ID);

Performance fixes
7) In procedure TCustomShellTreeView.Refresh(Node: TTreeNode);    

After these lines:
    ThisLevel := Node.Level;
    OldNode := Node;

Before these lines:
   if Assigned(Node.Data) then
   begin


You find this repeat until:
    repeat
      Temp := FolderExists(TShellFolder(OldNode.Data).AbsoluteID, NewNode);
      if (Temp <> nil) and OldNode.Expanded then
        Temp.Expand(False);
      OldNode := OldNode.GetNext;
    until (OldNode = nil) or (OldNode.Level = ThisLevel);


Replace it with:
//Performance
// Refreshing folder with many folder takes very long.
// Check OldNode.Expanded first before calling expensive FolderExists
(*
    repeat
      Temp := FolderExists(TShellFolder(OldNode.Data).AbsoluteID, NewNode);
      if (Temp <> nil) and OldNode.Expanded then
        Temp.Expand(False);
      OldNode := OldNode.GetNext;
    until (OldNode = nil) or (OldNode.Level = ThisLevel);
*)
    repeat
      if (OldNode.Expanded) then
      begin
        Temp := FolderExists(TShellFolder(OldNode.Data).AbsoluteID, NewNode);
        if (Temp <> nil) then
          Temp.Expand(False);
      end;
      OldNode := OldNode.GetNext;
    until (OldNode = nil) or (OldNode.Level = ThisLevel);

- Open the ShellControls.groupproj in Delphi (Or CBuilder), Compile and Install the 32 Bits version. The 64 Bits also works, but is not needed.

Notes:

- If you already have these controls installed, make the modifications described above to your version.
- The subdirectory 'Vcl.ShellControls' is in the Search path of the Project. 

