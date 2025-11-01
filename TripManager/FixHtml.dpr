program FixHtml;

{$R *.res}

uses
  Winapi.ShellAPI, Winapi.Windows,
  System.SysUtils, System.IOUtils,
  UnitStringUtils;

var
  CurDir, Dir2Fix: string;
  Fs: TSearchRec;
  Rc: integer;
  AHtml: string;
begin
  GetDir(0, CurDir);
  Dir2Fix := ExtractFilePath(ExpandFileName(ParamStr(1)));
  ChDir(Dir2Fix);
  Rc := FindFirst('*.html', faAnyFile, Fs);
  while (Rc = 0) do
  begin
    AHtml := TFile.ReadAllText(Fs.Name, TEncoding.UTF8);
//    AHtml := ReplaceAll(AHtml, ['?.html"'], ['"'], [rfReplaceAll]);
//    AHtml := ReplaceAll(AHtml, ['?.html"', '>&middot;&nbsp;</span>'], ['"', '>&middot;&nbsp;&nbsp;&nbsp;</span>'], [rfReplaceAll]);
    AHtml := ReplaceAll(AHtml, ['?.html"',
                                '>&middot;&nbsp;&nbsp;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;</span>',
                                '>&Oslash;&nbsp;&nbsp;&nbsp;</span>',
                                '>&Oslash;&nbsp;&nbsp;</span>',
                                '>&Oslash;&nbsp;</span>'],
                               ['"',
                                '>&middot;&nbsp;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;&nbsp;&nbsp;</span>',
                                '>&middot;&nbsp;&nbsp;&nbsp;</span>',
                                '>&Oslash;</span>',
                                '>&Oslash;</span>',
                                '>&Oslash;</span>'],
                               [rfReplaceAll]);
    TFile.WriteAllText(Fs.Name, AHtml);
    Rc := FindNext(Fs);
  end;
  FindClose(Fs);
  ChDir(CurDir);
end.
