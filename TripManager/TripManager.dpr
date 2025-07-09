program TripManager;

{$R 'OpenLayers2.res' '..\CommonUnits\osm\Resources\OpenLayers2.rc'}

{.$DEFINE Debug_CallStack}

uses
  {$IFDEF Debug_CallStack}
  UnitStackTrace in 'UnitStackTrace.pas',
  {$ENDIF }
  MidasLib,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  UDmRoutePoints in 'UDmRoutePoints.pas' {DmRoutePoints: TDataModule},
  UFrmTripManager in 'UFrmTripManager.pas' {FrmTripManager},
  UFrmPostProcess in 'UFrmPostProcess.pas' {FrmPostProcess},
  UFrmDateDialog in 'UFrmDateDialog.pas' {FrmDateDialog},
  UFrmTransferOptions in 'UFrmTransferOptions.pas' {FrmTransferOptions},
  UFrmAdditional in 'UFrmAdditional.pas' {FrmAdditional},
  UFrmSendTo in 'UFrmSendTo.pas' {FrmSendTo},
  UFrmAdvSettings in 'UFrmAdvSettings.pas' {FrmAdvSettings},
  UFrmTripEditor in 'UFrmTripEditor.pas' {FrmTripEditor},
  UFrmNewTrip in 'UFrmNewTrip.pas' {FrmNewTrip},
  UFrmShowLog in 'UFrmShowLog.pas' {FrmShowLog},
  UnitRegistryKeys in 'UnitRegistryKeys.pas',
  TripManager_MultiContext in 'TripManager_MultiContext.pas',
  TripManager_ShellTree in 'TripManager_ShellTree.pas',
  TripManager_ShellList in 'TripManager_ShellList.pas',
  TripManager_ValEdit in 'TripManager_ValEdit.pas',
  TripManager_DBGrid in 'TripManager_DBGrid.pas',
  TripManager_GridSelItem in 'TripManager_GridSelItem.pas',
  UnitRegistry in '..\CommonUnits\UnitRegistry.pas',
  BCHexEditor in '..\CommonUnits\BCHex\BCHexEditor.pas',
  Monitor in '..\CommonUnits\DirMon\Monitor.pas',
  ogckml23 in '..\CommonUnits\kml\ogckml23.pas',
  kml_helper in '..\CommonUnits\kml\kml_helper.pas',
  UnitListViewSort in '..\CommonUnits\UnitListViewSort.pas',
  mtp_helper in '..\CommonUnits\Mtp\mtp_helper.pas',
  UnitMtpDevice in '..\CommonUnits\Mtp\UnitMtpDevice.pas',
  PortableDeviceApiLib_TLB in '..\CommonUnits\Mtp\PortableDeviceApiLib_TLB.pas',
  UnitOSMMap in '..\CommonUnits\osm\UnitOSMMap.pas',
  UnitVerySimpleXml in '..\CommonUnits\VerySimpleXml\UnitVerySimpleXml.pas',
  Xml.VerySimple in '..\CommonUnits\VerySimpleXml\Xml.VerySimple.pas',
  MsgLoop in '..\CommonUnits\MsgLoop.pas',
  UnitBmp in '..\CommonUnits\UnitBmp.pas',
  UnitGeoCode in '..\CommonUnits\UnitGeoCode.pas',
  UnitGpi in '..\CommonUnits\UnitGpi.pas',
  UnitStringUtils in '..\CommonUnits\UnitStringUtils.pas',
  UnitTripObjects in '..\CommonUnits\UnitTripObjects.pas',
  UnitGpxObjects in '..\CommonUnits\UnitGpxObjects.pas',
  UnitGpxTripCompare in '..\CommonUnits\UnitGpxTripCompare.pas',
  UnitUSBEvent in '..\CommonUnits\UnitUSBEvent.pas',
  UnitGpxDefs in '..\CommonUnits\UnitGpxDefs.pas',
  UnitProcessOptions in '..\CommonUnits\UnitProcessOptions.pas',
  UFrmSelectGPX in '..\CommonUnits\UFrmSelectGPX.pas' {FrmSelectGPX},
  UFrmGeoSearch in '..\CommonUnits\UFrmGeoSearch.pas' {FGeoSearch},
  UFrmPlaces in '..\CommonUnits\UFrmPlaces.pas' {FrmPlaces};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
  Application.Title := 'TripManager';

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  CreateTempPath('TRIP');

  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TDmRoutePoints, DmRoutePoints);
  Application.CreateForm(TFrmTripManager, FrmTripManager);
  Application.CreateForm(TFrmPostProcess, FrmPostProcess);
  Application.CreateForm(TFrmDateDialog, FrmDateDialog);
  Application.CreateForm(TFrmAdditional, FrmAdditional);
  Application.CreateForm(TFrmSendTo, FrmSendTo);
  Application.CreateForm(TFrmAdvSettings, FrmAdvSettings);
  Application.CreateForm(TFrmNewTrip, FrmNewTrip);
  Application.CreateForm(TFrmTripEditor, FrmTripEditor);
  Application.CreateForm(TFGeoSearch, FGeoSearch);
  Application.CreateForm(TFrmPlaces, FrmPlaces);
  Application.CreateForm(TFrmTransferOptions, FrmTransferOptions);
  Application.CreateForm(TFrmShowLog, FrmShowLog);
  Application.Run;
end.
