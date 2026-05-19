unit UnitVehProfile;

interface

uses
  System.Generics.Collections, System.Classes,
  Data.DB, Datasnap.DBClient,
  SQLiteWrap,
  UnitGpxDefs;

type

  TVehicleProfile = record
    Valid: boolean;
    Vehicle_Id: integer;
    TruckType: integer;
    Name: string;
    GUID: string;
    AdventurousLevel: integer;
    Environmental: integer;
    Traction: integer;
    Calc_Method: integer;
    Max_Speed: integer;
    Width: integer;
    Imperial: boolean;
    Clearance: boolean;
    Legality: integer;
    Modified: cardinal;
    Proposed_Hash: cardinal;
    function HashSpeed1: cardinal;
    function HashSpeed2: cardinal;
    function HashSpeed3Bike: cardinal;
    function HashSpeed2Bike: cardinal;
    function HashSpeed2Car: cardinal;
    function HashSpeed3Car: cardinal;
    procedure Calculate_Proposed_Motor_Hash(const Model: TGarminModel);
    procedure Calculate_Proposed_Car_Hash(const Model: TGarminModel);
    procedure Calculate_Proposed_Hash(const Model: TGarminModel);
    procedure FromCds(const ACDS: TClientDataSet; const AModel: TGarminModel);
    function Changed(IName, IGUID: string;
                     IModified: cardinal): boolean; overload;
    function Changed(IVehicleProfile: TVehicleProfile): boolean; overload;
  end;

  TProfCalcMethod  = (cmFaster = 0, cmShorter = 1, cmStraight = 4, cmAdv = 7);
  TRoadLegality    = (rlNone = 0, rlNoHighway = 1, rlLegal = 2);
  TProfAdvLevel    = (advL1 = 0, advL2 = 1, advL3 = 2, advL4 = 3);
  TProfEnvironment = (enAvoid = 0, enAllow = 1, enAsk = 2);
  TTraction        = (tr2WD = 1, tr4WD = 2, tr3Wheels = 3, tr2Wheels = 4);
  TVehicleTruckType= (ttMotorCycle = 7, ttCar = 11);
  TKnownHash = record
    CM: TProfCalcMethod;
    AdvLvl: TProfAdvLevel;
    HashT2: Cardinal;
    HashT3: Cardinal;
    Hash2WD: Cardinal;
    Hash2WDClear: Cardinal;
    Hash4WD: Cardinal;
    Hash4WDClear: Cardinal;
  end;

var
  VehicleTruckTypeDesc: array[TVehicleTruckType] of string = ('MotorCycle', '' ,'' ,'', 'Car');
  TractionDesc: array[TTraction] of string = ('2WD', '4WD' ,'3 Wheels' ,'2 Wheels');
  ProfCalcMethodDesc: array[TProfCalcMethod] of string = ('Faster', 'Shorter', '', '', 'Straight', '', '', 'Adventurous');

