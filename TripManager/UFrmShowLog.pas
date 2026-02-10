unit UFrmShowLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.CheckLst,
  Vcl.Themes, Vcl.Menus;

type
  TFrmShowLog = class(TForm)
    PnlBot: TPanel;
    BtnClose: TBitBtn;
    LbLog: TCheckListBox;
    SaveTrip: TSaveDialog;
    PopupListBox: TPopupMenu;
    PreferTrip: TMenuItem;
    PreferGpx: TMenuItem;
    N1: TMenuItem;
    OpenFixedTrip: TMenuItem;
    SavefixedGPX: TMenuItem;
    BtnFixTrip: TButton;
    N2: TMenuItem;
    NextSegment: TMenuItem;
    PreviousSegment: TMenuItem;
    procedure BtnCloseClick(Sender: TObject);
    procedure LbLogClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LbLogDrawItem(Control: TWinControl; Index: Integer; Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure PreferTripClick(Sender: TObject);
    procedure PreferGpxClick(Sender: TObject);
    procedure OpenFixedTripClick(Sender: TObject);
    procedure SavefixedGPXClick(Sender: TObject);
    procedure BtnFixTripMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NextSegmentClick(Sender: TObject);
    procedure PreviousSegmentClick(Sender: TObject);
    procedure PopupListBoxPopup(Sender: TObject);
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
    procedure CoordinatesApplied(Sender: TObject; Coords: string);
  end;

var
  FrmShowLog: TFrmShowLog;

implementation

uses
  System.Types, System.StrUtils, system.Generics.Collections, System.UITypes,
  UnitGpxDefs, UnitGpxObjects, UnitTripDefs, UnitTripObjects, UnitGpxTripCompare,
  UFrmTripEditor,
  UnitVerySimpleXml, UnitProcessOptions, UnitStringUtils;

{$R *.dfm}

var
  FloatFormatSettings: TFormatSettings; // for FormatFloat -see Initialization

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

procedure TFrmShowLog.SavefixedGPXClick(Sender: TObject);
var
  ATripList: TTripList;
begin
  ATripList := TTripList(FrmTripEditor.CurTripList);
  FixTripList;

  SaveTrip.Filter := '*.gpx|*.gpx';
  SaveTrip.InitialDir := ExtractFilePath(CompareGpx);
  SaveTrip.FileName := Format('%s.gpx', [ATripList.TripName]);
  if not SaveTrip.Execute then
    exit;

  ATripList.SaveAsGPX(SaveTrip.FileName, false);
  Close;
end;

procedure TFrmShowLog.SetCheck(const FileType: string);
var
  Index, NextIndex: integer;
  PrevCoords, NextCoords, NewCoords: TCoords;
  SegmentOnly: boolean;
  ProcessOptions: TProcessOptions;
  AnUdbDir: TUdbDir;
begin
  if (LbLog.Items.Count < 2) then
    exit;

  PrevCoords := CoordsFromData(LbLog.Items.Objects[0]);
  for Index := LbLog.ItemIndex +1 downto 0 do
  begin
    if (ContainsText(LbLog.Items[Index], CheckSeg)) then
    begin
      PrevCoords := CoordsFromData(LbLog.Items.Objects[Index]);
      break;
    end;
  end;

  NextCoords := CoordsFromData(LbLog.Items.Objects[LbLog.Items.Count -1]);
  for Index := LbLog.ItemIndex +1 to LbLog.Items.Count -1 do
  begin
    if (ContainsText(LbLog.Items[Index], CheckSeg)) then
    begin
      NextCoords := CoordsFromData(LbLog.Items.Objects[Index]);
      break;
    end;
  end;

  ProcessOptions := TProcessOptions.Create;
  try
    SegmentOnly := (LbLog.ItemIndex > 1);
    for Index := LbLog.ItemIndex +1 to LbLog.Items.Count -1 do
    begin

      // A new segment
      if (ContainsText(LbLog.Items[Index], CheckSeg)) then
      begin
        if (SegmentOnly) then
          break;

        PrevCoords := CoordsFromData(LbLog.Items.Objects[Index]);
        NextCoords := CoordsFromData(LbLog.Items.Objects[LbLog.Items.Count -1]);
        for NextIndex := Index +1 to LbLog.Items.Count -1 do
        begin
          if (ContainsText(LbLog.Items[NextIndex], CheckSeg)) then
          begin
            NextCoords := CoordsFromData(LbLog.Items.Objects[NextIndex]);
        break;
          end;
        end;
      end;

      // Check Trip or GPX
      if not (ContainsText(LbLog.Items[Index], FileType)) then
      begin
        LbLog.Checked[Index] := false;
        continue;
      end;

      // Only want continue UDBDirs
      if (FileType = TripFile) then
      begin
        AnUdbDir := TUdbDir(LbLog.Items.Objects[Index]);
        if (AnUdbDir.UdbDirValue.SubClass.Direction <> 0) then
          continue;
      end;

      // Distance Check
      NewCoords := CoordsFromData(LbLog.Items.Objects[Index]);
      if (CoordDistance(NewCoords, PrevCoords, TDistanceUnit.duKm) < ProcessOptions.MinShapeDistKms) or
         (CoordDistance(NewCoords, NextCoords, TDistanceUnit.duKm) < ProcessOptions.MinShapeDistKms) then
        continue;

      PrevCoords := NewCoords;
      LbLog.Checked[Index] := true;
    end;
  finally
    ProcessOptions.Free;
  end;
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
  FixedTripList := TTripList(FrmTripEditor.CurTripList);

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

procedure TFrmShowLog.BtnFixTripMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Pt: TPoint;
begin
  Pt.X := X;
  Pt.Y := Y;
  Pt := TButton(Sender).ClientToScreen(Pt);
  PopupListBox.Popup(Pt.X, Pt.Y);
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
  FloatFormatSettings.ThousandSeparator := ',';
  FloatFormatSettings.DecimalSeparator := '.';
  FStyleServices := TStyleManager.ActiveStyle;
  GpxRptList := TList.Create;
end;

procedure TFrmShowLog.FormDestroy(Sender: TObject);
begin
  ClearGpxRptList;
  GpxRptList.Free;
end;

procedure TFrmShowLog.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (ssAlt in Shift) then
  begin
    case Key of
      VK_DOWN:
        begin
          Key := 0;
          NextSegmentClick(NextSegment);
        end;
      VK_UP:
        begin
          Key := 0;
          PreviousSegmentClick(PreviousSegment);
        end;
    end;
  end;
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
  try
    if Assigned(FSyncTreeview) then
      FSyncTreeview(LbLog.Items.Objects[LbLog.ItemIndex]);
  except
    MessageDlg('Could not reposition in Trip file.', TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
  end;
end;

procedure TFrmShowLog.CoordinatesApplied(Sender: TObject; Coords: string);
var
  Index: integer;
  Lat, Lon: string;
begin
  Index := LbLog.ItemIndex;
  if (Index < 0) and
     (Index > LbLog.Items.Count -1) then
    exit;
  if (LbLog.Header[Index]) then
    exit;

  LbLog.Checked[Index] := true;

  ParseLatLon(Coords, Lat, Lon);

  if (LbLog.Items.Objects[Index] is TXmlVSNode) then
  begin
    TXmlVSNode(LbLog.Items.Objects[Index]).Attributes['lat'] := Lat;
    TXmlVSNode(LbLog.Items.Objects[Index]).Attributes['lon'] := Lon;
    LbLog.Items[Index] := Format('     %s: New Coordinates: %s', [GpxFile, Coords]);
  end
  else if (LbLog.Items.Objects[Index] is TUdbDir) then
  begin
    TUdbDir(LbLog.Items.Objects[Index]).Lat := StrToFloat(Lat, FloatFormatSettings);
    TUdbDir(LbLog.Items.Objects[Index]).Lon := StrToFloat(Lon, FloatFormatSettings);
    LbLog.Items[Index] := Format('    %s: New Coordinates: %s', [TripFile, Coords]);
  end;
end;

procedure TFrmShowLog.OpenFixedTripClick(Sender: TObject);
begin
  FixTripList;
  FrmTripEditor.Show;
  Close;
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

procedure TFrmShowLog.NextSegmentClick(Sender: TObject);
var
  Index: integer;
begin
  Index := LbLog.ItemIndex + 1;
  if (Index > LbLog.Items.Count -1) then
    exit;
  while (Index < LbLog.Items.Count -1) and
        (not ContainsText(LbLog.Items[Index], CheckSeg)) do
    Inc(Index);
  LbLog.ItemIndex := Index;
  LbLogClick(LbLog);
end;

procedure TFrmShowLog.PreviousSegmentClick(Sender: TObject);
var
  Index: integer;
begin
  Index := LbLog.ItemIndex - 1;
  if (Index < 0) then
    exit;
  while (Index > 0) and
        (not ContainsText(LbLog.Items[Index], CheckSeg)) do
    Dec(Index);
  LbLog.ItemIndex := Index;
  LbLogClick(LbLog);
end;

procedure TFrmShowLog.PopupListBoxPopup(Sender: TObject);
begin
  PreferTrip.Enabled := (LbLog.ItemIndex = 0) or
                        ContainsText(LbLog.Items[LbLog.ItemIndex], CheckSeg);
  PreferGpx.Enabled := PreferTrip.Enabled;

  PreviousSegment.ShortCut := TextToShortCut('Alt+Up'); // Tshortcut(32806);
  NextSegment.ShortCut := TextToShortCut('Alt+Down'); //Tshortcut(32808);
end;

procedure TFrmShowLog.PreferGpxClick(Sender: TObject);
begin
  SetCheck(GpxFile);
end;

procedure TFrmShowLog.PreferTripClick(Sender: TObject);
begin
  SetCheck(TripFile);
end;

end.
