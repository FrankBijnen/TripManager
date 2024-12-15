unit UnitMapUtils;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses System.Classes;

function CreateLink(const PathObj, PathLink, Desc, Param: string): Boolean;
function ResolveLink(const Path: string): string;
procedure ListMapsRegistryKey(MapsList: TStringList; MapsKey: string);
procedure ListMapsAppData(const BaseDir: string; MapsList: TStringList; IncludePath: boolean = false);
function ListMaps(const BaseDir: string): TStringList;
function DeleteLink(const Path: string): boolean;
function GetMapFolder: string;
function GetKnownFolder(const Known: TGUID): string;
function LookupMap(const MapSegment: string): string;
procedure ClearTileCache;

implementation

uses Winapi.Windows, Winapi.ShlObj, Winapi.ActiveX, Winapi.ShellAPI, System.Win.ComObj, Winapi.KnownFolders,
     Registry, UnitVerySimpleXml,
     System.SysUtils, System.StrUtils;

var InstalledMaps: TStringList;

function CreateLink(const PathObj, PathLink, Desc, Param: string): Boolean;
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
begin
  result := false;
  if not (DirectoryExists(PathObj)) then
    exit;
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do
  begin
    SetArguments(PChar(Param));
    SetDescription(PChar(Desc));
    SetPath(PChar(PathObj));
  end;
  result := Succeeded(PFile.Save(PWChar(WideString(PathLink)), FALSE));
end;

function ResolveLink(const Path: string): string;
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
  FileData: TWin32FindData;
  Buf: Array[0..MAX_PATH] of char;
  Widepath: WideString;

begin
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;

  Widepath := Path;
  result := '';
  if Succeeded(PFile.Load(@Widepath[1], STGM_READ)) and
     Succeeded(SLink.Resolve(GetActiveWindow, SLR_NOUPDATE)) and
     Succeeded(SLink.GetPath(Buf, sizeof(Buf), FileData, SLGP_UNCPRIORITY)) Then
    result := Buf;
end;

function DeleteLink(const Path: string): boolean;
begin
  result := DeleteFile(Path);
end;

type
  TTDBRec = packed record
    RecType: AnsiChar;
    RecLen: Word;
  end;

  TPRec = packed record
    ProductId: Word;
    FamilyId: Word;
    Version: Word;
  end;

  TPNameRec = packed record
    PRec: TPRec;
    MapName: string;
    procedure Init;
  end;

procedure TPNameRec.Init;
begin
  FillChar(PRec, SizeOf(PRec), 0);
  MapName := '';
end;

function ScanTdb(const TdbFile: string): TPNameRec;
var F: File;
    TDBRec: TTDBRec;
    Rec: array of byte;
    BR: integer;
    SaveFileMode: byte;

  procedure ReadString(Indx: integer; var OutString: string);
  begin
    OutString := '';
    while (Indx < High(Rec)) and
          (Rec[Indx] <> 0) do
    begin
      OutString := OutString + Char(Rec[Indx]);
      Inc(Indx);
    end;
  end;

begin
  Result.Init;
  if not (FileExists(TdbFile)) then
    exit;
  AssignFile(F, TdbFile);
  SaveFileMode := FileMode;
  FileMode := 0;
  try
    Reset(F, 1);
    try
      while true do
      begin
        BlockRead(F, TDBRec, SizeOf(TDBRec), BR);
        if (BR <> SizeOf(TDBRec)) then
          exit;

        SetLength(Rec, TDBRec.RecLen);
        BlockRead(F, Rec[0], TDBRec.RecLen, BR);
        if (BR <> TDBRec.RecLen) then
          exit;

        case (TDBRec.RecType) of
          'P':
            begin
              Move(Rec[0], result.Prec, SizeOf(result.Prec));
              ReadString(SizeOf(result.Prec), result.MapName);
              exit;
            end;
        end;
      end;
    finally
      CloseFile(F);
    end;
  finally
    FileMode := SaveFileMode;
  end;
end;

procedure ListMdx(const MdxFile: string; MapSegments: TStringList);
var F: File;
    SaveFileMode: byte;
    Sign: array[0..5] of byte;
    Rec: array of byte;
    BR, RecLen: integer;
    RecCount, Cnt, MapSegment: DWord;

