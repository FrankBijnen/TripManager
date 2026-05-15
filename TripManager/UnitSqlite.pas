unit UnitSqlite;

interface

uses
  System.Generics.Collections, System.Classes,
  Data.DB, Datasnap.DBClient,
  SQLiteWrap,
  UnitGpxDefs;

type

  TCDSEvents = class(TObject)
  public
    procedure GetBlob(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure GetGUID(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure AfterOpen(DataSet: TDataSet);
  end;

  TSqlColumn = record
    Table_Name: UTF8String;
    Table_Type: UTF8String;
    Column_Name: UTF8String;
    Column_Type: UTF8String;
    PK: UTF8String;
  end;
  TSqlColumns = Tlist<TSqlColumn>;

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
    function HashSpeed3: cardinal;
    function HashCarSpeed: cardinal;
    procedure Calculate_Proposed_Motor_Hash(const Model: TGarminModel);
    procedure Calculate_Proposed_Car_Hash(const Model: TGarminModel);
    procedure Calculate_Proposed_Hash(const Model: TGarminModel);
    procedure FromCds(const ACDS: TClientDataSet; const AModel: TGarminModel);
    function Changed(IName, IGUID: string;
                     IVehicle_Id, ITruckType, ITraction: integer;
                     IEnvironmental, ICalc_Method, ILegality: integer): boolean; overload;
    function Changed(IVehicleProfile: TVehicleProfile): boolean; overload;
  end;

  TSqlResult = Tlist<Variant>;
  TSqlResults = TObjectList<TSqlResult>;

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
    Hash4WD: Cardinal;
  end;

const

  XT3_Environments: array[0..15, TRoadLegality, TProfEnvironment] of Cardinal =
    (
      // Not legal, Not implemented          Not Highway legal                  Legal
      ( ($00000000, $00000000, $00000000),  ($00000000, $00000000, $00000000), ($00000000, $00000000, $00000000) ), // 0 Not implemented
      ( ($00000000, $00000000, $00000000),  ($00000000, $00000000, $00000000), ($00000000, $00000000, $00000000) ), // 1 Not implemented
      ( ($00000000, $00000000, $00000000),  ($00000000, $00000000, $00000000), ($00000000, $00000000, $00000000) ), // 2 Not implemented
      ( ($00000000, $00000000, $00000000),  ($00000000, $00000000, $00000000), ($00000000, $00000000, $00000000) ), // 3 Not implemented
      ( ($00000000, $00000000, $00000000),  ($00000000, $00000000, $00000000), ($00000000, $00000000, $00000000) ), // 4 Not implemented
      ( ($00000000, $00000000, $00000000),  ($00000000, $00000000, $00000000), ($00000000, $00000000, $00000000) ), // 5 Not implemented
      ( ($00000000, $00000000, $00000000),  ($00009000, $00008000, $0000b000), ($0000a000, $0000b000, $00008000) ), // 6
      ( ($00000000, $00000000, $00000000),  ($00008000, $00009000, $0000a000), ($0000b000, $0000a000, $00009000) ), // 7
      ( ($00000000, $00000000, $00000000),  ($00007000, $00006000, $00005000), ($00004000, $00005000, $00006000) ), // 8
      ( ($00000000, $00000000, $00000000),  ($00006000, $00007000, $00004000), ($00005000, $00004000, $00007000) ), // 9
      ( ($00000000, $00000000, $00000000),  ($00005000, $00004000, $00007000), ($00006000, $00007000, $00004000) ), // a
      ( ($00000000, $00000000, $00000000),  ($00004000, $00005000, $00006000), ($00007000, $00006000, $00005000) ), // b
      ( ($00000000, $00000000, $00000000),  ($00003000, $00002000, $00001000), ($00000000, $00001000, $00002000) ), // c
      ( ($00000000, $00000000, $00000000),  ($00002000, $00003000, $00000000), ($00001000, $00000000, $00003000) ), // d
      ( ($00000000, $00000000, $00000000),  ($00002000, $00003000, $00000000), ($00001000, $00000000, $00003000) ), // e
      ( ($00000000, $00000000, $00000000),  ($00000000, $00000000, $00000000), ($00000000, $00000000, $00000000) )  // f Not implemented
    );

  XT3_Motor_Hashes: array[0..6] of TKnownHash = (
    (CM: cmFaster;              HashT2: $0A4F0000;  HashT3: $0A1F0000),
    (CM: cmShorter;             HashT2: $07E00000;  HashT3: $07D00000),
    (CM: cmStraight;            HashT2: $079B0000;  HashT3: $07CB0000),
    (CM: cmAdv; AdvLvl: advL1;  HashT2: $0A4A0000;  HashT3: $0A1A0000),
    (CM: cmAdv; AdvLvl: advL2;  HashT2: $0A7A0000;  HashT3: $0A6AA000),
    (CM: cmAdv; AdvLvl: advL3;  HashT2: $0AAA0000;  HashT3: $0A3AA000),
    (CM: cmAdv; AdvLvl: advL4;  HashT2: $0A5A0000;  HashT3: $0A0AA000)
  );

  XT3_Car_Hashes: array[0..6] of TKnownHash = (
    (CM: cmFaster;              Hash2WD: $023F0000; Hash4WD: $026F0000),
    (CM: cmShorter;             Hash2WD: $00300010; Hash4WD: $0FC00000),
    (CM: cmStraight;            Hash2WD: $002B0010; Hash4WD: $0FFB0000),
    (CM: cmAdv; AdvLvl: advL1;  Hash2WD: $023A0000; Hash4WD: $026A0000),
    (CM: cmAdv; AdvLvl: advL2;  Hash2WD: $020A0000; Hash4WD: $021A0000),
    (CM: cmAdv; AdvLvl: advL3;  Hash2WD: $021A0000; Hash4WD: $020A0000),
    (CM: cmAdv; AdvLvl: advL4;  Hash2WD: $026A0000; Hash4WD: $023A0000)
  );

  XT3_Car_Clearance_Hashes: array[0..6] of TKnownHash = (
    (CM: cmFaster;              Hash2WD: $02000000; Hash4WD: $02700000),
    (CM: cmShorter;             Hash2WD: $002F0010; Hash4WD: $0FFF0000),
    (CM: cmStraight;            Hash2WD: $002C0010; Hash4WD: $0FFC0000),
    (CM: cmAdv; AdvLvl: advL1;  Hash2WD: $02390000; Hash4WD: $02690000),
    (CM: cmAdv; AdvLvl: advL2;  Hash2WD: $02090000; Hash4WD: $02190000),
    (CM: cmAdv; AdvLvl: advL3;  Hash2WD: $02190000; Hash4WD: $02090000),
    (CM: cmAdv; AdvLvl: advL4;  Hash2WD: $02690000; Hash4WD: $02390000)
  );

procedure GetTables(const DbName: string; TabList: TStrings);
function GetColumns(const DbName: string;
                    const TabName: string): TSqlColumns; overload;
function GetColumns(const Db: TSQLiteDatabase;
                    const TabName: string): TSqlColumns; overload;
procedure ExecSqlQuery(const DbName: string;
                       const Query: string;
                       const Results: TSqlResults);
function ExecUpdateSql(const DbName: string;
                       const Query: string): int64;
function GetAvoidancesChanged(const DbName: string): string;
function GetActiveVehicleProfile(const DbName: string;
                                 const Model: TGarminModel): TVehicleProfile;
procedure GetExploreList(const DBName: string;
                         const ExploreList: TStrings);
function CDSFromQuery(const DbName: string;
                      const Query: string;
                      const ACds: TClientDataSet): integer;
function GetAllVehicleProfilesQuery(const Model: TGarminModel): string;

var
  FCDSEvents: TCDSEvents;

implementation

uses
  System.Variants, System.SysUtils, System.StrUtils,
  Winapi.Windows,
  Vcl.Dialogs,
  SQLite3,
  UnitStringUtils;

const
  CRLF = #13#10;
  Max_Speed_Supported = 768; // 768 m/s = 2764 km/h!

procedure TCDSEvents.GetBlob(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  Text := ReplaceAll(Copy(Sender.AsString, 1, 1024), [#0, #9, #10], ['.', '.', ' ']);
end;

procedure TCDSEvents.GetGUID(Sender: TField; var Text: string; DisplayText: Boolean);
var
  B: TBytes;
  Index: integer;
begin
  Text := '';
  B := Sender.AsBytes;
  if Length(B) < 16 then
    exit;
  for Index := 0 to 3 do
    Text := Text + IntToHex(B[Index], 2);
  Text := text + '-';
  for Index := 4 to 5 do
    Text := Text + IntToHex(B[Index], 2);
  Text := text + '-';
  for Index := 6 to 7 do
    Text := Text + IntToHex(B[Index], 2);
  Text := text + '-';
  for Index := 8 to 9 do
    Text := Text + IntToHex(B[Index], 2);
  Text := text + '-';
  for Index := 10 to 15 do
    Text := Text + IntToHex(B[Index], 2);
  Text := LowerCase(Text);
end;

procedure TCDSEvents.AfterOpen(DataSet: TDataSet);
var
  AField: TField;
begin
  for AField in DataSet.Fields do
  begin
    if (AField is TBlobField) then
    begin
      if (ContainsText(Afield.FieldName, 'UID')) then
      begin
        AField.OnGetText := GetGUID;
        Afield.DisplayWidth := 40;
      end
      else
      begin
        AField.OnGetText := GetBlob;
        AField.Tag := 1;
      end;
    end;
  end;
end;

function MkGuid(const HexGuid: string): string;
begin
  result := LowerCase(HexGuid);
  insert('-', result, 9);
  insert('-', result, 14);
  insert('-', result, 19);
  insert('-', result, 24);
end;

function TVehicleProfile.HashSpeed1: cardinal;
begin
  result := (Max_Speed and $0000ff00) shl 16;
end;

function TVehicleProfile.HashSpeed2: cardinal;
const
  Speed2Tab: array[0..15, 0..15] of byte =
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
begin
  result := (Speed2Tab[Byte(Width) and $0f, (Max_Speed and $000000f0) shr 4]) shl 8;
end;

function TVehicleProfile.HashSpeed3: cardinal;
const
  Speed3TabImperial: array[0..15] of byte =
   ($0e, $0f, $0c, $0d, $0a, $0b, $08, $09, $06, $07, $04, $05, $02, $03, $00, $01);
//  0=e  1=f  2=c  3=d  4=a  5=b  6=8  7=9  8=6  9=7  a=4  b=5  c=2  d=3  e=0  f=1
  Speed3TabMetric: array[0..15] of byte =
   ($02, $03, $00, $01, $06, $07, $04, $05, $0a, $0b, $08, $09, $0e, $0f, $0c, $0d);
//  0=2  1=3  2=0  3=1  4=6  5=7  6=4  7=5  8=a  9=b  a=8  b=9  c=e  d=f  e=c  f=d
begin
  if (Imperial) then
    result := (Speed3TabImperial[Max_Speed and $0000000f]) shl 4
  else
    result := (Speed3TabMetric[Max_Speed and $0000000f]) shl 4;
end;

// For cars no speed restriction possible
function TVehicleProfile.HashCarSpeed: cardinal;
begin
  if (Imperial) then
    result := $1D0
  else
    result := $F10;
end;

procedure TVehicleProfile.Calculate_Proposed_Motor_Hash(const Model: TGarminModel);
var
  Index: integer;
  HWidth: byte;
begin
  if (Max_Speed > Max_Speed_Supported) then
    exit;

  // Only 2, or 3 Wheels traction
  if not (Traction in [Ord(TTraction.tr3Wheels),        // 3 Wheels
                       Ord(TTraction.tr2Wheels)]) then  // 2 Wheels
    exit;

  // Need more tests
  if (Width < $60) or
     (Width > $ef) then
      exit;
  HWidth := (Byte(Width) and $f0) shr 4;

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
                                XT3_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)]
          else                                          // 3 Wheels
            Proposed_Hash := XT3_Motor_Hashes[Index].HashT3 or
                                XT3_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)];

          Proposed_Hash := Proposed_Hash +  HashSpeed1;
          Proposed_Hash := Proposed_Hash or HashSpeed2;
          Proposed_Hash := Proposed_Hash or HashSpeed3;
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
  if (Max_Speed <> 0) then
    exit;

  // Only 2WD and 4WD, 2 Axles
  if not (Traction in [Ord(TTraction.tr2WD), Ord(TTraction.tr4WD)]) then
    exit;

  // Only width allowed are 200 and 198
  if (Imperial = false) and
     (Width <> 200) then
    exit;

  if (Imperial = true) and
     (Width <> 198) then
    exit;
  HWidth := (Byte(Width) and $f0) shr 4;

  // Valid Environmental value
  if not (Environmental in [Ord(TProfEnvironment.enAvoid),
                            Ord(TProfEnvironment.enAllow),
                            Ord(TProfEnvironment.enAsk)]) then
    exit;

  // Valid Legality
  if not (Legality in [1,2]) then
    exit;

  case Model of
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
              Proposed_Hash := XT3_Car_Clearance_Hashes[Index].Hash4WD or
                                XT3_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)]
            else                                      // 2WD
              Proposed_Hash := XT3_Car_Clearance_Hashes[Index].Hash2WD or
                                  XT3_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)];
          end
          else
          begin
            if (Traction = Ord(TTraction.tr4WD)) then // 4WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash4WD or
                                XT3_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)]
            else                                      // 2WD
              Proposed_Hash := XT3_Car_Hashes[Index].Hash2WD or
                                  XT3_Environments[HWidth, TRoadLegality(Legality), TProfEnvironment(Environmental)];
          end;
          Proposed_Hash := Proposed_Hash + HashCarSpeed;
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
                                 IVehicle_Id, ITruckType, ITraction: integer;
                                 IEnvironmental, ICalc_Method, ILegality: integer): boolean;
