unit MsgLoop;

interface

uses
  Winapi.Windows, Winapi.Messages;

procedure ProcessMessages;

implementation

procedure ProcessMessages;
var
  pmMsg:TMsg;
begin
  while (PeekMessage(pmMsg, 0, 0, 0, PM_REMOVE)) do
  begin
    TranslateMessage(pmMsg);
    DispatchMessage(pmMsg);
  end;
end;

end.