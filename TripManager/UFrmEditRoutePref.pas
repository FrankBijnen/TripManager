unit UFrmEditRoutePref;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ValEdit, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TFrmEditRoutePref = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BtnOK: TBitBtn;
    VlRoutePrefs: TValueListEditor;
    procedure VlRoutePrefsGetPickList(Sender: TObject; const KeyName: string; Values: TStrings);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure VlRoutePrefsStringsChange(Sender: TObject);
  private
    { Private declarations }
    PickList: TStringList;
  public
    { Public declarations }
    VlModified: boolean;
    CurTripList: TObject;
  end;

var
  FrmEditRoutePref: TFrmEditRoutePref;

implementation

uses
  System.Generics.Collections,
  UnitProcessOptions, UnitTripDefs, UnitTripObjects;

{$R *.dfm}

procedure TFrmEditRoutePref.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Locations: TmLocations;
  Location: TLocation;
  RoutePointList : TList<TLocation>;
  ViaPt: integer;
  ARoutePref: string;
  LookUp: integer;
  ProcessOptions: TProcessOptions;
begin
  if (ModalResult <> IDOK) then
    exit;

  ProcessOptions := TProcessOptions.Create;
  RoutePointList := TList<TLocation>.Create;
  try
    Locations := TTripList(CurTripList).GetItem(TmLocations.GetKey) as TmLocations;
    for ViaPt := 1 to Locations.ViaPointCount -1 do
    begin
      Locations.GetSegmentPoints(ViaPt, RoutePointList);
      Location := RoutePointList[0];
      Location.RoutePref := TRoutePreference.rmFasterTime;
      Location.AdvLevel := TAdvlevel.advNA;

      ARoutePref := VlRoutePrefs.Strings.ValueFromIndex[ViaPt -1];
      LookUp := PickList.IndexOf(ARoutePref);
      if (LookUp > -1) then
      begin
        Location.RoutePref := TRoutePreference(Hi(Word(PickList.Objects[LookUp])));
        if (Location.RoutePref = TRoutePreference.rmAdventurous) then
          Location.AdvLevel := TAdvlevel(Lo(Word(PickList.Objects[LookUp])))
        else
          Location.AdvLevel := TAdvlevel.advNA;
      end;
    end;
    TTripList(CurTripList).SetSegmentRoutePrefs(Locations, ProcessOptions);
  finally
    RoutePointList.Free;
    ProcessOptions.Free;
  end;
end;

procedure TFrmEditRoutePref.FormCreate(Sender: TObject);
var
  Index: integer;
  ARoutePref, ARoutePrefAdv: TRoutePrefRec;
  W: word;
begin
  PickList := TStringList.Create;

  // Basic CalcModes Faster, Short, Straight
  for ARoutePref in RoutePrefRecs do
  begin
    if (ARoutePref.Sel = false) then
      continue;

    W := (Ord(ARoutePref.Rm) shl 8) + Ord(TAdvlevel.advNA);
    PickList.AddObject(ARoutePref.Desc, TObject(W));
  end;

  // Adventurous
  ARoutePrefAdv := RoutePrefRecs[cmAdventurous];
  for Index := MinAdvLevelUserConfig to High(AdvLevelMap) do
  begin
    W := (Ord(ARoutePrefAdv.Rm) shl 8)  + AdvLevelMap[Index].Value;
    PickList.AddObject(ARoutePrefAdv.Desc + ' ' + AdvLevelMap[Index].Name, TObject(W));
  end;
end;

procedure TFrmEditRoutePref.FormDestroy(Sender: TObject);
begin
  PickList.Free;
end;

procedure TFrmEditRoutePref.FormShow(Sender: TObject);
var
  Locations: TmLocations;
  Location: TLocation;
  RoutePointList : TList<TLocation>;
  ViaPt: integer;
  RoutePreference, AdventurousLevel, FormatString: string;
begin
  RoutePointList := TList<TLocation>.Create;
  VlRoutePrefs.Strings.BeginUpdate;
  try
    VlRoutePrefs.Strings.Clear;
    Locations := TTripList(CurTripList).GetItem(TmLocations.GetKey) as TmLocations;
    for ViaPt := 1 to Locations.ViaPointCount do
    begin
      Locations.GetSegmentPoints(ViaPt, RoutePointList);
      Location := RoutePointList[0];
      RoutePreference := RoutePref2Desc(Location.RoutePref, TTripList(CurTripList).TripModel);
      FormatString := '%s';
      AdventurousLevel := '';
      if (Location.RoutePref = TRoutePreference.rmAdventurous) then
      begin
        IntToIdent(Ord(Location.AdvLevel), AdventurousLevel, AdvLevelMap);
        FormatString := '%s %s';
      end;
      VlRoutePrefs.Strings.AddPair(Location.LocationTmName.AsString, Format(FormatString, [RoutePreference, AdventurousLevel]));
    end;
  finally
    RoutePointList.free;
    VlRoutePrefs.Strings.EndUpdate;
    VlModified := false;
  end;
end;

procedure TFrmEditRoutePref.VlRoutePrefsGetPickList(Sender: TObject; const KeyName: string; Values: TStrings);
begin
  Values.Assign(PickList);
end;

procedure TFrmEditRoutePref.VlRoutePrefsStringsChange(Sender: TObject);
begin
  VlModified := true;
end;

end.
