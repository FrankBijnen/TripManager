program TripManager;

{$R 'OpenLayers2.res' '..\CommonUnits\osm\Resources\OpenLayers2.rc'}

uses
  {$IFDEF Debug_CallStack}
  UnitStackTrace in 'UnitStackTrace.pas',
  {$ENDIF}
  MidasLib,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,

// Forms
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
  UFrmNewTrip in 'UFrmNewTrip.pas' {FrmNewTrip},

// Control extensions
  TripManager_MultiContext in 'TripManager_MultiContext.pas',
  TripManager_ShellList in 'TripManager_ShellList.pas',
  TripManager_ValEdit in 'TripManager_ValEdit.pas',

// Common
  BCHexEditor in '..\CommonUnits\BCHex\BCHexEditor.pas',
  Monitor in '..\CommonUnits\DirMon\Monitor.pas',
  ogckml23 in '..\CommonUnits\kml\ogckml23.pas',
  kml_helper in '..\CommonUnits\kml\kml_helper.pas',
  ListViewSort in '..\CommonUnits\LVSort\ListViewSort.pas',
  mtp_helper in '..\CommonUnits\Mtp\mtp_helper.pas',
  UnitMtpDevice in '..\CommonUnits\Mtp\UnitMtpDevice.pas',
  PortableDeviceApiLib_TLB in '..\CommonUnits\Mtp\PortableDeviceApiLib_TLB.pas',
  OSM_helper in '..\CommonUnits\osm\OSM_helper.pas',
  UnitOSMMap in '..\CommonUnits\osm\UnitOSMMap.pas',
  Vcl.Shell.ShellConsts in '..\CommonUnits\Vcl.ShellControls\Vcl.Shell.ShellConsts.pas',
  Vcl.Shell.ShellCtrls in '..\CommonUnits\Vcl.ShellControls\Vcl.Shell.ShellCtrls.pas',
  UnitVerySimpleXml in '..\CommonUnits\VerySimpleXml\UnitVerySimpleXml.pas',
  Xml.VerySimple in '..\CommonUnits\VerySimpleXml\Xml.VerySimple.pas',
  MsgLoop in '..\CommonUnits\MsgLoop.pas',
  UFrmSelectGPX in '..\CommonUnits\UFrmSelectGPX.pas' {FrmSelectGPX},
  UnitBmp in '..\CommonUnits\UnitBmp.pas',
  UnitGeoCode in '..\CommonUnits\UnitGeoCode.pas',
  UnitGpi in '..\CommonUnits\UnitGpi.pas',
  UnitGpx in '..\CommonUnits\UnitGpx.pas',
  UnitStringUtils in '..\CommonUnits\UnitStringUtils.pas',
  UnitTripObjects in '..\CommonUnits\UnitTripObjects.pas';

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
  Application.CreateForm(TFrmSelectGPX, FrmSelectGPX);
  Application.Run;
end.
