unit UFrmNewTrip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls;

type
  TFrmNewTrip = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    btnOk: TBitBtn;
    ChkDevice: TCheckBox;
    EdNewTrip: TEdit;
    EdResultFile: TEdit;
    Label1: TLabel;
    procedure ChkDeviceClick(Sender: TObject);
    procedure EdNewTripChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure ShowResultFile;
  public
    { Public declarations }
    DevicePath: string;
    CurPath: string;
  end;

var
  FrmNewTrip: TFrmNewTrip;

implementation

uses
  UFrmTripManager;

{$R *.dfm}

procedure TFrmNewTrip.ShowResultFile;
begin
  if (ChkDevice.Checked) then
    EdResultFile.Text := ChangeFileExt(IncludeTrailingPathDelimiter(DevicePath) + EdNewTrip.Text, '.' + TripExtension)
  else
    EdResultFile.Text := ChangeFileExt(IncludeTrailingPathDelimiter(CurPath) + EdNewTrip.Text, '.' + TripExtension);
  btnOk.Enabled := (edNewTrip.Text <> '');
end;

procedure TFrmNewTrip.ChkDeviceClick(Sender: TObject);
begin
  ShowResultFile;
end;

procedure TFrmNewTrip.EdNewTripChange(Sender: TObject);
begin
  ShowResultFile;
end;

procedure TFrmNewTrip.FormShow(Sender: TObject);
begin
  ShowResultFile;
end;

end.
