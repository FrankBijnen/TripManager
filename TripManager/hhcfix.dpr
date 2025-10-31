program hhcfix;

{$R *.res}

uses
  Winapi.ShellAPI, Winapi.Windows,
  System.SysUtils, System.IOUtils,
  UnitStringUtils;

var
  CurDir, Dir2Fix: string;
  Fs: TSearchRec;
  Rc: integer;
  AHtml, CmdLine: string;
  Output, Error: string;
  ExitCode: DWORD;
begin
  GetDir(0, CurDir);
  Dir2Fix := ExtractFilePath(ExpandFileName(ParamStr(1)));
  ChDir(Dir2Fix);
  Rc := FindFirst('*.html', faAnyFile, Fs);
  while (Rc = 0) do
  begin
    AHtml := TFile.ReadAllText(Fs.Name, TEncoding.UTF8);
//    AHtml := ReplaceAll(AHtml, ['?.html"', '>&middot;&nbsp;&nbsp;&nbsp;<'], ['"', '>&middot;&nbsp;<'], [rfReplaceAll]);
    AHtml := ReplaceAll(AHtml, ['?.html"', '>&middot;&nbsp;</span>'], ['"', '>&middot;&nbsp;&nbsp;&nbsp;</span>'], [rfReplaceAll]);


    TFile.WriteAllText(Fs.Name, AHtml);
    Rc := FindNext(Fs);
  end;
  FindClose(Fs);
  ChDir(CurDir);

  CmdLine := '"' + IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +  'hhc.exe" "' + Paramstr(1) + '"';
  Sto_RedirectedExecute(CmdLine, CurDir, Output, Error, ExitCode);
  Writeln(Output);
  Halt(ExitCode);
end.
