unit UFrmVehProfiles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  UnitGpxDefs, Vcl.ComCtrls,
  UnitDSFields, UnitSqlite;

type
  TFrmVehProfiles = class(TForm)
    CDSVehProfile: TClientDataSet;
    DsVehProfile: TDataSource;
    GrdVehProfile: TDBGrid;
    GridProfile: TStringGrid;
    PnlBottom: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    PCTMain: TPageControl;
    TabAllProfiles: TTabSheet;
    PctDetails: TPageControl;
    TabTripFiles: TTabSheet;
    TabAllFields: TTabSheet;
    PnlAllFields: TPanel;
    ScrllAllFields: TScrollBox;
    procedure FormShow(Sender: TObject);
    procedure CDSVehProfileAfterScroll(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure PnlAllFieldsMouseEnter(Sender: TObject);
    procedure PnlAllFieldsMouseLeave(Sender: TObject);
    procedure GrdVehProfileDblClick(Sender: TObject);
  private
    { Private declarations }
    InScroll: boolean;
    FDSFields: TDSFields;
    AModel: TGarminModel;
    procedure LoadProfiles;
    procedure LoadProfile;
  public
    { Public declarations }
    VehicleProfile: TVehicleProfile;
  end;

//var
//  FrmVehProfiles: TFrmVehProfiles;

implementation

uses
  System.StrUtils,
  UnitStringUtils, UnitModelConv, UnitRegistry, UnitregistryKeys,
  UnitTripDefs, TripManager_Grid;

{$R *.dfm}

procedure TFrmVehProfiles.CDSVehProfileAfterScroll(DataSet: TDataSet);
begin
  if (Dataset.state in [dsBrowse]) then
    LoadProfile;
end;

procedure TFrmVehProfiles.FormDestroy(Sender: TObject);
begin
  FDSFields.Free;
end;

procedure TFrmVehProfiles.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  Handled := false;
  if InScroll then
  begin
    ScrllAllFields.VertScrollBar.Position := ScrllAllFields.VertScrollBar.Position - WheelDelta;
    Handled := true;
  end;
end;

procedure TFrmVehProfiles.FormResize(Sender: TObject);
var
  SpaceLeft: integer;
begin
  SpaceLeft := ClientWidth - GetSystemMetrics(SM_CXVSCROLL);
  AlignGrid(GridProfile, SpaceLeft);
end;

procedure TFrmVehProfiles.FormShow(Sender: TObject);
begin
  PctDetails.ActivePage := TabTripFiles;
  LoadProfiles;

  CDSVehProfile.First;
end;

procedure TFrmVehProfiles.GrdVehProfileDblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmVehProfiles.LoadProfiles;
begin
  AModel := TModelConv.Display2Garmin(GetRegistry(Reg_CurrentModel, 0));
  if not (TModelConv.ReadVehicleDB(AModel)) then
    exit;

  if not (FileExists(GetDeviceTmp + ProfileDb)) then
    exit;

  CDSVehProfile.AfterOpen := FCDSEvents.AfterOpen;
  CDSFromQuery(GetDeviceTmp + ProfileDb,  GetAllVehicleProfilesQuery(AModel), CDSVehProfile);
end;

procedure TFrmVehProfiles.PnlAllFieldsMouseEnter(Sender: TObject);
begin
  InScroll := true;
end;

procedure TFrmVehProfiles.PnlAllFieldsMouseLeave(Sender: TObject);
begin
  InScroll := false;
end;

procedure TFrmVehProfiles.LoadProfile;
var
  CurRow: integer;
begin
  if not Assigned(FDSFields) then
    FDSFields := TDSFields.Create(PnlAllFields, DsVehProfile);

  VehicleProfile.FromCds(CDSVehProfile, AModel);
  GridProfile.RowCount := GridProfile.FixedRows +1;
  GridProfile.BeginUpdate;
  try
    CurRow := 1;
    AddGridValueLine(GridProfile, CurRow, '', '', '-Items saved in trip files-');

    AddGridValueLine(GridProfile, CurRow, Reg_VehicleId,               VehicleProfile.Vehicle_Id);
    AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileName,      VehicleProfile.Name);
    AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileGuid,      VehicleProfile.GUID);
    AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileHash,      VehicleProfile.Proposed_Hash,
                                          '(TripManager Proposed Hash)');
    AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileTruckType, VehicleProfile.TruckType,
                                          '(7=Motorcycle, 11=Car)');

    AddGridValueLine(GridProfile, CurRow, '', '');
    AddGridValueLine(GridProfile, CurRow, '', '', '-Items needed to compute Hash-');
    AddGridValueLine(GridProfile, CurRow, Reg_VehicleTraction,         VehicleProfile.Traction,
                                          '(1=2WD, 2=4WD, 3=3 Wheels, 4=2 Wheels)');
    if (CDSVehProfile.FindField('environmental') <> nil) then
      AddGridValueLine(GridProfile, CurRow, Reg_VehicleEnvironmental,    VehicleProfile.Environmental,
                                            '(0=Avoid, 1=Allow, 2=Ask)');

    AddGridValueLine(GridProfile, CurRow, Reg_VehicleLegality,         VehicleProfile.Legality,
                                          '(0=Not legal, 1=Not highway legal, 2=Legal');

    if (CDSVehProfile.FindField('calc_method') <> nil) then
      AddGridValueLine(GridProfile, CurRow, Reg_VehicleCalcMethod,       VehicleProfile.Calc_Method,
                                            '(0=Faster, 1=Shorter, 4=Straight, 7=Adventurous)');

    AddGridValueLine(GridProfile, CurRow, Reg_DefAdvLevel,             VehicleProfile.AdventurousLevel,
                                          '(0=L1, 1=L2, 2=L3, 3=L4)');
    AddGridValueLine(GridProfile, CurRow, 'Max Speed',                 VehicleProfile.Max_Speed,
                                          '(Meters/Sec.)');
    AddGridValueLine(GridProfile, CurRow, 'Vehicle Width',             VehicleProfile.Width,
                                          '(Centimeters)');
    AddGridValueLine(GridProfile, CurRow, 'Imperial',                  VehicleProfile.Imperial,
                                          '(True=Miles, False=Kms)');
    AddGridValueLine(GridProfile, CurRow, 'Last modified',             Format('0x%s', [IntToHex(VehicleProfile.Modified, 8)]),
                                          'Date: ');

    AddGridValueLine(GridProfile, CurRow,   '', '');

    GridProfile.RowCount := CurRow;
    AddGridHeader(GridProfile);

  finally
    GridProfile.EndUpdate;
  end;
end;


end.

