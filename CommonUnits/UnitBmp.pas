unit UnitBmp;

interface

uses
  WinApi.Windows, System.Classes, System.Types, System.SysUtils, Vcl.Graphics,
  Vcl.Dialogs;

type

  TBitmapFileHeader = packed record
    bmfIdentifier: array[0..1] of AnsiChar; // 'BM'
    bmfFileSize: dWord;
    bmfReserved: dWord;
    bmfBitMapDataOffset: dWord;             // from begin of file
  end;

  // followed by the bitmapinfoheader
  TBitmapInfoHeader = packed record
    biSize: integer;                        // size of tbitmapinfoheader
    biWidth: integer;                       // bitmap width
    biHeight: integer;                      // height of bitmap
    biPlanes: Word;                         // always 1
    biBitCount: Word;                       // number color bits 4 = 16 colors, 8 = 256 pixel is a byte
    biCompression: integer;                 // compression used, 0
    biSizeImage: integer;                   // size of the pixel data
    biXPelsPerMeter: integer;               // not used, 0
    biYPelsPerMeter: integer;               // not used, 0
    biClrUsed: integer;                     // number of colors used, set to 0
    biClrImportant: integer;                // important colors, set to 0
  end;

  // followed by the palette data
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
  S: TBufferedFileStream;
  Index, RowLength: integer;
  SaveRed: byte;
begin
  if (not FileExists(ABitMap)) then
    raise exception.Create(Format(BMP_ERR_Not_Found, [ABitMap]));

  S := TBufferedFileStream.Create(ABitMap, fmOpenRead);
  try
    // read the file header info
    BitmapFileHeader := Default(TBitmapFileHeader);
    S.Read(BitmapFileHeader.bmfIdentifier, SizeOf(BitmapFileHeader.bmfIdentifier));
    if (BitmapFileHeader.bmfIdentifier <> 'BM') then                                        // a bitmap file starts with the id 'BM'
      raise exception.Create(Format(BMP_ERR_Not_Valid, [ABitMap]));

    S.Read(BitmapFileHeader.bmfFileSize,          SizeOf(BitmapFileHeader.bmfFileSize));
    S.Read(BitmapFileHeader.bmfReserved,          SizeOf(BitmapFileHeader.bmfReserved));
    S.Read(BitmapFileHeader.bmfBitMapDataOffset,  SizeOf(BitmapFileHeader.bmfBitMapDataOffset));

    // read the bitmap info header
    BitmapInfoHeader := Default(TBitmapInfoHeader);
    S.Read(BitmapInfoHeader.biSize,               SizeOf(BitmapInfoHeader.biSize));         // size of header itself
    S.Read(BitmapInfoHeader.biWidth,              SizeOf(BitmapInfoHeader.biWidth));
    S.Read(BitmapInfoHeader.biHeight,             SizeOf(BitmapInfoHeader.biHeight));
    S.Read(BitmapInfoHeader.biPlanes,             SizeOf(BitmapInfoHeader.biPlanes));
    S.Read(BitmapInfoHeader.biBitCount,           SizeOf(BitmapInfoHeader.biBitCount));     // bits per pixel
    S.Read(BitmapInfoHeader.biCompression,        SizeOf(BitmapInfoHeader.biCompression));
    S.Read(BitmapInfoHeader.biSizeImage,          SizeOf(BitmapInfoHeader.biSizeImage));
    S.Read(BitmapInfoHeader.biXPelsPerMeter,      SizeOf(BitmapInfoHeader.biXPelsPerMeter));
    S.Read(BitmapInfoHeader.biYPelsPerMeter,      SizeOf(BitmapInfoHeader.biYPelsPerMeter));
    S.Read(BitmapInfoHeader.biClrUsed,            SizeOf(BitmapInfoHeader.biClrUsed));
    S.Read(BitmapInfoHeader.biClrImportant,       SizeOf(BitmapInfoHeader.biClrImportant));

    // get the color palette
    if (BitmapInfoHeader.biClrUsed <> 256) then
      raise exception.Create(Format(BMP_ERR_Colors_256, [ABitMap]));

    SetLength(ColPat, SizeOf(TPaletteEntry) * BitmapInfoHeader.biClrUsed);
    S.Read(ColPat[0], SizeOf(TPaletteEntry) * BitmapInfoHeader.biClrUsed);

    // Swap Blue and Red
    for Index := 0 to BitmapInfoHeader.biClrUsed -1 do
    begin
      SaveRed := ColPat[(Index*4)];
      ColPat[(Index*4)] := ColPat[(Index*4) +2];
      ColPat[(Index*4) +2] := SaveRed;
    end;

    // get the pixel data of the bitmap
    RowLength := (BitmapInfoHeader.biWidth * BitmapInfoHeader.biBitCount) div 8;
    SetLength(ScanLines, BitmapInfoHeader.biHeight * RowLength);
    for Index := BitmapInfoHeader.biHeight -1 downto 0 do
    begin
      S.Read(ScanLines[Index * RowLength], RowLength);
    end;
  finally
    S.Free;
  end;
end;

end.