begin
  result := (Name <> IName) or
            (GUID <> IGUID) or
            (Vehicle_Id <> IVehicle_Id) or
            (TruckType <> ITruckType) or
            (Traction <> ITraction) or
            (Environmental <> IEnvironmental) or
            (Calc_Method <> ICalc_Method);
end;

function TVehicleProfile.Changed(IVehicleProfile: TVehicleProfile): boolean;
begin
  result := Changed(IVehicleProfile.Name,
                    IVehicleProfile.GUID,
                    IVehicleProfile.Vehicle_Id,
                    IVehicleProfile.TruckType,
                    IVehicleProfile.Traction,
                    IVehicleProfile.Environmental,
                    IVehicleProfile.Calc_Method,
                    IVehicleProfile.Legality);
end;

procedure TableNames(const Db: TSqliteDatabase; TabList: TStrings);
var
  TableTab: TSqliteTable;
  SQL: string;
begin
  TabList.Clear;
  Db.ParamsClear;
  SQL :=
    'SELECT m.name AS table_name' + CRLF +
    'FROM sqlite_master AS m ' + CRLF +
    'WHERE m.type IN (''table'', ''view'')' + CRLF +
    'ORDER BY m.name;';

  TableTab := Db.GetTable(SQL);
  try
    while not TableTab.EOF do
    begin
      TabList.Add(string(TableTab.FieldAsStringUnicode(0)));
      TableTab.Next;
    end;
  finally
    TableTab.free;
  end;
