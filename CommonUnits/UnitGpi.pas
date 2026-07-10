unit UnitGpi;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  System.Classes, System.Types, System.SysUtils, System.DateUtils, System.Generics.Collections,
  Vcl.Graphics,
  UnitBmp;

const
  GpiName                     = 'my.gpi';
  GpiVersion: Word            = 0;
  DefTransparentColor: DWORD  = $00ff00ff;
  GpiLargeSymbols             = '80x80';
  GpiMediumSymbols            = '48x48';
  GpiSmallSymbols             = '24x24';
  DefGpiSymbolsDir            = 'Symbols\';
  DefGpiSmallSymbolsDir       = DefGpiSymbolsDir + GpiSmallSymbols + '\';
  DefGpiProximity             = '1000';  // Meter
  GPIExtension                = '.gpi';
  GPIMask                     = '*' + GPIExtension;
  UnlExtension                = '.unl';

type
  TGPXString = UTF8String;

  TGPXWayPoint = class
// Possible Input Data
    Name: TGPXString;
    Comment: TGPXString;
    Description: TGPXString;
    Lat: TGPXString;
    Lon: TGPXString;
    Proximity: Word;
    Speed: Word;
    AlertType: byte;          // 0=360, 1=along road, 2=Tour guide
    Phone: TGPXString;
    Email: TGPXString;        // Not used in TM
    Country: TGPXString;
    State: TGPXString;
    PostalCode: TGPXString;
    City: TGPXString;
    Street: TGPXString;
    HouseNbr: TGPXString;
    Category: TGPXString;
    MediaId: byte;
    SoundNbr: byte;           // 0=Beep, 1=Tone,2= 3x Beep,3=Silence,4=Plung,5=Double Plung
    CategoryId: integer;
    BitmapId: integer;
    AudioAlert: byte;
// Only Output
    PoiId: integer;           // Taken from the PoiGroup
    PoiGroup: TGPXString;     // ""
    ImageCnt: integer;        // Count of images in WayPoint. Zumo displays only the 1st
    SelStart: array[0..$12] of int64;
    SelLength: array[0..$12] of int64;
    constructor Create;
    destructor Destroy; override;
  end;
  TPOIList = TObjectlist<TGPXWayPoint>;
  TPOIGroupData = class(TPOIList)
    SelStart: int64;
    SelLength: int64;
    SelStartArea: int64;
    SelLengthArea: int64;
    Id: integer;
    Name: TGPXString;
  end;
  TPOIGroupList = TObjectlist<TPOIGroupData>;

  TGPXCategory = class
    Category: TGPXString;
    CategoryId: Word;
    constructor Create;
    destructor Destroy; override;
  end;

  TGPXBitmap = class
    Bitmap: TGPXString;
    BitmapId: Word;
    GpiSymbolsDir: TGPXString;
    constructor Create(SymbolsDir: TGPXString = DefGpiSmallSymbolsDir);
    destructor Destroy; override;
  end;

  TGPXMedia = class
  private
    function CheckMedia(const AMediaPath: string; var NewMedia: string): int64;
  public
    MediaDir: string;
    BmpFile: string;
    JpgFile: string;
    Mp3File: string;
    MediaId: byte;
    Mp3Id: byte;
    Mp3Dup: boolean;
    BmpSize: int64;
    JpgSize: int64;
    Mp3Size: int64;
    constructor Create;
    destructor Destroy; override;
    procedure AddMediaFromDir;
    function HaveAllSizes: boolean;
    function AddBmpMedia(ABmpMedia: string): boolean;
    function AddMp3Media(AMp3Media: string): boolean;
    function AddJpgMedia(AJpgMedia: string): boolean;
  end;

  TPString = packed record
    LChars:     Word;
    Chars:      array of AnsiChar;
    constructor Create(AChars: TGPXString);
    procedure Write(S: TBufferedFileStream);
    procedure Read(S: TBufferedFileStream);
    function Size: integer;
  end;

  TPLString = packed record
    LCountry:   DWord;
    Country:    array[0..1] of AnsiChar;
    LChars:     Word;
    Chars:      array of AnsiChar; // Defined as AnsiChar, but can contain UTF8
    constructor Create(AChars: TGPXString);
    procedure Write(S: TBufferedFileStream);
    procedure Read(S: TBufferedFileStream);
    function Size: integer;
  end;

  TExtraRec = packed record
    RecType:    Word;
    Flags:      Word;
    TotalLength:DWord;
    MainLength: DWord;
    constructor Create(AVersion, ARecType: Word);
    procedure Write(S: TBufferedFileStream; ATotalLength, AExtra: Dword);
    procedure Read(S: TBufferedFileStream);
    function Assign(var Dest: TExtraRec): boolean;
  end;

  TMainRec = packed record
    RecType:    Word;
    Flags:      Word;
    Length:     DWord;
    constructor Create(AVersion, ARecType: Word);
    procedure Write(S: TBufferedFileStream; ALength: Dword);
    procedure Read(S: TBufferedFileStream); overload;
    procedure Read(S: TBufferedFileStream; var ExtraRec: TExtraRec); overload;
    procedure Assign(var Dest: TMainRec);
  end;

  TCategoryRef = packed record
    MainRec:    TMainRec;
    Id:         SmallInt;
    constructor Create(AVersion: Word; AId: SmallInt);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

  TCategory = packed record
    MainRec:    TMainRec;
    Id:         SmallInt;
    Name:       TPLString;
    constructor Create(AVersion: Word; GPXCategory: TGPXCategory);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

  TPoiBitmapRef = packed record
    MainRec:    TMainRec;
    Id:         SmallInt;
    constructor Create(AVersion: Word; AId: SmallInt);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

  TPoiBitmap = packed record
    MainRec:    TMainRec;
    Id:         SmallInt;
    Height:     SmallInt;
    Width:      SmallInt;
    LineSize:   SmallInt;
    BPP:        SmallInt;
    Dummy1:     SmallInt;
    ImageSize:  DWord;
    Dummy2:     DWord;
    CntColPat:  DWord;
    TranspCol:  DWord;
    Flags2:     DWord;
    Dummy3:     DWord;
    ScanLines:  array of byte;
    ColPat:     array of byte;
    BitMapRd: TBitMapReader;
    constructor Create(AVersion: Word; GPXBitMap: TGPXBitmap);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Bitmap: Vcl.Graphics.TBitMap;
    function Size: integer;
  end;

  THeader1 = packed record
    MainRec:    TMainRec;
    GrmRec:     array[0..5] of AnsiChar;
    Version:    array[0..1] of AnsiChar;
    TimeStamp:  DWord;
    Flag1:      byte;
    Flag2:      byte;
    Name:       TPstring;
    constructor Create(AVersion: Word);
    procedure Write(S: TBufferedFileStream);
    procedure Read(S: TBufferedFileStream);
    function Size: integer;
  end;

  THeader2 = packed record
    MainRec:    TMainRec;
    PoiRec:     array[0..3] of AnsiChar;
    Dummy:      Word;
    Version:    array[0..1] of AnsiChar;
    CodePage:   Word;
    CopyRight:  Word;
    constructor Create(AVersion: Word);
    procedure Write(S: TBufferedFileStream);
    procedure Read(S: TBufferedFileStream);
    function Size: integer;
  end;

// Need to be defined before TWayPt
  TAlert = packed record
    MainRec:    TMainRec;
    Proximity:  Word;
    Speed:      Word;
    Dummy1:     Word;
    Dummy2:     Word;
    Alert:      Byte;
    AlertType:  Byte;
    SoundNbr:   Byte;
    AudioAlert: Byte;
    constructor Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
  end;

  TComment = packed record
    MainRec:    TMainRec;
    Comment:    TPLString;
    constructor Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

  TAddress = packed record
    Extra:      boolean;                    // Internal variable, dont write
    ExtraRec:   TExtraRec;
    MainRec:    TMainRec;
    Flags:      Word;
    City:       TPLString;
    Country:    TPLString;
    State:      TPLString;
    PostalCode: TPString;
    Street:     TPLString;
    HouseNbr:   TPString;
    constructor Create(AVersion: Word; GPXWayPoint: TGPXWayPoint; AExtra: boolean);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
    function Size: integer;
    function ExtraSize: integer;
  end;

  TContact = packed record
    Extra:      boolean;                    // Internal variable, dont write
    ExtraRec:   TExtraRec;
    MainRec:    TMainRec;
    Flags:      Word;
    Phone:      TPString;
    Email:      TPString;
    constructor Create(AVersion: Word; GPXWayPoint: TGPXWayPoint; AExtra: boolean);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
    function Size: integer;
    function ExtraSize: integer;
  end;

  TImage = packed record
    MainRec:    TMainRec;
    Dummy1:     Byte;
    ImageSize:  DWord;
    Image:      TBytes;
    constructor Create(AVersion: Word; AGPXMedia: TGPXMedia);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

  TDescription = packed record
    MainRec:    TMainRec;
    Unknown16:  Byte;
    Desc:       TPString;
    DescL:      TPLString;
    constructor Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

