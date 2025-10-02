unit UFrmNewTrip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls,
  UnitMtpDevice;

type
  TFrmNewTrip = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BtnOk: TBitBtn;
    EdNewTrip: TEdit;
    EdResultFile: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure ChkDeviceClick(Sender: TObject);
    procedure EdNewTripChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    procedure ShowResultFile;
    function CheckTripExists: boolean;
  public
    { Public declarations }
    SavedFolderId: string;
    CurrentDevice: TMTP_Device;
    DevicePath: string;
    CurPath: string;
  end;

var
  FrmNewTrip: TFrmNewTrip;

implementation

uses
  UFrmTripManager, mtp_helper;

{$R *.dfm}

procedure TFrmNewTrip.ShowResultFile;
begin
  if (CurrentDevice <> nil) then
    EdResultFile.Text := ChangeFileExt(IncludeTrailingPathDelimiter(DevicePath) + EdNewTrip.Text, TripExtension)
  else
    EdResultFile.Text := ChangeFileExt(IncludeTrailingPathDelimiter(CurPath) + EdNewTrip.Text, TripExtension);
  BtnOk.Enabled := (EdNewTrip.Text <> '');
end;

function TFrmNewTrip.CheckTripExists: boolean;
var
  NFile, CurrentObjectId: string;
begin
  result := false;
  if (CurrentDevice <> nil) then
  begin
    NFile := ExtractFileName(EdResultFile.Text);
    CurrentObjectId := GetIdForFile(CurrentDevice.PortableDev, SavedFolderId, NFile);
    if (CurrentObjectId <> '') then
      exit(true);
  end
  else
  begin
    if (FileExists(EdResultFile.Text)) then
      exit(true);
  end;
end;

procedure TFrmNewTrip.ChkDeviceClick(Sender: TObject);
begin
  ShowResultFile;
end;

procedure TFrmNewTrip.EdNewTripChange(Sender: TObject);
begin
  ShowResultFile;
end;

procedure TFrmNewTrip.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := (ModalResult <> mrOk) or not CheckTripExists;

  if not CanClose then
     ShowMessage(Format('Trip %s exists', [EdNewTrip.Text]));
end;

procedure TFrmNewTrip.FormShow(Sender: TObject);
begin
  ShowResultFile;
end;

end.
