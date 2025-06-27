unit UnitGpi;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  System.Classes, System.Types, System.SysUtils, System.AnsiStrings, System.DateUtils, System.Generics.Collections,
  Vcl.Dialogs, Vcl.Graphics, UnitBmp;

type
  TGPXString = UTF8String;

const
  GpiName: TGPXString         = 'my.gpi';
  GpiVersion: Word            = 0;
  DefTransparentColor: DWORD  = $00ff00ff;
  DefGpiSymbolsDir            = 'Symbols\24x24\';
  Reg_GPISymbolSize           = 'GPISymbolsSize';
  Reg_GPIProximity            = 'GPIProximity';

type

  TGPXWayPoint = class
    Name: TGPXString;
    Lat:  TGPXString;
    Lon:  TGPXString;
    Symbol: TGPXString;
    Phone: TGPXString;
    Email: TGPXString;
    Comment: TGPXString;
    Country: TGPXString;
    State: TGPXString;
    PostalCode: TGPXString;
    City: TGPXString;
    Street: TGPXString;
    HouseNbr: TGPXString;
    Category: TGPXString;
    Speed: Word;
    Proximity: Word;
    BitmapId: integer;
    CategoryId: integer;
    SelStart: int64;
    SelLength: int64;
    constructor Create;
    destructor Destroy; override;
  end;
  TPOIList = TObjectlist<TGPXWayPoint>;

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
    constructor Create(SymbolsDir: TGPXString = DefGpiSymbolsDir);
    destructor Destroy; override;
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
    MainRec:  TMainRec;
    Id:       SmallInt;
    constructor Create(AVersion: Word; AId: SmallInt);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

  TCategory = packed record
    MainRec:  TMainRec;
    Id:       SmallInt;
    Name:     TPLString;
    constructor Create(AVersion: Word; GPXCategory: TGPXCategory);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

  TPoiBitmapRef = packed record
    MainRec:  TMainRec;
    Id:       SmallInt;
    constructor Create(AVersion: Word; AId: SmallInt);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

  TPoiBitmap = packed record
    MainRec:  TMainRec;
    Id:       SmallInt;
    Height:   SmallInt;
    Width:    SmallInt;
    LineSize: SmallInt;
    BPP:      SmallInt;
    Dummy1:   SmallInt;
    ImageSize:DWord;
    Dummy2:   DWord;
    CntColPat:DWord;
    TranspCol:DWord;
    Flags2:   DWord;
    Dummy3:   DWord;
    ScanLines:array of byte;
    ColPat:   array of byte;
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
    MainRec:    TMainRec;
    Flags:      Word;
    City:       TPLString;
    Country:    TPLString;
    State:      TPLString;
    PostalCode: TPString;
    Street:     TPLString;
    HouseNbr:   TPString;
    constructor Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(MainRec: TMainRec);
    procedure Read(S: TBufferedFileStream; MainRec: TMainRec);
    function Size: integer;
  end;

  TContact = packed record
    MainRec:    TMainRec;
    Flags:      Word;
    Phone:      TPString;
    Email:      TPString;
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
    Contact:    TContact;
    Address:    TAddress;
    constructor Create(AVersion: Word; GPXWayPoint: TGPXWayPoint; AExtra: boolean);
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
    constructor Create(AVersion: Word; AExtra: boolean);
    procedure AddWpt(GPXWayPt: TGPXWayPoint);
    procedure Write(S: TBufferedFileStream);
    procedure Assign(ExtraRec: TExtraRec);
    procedure Read(S: TBufferedFileStream; ExtraRec: TExtraRec);
    function Size: integer;
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
    Categories: TObjectlist<TGPXCategory>; // Internal variable, dont write
    BitMaps: TObjectlist<TGPXBitmap>; // Internal variable, dont write
    constructor Create(AVersion: Word; AName: TGPXString; AExtra: boolean = true);
    procedure AddWpt(GPXWayPt: TGPXWayPoint);
    function AddCat(GPXCategory: TGPXCategory): integer;
    function AddBmp(GPXBitMap: TGPXBitMap): integer;
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
    procedure Read(S: TBufferedFileStream; APOIList: TPOIList; ImageDir: string = '');
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
  System.Math,
  System.WideStrUtils,
  Winapi.Windows,
  Vcl.Imaging.pngimage,
  UnitStringUtils;