const

  Hash_VehicleMaxSpeed             = 'Max Speed';
  Hash_VehicleWidth                = 'Vehicle Width';
  Hash_VehicleImperial             = 'Imperial';
  Hash_VehicleClearance            = 'High clearance';
  Hash_VehicleCalcMethod           = 'Calculation method';
  Hash_VehicleEnvironmental        = 'Environmental zones';
  Hash_VehicleTraction             = 'Traction';
  Hash_VehicleLegality             = 'Legal status';


  // Base hash values for bikes
  // The Calculation method/Adventurous level are used as to index.
  XT3_Motor_Hashes: array[0..6] of TKnownHash = (
    (CM: cmFaster;              HashT2: $0A4F0000;  HashT3: $0A1F0000),
    (CM: cmShorter;             HashT2: $07E00000;  HashT3: $07D00000),
    (CM: cmStraight;            HashT2: $079B0000;  HashT3: $07CB0000),
    (CM: cmAdv; AdvLvl: advL1;  HashT2: $0A4A0000;  HashT3: $0A1A0000),
    (CM: cmAdv; AdvLvl: advL2;  HashT2: $0A7A0000;  HashT3: $0A6AA000),
    (CM: cmAdv; AdvLvl: advL3;  HashT2: $0AAA0000;  HashT3: $0A3AA000),
    (CM: cmAdv; AdvLvl: advL4;  HashT2: $0A5A0000;  HashT3: $0A0AA000)
  );

  // Base hash values for cars
  XT3_Car_Hashes: array[0..6] of TKnownHash = (
    (CM: cmFaster;              Hash2WD: $023F0000; Hash2WDClear: $02000000; Hash4WD: $026F0000; Hash4WDClear: $02700000),
    (CM: cmShorter;             Hash2WD: $00300010; Hash2WDClear: $002F0010; Hash4WD: $0FC00000; Hash4WDClear: $0FFF0000),
    (CM: cmStraight;            Hash2WD: $002B0010; Hash2WDClear: $002C0010; Hash4WD: $0FFB0000; Hash4WDClear: $0FFC0000),
    (CM: cmAdv; AdvLvl: advL1;  Hash2WD: $023A0000; Hash2WDClear: $02390000; Hash4WD: $026A0000; Hash4WDClear: $02690000),
    (CM: cmAdv; AdvLvl: advL2;  Hash2WD: $020A0000; Hash2WDClear: $02090000; Hash4WD: $021A0000; Hash4WDClear: $02190000),
    (CM: cmAdv; AdvLvl: advL3;  Hash2WD: $021A0000; Hash2WDClear: $02190000; Hash4WD: $020A0000; Hash4WDClear: $02090000),
    (CM: cmAdv; AdvLvl: advL4;  Hash2WD: $026A0000; Hash2WDClear: $02690000; Hash4WD: $023A0000; Hash4WDClear: $02390000)
  );

  // The high nibble of the Width, legality and Environments are used to index.
  // The values found are or-ed to the base values
  XT3_Legal_Environments: array[0..$f, TRoadLegality, TProfEnvironment] of Cardinal =
    (
      // Not legal, Not impl.     Not Highway legal      Legal
      // Avoid   Allow  Ask       Avoid  Allow  Ask      Avoid  Allow  Ask
      ( ($0000, $0000, $0000),  ($0000, $0000, $0000), ($0000, $0000, $0000) ), // 0 Not implemented
      ( ($0000, $0000, $0000),  ($0000, $0000, $0000), ($0000, $0000, $0000) ), // 1 Not implemented
      ( ($0000, $0000, $0000),  ($0000, $0000, $0000), ($0000, $0000, $0000) ), // 2 Not implemented
      ( ($0000, $0000, $0000),  ($0000, $0000, $0000), ($0000, $0000, $0000) ), // 3 Not implemented
      ( ($0000, $0000, $0000),  ($0000, $0000, $0000), ($0000, $0000, $0000) ), // 4 Not implemented
      ( ($0000, $0000, $0000),  ($0000, $0000, $0000), ($0000, $0000, $0000) ), // 5 Not implemented
      ( ($0000, $0000, $0000),  ($9000, $8000, $b000), ($a000, $b000, $8000) ), // 6
      ( ($0000, $0000, $0000),  ($8000, $9000, $a000), ($b000, $a000, $9000) ), // 7
      ( ($0000, $0000, $0000),  ($7000, $6000, $5000), ($4000, $5000, $6000) ), // 8
      ( ($0000, $0000, $0000),  ($6000, $7000, $4000), ($5000, $4000, $7000) ), // 9
      ( ($0000, $0000, $0000),  ($5000, $4000, $7000), ($6000, $7000, $4000) ), // a
      ( ($0000, $0000, $0000),  ($4000, $5000, $6000), ($7000, $6000, $5000) ), // b
      ( ($0000, $0000, $0000),  ($3000, $2000, $1000), ($0000, $1000, $2000) ), // c
      ( ($0000, $0000, $0000),  ($2000, $3000, $0000), ($1000, $0000, $3000) ), // d
      ( ($0000, $0000, $0000),  ($1000, $0000, $3000), ($2000, $3000, $0000) ), // e
      ( ($0000, $0000, $0000),  ($0000, $0000, $0000), ($0000, $0000, $0000) )  // f Not implemented
    );

  // The low nibble of the width, and the high nibble of the low byte of speed are used to index.
  // Speed2Tab is added to the base hash.
  Speed2Tab: array[0..$f, 0..$f] of byte =
    (
      ($7  ,$6  ,$5  ,$4  ,$3  ,$2  ,$1  ,$0  ,$f  ,$e  ,$d  ,$c  ,$b  ,$a  ,$9  ,$8),   // 0x90  =144
      ($6  ,$7  ,$4  ,$5  ,$2  ,$3  ,$0  ,$1  ,$e  ,$f  ,$c  ,$d  ,$a  ,$b  ,$8  ,$9),   // 0x91
      ($5  ,$4  ,$7  ,$6  ,$1  ,$0  ,$3  ,$2  ,$d  ,$c  ,$f  ,$e  ,$9  ,$8  ,$b  ,$a),   // 0x92
      ($4  ,$5  ,$6  ,$7  ,$0  ,$1  ,$2  ,$3  ,$c  ,$d  ,$e  ,$f  ,$8  ,$9  ,$a  ,$b),   // 0x93
      ($3  ,$2  ,$1  ,$0  ,$7  ,$6  ,$5  ,$4  ,$b  ,$a  ,$9  ,$8  ,$f  ,$e  ,$d  ,$c),   // 0x94
      ($2  ,$3  ,$0  ,$1  ,$6  ,$7  ,$4  ,$5  ,$a  ,$b  ,$8  ,$9  ,$e  ,$f  ,$c  ,$d),   // 0x95
      ($1  ,$0  ,$3  ,$2  ,$5  ,$4  ,$7  ,$6  ,$9  ,$8  ,$b  ,$a  ,$d  ,$c  ,$f  ,$e),   // 0x96
      ($0  ,$1  ,$2  ,$3  ,$4  ,$5  ,$6  ,$7  ,$8  ,$9  ,$a  ,$b  ,$c  ,$d  ,$e  ,$f),   // 0x97
      ($f  ,$e  ,$d  ,$c  ,$b  ,$a  ,$9  ,$8  ,$7  ,$6  ,$5  ,$4  ,$3  ,$2  ,$1  ,$0),   // 0x98
      ($e  ,$f  ,$c  ,$d  ,$a  ,$b  ,$8  ,$9  ,$6  ,$7  ,$4  ,$5  ,$2  ,$3  ,$0  ,$1),   // 0x99
      ($d  ,$c  ,$f  ,$e  ,$9  ,$8  ,$b  ,$a  ,$5  ,$4  ,$7  ,$6  ,$1  ,$0  ,$3  ,$2),   // 0x9a
      ($c  ,$d  ,$e  ,$f  ,$8  ,$9  ,$a  ,$b  ,$4  ,$5  ,$6  ,$7  ,$0  ,$1  ,$2  ,$3),   // 0x9b
      ($b  ,$a  ,$9  ,$8  ,$f  ,$e  ,$d  ,$c  ,$3  ,$2  ,$1  ,$0  ,$7  ,$6  ,$5  ,$4),   // 0x9c
      ($a  ,$b  ,$8  ,$9  ,$e  ,$f  ,$c  ,$d  ,$2  ,$3  ,$0  ,$1  ,$6  ,$7  ,$4  ,$5),   // 0x9d
      ($9  ,$8  ,$b  ,$a  ,$d  ,$c  ,$f  ,$e  ,$1  ,$0  ,$3  ,$2  ,$5  ,$4  ,$7  ,$6),   // 0x9e
      ($8  ,$9  ,$a  ,$b  ,$c  ,$d  ,$e  ,$f  ,$0  ,$1  ,$2  ,$3  ,$4  ,$5  ,$6  ,$7)    // 0x9f = 159
    );

  // The value found in of these 4 tables is added to the base hash.
  // The low nibble of the low byte of speed are used to index.
  BikeSpeed3TabImperial: array[0..$f] of byte =
    ($e, $f, $c, $d, $a, $b, $8, $9, $6, $7, $4, $5, $2, $3, $0, $1);
  BikeSpeed3TabMetric: array[0..$f] of byte =
    ($2, $3, $0, $1, $6, $7, $4, $5, $a, $b, $8, $9, $e, $f, $c, $d);

  //TODO only element 0, 5, $e have been verified.
  CarSpeed3TabImperial: array[0..$f] of byte =
    ($d, $c, $f, $e, $9, $8, $b, $a, $5, $4, $7, $6, $1, $0, $3, $2);
  CarSpeed3TabMetric: array[0..$f] of byte =
    ($1, $0, $3, $2, $5, $4, $7, $6, $9, $8, $b, $a, $d, $c, $f, $e);

