unit UnitStringUtils;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  System.Sysutils, System.Variants, System.Classes,
  Winapi.ShellAPI, Winapi.Windows;

type
  T4Bytes = array[0..3] of byte;

function SenSize(const S: int64): string;
function Intd(const N: Integer; const D: Integer): string;
function Spc(const Cnt: integer): string;
function NextField(var AString: string; const ADelimiter: string): string;
function ReplaceAll(const AString: string;
                    const OldPatterns, NewPatterns: array of string;
                    Flags: TReplaceFlags = [rfReplaceAll]): string;
procedure SetSubString(var AString: string; const Pos: integer; SubString: string);
function Swap32(I: T4Bytes): T4Bytes; overload; inline;
function Swap32(I: Cardinal): Cardinal; overload; inline;
function Swap32(I: integer): integer; overload; inline;
function Swap32(I: single): single; overload; inline;
function ValidLatLon(const Lat, Lon: string): boolean;
procedure ParseLatLon(const LatLon: string; var Lat, Lon: string);
procedure AdjustLatLon(var Lat, Lon: string; No_Decimals: integer);
procedure CheckHRGuid(HR: Hresult);
procedure PrepStream(TmpStream: TMemoryStream; const Buffer: array of Cardinal);  overload;
procedure PrepStream(TmpStream: TMemoryStream; const Count: Cardinal; const Buffer: array of WORD); overload;

procedure DebugMsg(const Msg: array of variant);
function TempFilename(const Prefix: string): string;
function GetAppData: string;
function EscapeHtml(const HTML: string): string;
function EscapeDQuote(const HTML: string): string;
function EscapeFileName(InFile: string): string;
function CreateTempPath(const Prefix: string): string;
function GetHtmlTmp: string;
function GetTracksExt: string;
function GetTracksMask: string;
function GetTracksTmp: string;
function GetOSMTemp: string;
function GetRoutesTmp: string;
function GetDeviceTmp: string;
function GPX2HTMLColor(GPXColor: string): string;
function GetLocaleSetting: TFormatSettings;
function VerInfo(IncludeCompany: boolean = false): string;
function UserAgent: string;

var
  CreatedTempPath: string;
  App_Prefix: string;

implementation

uses
  System.Math, System.StrUtils, Winapi.ShlObj, Winapi.KnownFolders, Winapi.ActiveX,
  Vcl.Forms, Vcl.Dialogs,
  MsgLoop;

var
  FloatFormatSettings: TFormatSettings; // for FormatFloat -see Initialization

const
  LenFileSize = 11;
  B  = ' B';
  Kb = ' Kb';
  Mb = ' Mb';
  HtmlTempFileName  = '.html';
  TrackFileExt    = '.track';
  OSMDir            = 'OSM\';
  RoutesDir         = 'Routes\';
  DeviceDir         = 'Device\';

function SenSize(const S: int64): string;
var
  H: string;
  I: int64;
begin
  H := Spc(LenFileSize);
  if S < (1000000) then
    result := H + FormatFloat('#,##0', S) + B
  else if S < (1000000000) then
    result := H + FormatFloat('#,##0', S / 1024) + Kb
  else
    result := H + FormatFloat('#,##0', S / (1024 * 1024)) + Mb;
  I := Length(result);
  result := Copy(result, I - LenFileSize + 1, LenFileSize);
end;

function Intd(const N: Integer; const D: Integer): string;
var
  L: integer;
begin
  result := IntToStr(N);
  L := D - Length(result);
  if L >= 0 then
    result := StringOfChar(char('0'), L) + result
  else
    result := StringOfChar(char('*'), D);
end;

function Spc(const Cnt: integer): string;
begin
  result := StringOfChar(char(' '), Cnt);
end;

function NextField(var AString: string; const ADelimiter: string): string;
var
  Indx: integer;
  L: integer;
begin
  L := Length(ADelimiter);
  Indx := Pos(ADelimiter, AString);
  if Indx < 1 then
  begin
    result := AString;
    AString := '';
  end
  else
  begin
    result := Copy(AString, 1, Indx - 1);
    Delete(AString, 1, Indx + L - 1);
  end;