const
  Coord_Decimals = '%1.6f';

var
  FormatSettings: TFormatSettings;

// Need separate class
constructor TGPXWayPoint.Create;
begin
  BitmapId := -1;
  CategoryId := -1;
  Proximity := 0;
  Speed := 0;
  inherited;
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
  Category := '';
  inherited;
end;

constructor TGPXBitmap.Create(SymbolsDir: TGPXString = DefGpiSymbolsDir);
begin
  GpiSymbolsDir := SymbolsDir;
  inherited Create;
end;

destructor TGPXBitmap.Destroy;
begin
  Bitmap := '';
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
var HCoord: Double;
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
var HCoord: Double;
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
  LChars := length(AChars);
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
  Country := 'EN';
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
  FillChar(ExtraRec, SizeOf(ExtraRec), 0);

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
constructor TWayPt.Create(AVersion: Word; GPXWayPoint: TGPXWayPoint; AExtra: boolean);
begin
  Extra := AExtra;
  if (Extra) then
    ExtraRec.Create(AVersion, $0002)
  else
    MainRec.Create(AVersion, $0002);

  Name.Create(GPXWayPoint.Name);
  Lat := Str2Coord(GPXWayPoint.Lat);
  Lon := Str2Coord(GPXWayPoint.Lon);
  Dummy1 := 1;
  HasAlert := 0;
  if (Extra) then
  begin
    CategoryRef.Create(AVersion, GPXWayPoint.CategoryId); // Can be -1
    BitmapRef.Create(AVersion, GPXWayPoint.BitmapId);     // Can be -1
    Alert.Create(AVersion, GPXWayPoint);
    if (Alert.Proximity > 0) or
       (Alert.Speed > 0) then
       HasAlert := $0001;
    Comment.Create(AVersion, GPXWayPoint);
    Contact.Create(AVersion, GPXWayPoint);
    Address.Create(AVersion, GPXWayPoint)
  end;
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
    if (Contact.Flags <> 0) then
      Contact.Write(S);
    if (Address.Flags <> 0) then
      Address.Write(S);
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
  S.Read(Dummy1, Sizeof(Dummy1));
  S.Read(HasAlert, Sizeof(HasAlert));
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
    if (Contact.Flags <> 0) then
      result := result + Contact.Size;
    if (Address.Flags <> 0) then
      result := result + Address.Size;
  end;
end;

// Recordtype 3
constructor TAlert.Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
var MPS: double;
begin
  MainRec.Create(AVersion, $0003);
  Proximity := GPXWayPoint.Proximity;
  MPS := (GPXWayPoint.Speed * 1000) / (60 * 60);
  Speed := Round(MPS * 100);
  Dummy1 := $0100;
  Dummy2 := $0100;
  Alert := 1;
  AlertType := 1;
  SoundNbr := 0;
  if (Proximity > 0) then
    SoundNbr := 4
  else
    if (Speed > 0) then
      SoundNbr := 5;
  AudioAlert := $10;
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
      BitMapRd.Load(TGPXString(
                      string(GPXBitMap.GpiSymbolsDir) +
                      ChangeFileExt(
                        StringReplace(string(GPXBitMap.Bitmap), '/', '_', [rfReplaceAll]),
                        '.bmp')));
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
constructor TArea.Create(AVersion: Word; AExtra: boolean);
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
end;

procedure TArea.AddWpt(GPXWayPt: TGPXWayPoint);
var WayPt: TWayPt;
begin
  WayPt.Create(GPIVersion, GPXWayPt, Extra);  // Just temporary, to calculate
  ExtraSize := ExtraSize + WayPt.Size;        // If waypoint has extra records like area, this is computed
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
var GPXWayPt: TGPXWayPoint;
    WayPt: TWayPt;