// Until here

  TWayPt = packed record
    Extra:      boolean;                    // Internal variable, dont write
    ExtraRec:   TExtraRec;
    MainRec:    TMainRec;
    Lat:        LongInt;
    Lon:        LongInt;
    Dummy1:     Word;
    HasAlert:   Byte;
    Name:       TPLString;
    CategoryRef:TCategoryRef;
    BitmapRef:  TPoiBitmapRef;
    Alert:      TAlert;
    Comment:    TComment;
    Address:    TAddress;
    Contact:    TContact;
    Description:TDescription;
    Image:      TImage;
    constructor Create(AVersion: Word; AGPXWayPoint: TGPXWayPoint; AGPXMedia: TGPXMedia; AExtra: boolean);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
    function Size: integer;
    function ExtraSize: integer;
  end;

  TArea = packed record
    Extra:      boolean;                   // Internal variable, dont write
    ExtraSize:  integer;
    ExtraRec:   TExtraRec;
    MaxLat:     LongInt;
    MaxLon:     LongInt;
    MinLat:     LongInt;
    MinLon:     LongInt;
    Dummy1:     DWord;
    Dummy2:     Word;
    Alert:      Byte;
    WayPts:     TObjectlist<TGPXWayPoint>; // Internal variable, dont write
    Medias:     TObjectList<TGPXMedia>;    // Copy of PoiGroup;
    constructor Create(AVersion: Word; AMedias: TObjectList<TGPXMedia>; AExtra: boolean);
    procedure AddWpt(GPXWayPt: TGPXWayPoint);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(ExtraRec: TExtraRec);
    procedure Read(S: TBufferedFileStream; ExtraRec: TExtraRec);
    function Size: integer;
  end;

  TMedia = packed record
    Extra:      boolean;  // Internal variable, dont write
    ExtraRec:   TExtraRec;
    MainRec:    TMainRec;
    MediaId:    Byte;
    AudioType:  Byte;    // $10=Builtin $20=Custom Audio
    AudioFormat:Byte;    // $00=Wav, $01=Mp3
    TotalLength:DWord;
    Locale:     array[0..1] of AnsiChar;
    MediaLength:DWord;
    Media:      Tbytes;
    constructor Create(AVersion: Word; AMedia: TGPXMedia; Simulate: boolean; AExtra: boolean = true);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
    function Size: integer;
    function ExtraSize: integer;
  end;

  TEndx = packed record
    MainRec:    TMainRec;
    constructor Create(AVersion: Word);
    procedure Write(S: TBufferedFileStream);
    function Size: integer;
  end;

  TPOIGroup = packed record
    Extra:      boolean;
    ExtraSize:  integer;
    MainRec:    TMainRec;
    ExtraRec:   TExtraRec;
    Name:       TPLString;
    Area:       TArea;
    Categories: TObjectlist<TGPXCategory>;  // Internal variable, dont write
    BitMaps:    TObjectlist<TGPXBitmap>;    // Internal variable, dont write
    Medias:     TObjectlist<TGPXMedia>;     // Internal variable, dont write
    constructor Create(AVersion: Word; AName: TGPXString; AExtra: boolean = true);
    procedure AddWpt(GPXWayPt: TGPXWayPoint);
    function AddCat(GPXCategory: TGPXCategory): integer;
    function AddBmp(GPXBitMap: TGPXBitMap): integer;
    function AddGPXMedia: integer;
    procedure CheckTourGuideMedia(MediaId: integer; var BmpId: integer; var Mp3Id: integer);
    procedure AddMedia(MediaId: integer; AGPXDir, ATourGuidePath: string);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
    function Size: integer;
  end;

  TGPI = packed record
    Version:        Word;
    Extra:          boolean;
    Header1:        THeader1;
    Header2:        THeader2;
    POIGroup:       TPOIGroup;
    Endx:           TEndx;
    constructor Create(AVersion: Word; AExtra: boolean = true);
    procedure WriteHeader(S: TBufferedFileStream);
    function CreatePOIGroup(Category: TGPXString): TPOIGroup;
    procedure WriteEnd(S: TBufferedFileStream);
    procedure Read(S: TBufferedFileStream; APOIGroupList: TPOIGroupList; ImageDir: string = '');
    procedure SaveGpx(const GPXFile: string; const APOIGroupList: TPOIGroupList; const SymbolCat: string);
  end;

const HasPhone:   Word = $0001;
      HasEmail:   Word = $0008;
      HasCity:    Word = $0001;
      HasCountry: Word = $0002;
      HasState:   Word = $0004;
      HasPostal:  Word = $0008;
      HasStreet:  Word = $0010;
      HasHouseNbr:Word = $0020;

implementation

uses
  System.Math, System.WideStrUtils,
  Winapi.Windows,
  Vcl.Dialogs, Vcl.Imaging.pngimage,
  UnitVerySimpleXml, UnitStringUtils;

const
  Coord_Decimals = '%1.6f';
  DefLocale      = 'EN';

var
  FormatSettings: TFormatSettings;

constructor TGPXWayPoint.Create;
begin
  inherited;

  BitmapId := -1;
  CategoryId := -1;
  Proximity := 0;
  Speed := 0;
  AlertType := 0;
  MediaId := 0;
  SoundNbr := 0;
  ImageCnt := 0;
  AudioAlert := $10;
end;

destructor TGPXWayPoint.Destroy;
begin
  inherited;
end;

constructor TGPXCategory.Create;
begin
  inherited;
end;

destructor TGPXCategory.Destroy;
begin
  inherited;
  Category := '';
end;

constructor TGPXBitmap.Create(SymbolsDir: TGPXString = DefGpiSmallSymbolsDir);
begin
  inherited Create;
  GpiSymbolsDir := SymbolsDir;
end;

destructor TGPXBitmap.Destroy;
begin
  Bitmap := '';
  inherited;
end;

constructor TGPXMedia.Create;
begin
  inherited Create;
  MediaId := 0;
  MP3Id := 0;
  MediaDir := '';
  BmpFile := '';
  BmpSize := -1;
  JpgFile := '';
  JpgSize := -1;
  Mp3File := '';
  Mp3Size := -1;
  Mp3Dup := false;
end;

function TGPXMedia.HaveAllSizes: boolean;
begin
  result := (BmpSize > -1) and
            (JpgSize > -1) and
            (Mp3Size > -1);
end;

function TGPXMedia.CheckMedia(const AMediaPath: string; var NewMedia: string): int64;
var
  Fs: TSearchRec;
  Rc: integer;
begin
  result := -1;
  NewMedia := '';
  Rc := System.SysUtils.FindFirst(AMediaPath, faAnyFile, Fs);
  if (Rc = 0) then
  begin
    result := Fs.Size;
    NewMedia := ExtractFilePath(AMediaPath) + Fs.Name;
    System.SysUtils.FindClose(Fs);
  end;
end;

procedure TGPXMedia.AddMediaFromDir;
begin
  if (Mp3Size < 0) then
    Mp3Size := CheckMedia(MediaDir + '*.mp3', Mp3File);
  if (JpgSize < 0) then
    JpgSize := CheckMedia(MediaDir + '*.jpg', JpgFile);
  if (BmpSize < 0) then
    BmpSize := CheckMedia(MediaDir + '*.bmp', BmpFile);
end;

function TGPXMedia.AddBmpMedia(ABmpMedia: string): boolean;
begin
  MediaDir := ExtractFilePath(ABmpMedia);
  BmpSize := CheckMedia(ABmpMedia, BmpFile);
  result := (BmpSize > -1);
end;

function TGPXMedia.AddMp3Media(AMp3Media: string): boolean;
begin
  MediaDir := ExtractFilePath(AMp3Media);
  Mp3Size := CheckMedia(AMp3Media, Mp3File);
  result := (Mp3Size > -1);
end;

function TGPXMedia.AddJpgMedia(AJpgMedia: string): boolean;
begin
  MediaDir := ExtractFilePath(AJpgMedia);
  JpgSize := CheckMedia(AJpgMedia, JpgFile);
  result := (JpgSize > -1);
end;

destructor TGPXMedia.Destroy;
begin
  inherited;
end;

function ConvertToUtf8(const Chars: PAnsiChar; Cp: integer): TGPXString; overload;
begin
  if (Cp = CP_UTF8) then
    result := Chars
  else
    result := AnsiToUtf8Ex(Chars, Cp);
end;

function ConvertToUtf8(const Source: TPString; Cp: integer): TGPXString; overload;
begin
  result := ConvertToUtf8(PAnsiChar(Source.Chars), Cp);
end;

function ConvertToUtf8(const Source: TPLString; Cp: integer): TGPXString; overload;
begin
  result := ConvertToUtf8(PAnsiChar(Source.Chars), Cp);
end;

function ConvertToString(const Source: TPLString; Cp: integer): string;
begin
  result := string(ConvertToUtf8(Source, Cp));
end;

function GetTimeStamp: DWord;
begin
  try
    result := DateTimeToUnix(IncDay(IncYear(Now, -20)), False);
  except
    result := 0;
  end;
end;

//Relies on formatsettings with a decimal point
function Str2Coord(ACoord: TGPXString): LongInt;
var
  HCoord: Double;
begin
  try
    HCoord := StrToFloat(String(ACoord), FormatSettings);
    HCoord := HCoord * 4294967296 {2^32} / 360;
    result := round(HCoord);
  except
    result := 0;
  end;
end;

function Coord2Str(ACoord: LongInt): TGPXString;
var
  HCoord: Double;
begin
  try
    HCoord := SimpleRoundTo(ACoord / 4294967296 * 360, -6);
    result := TGPXString(Format(Coord_Decimals, [HCoord], FormatSettings));
  except
    result := '';
  end;
end;

