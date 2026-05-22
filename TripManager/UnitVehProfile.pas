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
    Max_Vehicle_Speed: integer;
    Modified_Date: cardinal;
    Proposed_Hash: cardinal;
    function HashSpeed1(const ASpeed: cardinal): cardinal;
    function HashSpeed2(const AWidth: byte;
                        const ASpeed: cardinal): cardinal;
    function HashSpeed3Bike(const ASpeed: cardinal;
                            const AImperial: boolean): cardinal;
    function HashSpeed2Bike(const AWidth: byte;
                            const ASpeed: cardinal;
                            const AImperial: boolean): cardinal;
    function HashSpeed2Car(const AWidth: byte;
                           const ASpeed: cardinal;
                           const AImperial: boolean): cardinal;
    function HashSpeed3Car(const ASpeed: cardinal;
                           const AImperial: boolean): cardinal;
    procedure Calculate_Proposed_Motor_Hash(const Model: TGarminModel);
    procedure Calculate_Proposed_Car_Hash(const Model: TGarminModel);
    procedure Calculate_Proposed_Hash(const Model: TGarminModel);
    procedure FromCds(const ACDS: TClientDataSet; const AModel: TGarminModel);
    procedure FromRegistry(const SubKey: string);
    procedure ToRegistry(const SubKey: string);
    function HashFromHashList(const ProfileHashList: TStringList): cardinal;
    procedure UpdateFromHashList(const SubKey: string; const ProfileHashList: TStringList);
    function Changed(IVehicleProfile: TVehicleProfile): boolean;
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
    HashT2: cardinal;
    HashT3: cardinal;
    Hash2WD: cardinal;
    Hash2WDHClear: cardinal;
    Hash4WD: cardinal;
    Hash4WDHClear: cardinal;
  end;

var
  VehicleTruckTypeDesc: array[TVehicleTruckType] of string = ('MotorCycle', '' ,'' ,'', 'Car');
  TractionDesc: array[TTraction] of string = ('2WD', '4WD' ,'3 Wheels' ,'2 Wheels');
  ProfCalcMethodDesc: array[TProfCalcMethod] of string = ('Faster', 'Shorter', '', '', 'Straight', '', '', 'Adventurous');

const
  Hash_VehicleMaxSpeed             = 'Max Speed';
  Hash_VehicleWidth                = 'Vehicle Width';
  Hash_VehicleImperial             = 'Imperial';
  Hash_VehicleClearance            = 'Clearance';
  Hash_VehicleCalcMethod           = 'Calculation method';
  Hash_VehicleEnvironmental        = 'Environmental zones';
  Hash_VehicleTraction             = 'Traction';
  Hash_VehicleLegality             = 'Legal status';

  // Base hash values for bikes
  // The Calculation method/Adventurous level, and Traction are used as to index.
  XT3_Motor_Hashes: array[0..6] of TKnownHash = (
    (CM: cmFaster;              HashT2: $0A4F0000;  HashT3: $0A1F0000),
    (CM: cmShorter;             HashT2: $07E00000;  HashT3: $07D00000),
    (CM: cmStraight;            HashT2: $079B0000;  HashT3: $07CB0000),
    (CM: cmAdv; AdvLvl: advL1;  HashT2: $0A4A0000;  HashT3: $0A1A0000),
    (CM: cmAdv; AdvLvl: advL2;  HashT2: $0A7A0000;  HashT3: $0A6A0000),
    (CM: cmAdv; AdvLvl: advL3;  HashT2: $0AAA0000;  HashT3: $0A3A0000),
    (CM: cmAdv; AdvLvl: advL4;  HashT2: $0A5A0000;  HashT3: $0A0A0000)
  );

  // Base hash values for cars
  // The Calculation method/Adventurous level, Traction and Clearance are used as to index.
  XT3_Car_Hashes: array[0..6] of TKnownHash = (
    (CM: cmFaster;              Hash2WD: $023F0000; Hash2WDHClear: $02000000; Hash4WD: $026F0000; Hash4WDHClear: $02700000),
    (CM: cmShorter;             Hash2WD: $00300010; Hash2WDHClear: $002F0010; Hash4WD: $0FC00000; Hash4WDHClear: $0FFF0000),
    (CM: cmStraight;            Hash2WD: $002B0010; Hash2WDHClear: $002C0010; Hash4WD: $0FFB0000; Hash4WDHClear: $0FFC0000),
    (CM: cmAdv; AdvLvl: advL1;  Hash2WD: $023A0000; Hash2WDHClear: $02390000; Hash4WD: $026A0000; Hash4WDHClear: $02690000),
    (CM: cmAdv; AdvLvl: advL2;  Hash2WD: $020A0000; Hash2WDHClear: $02090000; Hash4WD: $021A0000; Hash4WDHClear: $02190000),
    (CM: cmAdv; AdvLvl: advL3;  Hash2WD: $021A0000; Hash2WDHClear: $02190000; Hash4WD: $020A0000; Hash4WDHClear: $02090000),
    (CM: cmAdv; AdvLvl: advL4;  Hash2WD: $026A0000; Hash2WDHClear: $02690000; Hash4WD: $023A0000; Hash4WDHClear: $02390000)
  );

  // The high nibble of the Width, legality and Environments are used to index.
  // The value found is added to the base value
  XT3_Legal_Environments: array[0..$f, TRoadLegality, TProfEnvironment] of cardinal =
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

  // The value found in one of these 4 tables is added to the base hash.
  // The low nibble of the low byte of speed is used to index.
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
  Data.DB,
  UnitRegistry, UnitRegistryKeys;

