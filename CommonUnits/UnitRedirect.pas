unit UnitRedirect;
// This is an example application to demonstrate the use of pipes
// to redirect the input/output of a console application.
// The function "Sto_RedirectedExecute" was written by Martin Stoeckli
// and is part of the site:
// http://www.martinstoeckli.ch/delphi/
//

interface

uses Winapi.Windows, System.Classes;

/// <summary>
/// Runs a console application and captures the stdoutput and
/// stderror.</summary>
/// <param name="CmdLine">The commandline contains the full path to
/// the executable and the necessary parameters. Don't forget to
/// quote filenames with "" if the path contains spaces.</param>
/// <param name="Output">Receives the console stdoutput.</param>
/// <param name="Error">Receives the console stderror.</param>
/// <param name="Input">Send to stdinput of the process.</param>
/// <param name="Wait">[milliseconds] Maximum of time to wait,
/// until application has finished. After reaching this timeout,
/// the application will be terminated and False is returned as
/// result.</param>
/// <returns>True if process could be started and did not reach the
/// timeout.</returns>
function Sto_RedirectedExecute(CmdLine: string;
                               var Output: string;
                               var Error: string;
                               var ExitCode: DWord;
                               const Input: string = '';
                               const Wait: DWord = 3600000;
                               const ShowWindow: boolean = false): boolean;
// Just a createprocess!
function WaitOnProcess(var AProcess: TProcessInformation; WaitTime: DWORD = 50): DWORD;
procedure TerminateRunningProcess(var AProcess: TProcessInformation;
                                  const ExitCode: DWORD = DWORD(-1);
                                  const Close: boolean = true);
// If the process does not read or write from stdin or stdout, you can use the
// methods below.
// Environment support routines
// Retrieve Unicode, but store Ansi
function GetCurrentEnvironment: TStringList;
procedure Add2Environment(Environ: TStringList; AKey, AValue: String);
function GetEnvironment(Environ: TStringList): AnsiString;

function CreateProcessWait(CmdLine: string;
                           const ShowWindow: Boolean = false;
                           Environment: PAnsiChar = nil
                          ): TProcessInformation; overload;
// Future use
function CreateProcessWait(CmdLine, User, Domain, Passwd: string;
                           const ShowWindow: Boolean = false
                          ): TProcessInformation; overload;

function CreateProcessWithLogonW(
  lpUsername,
  lpDomain,
  lpPassword: PWideChar;
  dwLogonFlags: DWORD;
  lpApplicationName: PWideChar;
  lpCommandLine: PWideChar;
  dwCreationFlags: DWORD;
  lpEnvironment: Pointer;
  lpCurrentDirectory: PWideChar;
  lpStartupInfo: PStartupInfoW;
  lpProcessInformation: PProcessInformation
): BOOL; stdcall; external 'advapi32.dll';


implementation

uses MsgLoop, System.Sysutils;

const LOGON_WITH_PROFILE = 1;
      LOGON_NETCREDENTIALS_ONLY = 2;

function GetCreationFlags(ShowWindow: boolean): DWord;
begin
  result := 0;
  if not (ShowWindow) then
    result := result or CREATE_NO_WINDOW;
end;

function GetStartupInfo(ShowWindow: boolean): TStartupInfo;
begin
  FillChar(Result, SizeOf(result), 0);
  result.cb := SizeOf(result);
  result.dwFlags := STARTF_USESHOWWINDOW;
  if (ShowWindow) then
    result.wShowWindow := SW_NORMAL
  else
    result.wShowWindow := SW_HIDE;
end;

function GetCurrentEnvironment: TStringList;
var PEnvVars: PChar;    // pointer to start of environment block
    PEnvEntry: PChar;   // pointer to an env string in block
begin
  // Clear the list
  result :=  TStringList.Create;
  result.Sorted := true;
  // Get reference to environment block for this process
  PEnvVars := GetEnvironmentStrings;
  if PEnvVars <> nil then
  begin
    // We have a block: extract strings from it
    // Env strings are #0 separated and list ends with #0#0
    PEnvEntry := PEnvVars;
    try
      while PEnvEntry^ <> #0 do
      begin
        result.Add(PEnvEntry);
        Inc(PEnvEntry, StrLen(PEnvEntry) + 1);
      end;
    finally
      // Dispose of the memory block
      FreeEnvironmentStrings(PEnvVars);
    end;
  end;
end;

procedure Add2Environment(Environ: TStringList; AKey, AValue: String);
begin
  Environ.Add(AKey + '=' + AValue);
end;

function GetEnvironment(Environ: TStringList): AnsiString;
var AVar: string;
begin
  for AVar in Environ do
    result := result + AnsiString(AVar) + #0;
  result := result + #0;
