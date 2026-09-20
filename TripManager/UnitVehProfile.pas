unit UnitVehProfile;

interface

uses
  System.Classes,
  Datasnap.DBClient,
  UnitGpxDefs;

type
  TVehicleProfile = record
    Valid: boolean;
    Vehicle_Id: integer;
    Name: string;
    GUID: string;
    Imperial: boolean;
    Truck_Type: integer;
    Calc_Method: integer;
    Adventurous_Route_Mode: integer;
    Traction: integer;
    High_Clearance: boolean;
    Width: integer;
    Road_Legality: integer;
    Environmental: integer;
    Avoidances: word;
    Max_Vehicle_Speed: integer;
    Modified_Date: cardinal;
    Proposed_Hash: cardinal;
    function XT3_FW350_HashSpeed1(const ASpeed: cardinal): cardinal;
    function XT3_FW350_HashSpeed2(const AWidth: byte;
                                  const ASpeed: cardinal): cardinal;
    function XT3_FW350_HashSpeed3(const ASpeed: cardinal;
                                  const ABike: boolean): cardinal;
    function XT3_FW430_AvoidanceMask(const Avoidances: byte): integer;
    function Can_Calculate_Hash(const Model: TGarminModel): boolean;
    procedure Calculate_Proposed_Hash(const Model: TGarminModel);
    procedure FromCds(const ACDS: TClientDataSet; const AModel: TGarminModel);
    procedure FromRegistry(const SubKey: string);
    procedure ToRegistry(const SubKey: string);
    function HashFromHashList(const SubKey: string): cardinal;
    function MustUpdate(Old_VehicleProfile: TVehicleProfile): boolean;
    function AvoidancesValid: boolean;
    function GetAvoidances: string;
  end;

  TProfCalcMethod  = (cmFaster = 0, cmShorter = 1, cmStraight = 4, cmAdv = 7);
  TRoadLegality    = (rlNone = 0, rlNoHighway = 1, rlLegal = 2);
  TProfAdvLevel    = (advL1 = 0, advL2 = 1, advL3 = 2, advL4 = 3);
  TProfEnvironment = (enAvoid = 0, enAllow = 1, enAsk = 2);
  TProfAVoidValid  = (pavValid = $03, pavMask = $ff, pavNotSelected = $80, pavInvalid = $ff);
  TProfAvoidances  = (pavU_turns = $01, pavHighWays = $02, pavTolls = $04, pavFerries = $08, pavCarpool = $10, pavUnpaved = $40);
  TTraction        = (tr2WD = 1, tr4WD = 2, tr3Wheels = 3, tr2Wheels = 4);
  TVehicleTruckType= (ttMotorCycle = 7, ttCar = 11);
  TKnown_FW350_Hash = record
    CM:             TProfCalcMethod; // Calc_method
    AdvLvl:         TProfAdvLevel;   // Adventurous levevel
    HashT2:         cardinal;        // Bike 2 wheels
    HashT3:         cardinal;        // Bike 3 wheels
    Hash2WD:        cardinal;        // Car 2WD
    Hash2WDHClear:  cardinal;        // Car 2WD High Clearance
    Hash4WD:        cardinal;        // Car 4WD
    Hash4WDHClear:  cardinal;        // Car 4WD High Clearance
  end;

  TKnown_FW430_Hash = record
    Imperial:       boolean;
    CM:             TProfCalcMethod; // Calc_method
    AdvLvl:         TProfAdvLevel;   // Adventurous levevel
    HashT2:         cardinal;        // Bike 2 wheels
    HashT3:         cardinal;        // Bike 3 wheels
    Hash2WD:        cardinal;        // Car 2WD
    Hash2WDHClear:  cardinal;        // Car 2WD High Clearance
    Hash4WD:        cardinal;        // Car 4WD
    Hash4WDHClear:  cardinal;        // Car 4WD High Clearance
  end;

  TKnown_FW430_Avoidance = record
    ProfEnvironment: TProfEnvironment;
    source: byte;
    dest: byte;
  end;

var
  VehicleTruckTypeDesc: array[TVehicleTruckType] of string = ('MotorCycle', '' ,'' ,'', 'Car');
  TractionDesc:         array[TTraction] of string = ('2WD', '4WD' ,'3 Wheels' ,'2 Wheels');
  ProfCalcMethodDesc:   array[TProfCalcMethod] of string = ('Faster', 'Shorter', '', '', 'Straight', '', '', 'Adventurous');

