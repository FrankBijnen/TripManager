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
    FCoordinates : string;
    FPathName : string;
    FTrackName : string;
    FColor: string;
    FUseFolder: boolean;
    FKmlNode: IXMLDocumentType;
    FDocumentNode: IXMLNode;
    procedure NewKMLDocument;
    procedure WriteLineStyle(AStyle: IXMLNode; AColor: string = 'Magenta');
    procedure WriteStyle(AStyle: TStyleMap);
    procedure WriteStyleMap(Styles: array of TStyleMap);
    function WriteFolder(AName: string; ACoordinates: string): IXMLNode;
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
    property UseFolder: boolean read FUseFolder write FUseFolder;
  end;

const KML_StyleUrl = 'm_ylw-pushpin';
      Href = 'http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png';

implementation

uses
  Winapi.ShellAPI, WinApi.Windows,
  UnitStringUtils;

function KMLColor(GPXColor: string): string;
var
  HTMLColor: string;
begin
  HTMLColor := GPX2HTMLColor(GPXColor);
  result := Format('ff%s%s%s', [Copy(HTMLColor, 5,2), Copy(HTMLColor, 3, 2), Copy(HTMLColor, 1, 2)]);
end;

function AddTypedNode(AParent: IXMLNode; AName: string; SomeType: TXMLNodeClass): IXMLNode;
begin
  result := (AParent as IXMLNodeAccess).AddChild(AName, TargetNamespace, SomeType);
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
  Style := AddTypedNode(FDocumentNode, 'Style', TXMLStyleType);
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
  StyleMap := AddTypedNode(FDocumentNode, 'StyleMap', TXMLStyleMapType);
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
  SetLength(FCoordinates, 0);
end;

procedure TKMLHelper.WritePoint(const ALon, ALat, AEle: string);
begin
  FCoordinates := FCoordinates + Format('%s,%s,%s ', [ALon, ALat, AEle]);
end;

function TKMLHelper.WriteFolder(AName: string; ACoordinates: string): IXMLNode;
var
  PlaceMark     : IXMLNode;
  LineString    : IXMLNode;
begin
  result := FDocumentNode;
  if (FUseFolder) then
  begin
    result := AddTypedNode(FDocumentNode, 'Folder', TXMLFolderType);
    with result as IXMLFolderType do
      Name := AName;
  end;

  PlaceMark := AddTypedNode(result, 'Placemark', TXMLPlacemarkType);
  with PlaceMark as IXMLPlacemarkType do
  begin
    Name := Format('Track %s', [AName]);
    WriteLineStyle(AddTypedNode(PlaceMark, 'Style', TXMLStyleType), FColor);
    LineString := AddTypedNode(PlaceMark, 'LineString', TXMLLineStringType);
    with LineString as IXMLLineStringType do
      Coordinates := ACoordinates;
  end;
end;

function TKMLHelper.WritePointsEnd: IXMLNode;
begin
  Result := WriteFolder(FTrackName, FCoordinates);
  SetLength(FCoordinates, 0)
end;

function TKMLHelper.WritePlacesStart(AName: string): IXMLNode;
begin
  Result := AddTypedNode(FDocumentNode, 'Folder', TXMLFolderType);
  with Result as IXMLFolderType do
    Name := AName;
end;

procedure TKMLHelper.WritePlace(AFolder: IXMLNode;
                                ACoordinates: string;
                                AName: string;
                                ADescription: string = '');
var
  PlaceMark : IXMLNode;
  Point     : IXMLNode;
begin
  PlaceMark := AddTypedNode(AFolder, 'Placemark', TXMLPlacemarkType);
  with PlaceMark as IXMLPlacemarkType do
  begin
    Name := AName;
    Description := ADescription;
    Point := AddTypedNode(PlaceMark, 'Point', TXMLPointType);
    with Point as IXMLPointType do
      Coordinates := ACoordinates
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

procedure TKMLHelper.NewKMLDocument;
begin
  FKmlNode := NewXMLDocument.GetDocBinding('kml', TXMLDocumentType, TargetNamespace) as IXMLDocumentType;
  FDocumentNode := FKmlNode.AddChild('Document');
  FDocumentNode.AddChild('name').NodeValue := ChangeFileExt(ExtractFileName(FPathName), '');
end;

constructor TKMLHelper.Create(APathName: string);
begin
  inherited Create;

  FUseFolder := true;
  FPathName := APathName;
  NewKMLDocument;
end;

destructor TKMLHelper.Destroy;
begin
  FKmlNode := nil;
  FDocumentNode := nil;
  FPathName := '';

  inherited Destroy;
end;

procedure TKMLHelper.WriteKml;
var
  XmL: IXMLDocument;
  Kml: IXMLNode;
begin
  // Create a Document. UTF-8 and formatted.
  XML := NewXMLDocument;

  // Add Kml node
  Kml := LoadXMLData(FKmlNode.XML).Node;
  if (Kml.ChildNodes.Count > 0) then
    XML.ChildNodes.Add(Kml.ChildNodes[0]);

  // Format XML. Option?
  Xml.Xml.Text := FormatXMLData(Xml.XML.Text);
  Xml.Active := true;

  XML.Encoding := 'utf-8';
  XML.Options := [doNodeAutoIndent];
  XML.ParseOptions := [poPreserveWhiteSpace];

  // Save
  Xml.SaveToFile(FPathName);
end;

end.
