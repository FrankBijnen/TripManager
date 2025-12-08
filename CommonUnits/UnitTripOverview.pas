unit UnitTripOverview;
//TODO RoadSpeed  Make the road speeds configurable
interface

uses
  System.Classes, System.SysUtils, System.Generics.Collections,
  UnitGpxDefs;

function ComputeTime(const RoadClass: byte; const Dist: Double): double;
function TripTimeAsHrMin(AValue: cardinal): string;
function AddToTripInfo(const ATripInfoList: TTripInfoList;
                       const SegmentId, RoutePointId, UdbId: integer;
                       const RoutePoint, RoadClass: string;
                       const UdbDir: TObject;
                       const Dist: double): word; overload;
procedure AddToTripInfo(const ATripInfoList: TTripInfoList;
                        const SegmentId, RoutePointId, UdbId: integer;
                        const RoutePoint: string;
                        const UdbDir: TObject;
                        const Dist: double; const Time: word); overload;
procedure ExportTripInfoToCSV(const ATripInfoList: TTripInfoList; const CSVFile: string);

implementation

uses
  System.Math,
  UnitTripObjects;

function DescriptionFromRoadClass(const RoadClass: byte): string;
begin
  case RoadClass of
    0:  result := '';
    1:  result := 'Interstate highway';
    2:  result := 'Major highway';
    3:  result := 'Other highway';
    4:  result := 'Arterial road';
    5:  result := 'Collector road';
    6:  result := 'Residential Street';
    7:  result := 'Private';
    8:  result := 'Highway ramp. Low speed';
    9:  result := 'Highway ramp. High speed';
    10: result := 'Unpaved';
    11: result := 'Major higway connector';
    12: result := 'Round about';
    else
        result := Format('RoadClass: %s', [IntToHex(RoadClass, 2)]);
  end;
end;

// Table from default Basecamp Motorcycle profile.
function SpeedFromRoadClass(const RoadClass: byte): integer;
begin
  case RoadClass of
    1:  result := 108;
    2:  result := 72;
    3:  result := 56;
    4:  result := 50;
    5:  result := 48;
    12: result := 15;
    else
        result := 20;
  end;
end;

function ComputeTime(const RoadClass: byte; const Dist: Double): double;
begin
  result := (3600 * Dist) / SpeedFromRoadClass(RoadClass);
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
      result := 'N/A'
  end;
end;

function AddToTripInfo(const ATripInfoList: TTripInfoList;
                       const SegmentId, RoutePointId, UdbId: integer;
                       const RoutePoint, RoadClass: string;
                       const UdbDir: TObject;
                       const Dist: double): word;
var
  ATripInfo: TTripInfo;
  DistTime: double;
  TripInfoKey: string;
begin
  TripInfoKey := Format('%.3d_%.3d_%.5d', [SegmentId, RoutePointId, UdbId]);
  if (ATripInfoList.ContainsKey(TripInfoKey)) then
    ATripInfo := ATripInfoList.Items[TripInfoKey]
  else
  begin
    ATripInfo := TTripInfo.Create;
    ATripInfo.SegmentId := SegmentId;
    ATripInfo.RoutePointId := RoutePointId;
    ATripInfo.RoutePoint := RoutePoint;
    ATripInfo.RoadClass := StrToIntDef('$' + RoadClass, 0);
    ATripInfo.MapSegRoadId := TUdbDir(UdbDir).MapSegRoadDisplay;
    ATripInfo.Description := DescriptionFromRoadClass(ATripInfo.RoadClass);
    ATripInfo.Speed := SpeedFromRoadClass(ATripInfo.RoadClass);
    ATripInfoList.Add(TripInfoKey, ATripInfo);
  end;
  DistTime := ComputeTime(ATripInfo.RoadClass, Dist);
  ATripInfo.Distance := ATripInfo.Distance + Dist;
  ATripInfo.Time := ATripInfo.Time + DistTime;
  result := Min($fffe, Round(DistTime));
end;

procedure AddToTripInfo(const ATripInfoList: TTripInfoList;
                        const SegmentId, RoutePointId, UdbId: integer;
                        const RoutePoint: string;
                        const UdbDir: TObject;
                        const Dist: double; const Time: word);
var
  ATripInfo: TTripInfo;
  TripInfoKey: string;
begin
  TripInfoKey := Format('%.3d_%.3d_%.5d', [SegmentId, RoutePointId, UdbId]);
  if (ATripInfoList.ContainsKey(TripInfoKey)) then
    ATripInfo := ATripInfoList.Items[TripInfoKey]
  else
  begin
    ATripInfo := TTripInfo.Create;
    ATripInfo.SegmentId := SegmentId;
    ATripInfo.RoutePointId := RoutePointId;
    ATripInfo.RoutePoint := RoutePoint;
    ATripInfo.MapSegRoadId := TUdbDir(UdbDir).MapSegRoadDisplay;
    ATripInfo.Description := DescriptionFromRoadClass(ATripInfo.RoadClass);
    ATripInfo.Speed := 0;
    ATripInfoList.Add(TripInfoKey, ATripInfo);
  end;
  ATripInfo.Distance := ATripInfo.Distance + Dist;
  ATripInfo.Time := ATripInfo.Time + Time;
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

        Lst.AddStrings(['Route point', 'Road ID', 'Road Class', 'Description', 'Speed (Kmh)',
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
              Lst.AddStrings([CurRoutePoint,
                              'Total',
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
                          DisplaySpeed(ATripInfo),
                          Format('%f', [ATripInfo.Distance]),
                          Format('%f', [ATripInfo.Time])]);
          Writer.WriteLine(Lst.DelimitedText);

        end;

        // Last Route point total
        if (RpDist > 0) then
        begin
          Lst.Clear;
          Lst.AddStrings([CurRoutePoint,
                          'Total',
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

