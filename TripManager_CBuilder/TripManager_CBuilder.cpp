//---------------------------------------------------------------------------

#include <vcl.h>
#pragma link "xmlrtl.bpi"
#pragma link "RESTComponents.bpi"
#pragma link "vclimg.bpi"
#pragma link "soaprtl.bpi"
#pragma link "dbrtl.bpi"
#pragma link "dsnap.bpi"
#pragma link "vclwinx.bpi"
#pragma link "vcldb.bpi"
#pragma hdrstop
#include "..\CommonUnits\UnitStringUtils.hpp"
#include <tchar.h>

//---------------------------------------------------------------------------
#include <Vcl.Styles.hpp>
#include <Vcl.Themes.hpp>
USEFORMNS("..\CommonUnits\UFrmGeoSearch.pas", Ufrmgeosearch, FGeoSearch);
USEFORMNS("..\CommonUnits\UFrmPlaces.pas", Ufrmplaces, FrmPlaces);
USEFORMNS("..\CommonUnits\UFrmSelectGPX.pas", Ufrmselectgpx, FrmSelectGPX);
USEFORMNS("..\TripManager\UFrmAdditional.pas", Ufrmadditional, FrmAdditional);
USEFORMNS("..\TripManager\UFrmAdvSettings.pas", Ufrmadvsettings, FrmAdvSettings);
USEFORMNS("..\TripManager\UFrmDateDialog.pas", Ufrmdatedialog, FrmDateDialog);
USEFORMNS("..\TripManager\UFrmNewTrip.pas", Ufrmnewtrip, FrmNewTrip);
USEFORMNS("..\TripManager\UFrmPostProcess.pas", Ufrmpostprocess, FrmPostProcess);
USEFORMNS("..\TripManager\UFrmTransferOptions.pas", Ufrmtransferoptions, FrmTransferOptions);
USEFORMNS("..\TripManager\UFrmTripEditor.pas", Ufrmtripeditor, FrmTripEditor);
USEFORMNS("..\TripManager\UFrmTripManager.pas", Ufrmtripmanager, FrmTripManager);
USEFORMNS("..\TripManager\UDmRoutePoints.pas", Udmroutepoints, DmRoutePoints); /* TDataModule: File Type */
//---------------------------------------------------------------------------
int WINAPI _tWinMain(HINSTANCE, HINSTANCE, LPTSTR, int)
{
    try
	{
		 Application->Initialize();
		 Application->MainFormOnTaskBar = true;
         CreateTempPath('TRIP');
		 TStyleManager::TrySetStyle("Sapphire Kamri");
		Application->CreateForm(__classid(TFrmTripManager), &FrmTripManager);
		Application->CreateForm(__classid(TFGeoSearch), &FGeoSearch);
		Application->CreateForm(__classid(TFrmPlaces), &FrmPlaces);
		Application->CreateForm(__classid(TFrmAdditional), &FrmAdditional);
		Application->CreateForm(__classid(TFrmAdvSettings), &FrmAdvSettings);
		Application->CreateForm(__classid(TFrmDateDialog), &FrmDateDialog);
		Application->CreateForm(__classid(TFrmNewTrip), &FrmNewTrip);
		Application->CreateForm(__classid(TFrmPostProcess), &FrmPostProcess);
		Application->CreateForm(__classid(TFrmTransferOptions), &FrmTransferOptions);
		Application->CreateForm(__classid(TFrmTripEditor), &FrmTripEditor);
		Application->CreateForm(__classid(TDmRoutePoints), &DmRoutePoints);
		Application->Run();
    }
    catch (Exception &exception)
    {
         Application->ShowException(&exception);
    }
    catch (...)
    {
         try
         {
             throw Exception("");
         }
         catch (Exception &exception)
         {
             Application->ShowException(&exception);
         }
    }
    return 0;
}
//---------------------------------------------------------------------------
