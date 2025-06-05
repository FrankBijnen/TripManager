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
  System.TypInfo, UnitStringUtils, UnitGpxObjects, UFrmAdvSettings;

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
begin
  WayPtList := TStringList.Create;
  try
    WayPtList.Text := ProcessCategoryPick;
    ChkProcessBegin.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessBegin', BooleanValues[true]) = BooleanValues[true]);
    CmbBeginSymbol.ItemIndex := CmbBeginSymbol.Items.IndexOf(GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'BeginSymbol', 'Flag, Red'));
    EdBeginStr.Text := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'BeginStr', 'Begin');
    ChkBeginAddress.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'BeginAddress', BooleanValues[false]) = BooleanValues[true]);

    ChkProcessEnd.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessEnd', BooleanValues[true]) = BooleanValues[true]);
    CmbEndSymbol.ItemIndex := CmbEndSymbol.Items.IndexOf(GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'EndSymbol', 'Flag, Blue'));
    EdEndStr.Text := GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'EndStr', 'End');
    ChkEndAddress.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'EndAddress', BooleanValues[false]) = BooleanValues[true]);

    ChkProcessWpt.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessWpt', BooleanValues[true]) = BooleanValues[true]);
    CmbWayPtCat.ItemIndex := WayPtList.IndexOf(GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessCategory', WayPtList[WayPtList.Count -1]));
    ChkWayPtAddress.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'WayPtAddress', BooleanValues[false]) = BooleanValues[true]);

    ChkProcessVia.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessVia', BooleanValues[true]) = BooleanValues[true]);
    ChkViaAddress.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ViaAddress', BooleanValues[false]) = BooleanValues[true]);

    ChkProcessShape.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessShape', BooleanValues[true]) = BooleanValues[true]);
    CmbShapingName.ItemIndex := GetEnumValue(TypeInfo(TShapingPointName),
                                  GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ShapingName', 'Route_Distance'));
    CmbDistanceUnit.ItemIndex := GetEnumValue(TypeInfo(TDistanceUnit),
                                   GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'DistanceUnit', 'duKm'));
    ChkShapeAddress.Checked := (GetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ShapeAddress', BooleanValues[false]) = BooleanValues[true]);
  finally
    WayPtList.Free;
  end;
end;

procedure TFrmPostProcess.StorePrefs;
begin
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessBegin', BooleanValues[ChkProcessBegin.Checked]);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'BeginSymbol', CmbBeginSymbol.Text);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'BeginStr', EdBeginStr.Text);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'BeginAddress', BooleanValues[ChkBeginAddress.Checked]);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessEnd', BooleanValues[ChkProcessEnd.Checked]);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'EndSymbol', CmbEndSymbol.Text);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'EndStr', EdEndStr.Text);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'EndAddress', BooleanValues[ChkEndAddress.Checked]);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessWpt', BooleanValues[ChkProcessWpt.Checked]);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessCategory', CmbWayPtCat.Text);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'WayPtAddress', BooleanValues[ChkWayPtAddress.Checked]);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessVia', BooleanValues[ChkProcessVia.Checked]);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ViaAddress', BooleanValues[ChkViaAddress.Checked]);

  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ProcessShape', BooleanValues[ChkProcessShape.Checked]);
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ShapingName', GetEnumName(TypeInfo(TShapingPointName), CmbShapingName.ItemIndex) );
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'DistanceUnit', GetEnumName(TypeInfo(TDistanceUnit), CmbDistanceUnit.ItemIndex) );
  SetRegistryValue(HKEY_CURRENT_USER, TripManagerReg_Key, 'ShapeAddress', BooleanValues[ChkShapeAddress.Checked]);
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

