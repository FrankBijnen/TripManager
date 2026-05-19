unit TripManager_Grid;

interface

uses
  Vcl.Grids;
procedure AlignGrid(AGrid: TStringGrid; SpaceLeft: integer);
procedure AddGridHeader(const AGrid: TStringGrid);
procedure AddGridValueLine(const AGrid: TStringGrid;
                           var ARow: integer;
                           const AKey: string; Value: Variant; ADesc: string = '');
procedure AddGridLine(const AGrid: TStringGrid;
                      var ARow: integer;
                      const AKey: string; DefaultValue: Variant; ADesc: string = '');

implementation
uses
  System.Math, System.StrUtils, System.SysUtils, System.Variants,
  UnitStringUtils, UnitRegistry, UnitTripDefs;

procedure AlignGrid(AGrid: TStringGrid; SpaceLeft: integer);
var
  Margin: integer;
  Index: integer;
  CurCol: integer;
  LastCol: integer;
  SpaceNeeded: integer;
begin
  Margin := AGrid.ScaleValue(10);
  LastCol := SpaceLeft;
  for CurCol := 0 to AGrid.ColCount -2 do
  begin
    SpaceNeeded := 0;
    for Index := 0 to AGrid.RowCount do
      SpaceNeeded := Max(SpaceNeeded, AGrid.Canvas.TextWidth(AGrid.Cells[CurCol, Index]) + Margin);
    AGrid.ColWidths[CurCol] := SpaceNeeded;
    Dec(LastCol, SpaceNeeded);
  end;
  AGrid.ColWidths[AGrid.ColCount -1] := LastCol;
end;

procedure AddGridHeader(const AGrid: TStringGrid);
begin
  AGrid.FixedRows := 1;
  AGrid.Cells[0, 0] := 'Registry Key';
  AGrid.Cells[1, 0] := 'Description';
  AGrid.Cells[2, 0] := 'Value';
end;

procedure AddGridValueLine(const AGrid: TStringGrid;
                           var ARow: integer;
                           const AKey: string; Value: Variant; ADesc: string = '');
var
  ACardinal: Cardinal;
begin
  AGrid.Cells[0, ARow] := AKey;
  AGrid.Cells[1, ARow] := ADesc;
  AGrid.Cells[2, ARow] := Value;
  if (StartsText('0x', AGrid.Cells[2, ARow])) and
     (StartsText('Date: ', AGrid.Cells[1, ARow])) then
  begin
    ACardinal := StrToIntDef('$' + Copy(AGrid.Cells[2, ARow], 3), 0);
    AGrid.Cells[1, ARow] := 'Date: ' + TUnixDateConv.CardinalAsDateTimeString(ACardinal);
  end;

  ARow := ARow + 1;
end;

procedure AddGridLine(const AGrid: TStringGrid;
                      var ARow: integer;
                      const AKey: string; DefaultValue: Variant; ADesc: string = '');
var
  RegKey, SubKey: string;
begin
  if (AKey = '') then
    AddGridValueLine(AGrid, ARow, AKey, '', ADesc)
  else
  begin
    RegKey := AKey;
    if (Pos('\', RegKey) > 0) then
      SubKey := NextField(RegKey, '\')
    else
      SubKey := '';
    if (VarIsStr(DefaultValue)) then
      AddGridValueLine(AGrid, ARow, AKey, GetRegistry(RegKey, VarToStr(DefaultValue), SubKey), ADesc)
    else if (VarIsNumeric(DefaultValue)) then
      AddGridValueLine(AGrid, ARow, AKey, GetRegistry(RegKey, integer(DefaultValue), SubKey), ADesc)
    else if (VarIsOrdinal(DefaultValue)) then
      AddGridValueLine(AGrid, ARow, AKey, GetRegistry(RegKey, boolean(DefaultValue), SubKey), ADesc)
  end;
end;

end.
