unit TripManager_ShellTree;

interface

uses
  System.Classes, System.Types,
  Vcl.Shell.ShellCtrls;

type
  TShellTreeView = class(Vcl.Shell.ShellCtrls.TShellTreeView)
  private
  protected
     procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
  public
  end;

implementation

procedure TShellTreeView.DoContextPopup(MousePos: TPoint; var Handled: boolean);
var
  RightClickSave: boolean;
begin
  // RightClickSelect needs to be disabled within this method.
  // 'Selected' will be set to FRClickNode, leading to all kind of AV's (Especially WIN64)
  // See Vcl.ComCtrls at around line 12240 CNNotify, Case NM_RCLICK:
  RightClickSave := RightClickSelect;
  RightClickSelect := false;

  try

   inherited;

  finally
    RightClickSelect := RightClickSave;
  end;
end;

end.
