unit UFrmVehProfiles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Datasnap.DBClient, Vcl.Grids,
  Vcl.DBGrids, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  UnitGpxDefs, Vcl.ComCtrls,
  UnitDSFields, UnitSqlite, UnitVehProfile, UnitStringGrid;

type
  TFrmVehProfiles = class(TForm)
    CDSVehProfile: TClientDataSet;
    DsVehProfile: TDataSource;
    GrdVehProfile: TDBGrid;
    GridProfile: UnitStringGrid.TStringGrid;
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
    BtnUnitTest: TButton;
    BtnLookupHash: TButton;
    SaveUnitTestDialog: TSaveDialog;
    SpltGridDetail: TSplitter;
    TabHashList: TTabSheet;
    GridHashList: TStringGrid;
    PnlHashFunc: TPanel;
    BtnDeleteHashList: TButton;
    BtnSaveHash: TButton;
    BtnCleanUp: TButton;
    procedure FormShow(Sender: TObject);
    procedure CDSVehProfileAfterScroll(DataSet: TDataSet);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure PnlAllFieldsMouseEnter(Sender: TObject);
    procedure PnlAllFieldsMouseLeave(Sender: TObject);
    procedure GrdVehProfileDblClick(Sender: TObject);
    procedure CDSVehProfileBeforePost(DataSet: TDataSet);
    procedure BtnUnitTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure BtnLookupHashClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GrdVehProfileTitleClick(Column: TColumn);
    procedure BtnDeleteHashListClick(Sender: TObject);
    procedure BtnSaveHashClick(Sender: TObject);
    procedure PctDetailsChange(Sender: TObject);
    procedure GridHashListSelectCell(Sender: TObject; ACol, ARow: {$IFDEF VER350}Integer{$ELSE}Longint{$ENDIF};
      var CanSelect: Boolean);
    procedure BtnCleanUpClick(Sender: TObject);
  private
    { Private declarations }
    ManualUpdate: boolean;
    InScroll: boolean;
    FDSFields: TDSFields;
    CurModel: TGarminModel;
    OrderBy: string;
    AscDesc: string;
    function ExistProfile(const FieldName, FieldValue: string): boolean;
    procedure RefreshRecord;
    procedure GridModified(Sender: TObject; ACol, ARow: LongInt; var Value: string);
    procedure SetOverridden_Hash(const NewHash: cardinal);
    procedure GrdModified(Sender: TObject; ACol, ARow: Longint; var Value: string);
    procedure LoadProfiles;
    procedure LoadHashList;
    procedure LoadProfile;
  public
    { Public declarations }
    SubKey: string;
    VehicleProfile: TVehicleProfile;
  end;

//var FrmVehProfiles: TFrmVehProfiles;

implementation

uses
  System.StrUtils, System.TypInfo,
  UnitStringUtils, UnitModelConv, UnitRegistry, UnitregistryKeys,
  UnitTripDefs, UnitTripObjects, TripManager_Grid;

{$R *.dfm}

const
  Arrow_Up    = #$25b2;
  Arrow_Down  = #$25bc;
  Sort_Asc    = 'Asc';
  Sort_Desc   = 'Desc';

