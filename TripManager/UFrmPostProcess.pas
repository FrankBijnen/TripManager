unit UFrmPostProcess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList, Vcl.ImgList;

type
  TFrmPostProcess = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BitBtn2: TBitBtn;
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
    CmbShapingName: TComboBox;
    MemoPostProcess: TMemo;
    CmbDistanceUnit: TComboBox;
    PnlWaypt: TPanel;
    PnlWayptCaption: TPanel;
    ChkProcessWpt: TCheckBox;
    PnlWayptData: TPanel;
    CmbWayPtCat: TComboBox;
    EdWptStr: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    SymbolsLoaded: boolean;
    procedure LoadSymbols;
    procedure SetFixedPrefs;
    procedure SetPrefs;
    procedure StorePrefs;
    { Private declarations }
  public
    { Public declarations }
    procedure SetPreferences;
  end;

var
  FrmPostProcess: TFrmPostProcess;

implementation

uses
  System.TypInfo, UnitStringUtils, UnitGpx;

{$R *.dfm}

const
  RegKey = 'Software\TDBware\TripManager';
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
    CmbWayPtCat.Items.Text := ProcessCategoryPick;
    SymbolsLoaded := true;
  finally
    SetCursor(CrNormal);
  end;
end;

procedure TFrmPostProcess.SetFixedPrefs;
begin
  EnableBalloon := false;
  EnableTimeout := false;
  TimeOut := 0;
  MaxTries := 0;
  DebugComments := 'False';

  ProcessSubClass := true;
  ProcessBegin := true;
  ProcessEnd := true;
  ProcessShape := true;
  ProcessViaPts := true;
end;

procedure TFrmPostProcess.SetPrefs;
var
  WayPtList: TStringList;
begin
  WayPtList := TStringList.Create;
  try
    WayPtList.Text := ProcessCategoryPick;
    ChkProcessBegin.Checked := (GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessBegin', BooleanValues[true]) = BooleanValues[true]);
    CmbBeginSymbol.ItemIndex := CmbBeginSymbol.Items.IndexOf(GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'BeginSymbol', 'Flag, Red'));
    EdBeginStr.Text := GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'BeginStr', 'Begin');

    ChkProcessEnd.Checked := (GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessEnd', BooleanValues[true]) = BooleanValues[true]);
    CmbEndSymbol.ItemIndex := CmbEndSymbol.Items.IndexOf(GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'EndSymbol', 'Flag, Blue'));
    EdEndStr.Text := GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'EndStr', 'End');

    ChkProcessWpt.Checked := (GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessWpt', BooleanValues[true]) = BooleanValues[true]);
    CmbWayPtCat.ItemIndex := WayPtList.IndexOf(GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessCategory',
                                                       WayPtList[WayPtList.Count -1]));

    ChkProcessShape.Checked := (GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessShape', BooleanValues[true]) = BooleanValues[true]);
    CmbShapingName.ItemIndex := GetEnumValue(TypeInfo(TShapingPointName),
                                    GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ShapingName', 'Route_Distance'));

    CmbDistanceUnit.ItemIndex := GetEnumValue(TypeInfo(TDistanceUnit),
                                    GetRegistryValue(HKEY_CURRENT_USER, RegKey, 'DistanceUnit', 'duKm'));
  finally
    WayPtList.Free;
  end;
end;

procedure TFrmPostProcess.StorePrefs;
begin
  ProcessBegin := ChkProcessBegin.Checked;
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessBegin', BooleanValues[ProcessBegin]);
  BeginSymbol := CmbBeginSymbol.Text;
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'BeginSymbol', BeginSymbol);
  BeginStr := EdBeginStr.Text;
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'BeginStr', BeginStr);

  ProcessEnd := ChkProcessEnd.Checked;
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessEnd', BooleanValues[ProcessEnd]);
  EndSymbol := CmbEndSymbol.Text;
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'EndSymbol', EndSymbol);
  EndStr := EdEndStr.Text;
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'EndStr', EndStr);

  ProcessCategory := [];
  if (ChkProcessWpt.Checked) then
  begin
    case CmbWayPtCat.ItemIndex of
      1: Include(ProcessCategory, pcSymbol);
      2: Include(ProcessCategory, pcGPX);
      3: begin
           Include(ProcessCategory, pcSymbol);
           Include(ProcessCategory, pcGPX);
          end;
    end;
  end;
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessWpt', BooleanValues[ChkProcessWpt.Checked]);
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessCategory', CmbWayPtCat.Text);

  ProcessShape := ChkProcessShape.Checked;
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ProcessShape', BooleanValues[ProcessShape]);
  ShapingPointName := TShapingPointName(CmbShapingName.ItemIndex);
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'ShapingName', GetEnumName(TypeInfo(TShapingPointName), CmbShapingName.ItemIndex) );

  DistanceUnit := TDistanceUnit(CmbDistanceUnit.ItemIndex);
  SetRegistryValue(HKEY_CURRENT_USER, RegKey, 'DistanceUnit', GetEnumName(TypeInfo(TDistanceUnit), CmbDistanceUnit.ItemIndex) );
end;

procedure TFrmPostProcess.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = ID_Ok then
    StorePrefs;
end;

procedure TFrmPostProcess.FormCreate(Sender: TObject);
begin
  SymbolsLoaded := false;
end;

procedure TFrmPostProcess.FormShow(Sender: TObject);
begin
  LoadSymbols;
  SetFixedPrefs;
  SetPrefs;
end;

procedure TFrmPostProcess.SetPreferences;
begin
  SetFixedPrefs;
  SetPrefs;
end;

end.

