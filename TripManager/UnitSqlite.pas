unit UnitSqlite;

interface
{.$DEFINE AVOIDANCES}  // Not needed for ProfileHash

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
{$IFDEF AVOIDANCES}
    Avoidances: integer;
{$ENDIF}
    Calc_Method: integer;
    Max_Speed: integer;
    Proposed_Hash: cardinal;
    procedure Calculate_ProposedHash(const Model: TGarminModel);
    function Changed(IName, IGUID: UTF8String;
                     IVehicle_Id, ITruckType, ITransportMode: integer;
                     IEnvironmental, ICalc_Method: integer): boolean; overload;
    function Changed(IVehicleProfile: TVehicleProfile): boolean; overload;
  end;

  TSqlResult = Tlist<Variant>;
  TSqlResults = TObjectList<TSqlResult>;

  TProfCalcMethod  = (cmFaster = 0, cmShorter = 1, cmAdv = 7);
  TProfAdvLevel    = (advL1 = 0, advL2 = 1, advL3 = 2, advL4 = 3);
  TProfEnvironment = (enAvoid = 0, enAllow = 1, enAsk = 2);
  TKnownHash = record
    CM: TProfCalcMethod;
    AdvLvl: TProfAdvLevel;
    Hash: Cardinal;
  end;

const
  KnownXT3Environments: array[TProfEnvironment] of Cardinal =
    ($0000B000, $0000A000, $00009000);

  KnownXT3Hashes: array[0..5] of TKnownHash = (
    (CM: cmFaster;              Hash: $0A4F0F20),
    (CM: cmShorter;             Hash: $07E0BF20),
    (CM: cmAdv; AdvLvl: advL1;  Hash: $0A4A0F20),
    (CM: cmAdv; AdvLvl: advL2;  Hash: $0A7A0F20),
    (CM: cmAdv; AdvLvl: advL3;  Hash: $0AAA0F20),
    (CM: cmAdv; AdvLvl: advL4;  Hash: $0A4F0F20)
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

function MkGuid(const HexGuid: string): string;
begin
  result := LowerCase(HexGuid);
  insert('-', result, 9);
  insert('-', result, 14);
  insert('-', result, 19);
  insert('-', result, 24);
end;

procedure TVehicleProfile.Calculate_ProposedHash(const Model: TGarminModel);
var
  Index: integer;
begin
  Proposed_Hash := 0;
  // Only MotorCycles
  if (VehicleType <> 9) then
    exit;
  //TODO: Figure out how max_speed works
  if (Max_Speed <> 0) then
    exit;
  // Only 2 Wheels traction
  if( Traction <> 4) then
    exit;
  // Valid Environmental value
  if (Environmental < Ord(TProfEnvironment.enAvoid)) or
     (Environmental > Ord(TProfEnvironment.enAsk)) then
    exit;

  case Model of
    TGarminModel.XT3:
      begin
        for Index := Low(KnownXT3Hashes) to High(KnownXT3Hashes) do
        begin
          if (TProfCalcMethod(Calc_Method) <> KnownXT3Hashes[Index].CM) then
            continue;
          if (TProfCalcMethod(Calc_Method) = TProfCalcMethod.cmAdv) and
             (TProfAdvLevel(AdventurousLevel) <> KnownXT3Hashes[Index].AdvLvl) then
            continue;
          Proposed_Hash := KnownXT3Hashes[Index].Hash or
                              KnownXT3Environments[TProfEnvironment(Environmental)];
          break;
        end;
      end;
  end;
end;

function TVehicleProfile.Changed(IName, IGUID: UTF8String;
                                 IVehicle_Id, ITruckType, ITransportMode: integer;
                                 IEnvironmental, ICalc_Method: integer): boolean;
begin
  result := (Name <> IName) or
            (GUID <> IGUID) or
            (Vehicle_Id <> IVehicle_Id) or
            (TruckType <> ITruckType) or
            (TransportMode <> ITransportMode) or
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
                    IVehicleProfile.Environmental,
                    IVehicleProfile.Calc_Method);
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
            'v.calc_method, v.max_vehicle_speed, v.traction' + CRLF +
{$IFDEF AVOIDANCES}
            ', (select a.value from properties_dbg a where ' +
            'a.key_id = g.key_id and a."description:1" is null limit 1) as Avoid_Data' + CRLF +
{$ENDIF}
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
        if (ALine.Count > 10) then
        begin
          result.Environmental  := ALine[7];
          result.Calc_Method    := ALine[8];
          result.Max_Speed      := ALine[9];
          result.Traction       := ALine[10];
{$IFDEF AVOIDANCES}
          result.Avoidances     := StrToIntDef(ALine[11], 0);
{$ENDIF}
        end;
        result.Calculate_ProposedHash(Model);
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