end;

function ReplaceAll(const AString: string;
                    const OldPatterns, NewPatterns: array of string;
                    Flags: TReplaceFlags = [rfReplaceAll]): string;
var
  PatternHigh: integer;
  Index: integer;
begin
  PatternHigh := Min(High(NewPatterns), High(OldPatterns));
  if (PatternHigh < 0) then
    exit(AString);

  result := StringReplace(AString, OldPatterns[0], NewPatterns[0], Flags);
  for Index := 1 to PatternHigh do
    result := StringReplace(result, OldPatterns[Index], NewPatterns[Index], Flags);
end;

procedure SetSubString(var AString: string; const Pos: integer; SubString: string);
var
  ActPos: integer;
begin
  ActPos := Min(Length(AString), Pos);
  Delete(Astring, ActPos, Length(SubString));
  Insert(SubString, AString, ActPos);
end;

function Swap32(I: T4Bytes): T4Bytes;
begin
  result[0] := I[3];
  result[1] := I[2];
  result[2] := I[1];
  result[3] := I[0];
end;

function Swap32(I: Cardinal): Cardinal;
begin
  result := Cardinal(Swap32(T4BYtes(I)));
end;

function Swap32(I: integer): integer;
begin
  result := Cardinal(Swap32(T4BYtes(I)));
end;

function Swap32(I: single): single;
begin
  result := Single(Swap32(T4BYtes(I)));
end;

function ValidLatLon(const Lat, Lon: string): boolean;
var
  ADouble: Double;
begin
  result := TryStrToFloat(Lat, ADouble, FloatFormatSettings);
  result := result and (Abs(ADouble) <= 90);
  result := result and TryStrToFloat(Lon, ADouble, FloatFormatSettings);
  result := result and (Abs(ADouble) <= 180);
end;

function AdjustUsingRound(const ADecimal: string; No_Decimals: integer): string;
var
  F: double;
begin
  if TryStrToFloat(ADecimal, F, FloatFormatSettings) then
  begin
    F := RoundTo(F, -No_Decimals);
    result := FloatToStr(F, FloatFormatSettings);
  end;
end;

procedure PrepStream(TmpStream: TMemoryStream; const Buffer: array of Cardinal);
begin
  TmpStream.Clear;
  TmpStream.Write(Buffer, SizeOf(Buffer));
  TmpStream.Position := 0;
end;

procedure PrepStream(TmpStream: TMemoryStream; const Count: Cardinal; const Buffer: array of WORD);
var
  SwapCount: Cardinal;
begin
  SwapCount := Swap32(Count);
  TmpStream.Clear;
  TmpStream.Write(SwapCount, SizeOf(SwapCount));
  TmpStream.Write(Buffer, SizeOf(Buffer));
  TmpStream.Position := 0;
end;

procedure CheckHRGuid(HR: Hresult);
begin
  Assert(HR = S_OK, 'Error creating GUID');
end;

procedure AdjustLatLon(var Lat, Lon: string; No_Decimals: integer);
begin
  Lat := AdjustUsingRound(Lat, No_Decimals);
  Lon := AdjustUsingRound(Lon, No_Decimals);
end;

procedure ParseLatLon(const LatLon: string; var Lat, Lon: string);
begin
  Lon := LatLon;
  Lat := Trim(NextField(Lon, ','));
  Lon := Trim(Lon);
end;

procedure DebugMsg(const Msg: array of variant);
var I: integer;
    FMsg: string;
begin
  Fmsg := Format('%s %s %s', ['MTP_Helper', Paramstr(0), IntToStr(GetCurrentThreadId)]);
  for I := 0 to High(Msg) do
    FMsg := Format('%s,%s', [FMsg, VarToStr(Msg[I])]);
  OutputDebugString(PChar(FMsg));
end;

