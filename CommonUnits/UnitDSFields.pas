unit UnitDSFields;

interface

uses System.Classes, Vcl.DBCtrls, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Data.DB, hotspot;

type

  THelpNotify = procedure(Sender: TField) of object;

  TCanvasPanel = class(TPanel)
  public
    property Canvas;
  end;

  TDSFields = class
    FDataSource: TDataSource;
    FTag: integer;
    FOwnerPanel: TPanel;
    FLabelPanel: TCanvasPanel;
    FFieldsPanel: TPanel;
    FNewTop: integer;
    FHelpNotify: THelpNotify;
  private
    procedure LabelClick(Sender: Tobject);
    procedure AddLabel(AField: TField);
    procedure AddCheck(AField: TField);
    procedure AddEdit(AField: TField);
    procedure AddLookupCombo(AField: TField);
    function MinLabelWidth: integer;
    procedure AddPanels;
    procedure AddTableFields;
    procedure FieldsResize(Sender: Tobject);
  public
    constructor Create(AOwner: TPanel; ADataSource: TDataSource; ATag: integer = -1);
    destructor Destroy; override;
    property DataSource: TDataSource read FDataSource write FDataSource;
    property OwnerPanel: TPanel read FOwnerPanel write FOwnerPanel;
    property LabelPanel: TCanvasPanel read FLabelPanel write FLabelPanel;
    property FieldsPanel: TPanel read FFieldsPanel write FFieldsPanel;
    property HelpNotify: THelpNotify read FHelpNotify write FHelpNotify;
  end;

implementation

const ControlHeight   = 25;
      ControlMargin   = 10;
      NonStringWidth  = 80;
      ControlSpace    = 5;

constructor TDSFields.Create(AOwner: TPanel; ADataSource: TDataSource; ATag: integer = -1);
begin
  inherited Create;
  FDataSource := ADataSource;
  FTag := ATag;
  FOwnerPanel := AOwner;
  AddTableFields;
end;

destructor TDSFields.Destroy;
begin
  inherited;
end;

procedure TDSFields.LabelClick(Sender: Tobject);
begin
  if Assigned(FHelpNotify) and
     Assigned(FDataSource) and
     Assigned(FDataSource.DataSet) then
    FHelpNotify(FDataSource.DataSet.Fields[TControl(Sender).Tag]);
end;

procedure TDSFields.AddLabel(AField: TField);
begin
  with THotLabel.Create(LabelPanel) do
  begin
    Parent := LabelPanel;
    AutoSize := false;
    Alignment := taRightJustify;
    Left := 0;
    Top := FNewTop + ControlSpace;
    Height := ControlHeight;
    Width := Parent.Width - ControlMargin;
    Caption := AField.DisplayLabel;
    Tag := Afield.Index;
    OnClick := LabelClick;
  end;
end;

procedure TDSFields.AddCheck(AField: TField);
begin
  with TDBCheckBox.Create(FieldsPanel) do
  begin
    Parent := FieldsPanel;
    Left := ControlMargin;
    Top := FNewTop;
    Height := ControlHeight;
    Width := NonStringWidth;
    DataSource := FDataSource;
    DataField := AField.FieldName;
    ReadOnly := AField.ReadOnly;
    Tag := Afield.Index;
  end;
end;

procedure TDSFields.AddEdit(AField: TField);
begin
  with TDBEdit.Create(FieldsPanel) do
  begin
    Parent := FieldsPanel;
    AutoSize := false;
    Left := ControlMargin;
    Top := FNewTop;
    Height := ControlHeight;
    if (AField is TStringField) then
      Width := Parent.Width - (ControlMargin * 2)
    else
      Width := NonStringWidth;
    AlignWithMargins := true;
    DataSource := FDataSource;
    DataField := AField.FieldName;
    ReadOnly := AField.ReadOnly;
    Tag := Afield.Index;
  end;
end;

procedure TDSFields.AddLookupCombo(AField: TField);
begin
  with TDBLookupComboBox.Create(FieldsPanel) do
  begin
    Parent := FieldsPanel;
    Left := ControlMargin;
    Top := FNewTop;
    Height := ControlHeight;
    if (AField is TStringField) then
      Width := Parent.Width - (ControlMargin * 2)
    else
      Width := NonStringWidth;
    AlignWithMargins := true;
    DataSource := FDataSource;
    DataField := AField.FieldName;
    ReadOnly := AField.ReadOnly;
    Tag := Afield.Index;
  end;
end;

procedure TDSFields.AddTableFields;
var AField: TField;
begin
  AddPanels;

  FNewTop := ControlMargin;
  for AField in FDataSource.DataSet.Fields do
  begin
    if (FTag <> -1) and
       (AField.Tag <> FTag) then
      continue;
    if (AField.Visible = false) then
      continue;
    if (Afield.FieldKind = TFieldKind.fkLookup) then
    begin
      AddLabel(AField);
      AddLookupCombo(AField);
      FNewTop := FNewTop + ControlHeight + ControlSpace;
      continue;
    end;
    if (Afield.FieldKind = TFieldKind.fkData) then
    begin
      AddLabel(AField);
      if (AField is TBooleanField) then
        AddCheck(AField)
      else
        AddEdit(AField);
      FNewTop := FNewTop + ControlHeight + ControlSpace;
      continue;
    end;
  end;
  FieldsPanel.Constraints.MinHeight := FNewTop + ControlHeight;
end;

function TDSFields.MinLabelWidth: integer;
var AField: TField;
    FieldWidth: integer;
begin
  Result := ControlMargin;
  for AField in FDataSource.DataSet.Fields do
  begin
    if (AField.Visible = false) then
      continue;
    FieldWidth := LabelPanel.Canvas.TextWidth(AField.DisplayLabel);
    if (result < FieldWidth + (ControlMargin * 2)) then
      Result := FieldWidth + (ControlMargin * 2);
  end;
end;

procedure TDSFields.FieldsResize(Sender: Tobject);
var Indx: integer;
    AControl : TControl;
    AField : TField;
begin
  for Indx := 0 to FieldsPanel.ControlCount -1 do
  begin
    AControl := FieldsPanel.Controls[Indx];
    if (AControl is TDBEdit) or
       (AControl is TDBLookupComboBox) then
    begin
      AField := FDataSource.DataSet.Fields[AControl.Tag];
      if (Afield is TStringField) then
         AControl.Width := FieldsPanel.Width - (ControlMargin * 2);
    end;
  end;
end;

procedure TDSFields.AddPanels;
begin
  LabelPanel := TCanvasPanel.Create(OwnerPanel);
  LabelPanel.Parent := OwnerPanel;
  LabelPanel.Width := MinLabelWidth;
  LabelPanel.Align := alLeft;

  FieldsPanel := TPanel.Create(OwnerPanel);
  FieldsPanel.Parent := OwnerPanel;
  FieldsPanel.Align := alClient;
  FieldsPanel.Constraints.MinWidth := NonStringWidth + (ControlMargin * 2);
  FieldsPanel.OnResize := FieldsResize;
end;

end.
