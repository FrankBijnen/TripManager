unit TripManager_DBGrid;
// DBGrid with better mouse selection

interface

uses
  System.Classes, System.UITypes,
  Vcl.DBGrids;

type
  TDBGrid = class(Vcl.DBGrids.TDBGrid)
  private
    FirstSel: integer;
    procedure SelectRange;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    property InplaceEditor;
  end;

implementation

uses
  System.Math,
  Data.DB;

constructor TDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FirstSel := -1;
end;

procedure TDBGrid.SelectRange;
var
  CurrentRec: integer;
  MyBook: TBookmark;
begin
  SelectedRows.Clear;

  if (FirstSel < 1) or
     (FirstSel > DataSource.DataSet.RecordCount) or
     (FirstSel = DataSource.DataSet.RecNo) then
    exit;

  DataSource.DataSet.DisableControls;
  MyBook := DataSource.DataSet.GetBookmark;
  try
    for CurrentRec := Min(FirstSel, DataSource.DataSet.RecNo) to
                      Max(FirstSel, DataSource.DataSet.RecNo) do
    begin
      DataSource.DataSet.RecNo := CurrentRec;
      SelectedRows.CurrentRowSelected := true;
    end;
    DataSource.DataSet.GotoBookmark(MyBook);
  finally
    DataSource.DataSet.EnableControls;
    DataSource.DataSet.FreeBookmark(MyBook);
  end;
end;

procedure TDBGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;

  if (ssCtrl in Shift) then
    exit;

  if not (ssShift in Shift) then
    FirstSel := DataSource.DataSet.RecNo;
  SelectRange;
end;

end.
