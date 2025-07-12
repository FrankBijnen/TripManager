// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'UFrmTripEditor.pas' rev: 36.00 (Windows)

#ifndef UFrmTripEditorHPP
#define UFrmTripEditorHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Vcl.Mask.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ToolWin.hpp>
#include <Vcl.BaseImageCollection.hpp>
#include <Vcl.ImageCollection.hpp>
#include <System.ImageList.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.VirtualImageList.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.DBGrids.hpp>
#include <Data.DB.hpp>
#include <unitTripObjects.hpp>
#include <TripManager_DBGrid.hpp>

//-- user supplied -----------------------------------------------------------

namespace Ufrmtripeditor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TFrmTripEditor;
//-- type declarations -------------------------------------------------------
typedef System::Classes::TNotifyEvent TTripFileUpdate;

typedef void __fastcall (__closure *TRoutePointsShowing)(System::TObject* Sender, bool Showing);

class PASCALIMPLEMENTATION TFrmTripEditor : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* PnlBottom;
	Vcl::Buttons::TBitBtn* BtnOk;
	Vcl::Buttons::TBitBtn* BtnCancel;
	Tripmanager_dbgrid::TDBGrid* DBGRoutePoints;
	Vcl::Extctrls::TPanel* PnlRoute;
	Vcl::Dbctrls::TDBEdit* DbTripName;
	Vcl::Dbctrls::TDBComboBox* DBCRoutePreference;
	Vcl::Dbctrls::TDBComboBox* DBCTransportationMode;
	Vcl::Comctrls::TDateTimePicker* DTDepartureDate;
	Vcl::Stdctrls::TGroupBox* GrpRoute;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TComboBox* CmbModel;
	Vcl::Menus::TPopupMenu* PopupGrid;
	Vcl::Menus::TMenuItem* MoveUp1;
	Vcl::Menus::TMenuItem* MoveDown1;
	Vcl::Menus::TMenuItem* N1;
	Vcl::Menus::TMenuItem* Insert1;
	Vcl::Menus::TMenuItem* Delete1;
	Vcl::Comctrls::TToolBar* TBBRoutePoints;
	Vcl::Comctrls::TToolButton* TbMoveUp;
	Vcl::Comctrls::TToolButton* TbInsertPoint;
	Vcl::Comctrls::TToolButton* TbDeletePoint;
	Vcl::Comctrls::TToolButton* TBMoveDown;
	Vcl::Virtualimagelist::TVirtualImageList* VirtImgListRoutePoints;
	Vcl::Imagecollection::TImageCollection* ImgColRoutePoints;
	Vcl::Extctrls::TPanel* PnlRoutePointsButtons;
	Vcl::Extctrls::TPanel* PnlFiller;
	Vcl::Comctrls::TToolButton* TbLookupAddress;
	Vcl::Menus::TMenuItem* Selectall1;
	Vcl::Menus::TMenuItem* N2;
	Vcl::Dialogs::TSaveDialog* SaveTrip;
	Vcl::Comctrls::TToolButton* TBGPXExp_Imp;
	Vcl::Menus::TPopupMenu* PopupGPX;
	Vcl::Menus::TMenuItem* ImportGPX;
	Vcl::Dialogs::TOpenDialog* OpenTrip;
	Vcl::Menus::TMenuItem* N3;
	Vcl::Menus::TMenuItem* Copy1;
	Vcl::Menus::TMenuItem* Cut1;
	Vcl::Menus::TMenuItem* Paste1;
	Vcl::Comctrls::TToolButton* TBCSVExp_Imp;
	Vcl::Menus::TPopupMenu* PopupCSV;
	Vcl::Menus::TMenuItem* ImportCSV;
	Vcl::Menus::TMenuItem* ExportCSV;
	void __fastcall BtnOkClick(System::TObject* Sender);
	void __fastcall BtnCancelClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormHide(System::TObject* Sender);
	void __fastcall MoveUp1Click(System::TObject* Sender);
	void __fastcall MoveDown1Click(System::TObject* Sender);
	void __fastcall Insert1Click(System::TObject* Sender);
	void __fastcall Delete1Click(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall DBGRoutePointsKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall TbInsertPointClick(System::TObject* Sender);
	void __fastcall TbDeletePointClick(System::TObject* Sender);
	void __fastcall TbMoveUpClick(System::TObject* Sender);
	void __fastcall TBMoveDownClick(System::TObject* Sender);
	void __fastcall TbLookupAddressClick(System::TObject* Sender);
	void __fastcall Selectall1Click(System::TObject* Sender);
	void __fastcall ExportGpxClick(System::TObject* Sender);
	void __fastcall ImportGPXClick(System::TObject* Sender);
	void __fastcall Copy1Click(System::TObject* Sender);
	void __fastcall Cut1Click(System::TObject* Sender);
	void __fastcall Paste1Click(System::TObject* Sender);
	void __fastcall PnlRouteResize(System::TObject* Sender);
	void __fastcall ImportCSVClick(System::TObject* Sender);
	void __fastcall ExportCSVClick(System::TObject* Sender);
	
private:
	TTripFileUpdate FTripFileUpdating;
	TTripFileUpdate FTripFileCanceled;
	TTripFileUpdate FTripFileUpdated;
	TRoutePointsShowing FRoutePointsShowing;
	void __fastcall CopyToClipBoard(bool Cut);
	
public:
	System::UnicodeString CurPath;
	Unittripobjects::TTripList* CurTripList;
	System::UnicodeString CurFile;
	bool CurNewFile;
	bool CurDevice;
	Unittripobjects::TZumoModel CurModel;
	__property TTripFileUpdate OnTripFileCanceled = {read=FTripFileCanceled, write=FTripFileCanceled};
	__property TTripFileUpdate OnTripFileUpdating = {read=FTripFileUpdating, write=FTripFileUpdating};
	__property TTripFileUpdate OnTripFileUpdated = {read=FTripFileUpdated, write=FTripFileUpdated};
	__property TRoutePointsShowing OnRoutePointsShowing = {read=FRoutePointsShowing, write=FRoutePointsShowing};
public:
	/* TCustomForm.Create */ inline __fastcall virtual TFrmTripEditor(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TFrmTripEditor(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.CreateScaledNew */ inline __fastcall virtual TFrmTripEditor(System::Classes::TComponent* AOwner, int ADPI, int Dummy) : Vcl::Forms::TForm(AOwner, ADPI, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TFrmTripEditor() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TFrmTripEditor(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TFrmTripEditor* FrmTripEditor;
}	/* namespace Ufrmtripeditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_UFRMTRIPEDITOR)
using namespace Ufrmtripeditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// UFrmTripEditorHPP