implementation

uses
  System.Variants, System.SysUtils, System.StrUtils,
  Winapi.Windows,
  Vcl.Dialogs,
  SQLite3,
  UnitStringUtils;

const
  Max_Speed_Supported = 768; // 768 m/s = 2764 km/h!

function TVehicleProfile.HashSpeed1: cardinal;
begin
  result := (Max_Speed and $0000ff00) shl 16;
end;

function TVehicleProfile.HashSpeed2: cardinal;
begin
  result := (Speed2Tab[Byte(Width) and $0f, (Max_Speed and $000000f0) shr 4]) shl 8;
end;

function TVehicleProfile.HashSpeed2Bike: cardinal;
begin
  result := HashSpeed2 + HashSpeed3Bike;
end;

function TVehicleProfile.HashSpeed2Car: cardinal;
begin
  result := HashSpeed2 + HashSpeed3Car;
end;

function TVehicleProfile.HashSpeed3Bike: cardinal;
begin
  if (Imperial) then
    result := (BikeSpeed3TabImperial[Max_Speed and $0000000f]) shl 4
  else
    result := (BikeSpeed3TabMetric[Max_Speed and $0000000f]) shl 4;
end;

function TVehicleProfile.HashSpeed3Car: cardinal;
begin
  if (Imperial) then
    result := (CarSpeed3TabImperial[Max_Speed and $0000000f]) shl 4
  else
    result := (CarSpeed3TabMetric[Max_Speed and $0000000f]) shl 4;
