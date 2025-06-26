unit TripManager_ValEdit;
// Add events when selection has moved and before DrawCell, and Save as CSV

interface

uses
  System.Classes, System.Types,
  Vcl.Grids, Vcl.ValEdit;

type
  TValueListEditor = class(Vcl.ValEdit.TValueListEditor)
  private
    FOnSelectionMoved: TNotifyEvent;
    FOnBeforeDrawCell: TDrawCellEvent;
  protected
    procedure SelectionMoved(const OldSel: TGridRect); override;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
  public
    procedure SaveAsCSV(const CSVFile: string);
    property OnSelectionMoved: TNotifyEvent read FOnSelectionMoved write FOnSelectionMoved;
    property OnBeforeDrawCell: TDrawCellEvent read FOnBeforeDrawCell write FOnBeforeDrawCell;
  end;

implementation

uses
  System.SysUtils,
  Vcl.Graphics;

procedure TValueListEditor.SelectionMoved(const OldSel: TGridRect);
begin
  inherited SelectionMoved(OldSel);

  if Assigned(FOnSelectionMoved) then
    FOnSelectionMoved(Self);
end;

procedure TValueListEditor.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
begin
  if (Assigned(FOnBeforeDrawCell)) then
    FOnBeforeDrawCell(Self, ACol, ARow, ARect, AState);

  inherited DrawCell(ACol, ARow, ARect, AState);
end;

procedure TValueListEditor.SaveAsCSV(const CSVFile: string);
var
  Writer: TTextWriter;
  Lst: TStringList;
  Index: integer;
begin
  Writer := TStreamWriter.Create(CSVFile, false, TEncoding.UTF8);
  try
    Lst := TStringList.Create;
    try
      Lst.QuoteChar := '"';
      Lst.Delimiter := ';';

      Lst.AddStrings(['Key', 'Value']);
      Writer.WriteLine(Lst.DelimitedText);

      for Index := 0 to Strings.Count -1 do
      begin
        Lst.Clear;
        Lst.AddStrings([#9 + Strings.KeyNames[Index], #9 + Strings.ValueFromIndex[Index]]);
        Writer.WriteLine(Lst.DelimitedText);
      end;
    finally
      Lst.Free;
    end;
  finally
    Writer.Free;
  end;
end;

end.