end;

function GetColumns(const Db: TSQLiteDatabase;
                    const TabName: string): TSqlColumns;
var
  ColumnTab: TSqliteTable;
  AColumn: TSqlColumn;
  SQL: string;
begin
  if not SQLite3Loaded then
    exit(nil);

  result := TSqlColumns.Create;

  Db.ParamsClear;
  Db.AddParamTextUnicode(':Tab', UTF8String(TabName));
  SQL :=
    'SELECT m.name AS table_name, m.type AS table_type, ' + CRLF +
    '  p.name AS column_name, p.type AS data_type, ' + CRLF +
    '  CASE p.pk WHEN 1 THEN ''PK'' END AS const ' + CRLF +
    'FROM sqlite_master AS m ' + CRLF +
    '  INNER JOIN pragma_table_info(table_name) AS p ' + CRLF +
    'WHERE m.type IN (''table'') ' + CRLF +
    'and m.name like :Tab '+ CRLF +
    'ORDER BY m.name, p.cid;' ;

  ColumnTab := Db.GetTable(SQL);
  try
    while not ColumnTab.EOF do
    begin
      AColumn.Table_Name := ColumnTab.FieldAsStringUnicode(0);
      AColumn.Table_Type := ColumnTab.FieldAsStringUnicode(1);
      AColumn.Column_Name := ColumnTab.FieldAsStringUnicode(2);
      AColumn.Column_Type := ColumnTab.FieldAsStringUnicode(3);
      AColumn.PK := ColumnTab.FieldAsStringUnicode(4);

      result.Add(AColumn);
      ColumnTab.Next;
    end;
  finally
    ColumnTab.free;
  end;
