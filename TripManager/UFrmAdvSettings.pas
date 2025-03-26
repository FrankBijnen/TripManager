unit UFrmAdvSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.ValEdit;

type
  TFrmAdvSettings = class(TForm)
    BtnOK: TButton;
    BtnCancel: TButton;
    PnlBottom: TPanel;
    ValueListEditor1: TValueListEditor;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSettings;
    procedure SaveSettings;
  public
    { Public declarations }
  end;

var
  FrmAdvSettings: TFrmAdvSettings;

implementation

uses
  UnitStringUtils, UFrmTripManager;

{$R *.dfm}

procedure TFrmAdvSettings.LoadSettings;

  procedure AddKey(AKey: string; DefaultValue: string = '');
  begin
    ValueListEditor1.Strings.AddPair(AKey, GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, AKey, DefaultValue));
  end;

begin
  ValueListEditor1.Strings.BeginUpdate;
  try
    ValueListEditor1.Strings.Clear;
    AddKey('ExploreUuid');       // No default
    AddKey('VehicleProfileGuid', XT2_VehicleProfileGuid);
    AddKey('VehicleProfileHash', XT2_VehicleProfileHash);
    AddKey('VehicleId',          XT2_VehicleId);
  finally
    ValueListEditor1.Strings.EndUpdate;
  end;
end;

procedure TFrmAdvSettings.SaveSettings;
var
  Index: integer;
begin
  for Index := 0 to ValueListEditor1.Strings.Count -1 do
  begin
    SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key,
                     ValueListEditor1.Strings.KeyNames[Index], ValueListEditor1.Strings.ValueFromIndex[Index]);
  end;
end;

procedure TFrmAdvSettings.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = mrOk then
    SaveSettings;
end;

procedure TFrmAdvSettings.FormShow(Sender: TObject);
begin
  LoadSettings;
end;

end.