procedure TFrmVehProfiles.BtnUnitTestClick(Sender: TObject);
var
  P: TVehicleProfile;
  F: TextFile;

  procedure Generic_Tests(TruckType: TVehicleTruckType;
                          Traction: TTraction;
                          Imperial: boolean);

  const
    BoolValues: array[boolean] of string =        ('False', 'True');
    SpeedsDMSec: array[0..3] of integer =         (0, 138, 222, 277); //DMSec
    Speeds: array[0..3] of integer =              (0,  50,  80, 100); //Kmh
    Widths3W: array[0..7] of integer =            (110, 120, 125, 130, 140, 150, 155, 170);
    WidthsMetric: array[0..0] of integer =        (120);
    WidthsImperial: array[0..0] of integer =      (122);
    CarWidthsMetric: array[0..8] of integer =     (150, 155, 170, 185, 190, 200, 215, 220, 230);
    CarWidthsImperial: array[0..0] of integer =   (198);

  var
    PName: string;
    Legal: TRoadLegality;
    Environment: TProfEnvironment;
    CalcMethod: TProfCalcMethod;
    Advlevel: integer;
    Clearance: boolean;
    ToClearance: boolean;
    WidthsArray: TDynArrayType;
    SpeedsArray: TDynArrayType;
    Width: integer;
    Speed, SpeedCnt: integer;
  begin
    P := Default(TVehicleProfile);
    P.Truck_Type := Ord(TruckType);
    P.Traction := Ord(Traction);
    P.Imperial := Imperial;

    SpeedsArray := DynArray(SpeedsDMSec);
    if (Traction = TTraction.tr3Wheels) then
      WidthsArray := DynArray(Widths3W)
    else if (Imperial) then
    begin
      if (TruckType = TVehicleTruckType.ttCar) then
        WidthsArray := DynArray(CarWidthsImperial)
      else
        WidthsArray := DynArray(WidthsImperial)
    end else
    begin
      if (TruckType = TVehicleTruckType.ttCar) then
        WidthsArray := DynArray(CarWidthsMetric)
      else
        WidthsArray := DynArray(WidthsMetric)
    end;

    P.Max_Vehicle_Speed := 0;
    ToClearance := (TruckType = TVehicleTruckType.ttCar);
    for Clearance := False to ToClearance do
    begin
      for Legal := Low(TRoadLegality) to High(TRoadLegality) do
      begin
        for Environment := Low(TProfEnvironment) to High(TProfEnvironment) do
        begin
          for Width in WidthsArray do
          begin
            SpeedCnt := -1;
            for Speed in SpeedsArray do
            begin
              Inc(SpeedCnt);
              for CalcMethod := Low(TProfCalcMethod) to High(TProfCalcMethod) do
              begin
                if (ProfCalcMethodDesc[CalcMethod] = '') then
                  continue;
                PName := Format('%s%s%s%s%s%s%d%s%d%s%s%s%s%s%s',
                  [ VehicleTruckTypeDesc[TruckType], #9,
                    TractionDesc[Traction], #9,
                    GetEnumName(TypeInfo(TRoadLegality), Ord(Legal)), #9,
                    Width, #9,
                    Speeds[SpeedCnt], #9,
                    GetEnumName(TypeInfo(TProfEnvironment), Ord(Environment)), #9,
                    BoolValues[Clearance], #9,
                    ProfCalcMethodDesc[TProfCalcMethod(CalcMethod)]
                  ]);
                P.Name := PName;
                P.Road_Legality := Ord(Legal);
                P.Width := Width;
                P.Max_Vehicle_Speed := Speed;
                P.Environmental := Ord(Environment);
                P.Calc_Method := Ord(CalcMethod);
                P.Calculate_Proposed_Hash(CurModel);
                P.High_Clearance := Clearance;
                if (CalcMethod = TProfCalcMethod.cmAdv) then
                begin
                  for Advlevel := Ord(Low(TProfAdvLevel)) to Ord(High(TProfAdvLevel)) do
                  begin
                    P.Name := Format('%s%s%d', [PName, #9, Advlevel]);
                    P.Adventurous_Route_Mode := Advlevel;
                    P.Calculate_Proposed_Hash(CurModel);
                    Writeln(F, P.Name, #9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));
                  end;
                end
                else
                begin
                  P.Adventurous_Route_Mode := 0;
                  P.Calculate_Proposed_Hash(CurModel);
                  Writeln(F, P.Name, #9, #9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  procedure MotorProfiles(Imperial: boolean; Width: integer);
  begin
    P := Default(TVehicleProfile);
    P.Name := 'VFR Avoid Legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr2Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAvoid);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'VFR Allow Legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr2Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'VFR Ask Legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr2Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAsk);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'VFR Allow Not Highway legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr2Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlNoHighway);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'VFR Allow Legal Shorter';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr2Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmShorter);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'VFR Ask Legal L2';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr2Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAsk);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmAdv);
    P.Adventurous_Route_Mode := 1;
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'VFR Ask Legal Faster 80 km';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr2Wheels);
    P.Max_Vehicle_Speed := 222;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAsk);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'VFR Ask Legal Shorter 80 km';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr2Wheels);
    P.Max_Vehicle_Speed := 222;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAsk);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmShorter);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'VFR Ask Legal L3 80 km';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr2Wheels);
    P.Max_Vehicle_Speed := 222;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAsk);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmAdv);
    P.Adventurous_Route_Mode := 2;
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));
  end;

  procedure TrikeProfiles(Imperial: boolean; Width: integer);
  begin
    P := Default(TVehicleProfile);
    P.Name := 'Trike Allow Legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr3Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Trike Ask Legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr3Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAsk);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Trike Allow Legal Faster 150cm';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr3Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := 150;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Trike Allow Legal Faster 150cm 50 km';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr3Wheels);
    P.Max_Vehicle_Speed := 138;
    P.Width := 150;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Trike Allow Not Highway legal Faster 150cm';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr3Wheels);
    P.Max_Vehicle_Speed := 0;
    P.Width := 150;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlNoHighway);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Trike Allow Legal Faster 80 km';
    P.Truck_Type := Ord(TVehicleTruckType.ttMotorCycle);
    P.Traction := Ord(TTraction.tr3Wheels);
    P.Max_Vehicle_Speed := 80;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

  end;

  procedure CarProfiles(Imperial: boolean; Width: integer);
  begin
    P := Default(TVehicleProfile);
    P.Name := 'Mazda Allow Legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttCar);
    P.Traction := Ord(TTraction.tr2WD);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Mazda Avoid Legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttCar);
    P.Traction := Ord(TTraction.tr2WD);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAvoid);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Mazda Avoid Legal Shorter';
    P.Truck_Type := Ord(TVehicleTruckType.ttCar);
    P.Traction := Ord(TTraction.tr2WD);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAvoid);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmShorter);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Mazda Avoid Legal L3';
    P.Truck_Type := Ord(TVehicleTruckType.ttCar);
    P.Traction := Ord(TTraction.tr2WD);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAvoid);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmAdv);
    P.Adventurous_Route_Mode := 2;
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Mazda 4WD Allow Legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttCar);
    P.Traction := Ord(TTraction.tr4WD);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := false;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

    P := Default(TVehicleProfile);
    P.Name := 'Mazda 4WD Allow High Legal Faster';
    P.Truck_Type := Ord(TVehicleTruckType.ttCar);
    P.Traction := Ord(TTraction.tr4WD);
    P.Max_Vehicle_Speed := 0;
    P.Width := Width;
    P.Imperial := Imperial;
    P.Environmental := Ord(TProfEnvironment.enAllow);
    P.Road_Legality := Ord(TRoadLegality.rlLegal);
    P.Calc_Method := Ord(TProfCalcMethod.cmFaster);
    P.High_Clearance := true;
    P.Calculate_Proposed_Hash(CurModel);
    Writeln(F, P.Name, #9#9#9#9#9#9#9#9#9, P.Proposed_Hash, #9, '0x', IntToHex(P.Proposed_Hash, 8));

  end;

begin
  if not SaveUnitTestDialog.Execute then
    exit;

  AssignFile(F, SaveUnitTestDialog.FileName);
  Rewrite(F);
  try
    Writeln(F, Format('Profile%sTraction%sLegal%sWidth%sMaxSpeed%sEnvironment%sHigh Clearance%sCalcMethod%sLevel%sHash%sHash Hex',
                      [#9,#9,#9,#9,#9,#9,#9,#9,#9,#9]));

    Writeln(F, 'Metric Specific');
    MotorProfiles(false, 120);
    TrikeProfiles(false, 120);
    CarProfiles(false, 200);

    Writeln(F, 'Metric Generic');
    Generic_Tests(TVehicleTruckType.ttMotorCycle, TTraction.tr2Wheels, false);
    Generic_Tests(TVehicleTruckType.ttMotorCycle, TTraction.tr3Wheels, false);
    Generic_Tests(TVehicleTruckType.ttCar, TTraction.tr2WD, false);
    Generic_Tests(TVehicleTruckType.ttCar, TTraction.tr4WD, false);

    Writeln(F, 'Imperial Specific');
    MotorProfiles(true, 122);
    TrikeProfiles(true, 122);
    CarProfiles(true, 198);

    Writeln(F, 'Imperial Generic');
    Generic_Tests(TVehicleTruckType.ttMotorCycle, TTraction.tr2Wheels, true);
    Generic_Tests(TVehicleTruckType.ttMotorCycle, TTraction.tr3Wheels, true);
    Generic_Tests(TVehicleTruckType.ttCar, TTraction.tr2WD, true);
    Generic_Tests(TVehicleTruckType.ttCar, TTraction.tr4WD, true);
  finally
    CloseFile(F);
  end;
end;

// Cant use fieldtype of GUID (Blob) in locate
function TFrmVehProfiles.ExistProfile(const FieldName, FieldValue: string): boolean;
var
  SavedRecNo: integer;
begin
  result := false;

  CDSVehProfile.DisableControls;
  SavedRecNo := CDSVehProfile.RecNo;
  try
    CDSVehProfile.First;
    while not (result) and
          not (CDSVehProfile.Eof) do
    begin
      if (SameText(CDSVehProfile.FieldByName(FieldName).DisplayText, FieldValue)) then
        exit(true);
      CDSVehProfile.Next;
    end;
  finally
    CDSVehProfile.RecNo := SavedRecNo;
    CDSVehProfile.EnableControls;
  end;
end;

procedure TFrmVehProfiles.BtnCleanUpClick(Sender: TObject);
var
  Index: integer;
begin
  for Index := GridHashList.RowCount -1 downto 2 do // High => Low
  begin
    if (GridHashList.Cells[0, Index] = '') then
      continue;
    if (ExistProfile('GUID', GridHashList.Cells[0, Index])) then
      continue;

    DeleteRegistryKey(SubKey + '\' + Reg_VehicleProfileHashList + '\' + GridHashList.Cells[0, Index]);
  end;
  LoadHashList;
end;

procedure TFrmVehProfiles.GridHashListSelectCell(Sender: TObject; ACol, ARow: {$IFDEF VER350}Integer{$ELSE}Longint{$ENDIF};
      var CanSelect: Boolean);
begin
  BtnDeleteHashList.Enabled :=
       (ARow > 1) and
       (ARow < GridHashList.RowCount) and
       (GridHashList.Cells[0, ARow] <> '');
end;

procedure TFrmVehProfiles.GridModified(Sender: TObject; ACol, ARow: LongInt; var Value: string);
begin
  if (TStringGrid(Sender).Cells[0, ARow] = '') then
    TStringGrid(Sender).Cells[2, ARow] := ''
  else if (Copy(TStringGrid(Sender).Cells[0, ARow], 1, 1) <> '*') then
  begin
    TStringGrid(Sender).Cells[0, ARow] := '*' + TStringGrid(Sender).Cells[0, ARow];
    BtnSaveHash.Enabled := true;
  end;
end;

procedure TFrmVehProfiles.SetOverridden_Hash(const NewHash: cardinal);
begin
  SetRegistry(Reg_VehicleProfileHash,
              NewHash,
              SubKey + '\' + Reg_VehicleProfileHashList + '\' + CDSVehProfile.FieldByName('guid').DisplayText);

  if not (CDSVehProfile.State in [dsEdit, dsInsert]) then
    CDSVehProfile.Edit;
  CDSVehProfile.Post;
end;

procedure TFrmVehProfiles.BtnDeleteHashListClick(Sender: TObject);
begin
  try
    if (GridHashList.Row > 1) and
       (GridHashList.Row < GridHashList.RowCount) and
       (GridHashList.Cells[0, GridHashList.Row] <> '') then
      DeleteRegistryKey(SubKey + '\' + Reg_VehicleProfileHashList + '\' + GridHashList.Cells[0, GridHashList.Row]);
  finally
    LoadHashList;
  end;
end;

procedure TFrmVehProfiles.BtnLookupHashClick(Sender: TObject);
var
  TripDirMask, TripDir: string;
  Fs: TSearchRec;
  Rc: integer;
  TmpTripList: TTripList;
  ScanGuid: string;
  NewHash: cardinal;
begin
  NewHash := 0;
  ScanGuid := CDSVehProfile.FieldByName('GUID').DisplayText;
  TripDir := GetRegistry(Reg_PrefFileSysFolder_Key, '');
  if (SelectDirectoryOrFile('Scan in Directory or File for hash value?', '', TripDir) = false) then
    exit;

  if (FileExists(TripDir)) then
    TripDirMask := TripDir
  else
    TripDirMask := IncludeTrailingPathDelimiter(TripDir) + TripMask;
  TripDir := ExtractFilePath(TripDirMask);

  TmpTripList := TTripList.Create;
  try
    Rc := System.Sysutils.FindFirst(TripDirMask, faAnyFile, Fs);
    while (Rc = 0) and
          (NewHash = 0) do
    begin
      TmpTripList.LoadFromFile(TripDir + Fs.Name);
      if (TmpTripList.VehicleGUID = ScanGuid) then
        NewHash := TmpTripList.VehicleHash;
      Rc := FindNext(Fs);
    end;
    FindClose(Fs);
  finally
    TmpTripList.Free;
  end;

  if (NewHash <> 0) then
  begin
    SetOverridden_Hash(NewHash);
    RefreshRecord;
  end
  else
    ShowMessage('No suitable trips found!')
end;

procedure TFrmVehProfiles.RefreshRecord;
var
  CurRecNo: integer;
begin
  CurRecNo := CDSVehProfile.RecNo;
  try
    LoadProfiles;
    LoadProfile;
  finally
    CDSVehProfile.RecNo := CurRecNo;
  end;
end;

procedure TFrmVehProfiles.BtnSaveHashClick(Sender: TObject);
var
  Index: integer;
  VehSubKey: string;
begin
  try
    for Index := GridHashList.FixedRows to GridHashList.RowCount do
    begin
      if (Copy(GridHashList.Cells[0, Index], 1, 1) <> '*') then
        continue;
      VehSubKey := SubKey + '\' + Reg_VehicleProfileHashList + '\' + Copy(GridHashList.Cells[0, Index], 2);
      SetRegistry(Reg_VehicleProfileHash, GridHashList.Cells[2, Index], VehSubKey);
    end;
  finally
    RefreshRecord;
  end;
end;

procedure TFrmVehProfiles.CDSVehProfileAfterScroll(DataSet: TDataSet);
begin
  if (Dataset.state in [dsBrowse]) then
    LoadProfile;
end;

procedure TFrmVehProfiles.CDSVehProfileBeforePost(DataSet: TDataSet);
var
  TmpProfile: TVehicleProfile;
begin
  TmpProfile.FromCds(TClientDataset(DataSet), CurModel);
  Dataset.FieldByName('Proposed_Hash').AsInteger := TmpProfile.Proposed_Hash;
  if (TmpProfile.Proposed_Hash = 0) then
    Dataset.FieldByName('Overridden_Hash').AsInteger := TmpProfile.HashFromHashList(SubKey);
end;

procedure TFrmVehProfiles.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (ModalResult = IdOK) and
     (VehicleProfile.Proposed_Hash = 0) then
    ShowMessage('Warning. VehicleProfileHash is 0!');
end;

procedure TFrmVehProfiles.FormCreate(Sender: TObject);
begin
  OrderBy := VehicleProfileOrder;
  AscDesc := '';
  BtnUnitTest.Visible := {$IFDEF DEBUG}true{$ELSE}false{$ENDIF};
  GridProfile.OnModified := GrdModified;
end;

procedure TFrmVehProfiles.FormDestroy(Sender: TObject);
begin
  FDSFields.Free;
end;

procedure TFrmVehProfiles.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = Chr(VK_ESCAPE)) then
  begin
    Key := #0;
    ModalResult := mrCancel;
  end;
end;

procedure TFrmVehProfiles.GrdModified(Sender: TObject; ACol, ARow: Longint; var Value: string);
begin
  if (ManualUpdate) and
     (TStringGrid(Sender).Cells[0, ARow] = Reg_VehicleProfileHash) then
    SetOverridden_Hash(StrToIntDef(Value, 0))
  else
    Value := TStringGrid(Sender).Cells[ACol, ARow];
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

procedure TFrmVehProfiles.GrdVehProfileTitleClick(Column: TColumn);
var
  Index: integer;
begin
  for Index := 0 to GrdVehProfile.Columns.Count -1 do
    GrdVehProfile.Columns[Index].Title.Caption := GrdVehProfile.Columns[Index].FieldName;
  if (Column.FieldName <> OrderBy) then
  begin
    OrderBy := Column.FieldName;
    AscDesc := Sort_Asc;
  end
  else
  begin
    if (Sametext(AscDesc, Sort_Asc)) then
      AscDesc := Sort_Desc
    else
      AscDesc := Sort_Asc;
  end;
  if (Sametext(AscDesc, Sort_Asc)) then
    Column.Title.Caption := Column.Title.Caption + ' ' + Arrow_Up
  else
    Column.Title.Caption := Column.Title.Caption + ' ' + Arrow_Down;
  LoadProfiles;
end;

procedure TFrmVehProfiles.LoadProfiles;
begin
  CurModel := TModelConv.Display2Garmin(GetRegistry(Reg_CurrentModel, 0));
  if not (TModelConv.ReadVehicleDB(CurModel)) then
    exit;

  if not (FileExists(GetDeviceTmp + ProfileDb)) then
    exit;
  CDSVehProfile.AfterOpen := FCDSEvents.AfterOpen;
  CDSFromQuery(GetDeviceTmp + ProfileDb, GetVehicleProfilesQuery(CurModel, Format('%s %s', [OrderBy, AscDesc])), CDSVehProfile);

  LoadHashList;
end;

procedure TFrmVehProfiles.PctDetailsChange(Sender: TObject);
begin
  if (TPageControl(Sender).ActivePage = TabHashList) then
    LoadHashList;
end;

procedure TFrmVehProfiles.PnlAllFieldsMouseEnter(Sender: TObject);
begin
  InScroll := true;
end;

procedure TFrmVehProfiles.PnlAllFieldsMouseLeave(Sender: TObject);
begin
  InScroll := false;
end;

procedure TFrmVehProfiles.LoadHashList;
var
  CurRow: integer;
  HashList: TStringList;
  AProfile: string;
  VehSubKey: string;
begin
  GridHashList.OnModified := GridModified;
  GridHashList.RowCount := GridHashList.FixedRows +1;
  GridHashList.BeginUpdate;
  try
    CurRow := 1;
    HashList := TStringList.Create;
    try
      VehSubKey := SubKey + '\' + Reg_VehicleProfileHashList;
      AddGridValueLine(GridHashList, CurRow, VehSubKey, '', '-Trip file Hashes saved in registry-');
      AddGridValueLine(GridHashList, CurRow, '', '', '');

      GetRegistryList(VehSubKey, HashList);
      for AProfile in HashList do
      begin
        if (ExistProfile('GUID', AProfile)) then
          GridHashList.Cells[3, CurRow] := ''
        else
          GridHashList.Cells[3, CurRow] := 'False';
        AddGridValueLine(GridHashList, CurRow, AProfile,
                                               GetRegistry(Reg_VehicleProfileHash, 0, VehSubKey + '\' + AProfile),
                                               GetRegistry(Reg_VehicleProfileName, '', VehSubKey + '\' + AProfile));

      end;
    finally
      HashList.Free;
    end;

    GridHashList.RowCount := CurRow;
    AddGridHeader(GridHashList);
    GridHashList.Cells[3, 0] := 'Existing profile';

  finally
    GridHashList.EndUpdate;
    BtnDeleteHashList.Enabled := false;
    BtnSaveHash.Enabled := false;
  end;
end;

procedure TFrmVehProfiles.LoadProfile;
var
  CurRow: integer;
  OverriddenHash: cardinal;
begin
  if not Assigned(FDSFields) then
    FDSFields := TDSFields.Create(PnlAllFields, DsVehProfile);

  VehicleProfile.FromCds(CDSVehProfile, CurModel);
  OverriddenHash := CDSVehProfile.FieldByName('Overridden_Hash').AsInteger;
  if (OverriddenHash <> 0) then
    VehicleProfile.Proposed_Hash := OverriddenHash;
  ManualUpdate := (CDSVehProfile.FieldByName('Proposed_Hash').AsInteger = 0);
  BtnLookupHash.Enabled := ManualUpdate;

  GridProfile.RowCount := GridProfile.FixedRows +1;
  GridProfile.BeginUpdate;
  try
    CurRow := 1;
    AddGridValueLine(GridProfile, CurRow, '', '', '-Items saved in trip files-');

    AddGridValueLine(GridProfile, CurRow, Reg_VehicleId,                  VehicleProfile.Vehicle_Id);
    AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileName,         VehicleProfile.Name);
    AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileGuid,         VehicleProfile.GUID);

    if (ManualUpdate) then
      AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileHash,       VehicleProfile.Proposed_Hash,
                                            '(No proposal possible. Manual input)')
    else
      AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileHash,       VehicleProfile.Proposed_Hash,
                                            '(Proposed by TripManager. Readonly)');

    AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileTruckType,    VehicleProfile.Truck_Type,
                                          '(7=Motorcycle, 11=Car)');
    AddGridValueLine(GridProfile, CurRow, Reg_DefAdvLevel,                VehicleProfile.Adventurous_Route_Mode,
                                          '(0=L1, 1=L2, 2=L3, 3=L4)');

    AddGridValueLine(GridProfile, CurRow, '', '');
    AddGridValueLine(GridProfile, CurRow, '', '', '-Items needed to compute Hash-');
    AddGridValueLine(GridProfile, CurRow, Hash_VehicleTraction,           VehicleProfile.Traction,
                                          '(1=2WD, 2=4WD, 3=3 Wheels, 4=2 Wheels)');

    if (CDSVehProfile.FindField('environmental') <> nil) then
      AddGridValueLine(GridProfile, CurRow, Hash_VehicleEnvironmental,    VehicleProfile.Environmental,
                                            '(0=Avoid, 1=Allow, 2=Ask)');

    AddGridValueLine(GridProfile, CurRow, Hash_VehicleLegality,           VehicleProfile.Road_Legality,
                                          '(0=Not legal, 1=Not highway legal, 2=Legal');

    if (CDSVehProfile.FindField('calc_method') <> nil) then
      AddGridValueLine(GridProfile, CurRow, Hash_VehicleCalcMethod,       VehicleProfile.Calc_Method,
                                            '(0=Faster, 1=Shorter, 4=Straight, 7=Adventurous)');

    AddGridValueLine(GridProfile, CurRow, Hash_VehicleMaxSpeed,           VehicleProfile.Max_Vehicle_Speed,
                                          '(Decimeters/Sec.)');
    AddGridValueLine(GridProfile, CurRow, Hash_VehicleWidth,              VehicleProfile.Width,
                                          '(Centimeters)');
    AddGridValueLine(GridProfile, CurRow, Hash_VehicleImperial,           VehicleProfile.Imperial,
                                          '(True=Miles, False=Kms)');
    AddGridValueLine(GridProfile, CurRow, Hash_VehicleClearance,          VehicleProfile.High_Clearance,
                                          '(True=High, False=Normal)');
    AddGridValueLine(GridProfile, CurRow, Reg_VehicleProfileModifiedDate, Format('0x%s', [IntToHex(VehicleProfile.Modified_Date, 8)]),
                                          'Date: ');

    AddGridValueLine(GridProfile, CurRow,   '', '');

    GridProfile.RowCount := CurRow;
    AddGridHeader(GridProfile);

  finally
    GridProfile.EndUpdate;
  end;
end;

end.