end;

procedure TVehicleProfile.Calculate_Proposed_Motor_Hash(const Model: TGarminModel);
var
  Index: integer;
  HWidth: byte;
begin
  // Check Speed
  if (Max_Speed > Max_Speed_Supported) then
    exit;

  // Only 2, or 3 Wheels traction
  if not (Traction in [Ord(TTraction.tr3Wheels),        // 3 Wheels
                       Ord(TTraction.tr2Wheels)]) then  // 2 Wheels
    exit;

  // Check width
  HWidth := (Byte(Width) and $f0) shr 4;
  if (HWidth < $6) then  // min width 96
    HWidth := $6;
  if (HWidth > $d) then  // max width 223
    HWidth := $d;

  // Valid Environmental value
  if not (Environmental in [Ord(TProfEnvironment.enAvoid),
                            Ord(TProfEnvironment.enAllow),
                            Ord(TProfEnvironment.enAsk)]) then
    exit;

  // Valid Legality
  if not (Legality in [1,2]) then
    exit;

  case Model of
    TGarminModel.XT2:
      if Imperial then
        Proposed_Hash := $0815F4A0
      else
        Proposed_Hash := $0815F480;
    TGarminModel.XT3:
      begin
        for Index := Low(XT3_Motor_Hashes) to High(XT3_Motor_Hashes) do
        begin
          if (TProfCalcMethod(Calc_Method) <> XT3_Motor_Hashes[Index].CM) then
            continue;
          if (TProfCalcMethod(Calc_Method) = TProfCalcMethod.cmAdv) and
             (TProfAdvLevel(AdventurousLevel) <> XT3_Motor_Hashes[Index].AdvLvl) then
            continue;

          if (Traction = Ord(TTraction.tr2Wheels)) then // 2 Wheels
            Proposed_Hash := XT3_Motor_Hashes[Index].HashT2 or
                                XT3_Legal_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)]
          else                                          // 3 Wheels
            Proposed_Hash := XT3_Motor_Hashes[Index].HashT3 or
                                XT3_Legal_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)];

          Proposed_Hash := Proposed_Hash + HashSpeed1;
          Proposed_Hash := Proposed_Hash + HashSpeed2Bike;
          break;
        end;
      end;
  end;
end;

procedure TVehicleProfile.Calculate_Proposed_Car_Hash(const Model: TGarminModel);
var
  Index: integer;
  HWidth: byte;