end;

function GetColumns(const DbName: string;
                    const TabName: String): TSqlColumns;
var
  Db: TSQLiteDatabase;
begin
  if not SQLite3Loaded then
    exit(nil);

  Db := TSQLiteDatabase.Create(DbName, true);
  try
    result := GetColumns(Db, TabName);
  finally
    Db.Free;
  end;
end;

procedure GetTables(const DbName: string; TabList: TStrings);
var
  DB: TSQLiteDatabase;
begin
  if not SQLite3Loaded then
    exit;

  DB := TSqliteDatabase.Create(DBName, true);
  try
    TableNames(DB, TabList);
  finally
    DB.Free;
  end;
end;

procedure ExecSqlQuery(const DbName: string;
                       const Query: string;
                       const Results: TSqlResults);
var
  DB: TSQLiteDatabase;
  QTab: TSQLiteTable;
  AResult: TSqlResult;
  Index: integer;
begin
  if not SQLite3Loaded then
    exit;

  DB := TSqliteDatabase.Create(DBName, true);
  try
    QTab := Db.GetTable(Query);
    try
      while not QTab.EOF do
      begin
        AResult := TSqlResult.Create;
        for Index := 0 to QTab.ColCount -1 do
          AResult.Add(QTab.FieldAsStringUnicode(Index));
        Results.Add(AResult);
        QTab.Next;
      end;
    finally
      QTab.Free
    end;
  finally
    DB.Free;
  end;