constructor TPString.Create(AChars: TGPXString);
begin
  LChars := Length(AChars);
  SetLength(Chars, LChars);
  Move(Achars[1], Chars[0], LChars);
end;

procedure TPString.Write(S: TBufferedFileStream);
begin
  S.Write(LChars, SizeOf(LChars));
  S.Write(Chars[0], LChars);
end;

procedure TPString.Read(S: TBufferedFileStream);
begin
  S.Read(LChars, SizeOf(LChars));
  SetLength(Chars, LChars +1); // Null terminator
  S.Read(Chars[0], LChars);
end;

function TPString.Size: Integer;
begin
  result := LChars + SizeOf(LChars);
end;

constructor TPLString.Create(AChars: TGPXString);
begin
  LCountry := SizeOf(LChars) + Length(AChars) +  SizeOf(Country);
  Country := DefLocale;
  LChars := Length(AChars);
  SetLength(Chars, LChars);
  Move(Achars[1], Chars[0], LChars);
end;

procedure TPLString.Write(S: TBufferedFileStream);
begin
  S.Write(LCountry, SizeOf(LCountry));
  S.Write(Country[0], SizeOf(Country));
  S.Write(LChars, SizeOf(LChars));
  S.Write(Chars[0], LChars);
end;

procedure TPLString.Read(S: TBufferedFileStream);
begin
  S.Read(LCountry, SizeOf(LCountry));
  S.Read(Country[0], SizeOf(Country));
  S.Read(LChars, SizeOf(LChars));
  SetLength(Chars, 0);          // Force zeroes
  SetLength(Chars, LChars +1);  // +1 for null terminator
  S.Read(Chars[0], LChars);
end;

function TPLString.Size: Integer;
begin
  result := LCountry + SizeOf(LCountry);
end;

constructor TMainRec.Create(AVersion, ARecType: Word);
begin
  RecType := ARecType;
  Flags := $0000;
  Length := 0;
end;

procedure TMainRec.Write(S: TBufferedFileStream; ALength: Dword);
begin
  Length := ALength - SizeOf(Self);
  S.Write(RecType, SizeOf(RecType));
  S.Write(Flags, SizeOf(Flags));
  S.Write(Length, SizeOf(Length));
end;

procedure TMainRec.Read(S: TBufferedFileStream);
begin
  S.Read(RecType, SizeOf(RecType));
  S.Read(Flags, SizeOf(Flags));
  S.Read(Length, SizeOf(Length));
end;

procedure TMainRec.Read(S: TBufferedFileStream; var ExtraRec: TExtraRec);
begin
  ExtraRec := Default(TExtraRec);

  Read(S);

  if ((Flags and $08) = $08) then
  begin
    ExtraRec.RecType := RecType;
    ExtraRec.Flags := Flags;
    ExtraRec.TotalLength := Length;
    S.Read(ExtraRec.MainLength, SizeOf(ExtraRec.MainLength));
  end;
end;

procedure TMainRec.Assign(var Dest: TMainRec);
begin
  Move(Self, Dest, Sizeof(Dest));
end;

constructor TExtraRec.Create(AVersion, ARecType: Word);
begin
  RecType := ARecType;
  Flags := $0008;
  MainLength := 0;
  TotalLength := 0;
end;

procedure TExtraRec.Write(S: TBufferedFileStream; ATotalLength, AExtra: Dword);
begin
  TotalLength := ATotalLength - SizeOf(Self);
  MainLength := TotalLength - AExtra;
  S.Write(RecType, SizeOf(RecType));
  S.Write(Flags, SizeOf(Flags));
  S.Write(TotalLength, SizeOf(TotalLength));
  S.Write(MainLength, SizeOf(MainLength));
end;

procedure TExtraRec.Read(S: TBufferedFileStream);
begin
  S.Read(RecType, SizeOf(RecType));
  S.Read(Flags, SizeOf(Flags));
  S.Read(TotalLength, SizeOf(TotalLength));
  S.Read(MainLength, SizeOf(MainLength));
end;

function TExtraRec.Assign(var Dest: TExtraRec): boolean;
begin
  result := ((Flags and $08) = $08);
  Move(Self, Dest, SizeOf(Dest));
end;

// Recordtype 0
constructor THeader1.Create(AVersion: Word);
begin
  MainRec.Create(AVersion, $0000);
  GrmRec := 'GRMREC';
  Version := '00';
  TimeStamp := GetTimeStamp;
  Flag1 := $00;
  Flag2 := $00;
  Name.Create(GpiName);
end;

procedure THeader1.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(GrmRec, SizeOf(Grmrec));
  S.Write(Version, SizeOf(Version));
  S.Write(TimeStamp, SizeOf(TimeStamp));
  S.Write(Flag1, SizeOf(Flag1));
  S.Write(Flag2, SizeOf(Flag2));
  Name.Write(S);
end;

procedure THeader1.Read(S: TBufferedFileStream);
begin
  MainRec.Read(S);
  S.Read(GrmRec, SizeOf(Grmrec));
  if (GrmRec <> 'GRMREC') then
    raise exception.Create('GPI format not supported! GRMREC not on expected location.');
  S.Read(Version, SizeOf(Version));
  if (Version <> '00') then
    raise exception.Create('GPI format not supported! Version must be ''00''.');
  S.Read(TimeStamp, SizeOf(TimeStamp));
  S.Read(Flag1, SizeOf(Flag1));
  S.Read(Flag2, SizeOf(Flag2));
  Name.Read(S);
end;

function THeader1.Size: integer;
begin
  result := Sizeof(THeader1) - SizeOf(Name) + Name.Size;
end;

// Recordtype 1
constructor THeader2.Create(AVersion: Word);
begin
  MainRec.Create(AVersion, $0001);
  PoiRec := 'POI';
  Dummy := $0000;
  Version := '00';
  CodePage := $FDE9;          // UTF8
  CopyRight := $0000;
end;

procedure THeader2.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(PoiRec, SizeOf(PoiRec));
  S.Write(Dummy, SizeOf(Dummy));
  S.Write(Version, SizeOf(Version));
  S.Write(CodePage, SizeOf(CodePage));
  S.Write(CopyRight, SizeOf(CopyRight));
end;

procedure THeader2.Read(S: TBufferedFileStream);
begin
  MainRec.Read(S);
  S.Read(PoiRec, SizeOf(PoiRec));
  if (PoiRec <> 'POI') then
    raise exception.Create('GPI format not supported! POI not on expected location.');
  S.Read(Dummy, SizeOf(Dummy));
  S.Read(Version, SizeOf(Version));
  S.Read(CodePage, SizeOf(CodePage));
  S.Read(CopyRight, SizeOf(CopyRight));
end;

function THeader2.Size: integer;
begin
  result := Sizeof(THeader2);
end;

// Recordtype 2
constructor TWayPt.Create(AVersion: Word; AGPXWayPoint: TGPXWayPoint; AGPXMedia: TGPXMedia; AExtra: boolean);
begin
  Extra := AExtra;
  if (Extra) then
    ExtraRec.Create(AVersion, $0002)
  else
    MainRec.Create(AVersion, $0002);

  Name.Create(AGPXWayPoint.Name);
  Lat := Str2Coord(AGPXWayPoint.Lat);
  Lon := Str2Coord(AGPXWayPoint.Lon);
  Dummy1 := 1;
  HasAlert := 0;
  if (Extra) then
  begin
    CategoryRef.Create(AVersion, AGPXWayPoint.CategoryId); // Can be -1
    BitmapRef.Create(AVersion, AGPXWayPoint.BitmapId);     // Can be -1
    Alert.Create(AVersion, AGPXWayPoint);
    if (Alert.Proximity > 0) or
       (Alert.Speed > 0) then
       HasAlert := $0001;
    Comment.Create(AVersion, AGPXWayPoint);
    Address.Create(AVersion, AGPXWayPoint, true);
    Contact.Create(AVersion, AGPXWayPoint, true);
    Description.Create(AVersion, AGPXWayPoint);
  end;

  Image := Default(TImage);
  if (AGPXWayPoint.AudioAlert = $20) and
     (AGPXMedia.JpgSize > 0) then
    Image.Create(GpiVersion, AGPXMedia);
end;

procedure TWayPt.Write(S: TBufferedFileStream);
begin
  if (Extra) then
    ExtraRec.Write(S, Size, ExtraSize)
  else
    MainRec.Write(S, Size);
  S.Write(Lat, SizeOf(Lat));
  S.Write(Lon, SizeOf(Lon));
  S.Write(Dummy1, Sizeof(Dummy1));
  S.Write(HasAlert, Sizeof(HasAlert));
  Name.Write(S);
  if (Extra) then
  begin
    if (CategoryRef.Id > -1) then
      CategoryRef.Write(S);
    if (BitmapRef.Id > -1) then
      BitmapRef.Write(S);
    if (HasAlert <> 0) then
      Alert.Write(S);
    if (Comment.Comment.LChars > 0) then
      Comment.Write(S);
    if (Address.Flags <> 0) then
      Address.Write(S);
    if (Contact.Flags <> 0) then
      Contact.Write(S);
    if (Image.ImageSize > 0) then
      Image.Write(S);
    if (Description.DescL.LChars > 0) then
      Description.Write(S);
  end;
end;

procedure TWayPt.Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  MainRec.Assign(Self.MainRec);
  Extra := ExtraRec.Assign(Self.ExtraRec);
end;

