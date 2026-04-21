unit UnitSqlite;

interface

uses
  System.Generics.Collections, System.Classes,
  Data.DB, Datasnap.DBClient,
  SQLiteWrap,
  UnitGpxDefs;

type
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
    Name: UTF8String;
    GUID: UTF8String;
    VehicleType: integer;
    TransportMode: integer;
    AdventurousLevel: integer;
    Environmental: integer;
    Traction: integer;
    Calc_Method: integer;
    Max_Speed: integer;
    Width: integer;
    Imperial: boolean;
    Legality: integer;
    Proposed_Hash: cardinal;
    function HashSpeed1: cardinal;
    function HashSpeed2: cardinal;
    function HashSpeed3: cardinal;
    procedure Calculate_Proposed_Motor_Hash(const Model: TGarminModel);
    procedure Calculate_Proposed_Car_Hash(const Model: TGarminModel);
    procedure Calculate_Proposed_Hash(const Model: TGarminModel);
    function Changed(IName, IGUID: UTF8String;
                     IVehicle_Id, ITruckType, ITransportMode, ITraction: integer;
                     IEnvironmental, ICalc_Method, ILegality: integer): boolean; overload;
    function Changed(IVehicleProfile: TVehicleProfile): boolean; overload;
  end;

  TSqlResult = Tlist<Variant>;
  TSqlResults = TObjectList<TSqlResult>;

  TProfCalcMethod  = (cmFaster = 0, cmShorter = 1, cmStraight = 4, cmAdv = 7);
  TRoadLegality    = (rlNone = 0, rlNoHighway = 1, rlLegal = 2);
  TProfAdvLevel    = (advL1 = 0, advL2 = 1, advL3 = 2, advL4 = 3);
  TProfEnvironment = (enAvoid = 0, enAllow = 1, enAsk = 2);
  TTraction        = (tr2WD =1, tr3Wheels = 3, tr2Wheels = 4);
  TVehicleType     = (veCar = 1, veMotorCycle = 9);
  TKnownHash = record
    CM: TProfCalcMethod;
    AdvLvl: TProfAdvLevel;
    HashT2: Cardinal;
    HashT3: Cardinal;
    Hash2WD: Cardinal;
  end;