end;

function ExecUpdateSql(const DbName: string;
                       const Query: string): int64;
var
  DB: TSQLiteDatabase;
begin
  result := 0;
  if not SQLite3Loaded then
    exit;

  DB := TSqliteDatabase.Create(DBName, false);
  try
    DB.ExecSQL(Query);
    result := DB.TotalChanges;
  finally
    DB.Free;
  end;
end;

function FieldTypeFromSql(const SqlType: string): TFieldType;
begin
  if (ContainsText(SqlType, 'BOOL')) then
    result := ftInteger
  else if (ContainsText(SqlType, 'INT')) then
    result := ftInteger
  else if (ContainsText(SqlType, 'REAL')) then
    result := ftFloat
  else if (ContainsText(SqlType, 'BLOB')) then
    result := ftBlob
  else if (ContainsText(SqlType, 'TEXT')) then
    result := ftMemo
  else
    result := ftString;
end;

function FieldSizeFromSql(const SqlType: string): integer;
begin
  if (FieldTypeFromSql(SqlType) = ftString) then
    result := 255
  else
    result := 0;
end;

procedure GetExploreList(const DbName: string; const ExploreList: TStrings);
var
  SqlResults: TSqlResults;
  SqlResult: TSqlResult;
begin
  ExploreList.Clear;
  SqlResults := TSqlResults.Create;
  try
    try
      ExecSqlQuery(DbName,
                   'Select Name, hex(UUID) from items where type = 4',
                   SqlResults);
      for SqlResult in SqlResults do
        ExploreList.AddPair(SqlResult[0], MkGuid(SqlResult[1]));
    finally
      SqlResults.Free;
    end;
  except on E:Exception do
    ShowMessage(E.Message);
  end;
