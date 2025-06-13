unit UFrmPostProcess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList, Vcl.ImgList;

type
  TFrmPostProcess = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BtnOK: TBitBtn;
    PnlBegin: TPanel;
    PnlBeginCaption: TPanel;
    ImgListSymbols: TImageList;
    PnlBeginData: TPanel;
    EdBeginStr: TEdit;
    CmbBeginSymbol: TComboBoxEx;
    PnlEnd: TPanel;
    PnlEndCaption: TPanel;
    PnlEndData: TPanel;
    EdEndStr: TEdit;
    CmbEndSymbol: TComboBoxEx;
    ChkProcessBegin: TCheckBox;
    ChkProcessEnd: TCheckBox;
    PnlShape: TPanel;
    PnlShapeCaption: TPanel;
    ChkProcessShape: TCheckBox;
    PnlShapeData: TPanel;
    CmbShapingName: TComboBoxEx;
    MemoPostProcess: TMemo;
    CmbDistanceUnit: TComboBoxEx;
    PnlWaypt: TPanel;
    PnlWayptCaption: TPanel;
    ChkProcessWpt: TCheckBox;
    PnlWayptData: TPanel;
    CmbWayPtCat: TComboBoxEx;
    EdWptStr: TEdit;
    ChkBeginAddress: TCheckBox;
    ChkEndAddress: TCheckBox;
    ChkShapeAddress: TCheckBox;
    PnlVia: TPanel;
    PnlViaCaption: TPanel;
    ChkProcessVia: TCheckBox;
    PnlViaData: TPanel;
    EdViaPtStr: TEdit;
    EdViaPtChanged: TEdit;
    ChkViaAddress: TCheckBox;
    ChkWayPtAddress: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    SymbolsLoaded: boolean;
    procedure LoadSymbols;
    procedure SetPrefs;
    procedure StorePrefs;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPostProcess: TFrmPostProcess;

implementation

uses
  System.TypInfo, UnitRegistry, UnitStringUtils, UnitGpxObjects, UFrmAdvSettings;

{$R *.dfm}

const
  SymbolsDir = 'Symbols\24x24';
  BooleanValues: array[boolean] of string = ('False', 'True');

procedure TFrmPostProcess.LoadSymbols;
var
  Fs: TSearchRec;
  Rc, ImgIndex: Integer;
  ABitMap: TBitmap;
  CbItem: TComboExItem;
  Dir, SymbolName: string;
  CrWait, CrNormal: HCURSOR;
