unit UFrmGeoSearch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons;

type

  TFGeoSearch = class(TForm)
    PctMain: TPageControl;
    TabFreeSearch: TTabSheet;
    EdSearchFree: TLabeledEdit;
    TabFormattedSearch: TTabSheet;
    MemoFreeSearch: TMemo;
    MemoFormatted: TMemo;
    EdStreet: TLabeledEdit;
    EdCity: TLabeledEdit;
    EdCounty: TLabeledEdit;
    EdState: TLabeledEdit;
    EdCountry: TLabeledEdit;
    EdPostalCode: TLabeledEdit;
    Panel1: TPanel;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateDesign;
  public
    { Public declarations }
  end;

var
  FGeoSearch: TFGeoSearch;

implementation

uses
  UnitGeoCode;

{$R *.dfm}

procedure TFGeoSearch.FormShow(Sender: TObject);
begin
  ClearCoordCache; // Make sure we dont get cached data.
  case PctMain.ActivePageIndex of
    0: EdSearchFree.SetFocus;
    1: EdStreet.SetFocus;
  end;
end;

procedure TFGeoSearch.UpdateDesign;
begin
  PctMain.ActivePage := TabFreeSearch;
end;

procedure TFGeoSearch.FormCreate(Sender: TObject);
begin
  UpdateDesign;
end;

end.
