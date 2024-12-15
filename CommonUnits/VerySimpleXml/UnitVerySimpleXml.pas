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

implementation

function XMLPrefix(const AName: TXmlVSNode): string;
var P: Integer;
begin
  result := '';
  P := Pos(':', AName.NodeName);
  if (P > 1) then
    result := Copy(AName.NodeName, 1, P);
end;

end.
