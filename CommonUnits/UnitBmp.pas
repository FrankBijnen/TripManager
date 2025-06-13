unit UnitBmp;

interface

uses
  WinApi.Windows, System.Classes, System.Types, System.SysUtils, Vcl.Graphics,
  Vcl.Dialogs;

type

TIDString = string[2];

TBitmapFileHeader = record
  bmfIdentifier : Word; {'BM'}
  bmfFileSize : dWord;
  bmfReserved : dWord;
  bmfBitMapDataOffset : dWord; {from begin of file}
end;

{followed by the bitmapinfoheader}

TBitmapInfoHeader = record
  biSize: Longint;   {size of tbitmapinfoheader}
  biWidth: Longint;  {bitmap width}
  biHeight: Longint;  { height of bitmap}
  biPlanes: Word;     {always 1}
  biBitCount: Word;  {number color bits 4 = 16 colors, 8 = 256 pixel is a byte}
  biCompression: Longint; {compression used, 0 }
  biSizeImage: Longint;   {size of the pixel data}
  biXPelsPerMeter: Longint; {not used, 0 }
  biYPelsPerMeter: Longint; {not used, 0 }
  biClrUsed: Longint;       {number of colors used, set to 0 }
  biClrImportant: Longint;  {important colors, set to 0 }
end;
{followed by the palette data}

TBitMapReader = class
  BitmapFileHeader : TBitmapFileHeader;
  BitmapInfoHeader : TBitmapInfoHeader;
  RedByte, BlueByte, GreenByte : Byte;
  AWord : Word;
  Amt : Integer; {var variable, total bytes returned by blockread}
  AByte : Byte;
  ALongint : Longint;
  AChar : Char;
  BMhPalette : HPALETTE;
  PalCount : integer;
  Pb: Pointer;
  ColPat: array of byte;
  ScanLines: array of byte;
  constructor Create;
  procedure Load(ABitMap: UTF8String);
  destructor Destroy; override;
end;

implementation

constructor TBitMapReader.Create;
begin
  inherited;
end;

procedure TBitMapReader.Load(ABitMap: UTF8String);
var F: file;
    Idstr: TIDString;
    Y, RowLength: integer;
    Red, Blue: byte;
begin
  if (not FileExists(string(ABitMap))) then
    raise exception.Create(string(ABitMap) + ' not found');

  FileMode := 0;
  AssignFile(F, string(ABitMap));
  Reset(F, 1);
  try
    Idstr := '';

    {a bitmap file starts with the id 'BM'}
    BlockRead(F, AChar, 1, amt);
    Idstr := TIDString(Achar);
    BlockRead(F, Achar, 1, amt);
    Idstr := Idstr + TIDString(Achar);
    if Idstr <> 'BM' then
      raise exception.Create(string(ABitMap) + ' is not a valid bitmap');

    {read the file header info}
    BlockRead(F, Alongint, 4, amt);
    BitmapFileHeader.bmfFileSize := Alongint;
    BlockRead(F, Alongint, 4, amt);
    BitmapFileHeader.bmfReserved := Alongint;
    BlockRead(F, Alongint, 4, amt);
    BitmapFileHeader.bmfBitMapDataOffset := Alongint;

    {read the bitmap info header}
    BlockRead(F, Alongint, 4, amt);
    BitmapInfoHeader.biSize := Alongint; {size of header itself}
    BlockRead(F, Alongint, 4, amt);
    BitmapInfoHeader.biWidth := Alongint;
    BlockRead(F, Alongint, 4, amt);
    BitmapInfoHeader.biHeight :=  Alongint;
    Blockread(F, AWord, 2, amt);
    BitmapInfoHeader.biPlanes := Aword;
    Blockread(F, AWord, 2, amt);
    BitmapInfoHeader.biBitCount := Aword;  {bits per pixel}
    BlockRead(F, Alongint, 4, amt);
    BitmapInfoHeader.biCompression := Alongint;

    BlockRead(F, Alongint, 4, amt);
    BitmapInfoHeader.biSizeImage := Alongint;
    BlockRead(F, Alongint, 4, amt);
    BitmapInfoHeader.biXPelsPerMeter := Alongint;
    BlockRead(F, Alongint, 4, amt);
    BitmapInfoHeader.biYPelsPerMeter := Alongint;
    BlockRead(F, Alongint, 4, amt);
    BitmapInfoHeader.biClrUsed := Alongint;
    BlockRead(F, Alongint, 4, amt);
    BitmapInfoHeader.biClrImportant := Alongint;

    {get the color palette}
    If BitmapInfoHeader.biClrUsed <> 256 then
      raise exception.Create(string(ABitMap) + ' #Colors should be 256');

    PalCount := BitmapInfoHeader.biClrUsed;
    SetLength(ColPat, SizeOf(TPaletteEntry) * PalCount);
    BlockRead(F, ColPat[0], SizeOf(TPaletteEntry) * PalCount, Amt);

    {Swap Blue and Red}
    for Y := 0 to PalCount-1 do
    begin
      Red := ColPat[ (Y*4) ];
      Blue := ColPat[ (Y*4) + 2 ];
      ColPat[ (Y*4) + 2 ] := Red;
      ColPat[ (Y*4) ] := Blue;
    end;

    {get the pixel data of the bitmap}
    RowLength := (BitmapInfoHeader.biWidth * BitmapInfoHeader.biBitCount) div 8;
    SetLength(ScanLines, BitmapInfoHeader.biHeight * RowLength);
    for Y := BitmapInfoHeader.biHeight - 1 downto 0 do
      BlockRead(F, ScanLines[Y * RowLength], RowLength, amt);

  finally
    CloseFile(F);
  end;
end;

destructor TBitMapReader.Destroy;
begin
  SetLength(ColPat, 0);
  SetLength(ScanLines, 0);
  inherited;
end;

end.
