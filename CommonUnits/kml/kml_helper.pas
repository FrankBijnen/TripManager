unit kml_helper;

interface

uses System.Classes, System.SysUtils,
     Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc,
     ogckml23;

type
  TStyleMap = record
    Key:string;
    Style:string;
    Scale:double;
  public
    constructor Create(Akey, AStyle: string; AScale: double);
  end;

  TKMLHelper = class
    Coordinates : TStringList;
    FPathName : string;
    FTrackName : string;
    FColor: string;
    FNewDoc : IXMLDocumentType;
    function NewKMLDocument: IXMLDocumentType;
    procedure WriteLineStyle(AStyle: IXMLNode; AColor: string = 'Magenta');
    procedure WriteStyle(AStyle: TStyleMap);
    procedure WriteStyleMap(Styles: array of TStyleMap);
    function WriteFolder(AName:string; ACoordinates:string): IXMLNode;

    procedure WriteHeader(ARing:boolean = false);
    procedure WritePointsStart(const ATrackName, AColor: string);
    procedure WritePoint(const ALon, ALat, AEle: string);
    function WritePointsEnd: IXMLNode;
    function WritePlacesStart(AName: string): IXMLNode;
    procedure WritePlace(AFolder: IXMLNode;
                         ACoordinates: string;
                         AName: string;
                         ADescription: string = '');
    procedure WritePlacesEnd;
    procedure WriteFooter;
    procedure WriteKml;

  public
    var FormatSettings: TFormatSettings;
    constructor Create(APathName: string);
    destructor Destroy; override;
  end;

const KML_StyleUrl = 'm_ylw-pushpin';
      Href = 'http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png';

implementation

uses
  Winapi.ShellAPI, WinApi.Windows, UnitStringUtils;

function KMLColor(GPXColor: string): string;
var
  HTMLColor: string;
begin
  HTMLColor := GPX2HTMLColor(GPXColor);
  result := Format('ff%s%s%s', [Copy(HTMLColor, 5,2), Copy(HTMLColor, 3, 2), Copy(HTMLColor, 1, 2)]);
end;

function GetNodeAsType(ANewDoc: IXMLNode; Aname: string; SomeType: TXMLNodeClass): IXMLNode;
begin
  result := (ANewDoc as IXMLNodeAccess).AddChild(AName, TargetNamespace, SomeType);
end;

constructor TStyleMap.Create(Akey, AStyle: string; AScale: double);
begin
  Key   := Akey;
  Style := AStyle;
  Scale := Ascale;
end;

procedure TKMLHelper.WriteLineStyle(AStyle: IXMLNode; AColor: string = 'Magenta');
begin
  with AStyle as IXMLStyleType,
       LineStyle as IXMLLineStyleType do
  begin
    Color := KMLColor(AColor);
    Width := 3;
  end;
end;

procedure TKMLHelper.WriteStyle(AStyle: TStyleMap);
var Style: IXMLNode;
begin
  Style := GetNodeAsType(FNewDoc, 'Style', TXMLStyleType);
  with Style as IXMLStyleType do
  begin
    Id := Astyle.Style;
    with IconStyle as IXMLIconStyleType do
    begin
      Scale := AStyle.Scale;
      Icon.Href := Href;
      with HotSpot do
      begin
        X := 20;
        Y := 2;
        Xunits := 'pixels';
        Yunits := 'pixels';
      end;
    end;
    WriteLineStyle(Style);
  end;
end;

procedure TKMLHelper.WriteStyleMap(Styles:array of TStyleMap);
var StyleMap  : IXMLNode;
    Style     : TStyleMap;
begin
  StyleMap := GetNodeAsType(FNewDoc, 'StyleMap', TXMLStyleMapType);
  with StyleMap as IXMLStyleMapType do
  begin
    Id := KML_StyleUrl;
    for Style in Styles do
    begin
      with Pair.Add as IXMLPairType do
      begin
        key := Style.key;
        StyleUrl := Style.style;
      end;
    end;
  end;
end;

