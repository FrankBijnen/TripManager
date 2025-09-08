unit UfrmEditRoutePref;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ValEdit, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  UnitTripObjects;

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
    CurTripList: TTripList;
  end;

var
  FrmEditRoutePref: TFrmEditRoutePref;

implementation
uses
  System.Generics.Collections;

{$R *.dfm}

procedure TFrmEditRoutePref.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Locations: TmLocations;
  Location: TLocation;
  RoutePointList : TList<TLocation>;
  ViaPt: integer;
  ARoutePref: string;
  LookUp: integer;
begin
  if (ModalResult <> IDOK) then
    exit;

  RoutePointList := TList<TLocation>.Create;
  try
    Locations := CurTripList.GetItem('mLocations') as TmLocations;
    for ViaPt := 1 to Locations.ViaPointCount do
    begin
      Locations.GetRoutePoints(ViaPt, RoutePointList);
      Location := RoutePointList[0];
      Location.RoutePref := TRoutePreference.rmFasterTime;
      Location.AdvLevel := TAdvlevel.advNA;

      ARoutePref := VlRoutePrefs.Strings.ValueFromIndex[ViaPt -1];
      LookUp := PickList.IndexOf(ARoutePref);
      if (LookUp > -1) then
      begin
        Location.RoutePref := TRoutePreference(Hi(Word(PickList.Objects[LookUp])));
        Location.AdvLevel := TAdvlevel(Lo(Word(PickList.Objects[LookUp])));
      end;
    end;
    CurTripList.SetRoutePrefs_XT2_Tread2(Locations);
  finally
    RoutePointList.free;
  end;
end;

procedure TFrmEditRoutePref.FormCreate(Sender: TObject);
var
  Index: integer;
begin
  PickList := TStringList.Create;
  for Index := 0 to 2 do
    PickList.AddObject(RoutePreferenceMap[Index].Name,
                       TObject(RoutePreferenceMap[Index].Value shl 8) );
  for Index := 1 to 4 do
    PickList.AddObject(RoutePreferenceMap[3].Name + ' ' + AdvLevelMap[Index].Name,
                       TObject( (RoutePreferenceMap[3].Value shl 8) + AdvLevelMap[Index].Value) );
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
    Locations := CurTripList.GetItem('mLocations') as TmLocations;
    for ViaPt := 1 to Locations.ViaPointCount do
    begin
      Locations.GetRoutePoints(ViaPt, RoutePointList);
      Location := RoutePointList[0];
      if (IntToIdent(Ord(Location.RoutePref), RoutePreference, RoutePreferenceMap)) then
      begin
        FormatString := '%s%s';
        AdventurousLevel := '';
        if (Location.RoutePref = TRoutePreference.rmCurvyRoads) then
        begin
          if IntToIdent(Ord(Location.AdvLevel), AdventurousLevel, AdvLevelMap) then
            FormatString := '%s %s';
        end;
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
