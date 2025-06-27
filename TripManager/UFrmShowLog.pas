unit UFrmShowLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TFrmShowLog = class(TForm)
    PnlBot: TPanel;
    BtnClose: TBitBtn;
    MemoLog: TMemo;
    procedure BtnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmShowLog: TFrmShowLog;

implementation

{$R *.dfm}

procedure TFrmShowLog.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