const MDXInvalid = 'MDX Invalid';
begin
  AssignFile(F, MdxFile);
  SaveFileMode := FileMode;
  Filemode := 0;
  try
    Reset(F, 1);
    try
      BlockRead(F, Sign[0], SizeOf(Sign), BR);
      if (BR <> SizeOf(Sign)) then
        raise Exception.Create(MDXInvalid);

      BlockRead(F, RecLen, SizeOf(RecLen), BR);
      if (BR <> SizeOf(RecLen)) then
        raise Exception.Create(MDXInvalid);

      BlockRead(F, RecCount, SizeOf(RecCount), BR);
      if (BR <> SizeOf(RecCount)) then
        raise Exception.Create(MDXInvalid);

      SetLength(Rec, RecLen);
      for Cnt := 1 to RecCount do
      begin
        BlockRead(F, Rec[0], RecLen, BR);
        if (BR <> RecLen) then
          raise Exception.Create(MDXInvalid);
        Move(Rec[0], MapSegment, SizeOf(MapSegment));
        MapSegments.Add(IntToStr(MapSegment));
      end;
    finally
      CloseFile(F);
    end;
  finally
    FileMode := SaveFileMode;
  end;
end;

procedure ListMapsRegistryKey(MapsList: TStringList; MapsKey: string);
var Maps, SubProducts, MapSegments: TStringList;
    Idx, Tdb, AMapKey, BMap: string;
    ProductNameRec: TPNameRec;
    Reg: TRegistry;