begin
  ExtraRec.Write(S, Size, ExtraSize);
  S.Write(MaxLat, SizeOf(MaxLat));
  S.Write(MaxLon, SizeOf(MaxLon));
  S.Write(MinLat, SizeOf(MinLat));
  S.Write(MinLon, SizeOf(MinLon));
  S.Write(Dummy1, Sizeof(Dummy1));
  S.Write(Dummy2, Sizeof(Dummy2));
  S.Write(Alert, Sizeof(Alert));
  for GPXWayPt in WayPts do
  begin
    WayPt.Create(GPIVersion, GPXWayPt, Extra);
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
  Area.Create(GPIVersion, Extra);
  if (Extra) then
  begin
    ExtraRec.Create(AVersion, $09);
    Categories := TObjectlist<TGPXCategory>.Create(true);
    BitMaps := TObjectlist<TGPXBitmap>.Create(true);
  end
  else
    MainRec.Create(AVersion, $09); // Length will be recalculated by adding wpt
end;

procedure TPOIGroup.AddWpt(GPXWayPt: TGPXWayPoint);
begin
  Area.AddWpt(GPXWayPt);
end;

function TPOIGroup.AddCat(GPXCategory: TGPXCategory): integer;
var Category: TCategory;
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
var BitMap: TPoiBitMap;
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

procedure TPOIGroup.Write(S: TBufferedFileStream);
var GPXCategory: TGPXCategory;
    Category: TCategory;
    GPXBitMap: TGPXBitMap;
    PoiBitMap: TPoiBitMap;
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
constructor TAddress.Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
begin
  MainRec.Create(AVersion, $0b);
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

procedure TAddress.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TAddress.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  Assign(MainRec);

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
  result := SizeOf(MainRec) +  SizeOf(Flags);
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
constructor TContact.Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
begin
  MainRec.Create(AVersion, $0c);
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
  MainRec.Write(S, Size);
  S.Write(Flags, SizeOf(Flags));
  if (Flags and HasPhone <> 0) then
    Phone.Write(S);
  if (Flags and HasEmail <> 0) then
    Email.Write(S);
end;

procedure TContact.Assign(MainRec: TMainRec);
begin
  MainRec.Assign(Self.MainRec);
end;

procedure TContact.Read(S: TBufferedFileStream; MainRec: TMainRec);
begin
  Assign(MainRec);

  S.Read(Flags, SizeOf(Flags));
  if (Flags and HasPhone <> 0) then
    Phone.Read(S);
  if (Flags and HasEmail <> 0) then
    Email.Read(S);
end;

function TContact.Size: integer;
begin
  result := SizeOf(MainRec) +  SizeOf(Flags);
  if (Flags and HasPhone <> 0) then
    result := result + Phone.Size;
  if (Flags and HasEmail <> 0) then
    result := result + Email.Size;
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

procedure TGPI.Read(S: TBufferedFileStream; APOIList: TPOIList; ImageDir: string = '');
var
  Header1: THeader1;
  Header2: THeader2;
  MainRec: TMainRec;
  ExtraRec: TExtraRec;
  PoiGroup: TPOIGroup;
  Area: TArea;
  WayPt: TWayPt;
  CategoryRef: TCategoryRef;
  Category: TCategory;
  Alert: TAlert;
  PoiBitmap: TPoiBitmap;
  PoiBitmapRef: TPoiBitmapRef;
  Comment: TComment;
  Address: TAddress;
  Contact: TContact;
  BitMap: Vcl.Graphics.TBitmap;
  PNGImage: Vcl.Imaging.pngimage.TPngImage;
  GPXWayPoint: TGPXWayPoint;
  CategoryList: TStringList;
  BitMapList: TList;
  StartPos: int64;

  procedure ReadHeader(S: TbufferedFileStream);
  begin
    Header1.Read(S);
    Header2.Read(S);
  end;