function TempPath: string;
var ADir: array [0 .. MAX_PATH] of char;
begin
  GetTempPath(MAX_PATH, ADir);
  result := StrPas(ADir);
end;

function TempFilename(const Prefix: string): string;
var
  AName, ADir: array [0 .. MAX_PATH] of char;
begin
  GetTempPath(MAX_PATH, ADir);
  GetTempFilename(ADir, PChar(Prefix), 0, AName);
  result := StrPas(AName);
end;

function GetAppData: string;
var
  NameBuffer: PChar;
begin
  result := '';
  if SUCCEEDED(SHGetKnownFolderPath(FOLDERID_RoamingAppData, 0, 0, NameBuffer)) then
  begin
    result := IncludeTrailingPathDelimiter(StrPas(NameBuffer)) + IncludeTrailingPathDelimiter(Application.Title);
    CoTaskMemFree(NameBuffer);
    if not DirectoryExists(result) then
      CreateDir(result);
  end;
end;

function CreateTempPath(const Prefix: string): string;
begin
  App_Prefix := Prefix;
  result := TempFilename(App_Prefix);
  if FileExists(result) then
    System.Sysutils.DeleteFile(result);
  MkDir(result);
  CreatedTempPath := IncludeTrailingPathDelimiter(result);
  MkDir(GetOSMTemp);
  MKDir(GetRoutesTmp);
end;

function GetHtmlTmp: string;
begin
  result := GetOSMTemp + App_Prefix +  HtmlTempFileName;
end;

function GetTracksExt: string;
begin
  result := TrackFileExt;
end;

function GetTracksMask: string;
begin
  result := '*' + GetTracksExt;
end;

function GetTracksTmp: string;
begin
  result := GetOSMTemp + App_Prefix + GetTracksMask;
end;

function GetOSMTemp: string;
begin
  result := CreatedTempPath + OSMDir;
end;

function GetRoutesTmp: string;
begin
  result := CreatedTempPath + RoutesDir;
end;

function GetDeviceTmp: string;
begin
  result := CreatedTempPath + DeviceDir;
end;

function EscapeDQuote(const HTML: string): string;
begin
  result := ReplaceAll(HTML, ['"'], ['\"']);
end;