procedure TWayPt.Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  Assign(MainRec, ExtraRec);

  S.Read(Lat, SizeOf(Lat));
  S.Read(Lon, SizeOf(Lon));
  S.Read(Dummy1, SizeOf(Dummy1));
  S.Read(HasAlert, SizeOf(HasAlert));
  Name.Read(S);
end;

function TWayPt.Size: integer;
begin
  if (Extra) then
    result := SizeOf(ExtraRec)
  else
    result := SizeOf(MainRec);
  result := result + Sizeof(Lat) + SizeOf(Lon) + SizeOf(Dummy1) +
                     SizeOf(HasAlert) + Name.Size;
  result := result + ExtraSize;
end;

function TWayPt.ExtraSize: integer;
begin
  result := 0;
  if (Extra) then
  begin
    if (CategoryRef.Id > -1) then
      result := result + SizeOf(CategoryRef);
    if (BitmapRef.Id > -1) then
      result := result +  SizeOf(BitmapRef);
    if (HasAlert <> 0) then
      result := result + Sizeof(Alert);
    if (Comment.Comment.LChars > 0) then
      result := result + Comment.Size;
    if (Address.Flags <> 0) then
      result := result + Address.Size;
    if (Contact.Flags <> 0) then
      result := result + Contact.Size;
    if (Image.ImageSize > 0) then
      result := result + Image.Size;
    if (Description.DescL.LChars > 0) then
      result := result + Description.Size;
  end;
end;

// Recordtype 3
constructor TAlert.Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
var
  MPS: double;
begin
  MainRec.Create(AVersion, $0003);
  Proximity := GPXWayPoint.Proximity;
  MPS := (GPXWayPoint.Speed * 1000) / (60 * 60);
  Speed := Round(MPS * 100);
  Dummy1 := $0100;
  Dummy2 := $0100;
  Alert := 1;
  AlertType := GPXWayPoint.AlertType;
  SoundNbr := GPXWayPoint.SoundNbr;
  AudioAlert := GPXWayPoint.AudioAlert;   // 0x10=BuiltIn 0x20=Custom
end;

procedure TAlert.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, SizeOf(Talert));
  S.Write(Proximity, SizeOf(Proximity));
  S.Write(Speed, SizeOf(Speed));
  S.Write(Dummy1, SizeOf(Dummy1));
  S.Write(Dummy2, SizeOf(Dummy2));
  S.Write(Alert, SizeOf(Alert));
  S.Write(AlertType, SizeOf(AlertType));
  S.Write(SoundNbr, SizeOf(SoundNbr));
  S.Write(AudioAlert, SizeOf(AudioAlert));
end;

procedure TAlert.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TAlert.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  Assign(MainRec);

  S.Read(Proximity, SizeOf(Proximity));
  S.Read(Speed, SizeOf(Speed));
  S.Read(Dummy1, SizeOf(Dummy1));
  S.Read(Dummy2, SizeOf(Dummy2));
  S.Read(Alert, SizeOf(Alert));
  S.Read(AlertType, SizeOf(AlertType));
  S.Read(SoundNbr, SizeOf(SoundNbr));
  S.Read(AudioAlert, SizeOf(AudioAlert));
end;

// Recordtype 4
constructor TPoiBitmapRef.Create(AVersion: Word; AId: SmallInt);
begin
  MainRec.Create(AVersion, $0004);
  Id := Aid;
end;

procedure TPoiBitmapRef.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, size);
  S.Write(Id, SizeOf(Id));
end;

procedure TPoiBitmapRef.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TPoiBitmapRef.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  Assign(MainRec);

  S.Read(Id, SizeOf(Id));

  // Handle bigger records
  S.Seek(MainRec.Length - SizeOf(Id), TSeekOrigin.soCurrent);
end;

function TPoiBitmapRef.Size: Integer;
begin
  result := SizeOf(TPoiBitmapRef);
end;

// Recordtype 5
constructor TPoiBitMap.Create(AVersion: Word; GPXBitMap: TGPXBitmap);
begin
  Id := GPXBitMap.BitmapId;
  MainRec.Create(AVersion, $0005);

  BitMapRd := TBitMapReader.Create;
  try
    try
      BitMapRd.Load(string(GPXBitMap.GpiSymbolsDir) +
                           ChangeFileExt(StringReplace(string(GPXBitMap.Bitmap), '/', '_', [rfReplaceAll]), '.bmp'));
    except on E:Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    end;
    with BitMapRd, BitMapRd.BitmapInfoHeader do
    begin
      Height := biHeight;
      Width := biWidth;
      LineSize := (biWidth * biBitCount) div 8;
      BPP := biBitCount;
      Dummy1 := 0;
      ImageSize := LineSize * Height;
      Dummy2 := 44;                     // ???
      CntColPat := PalCount;
      TranspCol := DefTransparentColor; // Magenta
      Flags2 := $0001;                  // Transparent
      Dummy3 := ImageSize + Dummy2;     // ???
    end;
    SetLength(ColPat, length(BitMapRd.ColPat));
    Move(BitMapRd.ColPat[0], ColPat[0], length(BitMapRd.ColPat));
    SetLength(ScanLines, length(BitMapRd.ScanLines));
    Move(BitMapRd.ScanLines[0], ScanLines[0], length(BitMapRd.ScanLines));
  finally
    FreeAndNil(BitMapRd);
  end;
end;

procedure TPoiBitMap.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(Id, Sizeof(Id));
  S.Write(Height, SizeOf(Height));
  S.Write(Width, SizeOf(Width));
  S.Write(LineSize, SizeOf(LineSize));
  S.Write(BPP, SizeOf(BPP));
  S.Write(Dummy1, SizeOf(Dummy1));
  S.Write(ImageSize, SizeOf(ImageSize));
  S.Write(Dummy2, SizeOf(Dummy2));
  S.Write(CntColPat, SizeOf(CntColPat));
  S.Write(TranspCol, SizeOf(TranspCol));
  S.Write(Flags2, SizeOf(Flags2));
  S.Write(Dummy3, SizeOf(Dummy3));
  S.Write(ScanLines[0], length(ScanLines));
  S.Write(ColPat[0], length(ColPat));

  SetLength(ScanLines, 0);
  SetLength(Colpat, 0);
end;

procedure TPoiBitMap.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TPoiBitMap.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);

  S.Read(Id, Sizeof(Id));
  S.Read(Height, SizeOf(Height));
  S.Read(Width, SizeOf(Width));
  S.Read(LineSize, SizeOf(LineSize));
  S.Read(BPP, SizeOf(BPP));
  S.Read(Dummy1, SizeOf(Dummy1));
  S.Read(ImageSize, SizeOf(ImageSize));
  S.Read(Dummy2, SizeOf(Dummy2));
  S.Read(CntColPat, SizeOf(CntColPat));
  S.Read(TranspCol, SizeOf(TranspCol));
  S.Read(Flags2, SizeOf(Flags2));
  S.Read(Dummy3, SizeOf(Dummy3));

  SetLength(ScanLines, ImageSize);
  S.Read(ScanLines[0], Length(ScanLines));

  SetLength(ColPat, CntColPat * SizeOf(TPaletteEntry));
  S.Read(ColPat[0], Length(ColPat));
end;

function TPoiBitmap.Bitmap: Vcl.Graphics.TBitMap;
var
  ScanIndx, Indx: integer;
  LogPal: TMaxLogPalette;
begin
  if (BPP <> 8) then
    exit(nil);

  result := Vcl.Graphics.TBitmap.Create(Width, Height);
  result.PixelFormat := pf8bit;

  LogPal.palVersion := $300;
  LogPal.palNumEntries := CntColPat;
  CopyMemory(@LogPal.palPalEntry, @ColPat[0], CntColPat * SizeOf(TPaletteEntry));
  Bitmap.Palette := CreatePalette(pLogPalette(@LogPal)^);

  ScanIndx := 0;
  for Indx := 0 to Height -1 do
  begin
    CopyMemory(result.ScanLine[Indx], @ScanLines[ScanIndx], LineSize);
    Inc(ScanIndx, LineSize);
  end;
end;

function TPoiBitMap.Size: integer;
begin
  result := SizeOf(MainRec) +
            SizeOf(Id) +
            SizeOf(Height) +
            SizeOf(Width) +
            SizeOf(LineSize) +
            SizeOf(BPP) +
            SizeOf(Dummy1) +
            SizeOf(ImageSize) +
            SizeOf(Dummy2) +
            Sizeof(CntColPat) +
            SizeOf(TranspCol) +
            Sizeof(Flags2) +
            SizeOf(Dummy3) +
            Length(ScanLines) +
            Length(ColPat);
end;

// Recordtype 6
constructor TCategoryRef.Create(AVersion: Word; AId: SmallInt);
begin
  Id := Aid;
  MainRec.Create(AVersion, $0006);
end;

procedure TCategoryRef.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(Id, Sizeof(Id));
end;

procedure TCategoryRef.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TCategoryRef.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  Assign(MainRec);

  S.Read(Id, Sizeof(Id));
end;

function TCategoryRef.Size: integer;
begin
  result := SizeOf(TCategoryRef);
end;

// Recordtype 7
constructor TCategory.Create(AVersion: Word; GPXCategory: TGPXCategory);
begin
  Id := GPXCategory.CategoryId;
  Name.Create(GPXCategory.Category);
  MainRec.Create(AVersion, $0007);
end;

procedure TCategory.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(Id, Sizeof(Id));
  Name.Write(S);
end;