begin
  ReadHeader(S);
  CategoryList := TStringList.Create;
  BitMapList := TList.Create;
  APOIList.Clear;
  GPXWayPoint := nil;

  try
    repeat
      StartPos := S.Position;
      MainRec.Read(S, ExtraRec);
      case MainRec.RecType of
        $02:
          begin
            GPXWayPoint := TGPXWayPoint.Create;
            APOIList.Add(GPXWayPoint);
            GPXWayPoint.SelStart := StartPos;

            WayPt.Read(S, MainRec, ExtraRec);
            GPXWayPoint.Name := ConvertToUtf8(WayPt.Name, Header2.CodePage);
            GPXWayPoint.Lat := Coord2Str(WayPt.Lat);
            GPXWayPoint.Lon := Coord2Str(WayPt.Lon);
            continue;
          end;
        $03:
          begin
            Alert.Read(S, MainRec);
            GPXWayPoint.SelLength := S.Position - GPXWayPoint.SelStart;
            GPXWayPoint.Proximity := Alert.Proximity;
            GPXWayPoint.Speed := Round((Alert.Speed * 60 * 60) / 1000 / 100);
            continue;
          end;
        $04:
          begin
            PoiBitmapRef.Read(S, MainRec);
            GPXWayPoint.SelLength := S.Position - GPXWayPoint.SelStart;
            GPXWayPoint.Symbol := TGPXString(IntToStr(PoiBitmapRef.Id));
            continue;
          end;
        $05:
          begin
            PoiBitmap.Read(S, MainRec);

            if (ImageDir <> '') and
               (BitMapList.IndexOf(Pointer(PoiBitmap.Id)) = -1) then
            begin
              BitMapList.Add(Pointer(PoiBitmap.Id));
              Bitmap := PoiBitmap.Bitmap;
              try
                PNGImage := TPngImage.Create;
                try
                  PNGImage.Assign(BitMap);
                  PNGImage.TransparentColor := PoiBitmap.TranspCol;
                  PNGImage.SaveToFile(Format(IncludeTrailingPathDelimiter(ImageDir) + '%d.png', [PoiBitmap.Id]));
                finally
                  PNGImage.Free;
                end;
              finally
                Bitmap.Free;
              end;
            end;

            continue;
          end;
        $06:
          begin
            CategoryRef.Read(S, MainRec);
            GPXWayPoint.SelLength := S.Position - GPXWayPoint.SelStart;
            GPXWayPoint.CategoryId := CategoryRef.Id;
            continue;
          end;
        $07:
          begin
            Category.Read(S, MainRec);
            CategoryList.AddPair(IntToStr(Category.Id), ConvertToString(Category.Name, Header2.CodePage));
            continue;
          end;
        $08:
          begin
            Area.Read(S, ExtraRec);
            continue;
          end;
        $09:
          begin
            PoiGroup.Read(S, MainRec, ExtraRec);
            continue;
          end;
        $0a:
          begin
            Comment.Read(S, MainRec);
            GPXWayPoint.SelLength := S.Position - GPXWayPoint.SelStart;
            GPXWayPoint.Comment := ConvertToUtf8(Comment.Comment, Header2.CodePage);
            continue;
          end;
        $0b:
          begin
            Address.Read(S, MainRec);
            GPXWayPoint.SelLength := S.Position - GPXWayPoint.SelStart;
            GPXWayPoint.Country := ConvertToUtf8(Address.Country, Header2.CodePage);
            GPXWayPoint.State := ConvertToUtf8(Address.State, Header2.CodePage);
            GPXWayPoint.PostalCode := ConvertToUtf8(Address.PostalCode, Header2.CodePage);
            GPXWayPoint.City := ConvertToUtf8(Address.City, Header2.CodePage);
            GPXWayPoint.HouseNbr := ConvertToUtf8(Address.HouseNbr, Header2.CodePage);
            continue;
          end;
        $0c:
          begin
            Contact.Read(S, MainRec);
            GPXWayPoint.SelLength := S.Position - GPXWayPoint.SelStart;
            GPXWayPoint.Phone := ConvertToUtf8(Contact.Phone, Header2.CodePage);
            GPXWayPoint.Email := ConvertToUtf8(Contact.Email, Header2.CodePage);
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

    for GPXWayPoint in APOIList do
    begin
      if (GPXWayPoint.CategoryId > -1) then
        GPXWayPoint.Category := TGPXString(CategoryList.Values[IntToStr(GPXWayPoint.CategoryId)]);
    end;
  finally
    CategoryList.Free;
    BitMapList.Free;
  end;
end;

initialization
  FormatSettings := GetLocaleSetting;

end.


