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
    AHtml := ReplaceAll(AHtml, ['?.html"'], ['"'], [rfReplaceAll]);
    TFile.WriteAllText(Fs.Name, AHtml);
    Rc := FindNext(Fs);
  end;
  FindClose(Fs);
  ChDir(CurDir);
end.
