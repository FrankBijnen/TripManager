program ModelParams;
{$R *.res}

uses
  System.SysUtils,
  System.Rtti, System.TypInfo,
  WinApi.Windows,
  UnitTripDefs in '..\CommonUnits\UnitTripDefs.pas';

var
  TripModel: TTripModel;
  Chars: integer;

begin

  AllocConsole;
  Write('Model', #9);
  Write('Model Specific Params', #9);
  Write('UdbDirNameSize (Bytes)', #9);
  Write('UdbDirNameSize (Chars)', #9);
  Write('Unknown3Size', #9);
  Write('CalculationMagic', #9);
  Write('ScPosnSize', #9);
  Write('NeedRecreateTrips', #9);
  Write('HasAllLinks', #9);
  Write('SupportsGrouping', #9);
  Write('RoutePrefType', #9);
  Write('VersionSize', #9);
  Write('Version', #9);

  Write('Version Specific Params', #9);
  Write('UCS4', #9);
  Write('Unknown2Size', #9);
  Write('UdbDirUnknown2Size', #9);
  Write('Unknown3BoundsOffset', #9);
  Write('Unknown3MagicOffset', #9);
  Write('Unknown3ShapeOffset', #9);
  Write('Unknown3DistOffset', #9);
  Write('Unknown3TimeOffset', #9);
  Write('Unknown3FloatOffset', #9);
  Write('HandleTrailer', #9);
  Write('CanCheckSystemTrips', #9);

  Writeln;

  for TripModel := Low(TTripModel) to High(TTripModel) do
  begin
    if (TripVersion[TripModel].IsUcs4) then
      Chars := UdbDirNameSize[TripModel] div 4
    else
      Chars := UdbDirNameSize[TripModel] div 2;

    Write(GetEnumName(TypeInfo(TTripModel), Ord(TripModel)), #9);
    Write(#9);
    Write(UdbDirNameSize[TripModel], #9);
    Write(Chars, #9);
    Write(Unknown3Size[TripModel], #9);
    Write('0x', IntToHex(CalculationMagic[TripModel], 8), #9);
    Write(ScPosnSize[TripModel], #9);
    Write(NeedRecreateTrips[TripModel], #9);
    Write(HasAllLinks[TripModel], #9);
    Write(SupportsGrouping[TripModel], #9);
    Write(RoutePrefType[TripModel], #9);
    Write(TripVersion[TripModel].Size, #9);
    Write(TripVersion[TripModel].Version, #9);

    Write(#9);
    Write(TripVersion[TripModel].IsUcs4, #9);
    Write(TripVersion[TripModel].Unknown2Size, #9);
    Write(TripVersion[TripModel].UdbDirUnknown2Size, #9);
    Write('0x', IntToHex(TripVersion[TripModel].Unknown3BoundsOffset, 4), #9);
    Write('0x', IntToHex(TripVersion[TripModel].Unknown3MagicOffset, 4), #9);
    Write('0x', IntToHex(TripVersion[TripModel].Unknown3ShapeOffset, 4), #9);
    Write('0x', IntToHex(TripVersion[TripModel].Unknown3DistOffset, 4), #9);
    Write('0x', IntToHex(TripVersion[TripModel].Unknown3TimeOffset, 4), #9);
    Write('0x', IntToHex(TripVersion[TripModel].Unknown3FloatOffset, 4), #9);
    Write(TripVersion[TripModel].HandleTrailer, #9);
    Write(TripVersion[TripModel].CanCheckSystemTrips, #9);

    Writeln;
  end;
end.
