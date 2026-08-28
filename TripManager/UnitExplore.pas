unit UnitExplore;

interface

uses
  Data.DB, Datasnap.DBClient;

type
  TExpl_TrackPoint = packed record
    Lat:      integer;
    Lon:      integer;
    Unknown1: array[0..7] of byte;
    DateTime: cardinal;
    Ele:      single;
  end;

const
  Expl_ItemTable    = 'Items';
  Expl_MaxElevation = 10000;

procedure Expl_ExportToGPX(const CdsExploreDb: TClientDataSet;
                           const GPXFileName: string);

implementation

uses
  System.DateUtils, System.JSON, System.SysUtils, System.Classes, System.Generics.Collections,
  UnitGpxDefs, UnitTripDefs, UnitVerySimpleXml, UnitStringUtils,
  UnitGarminDevice, UnitModelConv;

const
  IDLen: array[TGarminModel]        of integer = (4,  // XT
                                                  4,  // XT2
                                                  8,  // XT3
                                                  8,  // Tread 2
                                                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  RecordStart: array[TGarminModel]  of integer = (40, // XT
                                                  40, // XT2
                                                  48, // XT3
                                                  48, // Tread 2
                                                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  RecordLen: array[TGarminModel]    of integer = (8,  // XT
                                                  57, // XT2
                                                  57, // XT3
                                                  48, // Tread 2
                                                  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

var
  FormatSettings: TFormatSettings;

procedure ExportWpts(const GPXRoot: TXmlVsNode; const CdsExploreDb: TClientDataSet);
var
  Wpt: TXmlVSNode;
begin
  cdsExploreDb.Filter := 'Type=1';
  cdsExploreDb.Filtered := true;
  CdsExploreDb.First;
  while not CdsExploreDb.Eof do
  begin
    Wpt := GPXRoot.AddChild('wpt');
    Wpt.SetAttribute('lat' , Coord2Float(CdsExploreDb.FieldByName('lat').AsInteger));
    Wpt.SetAttribute('lon' , Coord2Float(CdsExploreDb.FieldByName('lon').AsInteger));
    Wpt.AddChild('time').NodeValue := DateToISO8601(TUnixDateConv.CardinalAsDateTime(CdsExploreDb.FieldByName('Creation_date').AsInteger), false);
    Wpt.AddChild('name').NodeValue := CdsExploreDb.FieldByName('name').AsString;
    Wpt.AddChild('cmt').NodeValue := CdsExploreDb.FieldByName('UUID').DisplayText;

    CdsExploreDb.Next;
  end;
end;

procedure ExportRtes(const GPXRoot: TXmlVsNode; const CdsExploreDb: TClientDataSet);
var
  Rte, RtePt, ExtPt, ViaPt: TXmlVSNode;
  MetaData: TField;
  Route_points: TField;
  JSONRouteValue: TJSONValue;
  JSONRouteArray: TJSONArray;
  JSONRtePt: TJSonValue;
  JSONRtePtName: TJSonValue;
  JSONRtePtType: TJSonValue;

  JSONMetaValue: TJSONValue;
  JSONMetaVehicleType: TJSONValue;
  TransportMode: string;

  JSONMetaRoutePrefArray: TJSONArray;
  JSONMetaRoutePrefAdventurousModes: TJSONArray;
  RoutePreference: TRoutePreference;
  AdventurousMode: string;
  IsVia: boolean;
  Cnt: integer;
  ViaCnt: integer;
begin
  cdsExploreDb.Filter := 'Type=4';
  cdsExploreDb.Filtered := true;
  CdsExploreDb.First;
  Route_points := CdsExploreDb.FindField('Route_points');
  if (Route_points = nil) then
    exit;
  MetaData := CdsExploreDb.FindField('MetaData');
  if (MetaData = nil) then
    exit;

  while not CdsExploreDb.Eof do
  begin
    Rte := GPXRoot.AddChild('rte');
    Rte.AddChild('name').NodeValue := CdsExploreDb.FieldByName('name').AsString;
    Rte.AddChild('cmt').NodeValue := CdsExploreDb.FieldByName('UUID').DisplayText;
    JSONRouteValue := TJSONObject.ParseJSONValue(Route_points.AsString);
    JSONMetaValue := TJSONObject.ParseJSONValue(MetaData.AsString);
    JSONMetaVehicleType := JSONMetaValue.FindValue('VehicleProfileData').FindValue('VehicleType') as TJSONValue;
    JSONMetaRoutePrefArray := JSONMetaValue.FindValue('RoutePrefData').FindValue('RoutePrefUdbMethods') as TJSONArray;
    JSONMetaRoutePrefAdventurousModes := JSONMetaValue.FindValue('RoutePrefData').FindValue('RoutePrefAdventurousModes') as TJSONArray;

    if (IntToIdent(JSONMetaVehicleType.AsType<integer>, TransportMode, TransportModeMap)) then
      Rte.AddChild('extensions').AddChild('trp:Trip').AddChild('trp:TransportationMode').NodeValue := TransportMode;

    try
      Cnt := 0;
      ViaCnt := 0;
      JSONRouteArray := JSONRouteValue as TJSONArray;
      for JSONRtePt in JSONRouteArray do
      begin
        RtePt := Rte.AddChild('rtept');
        RtePt.SetAttribute('lat', JSONRtePt.FindValue('Lat').AsType<string>);
        RtePt.SetAttribute('lon', JSONRtePt.FindValue('Lon').AsType<string>);
        JSONRtePtName := JSONRtePt.FindValue('Name');
        if (JSONRtePtName <> nil) then
          RtePt.AddChild('name').NodeValue := JSONRtePtName.AsType<string>
        else
        begin
          Inc(Cnt);
          RtePt.AddChild('name').NodeValue := Format('%s_%d', [CdsExploreDb.FieldByName('name').AsString, Cnt]);
        end;
        IsVia := false;
        JSONRtePtType := JSONRtePt.FindValue('Type');
        if (JSONRtePtType <> nil) then
          IsVia := (JSONRtePtType.AsType<integer> = 1);

        if (IsVia) then
        begin
          ExtPt := RtePt.AddChild('extensions');
          ViaPt := ExtPt.AddChild('trp:ViaPoint');

          if (Assigned(JSONMetaRoutePrefArray)) then
          begin
            // End point gets route pref of last.
            if (ViaCnt > JSONRouteArray.Count -2) then
              ViaCnt := JSONRouteArray.Count -2;

            RoutePreference := TRoutePreference(JSONMetaRoutePrefArray[ViaCnt].AsType<integer>);
            ViaPt.AddChild('trp:CalculationMode').NodeValue := Expl2GpxDesc(RoutePreference);

            if (RoutePreference in [TRoutePreference.rmAdventurous]) then
            begin
              if (Assigned(JSONMetaRoutePrefAdventurousModes)) and
                 (IntToIdent(JSONMetaRoutePrefAdventurousModes[ViaCnt].AsType<integer>, AdventurousMode, AdvLevelMap)) then
                ExtPt.AddChild('tm:AdventurousLevel').NodeValue := AdventurousMode;
            end;
          end;
          Inc(ViaCnt);
        end
        else
          RtePt.AddChild('extensions').AddChild('trp:ShapingPoint');
      end;
    finally
      JSONRouteValue.Free;
      JSONMetaValue.Free;
    end;

    CdsExploreDb.Next;
  end;
end;

procedure ExportTrks(const GPXRoot: TXmlVsNode; const CdsExploreDb: TClientDataSet);
var
  TmpGarminDevice: TGarminDevice;
  GarminModel: TGarminModel;
  Trk, TrkSeg, TrkPt: TXmlVSNode;
  MetaData, TrackPoints: TField;
  JSONValue: TJSONValue;
  JSONPartNbr: TJSONValue;
  MemoryStream: TMemoryStream;
  Cnt: integer;
  LId: cardinal;
  Id: array[0..21] of AnsiChar;
  Flags: array[0..9] of byte;
  TrkPts: word;
  Expl_TrackPoint: TExpl_TrackPoint;
  SavePos: int64;
begin
  cdsExploreDb.Filter := 'Type=2';
  cdsExploreDb.Filtered := true;
  CdsExploreDb.First;

  TrackPoints := CdsExploreDb.FindField('Track_Points');
  if (TrackPoints = nil) then
    exit;

  MemoryStream := TMemoryStream.Create;
  try
    // Determine Model from PartNumber
    GarminModel := TGarminModel.XT;
    MetaData := CdsExploreDb.FindField('Metadata');
    if (MetaData <> nil) then
    begin
      JSONVAlue := TJSONObject.ParseJSONValue(MetaData.AsString);
      TmpGarminDevice := TGarminDevice.Create;
      try
        JSONPartNbr := JSONVAlue.FindValue('PartNumber');
        if (JSONPartNbr <> nil) then
        begin
          TmpGarminDevice.Init;
          TmpGarminDevice.PartNumber := JSONPartNbr.AsType<string>;
          GarminModel := TModelConv.GetModelFromGarminDevice(TmpGarminDevice);
        end;
      finally
        JSONValue.Free;
        TmpGarminDevice.Free;
      end;
    end;

    while not CdsExploreDb.Eof do
    begin
      Trk := GPXRoot.AddChild('trk');
      Trk.AddChild('name').NodeValue := CdsExploreDb.FieldByName('name').AsString;
      Trk.AddChild('cmt').NodeValue := CdsExploreDb.FieldByName('UUID').DisplayText;
      TrkSeg  := Trk.AddChild('trkseg');
      MemoryStream.Size := Length(TrackPoints.AsBytes);
      MemoryStream.Seek(0, TSeekOrigin.soBeginning);
      MemoryStream.WriteBuffer(TrackPoints.AsBytes, Length(TrackPoints.AsBytes));

      MemoryStream.Seek(0, TSeekOrigin.soBeginning);
      MemoryStream.Read(LId, SizeOf(LId));
      if (Lid <> SizeOf(Id)) then
        continue;

      case GarminModel of
        TGarminModel.XT, TGarminModel.XT2:;
        else
          MemoryStream.Seek(SizeOf(Cardinal), TSeekOrigin.soCurrent);
      end;
      MemoryStream.Read(Id, SizeOf(Id));
      if (Id <> 'serialization::archive') then
        continue;
      MemoryStream.Read(Flags, SizeOf(Flags));
      MemoryStream.Read(TrkPts, SizeOf(TrkPts));

      MemoryStream.Seek(RecordStart[GarminModel], TSeekOrigin.soBeginning);
      for Cnt := 0 to TrkPts -1 do
      begin
        SavePos := MemoryStream.Position;
        Expl_TrackPoint := Default(TExpl_TrackPoint);
        MemoryStream.Read(Expl_TrackPoint, RecordLen[GarminModel]);

        // Add Trackpoint to XML
        TrkPt := TrkSeg.AddChild('trkpt');
        Trkpt.SetAttribute('lat', Coord2Float(Expl_TrackPoint.Lat));
        Trkpt.SetAttribute('lon', Coord2Float(Expl_TrackPoint.Lon));
        if (Abs(Expl_TrackPoint.Ele) < Expl_MaxElevation) then
          Trkpt.AddChild('ele').NodeValue := FormatFloat('####0.00', Expl_TrackPoint.Ele, FormatSettings);
        if (Expl_TrackPoint.DateTime > 0) and
           (Expl_TrackPoint.DateTime < $ffffffff) then
        Trkpt.AddChild('time').NodeValue := DateToISO8601(TUnixDateConv.CardinalAsDateTime(Expl_TrackPoint.DateTime), false);

        MemoryStream.Seek(SavePos + RecordLen[GarminModel], TSeekOrigin.soBeginning);
      end;
      CdsExploreDb.Next;
    end;

  finally
    MemoryStream.Free;
  end;

end;

procedure Expl_ExportToGPX(const CdsExploreDb: TClientDataSet;
                           const GPXFileName: string);
var
  GPXXml: TXmlVSDocument;
  GPXRoot: TXmlVSNode;
begin

  GPXXml := TXmlVSDocument.Create;
  GPXRoot := InitGarminGpx(GPXXml);
  try
    ExportWpts(GPXRoot, CdsExploreDb);
    ExportRtes(GPXRoot, CdsExploreDb);
    ExportTrks(GPXRoot, CdsExploreDb);

  finally
    GPXXml.SaveToFile(GPXFileName);
    GPXXml.Free;
  end;
end;

initialization
begin
  FormatSettings := GetLocaleSetting;
end;

end.
