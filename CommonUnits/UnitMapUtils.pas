unit UnitMapUtils;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  System.Classes, System.Generics.Collections;

type
  TMapSegment = class
    MapSegment: integer;
    MapDescription: string;
    constructor Create(AMapSegment: integer);
  end;
  TMapSegmentList = TObjectDictionary<integer, TMapSegment>;

function CreateLink(const PathObj, PathLink, Desc, Param: string): Boolean;
function ResolveLink(const Path: string): string;
procedure ListMapsRegistryKey(const MapsList: TStringList;
                              const MapsKey: string);
procedure ListMapsAppData(const BaseDir: string;
                          const MapsList: TStringList;
                          const IncludePath: boolean = false);
procedure ListMaps(const BaseDir: string;
                   const InstalledMaps: TStringList);
function DeleteLink(const Path: string): boolean;
function GetMapFolder: string;
function GetKnownFolder(const Known: TGUID): string;
function LookupMap(const MapSegment: integer): string;
procedure ClearTileCache;

implementation

uses
  System.Win.Registry, System.SysUtils, System.StrUtils, System.Win.ComObj,
  Winapi.Windows, Winapi.ShlObj, Winapi.ActiveX, Winapi.ShellAPI, Winapi.KnownFolders,
  UnitVerySimpleXml, UnitStringUtils;

var
  InstalledMaps: TStringList;

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
  result := System.SysUtils.DeleteFile(Path);
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

  TDetailRec = packed record
    MapSegment: integer;
    MapParent:  integer;
    Bounds:     array[0..3] of integer;
  end;

  TMIdxRec = packed record
    MapId:      integer;
    ProductId:  SmallInt;
    FamilyId:   SmallInt;
    MapName:    integer;
  end;

procedure TPNameRec.Init;
begin
  Prec := Default(TPRec);
  MapName := '';
end;

constructor TMapSegment.Create(AMapSegment: integer);
begin
  inherited Create;
  MapSegment := AMapSegment;
end;

function ScanTdb(const TdbFile: string;
                 const InstalledMapSegs: TMapSegmentList): TPNameRec;
var
  F: File;
  TDBRec: TTDBRec;
  DetailRec: TDetailRec;
  AMapSegment: TMapSegment;
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
  FileMode := fmOpenRead;
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
              if (BR >= SizeOf(result.Prec)) then
              begin
                Move(Rec[0], result.Prec, SizeOf(result.Prec));
                ReadString(SizeOf(result.Prec), result.MapName);
              end;
            end;
          'L':
            begin
              if (BR >= SizeOf(DetailRec)) then
              begin
                DetailRec := Default(TDetailRec);
                Move(Rec[0], DetailRec, SizeOf(DetailRec));
                AMapSegment := TMapSegment.Create(DetailRec.MapSegment);
                ReadString(SizeOf(DetailRec), AMapSegment.MapDescription);
                InstalledMapSegs.Add(DetailRec.MapSegment, AMapSegment);
              end;
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

procedure ListMdx(const MdxFile: string;
                  const MapSegments: TStringList;
                  const InstalledMapSegs: TMapSegmentList);
var
  F: File;
  SaveFileMode: byte;
  Sign: array[0..5] of byte;
  Rec: array of byte;
  BR, RecLen: integer;
  RecCount, Cnt: DWord;
  IdxRec: TMidxRec;
  MapSegDescription: string;
const
  MDXInvalid = 'MDX Invalid';

begin
  AssignFile(F, MdxFile);
  SaveFileMode := FileMode;
  Filemode := fmOpenRead;
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

        if (BR >= SizeOf(IdxRec)) then
        begin
          Move(Rec[0], IdxRec, SizeOf(IdxRec));
          MapSegDescription := IntToStr(IdxRec.MapId);
          if (InstalledMapSegs.ContainsKey(IdxRec.MapName)) then
            MapSegDescription := InstalledMapSegs.Items[IdxRec.MapName].MapDescription;
          MapSegments.AddObject(MapSegDescription, pointer(IdxRec.MapId));
        end;
      end;
    finally
      CloseFile(F);
    end;
  finally
    FileMode := SaveFileMode;
  end;
end;

procedure ListMapsRegistryKey(const MapsList: TStringList;
                              const MapsKey: string);
