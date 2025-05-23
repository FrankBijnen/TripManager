unit TripManager_ValEdit;

interface

uses
  System.Classes,
  Vcl.Grids, Vcl.ValEdit;

type

  TValueListEditor = class(Vcl.ValEdit.TValueListEditor)
  private
    FOnSelectionMoved: TNotifyEvent;
  protected
    procedure SelectionMoved(const OldSel: TGridRect); override;
  public
    property OnSelectionMoved: TNotifyEvent read FOnSelectionMoved write FOnSelectionMoved;
  end;

implementation

procedure TValueListEditor.SelectionMoved(const OldSel: TGridRect);
begin
  inherited SelectionMoved(OldSel);

  if Assigned(FOnSelectionMoved) then
    FOnSelectionMoved(Self);
end;


end.