procedure TCategory.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TCategory.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  Assign(MainRec);

  S.Read(Id, Sizeof(Id));
  Name.Read(S);
end;

function TCategory.Size: integer;
begin
  result := SizeOf(TCategory) - SizeOf(Name) + Name.Size;
end;

// Recordtype 8
constructor TArea.Create(AVersion: Word; AMedias: TObjectList<TGPXMedia>; AExtra: boolean);
begin
  Extra := AExtra; // Extra fields for members, TArea is always extra
  ExtraRec.Create(AVersion, $0008);
  ExtraSize := 0;
  MaxLat := -MaxInt;
  MaxLon := -MaxInt;
  MinLat := MaxInt;
  MinLon := MaxInt;
  Alert := 0;
  Dummy1 := 0;
  Dummy2 := 1;
  WayPts := TObjectlist<TGPXWayPoint>.Create(true);
  Medias := AMedias;
end;

procedure TArea.AddWpt(GPXWayPt: TGPXWayPoint);
var
  WayPt: TWayPt;
  AMedia: TGPXMedia;
begin
  AMedia := nil;
  if (GPXWayPt.AudioAlert = $20) and
     (GPXWayPt.MediaId <= Medias.Count) then
    AMedia := Medias[GPXWayPt.MediaId -1];
  WayPt.Create(GPIVersion, GPXWayPt, AMedia, Extra);  // Just temporary, to calculate
  ExtraSize := ExtraSize + WayPt.Size;                // If waypoint has extra records like area, this is computed
  if (WayPt.Lat > MaxLat) then
    MaxLat := WayPt.Lat;
  if (WayPt.Lat < MinLat) then
    MinLat := WayPt.Lat;
  if (WayPt.Lon > MaxLon) then
    MaxLon := WayPt.Lon;
  if (WayPt.Lon < MinLon) then
    MinLon := WayPt.Lon;
  if (WayPt.Alert.Proximity > 0) or
     (WayPt.Alert.Speed > 0) then
    Alert := 1;
  WayPts.Add(GPXWayPt);
end;

procedure TArea.Write(S: TBufferedFileStream);
var
  GPXWayPt: TGPXWayPoint;
  WayPt: TWayPt;
  AMedia: TGPXMedia;
begin
  ExtraRec.Write(S, Size, ExtraSize);
  S.Write(MaxLat, SizeOf(MaxLat));
  S.Write(MaxLon, SizeOf(MaxLon));
  S.Write(MinLat, SizeOf(MinLat));
  S.Write(MinLon, SizeOf(MinLon));
  S.Write(Dummy1, Sizeof(Dummy1));
  S.Write(Dummy2, Sizeof(Dummy2));
  S.Write(Alert, SizeOf(Alert));
  for GPXWayPt in WayPts do
  begin
    AMedia := nil;
    if (GPXWayPt.AudioAlert = $20) and
       (GPXWayPt.MediaId <= Medias.Count) then
      AMedia := Medias[GPXWayPt.MediaId -1];
    WayPt.Create(GPIVersion, GPXWayPt, AMedia, Extra);
    WayPt.Write(S);
  end;
  WayPts.Free;
end;

procedure TArea.Assign(ExtraRec: TExtraRec);
begin
  Extra := ExtraRec.Assign(Self.ExtraRec);
end;

procedure TArea.Read(S: TBufferedFileStream; ExtraRec: TExtraRec);
begin
  Assign(ExtraRec);

  S.Read(MaxLat, SizeOf(MaxLat));
  S.Read(MaxLon, SizeOf(MaxLon));
  S.Read(MinLat, SizeOf(MinLat));
  S.Read(MinLon, SizeOf(MinLon));
  S.Read(Dummy1, Sizeof(Dummy1));
  S.Read(Dummy2, Sizeof(Dummy2));
  S.Read(Alert, Sizeof(Alert));
end;

function TArea.Size: integer;
begin
  result := SizeOf(ExtraRec);
  result := result + SizeOf(MaxLat) + SizeOf(MaxLon) + SizeOf(MinLat) + SizeOf(MinLon);
  result := result + sizeof(Dummy1) + SizeOf(Dummy2) + SizeOf(Alert) + ExtraSize;
end;

constructor TPOIGroup.Create(AVersion: Word; AName: TGPXString; AExtra: boolean = true);
begin
  Extra := AExtra;
  ExtraSize := 0;
  Name.Create(AName);
  Medias := TObjectlist<TGPXMedia>.Create(true);

  Area.Create(GPIVersion, Medias, Extra);
  if (Extra) then
  begin
    ExtraRec.Create(AVersion, $09);
    Categories := TObjectlist<TGPXCategory>.Create(true);
    BitMaps := TObjectlist<TGPXBitmap>.Create(true);
  end
  else
    MainRec.Create(AVersion, $09); // Length will be recalculated by adding wpt
end;

procedure TPOIGroup.CheckTourGuideMedia(MediaId: integer; var BmpId: integer; var Mp3Id: integer);
var
  AMedia: TMedia;
  AllGPXMedia: TGPXMedia;
  AGPXMedia: TGPXMedia;
  AGPXBitmap: TGPXBitmap;
begin
  BmpId := -1;
  Mp3Id := -1;

  // TourGuide media requested?
  if (MediaId < 0) then
    exit;
  AGPXMedia := Medias[MediaId -1];

  // Try to add media from MediaDir, if not found
  if (AGPXMedia.MediaDir <> '') and
     (AGPXMedia.HaveAllSizes = false) then
    AGPXMedia.AddMediaFromDir;

  // Bmp file specified. Use that and not the one from <symbol>
  if (AGPXMedia.BmpSize > -1) then
  begin
    AGPXBitmap := TGPXBitmap.Create(TGPXString(ExtractFilePath(AGPXMedia.BmpFile)));
    AGPXBitmap.Bitmap := TGPXString(ChangeFileExt(ExtractFileName(AGPXMedia.BmpFile), ''));
    BmpId := AddBmp(AGPXBitmap);
  end;

  // Handle duplicate MP3
  for AllGPXMedia in Medias do
  begin
    if (AGPXMedia.Mp3Id <> AllGPXMedia.Mp3Id) and
       (SameText(AllGPXMedia.Mp3File, AGPXMedia.Mp3File)) then
    begin
      AGPXMedia.Mp3Id := AllGPXMedia.Mp3Id;
      AGPXMedia.Mp3Dup := true;
      break;
    end;
  end;

  // Need an MP3 file, Jpg is optional.
  if (AGPXMedia.Mp3Size > -1) then
  begin
    Mp3Id := AGPXMedia.Mp3Id;
    if (AGPXMedia.Mp3Dup = false) then
    begin
      AMedia.Create(GPIVersion, AGPXMedia, true); // Only simulate, no read.
      ExtraSize := ExtraSize + AMedia.Size;
    end;
  end;
//TODO Message if not MP3, Jpg found?
end;

procedure TPOIGroup.AddWpt(GPXWayPt: TGPXWayPoint);
begin
  Area.AddWpt(GPXWayPt);
end;

function TPOIGroup.AddCat(GPXCategory: TGPXCategory): integer;
var
  Category: TCategory;
  AGPXCategory: TGPXCategory;
begin
  result := -1;
  if (Extra) then
  begin
    for AGPXCategory in Categories do
    begin
      result := AGPXCategory.CategoryId;
      if (AGPXCategory.Category = GPXCategory.Category) then
      begin
        GPXCategory.Free;
        exit;
      end;
    end;
    result := Categories.Count +1;
    GPXCategory.CategoryId := result;
    Category.Create(GPIVersion, GPXCategory);
    ExtraSize := ExtraSize + Category.Size;
    Categories.Add(GPXCategory);
  end;
end;

function TPOIGroup.AddBmp(GPXBitMap: TGPXBitMap): integer;
var
  BitMap: TPoiBitMap;
  AGXBitMap: TGPXBitMap;
begin
  result := -1;
  if (Extra) then
  begin
    for AGXBitMap in BitMaps do
    begin
      result := AGXBitMap.BitmapId;
      if (AGXBitMap.Bitmap = GPXBitMap.Bitmap) then
      begin
        GPXBitMap.Free;
        exit;
      end;
    end;
    result := BitMaps.Count +1;
    GPXBitMap.BitmapId := result;
    BitMap.Create(GPIVersion, GPXBitMap);
    ExtraSize := ExtraSize + BitMap.Size;
    BitMaps.Add(GPXBitMap);
  end;
end;

function TPOIGroup.AddGPXMedia: integer;
var
  AGPXMedia: TGPXMedia;
begin
  AGPXMedia := TGPXMedia.Create;
  result := Medias.Add(AGPXMedia) +1;
  Medias[result -1].Mp3Id := result;
end;

procedure TPOIGroup.AddMedia(MediaId: integer; AGpxDir, ATourGuidePath: string);
var
  AGPXMedia: TGPXMedia;
  MediaAvail: boolean;
