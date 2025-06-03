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

function FindSubNodeValue(ANode: TXmlVSNode; SubName: string): string;
function XMLPrefix(const AName: TXmlVSNode): string;

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

end.
