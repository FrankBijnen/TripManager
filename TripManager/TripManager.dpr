program TripManager;

uses
  {$IFDEF DEBUG}
  UnitStackTrace,
  {$ENDIF }
  MidasLib,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  UnitStringUtils,
  TripManager_MultiContext in 'TripManager_MultiContext.pas',
  TripManager_ShellList in 'TripManager_ShellList.pas',
  TripManager_ValEdit in 'TripManager_ValEdit.pas',
  UDmRoutePoints in 'UDmRoutePoints.pas' {DmRoutePoints: TDataModule},
  UFrmTripManager in 'UFrmTripManager.pas' {FrmTripManager},
  UFrmPostProcess in 'UFrmPostProcess.pas' {FrmPostProcess},
  UFrmDateDialog in 'UFrmDateDialog.pas' {FrmDateDialog},
  UFrmAdditional in 'UFrmAdditional.pas' {FrmAdditional},
  UFrmTransferOptions in 'UFrmTransferOptions.pas' {FrmTransferOptions},
  UFrmAdvSettings in 'UFrmAdvSettings.pas' {FrmAdvSettings},
  UFrmGeoSearch in 'UFrmGeoSearch.pas' {FGeoSearch},
  UFrmPlaces in 'UFrmPlaces.pas' {FrmPlaces},
  UFrmTripEditor in 'UFrmTripEditor.pas' {FrmTripEditor},
  UFrmNewTrip in 'UFrmNewTrip.pas' {FrmNewTrip};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  CreateTempPath('TRIP');

  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TDmRoutePoints, DmRoutePoints);
  Application.CreateForm(TFrmTripManager, FrmTripManager);
  Application.CreateForm(TFrmPostProcess, FrmPostProcess);
  Application.CreateForm(TFrmDateDialog, FrmDateDialog);
  Application.CreateForm(TFrmAdditional, FrmAdditional);
  Application.CreateForm(TFrmTransferOptions, FrmTransferOptions);
  Application.CreateForm(TFrmAdvSettings, FrmAdvSettings);
  Application.CreateForm(TFGeoSearch, FGeoSearch);
  Application.CreateForm(TFrmPlaces, FrmPlaces);
  Application.CreateForm(TFrmNewTrip, FrmNewTrip);
  Application.CreateForm(TFrmTripEditor, FrmTripEditor);
  Application.Run;
end.