begin
  MediaAvail := false;
  AGPXMedia := Medias[MediaId -1];

  // Bmp, Mp3, or Jpg specified found. Use it.
  if (SameText(ExtractFileExt(ATourGuidePath), '.bmp')) then
    MediaAvail := AGPXMedia.AddBmpMedia(ATourGuidePath)
  else if (SameText(ExtractFileExt(ATourGuidePath), '.mp3')) then
    MediaAvail := AGPXMedia.AddMp3Media(ATourGuidePath)
  else if (SameText(ExtractFileExt(ATourGuidePath), '.jpg')) then
    MediaAvail := AGPXMedia.AddJpgMedia(ATourGuidePath);

  // If MediaAvail then AGPXMedia.MediaDir contains path. If not try to guess it.
  if (MediaAvail = false) then
  begin
    if (FileExists(ATourGuidePath)) then
      // Linked a txt file for example
     AGPXMedia.MediaDir := ExtractFilePath(ATourGuidePath)
    else
      // Subdir of GPX file
      AGPXMedia.MediaDir := IncludeTrailingPathDelimiter(AGpxDir + ExtractFileName(ExtractFileDir(ATourGuidePath)));
  end;
end;

procedure TPOIGroup.Write(S: TBufferedFileStream);
var
  GPXCategory: TGPXCategory;
  Category: TCategory;
  GPXBitMap: TGPXBitMap;
  PoiBitMap: TPoiBitMap;
  AGPXMedia: TGPXMedia;
  AMedia: TMedia;
begin
  if (Extra) then
    ExtraRec.Write(S, Size, ExtraSize)
  else
    MainRec.Write(S, Size);
  Name.Write(S);
  Area.Write(S);
  if (Extra) then
  begin
    for GPXCategory in Categories do
    begin
      Category.Create(GPIVersion, GPXCategory);
      Category.Write(S);
    end;
    Categories.Free;

    for GPXBitMap in BitMaps do
    begin
      PoiBitMap.Create(GPIVersion, GPXBitMap);
      PoiBitMap.Write(S);
    end;
    Bitmaps.Free;

    for AGPXMedia in Medias do
    begin
      if (AGPXMedia.Mp3Dup = true) or
         (AGPXMedia.Mp3Size < 0) then
        continue;
      AMedia.Create(GpiVersion, AGPXMedia, false);
      AMedia.Write(S);
    end;
    Medias.Free;
  end;
end;

procedure TPOIGroup.Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  MainRec.Assign(Self.MainRec);
  Extra := ExtraRec.Assign(Self.ExtraRec);
end;

procedure TPOIGroup.Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  Assign(MainRec, ExtraRec);

  Name.Read(S);
end;

function TPOIGroup.Size: integer;
begin
  if (Extra) then
    result := SizeOf(ExtraRec)
  else
    result := SizeOf(MainRec);
  result := result + Name.Size + Area.Size;
  if (Extra) then
    result := result + ExtraSize;
end;

// Recordtype 10
constructor TComment.Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
begin
  MainRec.Create(AVersion, $0A);
  Comment.Create(GPXWayPoint.Comment);
end;

procedure TComment.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, Size);
  Comment.Write(S);
end;

procedure TComment.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TComment.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  Assign(MainRec);

  Comment.Read(S);
end;

function TComment.Size: integer;
begin
  result := SizeOf(MainRec) + Comment.Size;
end;

// RecordType 11
constructor TAddress.Create(AVersion: Word; GPXWayPoint: TGPXWayPoint; AExtra: boolean);
begin
  Extra := AExtra;
  if (Extra) then
    ExtraRec.Create(AVersion, $000b)
  else
    MainRec.Create(AVersion, $000b);
  Flags := $0000;     //bit 0=phone, 1=phone2, 2=fax, 3=email, 4=link
                      // Email would be nice, but is not in GPX
  if (GPXWayPoint.City <> '') then
  begin
    Flags := Flags + HasCity;
    City.Create(GPXWayPoint.City);
  end;
  if (GPXWayPoint.Country <> '') then
  begin
    Flags := Flags + HasCountry;
    Country.Create(GPXWayPoint.Country);
  end;
  if (GPXWayPoint.State <> '') then
  begin
    Flags := Flags + HasState;
    State.Create(GPXWayPoint.State);
  end;
  if (GPXWayPoint.PostalCode <> '') then
  begin
    Flags := Flags + HasPostal;
    PostalCode.Create(GPXWayPoint.PostalCode);
  end;
  if (GPXWayPoint.Street <> '') then
  begin
    Flags := Flags + HasStreet;
    Street.Create(GPXWayPoint.Street);
  end;
  if (GPXWayPoint.HouseNbr <> '') then
  begin
    Flags := Flags + HasHouseNbr;
    HouseNbr.Create(GPXWayPoint.HouseNbr);
  end;
end;

procedure TAddress.Write(S: TBufferedFileStream);
begin
  if (Extra) then
    ExtraRec.Write(S, Size, ExtraSize)
  else
    MainRec.Write(S, Size);
  S.Write(Flags, SizeOf(Flags));
  if (Flags and HasCity <> 0) then
    City.Write(S);
  if (Flags and HasCountry <> 0) then
    Country.Write(S);
  if (Flags and HasState <> 0) then
    State.Write(S);
  if (Flags and HasPostal <> 0) then
    PostalCode.Write(S);
  if (Flags and HasStreet <> 0) then
    Street.Write(S);
  if (Flags and HasHouseNbr <> 0) then
    HouseNbr.Write(S);
end;

procedure TAddress.Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  MainRec.Assign(Self.MainRec);
  Extra := ExtraRec.Assign(Self.ExtraRec);
end;

procedure TAddress.Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  Assign(MainRec, ExtraRec);

  S.Read(Flags, SizeOf(Flags));
  if (Flags and HasCity <> 0) then
    City.Read(S);
  if (Flags and HasCountry <> 0) then
    Country.Read(S);
  if (Flags and HasState <> 0) then
    State.Read(S);
  if (Flags and HasPostal <> 0) then
    PostalCode.Read(S);
  if (Flags and HasStreet <> 0) then
    Street.Read(S);
  if (Flags and HasHouseNbr <> 0) then
    HouseNbr.Read(S);
end;

function TAddress.Size: integer;
begin
  if (Extra) then
    result := SizeOf(ExtraRec)
  else
    result := SizeOf(MainRec);
  result := result + SizeOf(Flags);
  result := result + ExtraSize;
end;

function TAddress.ExtraSize: integer;
begin
  result := 0;
  if (Flags and HasCity <> 0) then
    result := result + City.Size;
  if (Flags and HasCountry <> 0) then
    result := result + Country.Size;
  if (Flags and HasState <> 0) then
    result := result + State.Size;
  if (Flags and HasPostal <> 0) then
    result := result + PostalCode.Size;
  if (Flags and HasStreet <> 0) then
    result := result + Street.Size;
  if (Flags and HasHouseNbr <> 0) then
    result := result + HouseNbr.Size;
end;

// RecordType 12
constructor TContact.Create(AVersion: Word; GPXWayPoint: TGPXWayPoint; AExtra: boolean);
begin
  Extra := AExtra;
  if (Extra) then
    ExtraRec.Create(AVersion, $000c)
  else
    MainRec.Create(AVersion, $000c);
  Flags := $0000;     //bit 0=phone, 1=phone2, 2=fax, 3=email, 4=link
                      // Email would be nice, but is not in GPX
  if (GPXWayPoint.Phone <> '') then
  begin
    Flags := Flags + HasPhone;
    Phone.Create(GPXWayPoint.Phone);
  end;
  if (GPXWayPoint.Email <> '') then
  begin
    Flags := Flags + HasEmail;
    Email.Create(GPXWayPoint.Email);
  end;
end;

procedure TContact.Write(S: TBufferedFileStream);
begin
  if (Extra) then
    ExtraRec.Write(S, Size, ExtraSize)
  else
    MainRec.Write(S, Size);
  S.Write(Flags, SizeOf(Flags));
  if (Flags and HasPhone <> 0) then
    Phone.Write(S);
  if (Flags and HasEmail <> 0) then
    Email.Write(S);
end;

procedure TContact.Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  MainRec.Assign(Self.MainRec);
  Extra := ExtraRec.Assign(Self.ExtraRec);
end;

procedure TContact.Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  Assign(MainRec, ExtraRec);

  S.Read(Flags, SizeOf(Flags));
  if (Flags and HasPhone <> 0) then
    Phone.Read(S);
  if (Flags and HasEmail <> 0) then
    Email.Read(S);
end;

function TContact.Size: integer;
begin
  if (Extra) then
    result := SizeOf(ExtraRec)
  else
    result := SizeOf(MainRec);
  result := result + SizeOf(Flags);
  result := result + ExtraSize;
end;

function TContact.ExtraSize: integer;
begin
  result := 0;
  if (Flags and HasPhone <> 0) then
    result := result + Phone.Size;
  if (Flags and HasEmail <> 0) then
    result := result + Email.Size;
end;

// RecordType 13
constructor TImage.Create(AVersion: Word; AGPXMedia: TGPXMedia);
var
  Stream: TBufferedFileStream;
begin
  MainRec.Create(AVersion, $0d);
  Dummy1 := $00;
  ImageSize := AGPXMedia.JpgSize;
  SetLength(Image, ImageSize);
  Stream := TBufferedFileStream.Create(AGPXMedia.JpgFile, fmOpenRead);
  try
    Stream.Read(Image[0], Stream.Size);
  finally
    Stream.Free;
  end;
end;

procedure TImage.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(Dummy1, SizeOf(Dummy1));
  S.Write(ImageSize, SizeOf(ImageSize));
  S.Write(Image[0], Length(Image));
end;

procedure TImage.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TImage.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  Assign(MainRec);

  S.Read(Dummy1, SizeOf(Dummy1));
  S.Read(ImageSize, SizeOf(ImageSize));
  SetLength(Image, ImageSize);
  S.Read(Image[0], Length(Image));
