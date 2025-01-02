//---------------------------------------------------------------------------

#include <vcl.h>
#pragma link "xmlrtl.bpi"
#pragma link "RESTComponents.bpi"
#pragma link "vclimg.bpi"
#pragma link "soaprtl.bpi"
#pragma hdrstop
#include <tchar.h>
#include "UnitStringUtils.hpp"

//---------------------------------------------------------------------------
#include <Vcl.Styles.hpp>
#include <Vcl.Themes.hpp>
USEFORMNS("..\TripManager\UFrmTripManager.pas", Ufrmtripmanager, FrmTripManager);
USEFORMNS("..\TripManager\UFrmPostProcess.pas", Ufrmpostprocess, FrmPostProcess);
USEFORMNS("..\TripManager\UFrmDateDialog.pas", Ufrmdatedialog, FrmDateDialog);
USEFORMNS("..\TripManager\UFrmAdditional.pas", Ufrmadditional, FrmAdditional);
USEFORMNS("..\TripManager\UFrmTransferOptions.pas", Ufrmtransferoptions, FrmTransferOptions);
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
         Application->CreateForm(__classid(TFrmPostProcess), &FrmPostProcess);
         Application->CreateForm(__classid(TFrmDateDialog), &FrmDateDialog);
         Application->CreateForm(__classid(TFrmAdditional), &FrmAdditional);
         Application->CreateForm(__classid(TFrmTransferOptions), &FrmTransferOptions);
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
