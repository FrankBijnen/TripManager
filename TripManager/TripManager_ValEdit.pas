unit TripManager_ValEdit;
// Add event when selection has moved, and Save as CSV

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
    procedure SaveAsCSV(const CSVFile: string);
    property OnSelectionMoved: TNotifyEvent read FOnSelectionMoved write FOnSelectionMoved;
  end;

implementation

uses
  System.SysUtils;

procedure TValueListEditor.SelectionMoved(const OldSel: TGridRect);
begin
  inherited SelectionMoved(OldSel);

  if Assigned(FOnSelectionMoved) then
    FOnSelectionMoved(Self);
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