procedure TKMLHelper.WritePointsStart(const ATrackName, AColor: string);
begin
  FTrackName := ATrackName;
  FColor := AColor;
  Coordinates.Clear;
end;

procedure TKMLHelper.WritePoint(const ALon, ALat, AEle: string);
begin
  Coordinates.Add(Format('%s,%s,%s ',
                          [ALon, ALat, AEle]));
end;

function TKMLHelper.WriteFolder(AName:string; ACoordinates:string): IXMLNode;
var
  PlaceMark     : IXMLNode;
  MultiGeometry : IXMLNode;
  LineString    : IXMLNode;
begin
  result := GetNodeAsType(FNewDoc, 'Folder', TXMLFolderType);
  with result as IXMLFolderType do
  begin
    Name := AName;
    PlaceMark := GetNodeAsType(result, 'Placemark', TXMLPlacemarkType);
    with PlaceMark as IXMLPlacemarkType do
    begin
      Name := Format('Track %s', [AName]);
// Doesn't work with Google Maps
//      StyleUrl := '#'+ KML_StyleUrl;
      WriteLineStyle(GetNodeAsType(PlaceMark, 'Style', TXMLStyleType), FColor);
      MultiGeometry := GetNodeAsType(PlaceMark, 'MultiGeometry', TXMLMultiGeometryType);
      LineString := GetNodeAsType(MultiGeometry, 'LineString', TXMLLineStringType);
      with LineString as IXMLLineStringType do
        Coordinates := ACoordinates;
    end;
  end;
end;

function TKMLHelper.WritePointsEnd: IXMLNode;
begin
  Result := WriteFolder(FTrackName, Coordinates.Text);
  Coordinates.Clear;
end;

function TKMLHelper.WritePlacesStart(AName: string): IXMLNode;
begin
  Result := GetNodeAsType(FNewDoc, 'Folder', TXMLFolderType);
  with Result as IXMLFolderType do
  begin
    Name := AName;
  end;
end;

procedure TKMLHelper.WritePlace(AFolder: IXMLNode;
                                ACoordinates: string;
                                AName: string;
                                ADescription: string = '');
var
  PlaceMark : IXMLNode;
  Point     : IXMLNode;
begin
  PlaceMark := GetNodeAsType(AFolder, 'Placemark', TXMLPlacemarkType);
  with PlaceMark as IXMLPlacemarkType do
  begin
    Name := AName;
    Description := ADescription;
    Point := GetNodeAsType(PlaceMark, 'Point', TXMLPointType);
    with Point as IXMLPointType do
    begin
      Coordinates := ACoordinates
    end;
  end;
end;

procedure TKMLHelper.WritePlacesEnd;
begin
{}
end;

procedure TKMLHelper.WriteFooter;
begin
{}
end;

procedure TKMLHelper.WriteHeader(ARing:boolean = false);
var
  MyStyles  : array of TStyleMap;
  Style     : TStyleMap;
begin
  MyStyles := [TStyleMap.Create('normal', 's_ylw-pushpin', 1.1),
               TStyleMap.Create('highlight', 's_ylw-pushpin_hl', 1.3)];

  WriteStyleMap(MyStyles);

  for Style in MyStyles do
    WriteStyle(Style);

end;

function TKMLHelper.NewKMLDocument: IXMLDocumentType;
begin
  result := NewDocument;
  result.Name := ChangeFileExt(ExtractFileName(FPathName), '');
end;

constructor TKMLHelper.Create(APathName: string);
begin
  inherited Create;
  Coordinates := TStringList.Create;

  FPathName := APathName;
  FNewDoc := NewKMLDocument;
end;

destructor TKMLHelper.Destroy;
begin
  FNewDoc := nil;
  FPathName := '';
  Coordinates.Free;

  inherited Destroy;
end;

procedure TKMLHelper.WriteKml;
var
  XmL: IXMLDocument;
begin
  XmL := TXMLDocument.Create(nil);
  Xml.XML.Add(FNewDoc.XML);
  Xml.Active:=true;
  Xml.SaveToFile(FPathName);
end;

end.
