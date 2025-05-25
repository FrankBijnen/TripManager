unit ListViewSort;

interface

uses System.SysUtils, System.Classes, Winapi.Windows,
     Vcl.ComCtrls, Winapi.CommCtrl, System.Math, System.DateUtils;
type
  TSortSpecification = record
    Column: TListColumn;
    Ascending: Boolean;
    UseObject: Boolean;
    CompareItems: function(const s1, s2: string): Integer;
  end;

  THeaderSortState = (hssNone, hssAscending, hssDescending);

// Listview Sort
function CompareTextAsInteger(const s1, s2: string): Integer;
function CompareTextAsDateTime(const s1, s2: string): Integer;
function GetListHeaderSortState(HeaderLView: TCustomListView; Column: TListColumn): THeaderSortState;
procedure SetListHeaderSortState(HeaderLView: TCustomListView; Column: TListColumn; Value: THeaderSortState);
procedure ListViewCompare(Item1, Item2: TListItem;
                          FSortSpecification:TSortSpecification;
                          Data: Integer; var Compare: Integer);
procedure InitSortSpec(Column: TListColumn;
                       Ascending: Boolean;
                       var FSortSpecification:TSortSpecification);
procedure DoListViewSort(AListView: TlistView;
                         Column: TListColumn;
                         Ascending: Boolean;
                         var FSortSpecification:TSortSpecification);
procedure ListViewColumnClick(AListView: TlistView;
                              Column: TListColumn;
                              var FSortSpecification:TSortSpecification);

implementation

uses System.Types, UnitMtpDevice;

function SafeStrToInt64(const S: string): int64;
begin
  try
    result := StrToInt(S);
  except
    result := 0;
  end;
end;

function CompareTextAsInteger(const s1, s2: string): Integer;
begin
  Result := CompareValue(SafeStrToInt64(s1), SafeStrToInt64(s2));
end;

function CompareTextAsDateTime(const s1, s2: string): Integer;
begin
  Result := CompareDateTime(StrToDateTime(s1), StrToDateTime(s2));
end;

function GetListHeaderSortState(HeaderLView: TCustomListView; Column: TListColumn): THeaderSortState;
var
  Header: HWND;
  Item: THDItem;
begin
  Header := ListView_GetHeader(HeaderLView.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;
  Header_GetItem(Header, Column.Index, Item);
  if Item.fmt and HDF_SORTUP <> 0 then
    Result := hssAscending
  else if Item.fmt and HDF_SORTDOWN <> 0 then
    Result := hssDescending
  else
    Result := hssNone;
end;

procedure SetListHeaderSortState(HeaderLView: TCustomListView; Column: TListColumn; Value: THeaderSortState);
var
  Header: HWND;
  Item: THDItem;
begin
  Header := ListView_GetHeader(HeaderLView.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;
  Header_GetItem(Header, Column.Index, Item);
  Item.fmt := Item.fmt and not (HDF_SORTUP or HDF_SORTDOWN); //remove both flags
  case Value of
    hssAscending:
      Item.fmt := Item.fmt or HDF_SORTUP;
    hssDescending:
      Item.fmt := Item.fmt or HDF_SORTDOWN;
  end;
  Header_SetItem(Header, Column.Index, Item);
end;

procedure ListViewCompare(Item1, Item2: TListItem;
                          FSortSpecification:TSortSpecification;
                          Data: Integer; var Compare: Integer);
var
  Index: Integer;
  s1, s2: string;
begin
  Index := FSortSpecification.Column.Index;
  if FSortSpecification.UseObject then
  begin
    Compare:=CompareValue(TBASE_Data(Item1.Data).SortValue,
                          TBASE_Data(Item2.Data).SortValue);
  end
  else
  begin
    if Index = 0 then
    begin
      s1 := IntToStr(Item1.ImageIndex * -1) + Item1.Caption;   // Directories first
      s2 := IntToStr(Item2.ImageIndex * -1) + Item2.Caption;
    end
    else
    begin
      s1 := '';
      if (Item1.SubItems.Count > Index-1) then
        s1 := Item1.SubItems[Index-1];
      s2 := '';
      if (Item2.SubItems.Count > Index-1) then
        s2 := Item2.SubItems[Index-1];
    end;
    Compare := FSortSpecification.CompareItems(s1, s2);
  end;
  if not FSortSpecification.Ascending then
    Compare := -Compare;
end;

procedure InitSortSpec(Column: TListColumn;
                       Ascending: Boolean;
                       var FSortSpecification:TSortSpecification);
begin
  FSortSpecification.Column := Column;
  FSortSpecification.Ascending := Ascending;
  FSortSpecification.UseObject := (Column.Tag = 1);
  FSortSpecification.CompareItems := CompareText;
end;

procedure DoListViewSort(AListView: TlistView;
                         Column: TListColumn;
                         Ascending: Boolean;
                         var FSortSpecification:TSortSpecification);
begin
  InitSortSpec(Column, Ascending, FSortSpecification);
  AListView.AlphaSort;
end;

procedure ListViewColumnClick(AListView: TlistView;
                              Column: TListColumn;
                              var FSortSpecification:TSortSpecification);
var
  I: Integer;
  Ascending: Boolean;
  State: THeaderSortState;
begin
  Ascending := GetListHeaderSortState(AListView, Column)<>hssAscending;
  DoListViewSort(AListView, Column, Ascending, FSortSpecification);
  for I := 0 to AListView.Columns.Count-1 do
  begin
    if AListView.Column[I]=Column then
      if Ascending then
        State := hssAscending
      else
        State := hssDescending
    else
      State := hssNone;
    SetListHeaderSortState(AListView, AListView.Column[I], State);
  end;
end;

end.
