unit UnitHotLabel;

interface

uses
  System.Classes,
  Winapi.Messages,
  Vcl.DBCtrls, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Graphics,
  Data.DB;

type

  THotLabel = class(TLabel)
  private
    FHilited: boolean;
    FHiliteColor: TColor;
    FOldColor: TColor;
    FHiliteCursor: TCursor;
    FOldCursor: TCursor;
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
  protected
    procedure MouseEntered(var AMessage: TMessage); message CM_MOUSEENTER;
    procedure MouseLeft(var AMessage: TMessage); message CM_MOUSELEAVE;
    procedure CMDialogChar(var AMessage: TCMDialogChar); message CM_DIALOGCHAR;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property HiliteColor: TColor read FHiliteColor write FHiliteColor default clRed;
    property HiliteCursor: TCursor read FHiliteCursor write FHiliteCursor default crHandPoint;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
  end;

implementation

uses
  System.SysUtils,
  Vcl.Menus;

{THotLabel}

function IsAccel(VK: Word; const Str: string): Boolean;
begin
  Result := CompareText(Char(VK), GetHotKey(Str), loUserLocale) = 0;
end;

constructor THotLabel.Create(AOwner:tcomponent);
begin
  inherited Create(AOwner);
  FHiliteColor := clRed;
  FHiliteCursor := crHandPoint;
  FHilited := false;
end;

destructor THotLabel.Destroy;
begin
  inherited destroy;
end;

procedure THotLabel.MouseEntered(var AMessage: TMessage);
begin
  if (csDesigning in ComponentState) or
     (FHilited) then
    exit;
  FHilited := false;

  FOldColor := Font.Color;
  FOldCursor := Cursor;
  Font.Color := FHiliteColor;
  Cursor := FHiliteCursor;

  if Assigned(FOnEnter) then
    FOnEnter(Self);

  inherited;
end;

procedure THotLabel.MouseLeft(var AMessage: TMessage);
begin
  Font.Color := FOldColor;
  Cursor := FOldCursor;
  FHilited := false;

  if Assigned(FOnExit) then
    FOnExit(Self);

  inherited;
end;

procedure THotLabel.CMDialogChar(var AMessage: TCMDialogChar);
begin
  if IsAccel(AMessage.CharCode, Caption) then
  begin
    Click;
    AMessage.Result := 1;
  end;
  inherited;
end;

end.