begin
  if (SymbolsLoaded) then
    exit;

  CrWait := LoadCursor(0, IDC_WAIT);
  CrNormal := SetCursor(CrWait);
  try
    CmbBeginSymbol.ItemsEx.Clear;
    CmbEndSymbol.ItemsEx.Clear;

    ImgListSymbols.Clear;
    ImgListSymbols.Width := 24;
    ImgListSymbols.Height := 24;
    Dir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + SymbolsDir;
    Rc := FindFirst(Dir + '\*.bmp', faAnyFile - faDirectory, Fs);
    while (Rc = 0) do
    begin
      SymbolName := ChangeFileExt(Fs.Name, '');
      ABitMap := TBitmap.Create;
      ABitMap.LoadFromFile(Dir + '\' + Fs.Name);
      ABitMap.Transparent := true;
      ABitMap.TransparentMode := TTransparentMode.tmAuto;

      ImgIndex := ImgListSymbols.Add(ABitMap, nil);
      ABitMap.Free;

      CbItem := CmbBeginSymbol.ItemsEx.Add;
      CbItem.ImageIndex := ImgIndex;
      CbItem.Caption := SymbolName;

      CbItem := CmbEndSymbol.ItemsEx.Add;
      CbItem.ImageIndex := ImgIndex;
      CbItem.Caption := SymbolName;

      Rc := FindNext(Fs);
    end;
    FindClose(Fs);
    SymbolsLoaded := true;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmPostProcess.SetPrefs;
var
  WayPtList: TStringList;
  DefProcessOptions: TProcessOptions;
begin
  DefProcessOptions := TProcessOptions.Create;
  WayPtList := TStringList.Create;
  try
    WayPtList.Text := ProcessCategoryPick;
    ChkProcessBegin.Checked := GetRegistry(Reg_ProcessBegin, true);
    CmbBeginSymbol.ItemIndex := CmbBeginSymbol.Items.IndexOf(GetRegistry(Reg_BeginSymbol, DefProcessOptions.BeginSymbol));
    EdBeginStr.Text := GetRegistry(Reg_BeginStr, DefProcessOptions.BeginStr);
    ChkBeginAddress.Checked := GetRegistry(Reg_BeginAddress, false);

    ChkProcessEnd.Checked := GetRegistry(Reg_ProcessEnd, true);
    CmbEndSymbol.ItemIndex := CmbEndSymbol.Items.IndexOf(GetRegistry(Reg_EndSymbol, DefProcessOptions.EndSymbol));
    EdEndStr.Text := GetRegistry(Reg_EndStr, DefProcessOptions.EndStr);
    ChkEndAddress.Checked := GetRegistry(Reg_EndAddress, false);

    ChkProcessWpt.Checked := GetRegistry(Reg_ProcessWpt, true);
    CmbWayPtCat.ItemIndex := WayPtList.IndexOf(GetRegistry(Reg_ProcessCategory, WayPtList[WayPtList.Count -1]));
    ChkWayPtAddress.Checked := GetRegistry(Reg_WayPtAddress, false);

    ChkProcessVia.Checked := GetRegistry(Reg_ProcessVia, true);
    ChkViaAddress.Checked := GetRegistry(Reg_ViaAddress, false);

    ChkProcessShape.Checked := GetRegistry(Reg_ProcessShape, true);
    CmbShapingName.ItemIndex := GetEnumValue(TypeInfo(TShapingPointName),
      GetRegistry(Reg_ShapingName, GetEnumName(TypeInfo(TShapingPointName), Ord(DefProcessOptions.ShapingPointName))));
    CmbDistanceUnit.ItemIndex := GetEnumValue(TypeInfo(TDistanceUnit),
      GetRegistry(Reg_DistanceUnit, GetEnumName(TypeInfo(TDistanceUnit), Ord(DefProcessOptions.DistanceUnit))));
    ChkShapeAddress.Checked := GetRegistry(Reg_ShapeAddress, false);
  finally
    WayPtList.Free;
    DefProcessOptions.Free;
  end;
end;

procedure TFrmPostProcess.StorePrefs;
begin
  SetRegistry(Reg_ProcessBegin, ChkProcessBegin.Checked);
  SetRegistry(Reg_BeginSymbol, CmbBeginSymbol.Text);
  SetRegistry(Reg_BeginStr, EdBeginStr.Text);
  SetRegistry(Reg_BeginAddress, ChkBeginAddress.Checked);

  SetRegistry(Reg_ProcessEnd, ChkProcessEnd.Checked);
  SetRegistry(Reg_EndSymbol, CmbEndSymbol.Text);
  SetRegistry(Reg_EndStr, EdEndStr.Text);
  SetRegistry(Reg_EndAddress, ChkEndAddress.Checked);

  SetRegistry(Reg_ProcessWpt, ChkProcessWpt.Checked);
  SetRegistry(Reg_ProcessCategory, CmbWayPtCat.Text);
  SetRegistry(Reg_WayPtAddress, ChkWayPtAddress.Checked);

  SetRegistry(Reg_ProcessVia, ChkProcessVia.Checked);
  SetRegistry(Reg_ViaAddress, ChkViaAddress.Checked);

  SetRegistry(Reg_ProcessShape, ChkProcessShape.Checked);
  SetRegistry(Reg_ShapingName, GetEnumName(TypeInfo(TShapingPointName), CmbShapingName.ItemIndex) );
  SetRegistry(Reg_DistanceUnit, GetEnumName(TypeInfo(TDistanceUnit), CmbDistanceUnit.ItemIndex) );
  SetRegistry(Reg_ShapeAddress, BooleanValues[ChkShapeAddress.Checked]);
end;

procedure TFrmPostProcess.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = ID_Ok then
    StorePrefs;
end;

procedure TFrmPostProcess.FormCreate(Sender: TObject);
begin
  CmbWayPtCat.Items.Text := ProcessCategoryPick;
  CmbShapingName.Items.Text := 'Unchanged' + #10 +
                               'Route_Sequence' + #10 +
                               'Route_Distance' + #10 +
                               'Sequence_Route' + #10 +
                               'Distance_Route';

  CmbDistanceUnit.Items.Text := 'Km' + #10 +
                                'Mile';

  SymbolsLoaded := false;
end;

procedure TFrmPostProcess.FormShow(Sender: TObject);
begin
  LoadSymbols;
  SetPrefs;
end;

end.