end;

function CDSFromQuery(const DbName: string;
                      const Query: string;
                      const ACds: TClientDataSet): integer;
var
  DB: TSQLiteDatabase;
  QTab: TSQLiteTable;
  Index: integer;
  DupName: integer;
  AMemStream: TBytesStream;
  AddedFields: TStringList;
  FieldNameToAdd: string;
begin
  result := 0;
  if not SQLite3Loaded then
    exit;

  AddedFields := TStringList.Create;
  DB := TSqliteDatabase.Create(DBName, true);
  try
    QTab := Db.GetTable(Query);
    ACds.Close;
    ACds.DisableControls;
    ACds.ReadOnly := false;
    ACds.FieldDefs.Clear;
    for Index := 0 to QTab.ColCount -1 do
    begin
      // Check for duplicate FieldName
      FieldNameToAdd := QTab.Columns[Index];
      DupName := 1;
      while (AddedFields.IndexOf(FieldNameToAdd) > 0) do
      begin
        Inc(DupName);
        FieldNameToAdd := Format('%s_%d', [QTab.Columns[Index], DupName]);
      end;
      AddedFields.Add(FieldNameToAdd);

      // Now add to FieldDefs
      ACds.FieldDefs.Add(FieldNameToAdd,
                         FieldTypeFromSql(QTab.Types[Index]),
                         FieldSizeFromSql(QTab.Types[Index]),
                         false);
    end;
    try
      ACds.CreateDataSet;
      for Index := 0 to QTab.ColCount -1 do
        if (FieldTypeFromSql(QTab.Types[Index]) = ftString) then
         ACds.Fields[Index].DisplayWidth := 15;
      ACds.LogChanges := false;

      while not QTab.EOF do
      begin
        ACds.Append;
        for Index := 0 to QTab.ColCount -1 do
        begin
          case Acds.Fields[Index].DataType of
            TFieldType.ftInteger:
              Acds.Fields[Index].AsInteger := Qtab.FieldAsInteger(Index);
            TFieldType.ftFloat:
              Acds.Fields[Index].AsFloat := Qtab.FieldAsDouble(Index);
            TFieldType.ftBlob:
              begin
                AMemStream := Qtab.FieldAsBlobBytes(Index);
                Acds.Fields[Index].AsBytes := AMemStream.Bytes;
                AMemStream.Free;
              end
            else
              Acds.Fields[Index].Value := string(Qtab.FieldAsStringUnicode(Index));
          end;
        end;
        ACds.Post;
        Inc(result);
        QTab.Next;
      end;
    finally
      QTab.Free;
      ACds.EnableControls;
    end;
  finally
    DB.Free;
    AddedFields.Free;
  end;
end;

function GetAvoidancesChanged(const DbName: string): string;
var
  SqlResults: TSqlResults;
  ALine: TSqlResult;
  DBValue: cardinal;
begin
  result := '';
  SqlResults := TSqlResults.Create;
  try
    try
      ExecSqlQuery(DbName,
        'Select value from data_number ' + CRLF +
        'where context like ''%None%''' + CRLF +
        ' and name like ''%Avoid%''' + CRLF +
        ' and name like ''%Changed%''' + CRLF +
        ' limit 1;',
        SqlResults);
      for ALine in SqlResults do
      begin
        DBValue := ALine[0];
        result := '0x' + IntToHex(DBValue, 8);
        break;
      end;
    finally
      SqlResults.Free;
    end;
  except on E:Exception do
    ShowMessage(E.Message);
  end;
end;

function GetActiveVehicleProfile(const DbName: string;
                                 const Model: TGarminModel): TVehicleProfile;
var
  SqlResults: TSqlResults;
  ALine: TSqlResult;
