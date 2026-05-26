unit UnitTripOverview;

interface

uses
  System.Generics.Collections;

type
  TTripInfoKey = record
    SegmentId: integer;
    RoutePointId: integer;
    UdbId: integer;
    function GetKey: string;
  end;

  TTripInfoData = record
    RoutePoint: string;
    RoadClass: byte;
    MapSegRoadId : string;
    Description: string;
    Coords: string;
    Speed: integer;
    Dist: double;
    Time: double;
  end;

  TTripInfo = class(TObject)
    SegmentId: integer;
    RoutePointId: integer;
    RoutePoint: string;
    RoadClass: byte;
    MapSegRoadId: string;
    Description: string;
    Coords: string;
    Speed: integer;
    Distance: double;
    Time: double;
    constructor Create(const TripKey: TTripInfoKey;
                       const TripData: TTripInfoData);

  end;
  TTripInfoList = TObjectDictionary<string, TTripInfo>;


function TripTimeAsHrMin(AValue: cardinal): string;
function AddToTripInfo(const ATripInfoList: TTripInfoList;
                       const TripKey: TTripInfoKey;
                       const TripData: TTripInfoData): word;
procedure ExportTripInfoToCSV(const ATripInfoList: TTripInfoList; const CSVFile: string);

implementation

uses
  System.Classes, System.SysUtils, System.Math,
  UnitGpxDefs;

function TTripInfoKey.GetKey: string;
begin
  result := Format('%.3d_%.3d_%.5d', [SegmentId, RoutePointId, UdbId]);
end;

constructor TTripInfo.Create(const TripKey: TTripInfoKey;
                             const TripData: TTripInfoData);
begin
  inherited Create;

  SegmentId := TripKey.SegmentId;
  RoutePointId := TripKey.RoutePointId;
  RoutePoint := TripData.RoutePoint;
  RoadClass := TripData.RoadClass;
  MapSegRoadId := TripData.MapSegRoadId;
  Coords := TripData.Coords;
  Speed := TripData.Speed;
  Description := TripData.Description;
end;

function TripTimeAsHrMin(AValue: cardinal): string;
var
  Hour, Min: integer;
begin
  Hour := Trunc(AValue / 60 / 60);
  Min := Trunc(AValue / 60);
  MIn := Min - (Hour * 60);
  result := Format('%d Hour %d Min.', [Hour, Min]);
  result := result + Format(' (%d Seconds)', [AValue]);
end;

function DisplaySpeed(ATripInfo: TTripInfo): string;
begin
  if (ATripInfo.Speed > 0) then
    result := Format('%d', [ATripInfo.Speed])
  else
  begin
    if (ATripInfo.Time > 0) then
      result := Format('%d', [Round(ATripInfo.Distance * 3600 / ATripInfo.Time)])
    else
      result := NotApplicable;
  end;
end;

function AddToTripInfo(const ATripInfoList: TTripInfoList;
                       const TripKey: TTripInfoKey;
                       const TripData: TTripInfoData): word;
var
  ATripInfo: TTripInfo;
  TripInfoKey: string;
begin
  TripInfoKey := TripKey.GetKey;
  if (ATripInfoList.ContainsKey(TripInfoKey)) then
    ATripInfo := ATripInfoList.Items[TripInfoKey]
  else
  begin
    ATripInfo := TTripInfo.Create(TripKey, TripData);
    ATripInfoList.Add(TripInfoKey, ATripInfo);
  end;
  ATripInfo.Distance := ATripInfo.Distance + TripData.Dist;
  ATripInfo.Time := ATripInfo.Time + TripData.Time;
  result := Min($fffe, Round(TripData.Time));
end;

procedure ExportTripInfoToCSV(const ATripInfoList: TTripInfoList; const CSVFile: string);
var
  Writer: TTextWriter;
  Lst: TStringList;
  SortedTripKeys: TStringList;
  ATripKey: string;
  ATripInfo: TTripInfo;
  RpTime, RpDist: Double;
  ToTTime, TotDist: Double;
  CurSegmentId, CurRoutePointId: integer;
  CurRoutePoint: string;
begin
  SortedTripKeys := TStringList.Create;
  SortedTripKeys.Sorted := true;
  SortedTripKeys.Duplicates := TDuplicates.dupIgnore;
  try
    for ATripKey in ATripInfoList.Keys do
      SortedTripKeys.Add(ATripKey);

    Writer := TStreamWriter.Create(CSVFile, false, TEncoding.UTF8);
    try
      Lst := TStringList.Create;
      try
        Lst.QuoteChar := '"';
        Lst.Delimiter := ';';
        Lst.StrictDelimiter := true;

        Lst.AddStrings(['Route point', 'Road ID', 'Road Class', 'Description', 'Coordinates', 'Speed (Kmh)',
                        'Distance (Km)', 'Time (Sec)', 'Trip Distance (Km)', 'Trip Time (Sec)', 'Trip time']);
        Writer.WriteLine(Lst.DelimitedText);

        RpTime := 0;
        RpDist := 0;
        ToTTime := 0;
        TotDist := 0;
        CurSegmentId := -1;
        CurRoutePointId := -1;
        CurRoutePoint := '';

        for ATripKey in SortedTripKeys do
        begin
          ATripInfo := ATripInfoList.Items[ATripKey];

          // Route point total
          if (CurSegmentId <> ATripInfo.SegmentId) or
             (CurRoutePointId <> ATripInfo.RoutePointId) then
          begin
            if (RpDist > 0) then
            begin
              Lst.Clear;
              Lst.AddStrings([ATripInfo.RoutePoint,
                              'Route point',
                              '',
                              '',
                              '',
                              '',
                              Format('%f', [RpDist]),
                              Format('%f', [RpTime]),
                              Format('%f', [TotDist]),
                              Format('%f', [TotTime]),
                              TripTimeAsHrMin(Round(TotTime))]);
              Writer.WriteLine(Lst.DelimitedText);
            end;
            // reset Route point total
            RpTime := 0;
            RpDist := 0;
            CurSegmentId := ATripInfo.SegmentId;
            CurRoutePointId := ATripInfo.RoutePointId;
            CurRoutePoint := ATripInfo.RoutePoint;
          end;

          RpTime := RpTime + ATripInfo.Time;
          RpDist := RpDist + ATripInfo.Distance;
                    TotTime := TotTime + ATripInfo.Time;
          TotDist := TotDist + ATripInfo.Distance;

          Lst.Clear;
          Lst.AddStrings([ATripInfo.RoutePoint,
                          ATripInfo.MapSegRoadId,
                          Format('(0x%s)', [IntToHex(ATripInfo.RoadClass, 2)]),
                          ATripInfo.Description,
                          ATripInfo.Coords,
                          DisplaySpeed(ATripInfo),
                          Format('%f', [ATripInfo.Distance]),
                          Format('%f', [ATripInfo.Time])]);
          Writer.WriteLine(Lst.DelimitedText);

        end;

        // Last Route point total
        if (RpDist > 0) then
        begin
          Lst.Clear;
          Lst.AddStrings(['Route',
                          'Total',
                          '',
                          '',
                          '',
                          '',
                          Format('%f', [RpDist]),
                          Format('%f', [RpTime]),
                          Format('%f', [TotDist]),
                          Format('%f', [TotTime]),
                          TripTimeAsHrMin(Round(TotTime))]);
          Writer.WriteLine(Lst.DelimitedText);
        end;
      finally
        Lst.Free;
      end;
    finally
      Writer.Free;
    end;
  finally
    SortedTripKeys.Free;
  end;
end;

end.