const
  Max_Vehicle_Speed_Supported = 768; // 768 dm/s = 27648 km/h!
  Min_Width                   = 96;  // $60
  Max_Width_Bike              = 223; // $df
  Max_Width_Car               = 239; // $ef

function TVehicleProfile.HashSpeed1(const ASpeed: cardinal): cardinal;
begin
  result := (ASpeed and $0000ff00) shl 16;
end;

function TVehicleProfile.HashSpeed2(const AWidth: byte;
                                    const ASpeed: cardinal): cardinal;
begin
  result := (Speed2Tab[Byte(AWidth) and $0f, (ASpeed and $000000f0) shr 4]) shl 8;
end;

function TVehicleProfile.HashSpeed2Bike(const AWidth: byte;
                                        const ASpeed: cardinal;
                                        const AImperial: boolean): cardinal;
begin
  result := HashSpeed2(AWidth, ASpeed) + HashSpeed3Bike(ASpeed, AImperial);
end;

function TVehicleProfile.HashSpeed2Car(const AWidth: byte;
                                       const ASpeed: cardinal;
                                       const AImperial: boolean): cardinal;
begin
  result := HashSpeed2(AWidth, ASpeed) + HashSpeed3Car(ASpeed, AImperial);
end;

function TVehicleProfile.HashSpeed3Bike(const ASpeed: cardinal;
                                        const AImperial: boolean): cardinal;
begin
  if (AImperial) then
    result := (BikeSpeed3TabImperial[ASpeed and $0000000f]) shl 4
  else
    result := (BikeSpeed3TabMetric[ASpeed and $0000000f]) shl 4;
end;

function TVehicleProfile.HashSpeed3Car(const ASpeed: cardinal;
                                       const AImperial: boolean): cardinal;
begin
  if (AImperial) then
    result := (CarSpeed3TabImperial[ASpeed and $0000000f]) shl 4
  else
    result := (CarSpeed3TabMetric[ASpeed and $0000000f]) shl 4;
end;

procedure TVehicleProfile.Calculate_Proposed_Motor_Hash(const Model: TGarminModel);
var
  Index: integer;
begin
  // Check Speed
  if (Max_Vehicle_Speed > Max_Vehicle_Speed_Supported) then
    exit;

  // Only 2, or 3 Wheels traction
  if not (Traction in [Ord(TTraction.tr3Wheels),        // 3 Wheels
                       Ord(TTraction.tr2Wheels)]) then  // 2 Wheels
    exit;

  // Check width
  if (Width < Min_Width) then       // min width 96
    exit;
  if (Width > Max_Width_Bike) then  // max width 223
    exit;

  // Valid Environmental value
  if not (Environmental in [Ord(TProfEnvironment.enAvoid),
                            Ord(TProfEnvironment.enAllow),
                            Ord(TProfEnvironment.enAsk)]) then
    exit;

  // Valid Legality
  if not (Road_Legality in [Ord(TRoadLegality.rlNoHighway),
                            Ord(TRoadLegality.rlLegal)]) then
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
             (TProfAdvLevel(Adventurous_Route_Mode) <> XT3_Motor_Hashes[Index].AdvLvl) then
            continue;

          if (Traction = Ord(TTraction.tr2Wheels)) then // 2 Wheels
            Proposed_Hash := XT3_Motor_Hashes[Index].HashT2 +
                                XT3_Legal_Environments[(Width and $f0) shr 4,
                                                        TRoadLegality(Road_Legality),
                                                        TProfEnvironment(Environmental)]
          else                                          // 3 Wheels
            Proposed_Hash := XT3_Motor_Hashes[Index].HashT3 +
                                XT3_Legal_Environments[(Width and $f0) shr 4,
                                                        TRoadLegality(Road_Legality),
                                                        TProfEnvironment(Environmental)];

          Proposed_Hash := Proposed_Hash + HashSpeed1(Max_Vehicle_Speed);
          Proposed_Hash := Proposed_Hash + HashSpeed2Bike(Width, Max_Vehicle_Speed, Imperial);
          break;
        end;
      end;
  end;
end;

