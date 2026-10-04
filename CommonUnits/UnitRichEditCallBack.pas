unit UnitRichEditCallBack;
// Provide Callback, for displaying ole objects in rtf

{$MINENUMSIZE 4}

interface

uses
  Winapi.Windows, Winapi.ActiveX, Winapi.Richedit, Vcl.ComCtrls, System.Win.ComObj;

type

TReObject = record
  CBStruct: dword;
  Xp: longint;
  ClsId: TCLSID;
  POleObj: IOleObject;
  PStg: IStorage;
  POleSite: IOleClientSite;
  Sizel: TSize;
  DVAspect: dword;
  dwFlags: dword;
  dwUser: dword;
end;
PreObject = ^TReObject;

const
  REO_GETOBJ_NO_INTERFACES  = $00000000;
  REO_GETOBJ_POLEOBJ        = $00000001;
  REO_GETOBJ_PSTG           = $00000002;
  REO_GETOBJ_POLESITE       = $00000004;
  REO_GETOBJ_ALL_INTERFACES = $00000007;

  REO_CP_SELECTION          = $FFFFFFFF;

  REO_IOB_SELECTION         = $FFFFFFFF;
  REO_IOB_USE_CP            = $FFFFFFFE;

  REO_NULL                  = $00000000; // No flags
  REO_READWRITEMASK         = $0000003F; // Mask out RO bits
  REO_DONTNEEDPALETTE       = $00000020; // Object doesn't need palette
  REO_BLANK                 = $00000010; // Object is blank
  REO_DYNAMICSIZE           = $00000008; // Object defines size always
  REO_INVERTEDSELECT        = $00000004; // Object drawn all inverted if sel
  REO_BELOWBASELINE         = $00000002; // Object sits below the baseline
  REO_RESIZABLE             = $00000001; // Object may be resized
  REO_LINK                  = $80000000; // Object is a link (RO)
  REO_STATIC                = $40000000; // Object is static (RO)
  REO_SELECTED              = $08000000; // Object selected (RO)
  REO_OPEN                  = $04000000; // Object open in its server (RO)
  REO_INPLACEACTIVE         = $02000000; // Object in place active (RO)
  REO_HILITED               = $01000000; // Object is to be hilited (RO)
  REO_LINKAVAILABLE         = $00800000; // Link believed available (RO)
  REO_GETMETAFILE           = $00400000; // Object requires metafile (RO)

  RECO_PASTE                = $00000000; // paste from clipboard
  RECO_DROP                 = $00000001; // drop
  RECO_COPY                 = $00000002; // copy to the clipboard
  RECO_CUT                  = $00000003; // cut to the clipboard
  RECO_DRAG                 = $00000004; // drag

type

  IRichEditOle = interface(IUnknown)
    ['{00020D00-0000-0000-C000-000000000046}']
    function GetClientSite(out lplpolesite: IOLECLIENTSITE): HResult; stdcall;
    function GetObjectCount: longint; stdcall;
    function GetLinkCount: longint; stdcall;
    function GetObject(iob: longint; out reobject: TReObject; dwFlags: DWORD): HRESULT; stdcall;
    function InsertObject(const reobject: TReObject): HResult; stdcall;
    function ConvertObject(iob: longint; const clsidNew: TCLSID;
       lpStrUserTypeNew: POleStr): HRESULT; stdcall;
    function ActivateAs(const clsid, clsidAs: TCLSID): HRESULT; stdcall;
    function SetHostNames(lpstrContainerApp, lpstrContainerObj: POleStr): HRESULT; stdcall;
    function SetLinkAvailable(iob: longint; fAvailable: BOOL): HRESULT; stdcall;
    function SetDvaspect(iob: longint; dvaspect: DWORD): HRESULT; stdcall;
    function HandsOffStorage(iob: longint): HRESULT; stdcall;
    function SaveCompleted(iob: longint; stg: IStorage): HRESULT; stdcall;
    function InPlaceDeactivate: HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
         out dataobj: IDataObject): HRESULT; stdcall;
    function ImportDataObject(dataobj: IDataObject; cf: TClipFormat;
         hMetaPict: HGLOBAL): HRESULT; stdcall;
  end;

  IRichEditOleCallback = interface(IUnknown)
    ['{00020D03-0000-0000-C000-000000000046}']
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame;
         out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; stg: IStorage; cp: longint): HRESULT; stdcall;
    function DeleteObject(oleobj: IOLEObject): HRESULT; stdcall;
    function QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat;
         reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
         out dataobj: IDataObject): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
         var dwEffect: DWORD): HRESULT; stdcall;
    function GetContextMenu(seltype: Word; oleobj: IOleObject;
         const chrg: TCharRange; var menu: HMENU): HRESULT; stdcall;
  end;

  TMyRichEditOleCallback = class(TInterfacedObject, IRichEditOleCallback)
  private
    FOwner: TRichEdit;
  protected
    function GetNewStorage(out stg: IStorage): HRESULT; stdcall;
    function GetInPlaceContext(out Frame: IOleInPlaceFrame;
         out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo): HRESULT; stdcall;
    function ShowContainerUI(fShow: BOOL): HRESULT; stdcall;
    function QueryInsertObject(const clsid: TCLSID; stg: IStorage; cp: longint): HRESULT; stdcall;
    function DeleteObject(oleobj: IOLEObject): HRESULT; stdcall;
    function QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat;
         reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HRESULT; stdcall;
    function GetClipboardData(const chrg: TCharRange; reco: DWORD;
         out dataobj: IDataObject): HRESULT; stdcall;
    function GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
         var dwEffect: DWORD): HRESULT; stdcall;
    function GetContextMenu(seltype: Word; oleobj: IOleObject;
         const chrg: TCharRange; var menu: HMENU): HRESULT; stdcall;
  public
    constructor Create(AOwner: TRichEdit);
  end;

  function RichEdit_SetOleCallback(RichEdit: HWnd; OleInterface: IRichEditOleCallback): BOOL;
  function RichEdit_GetOleInterface(RichEdit: HWnd; out OleInterface: IRichEditOle): BOOL;

