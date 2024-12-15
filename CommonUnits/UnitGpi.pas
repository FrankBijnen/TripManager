unit UnitGpi;
interface

uses
  System.Classes, System.Types, System.SysUtils, System.AnsiStrings, System.DateUtils, System.Generics.Collections,
  Vcl.Dialogs, UnitBmp;

type
  TGPXString = UTF8String;

const GpiName: TGPXString = 'my.gpi';
      GpiVersion: Word = 0;
      GpiSymbolsDir: TGPXString = 'Symbols\24x24\';
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
    Speed: Word;
    Proximity: Word;
    BitmapId: integer;
    CategoryId: integer;
    constructor Create;
    destructor Destroy; override;
  end;

  TGPXCategory = class
    Category: TGPXString;
    CategoryId: Word;
    constructor Create;
    destructor Destroy; override;
  end;

  TGPXBitmap = class
    Bitmap: TGPXString;
    BitmapId: Word;
    constructor Create;
    destructor Destroy; override;
  end;

  TPString = packed record
    LChars:     Word;
    Chars:      array of AnsiChar;
    constructor Create(AChars: TGPXString);
    procedure Write(S: TFileStream);
    function Size: integer;
  end;

  TPLString = packed record
    LCountry:   DWord;
    Country:    array[0..1] of AnsiChar;
    LChars:     Word;
    Chars:      array of AnsiChar;
    constructor Create(AChars: TGPXString);
    procedure Write(S: TFileStream);
    function Size: integer;
  end;

  TMainRec = packed record
    RecType:    Word;
    Flags:      Word;
    Length:     DWord;
    constructor Create(AVersion, ARecType: Word);
    procedure Write(S: TFileStream; ALength: Dword);
  end;

  TExtraRec = packed record
    RecType:    Word;
    Flags:      Word;
    TotalLength:DWord;
    MainLength: DWord;
    constructor Create(AVersion, ARecType: Word);
    procedure Write(S: TFileStream; ATotalLength, AExtra: Dword);
  end;

  TCategoryRef = packed record
    MainRec:  TMainRec;
    Id:       SmallInt;
    constructor Create(AVersion: Word; AId: SmallInt);
    procedure Write(S: TFileStream);
    function Size: integer;
  end;

  TCategory = packed record
    MainRec:  TMainRec;
    Id:       SmallInt;
    Name:     TPLString;
    constructor Create(AVersion: Word; GPXCategory: TGPXCategory);
    procedure Write(S: TFileStream);
    function Size: integer;
  end;

  TPoiBitmapRef = packed record
    MainRec:  TMainRec;
    Id:       SmallInt;
    constructor Create(AVersion: Word; AId: SmallInt);
    procedure Write(S: TFileStream);
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
    procedure Write(S: TFileStream);
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
    procedure Write(S: TFileStream);
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
    procedure Write(S: TFileStream);
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
    procedure Write(S: TFileStream);
  end;

  TComment = packed record
    MainRec:    TMainRec;
    Comment:    TPLString;
    constructor Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
    procedure Write(S: TFileStream);
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
    procedure Write(S: TFileStream);
    function Size: integer;
  end;

  TContact = packed record
    MainRec:    TMainRec;
    Flags:      Word;
    Phone:      TPString;
    Email:      TPString;
    constructor Create(AVersion: Word; GPXWayPoint: TGPXWayPoint);
    procedure Write(S: TFileStream);
    function Size: integer;
  end;
// Until here

  TWayPt = packed record
    Extra:      boolean;
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
    procedure Write(S: TFileStream);
    function Size: integer;
    function ExtraSize: integer;
  end;

  TArea = packed record
    Extra:      boolean;
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
    procedure Write(S: TFileStream);
    function Size: integer;
  end;

  TEndx = packed record
    MainRec:    TMainRec;
    constructor Create(AVersion: Word);
    procedure Write(S: TFileStream);
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
    procedure Write(S: TFileStream);
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
    procedure WriteHeader(S: TFileStream);
    function CreatePOIGroup(Category: TGPXString): TPOIGroup;
    procedure WriteEnd(S: TFileStream);
  end;

const HasPhone:   Word = $0001;
      HasEmail:   Word = $0008;
      HasCity:    Word = $0001;
      HasCountry: Word = $0002;
      HasState:   Word = $0004;
      HasPostal:  Word = $0008;
      HasStreet:  Word = $0010;
      HasHouseNbr:Word = $0020;

var FormatSettings: TFormatSettings;

implementation

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

constructor TGPXBitmap.Create;
begin
  inherited;
end;

destructor TGPXBitmap.Destroy;
begin
  Bitmap := '';
  inherited;
end;

//TODO: Correctly handle UTF8 strings
function UTF8PCopy(Dest: PAnsiChar; const Source: AnsiString): PAnsiChar;
begin
  result := System.AnsiStrings.StrPCopy(Dest, Source);
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

constructor TPString.Create(AChars: TGPXString);
begin
  LChars := length(AChars);
  SetLength(Chars, LChars);
  Move(Achars[1], Chars[0], LChars);
end;

procedure TPString.Write(S: TFileStream);
begin
  S.Write(LChars, SizeOf(LChars));
  S.Write(Chars[0], LChars);
end;

function TPString.Size: Integer;
begin
  result := LChars + SizeOf(LChars);
end;

constructor TPLString.Create(AChars: TGPXString);
begin
  LCountry := SizeOf(LChars) + length(AChars) +  SizeOf(Country);
  UTF8PCopy(Country, 'EN');
  LChars := length(AChars);
  SetLength(Chars, LChars);
  Move(Achars[1], Chars[0], LChars);
