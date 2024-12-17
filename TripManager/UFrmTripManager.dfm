object FrmTripManager: TFrmTripManager
  Left = 0
  Top = 0
  AlphaBlend = True
  Caption = 'XT Trip Manager'
  ClientHeight = 617
  ClientWidth = 1297
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object HSplitterDevFiles_Info: TSplitter
    Left = 0
    Top = 245
    Width = 1297
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 223
  end
  object VSplitterTripInfo_HexOSM: TSplitter
    Left = 631
    Top = 250
    Width = 5
    Height = 367
    ExplicitLeft = 1
    ExplicitTop = 1
    ExplicitHeight = 464
  end
  object PnlXTAndFileSys: TPanel
    Left = 0
    Top = 0
    Width = 1297
    Height = 245
    Align = alTop
    TabOrder = 0
    object VSplitterDev_Files: TSplitter
      Left = 631
      Top = 1
      Width = 5
      Height = 243
      ExplicitLeft = 722
      ExplicitTop = 6
      ExplicitHeight = 198
    end
    object PnlXTLeft: TPanel
      Left = 1
      Top = 1
      Width = 630
      Height = 243
      Align = alLeft
      TabOrder = 0
      object PnlDeviceTop: TPanel
        Left = 1
        Top = 1
        Width = 628
        Height = 32
        Align = alTop
        TabOrder = 1
        object CmbDevices: TComboBox
          AlignWithMargins = True
          Left = 196
          Top = 5
          Width = 100
          Height = 21
          Margins.Top = 4
          Align = alClient
          TabOrder = 2
          Text = 'Select an MTP device'
          OnChange = CmbDevicesChange
          Items.Strings = (
            'Select an MTP device')
        end
        object BtnRefresh: TButton
          AlignWithMargins = True
          Left = 95
          Top = 4
          Width = 95
          Height = 24
          Align = alLeft
          Caption = 'Refresh'
          TabOrder = 1
          OnClick = BtnRefreshClick
        end
        object BgDevice: TButtonGroup
          AlignWithMargins = True
          Left = 376
          Top = 4
          Width = 157
          Height = 24
          Align = alRight
          ButtonHeight = 20
          ButtonWidth = 50
          ButtonOptions = [gboGroupStyle, gboShowCaptions]
          Items = <
            item
              Caption = 'Trips'
            end
            item
              Caption = 'Gpx'
            end
            item
              Caption = 'Poi (Gpi)'
            end>
          ItemIndex = 0
          TabOrder = 4
          OnClick = BgDeviceClick
        end
        object BtnSetDeviceDefault: TButton
          AlignWithMargins = True
          Left = 539
          Top = 4
          Width = 85
          Height = 24
          Align = alRight
          Caption = 'Set as default'
          TabOrder = 5
          OnClick = BtnSetDeviceDefaultClick
        end
        object BtnFunctions: TButton
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 85
          Height = 24
          Align = alLeft
          Caption = 'Functions'
          TabOrder = 0
          OnMouseUp = BtnFunctionsMouseUp
        end
        object CmbModel: TComboBox
          AlignWithMargins = True
          Left = 302
          Top = 5
          Width = 68
          Height = 21
          Margins.Top = 4
          Align = alRight
          TabOrder = 3
          Text = 'Unknown'
          Items.Strings = (
            'XT'
            'XT2'
            'Unknown')
        end
      end
      object LstFiles: TListView
        Left = 1
        Top = 33
        Width = 628
        Height = 185
        Align = alClient
        Checkboxes = True
        Columns = <
          item
            Caption = 'Name'
            Width = 250
          end
          item
            Caption = 'Date'
            Width = 100
          end
          item
            Caption = 'Time'
            Width = 100
          end
          item
            Caption = 'Ext'
          end
          item
            Alignment = taRightJustify
            Caption = 'Size'
            Tag = 1
            Width = 100
          end>
        DoubleBuffered = True
        HideSelection = False
        LargeImages = ImageList
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        ParentDoubleBuffered = False
        SmallImages = ImageList
        TabOrder = 0
        ViewStyle = vsReport
        OnColumnClick = LstFilesColumnClick
        OnCompare = LstFilesCompare
        OnDblClick = LstFilesDblClick
        OnDeletion = LstFilesDeletion
        OnKeyUp = LstFilesKeyUp
        OnSelectItem = LstFilesSelectItem
        OnItemChecked = LstFilesItemChecked
      end
      object EdDeviceFolder: TEdit
        AlignWithMargins = True
        Left = 4
        Top = 221
        Width = 622
        Height = 21
        Margins.Bottom = 0
        Align = alBottom
        TabOrder = 2
        OnKeyPress = EdDeviceFolderKeyPress
      end
    end
    object PnlFileSys: TPanel
      Left = 636
      Top = 1
      Width = 660
      Height = 243
      Align = alClient
      TabOrder = 1
      object VSplitterFile_Sys: TSplitter
        Left = 247
        Top = 33
        Height = 184
        ExplicitLeft = 171
        ExplicitTop = 49
        ExplicitHeight = 100
      end
      object ShellTreeView1: TShellTreeView
        Left = 66
        Top = 33
        Width = 181
        Height = 184
        ObjectTypes = [otFolders]
        Root = 'rfDesktop'
        ShellListView = ShellListView1
        UseShellImages = True
        Align = alLeft
        AutoRefresh = False
        Indent = 19
        ParentColor = False
        RightClickSelect = True
        ShowRoot = False
        TabOrder = 0
        OnChange = ShellTreeView1Change
        OnCustomDrawItem = ShellTreeView1CustomDrawItem
      end
      object ShellListView1: TShellListView
        Left = 250
        Top = 33
        Width = 409
        Height = 184
        ObjectTypes = [otFolders, otNonFolders]
        Root = 'rfDesktop'
        ShellTreeView = ShellTreeView1
        Sorted = True
        OnAddFolder = ShellListView1AddFolder
        Align = alClient
        OnClick = ShellListView1Click
        ReadOnly = False
        GridLines = True
        HideSelection = False
        MultiSelect = True
        RowSelect = True
        OnColumnClick = ShellListView1ColumnClick
        TabOrder = 1
        ViewStyle = vsReport
        OnKeyUp = ShellListView1KeyUp
      end
      object PnlXt2FileSys: TPanel
        Left = 1
        Top = 33
        Width = 65
        Height = 184
        Align = alLeft
        TabOrder = 2
        object BtnFromDev: TButton
          AlignWithMargins = True
          Left = 4
          Top = 4
          Width = 57
          Height = 25
          Align = alTop
          Caption = '==>'
          TabOrder = 0
          OnClick = BtnFromDevClick
        end
        object BtnToDev: TButton
          AlignWithMargins = True
          Left = 4
          Top = 35
          Width = 57
          Height = 25
          Align = alTop
          Caption = '<=='
          TabOrder = 1
          OnClick = BtnToDevClick
        end
      end
      object PnlFileSysFunc: TPanel
        Left = 1
        Top = 1
        Width = 658
        Height = 32
        Align = alTop
        TabOrder = 4
        object BtnAddToMap: TButton
          AlignWithMargins = True
          Left = 170
          Top = 4
          Width = 85
          Height = 24
          Align = alLeft
          Caption = 'Add to map'
          TabOrder = 1
          OnClick = BtnAddToMapClick
        end
        object BtnTransferToDevice: TButton
          AlignWithMargins = True
          Left = 261
          Top = 4
          Width = 99
          Height = 24
          Align = alLeft
          Caption = 'Transfer to device'
          TabOrder = 2
          OnClick = BtnTransferToDeviceClick
        end
        object PnlTopFiller: TPanel
          Left = 1
          Top = 1
          Width = 65
          Height = 30
          Align = alLeft
          TabOrder = 5
          object ChkWatch: TCheckBox
            Left = 1
            Top = 1
            Width = 63
            Height = 28
            Align = alClient
            Caption = 'Watch'
            TabOrder = 0
            OnClick = ChkWatchClick
          end
        end
        object BtnRefreshFileSys: TButton
          AlignWithMargins = True
          Left = 69
          Top = 4
          Width = 95
          Height = 24
          Align = alLeft
          Caption = 'Refresh'
          TabOrder = 0
          OnClick = BtnRefreshFileSysClick
        end
        object BtnCreateAdditional: TButton
          AlignWithMargins = True
          Left = 457
          Top = 4
          Width = 85
          Height = 24
          Align = alLeft
          Caption = 'Additional files'
          TabOrder = 4
          OnClick = CreateAdditionalClick
        end
        object BtnPostProcess: TButton
          AlignWithMargins = True
          Left = 366
          Top = 4
          Width = 85
          Height = 24
          Align = alLeft
          Caption = 'Post process'
          TabOrder = 3
          OnClick = PostProcessClick
        end
      end
      object PnlBotFileSys: TPanel
        Left = 1
        Top = 217
        Width = 658
        Height = 25
        Align = alBottom
        TabOrder = 3
        ExplicitWidth = 656
        object EdFileSysFolder: TEdit
          AlignWithMargins = True
          Left = 69
          Top = 2
          Width = 585
          Height = 22
          Margins.Top = 1
          Margins.Bottom = 0
          Align = alClient
          TabOrder = 0
          OnKeyPress = EdFileSysFolderKeyPress
          ExplicitWidth = 583
          ExplicitHeight = 21
        end
        object Panel1: TPanel
          Left = 1
          Top = 1
          Width = 65
          Height = 23
          Align = alLeft
          TabOrder = 1
          object BtnOpenTemp: TButton
            Left = 1
            Top = 1
            Width = 63
            Height = 21
            Align = alClient
            Caption = 'Temp path'
            TabOrder = 0
            TabStop = False
            OnClick = BtnOpenTempClick
          end
        end
      end
    end
  end
  object PctHexOsm: TPageControl
    Left = 636
    Top = 250
    Width = 661
    Height = 367
    ActivePage = TsOSMMap
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 659
    ExplicitHeight = 363
    object TsHex: TTabSheet
      Caption = 'Hexadecimal display'
      object HexPanel: TPanel
        Left = 0
        Top = 0
        Width = 653
        Height = 339
        Align = alClient
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object PnlHexEditTrip: TPanel
          Left = 1
          Top = 1
          Width = 651
          Height = 25
          Align = alTop
          ParentBackground = False
          TabOrder = 0
          object BtnSaveTripFile: TButton
            Left = 1
            Top = 1
            Width = 131
            Height = 23
            Align = alLeft
            Caption = 'Save Trip File (From Hex)'
            Enabled = False
            TabOrder = 0
            OnClick = BtnSaveTripFileClick
          end
        end
      end
    end
    object TsOSMMap: TTabSheet
      Caption = 'OSM Map'
      ImageIndex = 1
      object AdvPanel_MapTop: TPanel
        Left = 0
        Top = 0
        Width = 653
        Height = 22
        Align = alTop
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnResize = AdvPanel_MapTopResize
        ExplicitWidth = 651
        object SpeedBtn_MapClear: TSpeedButton
          Left = 0
          Top = 0
          Width = 60
          Height = 22
          Align = alLeft
          Caption = 'Clear map'
          OnClick = SpeedBtn_MapClearClick
        end
        object Splitter1: TSplitter
          Left = 584
          Top = 0
          Height = 22
          ExplicitLeft = 545
          ExplicitTop = 5
          ExplicitHeight = 100
        end
        object EditMapCoords: TEdit
          Left = 242
          Top = 0
          Width = 143
          Height = 22
          Hint = 'Use Ctrl+Click on the map to set the Lat/Lon values'
          Align = alLeft
          MaxLength = 127
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TextHint = '0.1234, 0.1234'
          OnKeyDown = EditMapCoordsKeyDown
          ExplicitHeight = 21
        end
        object BtnApplyCoords: TButton
          Left = 60
          Top = 0
          Width = 106
          Height = 22
          Align = alLeft
          Caption = 'Apply Coordinates'
          Enabled = False
          TabOrder = 1
          OnClick = BtnApplyCoordsClick
        end
        object LblRoutePoint: TEdit
          Left = 587
          Top = 0
          Width = 66
          Height = 22
          Align = alClient
          ReadOnly = True
          TabOrder = 2
          Text = '-'
          ExplicitWidth = 64
          ExplicitHeight = 21
        end
        object PnlCoordinates: TPanel
          Left = 166
          Top = 0
          Width = 76
          Height = 22
          Align = alLeft
          Caption = 'Coordinates'
          ParentBackground = False
          TabOrder = 3
        end
        object PnlRoutePoint: TPanel
          Left = 385
          Top = 0
          Width = 76
          Height = 22
          Align = alLeft
          Caption = 'Route/Point'
          ParentBackground = False
          TabOrder = 4
        end
        object LblRoute: TEdit
          Left = 461
          Top = 0
          Width = 123
          Height = 22
          Align = alLeft
          ReadOnly = True
          TabOrder = 5
          Text = '-'
          ExplicitHeight = 21
        end
      end
      object AdvPanel_MapBottom: TPanel
        Left = 0
        Top = 302
        Width = 653
        Height = 37
        Align = alBottom
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        ExplicitTop = 298
        ExplicitWidth = 651
        object EditMapBounds: TLabeledEdit
          AlignWithMargins = True
          Left = 50
          Top = 6
          Width = 600
          Height = 28
          Hint = 'Coordinates of the visible area (South,West,North,East)'
          Margins.Left = 50
          Margins.Top = 6
          TabStop = False
          Align = alClient
          EditLabel.Width = 39
          EditLabel.Height = 28
          EditLabel.Caption = 'Bounds:'
          LabelPosition = lpLeft
          MaxLength = 200
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          Text = ''
          ExplicitWidth = 598
          ExplicitHeight = 21
        end
      end
      object EdgeBrowser1: TEdgeBrowser
        Left = 0
        Top = 22
        Width = 653
        Height = 280
        Align = alClient
        TabOrder = 2
        UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
        OnCreateWebViewCompleted = EdgeBrowser1CreateWebViewCompleted
        OnNavigationStarting = EdgeBrowser1NavigationStarting
        OnWebMessageReceived = EdgeBrowser1WebMessageReceived
        OnZoomFactorChanged = EdgeBrowser1ZoomFactorChanged
        ExplicitWidth = 651
        ExplicitHeight = 276
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 250
    Width = 631
    Height = 367
    ActivePage = TsTripInfo
    Align = alLeft
    TabOrder = 2
    ExplicitHeight = 363
    object TsTripInfo: TTabSheet
      Caption = 'Trip info'
      object VSplitterTree_Grid: TSplitter
        Left = 241
        Top = 22
        Width = 5
        Height = 317
        ExplicitTop = 0
        ExplicitHeight = 383
      end
      object PnlTripInfo: TPanel
        Left = 0
        Top = 0
        Width = 623
        Height = 22
        Align = alTop
        Caption = '-'
        Color = clGradientActiveCaption
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
        StyleElements = [seBorder]
      end
      object TvTrip: TTreeView
        Left = 0
        Top = 22
        Width = 241
        Height = 317
        Align = alLeft
        DoubleBuffered = True
        HideSelection = False
        Indent = 19
        ParentDoubleBuffered = False
        ReadOnly = True
        TabOrder = 0
        ToolTips = False
        OnChange = TvTripChange
        OnCustomDrawItem = TvTripCustomDrawItem
        ExplicitHeight = 313
      end
      object PnlVlTripInfo: TPanel
        Left = 246
        Top = 22
        Width = 377
        Height = 317
        Align = alClient
        TabOrder = 1
        ExplicitHeight = 313
        object VlTripInfo: TValueListEditor
          Left = 1
          Top = 27
          Width = 375
          Height = 289
          Align = alClient
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goAlwaysShowEditor, goThumbTracking]
          TabOrder = 0
          OnEditButtonClick = VlTripInfoEditButtonClick
          OnKeyDown = ValueListKeyDown
          OnSelectCell = VlTripInfoSelectCell
          OnStringsChange = VlTripInfoStringsChange
          ExplicitHeight = 285
          ColWidths = (
            150
            219)
        end
        object PnlVlTripInfoTop: TPanel
          Left = 1
          Top = 1
          Width = 375
          Height = 26
          Align = alTop
          TabOrder = 1
          object BtnSaveTripValues: TButton
            Left = 1
            Top = 1
            Width = 144
            Height = 22
            Caption = 'Save Trip File (From Values)'
            Enabled = False
            TabOrder = 0
            OnClick = BtnSaveTripValuesClick
          end
        end
      end
    end
  end
  object ImageList: TImageList
    Left = 124
    Top = 66
    Bitmap = {
      494C010102000800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000000000000000000000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      000000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF000000000000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000FFFFFF00FFFFFF0000000000FFFFFF000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000E007FFFF00000000
      E007FFFF00000000E007FFFF00000000E007C00F00000000E007800700000000
      E007800300000000E007800100000000E007800100000000E007800F00000000
      E007800F00000000E00F801F00000000E01FC0FF00000000E03FC0FF00000000
      FFFFFFFF00000000FFFFFFFF0000000000000000000000000000000000000000
      000000000000}
  end
  object DeviceMenu: TPopupMenu
    OwnerDraw = True
    OnPopup = DeviceMenuPopup
    Left = 34
    Top = 66
    object FileFunctions1: TMenuItem
      Caption = 'File Functions'
      GroupIndex = 1
    end
    object N2: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object Delete1: TMenuItem
      Caption = 'Delete selected files'
      GroupIndex = 1
      OnClick = Delete1Click
    end
    object Rename1: TMenuItem
      Caption = 'Rename file'
      GroupIndex = 1
      OnClick = RenameFile
    end
    object N1: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object TripFunctions1: TMenuItem
      Break = mbBarBreak
      Caption = 'Trip Functions'
      GroupIndex = 2
    end
    object N3: TMenuItem
      Caption = '-'
      GroupIndex = 2
    end
    object Setselectedtripstosaved1: TMenuItem
      Tag = 1
      Caption = 'Set selected trips to saved'
      GroupIndex = 2
      OnClick = SetSelectedTrips
    end
    object Setselectedtripstoimported1: TMenuItem
      Tag = 2
      Caption = 'Set selected trips to imported'
      GroupIndex = 2
      OnClick = SetSelectedTrips
    end
    object N4: TMenuItem
      Caption = '-'
      GroupIndex = 2
    end
    object Setdeparturedatetimeofselected1: TMenuItem
      Caption = 'Set departure date/time of selected trips'
      GroupIndex = 2
      OnClick = Setdeparturedatetimeofselected1Click
    end
    object N5: TMenuItem
      Caption = '-'
      GroupIndex = 2
    end
    object Renameselectedtripfilestotripname1: TMenuItem
      Caption = 'Rename selected trip files to trip name'
      GroupIndex = 2
      OnClick = Renameselectedtripfilestotripname1Click
    end
    object Groupselectedtrips1: TMenuItem
      Caption = 'Group selected trips'
      GroupIndex = 2
      OnClick = Groupselectedtrips1Click
    end
    object Ungroupselectedtrips1: TMenuItem
      Caption = 'Un-group selected trips'
      GroupIndex = 2
      OnClick = Ungroupselectedtrips1Click
    end
    object N6: TMenuItem
      Caption = '-'
      GroupIndex = 2
    end
    object Settransportationmodeofselectedtrips1: TMenuItem
      Caption = 'Set transportation mode of selected trips'
      GroupIndex = 2
      object Automotive1: TMenuItem
        Tag = 1
        Caption = 'Automotive'
        OnClick = TransportModeClick
      end
      object MotorCycling1: TMenuItem
        Tag = 9
        Caption = 'MotorCycling'
        OnClick = TransportModeClick
      end
      object OffRoad1: TMenuItem
        Tag = 10
        Caption = 'OffRoad'
        OnClick = TransportModeClick
      end
    end
    object Setroutepreferenceofselectedtrips1: TMenuItem
      Caption = 'Set route preference of selected trips'
      GroupIndex = 2
      object Fastertime1: TMenuItem
        Caption = 'Faster time'
        OnClick = RoutePreferenceClick
      end
      object Shorterdistance1: TMenuItem
        Tag = 1
        Caption = 'Shorter distance'
        OnClick = RoutePreferenceClick
      end
      object Directrouting1: TMenuItem
        Tag = 4
        Caption = 'Direct routing'
        OnClick = RoutePreferenceClick
      end
      object Curvyroads1: TMenuItem
        Tag = 7
        Caption = 'Curvy roads'
        OnClick = RoutePreferenceClick
      end
    end
  end
  object TripTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TripTimerTimer
    Left = 214
    Top = 66
  end
  object MapTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = MapTimerTimer
    Left = 304
    Top = 66
  end
  object PostProcessTimer: TTimer
    Enabled = False
    OnTimer = PostProcessTimerTimer
    Left = 397
    Top = 68
  end
end
