unit UnitRegistry;

interface

uses
  System.Win.Registry, System.TypInfo,
  Winapi.Windows;

const
  BooleanValues: array[boolean] of string = ('False', 'True');

function GetRegistry(const Name: string; const Default: string = ''; const SubKey: string = ''): string; overload;
function GetRegistry(const Name: string; const Default: boolean): boolean; overload;
function GetRegistry(const Name: string; const Default: integer): integer; overload;
function GetRegistry(const Name: string; const Default: integer; AType: PTypeInfo): integer; overload;
{$IFNDEF VER350}
function GetRegistry(const Name: string; const Default: TArray<string>): TArray<string>; overload;
{$ENDIF}
procedure SetRegistry(const Name, Value: string; const SubKey: string = ''); overload;
procedure SetRegistry(const Name: string; Value: boolean); overload;
procedure SetRegistry(const Name: string; Value: integer); overload;
{$IFNDEF VER350}
procedure SetRegistry(const Name: string; Value: TArray<string>); overload;
{$ENDIF}

implementation

uses
  Vcl.Forms,
  System.SysUtils,
  UnitStringUtils;

function ApplicationKey: string;
begin
  result := 'Software\TDBware\' + Application.Title;
end;

function GetRegistryValue(const ARootKey: HKEY; const KeyName, Name: string; const Default: string = ''): string;
var
  Registry: TRegistry;
begin
  result := '';
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := ARootKey;
    // False because we do not want to create it if it doesn't exist
    if (Registry.OpenKey(KeyName, False)) then
      result := Registry.ReadString(Name);
  finally
    Registry.Free;
  end;
  if (result = '') then
    result := Default;
end;

function GetRegistry(const Name: string; const Default: string = ''; const SubKey: string = ''): string;
var
  KeyName: string;
begin
  KeyName := ApplicationKey;
  if (SubKey <> '') then
    KeyName := KeyName + '\' + ReplaceAll(SubKey, [':\'],  ['']);
  result := GetRegistryValue(HKEY_CURRENT_USER, KeyName, Name, Default);
end;

function GetRegistry(const Name: string; const Default: boolean): boolean;
begin
  result := SameText(GetRegistryValue(HKEY_CURRENT_USER, ApplicationKey, Name, BooleanValues[Default]), BooleanValues[True]);
end;

function GetRegistry(const Name: string; const Default: integer): integer;
begin
  result := StrToint(GetRegistryValue(HKEY_CURRENT_USER, ApplicationKey, Name, IntToStr(Default)));
end;

function GetRegistry(const Name: string; const Default: integer; AType: PTypeInfo): integer;
begin
  result := GetEnumValue(AType, GetRegistry(Name, GetEnumName(AType, Default)));
end;

{$IFNDEF VER350}
function GetRegistry(const Name: string; const Default: TArray<string>): TArray<string>; overload;
var
  Registry: TRegistry;
  KeyName: string;
begin
  SetLength(result, 0);
  KeyName := ApplicationKey;

  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if (Registry.OpenKey(KeyName, False)) then
      result := Registry.ReadMultiString(Name);
  finally
    Registry.Free;
  end;
  if (Length(Result) = 0) then
    result := Default;
end;
{$ENDIF}

procedure SetRegistryValue(const ARootKey: HKEY; const KeyName, Name, Value: string);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_WRITE);
  try
    Registry.RootKey := ARootKey;
    Registry.OpenKey(KeyName, True);
    Registry.WriteString(Name, Value);
  finally
    Registry.Free;
  end;
end;

procedure SetRegistry(const Name, Value: string; const SubKey: string = '');
var
  KeyName: string;
begin
  KeyName := ApplicationKey;
  if (SubKey <> '') then
    KeyName := KeyName + '\' + ReplaceAll(SubKey, [':\'],  ['']);
  SetRegistryValue(HKEY_CURRENT_USER, KeyName, Name, Value);
end;

procedure SetRegistry(const Name: string; Value: boolean);
begin
  SetRegistryValue(HKEY_CURRENT_USER, ApplicationKey, Name, BooleanValues[Value]);
end;

procedure SetRegistry(const Name: string; Value: integer);
begin
  SetRegistryValue(HKEY_CURRENT_USER, ApplicationKey, Name, IntToStr(Value));
end;

{$IFNDEF VER350}
procedure SetRegistry(const Name: string; Value: TArray<string>);
var
  Registry: TRegistry;
  KeyName: string;
begin
  KeyName := ApplicationKey;

  Registry := TRegistry.Create(KEY_WRITE);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKey(KeyName, True);
    Registry.WriteMultiString(Name, Value);
  finally
    Registry.Free;
  end;
end;
{$ENDIF}

end.