end;

procedure TPLString.Write(S: TFileStream);
begin
  S.Write(LCountry, SizeOf(LCountry));
  S.Write(Country[0], SizeOf(Country));
  S.Write(LChars, SizeOf(LChars));
  S.Write(Chars[0], LChars);
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

procedure TMainRec.Write(S: TFileStream; ALength: Dword);
begin
  Length := ALength - SizeOf(Self);
  S.Write(Self, SizeOf(Self));
end;

constructor TExtraRec.Create(AVersion, ARecType: Word);
begin
  RecType := ARecType;
  Flags := $0008;
  MainLength := 0;
  TotalLength := 0;
end;

procedure TExtraRec.Write(S: TFileStream; ATotalLength, AExtra: Dword);
begin
  TotalLength := ATotalLength - SizeOf(Self);
  MainLength := TotalLength - AExtra;
  S.Write(Self, SizeOf(Self));
end;

// Recordtype 0
constructor THeader1.Create(AVersion: Word);
begin
  MainRec.Create(AVersion, $0000);
  UTF8PCopy(GrmRec, 'GRMREC');
  UTF8PCopy(Version, '00');
  TimeStamp := GetTimeStamp;
  Flag1 := $00;
  Flag2 := $00;
  Name.Create(GpiName);
end;

procedure THeader1.Write(S: TFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(GrmRec, SizeOf(Grmrec));
  S.Write(Version, SizeOf(Version));
  S.Write(TimeStamp, SizeOf(TimeStamp));
  S.Write(Flag1, SizeOf(Flag1));
  S.Write(Flag2, SizeOf(Flag2));
  Name.Write(S);
end;

function THeader1.Size: integer;
begin
  result := Sizeof(THeader1) - SizeOf(Name) + Name.Size;
end;

// Recordtype 1
constructor THeader2.Create(AVersion: Word);
begin
  MainRec.Create(AVersion, $0001);
  UTF8PCopy(PoiRec, 'POI');
  Dummy := $0000;
  UTF8PCopy(Version, '00');
  CodePage := $FDE9;          // UTF8
  CopyRight := $0000;
end;

procedure THeader2.Write(S: TFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(PoiRec, SizeOf(PoiRec));
  S.Write(Dummy, SizeOf(Dummy));
  S.Write(Version, SizeOf(Version));
  S.Write(CodePage, SizeOf(CodePage));
  S.Write(CopyRight, SizeOf(CopyRight));
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

procedure TWayPt.Write(S: TFileStream);
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

procedure TAlert.Write(S: TFileStream);
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

// Recordtype 4
constructor TPoiBitmapRef.Create(AVersion: Word; AId: SmallInt);
begin
  MainRec.Create(AVersion, $0004);
  Id := Aid;
end;

procedure TPoiBitmapRef.Write(S: TFileStream);
begin
  MainRec.Write(S, size);
  S.Write(Id, SizeOf(Id));
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

  try
    try
      BitMapRd := TBitMapReader.Create(TGPXString(
                      string(GpiSymbolsDir) +
                      ChangeFileExt(
                        StringReplace(String(GPXBitMap.Bitmap), '/', '_', [rfReplaceAll]),
                        '.bmp')));
    except on e:Exception do
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
      Dummy2 := 44;                 // ???
      CntColPat := PalCount;
      TranspCol := $00ff00ff;       // Magenta
      Flags2 := $0001;              // Transparent
      Dummy3 := ImageSize + Dummy2; // ???
    end;
    SetLength(ColPat, length(BitMapRd.ColPat));
    move(BitMapRd.ColPat[0], ColPat[0], length(BitMapRd.ColPat));
    SetLength(ScanLines, length(BitMapRd.ScanLines));
    move(BitMapRd.ScanLines[0], ScanLines[0], length(BitMapRd.ScanLines));
  finally
    BitMapRd.Free;
  end;
end;

procedure TPoiBitMap.Write(S: TFileStream);
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

procedure TCategoryRef.Write(S: TFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(Id, Sizeof(Id));
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

procedure TCategory.Write(S: TFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(Id, Sizeof(Id));
  Name.Write(S);
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
  WayPt.Create(GPIVersion, GPXWayPt, Extra); // Just temporary, to calculate
  ExtraSize := ExtraSize + WayPt.Size;    // If waypoint has extra records like area, this is computed
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

procedure TArea.Write(S: TFileStream);
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

procedure TPOIGroup.Write(S: TFileStream);
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

procedure TComment.Write(S: TFileStream);
begin
  MainRec.Write(S, Size);
  Comment.Write(S);
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

procedure TAddress.Write(S: TFileStream);
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

procedure TContact.Write(S: TFileStream);
begin
  MainRec.Write(S, Size);
  S.Write(Flags, SizeOf(Flags));
  if (Flags and HasPhone <> 0) then
    Phone.Write(S);
  if (Flags and HasEmail <> 0) then
    Email.Write(S);
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

procedure TEndx.Write(S: TFileStream);
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

procedure TGPI.WriteHeader(S: TFileStream);
begin
  Header1.Write(S);
  Header2.Write(S);
end;

function TGPI.CreatePOIGroup(Category: TGPXString): TPOIGroup;
begin
  POIGroup.Create(Version, Category, Extra);
  result := POIGroup;
end;

procedure TGPI.WriteEnd(S: TFileStream);
begin
  Endx.Write(S);
end;

end.
