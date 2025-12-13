// Add Event when the value is actually changed
unit Unit_StringGrid;

interface

uses
  Vcl.Grids;
type
  TStringGrid = class(Vcl.Grids.TStringGrid)
  private
    FOnModified: TSetEditEvent;
  protected
    procedure SetEditText(ACol, ARow: Longint; const Value: string); override;
  public
    property OnModified: TSetEditEvent read FOnModified write FOnModified;
  end;

implementation

procedure TStringGrid.SetEditText(ACol, ARow: Longint; const Value: string);
begin
  if Assigned(FOnModified) and
     (Cells[ACol, ARow] <> Value) then
    FOnModified(Self, ACol, ARow, Value);
  inherited SetEditText(ACol, Arow, Value);
end;

end.