begin
  // Check Speed
  if (Max_Speed > Max_Speed_Supported) then
    exit;

  // Only 2WD and 4WD, 2 Axles
  if not (Traction in [Ord(TTraction.tr2WD), Ord(TTraction.tr4WD)]) then
    exit;

  // Check width
  HWidth := (Byte(Width) and $f0) shr 4;
  if (HWidth < $6) then  // min width 96
    HWidth := $6;
  if (HWidth > $e) then  // max width 239
    HWidth := $e;

  // Valid Environmental value
  if not (Environmental in [Ord(TProfEnvironment.enAvoid),
                            Ord(TProfEnvironment.enAllow),
                            Ord(TProfEnvironment.enAsk)]) then
    exit;

  // Valid Legality
  if not (Legality in [1,2]) then
    exit;

  case Model of
//    TGarminModel.XT2: The XT2 has only one motorcycle profile. Not used.
    TGarminModel.XT3:
      begin
        for Index := Low(XT3_Car_Hashes) to High(XT3_Car_Hashes) do
        begin
          if (TProfCalcMethod(Calc_Method) <> XT3_Car_Hashes[Index].CM) then
            continue;
          if (TProfCalcMethod(Calc_Method) = TProfCalcMethod.cmAdv) and
             (TProfAdvLevel(AdventurousLevel) <> XT3_Car_Hashes[Index].AdvLvl) then
            continue;

          if (Clearance) then
          begin
            if (Traction = Ord(TTraction.tr4WD)) then // 4WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash4WDClear or
                                XT3_Legal_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)]
            else                                      // 2WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash2WDClear or
                                  XT3_Legal_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)];
          end
          else
          begin
            if (Traction = Ord(TTraction.tr4WD)) then // 4WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash4WD or
                                XT3_Legal_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)]
            else                                      // 2WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash2WD or
                                XT3_Legal_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)];
          end;
          Proposed_Hash := Proposed_Hash + HashSpeed1;
          Proposed_Hash := Proposed_Hash + HashSpeed2Car;
          break;
        end;
      end;
  end;
end;

procedure TVehicleProfile.Calculate_Proposed_Hash(const Model: TGarminModel);
begin
  Proposed_Hash := 0;

  case TruckType of
    Ord(TVehicleTruckType.ttCar):
      Calculate_Proposed_Car_Hash(Model);
    Ord(TVehicleTruckType.ttMotorCycle):
      Calculate_Proposed_Motor_Hash(Model);
  end;
end;

procedure TVehicleProfile.FromCds(const ACDS: TClientDataSet; const AModel: TGarminModel);

  function CDSField(AFieldName: string): Variant;
  var
    AField: TField;
  begin
    result := Unassigned;
    AField := ACDS.FindField(AFieldName);
    if (AField = nil) then
      exit;

    if (ContainsText(AFieldName, 'UID')) then
      result := AField.DisplayText
    else
      result := AField.Value;
  end;

begin
  Self := Default(TVehicleProfile);
  Vehicle_Id := CDSField('Vehicle_id');
  TruckType := CDSField('truck_type');
  Name := CDSField('name');
  GUID := CDSField('guid');
  AdventurousLevel := CDSField('adventurous_route_mode');
  Environmental := CDSField('environmental');
  Traction := CDSField('traction');
  Calc_Method := CDSField('calc_method');
  Max_Speed := CDSField('max_vehicle_speed');
  Width := CDSField('width');
  Imperial := (CDSField('width_metric') = 0);
  Clearance := (CDSField('clearance') = 1);
  Legality := CDSField('road_legality');
  Modified := CDSField('modified_date');
  valid := true;

  Calculate_Proposed_Hash(AModel);
end;

function TVehicleProfile.Changed(IName, IGUID: string;
                                 IModified: cardinal): boolean;
begin
  result := (Name <> IName) or
            (GUID <> IGUID) or
            (Modified <> IModified);
end;

function TVehicleProfile.Changed(IVehicleProfile: TVehicleProfile): boolean;
begin
  result := Changed(IVehicleProfile.Name,
                    IVehicleProfile.GUID,
                    IVehicleProfile.Modified);
end;

end.