end;

type
  TStoReadPipeThread = class(TThread)
  protected
    FPipe: THandle;
    FContent: TStringStream;
    function Get_Content: String;
    procedure Execute; override;
  public
    constructor Create(const Pipe: THandle);
    destructor Destroy; override;
    property Content: String read Get_Content;
  end;

  TStoWritePipeThread = class(TThread)
  protected
    FPipe: THandle;
    FContent: TStringStream;
    procedure Execute; override;
  public
    constructor Create(const Pipe: THandle; const Content: String);
    destructor Destroy; override;
  end;

  { TStoReadPipeThread }

constructor TStoReadPipeThread.Create(const Pipe: THandle);
begin
  FPipe := Pipe;
  FContent := TStringStream.Create('');
  inherited Create(false); // start running
end;

destructor TStoReadPipeThread.Destroy;
begin
  FContent.Free;
  inherited Destroy;
end;

procedure TStoReadPipeThread.Execute;
const BLOCK_SIZE = 4096;
var iBytesRead: DWord;
    myBuffer: array [0 .. BLOCK_SIZE - 1] of Byte;
begin
  repeat
    // try to read from pipe
    if ReadFile(FPipe, myBuffer, BLOCK_SIZE, iBytesRead, nil) then
      FContent.Write(myBuffer, iBytesRead);
    // a process may write less than BLOCK_SIZE, even if not at the end
    // of the output, so checking for < BLOCK_SIZE would block the pipe.
  until (iBytesRead = 0);
end;

function TStoReadPipeThread.Get_Content: String;
begin
  Result := FContent.DataString;
end;

{ TStoWritePipeThread }

constructor TStoWritePipeThread.Create(const Pipe: THandle;
  const Content: String);
begin
  FPipe := Pipe;
  FContent := TStringStream.Create(Content);
  inherited Create(false); // start running
end;

destructor TStoWritePipeThread.Destroy;
begin
  FContent.Free;
  if (FPipe <> 0) then
    CloseHandle(FPipe);
  inherited Destroy;
end;

procedure TStoWritePipeThread.Execute;
const BLOCK_SIZE = 4096;
var myBuffer: array [0 .. BLOCK_SIZE - 1] of Byte;
    iBytesToWrite: DWord;
    iBytesWritten: DWord;
begin
  iBytesToWrite := FContent.Read(myBuffer, BLOCK_SIZE);
  while (iBytesToWrite > 0) do
  begin
    WriteFile(FPipe, myBuffer, iBytesToWrite, iBytesWritten, nil);
    iBytesToWrite := FContent.Read(myBuffer, BLOCK_SIZE);
  end;
  // close our handle to let the other process know, that
  // there won't be any more data.
  CloseHandle(FPipe);
  FPipe := 0;
end;

function Sto_RedirectedExecute(CmdLine: string;
                               var Output: string;
                               var Error: string;
                               var ExitCode: DWord;
                               const Input: string = '';
                               const Wait: DWord = 3600000;
                               const ShowWindow: boolean = false): boolean;

var mySecurityAttributes: SECURITY_ATTRIBUTES;
    myStartupInfo: STARTUPINFO;
    myProcessInfo: PROCESS_INFORMATION;
    hPipeInputRead, hPipeInputWrite: THandle;
    hPipeOutputRead, hPipeOutputWrite: THandle;
    hPipeErrorRead, hPipeErrorWrite: THandle;
    myWriteInputThread: TStoWritePipeThread;
    myReadOutputThread: TStoReadPipeThread;
    myReadErrorThread: TStoReadPipeThread;
    iWaitRes: integer;

