unit TripManager_MultiContext;

// Interface to allow custom commands in contextmenu of ShellList

interface

uses System.Classes, System.Win.Comobj, System.Sysutils,
     Winapi.Windows, Winapi.ShlObj, Vcl.Controls, Vcl.Shell.ShellCtrls;

procedure DoContextMenuVerb(AFolder: TShellFolder; Verb: PAnsiChar);
procedure InvokeMultiContextMenu(Owner: TWinControl; AFolder: TShellFolder; MousePos: TPoint;
                                 var ICM2: IContextMenu2; AFileList: TStrings = nil);

implementation

// Contextmenu supporting multi select

procedure InvokeMultiContextMenu(Owner: TWinControl; AFolder: TShellFolder; MousePos: TPoint;
                                 var ICM2: IContextMenu2; AFileList: TStrings = nil);
var
  PIDL: PItemIDList;
  CM: IContextMenu;
  Menu: HMenu;
  Command: LongBool;
  ICI: TCMInvokeCommandInfo;
  ICmd: integer;
  ZVerb: array [0..255] of AnsiChar;
  Verb: string;
  Handled: boolean;
  SCV: IShellCommandVerb;
  HR: HResult;
  ItemIDListArray: array of PItemIDList;
  Index: integer;

begin
  if (AFolder.ParentShellFolder = nil) then
    exit;

  if not Assigned(AFileList) then     // get the IContextMenu Interface for FilePIDL
  begin
    PIDL := AFolder.RelativeID;
    HR := AFolder.ParentShellFolder.GetUIObjectOf(Owner.Handle, 1, PIDL, IID_IContextMenu, nil, CM);
  end
  else
  begin                             // get the IContextMenu Interface for the file array
    // Setup ItemIDListArray.
    SetLength(ItemIDListArray, AFileList.Count);
    for Index := 0 to AFileList.Count - 1 do
      ItemIDListArray[Index] := Pointer(AFileList.Objects[Index]);
    HR := AFolder.ParentShellFolder.GetUIObjectOf(Owner.Handle, AFileList.Count, ItemIDListArray[0], IID_IContextMenu, nil, CM);
  end;
  if (HR <> S_OK) then
    exit;

  // Indicate nothing happened
  Winapi.Windows.ClientToScreen(Owner.Handle, MousePos);
  Menu := CreatePopupMenu;
  CM.QueryContextMenu(Menu, 0, 1, $7FFF, CMF_EXPLORE or CMF_CANRENAME);
  CM.QueryInterface(IID_IContextMenu2, ICM2); //To handle submenus.

  try
    try
      Command := TrackPopupMenu(Menu,
                                TPM_LEFTALIGN or TPM_LEFTBUTTON or TPM_RIGHTBUTTON or TPM_RETURNCMD,
                                MousePos.X, MousePos.Y, 0, Owner.Handle, nil);
    finally
      ICM2 := nil;
    end;

    if Command then
    begin
      ICmd := LongInt(Command) -1;
      HR := CM.GetCommandString(ICmd, GCS_VERBA, nil, ZVerb, SizeOf(ZVerb));
      Verb := string(ZVerb);

      Handled := False;
      if not Handled and
         Supports(Owner, IShellCommandVerb, SCV) then
      begin
        HR := 0;
        SCV.ExecuteCommand(Verb, Handled);
      end;

      if not Handled then
      begin
        FillChar(ICI, SizeOf(ICI), #0);
        with ICI do
        begin
          cbSize := SizeOf(ICI);
          HWND := 0;
          lpVerb := MakeIntResourceA(ICmd);
          nShow := SW_SHOWNORMAL;
        end;
        HR := CM.InvokeCommand(ICI);
      end;

      if Assigned(SCV) then
        SCV.CommandCompleted(Verb, HR = S_OK);

    end;
  finally
    DestroyMenu(Menu);
  end;
end;

procedure DoContextMenuVerb(AFolder: TShellFolder; Verb: PAnsiChar);
var
  ICI: TCMInvokeCommandInfo;
  CM: IContextMenu;
  PIDL: PItemIDList;
begin
  if AFolder = nil then Exit;
  FillChar(ICI, SizeOf(ICI), #0);
  with ICI do
  begin
    cbSize := SizeOf(ICI);
    fMask := CMIC_MASK_ASYNCOK;
    hWND := 0;
    lpVerb := Verb;
    nShow := SW_SHOWNORMAL;
  end;
  PIDL := AFolder.RelativeID;
  AFolder.ParentShellFolder.GetUIObjectOf(0, 1, PIDL, IID_IContextMenu, nil, CM);
  CM.InvokeCommand(ICI);
end;

end.
