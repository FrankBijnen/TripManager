unit UnitUSBEvent;
// Taken, and modified, from: https://nitemsg.blogspot.com/2011/01/heres-unit-written-in-delphi-7-that-you.html
// MSDN: http://msdn.microsoft.com/en-us/library/aa363431%28VS.85%29.aspx

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Classes;

const
  GUID_DEVINTF_USB_DEVICE: TGUID  = '{A5DCBF10-6530-11D2-901F-00C04FB951ED}';
  GUID_DEVINTERFACE_WPD: TGUID    = '{6AC27878-A6FA-4155-BA85-F98F491D4F33}';
  USB_VOLUME                      = $00000002; // Device interface class
  USB_INTERFACE                   = $00000005; // Device interface class
  DBT_DEVNODES_CHANGED            = $0007;     // Device added, or removed
  DBT_DEVICEARRIVAL               = $8000;     // System detected a new device
  DBT_DEVICEREMOVECOMPLETE        = $8004;     // Device is gone

type
  PDevBroadcastDeviceInterface  = ^DEV_BROADCAST_DEVICEINTERFACE;
  DEV_BROADCAST_DEVICEINTERFACE = record
    dbcc_size: DWORD;
    dbcc_devicetype: DWORD;
    dbcc_reserved: DWORD;
    dbcc_classguid: TGUID;
    dbcc_name: char;
  end;

  TUSBDevice = class(TObject)
  public
    DeviceName: string;
    constructor Create(const ADeviceName: string);
  end;

  TUSBEvent = class(TObject)
  private
    FHandle: HWND;
    FParentHandle: HWND;
    FMsgId: integer;
    FDevNotifyHandle: HDEVNOTIFY;
    procedure WindowProc(var AMessage: TMessage);
    procedure WMDeviceChange(var AMessage: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    function RegisterUSBHandler(const ClassGuid: TGUID;
                                const AParentHandle: HWND;
                                const AMsgId: integer): boolean;
    function UnRegisterUSBHandler: boolean;
  end;

implementation

constructor TUSBDevice.Create(const ADeviceName: string);
begin
  inherited Create;

  DeviceName := ADeviceName;
end;

constructor TUSBEvent.Create;
begin
  inherited Create;

  FDevNotifyHandle := nil;
  FHandle := AllocateHWnd(WindowProc);
end;

destructor TUSBEvent.Destroy;
begin
  DeallocateHWnd(FHandle);

  inherited Destroy;
end;

procedure TUSBEvent.WMDeviceChange(var AMessage: TMessage);
var
  Data: PDevBroadcastDeviceInterface;
  AnUSBDevice: TUSBDevice;
begin
  case AMessage.wParam of
    DBT_DEVICEARRIVAL,
    DBT_DEVICEREMOVECOMPLETE:
      begin
        Data := PDevBroadcastDeviceInterface(AMessage.LParam);
        if (Data^.dbcc_devicetype = USB_INTERFACE) then
        begin
          AnUSBDevice := TUSBDevice.Create(PChar(@Data^.dbcc_name));
          PostMessage(FParentHandle, FMsgId, AMessage.wParam, LPARAM(AnUSBDevice));
        end;
      end;
  end;
end;

procedure TUSBEvent.WindowProc(var AMessage: TMessage);
begin
  case AMessage.Msg of
    WM_DEVICECHANGE:
      WMDeviceChange(AMessage);
    else
      AMessage.Result := DefWindowProc(FHandle, AMessage.Msg, AMessage.wParam, AMessage.lParam);
  end;
end;

function TUSBEvent.RegisterUSBHandler(const ClassGuid: TGuid;
                                      const AParentHandle: HWND;
                                      const AMsgId: integer): boolean;
var
  Dbi: DEV_BROADCAST_DEVICEINTERFACE;
  Size : integer;
begin
  result := false;
  if Assigned(FDevNotifyHandle) then
    exit;

  FParentHandle := AParentHandle;
  FMsgId := AMsgId;

  Size := SizeOf(DEV_BROADCAST_DEVICEINTERFACE);
  ZeroMemory(@Dbi,Size);
  Dbi.dbcc_size := Size;
  Dbi.dbcc_devicetype := USB_INTERFACE;
  Dbi.dbcc_reserved := 0;
  Dbi.dbcc_classguid := ClassGuid;
  Dbi.dbcc_name := #0;

  FDevNotifyHandle := RegisterDeviceNotification(FHandle, @Dbi, DEVICE_NOTIFY_WINDOW_HANDLE);
  result := Assigned(FDevNotifyHandle);
end;

function TUSBEvent.UnRegisterUSBHandler: boolean;
begin
  result := false;
  try
    if not Assigned(FDevNotifyHandle) then
      exit;
    result := UnregisterDeviceNotification(FDevNotifyHandle);
  finally
    FDevNotifyHandle := nil;
  end;
end;

end.