begin
  // prepare security structure
  ZeroMemory(@mySecurityAttributes, SizeOf(SECURITY_ATTRIBUTES));
  mySecurityAttributes.nLength := SizeOf(SECURITY_ATTRIBUTES);
  mySecurityAttributes.bInheritHandle := true;

  // create pipe to set stdinput
  hPipeInputRead := 0;
  hPipeInputWrite := 0;
  if (Input <> '') then
    CreatePipe(hPipeInputRead, hPipeInputWrite, @mySecurityAttributes, 0);

  // create pipes to get stdoutput and stderror
  CreatePipe(hPipeOutputRead, hPipeOutputWrite, @mySecurityAttributes, 0);
  CreatePipe(hPipeErrorRead, hPipeErrorWrite, @mySecurityAttributes, 0);

  // prepare startupinfo structure
  myStartupInfo := GetStartupInfo(ShowWindow);

  // assign pipes
  myStartupInfo.dwFlags := myStartupInfo.dwFlags or STARTF_USESTDHANDLES;
  myStartupInfo.hStdInput := hPipeInputRead;
  myStartupInfo.hStdOutput := hPipeOutputWrite;
  myStartupInfo.hStdError := hPipeErrorWrite;

  // since Delphi calls CreateProcessW, literal strings cannot be used anymore
  UniqueString(CmdLine);

  // start the process
  result := CreateProcess(nil,              // lpApplicationName
                          PChar(CmdLine),
                          nil,              // lpProcessAttributes
                          nil,              // lpThreadAttributes
                          true,             // bInheritHandles
                          GetCreationFlags(ShowWindow),
                          nil,              // lpEnvironment
                          nil,              // lpCurrentDirectory
                          myStartupInfo,
                          myProcessInfo);

  // close the ends of the pipes, now used by the process
  CloseHandle(hPipeInputRead);
  CloseHandle(hPipeOutputWrite);
  CloseHandle(hPipeErrorWrite);

  // could process be started ?
  if result then
  begin
    myWriteInputThread := nil;
    if (hPipeInputWrite <> 0) then
      myWriteInputThread := TStoWritePipeThread.Create(hPipeInputWrite, Input);
    myReadOutputThread := TStoReadPipeThread.Create(hPipeOutputRead);
    myReadErrorThread := TStoReadPipeThread.Create(hPipeErrorRead);
    try
      // wait unitl there is no more data to receive, or the timeout is reached
      iWaitRes := WaitForSingleObject(myProcessInfo.hProcess, Wait);
      // timeout reached ?
      if (iWaitRes = WAIT_TIMEOUT) then
      begin
        Result := false;
        TerminateProcess(myProcessInfo.hProcess, UINT(ERROR_CANCELLED));
      end;
      // return output
      myReadOutputThread.waitfor;
      Output := myReadOutputThread.Content;
      myReadErrorThread.waitfor;
      Error := myReadErrorThread.Content;
      GetExitCodeProcess(myProcessInfo.hProcess, ExitCode);
    finally
      myWriteInputThread.Free;
      myReadOutputThread.Free;
      myReadErrorThread.Free;
      CloseHandle(myProcessInfo.hThread);
      CloseHandle(myProcessInfo.hProcess);
    end;
  end;
  // close our ends of the pipes
  CloseHandle(hPipeOutputRead);
  CloseHandle(hPipeErrorRead);
end;

procedure CloseProcess(var AProcess: TProcessInformation);
begin
  CloseHandle(AProcess.hThread);
  CloseHandle(AProcess.hProcess);
  FillChar(AProcess, sizeof(AProcess), 0);
end;

function WaitOnProcess(var AProcess: TProcessInformation; WaitTime: DWORD = 50): DWORD;
var Rc: Dword;
begin
  result := DWORD(-1);
  Rc := STATUS_ABANDONED_WAIT_0;
  while (Rc <> STATUS_WAIT_0) and
        (AProcess.hProcess <> 0) do
  begin
    ProcessMessages;
    Rc := WaitForSingleObject(AProcess.hProcess, WaitTime);
  end;
  GetExitCodeProcess(AProcess.hProcess, result);
  CloseProcess(AProcess);
end;

procedure TerminateRunningProcess(var AProcess: TProcessInformation;
                                  const ExitCode: DWORD = DWORD(-1);
                                  const Close: boolean = true);
begin
  if (AProcess.hProcess = 0) then
    exit;
  TerminateProcess(AProcess.hProcess, ExitCode);
  if (Close) then
    CloseProcess(AProcess);
end;

function CreateProcessWait(CmdLine: string;
                           const ShowWindow: Boolean = false;
                           Environment: PAnsiChar = nil
                          ): TProcessInformation;
begin
  FillChar(Result, SizeOf(Result), 0);
  UniqueString(CmdLine);

  if not CreateProcess(nil, PChar(CmdLine), nil, nil, false,
    GetCreationFlags(ShowWindow), Environment, nil, GetStartupInfo(ShowWindow), Result) then
    RaiseLastOSError;
end;

function CreateProcessWait(CmdLine, User, Domain, Passwd: string;
                           const ShowWindow: Boolean = false
                          ): TProcessInformation;
var Si: TStartupInfo;
begin
  FillChar(Result, SizeOf(Result), 0);
  Si := GetStartupInfo(ShowWindow);

  UniqueString(User);
  UniqueString(Domain);
  UniqueString(Passwd);
  UniqueString(CmdLine);

  if not CreateProcessWithLogonW(PChar(User),
                                 PChar(Domain),
                                 PChar(Passwd),
                                 LOGON_NETCREDENTIALS_ONLY,
                                 nil,
                                 PChar(CmdLine),
                                 GetCreationFlags(ShowWindow),
                                 nil,
                                 nil,
                                 @Si,
                                 @result) then
    RaiseLastOSError;
end;

end.