begin
  result := Default(TVehicleProfile);
  SqlResults := TSqlResults.Create;
  try
    try
      case Model of
        TGarminModel.Tread2,
        TGarminModel.XT3:
          ExecSqlQuery(DbName,
            'select v.vehicle_id, v.truck_type, v.name,' + CRLF +
            'Hex(g.description) as Guid_Data,' + CRLF +
            'v.adventurous_route_mode, v.traction, v.road_legality, v.width_metric, v.clearance, v.modified_date,' + CRLF +
            'e.value as Env_Data,' + CRLF +
            'v.calc_method, v.max_vehicle_speed, v.width' + CRLF +
            'from properties_dbg act' + CRLF +
            'join vehicle_profile v on (v.vehicle_id = act.value)' + CRLF +
            'join properties_dbg g on (g.value = act.value and g."description:1" = ''guid'')' + CRLF +
            'join properties_dbg e on (e.key_id = g.key_id and e."description:1" like ''environmental%'')' + CRLF +
            'where act."description:1" = ''active_profile''' + CRLF +
            'limit 1;',
            SqlResults);
        else
          ExecSqlQuery(DbName,  // XT2
            'select v.vehicle_id, v.truck_type, v.name, ' +
            'Hex(v.guid_data) as Guid_Data,' + CRLF +
            'v.adventurous_route_mode, v.traction, v.road_legality, v.width_metric, v.clearance, v.modified_date' + CRLF +
            'from active_vehicle a' + CRLF +
            'join vehicle_profile v on (a.vehicle_id = v.vehicle_id)' + CRLF +
            'limit 1;',
            SqlResults);
      end;

      for ALine in SqlResults do
      begin
        if (ALine.Count < 10) then
          exit;
        result.Valid            := true;
        result.Vehicle_Id       := Aline[0];
        result.TruckType        := Aline[1];
        result.Name             := VarToStr(Aline[2]);
        result.GUID             := MkGuid(VarToStr(Aline[3]));
        result.AdventurousLevel := ALine[4];
        result.Traction         := ALine[5];
        result.Legality         := ALine[6];
        result.Imperial         := ALine[7] = 0;
        result.Clearance        := ALine[8] = 1;
        result.Modified         := ALine[9];
        if (ALine.Count > 13) then
        begin
          result.Environmental  := ALine[10];
          result.Calc_Method    := ALine[11];
          result.Max_Speed      := ALine[12];
          result.Width          := ALine[13];
        end;
        result.Calculate_Proposed_Hash(Model);
        break;
      end;
    finally
      SqlResults.Free;
    end;
  except on E:Exception do
    ShowMessage(E.Message);
  end;
end;

function GetAllVehicleProfilesQuery(const Model: TGarminModel): string;
begin
  case Model of
    TGarminModel.Tread2,
    TGarminModel.XT3:
      result :=
        'select' + CRLF +
        '(select act."description:1" from properties_dbg act where act.value = v.vehicle_id and act."description:1" = ''active_profile'' ) as Status, ' + CRLF +
        'g.description as GUID, ' + CRLF +
        'e.value as Environmental,' + CRLF +
        '0 as Proposed_Hash,' + CRLF +
        'v.*' + CRLF +
        'from vehicle_profile v' + CRLF +
        'join properties_dbg g on (g.value = v.vehicle_id and g."description:1" = ''guid'') ' + CRLF +
        'join properties_dbg e on (e.key_id = g.key_id and e."description:1" like ''environmental%'')' + CRLF +
        'order by Status desc, v.vehicle_id asc';
    else
      result :=
        'select' + CRLF +
        '(select ''active_profile'' from active_vehicle a where a.vehicle_id = v.vehicle_id) as Status, ' + CRLF +
        'v.Guid_Data as GUID, ' + CRLF +
        '0 as Proposed_Hash,' + CRLF +
        'v.*' + CRLF +
        'from vehicle_profile v'
  end;
end;

initialization
  FCDSEvents := TCDSEvents.Create;

finalization
  FCDSEvents.Free;

end.