var
  Maps, SubProducts, MapSegments: TStringList;
  Idx, Tdb, AMapKey, BMap: string;
  ProductNameRec: TPNameRec;
  Reg: TRegistry;
  InstalledMapSegs: TMapSegmentList;

begin
  Maps := TStringList.Create;
  SubProducts := TStringList.Create;
  Reg := TRegistry.Create;
  InstalledMapSegs := TMapSegmentList.Create([DoOwnsValues]);
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

            InstalledMapSegs.Clear;
            Tdb := Reg.ReadString('TDB');
            if (Tdb <> '') then
              ProductNameRec := ScanTdb(Tdb, InstalledMapSegs);
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
          ListMdx(Idx, MapSegments, InstalledMapSegs);
          MapsList.AddObject(ProductNameRec.MapName, TStringList(MapSegments));
        end;
        Reg.CloseKey;
      end;
    end;

  finally
    InstalledMapSegs.Free;
    Maps.Free;
    SubProducts.Free;
    Reg.Free;
  end;
end;

procedure ListMapsRegistry(const MapsList: TStringList);
const
  MapsKey = 'SOFTWARE\Wow6432Node\Garmin\MapSource\Families';
  MapsKeyNT = 'SOFTWARE\Wow6432Node\Garmin\MapSource\FamiliesNT';
begin
  ListMapsRegistryKey(MapsList, MapsKey);
  ListMapsRegistryKey(MapsList, MapsKeyNT);
end;

procedure ListMapsAppData(const BaseDir: string;
                          const MapsList: TStringList;
                          const IncludePath: boolean = false);
var
  Fs: TSearchRec;
  Rc: Integer;
  First: boolean;
  Xml, MapDir, Tdb, Idx: string;
  ProductNameRec: TPNameRec;

  MapSegments: TStringList;
  InstalledMapSegs: TMapSegmentList;
  XmlDoc: TXmlVSDocument;
  ProductNode, IdxNode, SubProductNode, SubProductDirNode, TDBNode: TXmlVSNode;
begin
  if not DirectoryExists(BaseDir) then
    exit;
  ChDir(BaseDir);
  XmlDoc := TXmlVSDocument.Create;
  InstalledMapSegs := TMapSegmentList.Create([doOwnsValues]);
  try
    First := true;
    while (True) do
    begin
      if (First) then
        Rc := System.SysUtils.FindFirst(IncludeTrailingPathDelimiter(BaseDir) + '*.*', faSymLink, Fs)
      else
        Rc := System.SysUtils.FindNext(Fs);
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
      InstalledMapSegs.Clear;
      ProductNameRec := ScanTdb(Tdb, InstalledMapSegs);

      MapSegments := TStringList.Create;
      IdxNode := ProductNode.Find('IDX');
      if (IdxNode <> nil) then
      begin
        Idx := MapDir + IdxNode.NodeValue;
        if FileExists(Idx) then
          ListMdx(Idx, MapSegments, InstalledMapSegs);
      end;
      if (IncludePath) then
        MapSegments.Add(ExpandFileName((Fs.Name)));

      MapsList.AddObject(ProductNameRec.MapName, TStringList(MapSegments));
    end;
    System.SysUtils.FindClose(Fs);
  finally
    XmlDoc.Free;
    InstalledMapSegs.Free;
  end;
end;

procedure ListMaps(const BaseDir: string;
                   const InstalledMaps: TStringList);
begin
  ListMapsAppData(BaseDir, InstalledMaps);
  ListMapsRegistry(InstalledMaps);
end;

procedure ScanInstalledMaps;
begin
  InstalledMaps := TStringList.Create;
  ListMaps(GetMapFolder, InstalledMaps);
end;

function LookupMap(const MapSegment: integer): string;
var
  Map, MapSeg: integer;
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
      if (integer(MapsegList.Objects[MapSeg]) = MapSegment) then
      begin
        result := InstalledMaps[Map] + #9 + IntToStr(MapSegment) + ': ' + MapsegList[MapSeg];
        exit;
      end;
    end;
  end;
end;

function GetKnownFolder(const Known: TGUID): string;
var
  NameBuffer: PChar;
begin
  result := '';
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
var
  Index: integer;
begin
  if (InstalledMaps <> nil) then
  begin
    for Index := 0 to InstalledMaps.Count -1 do
      TStringList(InstalledMaps.Objects[Index]).Free;
  end;
  InstalledMaps.Free;
end;

end.
