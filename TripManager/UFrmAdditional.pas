unit UFrmAdditional;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, System.ImageList, Vcl.ImgList,
  UnitGpxObjects;

type
  TFrmAdditional = class(TForm)
    PnlBot: TPanel;
    BtnCancel: TBitBtn;
    BitBtn2: TBitBtn;
    MemoPostProcess: TMemo;
    TvSelections: TTreeView;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TvSelectionsCheckStateChanging(Sender: TCustomTreeView; Node: TTreeNode; NewCheckState, OldCheckState: TNodeCheckState;
      var AllowChange: Boolean);
  private
    procedure SetPrefs;
    procedure StorePrefs;
    { Private declarations }
  public
    { Public declarations }
    Funcs: TGPXFuncArray;
  end;

var
  FrmAdditional: TFrmAdditional;

implementation

uses
  UnitStringUtils, UFrmAdvSettings;

{$R *.dfm}

procedure TFrmAdditional.SetPrefs;
begin
  TProcessOptions.SetPrefs(TvSelections, TripManagerReg_Key);
  TvSelections.Items[IdCompleteRoute].Enabled := false;
end;

procedure TFrmAdditional.StorePrefs;
begin
  Funcs := TProcessOptions.StorePrefs(TvSelections, TripManagerReg_Key);
end;

procedure TFrmAdditional.TvSelectionsCheckStateChanging(Sender: TCustomTreeView; Node: TTreeNode; NewCheckState,
  OldCheckState: TNodeCheckState; var AllowChange: Boolean);
begin
  AllowChange := Node.Enabled;
end;

procedure TFrmAdditional.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult = ID_Ok then
    StorePrefs;
end;

procedure TFrmAdditional.FormShow(Sender: TObject);
begin
  SetPrefs;
end;

end.

