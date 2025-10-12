unit UFrmShowLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.CheckLst;

type
  TFrmShowLog = class(TForm)
    PnlBot: TPanel;
    BtnClose: TBitBtn;
    LbLog: TCheckListBox;
    procedure BtnCloseClick(Sender: TObject);
    procedure LbLogClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ClearGpxRptList;
  public
    { Public declarations }
    FSyncTreeview: TNotifyEvent;
    GpxRptList: Tlist;
    procedure ClearLog;
  end;

var
  FrmShowLog: TFrmShowLog;

implementation

uses
  UnitGpxObjects,
  UFrmSelectGPX,
  UnitVerySimpleXml;

{$R *.dfm}

procedure TFrmShowLog.ClearGpxRptList;
var
  Index: integer;
begin
  for Index := 0 to GpxRptList.Count -1 do
  begin
    if (GpxRptList[Index] <> nil) and
       (TObject(GpxRptList[Index]) is TXmlVSNode) then
      TXmlVSNode(GpxRptList[Index]).Free;
  end;
  GpxRptList.Clear;
end;

procedure TFrmShowLog.ClearLog;
begin
  ClearGpxRptList;
  LbLog.Items.Clear;
end;

procedure TFrmShowLog.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmShowLog.FormCreate(Sender: TObject);
begin
  GpxRptList := TList.Create;
end;

procedure TFrmShowLog.FormDestroy(Sender: TObject);
begin
  ClearGpxRptList;
  GpxRptList.Free;
end;

procedure TFrmShowLog.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = Chr(VK_ESCAPE)) then
    Close;
end;

procedure TFrmShowLog.LbLogClick(Sender: TObject);
begin
  if Assigned(FSyncTreeview) then
    FSyncTreeview(LbLog.Items.Objects[LbLog.ItemIndex]);
end;

end.
