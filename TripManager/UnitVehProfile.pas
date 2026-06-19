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
    function HashSpeed3(const ASpeed: cardinal;
                        const ABike: boolean): cardinal;
    procedure Calculate_Proposed_Hash(const Model: TGarminModel);
    procedure FromCds(const ACDS: TClientDataSet; const AModel: TGarminModel);
    procedure FromRegistry(const SubKey: string);
    procedure ToRegistry(const SubKey: string);
    function HashFromHashList(const SubKey: string): cardinal;
    procedure UpdateFromHashList(const SubKey: string);
    function MustUpdate(Old_VehicleProfile: TVehicleProfile): boolean;
  end;

  TProfCalcMethod  = (cmFaster = 0, cmShorter = 1, cmStraight = 4, cmAdv = 7);
  TRoadLegality    = (rlNone = 0, rlNoHighway = 1, rlLegal = 2);
  TProfAdvLevel    = (advL1 = 0, advL2 = 1, advL3 = 2, advL4 = 3);
  TProfEnvironment = (enAvoid = 0, enAllow = 1, enAsk = 2);
  TTraction        = (tr2WD = 1, tr4WD = 2, tr3Wheels = 3, tr2Wheels = 4);
  TVehicleTruckType= (ttMotorCycle = 7, ttCar = 11);
  TKnownHash = record
    CM:             TProfCalcMethod; // Calc_method
    AdvLvl:         TProfAdvLevel;   // Adventurous levevel
    HashT2:         cardinal;        // Bike 2 wheels
    HashT3:         cardinal;        // Bike 3 wheels
    Hash2WD:        cardinal;        // Car 2WD
    Hash2WDHClear:  cardinal;        // Car 2WD High Clearance
    Hash4WD:        cardinal;        // Car 4WD
    Hash4WDHClear:  cardinal;        // Car 4WD High Clearance
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
  Hash_VehicleTraction             = 'Traction';
  Hash_VehicleLegality             = 'Legal status';

  // Base hash values
  // The Calculation method/Adventurous level, Traction and Clearance are used to index.
  XT3_Base_Hashes: array[0..6] of TKnownHash = (
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
      ( ($0000, $0000, $0000),  ($1000, $0000, $3000), ($2000, $3000, $0000) ), // e only for Cars
      ( ($0000, $0000, $0000),  ($0000, $0000, $0000), ($0000, $0000, $0000) )  // f Not implemented
    );

  // The low nibble of the width, and the high nibble of the low byte of speed are used to index.
  // Speed2Tab is added to the base hash. (nibble: 6 = shl 8)
  Speed2Tab: array[0..$f, 0..$f] of byte =
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
  Speed3Tab: array[boolean, boolean, 0..$f] of byte =
    (
    (($1, $0, $3, $2, $5, $4, $7, $6, $9, $8, $b, $a, $d, $c, $f, $e),   //Car,  Metric
     ($d, $c, $f, $e, $9, $8, $b, $a, $5, $4, $7, $6, $1, $0, $3, $2)),  //Car,  Imperial
    (($2, $3, $0, $1, $6, $7, $4, $5, $a, $b, $8, $9, $e, $f, $c, $d),   //Bike, Metric
     ($e, $f, $c, $d, $a, $b, $8, $9, $6, $7, $4, $5, $2, $3, $0, $1))   //Bike, Imperial
    );
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
//TODO
  ProfileHelp     = 'https://frankbijnen.github.io/TripManager/1initialtasks.html#setup_profile';

function TVehicleProfile.HashSpeed1(const ASpeed: cardinal): cardinal;
begin
  result := (ASpeed and $0000ff00) shl 16;
end;

function TVehicleProfile.HashSpeed2(const AWidth: byte;
                                    const ASpeed: cardinal): cardinal;
begin
  result := (Speed2Tab[Byte(AWidth) and $0f, (ASpeed and $000000f0) shr 4]) shl 8;
end;

function TVehicleProfile.HashSpeed3(const ASpeed: cardinal;
                                    const ABike: boolean): cardinal;
begin
  result := (Speed3Tab[ABike, Imperial, ASpeed and $0000000f]) shl 4;
