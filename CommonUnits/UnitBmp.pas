unit UnitBmp;

interface

uses
  WinApi.Windows, System.Classes, System.Types, System.SysUtils, Vcl.Graphics,
  Vcl.Dialogs;

type

  TBitmapFileHeader = packed record
    bmfIdentifier: array[0..1] of AnsiChar; {'BM'}
    bmfFileSize: dWord;
    bmfReserved: dWord;
    bmfBitMapDataOffset: dWord;             {from begin of file}
  end;

  {followed by the bitmapinfoheader}
  TBitmapInfoHeader = packed record
    biSize: integer;                        {size of tbitmapinfoheader}
    biWidth: integer;                       {bitmap width}
    biHeight: integer;                      {height of bitmap}
    biPlanes: Word;                         {always 1}
    biBitCount: Word;                       {number color bits 4 = 16 colors, 8 = 256 pixel is a byte}
    biCompression: integer;                 {compression used, 0 }
    biSizeImage: integer;                   {size of the pixel data}
    biXPelsPerMeter: integer;               {not used, 0 }
    biYPelsPerMeter: integer;               {not used, 0 }
    biClrUsed: integer;                     {number of colors used, set to 0 }
    biClrImportant: integer;                {important colors, set to 0 }
  end;
  {followed by the palette data}

  TBitMapReader = class
  public
    BitmapFileHeader: TBitmapFileHeader;
    BitmapInfoHeader: TBitmapInfoHeader;
    ColPat: array of byte;
    ScanLines: array of byte;
    constructor Create;
    destructor Destroy; override;
    procedure Load(const ABitMap: string);
  end;

resourcestring
  BMP_ERR_Not_Found   = '%s not found';
  BMP_ERR_Not_Valid   = '%s is not a valid bitmap';
  BMP_ERR_Colors_256  = '%s #Colors should be 256';

implementation

constructor TBitMapReader.Create;
begin
  inherited;
end;

destructor TBitMapReader.Destroy;
begin
  SetLength(ColPat, 0);
  SetLength(ScanLines, 0);
  inherited;
end;

procedure TBitMapReader.Load(const ABitMap: string);
var
  F: file;
  Amt: integer; // Bytes actually read. Never checked!
  Y, RowLength: integer;
  SaveRed, SaveFileMode: byte;
begin
  if (not FileExists(ABitMap)) then
    raise exception.Create(Format(BMP_ERR_Not_Found, [ABitMap]));

  SaveFileMode := FileMode;
  FileMode := fmOpenRead;
  AssignFile(F, ABitMap);
  Reset(F, 1);
  try
    {read the file header info}
    BitmapFileHeader := Default(TBitmapFileHeader);
    BlockRead(F, BitmapFileHeader.bmfIdentifier, SizeOf(BitmapFileHeader.bmfIdentifier), Amt);
    if (BitmapFileHeader.bmfIdentifier <> 'BM') then {a bitmap file starts with the id 'BM'}
      raise exception.Create(Format(BMP_ERR_Not_Valid, [ABitMap]));

    BlockRead(F, BitmapFileHeader.bmfFileSize,          SizeOf(BitmapFileHeader.bmfFileSize),         Amt);
    BlockRead(F, BitmapFileHeader.bmfReserved,          SizeOf(BitmapFileHeader.bmfReserved),         Amt);
    BlockRead(F, BitmapFileHeader.bmfBitMapDataOffset,  SizeOf(BitmapFileHeader.bmfBitMapDataOffset), Amt);

    {read the bitmap info header}
    BitmapInfoHeader := Default(TBitmapInfoHeader);
    BlockRead(F, BitmapInfoHeader.biSize,               SizeOf(BitmapInfoHeader.biSize),              Amt); {size of header itself}
    BlockRead(F, BitmapInfoHeader.biWidth,              SizeOf(BitmapInfoHeader.biWidth),             Amt);
    BlockRead(F, BitmapInfoHeader.biHeight,             SizeOf(BitmapInfoHeader.biHeight),            Amt);
    Blockread(F, BitmapInfoHeader.biPlanes,             SizeOf(BitmapInfoHeader.biPlanes),            Amt);
    Blockread(F, BitmapInfoHeader.biBitCount,           SizeOf(BitmapInfoHeader.biBitCount),          Amt); {bits per pixel}
    BlockRead(F, BitmapInfoHeader.biCompression,        SizeOf(BitmapInfoHeader.biCompression),       Amt);
    BlockRead(F, BitmapInfoHeader.biSizeImage,          SizeOf(BitmapInfoHeader.biSizeImage),         Amt);
    BlockRead(F, BitmapInfoHeader.biXPelsPerMeter,      SizeOf(BitmapInfoHeader.biXPelsPerMeter),     Amt);
    BlockRead(F, BitmapInfoHeader.biYPelsPerMeter,      SizeOf(BitmapInfoHeader.biYPelsPerMeter),     Amt);
    BlockRead(F, BitmapInfoHeader.biClrUsed,            SizeOf(BitmapInfoHeader.biClrUsed),           Amt);
    BlockRead(F, BitmapInfoHeader.biClrImportant,       SizeOf(BitmapInfoHeader.biClrImportant),      Amt);

    {get the color palette}
    if (BitmapInfoHeader.biClrUsed <> 256) then
      raise exception.Create(Format(BMP_ERR_Colors_256, [ABitMap]));

    SetLength(ColPat, SizeOf(TPaletteEntry) * BitmapInfoHeader.biClrUsed);
    BlockRead(F, ColPat[0], SizeOf(TPaletteEntry) * BitmapInfoHeader.biClrUsed, Amt);

    {Swap Blue and Red}
    for Y := 0 to BitmapInfoHeader.biClrUsed -1 do
    begin
      SaveRed := ColPat[(Y*4)];
      ColPat[(Y*4)] := ColPat[(Y*4) +2];
      ColPat[(Y*4) +2] := SaveRed;
    end;

    {get the pixel data of the bitmap}
    RowLength := (BitmapInfoHeader.biWidth * BitmapInfoHeader.biBitCount) div 8;
    SetLength(ScanLines, BitmapInfoHeader.biHeight * RowLength);
    for Y := BitmapInfoHeader.biHeight -1 downto 0 do
      BlockRead(F, ScanLines[Y * RowLength], RowLength, Amt);

  finally
    CloseFile(F);
    FileMode := SaveFileMode;
  end;
end;

end.
