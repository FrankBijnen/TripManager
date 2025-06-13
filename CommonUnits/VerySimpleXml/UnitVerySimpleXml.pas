unit UnitVerySimpleXml;

interface

// This unit enables us to enumerate the childnodes, even if they contain invalid NameSpaces!

uses Xml.VerySimple;

// Declare aliases. To Avoid ambiguity with MS names
type
  TXmlVSDocument = TXmlVerySimple;
  TXmlVSNode = TXmlNode;
  TXmlVSNodeType = TXmlNodeType;
  TXmlVSNodeTypes = TXmlNodeTypes;
  TXmlVSNodeList = TXmlNodeList;
  TXmlVSAttributeType = TXmlAttributeType;
  TXmlVSOptions = TXmlOptions;
  TXmlVSAttribute = TXmlAttribute;
  TXmlVSAttributeList = TXmlAttributeList;

function XMLPrefix(const AName: TXmlVSNode): string;
function FindSubNodeValue(ANode: TXmlVSNode; SubName: string): string;
function InitGarminGpx(GarminGPX: TXmlVSDocument): TXmlVSNode;

implementation

function XMLPrefix(const AName: TXmlVSNode): string;
var P: Integer;
begin
  result := '';
  P := Pos(':', AName.NodeName);
  if (P > 1) then
    result := Copy(AName.NodeName, 1, P);
end;

function FindSubNodeValue(ANode: TXmlVSNode; SubName: string): string;
var
  SubNode: TXmlVSNode;
begin
  Result := '';
  SubNode := ANode.Find(SubName);
  if (SubNode <> nil) then
  begin
    Result := SubNode.NodeValue;
    if (Result = '') and
       (SubNode.HasChildNodes) and
       (SubNode.FirstChild.NodeType = TXmlVSNodeType.ntCData) then
      Result := SubNode.FirstChild.NodeValue;
  end;
end;

function InitGarminGpx(GarminGPX: TXmlVSDocument): TXmlVSNode;
begin
  GarminGPX.Clear;
  GarminGPX.Encoding := 'utf-8';
  result := GarminGPX.AddChild('gpx', TXmlVSNodeType.ntDocument);
  result.SetAttribute('xmlns',       'http://www.topografix.com/GPX/1/1');
  result.SetAttribute('xmlns:gpxx',  'http://www.garmin.com/xmlschemas/GpxExtensions/v3');
  result.SetAttribute('xmlns:wptx1', 'http://www.garmin.com/xmlschemas/WaypointExtension/v1');
  result.SetAttribute('xmlns:ctx',   'http://www.garmin.com/xmlschemas/CreationTimeExtension/v1');
  result.SetAttribute('xmlns:trp',   'http://www.garmin.com/xmlschemas/TripExtensions/v1');

  result.SetAttribute('creator', 'TDBWare');
  result.SetAttribute('version', '1.1');
end;

end.