end;

procedure TVehicleProfile.Calculate_Proposed_Hash(const Model: TGarminModel);
var
  Index: integer;
begin
  Proposed_Hash := 0;

  // Check Speed
  if (Max_Vehicle_Speed > Max_Vehicle_Speed_Supported) then
    exit;

  // Only 2, or 3 Wheels traction
  if not (TTraction(Traction) in [TTraction.tr3Wheels,        // 3 Wheels Bike
                                  TTraction.tr2Wheels,        // 2 Wheels Bike
                                  TTraction.tr2WD,            // 2WD      Car
                                  TTraction.tr4WD]) then      // 3WD      Car
    exit;

  // Check width
  if (Width < Min_Width) then
    exit;
  if (Width > Max_Width[Truck_Type = Ord(TVehicleTruckType.ttMotorCycle)]) then
    exit;

  // Valid Environmental value
  if not (TProfEnvironment(Environmental) in [TProfEnvironment.enAvoid,
                                              TProfEnvironment.enAllow,
                                              TProfEnvironment.enAsk]) then
    exit;

  // Valid Legality
  if not (TRoadLegality(Road_Legality) in [TRoadLegality.rlNoHighway,
                                           TRoadLegality.rlLegal]) then
    exit;

  case Model of
    TGarminModel.XT2:
      if Imperial then
        Proposed_Hash := $0815F4A0
      else
        Proposed_Hash := $0815F480;
    TGarminModel.XT3:
      begin
        for Index := Low(XT3_Base_Hashes) to High(XT3_Base_Hashes) do
        begin
          if (TProfCalcMethod(Calc_Method) <> XT3_Base_Hashes[Index].CM) then
            continue;
          if (TProfCalcMethod(Calc_Method) = TProfCalcMethod.cmAdv) and
             (TProfAdvLevel(Adventurous_Route_Mode) <> XT3_Base_Hashes[Index].AdvLvl) then
            continue;

          case (TTraction(Traction)) of
            TTraction.tr2Wheels:
              Proposed_Hash := XT3_Base_Hashes[Index].HashT2;
            TTraction.tr3Wheels:
              Proposed_Hash := XT3_Base_Hashes[Index].HashT3;
            TTraction.tr2WD:
              if (High_Clearance) then
                Proposed_Hash := XT3_Base_Hashes[Index].Hash2WDHClear
              else
                Proposed_Hash := XT3_Base_Hashes[Index].Hash2WD;
            TTraction.tr4WD:
              if (High_Clearance) then
                Proposed_Hash := XT3_Base_Hashes[Index].Hash4WDHClear
              else
                Proposed_Hash := XT3_Base_Hashes[Index].Hash4WD;
          end;
          Proposed_Hash := Proposed_Hash + XT3_Legal_Environments[(Width and $f0) shr 4,
                                                                  TRoadLegality(Road_Legality),
                                                                  TProfEnvironment(Environmental)];
          Proposed_Hash := Proposed_Hash + HashSpeed1(Max_Vehicle_Speed) +
                                           HashSpeed2(Width, Max_Vehicle_Speed) +
                                           HashSpeed3(Max_Vehicle_Speed, TVehicleTruckType(Truck_Type) = TVehicleTruckType.ttMotorCycle);
          break;
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

procedure TVehicleProfile.UpdateFromHashList(const SubKey: string);
begin
  Self := Default(TVehicleProfile);

  FromRegistry(SubKey);
  if (Proposed_Hash <> 0) then // Already have a hash ?
    exit;

  Proposed_Hash := HashFromHashList(SubKey);
  if (Proposed_Hash <> 0) then // Lookup worked? Store in Registry
    ToRegistry(SubKey);
end;

function TVehicleProfile.MustUpdate(Old_VehicleProfile: TVehicleProfile): boolean;
begin
  result := (Old_VehicleProfile.Proposed_Hash = 0) or
            (Name <> Old_VehicleProfile.Name) or
            (GUID <> Old_VehicleProfile.GUID) or
            (Modified_Date <> Old_VehicleProfile.Modified_Date);
end;

end.
