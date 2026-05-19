unit UnitRegistry;

interface

uses
  System.Win.Registry, System.TypInfo,
  Winapi.Windows;

const
  BooleanValues: array[boolean] of string = ('False', 'True');

function GetRegistry(const Name: string; const Default: string = ''; const SubKey: string = ''): string; overload;
function GetRegistry(const Name: string; const Default: boolean; const SubKey: string = ''): boolean; overload;
function GetRegistry(const Name: string; const Default: integer; const SubKey: string = ''): integer; overload;
function GetRegistry(const Name: string; const Default: integer; AType: PTypeInfo; const SubKey: string = ''): integer; overload;
{$IFNDEF VER350}
function GetRegistry(const Name: string; const Default: TArray<string>; const SubKey: string = ''): TArray<string>; overload;
{$ENDIF}
procedure SetRegistry(const Name, Value: string; const SubKey: string = ''); overload;
procedure SetRegistry(const Name: string; Value: boolean; const SubKey: string = ''); overload;
procedure SetRegistry(const Name: string; Value: integer; const SubKey: string = ''); overload;
{$IFNDEF VER350}
procedure SetRegistry(const Name: string; Value: TArray<string>; const SubKey: string = ''); overload;
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

function SubApplicationKey(const SubKey: string): string;
begin
  result := ApplicationKey;
  if (SubKey <> '') then
    result := result + '\' + ReplaceAll(SubKey, [':\'],  ['']);
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
begin
  result := GetRegistryValue(HKEY_CURRENT_USER, SubApplicationKey(SubKey), Name, Default);
end;

function GetRegistry(const Name: string; const Default: boolean; const SubKey: string = ''): boolean;
begin
  result := SameText(GetRegistryValue(HKEY_CURRENT_USER, SubApplicationKey(SubKey), Name, BooleanValues[Default]), BooleanValues[True]);
end;

function GetRegistry(const Name: string; const Default: integer; const SubKey: string = ''): integer;
begin
  result := StrToIntDef(GetRegistryValue(HKEY_CURRENT_USER, SubApplicationKey(SubKey), Name, IntToStr(Default)), 0);
end;

function GetRegistry(const Name: string; const Default: integer; AType: PTypeInfo; const SubKey: string = ''): integer;
begin
  result := GetEnumValue(AType, GetRegistry(Name, GetEnumName(AType, Default), SubKey));
end;

{$IFNDEF VER350}
function GetRegistry(const Name: string; const Default: TArray<string>; const SubKey: string = ''): TArray<string>; overload;
var
  Registry: TRegistry;
begin
  SetLength(result, 0);
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    if (Registry.OpenKey(SubApplicationKey(SubKey), False)) then
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
begin
  SetRegistryValue(HKEY_CURRENT_USER, SubApplicationKey(SubKey), Name, Value);
end;

procedure SetRegistry(const Name: string; Value: boolean; const SubKey: string = '');
begin
  SetRegistryValue(HKEY_CURRENT_USER, ApplicationKey, SubApplicationKey(SubKey), BooleanValues[Value]);
end;

procedure SetRegistry(const Name: string; Value: integer; const SubKey: string = '');
begin
  SetRegistryValue(HKEY_CURRENT_USER, SubApplicationKey(SubKey), Name, IntToStr(Value));
end;

{$IFNDEF VER350}
procedure SetRegistry(const Name: string; Value: TArray<string>; const SubKey: string = '');
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_WRITE);
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKey(SubApplicationKey(SubKey), True);
    Registry.WriteMultiString(Name, Value);
  finally
    Registry.Free;
  end;
end;
{$ENDIF}

end.
