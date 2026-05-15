// Add Event when the value is actually changed
unit UnitStringGrid;

interface

uses
  Vcl.Grids;
type
  TMySetEditEvent = procedure (Sender: TObject; ACol, ARow: Longint; var Value: string) of object;

  TStringGrid = class(Vcl.Grids.TStringGrid)
  private
    FOnModified: TMySetEditEvent;
  protected
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
  public
    property OnModified: TMySetEditEvent read FOnModified write FOnModified;
  end;

implementation

procedure TStringGrid.SetEditText(ACol, ARow: Longint; const Value: string);
var
  EventValue: string;
begin
  EventValue := Value;
  if Assigned(FOnModified) and
     (Cells[ACol, ARow] <> Value) then
    FOnModified(Self, ACol, ARow, EventValue);

  inherited SetEditText(ACol, ARow, EventValue);
end;

end.