function EscapeHtml(const HTML: string): string;
begin
  result := ReplaceAll(HTML,
                       ['&',     '<',    '>',    '"',      '''',    ' ',      '-'],
                       ['&amp;', '&lt;', '&gt;', '&quot;', '&#39;', '&nbsp;', '&#8209;']
                      );
end;

function EscapeFileName(InFile: string): string;
const
  InvalidChars = ['<', '>', ':', '"', '/', '\', '|', '?', '*'];
var
  Indx: integer;
begin
  result := InFile;

  for Indx := 1 to Length(result) do
  begin
    if (CharInSet(result[Indx], InvalidChars)) then
      result[Indx] := '_';
  end;
end;

function RemovePath(const ADir: string; const AFlags: FILEOP_FLAGS = FOF_NO_UI; Retries: integer = 3): boolean;
var
  ShOp: TSHFileOpStruct;
  ShResult: integer;
  CurrentTry: integer;
begin
  result := false;
  if not(DirectoryExists(ADir)) then
    exit;

  CurrentTry := Retries;
  repeat
    FillChar(ShOp, SizeOf(ShOp), 0);
    ShOp.Wnd := Application.Handle;
    ShOp.wFunc := FO_DELETE;
    ShOp.pFrom := PChar(ADir + #0);
    ShOp.pTo := nil;
    ShOp.fFlags := AFlags;
    ShResult := SHFileOperation(ShOp);
    if (ShResult = 0) then
      break;

    Dec(CurrentTry);
    Sleep(100);
    ProcessMessages;
  until (CurrentTry < 1);

  if (ShResult <> 0) and (ShOp.fAnyOperationsAborted = false) then
    ShowMessage(Format('Remove directory failed code %u', [ShResult]));
  result := (ShResult = 0);
end;

function GPX2HTMLColor(GPXColor: string): string;
begin
  result := 'ff00ff';
  if (GPXColor = 'Black')       then exit('000000');
  if (GPXColor = 'DarkRed')     then exit('8b0000');
  if (GPXColor = 'DarkGreen')   then exit('006400');
  if (GPXColor = 'DarkYellow')  then exit('b5b820');
  if (GPXColor = 'DarkBlue')    then exit('00008b');
  if (GPXColor = 'DarkMagenta') then exit('8b008b');
  if (GPXColor = 'DarkCyan')    then exit('008b8b');
  if (GPXColor = 'LightGray')   then exit('cccccc');
  if (GPXColor = 'DarkGray')    then exit('444444');
  if (GPXColor = 'Red')         then exit('ff0000');
  if (GPXColor = 'Green')       then exit('00ff00');
  if (GPXColor = 'Yellow')      then exit('ffff00');
  if (GPXColor = 'Blue')        then exit('0000ff');
  if (GPXColor = 'Magenta')     then exit('ff00ff');
  if (GPXColor = 'Cyan')        then exit('00ffff');
  if (GPXColor = 'White')       then exit('ffffff');
  if (GPXColor = 'Transparent') then exit('ffffff');
end;

function GetLocaleSetting: TFormatSettings;
begin
  // Get Windows settings, and modify decimal separator and negcurr
  Result := TFormatSettings.Create(GetThreadLocale);
  with Result do
  begin
    DecimalSeparator := '.'; // The decimal separator is a . PERIOD!
    NegCurrFormat := 11;
  end;
end;

function QueryItem(Buf: PByte; Item: string): PChar;
var
  Len: DWORD;
begin
  if not VerQueryValue(Buf, PChar('stringFileInfo\040904E4\' + Item), Pointer(result), Len) then
     result := '';
end;

function VerInfo(IncludeCompany: boolean = false): string;
var
  S: string;
  Buf: PByte;
  Len: DWORD;
begin
  S := Application.ExeName;
  Len := GetFileVersionInfoSize(PChar(S), Len);
  if (Len > 0) then
  begin
    Buf := AllocMem(Len);
    try
      GetFileVersionInfo(PChar(S), 0, Len, Buf);
      S := 'ProductName';
      result := QueryItem(Buf, S);
{$IFDEF WIN64}
      result := S + ': ' + #9 + result + ' (Win64)' + #10;
{$ELSE}
      result := S + ': ' + #9 + result + ' (Win32)' + #10;
{$ENDIF}
      S := 'FileDescription';
      result := result + S + ': ' + #9 + QueryItem(Buf, S) + #10;
      S := 'FileVersion';
      result := result + S + ': ' + #9 + QueryItem(Buf, S) + #10;
      S := 'CompilerVersion';
      result := result + S + ': ' + #9 + FormatFloat('#0.0', CompilerVersion, FormatSettings) +#10;
      S := 'LegalCopyRight';
      result := result + S + ': ' + #9 + QueryItem(Buf, S) +#10;
      if (IncludeCompany) then
      begin
        S := 'CompanyName';
        result := result + S + ': ' + #9 + QueryItem(Buf, S) + #10;
      end;
    finally
      FreeMem(Buf, Len);
    end;
  end
  else
    result := 'No FileVersionInfo found';
end;

function UserAgent: string;
var
  Buf: PByte;
  Len: DWORD;
begin
  result := '';
  Len := GetFileVersionInfoSize(PChar(Application.ExeName), Len);
  if (Len > 0) then
  begin
    Buf := AllocMem(Len);
    try
      GetFileVersionInfo(PChar(Application.ExeName), 0, Len, Buf);
      result := QueryItem(Buf, 'ProductName') + '/' + QueryItem(Buf, 'ProductVersion') + ' (https://github.com/)';
    finally
      FreeMem(Buf, Len);
    end;
  end
end;

initialization
begin
  FloatFormatSettings.ThousandSeparator := ',';
  FloatFormatSettings.DecimalSeparator := '.';
end;

finalization

begin
  RemovePath(CreatedTempPath);
end;

end.
