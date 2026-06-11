unit UnitRegistry;

interface

uses
  System.TypInfo, System.Classes,
  Winapi.Windows,
  Vcl.Controls;

const
  BooleanValues: array[boolean] of string = ('False', 'True');

function GetRegistry(const Name: string; const Default: string = ''; const SubKey: string = ''): string; overload;
function GetRegistry(const Name: string; const Default: boolean; const SubKey: string = ''): boolean; overload;
function GetRegistry(const Name: string; const Default: int64; const SubKey: string = ''): int64; overload;
function GetRegistry(const Name: string; const Default: integer; AType: PTypeInfo; const SubKey: string = ''): integer; overload;
procedure GetRegistryList(const KeyName: string; const KeyList: TStrings); overload;
{$IFNDEF VER350}
function GetRegistry(const Name: string; const Default: TArray<string>; const SubKey: string = ''): TArray<string>; overload;
{$ENDIF}
procedure SetRegistry(const Name, Value: string; const SubKey: string = ''); overload;
procedure SetRegistry(const Name: string; Value: boolean; const SubKey: string = ''); overload;
procedure SetRegistry(const Name: string; Value: int64; const SubKey: string = ''); overload;
{$IFNDEF VER350}
procedure SetRegistry(const Name: string; Value: TArray<string>; const SubKey: string = ''); overload;
{$ENDIF}
function DeleteRegistryKey(const KeyName: string): boolean; overload;
procedure SaveControlPosition(const RegKey: string; const AControl: TWinControl);
procedure SaveControlSize(const RegKey: string; const AControl: TWinControl);
procedure ReadControlPosition(const RegKey: string; const AControl: TWinControl);
procedure ReadControlSize(const RegKey: string; const AControl: TWinControl);

implementation

uses
  Vcl.Forms,
  System.Win.Registry, System.SysUtils,
  UnitStringUtils;

const
  ControlTop      = '.Top';
  ControlLeft     = '.Left';
  ControlHeight   = '.Heigth';
  ControlWidth    = '.Width';
  ControlDefault  = $ffff;

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

procedure GetRegistryList(const ARootKey: HKEY; const KeyName: string; const KeyList: TStrings); overload;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_READ);
  try
    Registry.RootKey := ARootKey;
    // False because we do not want to create it if it doesn't exist
    if (Registry.OpenKey(KeyName, False)) then
      Registry.GetKeyNames(KeyList);
  finally
    Registry.Free;
  end;
end;

procedure GetRegistryList(const KeyName: string; const KeyList: TStrings);
begin
  GetRegistryList(HKEY_CURRENT_USER, SubApplicationKey(KeyName), KeyList);
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

function GetRegistry(const Name: string; const Default: int64; const SubKey: string = ''): int64;
begin
  result := StrToInt64Def(GetRegistryValue(HKEY_CURRENT_USER, SubApplicationKey(SubKey), Name, IntToStr(Default)), 0);
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
  SetRegistryValue(HKEY_CURRENT_USER, SubApplicationKey(SubKey), Name, BooleanValues[Value]);
end;

procedure SetRegistry(const Name: string; Value: int64; const SubKey: string = '');
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

function DeleteRegistryKey(const ARootKey: HKEY; const KeyName: string): boolean; overload;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create(KEY_ALL_ACCESS);
  try
    Registry.RootKey := ARootKey;
    result := Registry.DeleteKey(KeyName);
  finally
    Registry.Free;
  end;
end;

function DeleteRegistryKey(const KeyName: string): boolean;
begin
  result := DeleteRegistryKey(HKEY_CURRENT_USER, SubApplicationKey(KeyName));
end;

procedure SaveControlPosition(const RegKey: string; const AControl: TWinControl);
begin
  SetRegistry(AControl.Name + ControlTop, AControl.Top, RegKey);
  SetRegistry(AControl.Name + ControlLeft, AControl.Left, RegKey);
end;

procedure SaveControlSize(const RegKey: string; const AControl: TWinControl);
begin
  SetRegistry(AControl.Name + ControlWidth, AControl.Width, RegKey);
  SetRegistry(AControl.Name + ControlHeight, AControl.Height, RegKey);
end;

procedure ReadControlPosition(const RegKey: string; const AControl: TWinControl);
begin
  if (GetRegistry(AControl.Name + ControlTop, ControlDefault, RegKey) <> ControlDefault) then
    AControl.Top := GetRegistry(AControl.Name + ControlTop, ControlDefault, RegKey);
  if (GetRegistry(AControl.Name + ControlLeft, ControlDefault, RegKey) <> ControlDefault) then
    AControl.Left := GetRegistry(AControl.Name + ControlLeft, ControlDefault, RegKey);
end;

procedure ReadControlSize(const RegKey: string; const AControl: TWinControl);
begin
  if (GetRegistry(AControl.Name + ControlHeight, ControlDefault, RegKey) <> ControlDefault) then
    AControl.Height := GetRegistry(AControl.Name + ControlHeight, ControlDefault, RegKey);
  if (GetRegistry(AControl.Name + ControlWidth, ControlDefault, RegKey) <> ControlDefault) then
    AControl.Width := GetRegistry(AControl.Name + ControlWidth, ControlDefault, RegKey);
end;

end.