end;

function TImage.Size: integer;
begin
  result := SizeOf(MainRec) + SizeOf(Dummy1) + SizeOf(ImageSize) + Length(Image);
end;

// Recordtype 14
constructor TDescription.Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
begin
  MainRec.Create(AVersion, $0E);
  Unknown16 := 1;
  DescL.Create(GPXWayPoint.Description);
end;

procedure TDescription.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(Unknown16, SizeOf(Unknown16));
  case (Unknown16) of
    6,7:
      Desc.Write(S);
    else
      DescL.Write(S);
  end;
end;

procedure TDescription.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TDescription.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  Assign(MainRec);
  S.Read(Unknown16, SizeOf(Unknown16));
  case (Unknown16) of
    6,7:
      Desc.Read(S);
    else
      DescL.Read(S);
  end;
end;

function TDescription.Size: integer;
begin
  case (Unknown16) of
    6,7:
      result := SizeOf(MainRec) + SizeOf(Unknown16) + Desc.Size;
    else
      result := SizeOf(MainRec) + SizeOf(Unknown16) + DescL.Size;
  end;
end;

// Recordtype 18
constructor TMedia.Create(AVersion: Word; AMedia: TGPXMedia; Simulate: boolean; AExtra: boolean = true);
var
  Stream: TBufferedFileStream;
begin
  Extra := AExtra;
  if (Extra) then
    ExtraRec.Create(AVersion, $0012)
  else
    MainRec.Create(AVersion, $0012);
  MediaId := AMedia.Mp3Id;
  AudioType := $20;    // Custom Audio
  AudioFormat := $01;  // Mp3
  MediaLength := AMedia.Mp3Size;
  SetLength(Media, MediaLength);
  if (not Simulate) then
  begin
    Stream := TBufferedFileStream.Create(AMedia.Mp3File, fmOpenRead);
    try
      Stream.Read(Media[0], Stream.Size);
    finally
      Stream.Free;
    end;
  end;
  Locale := DefLocale;
  TotalLength := SizeOf(Locale) + SizeOf(MediaLength);
end;

procedure TMedia.Write(S: TBufferedFileStream);
begin
  if (Extra) then
    ExtraRec.Write(S, Size, ExtraSize)
  else
    MainRec.Write(S, Size);
  S.Write(MediaId, SizeOf(MediaId));
  S.Write(AudioType, SizeOf(AudioType));
  S.Write(AudioFormat, SizeOf(AudioFormat));
  S.Write(TotalLength, SizeOf(TotalLength));
  S.Write(Locale, SizeOf(Locale));
  S.Write(MediaLength, SizeOf(MediaLength));
  S.Write(Media[0], Length(Media));
end;

