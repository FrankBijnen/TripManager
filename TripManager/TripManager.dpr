program TripManager;

{$R 'OpenLayers2.res' '..\CommonUnits\osm\Resources\OpenLayers2.rc'}

{.$DEFINE Debug_CallStack}

uses
  {$IFDEF Debug_CallStack}
  UnitStackTrace,
  {$ENDIF }
  MidasLib,
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  UDmRoutePoints in 'UDmRoutePoints.pas' {DmRoutePoints: TDataModule},
  UFrmTripManager in 'UFrmTripManager.pas' {FrmTripManager},
  UFrmPostProcess in 'UFrmPostProcess.pas' {FrmPostProcess},
  UFrmDateDialog in 'UFrmDateDialog.pas' {FrmDateDialog},
  UFrmSendTo in 'UFrmSendTo.pas' {FrmSendTo},
  UFrmAdvSettings in 'UFrmAdvSettings.pas' {FrmAdvSettings},
  UFrmTripEditor in 'UFrmTripEditor.pas' {FrmTripEditor},
  UFrmNewTrip in 'UFrmNewTrip.pas' {FrmNewTrip},
  UFrmShowLog in 'UFrmShowLog.pas' {FrmShowLog},
  UFrmEditRoutePref in 'UFrmEditRoutePref.pas' {FrmEditRoutePref},
  UnitRegistry in '..\CommonUnits\UnitRegistry.pas',
  BCHexEditor in '..\CommonUnits\BCHex\BCHexEditor.pas',
  Monitor in '..\CommonUnits\DirMon\Monitor.pas',
  kml_helper in '..\CommonUnits\kml\kml_helper.pas',
  UnitListViewSort in '..\CommonUnits\UnitListViewSort.pas',
  mtp_helper in '..\CommonUnits\Mtp\mtp_helper.pas',
  UnitMtpDevice in '..\CommonUnits\Mtp\UnitMtpDevice.pas',
  UnitOSMMap in '..\CommonUnits\osm\UnitOSMMap.pas',
  UnitVerySimpleXml in '..\CommonUnits\VerySimpleXml\UnitVerySimpleXml.pas',
  Xml.VerySimple in '..\CommonUnits\VerySimpleXml\Xml.VerySimple.pas',
  MsgLoop in '..\CommonUnits\MsgLoop.pas',
  UnitBmp in '..\CommonUnits\UnitBmp.pas',
  UnitGeoCode in '..\CommonUnits\UnitGeoCode.pas',
  UnitGpi in '..\CommonUnits\UnitGpi.pas',
  UnitStringUtils in '..\CommonUnits\UnitStringUtils.pas',
  UnitTripDefs in '..\CommonUnits\UnitTripDefs.pas',
  UnitGpxDefs in '..\CommonUnits\UnitGpxDefs.pas',
  UnitTripObjects in '..\CommonUnits\UnitTripObjects.pas',
  UnitGpxObjects in '..\CommonUnits\UnitGpxObjects.pas',
  UnitGpxTripCompare in '..\CommonUnits\UnitGpxTripCompare.pas',
  UnitProcessOptions in '..\CommonUnits\UnitProcessOptions.pas',
  UFrmSelectGPX in '..\CommonUnits\UFrmSelectGPX.pas' {FrmSelectGPX},
  UFrmGeoSearch in '..\CommonUnits\UFrmGeoSearch.pas' {FGeoSearch},
  UFrmPlaces in '..\CommonUnits\UFrmPlaces.pas' {FrmPlaces},
  UnitUSBEvent in '..\CommonUnits\UnitUSBEvent.pas',
  UnitTripOverview in '..\CommonUnits\UnitTripOverview.pas',
  UnitRedirect in '..\CommonUnits\UnitRedirect.pas',
  UnitRegistryKeys;

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}
  Application.Title := 'TripManager';

  // Commandline process requested (/pp gpxmask)
  if (TGPXFile.CmdLinePostProcess(SetProcessOptions.SetCmdLinePrefs)) then
  begin
    Application.Terminate; // Call finalizations
    halt(0);               // Exit 0
  end;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  CreateTempPath('TRIP');

  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(TDmRoutePoints, DmRoutePoints);
  Application.CreateForm(TFrmTripManager, FrmTripManager);
  Application.CreateForm(TFrmPostProcess, FrmPostProcess);
  Application.CreateForm(TFrmDateDialog, FrmDateDialog);
  Application.CreateForm(TFrmSendTo, FrmSendTo);
  Application.CreateForm(TFrmAdvSettings, FrmAdvSettings);
  Application.CreateForm(TFrmNewTrip, FrmNewTrip);
  Application.CreateForm(TFrmTripEditor, FrmTripEditor);
  Application.CreateForm(TFGeoSearch, FGeoSearch);
  Application.CreateForm(TFrmPlaces, FrmPlaces);
  Application.CreateForm(TFrmShowLog, FrmShowLog);
  Application.CreateForm(TFrmEditRoutePref, FrmEditRoutePref);
  Application.Run;
end.
