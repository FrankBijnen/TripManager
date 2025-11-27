unit UFrmShowLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.CheckLst,
  Vcl.Themes;

type
  TFrmShowLog = class(TForm)
    PnlBot: TPanel;
    BtnClose: TBitBtn;
    LbLog: TCheckListBox;
    BtnTrip: TButton;
    BtnGpx: TButton;
    BtnFixedTrip: TButton;
    SaveTrip: TSaveDialog;
    BtnFixedGpx: TButton;
    procedure BtnCloseClick(Sender: TObject);
    procedure LbLogClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LbLogDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure BtnTripClick(Sender: TObject);
    procedure BtnGpxClick(Sender: TObject);
    procedure BtnFixedTripClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnFixedGpxClick(Sender: TObject);
  private
    { Private declarations }
    FstyleServices: TCustomStyleServices;
    procedure ClearGpxRptList;
    procedure SetCheck(const FileType: string);
    procedure FixTripList;
  public
    { Public declarations }
    CompareGpx: string;
    FSyncTreeview: TNotifyEvent;
    GpxRptList: Tlist;
    procedure ClearLog;
  end;

var
  FrmShowLog: TFrmShowLog;

implementation

uses
  System.Types, System.StrUtils, system.Generics.Collections,
  UnitGpxDefs, UnitTripObjects, UnitGpxObjects, UnitGpxTripCompare,
  UFrmTripEditor,
  UnitVerySimpleXml, UnitProcessOptions;

{$R *.dfm}

function CoordsFromData(AnObject: TObject): TCoords;
begin
  FillChar(result, SizeOf(result), 0);
  if (AnObject = nil) then
    exit;

  if (AnObject is TUdbDir) then
  begin
    result.Lat := TUdbDir(AnObject).Lat;
    result.Lon := TUdbDir(AnObject).Lon;
    exit;
  end;

  if (AnObject is TXmlVSNode) then
    result.FromAttributes(TXmlVSNode(AnObject).AttributeList);
end;

procedure TFrmShowLog.SetCheck(const FileType: string);
var
  Index: integer;
  LastCoords, NewCoords: TCoords;
  SegmentOnly: boolean;
  ProcessOptions: TProcessOptions;
  AnUdbDir: TUdbDir;
begin
  ProcessOptions := TProcessOptions.Create;
  try
    SegmentOnly := (LbLog.ItemIndex > 1);
    for Index := LbLog.ItemIndex +1 to LbLog.Items.Count -1 do
    begin
      if (SegmentOnly) and
         (ContainsText(LbLog.Items[Index], CheckSeg)) then
        break;

      if (Index < 0) then
        continue;
      if not (ContainsText(LbLog.Items[Index], FileType)) then
      begin
        LbLog.Checked[Index] := false;
        continue;
      end;

      // Only Continue
      if (FileType = TripFile) then
      begin
        AnUdbDir := TUdbDir(LbLog.Items.Objects[Index]);
        if (AnUdbDir.UdbDirValue.SubClass.Direction <> 0) then
          continue;
      end;

      NewCoords := CoordsFromData(LbLog.Items.Objects[Index]);
      if (CoordDistance(NewCoords, LastCoords, TDistanceUnit.duKm) < ProcessOptions.CompareDistanceOK / 100) then
        continue;

      LastCoords := NewCoords;
      LbLog.Checked[Index] := true;
    end;
  finally
    ProcessOptions.Free;
  end;
end;

procedure TFrmShowLog.BtnTripClick(Sender: TObject);
begin
  SetCheck(TripFile);
end;

procedure TFrmShowLog.FixTripList;
var
  Index: integer;
  AnUdbDir: TUdbDir;
  OldLocations, NewLocations: TmLocations;
  RoutePt, AddedShape: integer;
  RoutePointList: TList<TLocation>;
  CoordGpx: TCoords;
  NewLat, NewLon: double;
  FixedTripList, OldTripList: TTripList;
  ProcessOptions: TProcessOptions;
  RoutePoint: TRoutePoint;
  ShapeName, ShapeCmt: string;