const
  Hash_VehicleMaxSpeed             = 'Max Speed';
  Hash_VehicleWidth                = 'Vehicle Width';
  Hash_VehicleImperial             = 'Imperial';
  Hash_VehicleClearance            = 'Clearance';
  Hash_VehicleCalcMethod           = 'Calculation method';
  Hash_VehicleEnvironmental        = 'Environmental zones';
  Hash_VehicleAvoidances           = 'Avoidances';
  Hash_VehicleTraction             = 'Traction';
  Hash_VehicleLegality             = 'Legal status';
  ProfAvoidanceMap : array[0..5] of TIdentMapEntry =
  (
    (Value: Ord(pavU_turns);           Name: 'U-Turns'),
    (Value: Ord(pavHighWays);          Name: 'Highways'),
    (Value: Ord(pavTolls);             Name: 'Tolls and Fees'),
    (Value: Ord(pavFerries);           Name: 'Ferries'),
    (Value: Ord(pavCarpool);           Name: 'Carpool Lanes'),
    (Value: Ord(pavUnpaved);           Name: 'Unpaved Roads')
  );

  // Base hash values
  // The Calculation method/Adventurous level, Traction and Clearance are used to index.
  XT3_FW350_Base_Hashes: array[0..6] of TKnown_FW350_Hash = (
    (CM: cmFaster;
      HashT2: $0A4F0000;  HashT3: $0A1F0000;
      Hash2WD: $023F0000; Hash2WDHClear: $02000000; Hash4WD: $026F0000; Hash4WDHClear: $02700000),
    (CM: cmShorter;
      HashT2: $07E00000;  HashT3: $07D00000;
      Hash2WD: $00300010; Hash2WDHClear: $002F0010; Hash4WD: $0FC00000; Hash4WDHClear: $0FFF0000),
    (CM: cmStraight;
      HashT2: $079B0000;  HashT3: $07CB0000;
      Hash2WD: $002B0010; Hash2WDHClear: $002C0010; Hash4WD: $0FFB0000; Hash4WDHClear: $0FFC0000),
    (CM: cmAdv; AdvLvl: advL1;
      HashT2: $0A4A0000;  HashT3: $0A1A0000;
      Hash2WD: $023A0000; Hash2WDHClear: $02390000; Hash4WD: $026A0000; Hash4WDHClear: $02690000),
    (CM: cmAdv; AdvLvl: advL2;
      HashT2: $0A7A0000;  HashT3: $0A6A0000;
      Hash2WD: $020A0000; Hash2WDHClear: $02090000; Hash4WD: $021A0000; Hash4WDHClear: $02190000),
    (CM: cmAdv; AdvLvl: advL3;
      HashT2: $0AAA0000;  HashT3: $0A3A0000;
      Hash2WD: $021A0000; Hash2WDHClear: $02190000; Hash4WD: $020A0000; Hash4WDHClear: $02090000),
    (CM: cmAdv; AdvLvl: advL4;
      HashT2: $0A5A0000;  HashT3: $0A0A0000;
      Hash2WD: $026A0000; Hash2WDHClear: $02690000; Hash4WD: $023A0000; Hash4WDHClear: $02390000)
  );

  // The high nibble of the Width, legality and Environments are used to index.
  // The value found is added to the base value
  XT3_FW350_Legal_Environments: array[0..$f, TRoadLegality, TProfEnvironment] of cardinal =
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
      ( ($0000, $0000, $0000),  ($1000, $0000, $3000), ($2000, $3000, $0000) ), // e only for Cars
      ( ($0000, $0000, $0000),  ($0000, $0000, $0000), ($0000, $0000, $0000) )  // f Not implemented
    );

  // The low nibble of the width, and the high nibble of the low byte of speed are used to index.
  // Speed2Tab is added to the base hash. (nibble: 6 = shl 8)
  XT3_FW350_Speed2Tab: array[0..$f, 0..$f] of byte =
    (
      ($7  ,$6  ,$5  ,$4  ,$3  ,$2  ,$1  ,$0  ,$f  ,$e  ,$d  ,$c  ,$b  ,$a  ,$9  ,$8),   // 0x90  = 144
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

  // The value found is added to the base hash. (nibble: 7 = shl 4)
  // The low nibble of the low byte of speed is used to index.
  // Car = false, Bike = true
  // Metric = false, Imperial = true
  XT3_FW350_Speed3Tab: array[boolean, boolean, 0..$f] of byte =
    (
    (($1, $0, $3, $2, $5, $4, $7, $6, $9, $8, $b, $a, $d, $c, $f, $e),   //Car,  Metric
     ($d, $c, $f, $e, $9, $8, $b, $a, $5, $4, $7, $6, $1, $0, $3, $2)),  //Car,  Imperial
    (($2, $3, $0, $1, $6, $7, $4, $5, $a, $b, $8, $9, $e, $f, $c, $d),   //Bike, Metric
     ($e, $f, $c, $d, $a, $b, $8, $9, $6, $7, $4, $5, $2, $3, $0, $1))   //Bike, Imperial
    );

  XT3_FW430_Base_Hashes: array[0..13] of TKnown_FW430_Hash =
  (
    (Imperial: false; CM: cmFaster;
      HashT2: $01292700; Hash2WD: $00F1C700),
    (Imperial: false; CM: cmShorter;
      HashT2: $0128d600; Hash2WD: $00C03600),
    (Imperial: false; CM: cmStraight;
      HashT2: $0128d300; Hash2WD: $00C03300),
    (Imperial: false; CM: cmAdv; AdvLvl: advL1;
      HashT2: $01292000; Hash2WD: $00F1C000),
    (Imperial: false; CM: cmAdv; AdvLvl: advL2;
      HashT2: $01293000; Hash2WD: $00F1D000),
    (Imperial: false; CM: cmAdv; AdvLvl: advL3;
      HashT2: $01290000; Hash2WD: $00F1E000),
    (Imperial: false; CM: cmAdv; AdvLvl: advL4;
      HashT2: $01291000; Hash2WD: $00F1F000),

    (Imperial: true; CM: cmFaster;
      HashT2: $01692500; Hash2WD: $0131C900),
    (Imperial: true; CM: cmShorter;
      HashT2: $0168d400; Hash2WD: $01003800),
    (Imperial: true; CM: cmStraight;
      HashT2: $0168d100; Hash2WD: $01003D00),
    (Imperial: true; CM: cmAdv; AdvLvl: advL1;
      HashT2: $01692200; Hash2WD: $0131CE00),
    (Imperial: true; CM: cmAdv; AdvLvl: advL2;
      HashT2: $01693200; Hash2WD: $0131DE00),
    (Imperial: true; CM: cmAdv; AdvLvl: advL3;
      HashT2: $01690200; Hash2WD: $0131EE00),
    (Imperial: true; CM: cmAdv; AdvLvl: advL4;
      HashT2: $01691200; Hash2WD: $0131FE00)
  );

  XT3_FW430_Avoid_Nibble2: array[boolean] of byte =
    ($18,  // Metric
     $17); // Imperial

  XT3_FW430_Avoid_Nibble7: array[0..11] of TKnown_FW430_Avoidance =
  (
    (ProfEnvironment: enAsk;    source: 0; dest: 0),
    (ProfEnvironment: enAsk;    source: 1; dest: 1),
    (ProfEnvironment: enAsk;    source: 4; dest: 4),
    (ProfEnvironment: enAsk;    source: 5; dest: 5),

    (ProfEnvironment: enAllow;  source: 0; dest: 3),
    (ProfEnvironment: enAllow;  source: 1; dest: 0),
    (ProfEnvironment: enAllow;  source: 4; dest: 7),
    (ProfEnvironment: enAllow;  source: 5; dest: 4),

    (ProfEnvironment: enAvoid;  source: 0; dest: 2),
    (ProfEnvironment: enAvoid;  source: 1; dest: 3),
    (ProfEnvironment: enAvoid;  source: 4; dest: 6),
    (ProfEnvironment: enAvoid;  source: 5; dest: 7)
  );

  XT3_FW430_Avoid_Nibble7_Exception = [8, 9];

implementation

uses
  System.Variants, System.SysUtils, System.StrUtils, System.UITypes,
  Winapi.Windows, Winapi.ShellAPI,
  Vcl.Dialogs,
  Data.DB,
  UnitRegistry, UnitRegistryKeys;

const
  Max_Vehicle_Speed_Supported       = 768;    // 768 dm/s = 27648 km/h!
  Min_Width                         = 96;     // $60
  Max_Width: array[boolean] of byte = (239,   // $ef Car
                                       223);  // $df Bike
  ProfileHelp                       = 'https://frankbijnen.github.io/TripManager/1initialtasks.html#setup_profile';

function TVehicleProfile.XT3_FW350_HashSpeed1(const ASpeed: cardinal): cardinal;
begin
  result := (ASpeed and $0000ff00) shl 16;
end;

function TVehicleProfile.XT3_FW350_HashSpeed2(const AWidth: byte;
                                              const ASpeed: cardinal): cardinal;
begin
  result := (XT3_FW350_Speed2Tab[Byte(AWidth) and $0f, (ASpeed and $000000f0) shr 4]) shl 8;
end;

function TVehicleProfile.XT3_FW350_HashSpeed3(const ASpeed: cardinal;
                                              const ABike: boolean): cardinal;
begin
  result := (XT3_FW350_Speed3Tab[ABike, Imperial, ASpeed and $0000000f]) shl 4;
end;

function TVehicleProfile.XT3_FW430_AvoidanceMask(const Avoidances: byte): integer;
var
  Index: integer;
  HighAvoid: byte;
  LoAvoid: byte;
begin
  result := -1;
  // A profile never selected, can not be used
  if ((Avoidances and Ord(pavNotSelected)) <> 0) then
    exit;

  HighAvoid := (Avoidances shr 4);
  LoAvoid := (Avoidances and $f);
  for Index := Low(XT3_FW430_Avoid_Nibble7) to High(XT3_FW430_Avoid_Nibble7) do
  begin
    if (TProfEnvironment(Environmental) <> XT3_FW430_Avoid_Nibble7[Index].ProfEnvironment) then
      continue;
    if (HighAvoid <> XT3_FW430_Avoid_Nibble7[Index].source) then
      continue;
    if (LoAvoid in XT3_FW430_Avoid_Nibble7_Exception) then
      result := (XT3_FW430_Avoid_Nibble7[Index].dest + 1) shl 4
    else
      result := XT3_FW430_Avoid_Nibble7[Index].dest shl 4;
    break;
  end;
  if (result > -1) then
    result := result + (((XT3_FW430_Avoid_Nibble2[imperial] - LoAvoid) and $f) shl 24);
end;

function TVehicleProfile.Can_Calculate_Hash(const Model: TGarminModel): boolean;
var
  AvoidMask: integer;
begin
  result := false;

  case Model of
    TGarminModel.XT2:
      exit(true);

    TGarminModel.XT3:
      begin
        // Valid Environmental value
        if not (TProfEnvironment(Environmental) in [TProfEnvironment.enAvoid,
                                                    TProfEnvironment.enAllow,
                                                    TProfEnvironment.enAsk]) then
          exit;

        if (AvoidancesValid) then
        begin
          // A lot not supported for V430
          if (Max_Vehicle_Speed <> 0) then
            exit;

          // Only 2 wheels for Bikes
          // 2WD for Cars
          case (TVehicleTruckType(Truck_Type)) of
            TVehicleTruckType.ttMotorCycle:
            begin
              if not (TTraction(Traction) in [TTraction.tr2Wheels]) then  // 2 Wheels Bike
                exit;
              if (Imperial = false) and (Width <> 120) then
                exit;
              if (Imperial = true) and (Width <> 122) then
                exit;
            end;
            TVehicleTruckType.ttCar:
            begin
              if not (TTraction(Traction) in [TTraction.tr2WD]) then      // 2WD      Car
                exit;
              if (High_Clearance) then
                exit;
              if (Imperial = false) and (Width <> 200) then
                exit;
              if (Imperial = true) and (Width <> 198) then
                exit;

            end
            else
              exit;
          end;

          // Only Highway Legal
          if not (TRoadLegality(Road_Legality) in [TRoadLegality.rlLegal]) then
            exit;

        // FW430 introduces avoidances in hash
          AvoidMask := XT3_FW430_AvoidanceMask(Avoidances);
          if (AvoidMask < 0) then
            exit;

          exit(true);
        end
        else
        begin
          // Check Speed
          if (Max_Vehicle_Speed > Max_Vehicle_Speed_Supported) then
            exit;

          // Only 2, or 3 Wheels for Bikes
          // 2WD, or 4WD for Cars
          case (TVehicleTruckType(Truck_Type)) of
            TVehicleTruckType.ttMotorCycle:
              if not (TTraction(Traction) in [TTraction.tr2Wheels,        // 2 Wheels Bike
                                              TTraction.tr3Wheels]) then  // 3 Wheels Bike
                exit;
            TVehicleTruckType.ttCar:
              if not (TTraction(Traction) in [TTraction.tr2WD,            // 2WD      Car
                                              TTraction.tr4WD]) then      // 4WD      Car
                exit;
            else
              exit;
          end;

          // Check width
          if (Width < Min_Width) then
            exit;
          if (Width > Max_Width[Truck_Type = Ord(TVehicleTruckType.ttMotorCycle)]) then
            exit;

          // Valid Legality
          if not (TRoadLegality(Road_Legality) in [TRoadLegality.rlNoHighway,
                                                   TRoadLegality.rlLegal]) then
            exit;

          exit(true);
        end;
      end;
  end;
end;

procedure TVehicleProfile.Calculate_Proposed_Hash(const Model: TGarminModel);
var
  Index: integer;
  AvoidMask: integer;
begin
  Proposed_Hash := 0;

  if (Can_Calculate_Hash(Model) = false) then
    exit;

  case Model of
    TGarminModel.XT2:
      if Imperial then
        Proposed_Hash := $0815F4A0
      else
        Proposed_Hash := $0815F480;
    TGarminModel.XT3:
      begin
        // FW430 introduces avoidances in hash
        if (AvoidancesValid) then
        begin
          AvoidMask := XT3_FW430_AvoidanceMask(Avoidances);
          if (AvoidMask < 0) then
            exit;

          for Index := Low(XT3_FW430_Base_Hashes) to High(XT3_FW430_Base_Hashes) do
          begin
            if (Imperial <> XT3_FW430_Base_Hashes[Index].Imperial) then
              continue;

            if (TProfCalcMethod(Calc_Method) <> XT3_FW430_Base_Hashes[Index].CM) then
              continue;
            if (TProfCalcMethod(Calc_Method) = TProfCalcMethod.cmAdv) and
               (TProfAdvLevel(Adventurous_Route_Mode) <> XT3_FW430_Base_Hashes[Index].AdvLvl) then
              continue;

            case (TTraction(Traction)) of
              TTraction.tr2Wheels:
                Proposed_Hash := XT3_FW430_Base_Hashes[Index].HashT2;
              //TODO
              TTraction.tr3Wheels:;
              TTraction.tr2WD:
              //TODO
                if (High_Clearance) then
                else
                  Proposed_Hash := XT3_FW430_Base_Hashes[Index].Hash2WD;
              TTraction.tr4WD:;
            end;
            Proposed_Hash := Proposed_Hash + Cardinal(AvoidMask);

            break;
          end;
        end
        else
        begin
          // FW350 and earlier
          for Index := Low(XT3_FW350_Base_Hashes) to High(XT3_FW350_Base_Hashes) do
          begin
            if (TProfCalcMethod(Calc_Method) <> XT3_FW350_Base_Hashes[Index].CM) then
              continue;
            if (TProfCalcMethod(Calc_Method) = TProfCalcMethod.cmAdv) and
               (TProfAdvLevel(Adventurous_Route_Mode) <> XT3_FW350_Base_Hashes[Index].AdvLvl) then
              continue;

            case (TTraction(Traction)) of
              TTraction.tr2Wheels:
                Proposed_Hash := XT3_FW350_Base_Hashes[Index].HashT2;
              TTraction.tr3Wheels:
                Proposed_Hash := XT3_FW350_Base_Hashes[Index].HashT3;
              TTraction.tr2WD:
                if (High_Clearance) then
                  Proposed_Hash := XT3_FW350_Base_Hashes[Index].Hash2WDHClear
                else
                  Proposed_Hash := XT3_FW350_Base_Hashes[Index].Hash2WD;
              TTraction.tr4WD:
                if (High_Clearance) then
                  Proposed_Hash := XT3_FW350_Base_Hashes[Index].Hash4WDHClear
                else
                  Proposed_Hash := XT3_FW350_Base_Hashes[Index].Hash4WD;
            end;
            Proposed_Hash := Proposed_Hash + XT3_FW350_Legal_Environments[(Width and $f0) shr 4,
                                                                          TRoadLegality(Road_Legality),
                                                                          TProfEnvironment(Environmental)];
            Proposed_Hash := Proposed_Hash + XT3_FW350_HashSpeed1(Max_Vehicle_Speed) +
                                             XT3_FW350_HashSpeed2(Width, Max_Vehicle_Speed) +
                                             XT3_FW350_HashSpeed3(Max_Vehicle_Speed, TVehicleTruckType(Truck_Type) = TVehicleTruckType.ttMotorCycle);
            break;
          end;
        end;
      end;
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
  Vehicle_Id := CDSField('vehicle_id');
  Name := CDSField('name');
  GUID := CDSField('guid');
  Imperial := (CDSField('width_metric') = 0);
  Truck_Type := CDSField('truck_type');
  Calc_Method := CDSField('calc_method');
  Adventurous_Route_Mode := CDSField('adventurous_route_mode');
  Traction := CDSField('traction');
  High_Clearance := (CDSField('clearance') = 1);
  Width := CDSField('width');
  Road_Legality := CDSField('road_legality');
  Environmental := CDSField('environmental');
  Avoidances := CDSField('avoidances');
  if ((Hi(Avoidances) and Ord(pavValid)) <> 0) then
    Avoidances := Avoidances and Ord(pavMask)
  else
    Avoidances := Ord(pavInvalid);
  Max_Vehicle_Speed := CDSField('max_vehicle_speed');
  Modified_Date := CDSField('modified_date');
  valid := true;
end;

procedure TVehicleProfile.FromRegistry(const SubKey: string);
begin
  Self := Default(TVehicleProfile);
  Vehicle_Id       := GetRegistry(Reg_VehicleId, 0, SubKey);
  Name             := GetRegistry(Reg_VehicleProfileName, '', SubKey);
  GUID             := GetRegistry(Reg_VehicleProfileGuid, '', SubKey);
  Truck_Type       := GetRegistry(Reg_VehicleProfileTruckType, 0, SubKey);
  Proposed_Hash    := GetRegistry(Reg_VehicleProfileHash, 0, SubKey);
  Modified_Date    := GetRegistry(Reg_VehicleProfileModifiedDate, 0, SubKey);
end;

procedure TVehicleProfile.ToRegistry(const SubKey: string);
begin
  if (Proposed_Hash = 0) then
  begin
    if (MessageDlg(Format('Warning! VehicleProfileHash=0 for profile: %s.%s' +
                          'Open online help how to set up a vehicle profile?',
                          [Name, #10]),
                     TMsgDlgType.mtWarning,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     0, TMsgDlgBtn.mbNo) = MrYes) then
      ShellExecute(0, 'Open', ProfileHelp, '','', SW_SHOWNORMAL);
  end;

  SetRegistry(Reg_VehicleProfileGuid,         GUID, SubKey);
  SetRegistry(Reg_VehicleId,                  Vehicle_Id, SubKey);
  SetRegistry(Reg_VehicleProfileTruckType,    Truck_Type, SubKey);
  SetRegistry(Reg_VehicleProfileName,         Name, Subkey);
  SetRegistry(Reg_VehicleProfileModifiedDate, Modified_Date, SubKey);
  SetRegistry(Reg_VehicleProfileHash,         Proposed_Hash, SubKey);
end;

function TVehicleProfile.HashFromHashList(const SubKey: string): cardinal;
begin
  result := GetRegistry(Reg_VehicleProfileHash, 0, SubKey + '\' +
                                                   Reg_VehicleProfileHashList  + '\' +
                                                   GUID);
end;

function TVehicleProfile.MustUpdate(Old_VehicleProfile: TVehicleProfile): boolean;
begin
  result := (Old_VehicleProfile.Proposed_Hash = 0) or
            (Name <> Old_VehicleProfile.Name) or
            (GUID <> Old_VehicleProfile.GUID) or
            (Modified_Date <> Old_VehicleProfile.Modified_Date);
end;

function TVehicleProfile.AvoidancesValid: boolean;
begin
  result := Avoidances <> Ord(pavInvalid);
end;

function TVehicleProfile.GetAvoidances: string;
var
  Avoidance: integer;
begin
  result := '';
  for Avoidance := Low(ProfAvoidanceMap) to High(ProfAvoidanceMap) do
  begin
    if ((Avoidances and ProfAvoidanceMap[Avoidance].Value) = ProfAvoidanceMap[Avoidance].Value) then
    begin
      if (result <> '') then
        result := result + ', ';
      result := result + ProfAvoidanceMap[Avoidance].Name;
    end;
  end;
end;

end.