const
  XT3_Motor_environments: array[TRoadLegality, TProfEnvironment] of Cardinal =
    (
      ($00000000, $00000000, $00000000),  // Not legal, Not implemented
      ($00008000, $00009000, $0000A000),  // Not Highway legal
      ($0000B000, $0000A000, $00009000)   // Legal
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

  XT3_Car_environments: array[TProfEnvironment] of Cardinal =
      ($00000000, $00001000, $00002000);

  XT3_Car_Hashes: array[0..6] of TKnownHash = (
    (CM: cmFaster;              Hash2WD: $023F0F10),
    (CM: cmShorter;             Hash2WD: $00300F20),
    (CM: cmStraight;            Hash2WD: $002B0F20),
    (CM: cmAdv; AdvLvl: advL1;  Hash2WD: $023A0F10),
    (CM: cmAdv; AdvLvl: advL2;  Hash2WD: $020A0F10),
    (CM: cmAdv; AdvLvl: advL3;  Hash2WD: $021A0F10),
    (CM: cmAdv; AdvLvl: advL4;  Hash2WD: $026A0F10)
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
function GetVehicleProfile(const DbName: string;
                           const Model: TGarminModel): TVehicleProfile;
procedure GetExploreList(const DBName: string;
                         const ExploreList: TStrings);
function CDSFromQuery(const DbName: string;
                      const Query: string;
                      const ACds: TClientDataSet): integer;

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
  Speed2TabImperial: array[0..15] of byte =
   ($0d, $0c, $0f, $0e, $09, $08, $0b, $0a, $05, $04, $07, $06, $01, $00, $03, $02);
//  0=d  1=c  2=f  3=e  4=9  5=8  6=b  7=a  8=5  9=4  a=7  b=6  c=1  d=0  e=3  f=2
  Speed2TabMetric: array[0..15] of byte =
   ($0f, $0e, $0d, $0c, $0b, $0a, $09, $08, $07, $06, $05, $04, $03, $02, $01, $00);
//  0=f  1=e  2=d  3=c  4=b  5=a  6=9  7=8  8=7  9=6  a=5  b=4  c=3  d=2  e=1  f=0
begin
  if (Imperial) then
    result := (Speed2TabImperial[(Max_Speed and $000000f0) shr 4]) shl 8
  else
    result := (Speed2TabMetric[(Max_Speed and $000000f0) shr 4]) shl 8;
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

procedure TVehicleProfile.Calculate_Proposed_Motor_Hash(const Model: TGarminModel);
var
  Index: integer;
begin
  if (Max_Speed > Max_Speed_Supported) then
    exit;

  // Only 2, or 3 Wheels traction
  if not (Traction in [Ord(TTraction.tr3Wheels),        // 3 Wheels
                       Ord(TTraction.tr2Wheels)]) then  // 2 Wheels
    exit;

  // For 3 wheels must be width 120 if metric, non-imperial = 122
  if (Traction = Ord(TTraction.tr3Wheels)) and
     (Imperial = false) and
     (Width <> 120) then
    exit;

  if (Traction = Ord(TTraction.tr3Wheels)) and
     (Imperial = true) and
     (Width <> 122) then
    exit;

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
        for Index := Low(XT3_Motor_Hashes) to High(XT3_Motor_Hashes) do
        begin
          if (TProfCalcMethod(Calc_Method) <> XT3_Motor_Hashes[Index].CM) then
            continue;
          if (TProfCalcMethod(Calc_Method) = TProfCalcMethod.cmAdv) and
             (TProfAdvLevel(AdventurousLevel) <> XT3_Motor_Hashes[Index].AdvLvl) then
            continue;

          if (Traction = Ord(TTraction.tr2Wheels)) then // 2 Wheels
            Proposed_Hash := XT3_Motor_Hashes[Index].HashT2 or
                                XT3_Motor_environments[TRoadLegality(Legality), TProfEnvironment(Environmental)]
          else                   // 3 Wheels
            Proposed_Hash := XT3_Motor_Hashes[Index].Hasht3 or
                                XT3_Motor_environments[TRoadLegality(Legality), TProfEnvironment(Environmental)];

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
begin
  if (Max_Speed <> 0) then
    exit;

  // Only 2WD, 2 Axles
  if not (Traction in [Ord(TTraction.tr2WD)]) then
    exit;

  // Onle 2 Meter wide
  if (Width <> 200) then
    exit;

  // Valid Environmental value
  if not (Environmental in [Ord(TProfEnvironment.enAvoid),
                            Ord(TProfEnvironment.enAllow),
                            Ord(TProfEnvironment.enAsk)]) then
    exit;

  // Valid Legality
  if not (Legality in [2]) then
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

          Proposed_Hash := XT3_Car_Hashes[Index].Hash2WD or
                              XT3_Car_environments[TProfEnvironment(Environmental)];
          break;
        end;
      end;
  end;


end;

procedure TVehicleProfile.Calculate_Proposed_Hash(const Model: TGarminModel);
begin
  Proposed_Hash := 0;

  case VehicleType of
    Ord(TVehicleType.veCar):
      Calculate_Proposed_Car_Hash(Model);
    Ord(TVehicleType.veMotorCycle):
      Calculate_Proposed_Motor_Hash(Model);
  end;
end;

function TVehicleProfile.Changed(IName, IGUID: UTF8String;
                                 IVehicle_Id, ITruckType, ITransportMode, ITraction: integer;
                                 IEnvironmental, ICalc_Method, ILegality: integer): boolean;
begin
  result := (Name <> IName) or
            (GUID <> IGUID) or
            (Vehicle_Id <> IVehicle_Id) or
            (TruckType <> ITruckType) or
            (TransportMode <> ITransportMode) or
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
                    IVehicleProfile.TransportMode,
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

function GetVehicleProfile(const DbName: string;
                           const Model: TGarminModel): TVehicleProfile;
var
  SqlResults: TSqlResults;
  ALine: TSqlResult;
begin
  FillChar(result, SizeOf(result), 0);
  SqlResults := TSqlResults.Create;
  try
    try
      case Model of
        TGarminModel.Tread2,
        TGarminModel.XT3:
          ExecSqlQuery(DbName,
            'select v.vehicle_id, v.truck_type, v.name,' + CRLF +
            'Hex(g.description) as Guid_Data,' + CRLF +
            'v.vehicle_type, v.transport_mode, v.adventurous_route_mode,' + CRLF +
            'e.value as Env_Data,' + CRLF +
            'v.calc_method, v.max_vehicle_speed, v.traction, v.width, v.width_metric, v.road_legality' + CRLF +
            'from properties_dbg act' + CRLF +
            'join vehicle_profile v on (v.vehicle_id = act.value)' + CRLF +
            'join properties_dbg g on (g.value = act.value and g."description:1" = ''guid'')' + CRLF +
            'join properties_dbg e on (e.key_id = g.key_id and e."description:1" like ''environmental%'')' + CRLF +
            'where act."description:1" = ''active_profile''' + CRLF +
            'limit 1;',
            SqlResults);
        else
          ExecSqlQuery(DbName,
            'select v.vehicle_id, v.truck_type, v.name, Hex(v.guid_data), v.vehicle_type, v.transport_mode, v.adventurous_route_mode' + CRLF +
            'from active_vehicle a' + CRLF +
            'join vehicle_profile v on (a.vehicle_id = v.vehicle_id)' + CRLF +
            'limit 1;',
            SqlResults);
      end;

      for ALine in SqlResults do
      begin
        if (ALine.Count < 7) then
          exit;
        result.Valid            := true;
        result.Vehicle_Id       := Aline[0];
        result.TruckType        := Aline[1];
        result.Name             := Utf8String(VarToStr(Aline[2]));
        result.GUID             := Utf8String(MkGuid(VarToStr(Aline[3])));
        result.VehicleType      := ALine[4];
        result.TransportMode    := ALine[5];
        result.AdventurousLevel := ALine[6];
        if (ALine.Count > 13) then
        begin
          result.Environmental  := ALine[7];
          result.Calc_Method    := ALine[8];
          result.Max_Speed      := ALine[9];
          result.Traction       := ALine[10];
          result.Width          := ALine[11];
          result.Imperial       := ALine[12] = 0;
          result.Legality       := ALine[13];
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

end.
