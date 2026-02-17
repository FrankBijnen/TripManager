program hhcfix;

{$R *.res}

uses
  Winapi.ShellAPI, Winapi.Windows,
  System.SysUtils, System.IOUtils,
  UnitStringUtils, UnitRedirect;

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
    AHtml := ReplaceAll(AHtml, ['?.html"',
                                '<font face="Arial" size="2">',
                                '>&middot;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;&nbsp;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;</span>',
                                '>&Oslash;&nbsp;&nbsp;&nbsp;</span>',
                                '>&Oslash;&nbsp;&nbsp;</span>',
                                '>&Oslash;&nbsp;</span>',
                                ' name="#',
                                ' bgcolor="FFFCEA" '],
                               ['"',
                                '<font face="Calibri" size="3">',
                                '>&middot;&nbsp;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;&nbsp;&nbsp;</span>',
                                '>&Oslash;</span>',
                                '>&Oslash;</span>',
                                '>&Oslash;</span>',
                                ' name="',
                                ' bgcolor="FFFFFF" '],
                               [rfReplaceAll]);
    TFile.WriteAllText(Fs.Name, AHtml);
    Rc := FindNext(Fs);
  end;
  FindClose(Fs);
  ChDir(CurDir);

  CmdLine := '"' + IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +  'hhc.exe" "' + Paramstr(1) + '"';
  Sto_RedirectedExecute(CmdLine, CurDir, Output, Error, ExitCode);
  Writeln(Output);

  ChDir(Dir2Fix);
  Rc := FindFirst('*.html', faAnyFile, Fs);
  while (Rc = 0) do
  begin
    CmdLine := '"' + IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +  'tidy.exe" -c -i -m "' +
                     IncludeTrailingPathDelimiter(Dir2Fix) + Fs.Name + '"';
    Sto_RedirectedExecute(CmdLine, CurDir, Output, Error, ExitCode);
    if (ExitCode <> 0) then
      Writeln(Error);

    Rc := FindNext(Fs);
  end;
  FindClose(Fs);

  Halt(ExitCode);
end.