begin
  Maps := TStringList.Create;
  SubProducts := TStringList.Create;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if (Reg.OpenKeyReadOnly(MapsKey) = false) then
      exit;
    Reg.GetKeynames(Maps);
    Reg.CloseKey;

    for AMapKey in Maps do
    begin
      ProductNameRec.Init;
      BMap := '';
      Tdb := '';
      Idx := '';

      if (Reg.OpenKeyReadOnly(MapsKey + '\' + AMapKey)) then
      begin
        Reg.GetKeynames(SubProducts);
        Reg.CloseKey;
        if (SubProducts.Count > 0) then
        begin
          if (Reg.OpenKeyReadOnly(MapsKey + '\' + AMapKey + '\' + SubProducts[0])) then
          begin

            BMap := Reg.ReadString('BMAP');
            if (BMap <> '') and
               (FileExists(ChangeFileExt(BMap, '.mdx'))) then
              BMap := ChangeFileExt(BMap, '.mdx')
            else
              BMap := '';

            Tdb := Reg.ReadString('TDB');
            if (Tdb <> '') then
              ProductNameRec := ScanTdb(Tdb);
            Reg.CloseKey;
          end;
        end;
      end;

      if (Reg.OpenKeyReadOnly(MapsKey + '\' + AMapKey)) then
      begin
        Idx := Reg.ReadString('IDX');
        if (Idx = '') and
           (Bmap <> '') then
          Idx := BMap;
        if (Idx <> '') then
        begin
          if (ProductNameRec.MapName = '') then
            ProductNameRec.MapName := ChangeFileExt(ExtractFileName(Idx), '');
          MapSegments := TStringList.Create;
          ListMdx(Idx, MapSegments);
          MapsList.AddObject(ProductNameRec.MapName, TStringList(MapSegments));
        end;
        Reg.CloseKey;
      end;
    end;

  finally
    Maps.Free;
    SubProducts.Free;
    Reg.Free;
  end;
end;

procedure ListMapsRegistry(MapsList: TStringList);
const MapsKey = 'SOFTWARE\Wow6432Node\Garmin\MapSource\Families';
      MapsKeyNT = 'SOFTWARE\Wow6432Node\Garmin\MapSource\FamiliesNT';
begin
  ListMapsRegistryKey(MapsList, MapsKey);
  ListMapsRegistryKey(MapsList, MapsKeyNT);
end;

procedure ListMapsAppData(const BaseDir: string; MapsList: TStringList; IncludePath: boolean = false);
var Fs: TSearchRec;
    Rc: Integer;
    First: boolean;
    Xml, MapDir, Tdb, Idx: string;
    ProductNameRec: TPNameRec;

    MapSegments: TStringList;
    XmlDoc: TXmlVSDocument;
    ProductNode, IdxNode, SubProductNode, SubProductDirNode, TDBNode: TXmlVSNode;
begin
  if not DirectoryExists(BaseDir) then
    exit;
  ChDir(BaseDir);
  XmlDoc := TXmlVSDocument.Create;
  try
    First := true;
    while (True) do
    begin
      if (First) then
        Rc := FindFirst(IncludeTrailingPathDelimiter(BaseDir) + '*.*', faSymLink, Fs)
      else
        Rc := FindNext(Fs);
      if (Rc <> 0) then
        break;
      First := false;
      MapDir := IncludeTrailingPathDelimiter(ResolveLink(ExpandFileName(Fs.Name)));
      Xml := MapDir + 'info.xml';
      if (FileExists(Xml) = false) then
        continue;

      XmlDoc.LoadFromFile(Xml);

      ProductNode := XmlDoc.ChildNodes.Find('MapProduct');
      if (ProductNode = nil) then
        continue;

      SubProductNode := ProductNode.Find('SubProduct');
      if (SubProductNode = nil) then
        continue;

      SubProductDirNode := SubProductNode.Find('Directory');
      if (SubProductDirNode = nil) then
        continue;

      TDBNode := SubProductNode.Find('TDB');
      if (TDBNode = nil) then
        continue;

      Tdb := IncludeTrailingPathDelimiter(MapDir + SubProductDirNode.NodeValue) + TDBNode.NodeValue;
      if not FileExists(Tdb) then
        continue;

      MapSegments := TStringList.Create;
      IdxNode := ProductNode.Find('IDX');
      if (IdxNode <> nil) then
      begin
        Idx := MapDir + IdxNode.NodeValue;
        if FileExists(Idx) then
          ListMdx(Idx, MapSegments);
      end;
      if (IncludePath) then
        MapSegments.Add(ExpandFileName((Fs.Name)));

      ProductNameRec := ScanTdb(Tdb);
      MapsList.AddObject(ProductNameRec.MapName, TStringList(MapSegments));
    end;
    FindClose(Fs);
  finally
    XmlDoc.Free;
  end;
end;

function ListMaps(const BaseDir: string): TStringList;
begin
  result := TStringList.Create;
  ListMapsAppData(BaseDir, result);
  ListMapsRegistry(result);
end;

procedure ScanInstalledMaps;
begin
  InstalledMaps := ListMaps(GetMapFolder);
end;

function LookupMap(const MapSegment: string): string;
var Map, MapSeg: integer;
    MapsegList: TStringList;
begin
  result := '';
  if (InstalledMaps = nil) then
    ScanInstalledMaps;

  for Map := 0 to InstalledMaps.Count -1 do
  begin
    MapsegList := TStringList(InstalledMaps.Objects[Map]);
    for MapSeg := 0 to MapsegList.Count -1 do
    begin
      if (MapsegList[MapSeg] = MapSegment) then
      begin
        result := InstalledMaps[Map];
        exit;
      end;
    end;
  end;
end;

function GetKnownFolder(const Known: TGUID): string;
var NameBuffer: PChar;
begin
  if SUCCEEDED(SHGetKnownFolderPath(Known, 0, 0, NameBuffer)) then
    result := StrPas(NameBuffer);
  CoTaskMemFree(NameBuffer);
end;

function GetMapFolder: string;
begin
  result := IncludeTrailingPathDelimiter(GetKnownFolder(FOLDERID_ProgramData)) + 'Garmin\Maps';
end;

procedure ClearTileCache;
begin
// CMD should be in path
// Require elevation?
// Javawa GMTK also does \Garmin Training Center(r)\TileCache and \HomePort\TileCache. But were not interested in those.
  ShellExecute(0, nil, 'cmd.exe', '/C del /q "%LOCALAPPDATA%\Garmin\MapSource\TileCache\*.*', nil, SW_HIDE);
  ShellExecute(0, nil, 'cmd.exe', '/C del /q "%LOCALAPPDATA%\Garmin\BaseCamp\TileCache\*.*', nil, SW_HIDE);
  ShellExecute(0, nil, 'cmd.exe', '/C del /q "%LOCALAPPDATA%\Garmin\MapInstall\TileCache\*.*', nil, SW_HIDE);
  ShellExecute(0, nil, 'cmd.exe', '/C del /q "%APPDATA%\Garmin\MapSource\TileCache\*.*', nil, SW_HIDE);
  ShellExecute(0, nil, 'cmd.exe', '/C del /q "%APPDATA%\Garmin\BaseCamp\TileCache\*.*', nil, SW_HIDE);
  ShellExecute(0, nil, 'cmd.exe', '/C del /q "%APPDATA%\Garmin\MapInstall\TileCache\*.*', nil, SW_HIDE);
end;

initialization
begin
  InstalledMaps := nil;
end;

finalization
var Indx: integer;
begin
  if (InstalledMaps = nil) then
    exit;
  for Indx := 0 to InstalledMaps.Count -1 do
    TStringList(InstalledMaps.Objects[Indx]).Free;
  InstalledMaps.Free;
end;

end.