begin
  FixedTripList := FrmTripEditor.CurTripList;

  // Save locations and calculation info from current trip
  OldTripList := TTripList.Create;
  OldTripList.Assign(FixedTripList);

  // ProcessOptions only needed for Creating Locations
  ProcessOptions := TProcessOptions.Create;
  ProcessOptions.TripModel := FixedTripList.TripModel;

  // Source locations
  OldLocations := TmLocations(OldTripList.GetItem('mLocations'));
  if not Assigned(OldLocations) then
    exit;

  // New locations
  NewLocations := TmLocations(FixedTripList.GetItem('mLocations'));
  if not Assigned(NewLocations) then
    exit;
  NewLocations.Clear;

  RoutePointList := TList<TLocation>.Create;
  try
    AddedShape := 0;
    RoutePt := -1;
    OldLocations.GetRoutePoints(RoutePointList);
    for Index := 0 to LbLog.Items.Count -1 do
    begin
      if (LbLog.Checked[Index]) and
         (RoutePt >= 0) then
      begin
        if not (Assigned(LbLog.Items.Objects[Index])) then
          continue;
        if (LbLog.Items.Objects[Index] is TXmlVSNode) then
        begin
          CoordGpx.FromAttributes(TXmlVSNode(LbLog.Items.Objects[Index]).AttributeList);
          NewLat := CoordGpx.Lat;
          NewLon := CoordGpx.Lon;
        end
        else if (LbLog.Items.Objects[Index] is TUdbDir) then
        begin
          NewLat := TUdbDir(LbLog.Items.Objects[Index]).Lat;
          NewLon := TUdbDir(LbLog.Items.Objects[Index]).Lon
        end
        else
          continue;

        Inc(AddedShape);
        ShapeName := Format('%s_%d', [RoutePointList[RoutePt].LocationTmName.AsString, AddedShape]);
        ShapeCmt := Format('%s, %s', [FormatFloat('##0.00000', NewLat, FormatSettings),
                                      FormatFloat('##0.00000', NewLon, FormatSettings)]);

        FixedTripList.AddLocation(NewLocations,
                                ProcessOptions,
                                TRoutePoint.rpShaping,
                                TRoutePreference.rmNA,
                                TAdvlevel.advNA,
                                NewLat, NewLon,
                                0, // Departure date
                                ShapeName,
                                ShapeCmt);
        continue;
      end;

      if (ContainsText(LbLog.Items[Index], CheckSeg)) and
         (LbLog.items.Objects[Index] is TUdbDir) then
      begin
        AnUdbDir := LbLog.Items.Objects[Index] as TUdbDir;
        if (AnUdbDir.UdbDirValue.SubClass.PointType <> $03) then
          continue;
        Inc(RoutePt);
        if (RoutePt >  RoutePointList.Count -1) then // Past end?
          break;

        AddedShape := 0;
        if (RoutePointList[RoutePt].IsViaPoint) then
          RoutePoint := TRoutePoint.rpVia
        else
          RoutePoint := TRoutePoint.rpShaping;

        FixedTripList.AddLocation(NewLocations,
                                ProcessOptions,
                                RoutePoint,
                                RoutePointList[RoutePt].RoutePref,
                                RoutePointList[RoutePt].AdvLevel,
                                AnUdbDir.Lat, AnUdbDir.Lon,
                                TUnixDate.CardinalAsDateTime(RoutePointList[RoutePt].LocationTmArrival.AsUnixDateTime),
                                RoutePointList[RoutePt].LocationTmName.AsString,
                                RoutePointList[RoutePt].LocationTmAddress.AsString);
      end;
    end;
    FixedTripList.ForceRecalc;

  finally
    RoutePointList.Free;
    ProcessOptions.Free;
    OldTripList.Free;
  end;
end;

procedure TFrmShowLog.BtnFixedGpxClick(Sender: TObject);
begin
  FixTripList;

  SaveTrip.Filter := '*.gpx|*.gpx';
  SaveTrip.InitialDir := ExtractFilePath(CompareGpx);
  SaveTrip.FileName := TmTripName(FrmTripEditor.CurTripList.GetItem('mTripName')).AsString +  '.gpx';
  if not SaveTrip.Execute then
    exit;

  FrmTripEditor.CurTripList.SaveAsGPX(SaveTrip.FileName, false);
  Close;
end;

procedure TFrmShowLog.BtnFixedTripClick(Sender: TObject);
begin
  FixTripList;
  FrmTripEditor.Show;
  Close;
end;

procedure TFrmShowLog.BtnGpxClick(Sender: TObject);
begin
  SetCheck(GpxFile);
end;

procedure TFrmShowLog.ClearGpxRptList;
var
  Index: integer;
begin
  for Index := 0 to GpxRptList.Count -1 do
  begin
    if (GpxRptList[Index] <> nil) and
       (TObject(GpxRptList[Index]) is TXmlVSNode) then
      TXmlVSNode(GpxRptList[Index]).Free;
  end;
  GpxRptList.Clear;
end;

procedure TFrmShowLog.ClearLog;
begin
  ClearGpxRptList;
  LbLog.Items.Clear;
end;

procedure TFrmShowLog.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmShowLog.FormCreate(Sender: TObject);
begin
  FStyleServices := TStyleManager.Style['Sapphire Kamri'];
  GpxRptList := TList.Create;
end;

procedure TFrmShowLog.FormDestroy(Sender: TObject);
begin
  ClearGpxRptList;
  GpxRptList.Free;
end;

procedure TFrmShowLog.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = Chr(VK_ESCAPE)) then
    Close;

  if (Key = ' ') and
     (LbLog.ItemIndex > -1) then
  begin
    LbLog.Checked[LbLog.ItemIndex] := not LbLog.Checked[LbLog.ItemIndex];
    Key := #0;
  end;
end;

procedure TFrmShowLog.FormShow(Sender: TObject);
begin
  LbLog.ItemIndex := 0;
  LbLogClick(LbLog);
end;

procedure TFrmShowLog.LbLogClick(Sender: TObject);
begin
  BtnTrip.Enabled := (LbLog.ItemIndex = 0) or
                     ContainsText(LbLog.Items[LbLog.ItemIndex], CheckSeg);
  BtnGpx.Enabled := BtnTrip.Enabled;
  if Assigned(FSyncTreeview) then
    FSyncTreeview(LbLog.Items.Objects[LbLog.ItemIndex]);
end;

procedure TFrmShowLog.LbLogDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  ACanvas: TCanvas;
  Flags: Longint;
begin
  ACanvas := TCheckListBox(Control).Canvas;

  if Assigned(FStyleServices) then
  begin
    if (odSelected in State) then
      ACanvas.Brush.Color := FStyleServices.GetStyleColor(scButtonPressed)
    else
      ACanvas.Brush.Color := FStyleServices.GetStyleColor(scListBox);

    if (ContainsText(TCheckListBox(Control).Items[Index], CheckSeg)) then
    begin
      ACanvas.Font.Style := [TFontStyle.fsBold];
      ACanvas.Font.Size := ACanvas.Font.Size + 2;
     end;
  end;

  Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
  with TCheckListBox(Control) do
    DrawText(ACanvas.Handle, Items[Index], Length(Items[Index]), Rect, Flags);
end;

end.
