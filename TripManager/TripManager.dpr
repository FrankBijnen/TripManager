program TripManager;

uses
  Vcl.Forms,
  UnitStringUtils,
  UFrmTripManager in 'UFrmTripManager.pas' {FrmTripManager},
  UFrmPostProcess in 'UFrmPostProcess.pas' {FrmPostProcess},
  UFrmDateDialog in 'UFrmDateDialog.pas' {FrmDateDialog},
  UFrmAdditional in 'UFrmAdditional.pas' {FrmAdditional},
  UFrmTransferOptions in 'UFrmTransferOptions.pas' {FrmTransferOptions},
  TripManager_MultiContext in 'TripManager_MultiContext.pas',
  TripManager_ShellList in 'TripManager_ShellList.pas',
  UFrmAdvSettings in 'UFrmAdvSettings.pas' {FrmAdvSettings},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  CreateTempPath('TRIP');

  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TFrmTripManager, FrmTripManager);
  Application.CreateForm(TFrmPostProcess, FrmPostProcess);
  Application.CreateForm(TFrmDateDialog, FrmDateDialog);
  Application.CreateForm(TFrmAdditional, FrmAdditional);
  Application.CreateForm(TFrmTransferOptions, FrmTransferOptions);
  Application.CreateForm(TFrmAdvSettings, FrmAdvSettings);
  Application.Run;
end.
