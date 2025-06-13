// CodeGear C++Builder
// Copyright (c) 1995, 2024 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'BCHexEditor.pas' rev: 36.00 (Windows)

#ifndef BCHexEditorHPP
#define BCHexEditorHPP

#pragma delphiheader begin
#pragma option push
#if defined(__BORLANDC__) && !defined(__clang__)
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#endif
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Grids.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Bchexeditor
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS EBCHexEditor;
struct TBCHBookmark;
class DELPHICLASS TBCHColors;
class DELPHICLASS TBCHMemoryStream;
struct TBCHOffsetFormat;
class DELPHICLASS TCustomBCHexEditor;
class DELPHICLASS TBCHexEditor;
struct TBCHUndoRec;
class DELPHICLASS TBCHUndoStorage;
//-- type declarations -------------------------------------------------------
typedef int TPointerInt;

using Vcl::Grids::TGridCoord;

enum DECLSPEC_DENUM TBCHCharConvType : unsigned char { cctFromAnsi, cctToAnsi };

typedef System::StaticArray<char, 256> TBCHCharConvTable;

typedef System::StaticArray<System::StaticArray<char, 256>, 2> TBCHCharConv;

#pragma pack(push,4)
class PASCALIMPLEMENTATION EBCHexEditor : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	/* Exception.Create */ inline __fastcall EBCHexEditor(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall EBCHexEditor(const System::UnicodeString Msg, const System::TVarRec *Args, const System::NativeInt Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EBCHexEditor(System::NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EBCHexEditor(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EBCHexEditor(System::NativeUInt Ident, const System::TVarRec *Args, const System::NativeInt Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EBCHexEditor(System::PResStringRec ResStringRec, const System::TVarRec *Args, const System::NativeInt Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EBCHexEditor(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EBCHexEditor(const System::UnicodeString Msg, const System::TVarRec *Args, const System::NativeInt Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBCHexEditor(System::NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EBCHexEditor(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBCHexEditor(System::PResStringRec ResStringRec, const System::TVarRec *Args, const System::NativeInt Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EBCHexEditor(System::NativeUInt Ident, const System::TVarRec *Args, const System::NativeInt Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EBCHexEditor() { }
	
};

#pragma pack(pop)

struct DECLSPEC_DRECORD TBCHBookmark
{
public:
	TPointerInt mPosition;
	bool mInCharField;
};


typedef System::StaticArray<TBCHBookmark, 10> TBCHBookmarks;

enum DECLSPEC_DENUM TBCHCaretKind : unsigned char { ckFull, ckLeft, ckBottom, ckAuto };

enum DECLSPEC_DENUM TBCHTranslationKind : unsigned char { tkAsIs, tkDos8, tkASCII, tkMac, tkBCD, tkCustom };

enum DECLSPEC_DENUM TBCHProgressKind : unsigned char { pkLoad, pkSave, pkFind };

typedef void __fastcall (__closure *TBCHProgressEvent)(System::TObject* Sender, const TBCHProgressKind ProgressType, const System::Sysutils::TFileName aName, const System::Byte Percent, bool &Cancel);

typedef void __fastcall (__closure *TBCPHGetOffsetTextEvent)(System::TObject* Sender, const __int64 Number, System::UnicodeString &OffsetText);

enum DECLSPEC_DENUM TBCHUndoFlag : unsigned char { ufKindBytesChanged, ufKindByteRemoved, ufKindInsertBuffer, ufKindReplace, ufKindAppendBuffer, ufKindNibbleInsert, ufKindNibbleDelete, ufKindConvert, ufKindSelection, ufKindCombined, ufKindAllData, ufFlagByte1Changed, ufFlagByte2Changed, ufFlagModified, ufFlag2ndByteCol, ufFlagInCharField, ufFlagHasSelection, ufFlagInsertMode, ufFlagIsUnicode, ufFlagIsUnicodeBigEndian, ufFlagHasDescription };

typedef System::Set<TBCHUndoFlag, TBCHUndoFlag::ufKindBytesChanged, TBCHUndoFlag::ufFlagHasDescription> TBCHUndoFlags;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBCHColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Vcl::Controls::TControl* FParent;
	System::Uitypes::TColor FOffset;
	System::Uitypes::TColor FOddColumn;
	System::Uitypes::TColor FEvenColumn;
	System::Uitypes::TColor FCursorFrame;
	System::Uitypes::TColor FNonFocusCursorFrame;
	System::Uitypes::TColor FBackground;
	System::Uitypes::TColor FChangedText;
	System::Uitypes::TColor FChangedBackground;
	System::Uitypes::TColor FCurrentOffsetBackground;
	System::Uitypes::TColor FOffsetBackground;
	System::Uitypes::TColor FActiveFieldBackground;
	System::Uitypes::TColor FCurrentOffset;
	System::Uitypes::TColor FGrid;
	void __fastcall SetOffsetBackground(const System::Uitypes::TColor Value);
	void __fastcall SetCurrentOffset(const System::Uitypes::TColor Value);
	void __fastcall SetParent(Vcl::Controls::TControl* const Value);
	void __fastcall SetGrid(const System::Uitypes::TColor Value);
	void __fastcall SetBackground(const System::Uitypes::TColor Value);
	void __fastcall SetChangedBackground(const System::Uitypes::TColor Value);
	void __fastcall SetChangedText(const System::Uitypes::TColor Value);
	void __fastcall SetCursorFrame(const System::Uitypes::TColor Value);
	void __fastcall SetEvenColumn(const System::Uitypes::TColor Value);
	void __fastcall SetOddColumn(const System::Uitypes::TColor Value);
	void __fastcall SetOffset(const System::Uitypes::TColor Value);
	void __fastcall SetActiveFieldBackground(const System::Uitypes::TColor Value);
	void __fastcall SetCurrentOffsetBackground(const System::Uitypes::TColor Value);
	void __fastcall SetNonFocusCursorFrame(const System::Uitypes::TColor Value);
	
public:
	__fastcall TBCHColors(Vcl::Controls::TControl* Parent);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property Vcl::Controls::TControl* Parent = {read=FParent, write=SetParent};
	
__published:
	__property System::Uitypes::TColor Background = {read=FBackground, write=SetBackground, nodefault};
	__property System::Uitypes::TColor ChangedBackground = {read=FChangedBackground, write=SetChangedBackground, nodefault};
	__property System::Uitypes::TColor ChangedText = {read=FChangedText, write=SetChangedText, nodefault};
	__property System::Uitypes::TColor CursorFrame = {read=FCursorFrame, write=SetCursorFrame, nodefault};
	__property System::Uitypes::TColor Offset = {read=FOffset, write=SetOffset, nodefault};
	__property System::Uitypes::TColor OddColumn = {read=FOddColumn, write=SetOddColumn, nodefault};
	__property System::Uitypes::TColor EvenColumn = {read=FEvenColumn, write=SetEvenColumn, nodefault};
	__property System::Uitypes::TColor CurrentOffsetBackground = {read=FCurrentOffsetBackground, write=SetCurrentOffsetBackground, nodefault};
	__property System::Uitypes::TColor OffsetBackground = {read=FOffsetBackground, write=SetOffsetBackground, nodefault};
	__property System::Uitypes::TColor CurrentOffset = {read=FCurrentOffset, write=SetCurrentOffset, nodefault};
	__property System::Uitypes::TColor Grid = {read=FGrid, write=SetGrid, nodefault};
	__property System::Uitypes::TColor NonFocusCursorFrame = {read=FNonFocusCursorFrame, write=SetNonFocusCursorFrame, nodefault};
	__property System::Uitypes::TColor ActiveFieldBackground = {read=FActiveFieldBackground, write=SetActiveFieldBackground, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TBCHColors() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TBCHMemoryStream : public System::Classes::TMemoryStream
{
	typedef System::Classes::TMemoryStream inherited;
	
private:
	void * __fastcall PointerAt(const TPointerInt APosition, const TPointerInt ACount);
	
public:
	Winapi::Windows::PByte __fastcall GetAddress(const TPointerInt Index, const TPointerInt Count);
	void __fastcall ReadBufferAt(void *Buffer, const TPointerInt APosition, const TPointerInt ACount);
	void __fastcall WriteBufferAt(const void *Buffer, const TPointerInt APosition, const TPointerInt ACount);
	void __fastcall Move(const TPointerInt AFromPos, const TPointerInt AToPos, const TPointerInt ACount);
	void __fastcall TranslateToAnsi(const TBCHTranslationKind FromTranslation, const TPointerInt APosition, const TPointerInt ACount);
	void __fastcall TranslateFromAnsi(const TBCHTranslationKind ToTranslation, const TPointerInt APosition, const TPointerInt ACount);
	System::UnicodeString __fastcall GetAsHex(const TPointerInt APosition, const TPointerInt ACount, const bool SwapNibbles);
public:
	/* TMemoryStream.Destroy */ inline __fastcall virtual ~TBCHMemoryStream() { }
	
public:
	/* TObject.Create */ inline __fastcall TBCHMemoryStream() : System::Classes::TMemoryStream() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TBCHOffsetFormatFlag : unsigned char { offCalcWidth, offCalcRow, offCalcColumn, offBytesPerUnit };

typedef System::Set<TBCHOffsetFormatFlag, TBCHOffsetFormatFlag::offCalcWidth, TBCHOffsetFormatFlag::offBytesPerUnit> TBCHOffsetFormatFlags;

struct DECLSPEC_DRECORD TBCHOffsetFormat
{
public:
	System::UnicodeString Format;
	System::UnicodeString Prefix;
	System::UnicodeString Suffix;
	int MinWidth;
	TBCHOffsetFormatFlags Flags;
	System::Byte Radix;
	System::Byte _BytesPerUnit;
};


typedef void __fastcall (__closure *TBCHDrawCellEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* ACanvas, TPointerInt ACol, TPointerInt ARow, System::WideString &AWideText, const Winapi::Windows::TRect &ARect, bool &ADefaultDraw);

class PASCALIMPLEMENTATION TCustomBCHexEditor : public Vcl::Grids::TCustomGrid
{
	typedef Vcl::Grids::TCustomGrid inherited;
	
	
private:
	typedef System::DynamicArray<int> _TCustomBCHexEditor__1;
	
	
private:
	bool FIsViewSyncing;
	int FIntLastHexCol;
	bool FIsMaxOffset;
	int FBlockSize;
	bool FSepCharBlocks;
	TBCPHGetOffsetTextEvent FOnGetOffsetText;
	bool FFixedFileSize;
	int FCharWidth;
	int FCharHeight;
	Vcl::Controls::TImageList* FBookmarkImageList;
	bool FInsertModeOn;
	Vcl::Graphics::TBitmap* FCaretBitmap;
	TBCHColors* FColors;
	int FBytesPerRow;
	int FOffSetDisplayWidth;
	int FBytesPerRowDup;
	TBCHMemoryStream* FDataStorage;
	int FSwapNibbles;
	bool FFocusFrame;
	bool FIsFileReadonly;
	int FBytesPerCol;
	bool FPosInCharField;
	bool FLastPosInCharField;
	System::UnicodeString FFileName;
	System::Classes::TBits* FModifiedBytes;
	TBCHBookmarks FBookmarks;
	TPointerInt FSelStart;
	TPointerInt FSelPosition;
	TPointerInt FSelEnd;
	TPointerInt FSelBeginPosition;
	TBCHTranslationKind FTranslation;
	TBCHCaretKind FCaretKind;
	System::WideChar FReplaceUnprintableCharsBy;
	bool FAllowInsertMode;
	bool FWantTabs;
	bool FReadOnlyView;
	bool FHideSelection;
	bool FGraySelOnLostFocus;
	TBCHProgressEvent FOnProgress;
	int FMouseDownCol;
	TPointerInt FMouseDownRow;
	bool FShowDrag;
	int FDropCol;
	TPointerInt FDropRow;
	System::Classes::TNotifyEvent FOnInvalidKey;
	System::Classes::TNotifyEvent FOnTopLeftChanged;
	bool FAutoBytesPerRow;
	bool FSetAutoBytesPerRow;
	bool FDrawGridLines;
	bool FDrawGutter3D;
	int FGutterWidth;
	TBCHOffsetFormat FOffsetFormat;
	bool FSelectionPossible;
	Vcl::Graphics::TBitmap* FBookmarkBitmap;
	_TCustomBCHexEditor__1 FCursorList;
	bool FHasCustomBMP;
	System::UnicodeString FStreamFileName;
	bool FHasFile;
	TPointerInt FMaxUndo;
	System::StaticArray<System::WideChar, 16> FHexChars;
	bool FHexLowerCase;
	System::Classes::TNotifyEvent FOnChange;
	bool FShowRuler;
	int FBytesPerUnit;
	int FRulerBytesPerUnit;
	System::Classes::TNotifyEvent FOnSelectionChanged;
	int FSelectionChangedCount;
	bool FShowPositionIfNotFocused;
	bool FOffsetHandler;
	int FUsedRulerBytesPerUnit;
	bool FIsSelecting;
	bool FMouseUpCanResetSel;
	TBCHUndoStorage* FUndoStorage;
	bool FUnicodeCharacters;
	bool FUnicodeBigEndian;
	System::UnicodeString FMaskedChars;
	TPointerInt FDrawDataPosition;
	bool FDrawDataPositionIsHex;
	TBCHDrawCellEvent FOnDrawCell;
	System::Classes::TNotifyEvent FOnBookmarkChanged;
	bool FIsDrawDataSelected;
	System::Byte FSetDataSizeFillByte;
	System::Byte FRulerNumberBase;
	__property Color = {default=-16777211};
	bool __fastcall IsInsertModePossible();
	void __fastcall RecalcBytesPerRow();
	bool __fastcall IsFileSizeFixed();
	void __fastcall InternalErase(const bool KeyWasBackspace, const System::UnicodeString UndoDesc = System::UnicodeString());
	void __fastcall SetReadOnlyView(const bool Value);
	void __fastcall SetCaretKind(const TBCHCaretKind Value);
	void __fastcall SetFocusFrame(const bool Value);
	void __fastcall SetBytesPerColumn(const int Value);
	void __fastcall SetSwapNibbles(const bool Value);
	bool __fastcall GetSwapNibbles();
	int __fastcall GetBytesPerColumn();
	void __fastcall SetOffsetDisplayWidth();
	void __fastcall SetColors(TBCHColors* const Value);
	void __fastcall SetReadOnlyFile(const bool Value);
	void __fastcall SetTranslation(const TBCHTranslationKind Value);
	void __fastcall SetModified(const bool Value);
	void __fastcall SetChanged(TPointerInt DataPos, const bool Value);
	void __fastcall SetFixedFileSize(const bool Value);
	void __fastcall SetAllowInsertMode(const bool Value);
	bool __fastcall GetInsertMode();
	void __fastcall SetWantTabs(const bool Value);
	void __fastcall SetHideSelection(const bool Value);
	void __fastcall SetGraySelectionIfNotFocused(const bool Value);
	int __fastcall CalcColCount();
	int __fastcall GetLastCharCol();
	int __fastcall GetPropColCount();
	TPointerInt __fastcall GetPropRowCount();
	bool __fastcall GetMouseOverSelection();
	bool __fastcall CursorOverSelection(const int X, const int Y);
	bool __fastcall MouseOverFixed(const int X, const int Y);
	void __fastcall AdjustBookmarks(const TPointerInt From, const TPointerInt Offset);
	void __fastcall IntSetCaretPos(const int X, const int Y, const int ACol);
	void __fastcall TruncMaxPosition(TPointerInt &DataPos);
	HIDESBASE void __fastcall SetSelection(TPointerInt DataPos, TPointerInt StartPos, TPointerInt EndPos);
	int __fastcall GetCurrentValue();
	void __fastcall SetInsertMode(const bool Value);
	bool __fastcall GetModified();
	void __fastcall SetBytesPerRow(const int Value);
	void __fastcall SetMaskChar(const System::WideChar Value);
	void __fastcall SetAsText(const System::AnsiString Value);
	void __fastcall SetAsHex(const System::UnicodeString Value);
	System::AnsiString __fastcall GetAsText();
	System::UnicodeString __fastcall GetAsHex();
	HIDESBASE MESSAGE void __fastcall WMTimer(Winapi::Messages::TWMTimer &Msg);
	void __fastcall CheckSetCaret();
	TPointerInt __fastcall GetRow(const TPointerInt DataPos);
	void __fastcall WrongKey();
	void __fastcall CreateCaretGlyph();
	TPointerInt __fastcall GetSelStart();
	TPointerInt __fastcall GetSelEnd();
	TPointerInt __fastcall GetSelCount();
	void __fastcall SetSelStart(TPointerInt aValue);
	void __fastcall SetSelEnd(TPointerInt aValue);
	void __fastcall SetSelCount(TPointerInt aValue);
	void __fastcall SetInCharField(const bool Value);
	bool __fastcall GetInCharField();
	void __fastcall InternalInsertBuffer(char * Buffer, const TPointerInt Size, const TPointerInt Position);
	void __fastcall InternalAppendBuffer(char * Buffer, const TPointerInt Size);
	void __fastcall InternalGetCurSel(TPointerInt &StartPos, TPointerInt &EndPos, int &ACol, TPointerInt &ARow);
	void __fastcall InternalDelete(TPointerInt StartPos, TPointerInt EndPos, int ACol, TPointerInt ARow);
	bool __fastcall InternalDeleteNibble(const TPointerInt Pos, const bool HighNibble);
	bool __fastcall InternalInsertNibble(const TPointerInt Pos, const bool HighNibble);
	System::Classes::TFileStream* __fastcall CreateShift4BitStream(const TPointerInt StartPos, System::Sysutils::TFileName &FName);
	void __fastcall InternalConvertRange(const TPointerInt aFrom, const TPointerInt aTo, const TBCHTranslationKind aTransFrom, const TBCHTranslationKind aTransTo);
	void __fastcall MoveFileMem(const TPointerInt aFrom, const TPointerInt aTo, const TPointerInt aCount);
	TBCHBookmark __fastcall GetBookmark(System::Byte Index);
	void __fastcall SetBookmark(System::Byte Index, const TBCHBookmark &Value);
	void __fastcall SetBookmarkVals(const System::Byte Index, const TPointerInt Position, const bool InCharField);
	void __fastcall SetDrawGridLines(const bool Value);
	void __fastcall SetGutterWidth(const int Value);
	void __fastcall BookmarkBitmapChanged(System::TObject* Sender);
	void __fastcall SetBookmarkBitmap(Vcl::Graphics::TBitmap* const Value);
	void __fastcall FreeStorage(bool FreeUndo = false);
	bool __fastcall GetCanUndo();
	bool __fastcall GetCanRedo();
	System::UnicodeString __fastcall GetUndoDescription();
	System::UnicodeString __fastcall GetOffsetFormat();
	void __fastcall SetOffsetFormat(const System::UnicodeString Value);
	void __fastcall GenerateOffsetFormat(System::UnicodeString Value);
	void __fastcall SetHexLowerCase(const bool Value);
	void __fastcall SetDrawGutter3D(const bool Value);
	void __fastcall SetShowRuler(const bool Value);
	void __fastcall SetBytesPerUnit(const int Value);
	void __fastcall SetRulerString();
	void __fastcall CheckSelectUnit(TPointerInt &AStart, TPointerInt &AEnd);
	void __fastcall SetRulerBytesPerUnit(const int Value);
	void __fastcall SetShowPositionIfNotFocused(const bool Value);
	System::Byte __fastcall GetDataAt(TPointerInt Index);
	void __fastcall SetDataAt(TPointerInt Index, const System::Byte Value);
	void __fastcall SetUnicodeCharacters(const bool Value);
	void __fastcall SetUnicodeBigEndian(const bool Value);
	void __fastcall SetAutoBytesPerRow(const bool Value);
	TPointerInt __fastcall GetPositionAtCursor(const TPointerInt ACol, const TPointerInt ARow);
	bool __fastcall GetIsCharFieldCol(const int ACol);
	void __fastcall SetDataSize(const TPointerInt Value);
	void __fastcall SetBlockSize(const int Value);
	void __fastcall SetSepCharBlocks(const bool Value);
	void __fastcall SetRulerNumberBase(const System::Byte Value);
	void __fastcall SetMaskedChars(const System::UnicodeString Value);
	
protected:
	System::UnicodeString FRulerString;
	System::UnicodeString FRulerCharString;
	bool FFixedFileSizeOverride;
	bool FModified;
	DYNAMIC bool __fastcall DoMouseWheelDown(System::Classes::TShiftState Shift, const Winapi::Windows::TPoint &MousePos);
	DYNAMIC bool __fastcall DoMouseWheelUp(System::Classes::TShiftState Shift, const Winapi::Windows::TPoint &MousePos);
	virtual void __fastcall DrawCell(System::LongInt ACol, System::LongInt ARow, const Winapi::Windows::TRect &ARect, Vcl::Grids::TGridDrawState AState);
	__property int UsedRulerBytesPerUnit = {read=FUsedRulerBytesPerUnit, nodefault};
	__property bool IsSelecting = {read=FIsSelecting, nodefault};
	__property bool MouseUpCanResetSel = {read=FMouseUpCanResetSel, write=FMouseUpCanResetSel, nodefault};
	__property TBCHUndoStorage* UndoStorage = {read=FUndoStorage};
	__property TBCHMemoryStream* DataStorage = {read=FDataStorage};
	virtual void __fastcall SelectionChanged();
	void __fastcall NewSelection(TPointerInt SelFrom, TPointerInt SelTo);
	TGridCoord __fastcall CheckMouseCoord(int &X, int &Y);
	void __fastcall CheckUnit(TPointerInt &AValue);
	HIDESBASE virtual void __fastcall Changed();
	TPointerInt __fastcall DropPosition();
	void __fastcall Stream2Stream(System::Classes::TStream* strFrom, System::Classes::TStream* strTo, const TBCHProgressKind Operation, const TPointerInt Count = 0xffffffff);
	virtual void __fastcall PrepareOverwriteDiskFile();
	void __fastcall WaitCursor();
	void __fastcall OldCursor();
	virtual void __fastcall Paint();
	DYNAMIC void __fastcall TopLeftChanged();
	void __fastcall AdjustMetrics();
	TPointerInt __fastcall GetDataSize();
	void __fastcall CalcSizes();
	virtual bool __fastcall SelectCell(System::LongInt ACol, System::LongInt ARow);
	int __fastcall GetPosAtCursor(const int aCol, const int aRow);
	TGridCoord __fastcall GetCursorAtPos(const int aPos, const bool aChars);
	int __fastcall GetOtherFieldCol(const int aCol);
	int __fastcall GetOtherFieldColCheck(const int aCol);
	bool __fastcall CheckSelectCell(int aCol, int aRow);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMChar &Msg);
	MESSAGE void __fastcall WMImeChar(Winapi::Messages::TWMChar &Msg);
	MESSAGE void __fastcall CMINTUPDATECARET(Winapi::Messages::TMessage &Msg);
	MESSAGE void __fastcall CMSelectionChanged(Winapi::Messages::TMessage &Msg);
	HIDESBASE MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMGetDlgCode &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	void __fastcall IntChangeByte(const System::Byte aOldByte, const System::Byte aNewByte, TPointerInt aPos, TPointerInt aCol, TPointerInt aRow, const System::UnicodeString UndoDesc = System::UnicodeString());
	void __fastcall IntChangeWideChar(const System::WideChar aOldChar, const System::WideChar aNewChar, TPointerInt aPos, TPointerInt aCol, TPointerInt aRow, const System::UnicodeString UndoDesc = System::UnicodeString());
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	bool __fastcall HasChanged(TPointerInt aPos);
	void __fastcall Select(const TPointerInt aCurCol, const TPointerInt aCurRow, const TPointerInt aNewCol, const TPointerInt aNewRow);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual bool __fastcall CanCreateUndo(const TBCHUndoFlag aKind, const TPointerInt aCount, const TPointerInt aReplCount);
	void __fastcall CreateUndo(const TBCHUndoFlag aKind, const TPointerInt aPos, const TPointerInt aCount, const TPointerInt aReplCount, const System::UnicodeString sDesc = System::UnicodeString());
	virtual void __fastcall Loaded();
	virtual void __fastcall CreateWnd();
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMVScroll &Msg);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMHScroll &Msg);
	DYNAMIC void __fastcall Resize();
	bool __fastcall HasCustomBookmarkBitmap();
	__property bool AutoBytesPerRow = {read=FAutoBytesPerRow, write=SetAutoBytesPerRow, default=0};
	__property int BytesPerRow = {read=FBytesPerRow, write=SetBytesPerRow, nodefault};
	__property int BytesPerColumn = {read=GetBytesPerColumn, write=SetBytesPerColumn, default=2};
	__property TBCHTranslationKind Translation = {read=FTranslation, write=SetTranslation, nodefault};
	__property System::UnicodeString OffsetFormat = {read=GetOffsetFormat, write=SetOffsetFormat};
	__property TBCPHGetOffsetTextEvent OnGetOffsetText = {read=FOnGetOffsetText, write=FOnGetOffsetText};
	__property int BytesPerBlock = {read=FBlockSize, write=SetBlockSize, default=-1};
	__property bool SeparateBlocksInCharField = {read=FSepCharBlocks, write=SetSepCharBlocks, default=1};
	__property TBCHCaretKind CaretKind = {read=FCaretKind, write=SetCaretKind, default=3};
	__property TBCHColors* Colors = {read=FColors, write=SetColors};
	__property bool FocusFrame = {read=FFocusFrame, write=SetFocusFrame, nodefault};
	__property bool SwapNibbles = {read=GetSwapNibbles, write=SetSwapNibbles, default=0};
	__property System::WideChar MaskChar = {read=FReplaceUnprintableCharsBy, write=SetMaskChar, stored=false, nodefault};
	__property bool NoSizeChange = {read=FFixedFileSize, write=SetFixedFileSize, default=0};
	__property bool AllowInsertMode = {read=FAllowInsertMode, write=SetAllowInsertMode, default=1};
	__property bool WantTabs = {read=FWantTabs, write=SetWantTabs, default=1};
	__property bool ReadOnlyView = {read=FReadOnlyView, write=SetReadOnlyView, default=0};
	__property bool HideSelection = {read=FHideSelection, write=SetHideSelection, default=0};
	__property bool GraySelectionIfNotFocused = {read=FGraySelOnLostFocus, write=SetGraySelectionIfNotFocused, default=0};
	__property TBCHProgressEvent OnProgress = {read=FOnProgress, write=FOnProgress};
	__property System::Classes::TNotifyEvent OnInvalidKey = {read=FOnInvalidKey, write=FOnInvalidKey};
	__property System::Classes::TNotifyEvent OnTopLeftChanged = {read=FOnTopLeftChanged, write=FOnTopLeftChanged};
	System::UnicodeString __fastcall GetSelectionAsHex();
	void __fastcall SetSelectionAsHex(const System::UnicodeString s);
	System::AnsiString __fastcall GetSelectionAsText();
	void __fastcall SetSelectionAsText(const System::AnsiString s);
	__property bool DrawGridLines = {read=FDrawGridLines, write=SetDrawGridLines, nodefault};
	__property int GutterWidth = {read=FGutterWidth, write=SetGutterWidth, default=-1};
	__property Vcl::Graphics::TBitmap* BookmarkBitmap = {read=FBookmarkBitmap, write=SetBookmarkBitmap, stored=HasCustomBookmarkBitmap};
	__property TPointerInt MaxUndo = {read=FMaxUndo, write=FMaxUndo, default=1048576};
	__property bool InsertMode = {read=GetInsertMode, write=SetInsertMode, default=0};
	__property bool HexLowerCase = {read=FHexLowerCase, write=SetHexLowerCase, default=0};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property bool DrawGutter3D = {read=FDrawGutter3D, write=SetDrawGutter3D, default=1};
	__property bool ShowRuler = {read=FShowRuler, write=SetShowRuler, default=0};
	__property System::Byte RulerNumberBase = {read=FRulerNumberBase, write=SetRulerNumberBase, default=16};
	__property int BytesPerUnit = {read=FBytesPerUnit, write=SetBytesPerUnit, default=1};
	__property int RulerBytesPerUnit = {read=FRulerBytesPerUnit, write=SetRulerBytesPerUnit, default=-1};
	__property bool ShowPositionIfNotFocused = {read=FShowPositionIfNotFocused, write=SetShowPositionIfNotFocused, default=0};
	__property bool UnicodeChars = {read=FUnicodeCharacters, write=SetUnicodeCharacters, default=0};
	__property bool UnicodeBigEndian = {read=FUnicodeBigEndian, write=SetUnicodeBigEndian, default=0};
	__property System::Classes::TNotifyEvent OnSelectionChanged = {read=FOnSelectionChanged, write=FOnSelectionChanged};
	__property TBCHDrawCellEvent OnDrawCell = {read=FOnDrawCell, write=FOnDrawCell};
	virtual void __fastcall BookmarkChanged();
	void __fastcall DoSetCellWidth(const int Index, int Value);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	void __fastcall ReadMaskChar(System::Classes::TReader* Reader);
	void __fastcall ReadMaskChar_I(System::Classes::TReader* Reader);
	void __fastcall WriteMaskChar_I(System::Classes::TWriter* Writer);
	Winapi::Windows::PByte __fastcall GetFastPointer(const TPointerInt Index, const TPointerInt Count);
	
public:
	__fastcall virtual TCustomBCHexEditor(System::Classes::TComponent* aOwner);
	__fastcall virtual ~TCustomBCHexEditor();
	__property System::UnicodeString MaskedChars = {read=FMaskedChars, write=SetMaskedChars};
	__property TPointerInt DrawDataPosition = {read=FDrawDataPosition, nodefault};
	__property bool IsDrawDataSelected = {read=FIsDrawDataSelected, nodefault};
	DYNAMIC bool __fastcall CanFocus();
	__property bool IsMaxOffset = {read=FIsMaxOffset, nodefault};
	void __fastcall SeekToEOF();
	void __fastcall SyncView(TCustomBCHexEditor* Source, TPointerInt SyncOffset = 0x0);
	TPointerInt __fastcall DisplayStart();
	TPointerInt __fastcall DisplayEnd();
	bool __fastcall IsSelected(const TPointerInt APosition);
	__property TPointerInt PositionAtCursor[const TPointerInt ACol][const TPointerInt ARow] = {read=GetPositionAtCursor};
	__property bool IsCharFieldCol[const int ACol] = {read=GetIsCharFieldCol};
	__property System::Byte SetDataSizeFillByte = {read=FSetDataSizeFillByte, write=FSetDataSizeFillByte, nodefault};
	__property bool HasFile = {read=FHasFile, write=FHasFile, nodefault};
	virtual TPointerInt __fastcall UndoBeginUpdate();
	virtual TPointerInt __fastcall UndoEndUpdate();
	void __fastcall ResetSelection(const bool aDraw);
	__property System::UnicodeString SelectionAsHex = {read=GetSelectionAsHex, write=SetSelectionAsHex};
	__property System::AnsiString SelectionAsText = {read=GetSelectionAsText, write=SetSelectionAsText};
	virtual System::UnicodeString __fastcall GetOffsetString(const TPointerInt Position);
	virtual System::UnicodeString __fastcall GetAnyOffsetString(const TPointerInt Position);
	int __fastcall RowHeight();
	void __fastcall ResetUndo();
	TPointerInt __fastcall Seek(const TPointerInt aOffset, const TPointerInt aOrigin);
	TPointerInt __fastcall Find(void * aPattern, TPointerInt aCount, const TPointerInt aStart, const TPointerInt aEnd)/* overload */;
	TPointerInt __fastcall Find(System::UnicodeString aPattern, const TPointerInt aStart, const TPointerInt aEnd, const bool IgnoreCase)/* overload */;
	void __fastcall AddSelectionUndo(const TPointerInt AStart, const TPointerInt ACount);
	void __fastcall ReadBuffer(void *Buffer, const TPointerInt Index, const TPointerInt Count);
	virtual void __fastcall WriteBuffer(const void *Buffer, const TPointerInt Index, const TPointerInt Count);
	void __fastcall DeleteSelection(const System::UnicodeString UndoDesc = System::UnicodeString());
	void __fastcall LoadFromStream(System::Classes::TStream* Strm);
	void __fastcall LoadFromFile(const System::UnicodeString Filename);
	void __fastcall SaveToStream(System::Classes::TStream* Strm);
	void __fastcall SaveToFile(const System::UnicodeString Filename, const bool aUnModify = true);
	void __fastcall SaveRangeToStream(System::Classes::TStream* Strm, const TPointerInt APosition, const TPointerInt ACount);
	bool __fastcall Undo();
	bool __fastcall Redo();
	void __fastcall CreateEmptyFile(const System::UnicodeString TempName);
	System::WideChar * __fastcall BufferFromFile(const TPointerInt aPos, TPointerInt &aCount);
	void __fastcall InsertBuffer(char * aBuffer, const TPointerInt aSize, const TPointerInt aPos, const System::UnicodeString UndoDesc = System::UnicodeString(), const bool MoveCursor = true);
	void __fastcall AppendBuffer(char * aBuffer, const TPointerInt aSize, const System::UnicodeString UndoDesc = System::UnicodeString(), const bool MoveCursor = true);
	void __fastcall ReplaceSelection(char * aBuffer, TPointerInt aSize, const System::UnicodeString UndoDesc = System::UnicodeString(), const bool MoveCursor = true);
	TPointerInt __fastcall Replace(System::WideChar * aBuffer, TPointerInt aPosition, TPointerInt aOldCount, TPointerInt aNewCount, const System::UnicodeString UndoDesc = System::UnicodeString(), const bool MoveCursor = false);
	TPointerInt __fastcall GetCursorPos();
	bool __fastcall DeleteNibble(const TPointerInt aPos, const bool HighNibble, const System::UnicodeString UndoDesc = System::UnicodeString());
	bool __fastcall InsertNibble(const TPointerInt aPos, const bool HighNibble, const System::UnicodeString UndoDesc = System::UnicodeString());
	void __fastcall ConvertRange(const TPointerInt aFrom, const TPointerInt aTo, const TBCHTranslationKind aTransFrom, const TBCHTranslationKind aTransTo, const System::UnicodeString UndoDesc = System::UnicodeString());
	TPointerInt __fastcall GetTopLeftPosition(bool &oInCharField);
	void __fastcall SetTopLeftPosition(const TPointerInt aPosition, const bool aInCharField);
	TPointerInt __fastcall ShowDragCell(const TPointerInt X, const TPointerInt Y);
	void __fastcall HideDragCell();
	void __fastcall CombineUndo(const TPointerInt aCount, const System::UnicodeString sDesc = System::UnicodeString());
	System::WideChar __fastcall TranslateToAnsiChar(const System::Byte aByte);
	System::WideChar __fastcall TranslateFromAnsiChar(const System::Byte aByte);
	__property TPointerInt SelStart = {read=GetSelStart, write=SetSelStart, nodefault};
	__property TPointerInt SelEnd = {read=GetSelEnd, write=SetSelEnd, nodefault};
	__property TPointerInt SelCount = {read=GetSelCount, write=SetSelCount, nodefault};
	__property bool CanUndo = {read=GetCanUndo, nodefault};
	__property bool CanRedo = {read=GetCanRedo, nodefault};
	__property bool InCharField = {read=GetInCharField, write=SetInCharField, nodefault};
	__property System::UnicodeString UndoDescription = {read=GetUndoDescription};
	__property bool ReadOnlyFile = {read=FIsFileReadonly, write=SetReadOnlyFile, nodefault};
	__property bool Modified = {read=GetModified, write=SetModified, nodefault};
	__property TPointerInt DataSize = {read=GetDataSize, write=SetDataSize, nodefault};
	__property System::Byte Data[TPointerInt Index] = {read=GetDataAt, write=SetDataAt};
	__property System::AnsiString AsText = {read=GetAsText, write=SetAsText};
	__property System::UnicodeString AsHex = {read=GetAsHex, write=SetAsHex};
	__property System::UnicodeString Filename = {read=FFileName};
	__property TBCHBookmark Bookmark[System::Byte Index] = {read=GetBookmark, write=SetBookmark};
	__property bool ByteChanged[TPointerInt index] = {read=HasChanged, write=SetChanged};
	__property int ColCountRO = {read=GetPropColCount, nodefault};
	__property TPointerInt RowCountRO = {read=GetPropRowCount, nodefault};
	__property bool MouseOverSelection = {read=GetMouseOverSelection, nodefault};
	__property int CurrentValue = {read=GetCurrentValue, nodefault};
	void __fastcall SelectAll();
	__property VisibleColCount;
	__property VisibleRowCount;
	__property Canvas;
	__property Col;
	__property LeftCol;
	__property Row;
	__property TopRow;
	__property System::Classes::TNotifyEvent OnBookmarkChanged = {read=FOnBookmarkChanged, write=FOnBookmarkChanged};
	bool __fastcall GotoBookmark(const int Index);
	void __fastcall UpdateGetOffsetText();
	void __fastcall CenterCursorPosition();
public:
	/* TWinControl.CreateParented */ inline __fastcall TCustomBCHexEditor(HWND ParentWindow) : Vcl::Grids::TCustomGrid(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TBCHexEditor : public TCustomBCHexEditor
{
	typedef TCustomBCHexEditor inherited;
	
__published:
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property BorderStyle = {default=1};
	__property Constraints;
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseWheel;
	__property OnMouseWheelDown;
	__property OnMouseWheelUp;
	__property OnStartDock;
	__property OnStartDrag;
	__property ParentBiDiMode = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ScrollBars = {default=3};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property BytesPerRow;
	__property BytesPerColumn = {default=2};
	__property AutoBytesPerRow = {default=0};
	__property Translation;
	__property OffsetFormat = {default=0};
	__property CaretKind = {default=3};
	__property Colors;
	__property FocusFrame;
	__property SwapNibbles = {default=0};
	__property MaskChar;
	__property NoSizeChange = {default=0};
	__property AllowInsertMode = {default=1};
	__property DrawGridLines;
	__property WantTabs = {default=1};
	__property ReadOnlyView = {default=0};
	__property HideSelection = {default=0};
	__property GraySelectionIfNotFocused = {default=0};
	__property GutterWidth = {default=-1};
	__property BookmarkBitmap;
	__property MaxUndo = {default=1048576};
	__property InsertMode = {default=0};
	__property HexLowerCase = {default=0};
	__property OnProgress;
	__property OnInvalidKey;
	__property OnTopLeftChanged;
	__property OnChange;
	__property DrawGutter3D = {default=1};
	__property ShowRuler = {default=0};
	__property BytesPerUnit = {default=1};
	__property RulerBytesPerUnit = {default=-1};
	__property ShowPositionIfNotFocused = {default=0};
	__property OnSelectionChanged;
	__property UnicodeChars = {default=0};
	__property UnicodeBigEndian = {default=0};
	__property OnDrawCell;
	__property OnBookmarkChanged;
	__property OnGetOffsetText;
	__property BytesPerBlock = {default=-1};
	__property SeparateBlocksInCharField = {default=1};
	__property RulerNumberBase = {default=16};
public:
	/* TCustomBCHexEditor.Create */ inline __fastcall virtual TBCHexEditor(System::Classes::TComponent* aOwner) : TCustomBCHexEditor(aOwner) { }
	/* TCustomBCHexEditor.Destroy */ inline __fastcall virtual ~TBCHexEditor() { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TBCHexEditor(HWND ParentWindow) : TCustomBCHexEditor(ParentWindow) { }
	
};


typedef TBCHUndoRec *PBCHUndoRec;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TBCHUndoRec
{
public:
	TPointerInt DataLen;
	TBCHUndoFlags Flags;
	TPointerInt CurPos;
	TPointerInt Pos;
	TPointerInt Count;
	TPointerInt ReplCount;
	TBCHTranslationKind CurTranslation;
	int CurBPU;
	System::Byte Buffer;
};
#pragma pack(pop)


#pragma pack(push,4)
class PASCALIMPLEMENTATION TBCHUndoStorage : public System::Classes::TMemoryStream
{
	typedef System::Classes::TMemoryStream inherited;
	
private:
	TPointerInt FCount;
	TPointerInt FUpdateCount;
	TCustomBCHexEditor* FEditor;
	System::UnicodeString FDescription;
	PBCHUndoRec FRedoPointer;
	PBCHUndoRec FLastUndo;
	TPointerInt FLastUndoSize;
	System::UnicodeString FLastUndoDesc;
	void __fastcall SetCount(const TPointerInt Value);
	void __fastcall ResetRedo();
	void __fastcall CreateRedo(const TBCHUndoRec &Rec);
	TBCHUndoFlag __fastcall GetUndoKind(const TBCHUndoFlags Flags);
	void __fastcall AddSelection(const TPointerInt APos, const TPointerInt ACount);
	TBCHUndoFlag __fastcall ReadUndoRecord(TBCHUndoRec &aUR, System::UnicodeString &SDescription);
	TBCHUndoFlag __fastcall GetLastUndoKind();
	
public:
	__fastcall TBCHUndoStorage(TCustomBCHexEditor* AEditor);
	__fastcall virtual ~TBCHUndoStorage();
	virtual void __fastcall SetSize(const __int64 NewSize)/* overload */;
	void __fastcall CreateUndo(TBCHUndoFlag aKind, TPointerInt APosition, TPointerInt ACount, TPointerInt AReplaceCount, const System::UnicodeString SDescription = System::UnicodeString());
	bool __fastcall CanUndo();
	bool __fastcall CanRedo();
	bool __fastcall Redo();
	bool __fastcall Undo();
	int __fastcall BeginUpdate();
	int __fastcall EndUpdate();
	void __fastcall Reset(bool AResetRedo = true);
	void __fastcall RemoveLastUndo();
	__property TPointerInt Count = {read=FCount, write=SetCount, nodefault};
	__property TPointerInt UpdateCount = {read=FUpdateCount, nodefault};
	__property System::UnicodeString Description = {read=FDescription};
	__property TBCHUndoFlag UndoKind = {read=GetLastUndoKind, nodefault};
	/* Hoisted overloads: */
	
public:
	inline void __fastcall  SetSize(System::LongInt NewSize){ System::Classes::TMemoryStream::SetSize(NewSize); }
	
};

#pragma pack(pop)

typedef System::StaticArray<System::UnicodeString, 6> Bchexeditor__7;

typedef System::StaticArray<System::UnicodeString, 6> Bchexeditor__8;

//-- var, const, procedure ---------------------------------------------------
static _DELPHI_CONST System::Word BCH_FILEIO_BLOCKSIZE = System::Word(0xf000);
static _DELPHI_CONST System::Word CM_INTUPDATECARET = System::Word(0xb100);
static _DELPHI_CONST System::Word CM_SELECTIONCHANGED = System::Word(0xb101);
extern DELPHI_PACKAGE TBCHCharConv BCH_CCONV_MAC;
extern DELPHI_PACKAGE TBCHCharConv BCH_CCONV_BCD38;
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_ASIS;
#define Bchexeditor_BCH_TK_ASIS System::LoadResourceString(&Bchexeditor::_BCH_TK_ASIS)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_DOS8;
#define Bchexeditor_BCH_TK_DOS8 System::LoadResourceString(&Bchexeditor::_BCH_TK_DOS8)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_ASCII7;
#define Bchexeditor_BCH_TK_ASCII7 System::LoadResourceString(&Bchexeditor::_BCH_TK_ASCII7)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_MAC;
#define Bchexeditor_BCH_TK_MAC System::LoadResourceString(&Bchexeditor::_BCH_TK_MAC)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_BCD38;
#define Bchexeditor_BCH_TK_BCD38 System::LoadResourceString(&Bchexeditor::_BCH_TK_BCD38)
extern DELPHI_PACKAGE System::ResourceString _BCH_UC;
#define Bchexeditor_BCH_UC System::LoadResourceString(&Bchexeditor::_BCH_UC)
extern DELPHI_PACKAGE System::ResourceString _BCH_UC_BE;
#define Bchexeditor_BCH_UC_BE System::LoadResourceString(&Bchexeditor::_BCH_UC_BE)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_ASIS_S;
#define Bchexeditor_BCH_TK_ASIS_S System::LoadResourceString(&Bchexeditor::_BCH_TK_ASIS_S)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_DOS8_S;
#define Bchexeditor_BCH_TK_DOS8_S System::LoadResourceString(&Bchexeditor::_BCH_TK_DOS8_S)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_ASCII7_S;
#define Bchexeditor_BCH_TK_ASCII7_S System::LoadResourceString(&Bchexeditor::_BCH_TK_ASCII7_S)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_MAC_S;
#define Bchexeditor_BCH_TK_MAC_S System::LoadResourceString(&Bchexeditor::_BCH_TK_MAC_S)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_BCD38_S;
#define Bchexeditor_BCH_TK_BCD38_S System::LoadResourceString(&Bchexeditor::_BCH_TK_BCD38_S)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_CUSTOM_S;
#define Bchexeditor_BCH_TK_CUSTOM_S System::LoadResourceString(&Bchexeditor::_BCH_TK_CUSTOM_S)
extern DELPHI_PACKAGE System::ResourceString _BCH_TK_CUSTOM;
#define Bchexeditor_BCH_TK_CUSTOM System::LoadResourceString(&Bchexeditor::_BCH_TK_CUSTOM)
extern DELPHI_PACKAGE System::ResourceString _BCH_UC_S;
#define Bchexeditor_BCH_UC_S System::LoadResourceString(&Bchexeditor::_BCH_UC_S)
extern DELPHI_PACKAGE System::ResourceString _BCH_UC_BE_S;
#define Bchexeditor_BCH_UC_BE_S System::LoadResourceString(&Bchexeditor::_BCH_UC_BE_S)
extern DELPHI_PACKAGE Bchexeditor__7 BCHTranslationDesc;
extern DELPHI_PACKAGE Bchexeditor__8 BCHTranslationDescShort;
extern DELPHI_PACKAGE TBCHCharConv BCHCustomCharConv;
#define BCHOffsetHex L"-!10:0x|"
#define BCHOffsetDec L"a:|"
#define BCHOffsetOct L"0!8:o|"
extern DELPHI_PACKAGE void __fastcall TranslateBufferFromAnsi(const TBCHTranslationKind TType, char * aBuffer, char * bBuffer, const TPointerInt aCount);
extern DELPHI_PACKAGE void __fastcall TranslateBufferToAnsi(const TBCHTranslationKind TType, char * aBuffer, char * bBuffer, const TPointerInt aCount);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetTempName();
extern DELPHI_PACKAGE bool __fastcall IsKeyDown(int aKey);
extern DELPHI_PACKAGE TPointerInt __fastcall Min(TPointerInt a1, TPointerInt a2);
extern DELPHI_PACKAGE TPointerInt __fastcall Max(TPointerInt a1, TPointerInt a2);
extern DELPHI_PACKAGE TGridCoord __fastcall GridCoord(System::LongInt aX, System::LongInt aY);
extern DELPHI_PACKAGE char * __fastcall ConvertHexToBin(System::WideChar * aFrom, char * aTo, const TPointerInt aCount, const bool SwapNibbles, TPointerInt &BytesTranslated);
extern DELPHI_PACKAGE System::WideChar * __fastcall ConvertBinToHex(char * aFrom, System::WideChar * aTo, const TPointerInt aCount, const bool SwapNibbles);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IntToRadix(int Value, System::Byte Radix);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IntToRadix64(__int64 Value, System::Byte Radix);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IntToRadixLen(int Value, System::Byte Radix, System::Byte Len);
extern DELPHI_PACKAGE __int64 __fastcall DivideU64(const __int64 Dividend, const __int64 Divisor);
extern DELPHI_PACKAGE bool __fastcall TryDivideU64(const __int64 Dividend, const __int64 Divisor, __int64 &Val);
extern DELPHI_PACKAGE __int64 __fastcall ModuloU64(const __int64 Dividend, const __int64 Divisor);
extern DELPHI_PACKAGE bool __fastcall TryModuloU64(const __int64 Dividend, const __int64 Divisor, __int64 &Val);
extern DELPHI_PACKAGE bool __fastcall TryMultiplyU64(const __int64 Multiplier, const __int64 Multiplicator, __int64 &Val);
extern DELPHI_PACKAGE __int64 __fastcall MultiplyU64(const __int64 Multiplier, const __int64 Multiplicator);
extern DELPHI_PACKAGE bool __fastcall TryAddU64(const __int64 Addend1, const __int64 Addend2, __int64 &Val);
extern DELPHI_PACKAGE __int64 __fastcall AddU64(const __int64 Addend1, const __int64 Addend2);
extern DELPHI_PACKAGE bool __fastcall TrySubtractU64(const __int64 Minuend, const __int64 Subtrahend, __int64 &Val);
extern DELPHI_PACKAGE __int64 __fastcall SubtractU64(const __int64 Minuend, const __int64 Subtrahend);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IntToRadixLen64(__int64 Value, System::Byte Radix, System::Byte Len);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IntToOctal(const int Value);
extern DELPHI_PACKAGE int __fastcall RadixToInt(System::UnicodeString Value, System::Byte Radix);
extern DELPHI_PACKAGE __int64 __fastcall RadixToInt64(System::UnicodeString Value, System::Byte Radix);
extern DELPHI_PACKAGE int __fastcall CheckRadixToInt(System::UnicodeString Value);
extern DELPHI_PACKAGE __int64 __fastcall CheckRadixToInt64(System::UnicodeString Value);
extern DELPHI_PACKAGE int __fastcall OctalToInt(const System::UnicodeString Value);
extern DELPHI_PACKAGE void __fastcall SwapWideChar(System::WideChar &WChar);
extern DELPHI_PACKAGE System::Uitypes::TColor __fastcall FadeToGray(System::Uitypes::TColor aColor);
}	/* namespace Bchexeditor */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_BCHEXEDITOR)
using namespace Bchexeditor;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// BCHexEditorHPP