procedure TVehicleProfile.Calculate_Proposed_Car_Hash(const Model: TGarminModel);
var
  Index: integer;
begin
  // Check Speed
  if (Max_Vehicle_Speed > Max_Vehicle_Speed_Supported) then
    exit;

  // Only 2WD and 4WD, 2 Axles
  if not (Traction in [Ord(TTraction.tr2WD),
                       Ord(TTraction.tr4WD)]) then
    exit;

  // Check width
  if (Width < Min_Width) then       // min width 96
    exit;
  if (Width > Max_Width_Car) then   // max width 239
    exit;

  // Valid Environmental value
  if not (Environmental in [Ord(TProfEnvironment.enAvoid),
                            Ord(TProfEnvironment.enAllow),
                            Ord(TProfEnvironment.enAsk)]) then
    exit;

  // Valid Legality
  if not (Road_Legality in [Ord(TRoadLegality.rlNoHighway),
                            Ord(TRoadLegality.rlLegal)]) then
    exit;

  case Model of
    TGarminModel.XT2:     // The XT2 has only one motorcycle profile. Not used.
      Proposed_Hash := 0;
    TGarminModel.XT3:
      begin
        for Index := Low(XT3_Car_Hashes) to High(XT3_Car_Hashes) do
        begin
          if (TProfCalcMethod(Calc_Method) <> XT3_Car_Hashes[Index].CM) then
            continue;
          if (TProfCalcMethod(Calc_Method) = TProfCalcMethod.cmAdv) and
             (TProfAdvLevel(Adventurous_Route_Mode) <> XT3_Car_Hashes[Index].AdvLvl) then
            continue;

          if (High_Clearance) then
          begin
            if (Traction = Ord(TTraction.tr4WD)) then // 4WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash4WDhClear +
                                XT3_Legal_Environments[(Width and $f0) shr 4,
                                                       TRoadLegality(Road_Legality),
                                                       TProfEnvironment(Environmental)]
            else                                      // 2WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash2WDhClear +
                                  XT3_Legal_Environments[(Width and $f0) shr 4,
                                                          TRoadLegality(Road_Legality),
                                                          TProfEnvironment(Environmental)];
          end
          else
          begin
            if (Traction = Ord(TTraction.tr4WD)) then // 4WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash4WD +
                                XT3_Legal_Environments[(Width and $f0) shr 4,
                                                        TRoadLegality(Road_Legality),
                                                        TProfEnvironment(Environmental)]
            else                                      // 2WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash2WD +
                                XT3_Legal_Environments[(Width and $f0) shr 4,
                                                       TRoadLegality(Road_Legality),
                                                       TProfEnvironment(Environmental)];
          end;
          Proposed_Hash := Proposed_Hash + HashSpeed1(Max_Vehicle_Speed);
          Proposed_Hash := Proposed_Hash + HashSpeed2Car(Width, Max_Vehicle_Speed, Imperial);
          break;
        end;
      end;
  end;
end;

procedure TVehicleProfile.Calculate_Proposed_Hash(const Model: TGarminModel);
begin
  Proposed_Hash := 0;

  case Truck_Type of
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
  Max_Vehicle_Speed := CDSField('max_vehicle_speed');
  Modified_Date := CDSField('modified_date');
  valid := true;

  Calculate_Proposed_Hash(AModel);
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
  SetRegistry(Reg_VehicleProfileGuid,         GUID, SubKey);
  SetRegistry(Reg_VehicleId,                  Vehicle_Id, SubKey);
  SetRegistry(Reg_VehicleProfileTruckType,    Truck_Type, SubKey);
  SetRegistry(Reg_VehicleProfileName,         Name, Subkey);
  SetRegistry(Reg_VehicleProfileModifiedDate, Modified_Date, SubKey);
  SetRegistry(Reg_VehicleProfileHash,         Proposed_Hash, SubKey);
end;

function TVehicleProfile.HashFromHashList(const ProfileHashList: TStringList): cardinal;
var
  Index: integer;
begin
  result := 0;
  Index := ProfileHashList.IndexOf(GUID);
  if (Index > -1) then
    result := cardinal(ProfileHashList.Objects[Index]);
end;

procedure TVehicleProfile.UpdateFromHashList(const SubKey: string; const ProfileHashList: TStringList);
begin
  Self := Default(TVehicleProfile);

  FromRegistry(SubKey);
  if (Proposed_Hash <> 0) then // Already have a hash ?
    exit;

  Proposed_Hash := HashFromHashList(ProfileHashList);
  if (Proposed_Hash <> 0) then // Lookup worked? Store in Registry
    ToRegistry(SubKey);
end;

function TVehicleProfile.Changed(IVehicleProfile: TVehicleProfile): boolean;
begin
  result := (Name <> IVehicleProfile.Name) or
            (GUID <> IVehicleProfile.GUID) or
            (Modified_Date <> IVehicleProfile.Modified_Date);
end;

end.