procedure TMedia.Assign(MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  MainRec.Assign(Self.MainRec);
  Extra := ExtraRec.Assign(Self.ExtraRec);
end;

procedure TMedia.Read(S: TBufferedFileStream; MainRec: TMainRec; ExtraRec: TExtraRec);
begin
  Assign(MainRec, ExtraRec);

  S.Read(MediaId, SizeOf(MediaId));
  S.Read(AudioType, SizeOf(AudioType));
  S.Read(AudioFormat, SizeOf(AudioFormat));
  S.Read(TotalLength, SizeOf(TotalLength));
  S.Read(Locale, SizeOf(Locale));
  S.Read(MediaLength, SizeOf(MediaLength));
  SetLength(Media, MediaLength);
  S.Read(Media[0], Length(Media));
end;

function TMedia.Size: integer;
begin
  if (Extra) then
    result := SizeOf(ExtraRec)
  else
    result := SizeOf(MainRec);
  result := result +
            SizeOf(MediaId) +
            SizeOf(AudioType) +
            SizeOf(AudioFormat);
  result := result + ExtraSize;
end;

function TMedia.ExtraSize: integer;
begin
  result := 0;
  if (Extra) then
  begin
    result := result +
              SizeOf(TotalLength) +
              SizeOf(Locale) +
              SizeOf(MediaLength) +
              Length(Media);
  end;
end;

// RecordType -1
constructor TEndx.Create(AVersion: Word);
begin
  MainRec.Create(AVersion, $ffff);
end;

procedure TEndx.Write(S: TBufferedFileStream);
begin
  MainRec.Write(S, Size);
end;

function TEndx.Size: integer;
begin
  result := SizeOf(TEndx);
end;

// TGPI
constructor TGPI.Create(AVersion: word; AExtra: boolean = true);
begin
  Version := AVersion;
  Extra := AExtra;
  Header1.Create(AVersion);
  Header2.Create(AVersion);
  Endx.Create(AVersion);
end;

procedure TGPI.WriteHeader(S: TBufferedFileStream);
begin
  Header1.Write(S);
  Header2.Write(S);
end;

function TGPI.CreatePOIGroup(Category: TGPXString): TPOIGroup;
begin
  POIGroup.Create(Version, Category, Extra);
  result := POIGroup;
end;

procedure TGPI.WriteEnd(S: TBufferedFileStream);
begin
  Endx.Write(S);
end;

procedure TGPI.Read(S: TBufferedFileStream; APOIGroupList: TPOIGroupList; ImageDir: string = '');
const
  PoiGroupCat = 'PoiGroup';

  WayPointTypes: set of byte    = [$02,
                                   $03,  // Alert
                                   $04,  // Bitmap ref
                                   $06,  // Category ref
                                   $0a,  // Comment
                                   $0b,  // Address
                                   $0c,  // Contact
                                   $0d,  // Image
                                   $0e]; // Description

  ImageTypes: set of byte       = [$0d]; // Image

  NonWayPointTypes: set of byte = [$05,  // Bitmap
                                   $07,  // Media
                                   $12]; // Category

var
  Header1: THeader1;
  Header2: THeader2;
  MainRec: TMainRec;
  ExtraRec: TExtraRec;
  PoiGroupData: TPOIGroupData;
  PoiGroup: TPOIGroup;
  Area: TArea;
  WayPt: TWayPt;
  CategoryRef: TCategoryRef;
  Category: TCategory;
  Alert: TAlert;
  PoiBitmap: TPoiBitmap;
  PoiBitmapRef: TPoiBitmapRef;
  Comment: TComment;
  Image: TImage;
  Desciption: TDescription;
  Address: TAddress;
  Contact: TContact;
  Media: TMedia;
  BitMap: Vcl.Graphics.TBitmap;
  PNGImage: Vcl.Imaging.pngimage.TPngImage;
  GPXWayPoint: TGPXWayPoint;
  CategoryList: TStringList;
  StartPos: int64;

  procedure ReadHeader(S: TbufferedFileStream);
  begin
    Header1.Read(S);
    Header2.Read(S);
  end;

  procedure AddNonGpxWayPoint(AName: UTF8String);
  var
    NonGPXWayPoint: TGPXWayPoint;
  begin
    NonGPXWayPoint := TGPXWayPoint.Create;
    NonGPXWayPoint.Name := AName;
    NonGPXWayPoint.SelStart[MainRec.RecType] := StartPos;
    NonGPXWayPoint.SelLength[MainRec.RecType] := S.Position - StartPos;
    NonGPXWayPoint.SelStart[0] := NonGPXWayPoint.SelStart[MainRec.RecType];
    NonGPXWayPoint.SelLength[0] := NonGPXWayPoint.SelLength[MainRec.RecType];
    PoiGroupData.Add(NonGPXWayPoint);
  end;

  procedure UpdateCategories;
  var
    AGPXWayPoint: TGPXWayPoint;
  begin
    for AGPXWayPoint in PoiGroupData do
    begin
      // The name of the PoiGroup is also used as a category.
      AGPXWayPoint.PoiGroup := TGPXString(CategoryList.Values[PoiGroupCat]);
      if (AGPXWayPoint.CategoryId > -1) then
        AGPXWayPoint.Category := TGPXString(CategoryList.Values[IntToStr(AGPXWayPoint.CategoryId)]);
    end;
    CategoryList.Clear;
  end;

begin
  ReadHeader(S);
  CategoryList := TStringList.Create;
  APOIGroupList.Clear;
  PoiGroupData := nil;
  GPXWayPoint := nil;

  try
    repeat
      StartPos := S.Position;

      // Update Selection length in previous record
      if (Assigned(GPXWayPoint)) and
         (MainRec.RecType <= High(GPXWayPoint.SelStart)) then
      begin
        if not (MainRec.RecType in NonWayPointTypes) then
          GPXWayPoint.SelLength[MainRec.RecType] := S.Position - GPXWayPoint.SelStart[MainRec.RecType];
        if (MainRec.RecType in WayPointTypes) and
          (S.Position - GPXWayPoint.SelStart[0] > GPXWayPoint.SelLength[0]) then
          GPXWayPoint.SelLength[0] := S.Position - GPXWayPoint.SelStart[0];
      end;

      MainRec.Read(S, ExtraRec);

      // New GPX WayPoint
      if (MainRec.RecType = $02) then
      begin
        GPXWayPoint := TGPXWayPoint.Create;
        PoiGroupData.Add(GPXWayPoint);

        GPXWayPoint.PoiId := PoiGroupData.Id;
        GPXWayPoint.SelStart[0] := StartPos;
        GPXWayPoint.SelLength[0] := 0;
      end;

      // Init selection position of new GPX WayPoint.
      if (Assigned(GPXWayPoint)) and
         (MainRec.RecType in WayPointTypes) then
      begin
        if not (MainRec.RecType in ImageTypes) or
           ((MainRec.RecType in ImageTypes) and
            (GPXWayPoint.ImageCnt = 0)) then
          GPXWayPoint.SelStart[MainRec.RecType] := StartPos;
        GPXWayPoint.SelLength[MainRec.RecType] := 0;
      end;

      case MainRec.RecType of
        $02: // Waypoint
          begin
            WayPt.Read(S, MainRec, ExtraRec);
            GPXWayPoint.Name := ConvertToUtf8(WayPt.Name, Header2.CodePage);
            GPXWayPoint.Lat := Coord2Str(WayPt.Lat);
            GPXWayPoint.Lon := Coord2Str(WayPt.Lon);
            continue;
          end;
        $03: // Alert
          begin
            Alert.Read(S, MainRec);
            GPXWayPoint.Proximity := Alert.Proximity;
            GPXWayPoint.Speed := Round((Alert.Speed * 60 * 60) / 1000 / 100);
            GPXWayPoint.AlertType := Alert.AlertType;
            GPXWayPoint.SoundNbr := Alert.SoundNbr;
            GPXWayPoint.AudioAlert := Alert.AudioAlert;
            continue;
          end;
        $04: // BitmapRef
          begin
            PoiBitmapRef.Read(S, MainRec);
            GPXWayPoint.BitmapId := PoiBitmapRef.Id;
            continue;
          end;
        $05: // Bitmap
          begin
            PoiBitmap.Read(S, MainRec);
            if (ImageDir <> '') then
            begin
              Bitmap := PoiBitmap.Bitmap;
              try
                PNGImage := TPngImage.Create;
                try
                  PNGImage.Assign(BitMap);
                  PNGImage.TransparentColor := PoiBitmap.TranspCol;
                  PNGImage.SaveToFile(Format(IncludeTrailingPathDelimiter(ImageDir) + '%d_%d.png',
                                             [PoiGroupData.Id, PoiBitmap.Id]));
                finally
                  PNGImage.Free;
                end;
              finally
                Bitmap.Free;
              end;
            end;
            AddNonGpxWayPoint(UTF8string(Format('Bitmap: %d_%d', [PoiGroupData.Id, PoiBitmap.Id])));
            continue;
          end;
        $06: // CategoryRef
          begin
            CategoryRef.Read(S, MainRec);
            GPXWayPoint.CategoryId := CategoryRef.Id;
            continue;
          end;
        $07: // Category
          begin
            Category.Read(S, MainRec);
            CategoryList.AddPair(IntToStr(Category.Id), ConvertToString(Category.Name, Header2.CodePage));
            AddNonGpxWayPoint(UTF8string(Format('Category: %s', [ConvertToString(Category.Name, Header2.CodePage)])));
            continue;
          end;
        $08: // Area
          begin
            Area.Read(S, ExtraRec);
            if (Assigned(PoiGroupData)) then
              PoiGroupData.SelLengthArea := S.Position - PoiGroupData.SelStartArea;
            continue;
          end;
        $09: // PoiGroup
          begin
            if (Assigned(PoiGroupData)) then
              UpdateCategories;
            PoiGroup.Read(S, MainRec, ExtraRec);
            PoiGroupData := TPOIGroupData.Create;
            PoiGroupData.SelStart := StartPos;
            if (PoiGroup.Extra) then
              PoiGroupData.SelLength := ExtraRec.TotalLength + SizeOf(ExtraRec)
            else
              PoiGroupData.SelLength := MainRec.Length + SizeOf(MainRec);
            PoiGroupData.SelStartArea := S.Position;
            PoiGroupData.Name := ConvertToUtf8(PoiGroup.Name, Header2.CodePage);
            PoiGroupData.Id := APOIGroupList.Count;
            APOIGroupList.Add(PoiGroupData);
            CategoryList.AddPair(PoiGroupCat, ConvertToString(PoiGroup.Name, Header2.CodePage));
            continue;
          end;
        $0a: // Comment
          begin
            Comment.Read(S, MainRec);
            GPXWayPoint.Comment := ConvertToUtf8(Comment.Comment, Header2.CodePage);
            continue;
          end;
        $0b: // Address
          begin
            Address.Read(S, MainRec, ExtraRec);
            GPXWayPoint.Country := ConvertToUtf8(Address.Country, Header2.CodePage);
            GPXWayPoint.State := ConvertToUtf8(Address.State, Header2.CodePage);
            GPXWayPoint.PostalCode := ConvertToUtf8(Address.PostalCode, Header2.CodePage);
            GPXWayPoint.City := ConvertToUtf8(Address.City, Header2.CodePage);
            GPXWayPoint.Street := ConvertToUtf8(Address.Street, Header2.CodePage);
            GPXWayPoint.HouseNbr := ConvertToUtf8(Address.HouseNbr, Header2.CodePage);
            continue;
          end;
        $0c: // COntact
          begin
            Contact.Read(S, MainRec, ExtraRec);
            GPXWayPoint.Phone := ConvertToUtf8(Contact.Phone, Header2.CodePage);
            GPXWayPoint.Email := ConvertToUtf8(Contact.Email, Header2.CodePage);
            continue;
          end;
        $0d: // Image
          begin
            Image.Read(S, MainRec);
            GPXWayPoint.ImageCnt := GPXWayPoint.ImageCnt + 1;
            continue;
          end;
        $0e: // Description
          begin
            Desciption.Read(S, MainRec);
            case (Desciption.Unknown16) of
              6,7:
                GPXWayPoint.Description := ConvertToUtf8(Desciption.Desc, Header2.CodePage);
              else
                GPXWayPoint.Description := ConvertToUtf8(Desciption.DescL, Header2.CodePage);
            end;
            continue;
          end;
        $12: // Media
          begin
            Media.Read(S, MainRec, Extrarec);
            AddNonGpxWayPoint(TGPXString(Format('MediaId %d', [Media.MediaId])));
            continue;
          end;
        $ffff:
          break;
        else
          // Unknown Type
      end;

      if (MainRec.Length = 0) or
         (S.Position + MainRec.Length > S.Size) then
        break;

      S.Seek(MainRec.Length, TSeekOrigin.soCurrent);

    until (false);

    if (Assigned(PoiGroupData)) then
      UpdateCategories;

  finally
    CategoryList.Free;
  end;
end;

procedure TGPI.SaveGpx(const GPXFile: string; const APOIGroupList: TPOIGroupList; const SymbolCat: string);
var
  Xml: TXmlVSDocument;
  XMLRoot, AWpt, AExtensions, AAddress, ACategories: TXmlVSNode;
  APOIGroupData: TPOIGroupData;
  AWayPt: TGPXWayPoint;
  Symbol, Category: string;
begin
  XML := TXmlVSDocument.Create;
  try
    XMLRoot := InitGarminGpx(XML);
    for APOIGroupData in APOIGroupList do
    begin
      for AWayPt in APOIGroupData do
      begin
        if (AWayPt.Lat = '') or
           (AWayPt.Lon = '') then
          continue;

        AWpt := XMLRoot.AddChild('wpt');
        Awpt.AttributeList.Add('lat').Value := string(AWayPt.Lat);
        Awpt.AttributeList.Add('lon').Value := string(AWayPt.Lon);
        AWpt.AddChild('time').NodeValue := DateToISO8601(TTimezone.Local.ToUniversalTime(Now), true);
        AWpt.AddChild('name').NodeValue := string(AWayPt.Name);
        AWpt.AddChild('cmt').NodeValue := string(AWayPt.Comment);
        AWpt.AddChild('desc').NodeValue := string(AWayPt.Comment);
        Category := string(AWayPt.Category);
        Symbol := NextField(Category, ':');
        if (SameText(Symbol, SymbolCat)) then
          AWpt.AddChild('sym').NodeValue := Category
        else
          AWpt.AddChild('sym').NodeValue := IntToStr(AWayPt.BitmapId);
        AWpt.AddChild('type').NodeValue := 'user';
        AExtensions := AWpt.AddChild('extensions').AddChild('gpxx:WaypointExtension');
        if (AWayPt.Proximity <> 0) then
          AExtensions.AddChild('gpxx:Proximity').NodeValue := IntToStr(AWayPt.Proximity);
        AExtensions.AddChild('gpxx:DisplayMode').NodeValue := 'SymbolAndName';
        ACategories := AExtensions.AddChild('gpxx:Categories');
        ACategories.AddChild('gpxx:Category').NodeValue := string(APOIGroupData.Name);
        ACategories.AddChild('gpxx:Category').NodeValue := string(AWayPt.Category);
        AAddress := AExtensions.AddChild('gpxx:Address');
        AAddress.AddChild('gpxx:StreetAddress').NodeValue := string(AWayPt.Street);
        AAddress.AddChild('gpxx:City').NodeValue := string(AWayPt.City);
        AAddress.AddChild('gpxx:State').NodeValue := string(AWayPt.State);
        AAddress.AddChild('gpxx:Country').NodeValue := string(AWayPt.Country);
        AAddress.AddChild('gpxx:PostalCode').NodeValue := string(AWayPt.PostalCode);
        AExtensions.AddChild('gpxx:PhoneNumber').NodeValue := string(AWayPt.Phone);
      end;
    end;

    XML.SaveToFile(GPXFile);
  finally
    Xml.Free;
  end;
end;

initialization
  FormatSettings := GetLocaleSetting;

end.
