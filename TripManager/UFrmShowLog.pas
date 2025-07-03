unit UFrmShowLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  TFrmShowLog = class(TForm)
    PnlBot: TPanel;
    BtnClose: TBitBtn;
    LbLog: TListBox;
    procedure BtnCloseClick(Sender: TObject);
    procedure LbLogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FSyncTreeview: TnotifyEvent;
  end;

var
  FrmShowLog: TFrmShowLog;

implementation

{$R *.dfm}

procedure TFrmShowLog.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmShowLog.LbLogClick(Sender: TObject);
begin
  if Assigned(FSyncTreeview) then
    FSyncTreeview(LbLog.Items.Objects[LbLog.ItemIndex]);
end;

end.