implementation

function RichEdit_SetOleCallback(RichEdit: HWnd; OleInterface: IRichEditOleCallback): BOOL;
begin
  Result := BOOL(SendMessage(RichEdit, EM_SETOLECALLBACK, 0, LPARAM(OleInterface)));
end;

function RichEdit_GetOleInterface(RichEdit: HWnd; out OleInterface: IRichEditOle): BOOL;
begin
  Result := BOOL(SendMessage(RichEdit, EM_GETOLEINTERFACE, 0, LPARAM(@OleInterface)));
end;

constructor TMyRichEditOleCallback.Create(AOwner: Trichedit);
begin
  inherited Create;
  FOwner := AOwner;
end;

function TMyRichEditOleCallback.GetNewStorage(out stg: IStorage): HRESULT;
var LockBytes: ILockBytes;
begin
  Result := S_OK;
  try
    OleCheck(CreateILockBytesOnHGlobal(0, True, LockBytes));
    OleCheck(StgCreateDocfileOnILockBytes(LockBytes, STGM_READWRITE or STGM_SHARE_EXCLUSIVE or STGM_CREATE, 0, stg));
  except
    Result := E_OUTOFMEMORY;
  end;
end;

function TMyRichEditOleCallback.GetInPlaceContext(out Frame: IOleInPlaceFrame;
       out Doc: IOleInPlaceUIWindow; var FrameInfo: TOleInPlaceFrameInfo): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TMyRichEditOleCallback.ShowContainerUI(fShow: BOOL): HRESULT;
begin
  Result:= E_NOTIMPL;
end;

function TMyRichEditOleCallback.QueryInsertObject(const clsid: TCLSID; stg: IStorage;
       cp: longint): HRESULT;
begin
  Result := S_OK;
end;

function TMyRichEditOleCallback.DeleteObject(oleobj: IOLEObject): HRESULT;
begin
  oleobj.Close(OLECLOSE_NOSAVE);
  Result := S_OK;
end;

function TMyRichEditOleCallback.QueryAcceptData(dataobj: IDataObject; var cfFormat: TClipFormat;
         reco: DWORD; fReally: BOOL; hMetaPict: HGLOBAL): HRESULT;
begin
  Result := S_OK;
end;

function TMyRichEditOleCallback.ContextSensitiveHelp(fEnterMode: BOOL): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TMyRichEditOleCallback.GetClipboardData(const chrg: TCharRange; reco: DWORD;
         out dataobj: IDataObject): HRESULT;
begin
  Result := E_NOTIMPL;
end;

function TMyRichEditOleCallback.GetDragDropEffect(fDrag: BOOL; grfKeyState: DWORD;
         var dwEffect: DWORD): HRESULT;
const
  MK_ALT = $20;
var
  Effect: DWORD;
begin
  Result:= S_OK;
  if not fDrag then
  begin // allowable dest effects
    // check for force link
    if ((grfKeyState and (MK_CONTROL or MK_SHIFT)) = (MK_CONTROL or MK_SHIFT)) then
            Effect := DROPEFFECT_LINK
    // check for force copy
    else if ((grfKeyState and MK_CONTROL) = MK_CONTROL) then
            Effect := DROPEFFECT_COPY
    // check for force move
    else if ((grfKeyState and MK_ALT) = MK_ALT) then
            Effect := DROPEFFECT_MOVE
    // default -- recommended action is move
    else
      Effect := DROPEFFECT_MOVE;
    if (Effect and dwEffect <> 0) then // make sure allowed type
            dwEffect := Effect;
  end;
end;

function TMyRichEditOleCallback.GetContextMenu(seltype: Word; oleobj: IOleObject;
         const chrg: TCharRange; var menu: HMENU): HRESULT;
begin
  Result := S_OK;
  menu := 0;
end;

end.
