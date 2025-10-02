unit UnitSqlite;

interface

uses
  System.Generics.Collections, System.Classes,
  Data.DB, Datasnap.DBClient,
  SQLiteWrap;

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
  end;

  TSqlResult = Tlist<Variant>;
  TSqlResults = TObjectList<TSqlResult>;

procedure GetTables(const DbName: string; TabList: TStrings);
function GetColumns(const DbName: string;
                    const TabName: string): TSqlColumns; overload;
function GetColumns(const Db: TSQLiteDatabase;
                    const TabName: string): TSqlColumns; overload;
function ExecSqlQuery(const DbName: string;
                      const Query: string): TSqlResults;
function GetAvoidancesChanged(const DbName: string): string;
function GetVehicleProfile(const DbName: string): TVehicleProfile;
function CDSFromQuery(const DbName: string;
                      const Query: string;
                      const ACds: TClientDataSet): integer;
implementation

uses
  System.Variants, System.SysUtils, System.StrUtils,
  Winapi.Windows;

const
  CRLF = #13#10;

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
    'WHERE m.type IN (''table'')' + CRLF +
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
  Db := TSQLiteDatabase.Create(DbName);
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
  DB := TSqliteDatabase.Create(DBName);
  try
    TableNames(DB, TabList);
  finally
    DB.Free;
  end;
end;

function ExecSqlQuery(const DbName: string;
                      const Query: string): TSqlResults;
var
  DB: TSQLiteDatabase;
  QTab: TSQLiteTable;
  AResult: TSqlResult;
  Index: integer;
begin
  result := TSqlResults.Create(true);
  DB := TSqliteDatabase.Create(DBName);
  try
    QTab := Db.GetTable(Query);
    try
      while not QTab.EOF do
      begin
        AResult := TSqlResult.Create;
        for Index := 0 to QTab.ColCount -1 do
          AResult.Add(QTab.FieldAsStringUnicode(Index));
        result.Add(AResult);
        QTab.Next;
      end;
    finally
      QTab.Free
    end;
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

function CDSFromQuery(const DbName: string;
                      const Query: string;
                      const ACds: TClientDataSet): integer;
var
  DB: TSQLiteDatabase;
  QTab: TSQLiteTable;
  Index: integer;
  AMemStream: TBytesStream;
begin
  result := 0;
  DB := TSqliteDatabase.Create(DBName);
  try
    QTab := Db.GetTable(Query);
    ACds.Close;
    ACds.DisableControls;
    ACds.ReadOnly := false;
    ACds.FieldDefs.Clear;
    for Index := 0 to QTab.ColCount -1 do
      ACds.FieldDefs.Add(QTab.Columns[Index],
                         FieldTypeFromSql(QTab.Types[Index]),
                         FieldSizeFromSql(QTab.Types[Index]),
                         false);
    try
      ACds.CreateDataSet;
      for Index := 0 to QTab.ColCount -1 do
        if (FieldTypeFromSql(QTab.Types[Index]) = ftString) then
         ACds.Fields[Index].DisplayWidth := 15;
      ACds.LogChanges := false;

      while not QTab.EOF do
      begin
        ACds.Insert;
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
  end;

end;

function GetAvoidancesChanged(const DbName: string): string;
var
  SqlResults: TSqlResults;
  ALine: TSqlResult;
  DBValue: cardinal;
begin
  result := '';
  SqlResults := ExecSqlQuery(DbName,
    'Select value from data_number ' + CRLF +
    'where context like ''%None%'' and name like ''%Avoid%''' + CRLF+
    'limit 1;');
  try
    for ALine in SqlResults do
    begin
      DBValue := ALine[0];
      result := '0x' + IntToHex(DBValue, 8);
      break;
    end;
  finally
    SqlResults.Free;
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

function GetVehicleProfile(const DbName: string): TVehicleProfile;
var
  SqlResults: TSqlResults;
  ALine: TSqlResult;
begin
  FillChar(result, SizeOf(result), 0);

  SqlResults := ExecSqlQuery(DbName,
    'select v.vehicle_id, v.truck_type, v.name, Hex(v.guid_data), v.vehicle_type, v.transport_mode, v.adventurous_route_mode' + CRLF +
    'from active_vehicle a' + CRLF +
    'join vehicle_profile v on (a.vehicle_id = v.vehicle_id)' + CRLF +
    'limit 1;');
  try
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
      break;
    end;
  finally
    SqlResults.Free;
  end;
end;

end.
