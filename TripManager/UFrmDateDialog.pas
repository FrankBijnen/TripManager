// Can be used for sorting the trips.
// Can be combined with groupning on parenttripid. Max 16 file
// Sorting of groups appears to be on the first file of the group
unit UFrmDateDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls;

type
  TFrmDateDialog = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BitBtn2: TBitBtn;
    DtPicker: TDateTimePicker;
    ChkIncrement: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDateDialog: TFrmDateDialog;

implementation

{$R *.dfm}

end.
