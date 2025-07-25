object FrmTripManager: TFrmTripManager
  Left = 0
  Top = 0
  AlphaBlend = True
  Caption = 'XT(2) Trip Manager'
  ClientHeight = 681
  ClientWidth = 1264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object HSplitterDevFiles_Info: TSplitter
    Left = 0
    Top = 270
    Width = 1264
    Height = 5
    Cursor = crVSplit
    Align = alTop
    ExplicitTop = 223
    ExplicitWidth = 1297
  end
  object VSplitterTripInfo_HexOSM: TSplitter
    Left = 620
    Top = 275
    Width = 5
    Height = 406
    ExplicitLeft = 1
    ExplicitTop = 1
    ExplicitHeight = 464
  end
  object PnlXTAndFileSys: TPanel
    Left = 0
    Top = 25
    Width = 1264
    Height = 245
    Align = alTop
    TabOrder = 0
    object VSplitterDev_Files: TSplitter
      Left = 621
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
      Width = 620
      Height = 243
      Align = alLeft
      TabOrder = 0
      object PnlDeviceTop: TPanel
        Left = 1
        Top = 1
        Width = 618
        Height = 32
        Align = alTop
        TabOrder = 1
        object CmbDevices: TComboBox
          AlignWithMargins = True
          Left = 166
          Top = 5
          Width = 135
          Height = 21
          Margins.Left = 1
          Margins.Top = 4
          Margins.Right = 1
          Align = alClient
          TabOrder = 2
          Text = 'Select an MTP device'
          OnChange = CmbDevicesChange
          Items.Strings = (
            'Select an MTP device')
        end
        object BtnRefresh: TButton
          AlignWithMargins = True
          Left = 84
          Top = 4
          Width = 80
          Height = 24
          Margins.Left = 1
          Margins.Right = 1
          Align = alLeft
          Caption = 'Refresh'
          TabOrder = 1
          OnClick = BtnRefreshClick
        end
        object BgDevice: TButtonGroup
          AlignWithMargins = True
          Left = 375
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
          Left = 536
          Top = 4
          Width = 80
          Height = 24
          Margins.Left = 1
          Margins.Right = 1
          Align = alRight
          Caption = 'Set as default'
          TabOrder = 5
          OnClick = BtnSetDeviceDefaultClick
        end
        object BtnFunctions: TButton
          AlignWithMargins = True
          Left = 2
          Top = 4
          Width = 80
          Height = 24
          Margins.Left = 1
          Margins.Right = 1
          Align = alLeft
          Caption = 'Functions'
          TabOrder = 0
          OnMouseUp = BtnFunctionsMouseUp
        end
        object CmbModel: TComboBox
          AlignWithMargins = True
          Left = 303
          Top = 5
          Width = 68
          Height = 21
          Margins.Left = 1
          Margins.Top = 4
          Margins.Right = 1
          Align = alRight
          TabOrder = 3
          Text = 'Unknown'
          OnChange = CmbModelChange
          Items.Strings = (
            'XT'
            'XT2'
            'Unknown')
        end
      end
      object LstFiles: TListView
        Left = 1
        Top = 33
        Width = 618
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
            Width = 85
          end
          item
            Caption = 'Time'
            Width = 85
          end
          item
            Caption = 'Ext'
            Width = 45
          end
          item
            Alignment = taRightJustify
            Caption = 'Size'
            Tag = 1
            Width = 90
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
        Width = 612
        Height = 21
        Margins.Bottom = 0
        Align = alBottom
        TabOrder = 2
        OnKeyPress = EdDeviceFolderKeyPress
      end
    end
    object PnlFileSys: TPanel
      Left = 626
      Top = 1
      Width = 637
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
        Width = 386
        Height = 184
        AutoNavigate = False
        ObjectTypes = [otFolders, otNonFolders]
        Root = 'rfDesktop'
        ShellTreeView = ShellTreeView1
        Sorted = True
        OnAddFolder = ShellListView1AddFolder
        Align = alClient
        OnClick = ShellListView1Click
        OnDblClick = ShellListView1DblClick
        ReadOnly = False
        GridLines = True
        HideSelection = False
        MultiSelect = True
        RowSelect = True
        OnColumnClick = ShellListView1ColumnClick
        TabOrder = 1
        ViewStyle = vsReport
        OnKeyDown = ShellListView1KeyDown
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
        Width = 635
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
          Left = 366
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
          TabOrder = 4
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
        object BtnPostProcess: TButton
          AlignWithMargins = True
          Left = 471
          Top = 4
          Width = 85
          Height = 24
          Align = alLeft
          Caption = 'Post process'
          TabOrder = 3
          OnClick = PostProcessClick
        end
        object BtnCreateAdditional: TButton
          AlignWithMargins = True
          Left = 562
          Top = 4
          Width = 85
          Height = 24
          Align = alLeft
          Caption = 'Additional files'
          TabOrder = 5
          OnClick = CreateAdditionalClick
        end
        object BtnSendTo: TButton
          AlignWithMargins = True
          Left = 261
          Top = 4
          Width = 99
          Height = 24
          Align = alLeft
          Caption = 'Send to'
          TabOrder = 6
          OnClick = BtnSendToClick
        end
      end
      object PnlBotFileSys: TPanel
        Left = 1
        Top = 217
        Width = 635
        Height = 25
        Align = alBottom
        TabOrder = 3
        object EdFileSysFolder: TEdit
          AlignWithMargins = True
          Left = 69
          Top = 2
          Width = 562
          Height = 22
          Margins.Top = 1
          Margins.Bottom = 0
          Align = alClient
          TabOrder = 0
          OnKeyPress = EdFileSysFolderKeyPress
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
    Left = 625
    Top = 275
    Width = 639
    Height = 406
    ActivePage = TsOSMMap
    Align = alClient
    TabOrder = 1
    object TsHex: TTabSheet
      Caption = 'Hexadecimal display'
      object HexPanel: TPanel
        Left = 0
        Top = 0
        Width = 631
        Height = 378
        Align = alClient
        Color = clWhite
        DoubleBuffered = True
        DoubleBufferedMode = dbmRequested
        FullRepaint = False
        ParentBackground = False
        ParentDoubleBuffered = False
        TabOrder = 0
        object PnlHexEditTrip: TPanel
          Left = 1
          Top = 1
          Width = 629
          Height = 25
          Align = alTop
          ParentBackground = False
          TabOrder = 0
          object BtnSaveTripGpiFile: TButton
            Left = 1
            Top = 1
            Width = 131
            Height = 23
            Align = alLeft
            Caption = 'Save File (From Hex)'
            Enabled = False
            TabOrder = 0
            OnClick = BtnSaveTripGpiFileClick
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
        Width = 631
        Height = 28
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
        object SpeedBtn_MapClear: TSpeedButton
          AlignWithMargins = True
          Left = 0
          Top = 1
          Width = 60
          Height = 26
          Margins.Left = 0
          Margins.Top = 1
          Margins.Right = 0
          Margins.Bottom = 1
          Align = alLeft
          Caption = 'Clear map'
          OnClick = SpeedBtn_MapClearClick
          ExplicitLeft = -3
          ExplicitTop = -6
          ExplicitHeight = 22
        end
        object BtnGeoSearch: TSpeedButton
          AlignWithMargins = True
          Left = 60
          Top = 1
          Width = 60
          Height = 26
          Margins.Left = 0
          Margins.Top = 1
          Margins.Right = 0
          Margins.Bottom = 1
          Align = alLeft
          Caption = 'Search'
          OnClick = BtnGeoSearchClick
          ExplicitTop = 0
          ExplicitHeight = 22
        end
        object SpltRoutePoint: TSplitter
          Left = 656
          Top = 0
          Height = 28
          ExplicitLeft = 545
          ExplicitTop = 5
          ExplicitHeight = 100
        end
        object EditMapCoords: TEdit
          AlignWithMargins = True
          Left = 305
          Top = 3
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
          Left = 120
          Top = 0
          Width = 106
          Height = 28
          Align = alLeft
          Caption = 'Apply Coordinates'
          Enabled = False
          TabOrder = 1
          OnClick = BtnApplyCoordsClick
        end
        object LblRoutePoint: TEdit
          AlignWithMargins = True
          Left = 662
          Top = 3
          Width = 29
          Height = 22
          Align = alClient
          ReadOnly = True
          TabOrder = 2
          Text = '-'
          ExplicitHeight = 21
        end
        object PnlCoordinates: TPanel
          Left = 226
          Top = 0
          Width = 76
          Height = 28
          Align = alLeft
          Caption = 'Coordinates'
          ParentBackground = False
          TabOrder = 3
        end
        object PnlRoutePoint: TPanel
          Left = 451
          Top = 0
          Width = 76
          Height = 28
          Align = alLeft
          Caption = 'Route/Point'
          ParentBackground = False
          TabOrder = 4
        end
        object LblRoute: TEdit
          AlignWithMargins = True
          Left = 530
          Top = 3
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
        Top = 348
        Width = 631
        Height = 30
        Align = alBottom
        BevelOuter = bvNone
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object LblBounds: TLabel
          AlignWithMargins = True
          Left = 116
          Top = 3
          Width = 35
          Height = 24
          Margins.Left = 10
          Align = alLeft
          Caption = 'Bounds'
          Layout = tlCenter
          ExplicitHeight = 13
        end
        object EditMapBounds: TEdit
          AlignWithMargins = True
          Left = 157
          Top = 5
          Width = 471
          Height = 22
          Hint = 'Coordinates of the visible area (South,West,North,East)'
          Margins.Top = 5
          TabStop = False
          Align = alClient
          MaxLength = 200
          ParentShowHint = False
          ReadOnly = True
          ShowHint = True
          TabOrder = 0
          ExplicitHeight = 21
        end
        object ChkZoomToPoint: TCheckBox
          Left = 0
          Top = 0
          Width = 106
          Height = 30
          Align = alLeft
          Alignment = taLeftJustify
          Caption = 'Zoom in on point'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object EdgeBrowser1: TEdgeBrowser
        Left = 0
        Top = 28
        Width = 631
        Height = 320
        Align = alClient
        TabOrder = 2
        AllowSingleSignOnUsingOSPrimaryAccount = False
        TargetCompatibleBrowserVersion = '117.0.2045.28'
        UserDataFolder = '%LOCALAPPDATA%\bds.exe.WebView2'
        OnCreateWebViewCompleted = EdgeBrowser1CreateWebViewCompleted
        OnNavigationStarting = EdgeBrowser1NavigationStarting
        OnWebMessageReceived = EdgeBrowser1WebMessageReceived
        OnZoomFactorChanged = EdgeBrowser1ZoomFactorChanged
      end
    end
  end
  object PCTTripInfo: TPageControl
    Left = 0
    Top = 275
    Width = 620
    Height = 406
    ActivePage = TsTripGpiInfo
    Align = alLeft
    TabOrder = 2
    OnResize = PCTTripInfoResize
    object TsTripGpiInfo: TTabSheet
      Caption = 'Trip info'
      object VSplitterTree_Grid: TSplitter
        Left = 241
        Top = 22
        Width = 5
        Height = 337
        ExplicitTop = 0
        ExplicitHeight = 383
      end
      object PnlTripGpiInfo: TPanel
        Left = 0
        Top = 0
        Width = 612
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
        Height = 337
        Align = alLeft
        DoubleBuffered = True
        DoubleBufferedMode = dbmRequested
        HideSelection = False
        Indent = 19
        ParentDoubleBuffered = False
        ReadOnly = True
        TabOrder = 0
        ToolTips = False
        OnChange = TvTripChange
        OnCustomDrawItem = TvTripCustomDrawItem
      end
      object PnlVlTripInfo: TPanel
        Left = 246
        Top = 22
        Width = 366
        Height = 337
        Align = alClient
        TabOrder = 1
        object VlTripInfo: TValueListEditor
          Left = 1
          Top = 27
          Width = 364
          Height = 309
          Align = alClient
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goThumbTracking]
          PopupMenu = PopupTripInfo
          TabOrder = 0
          OnEditButtonClick = VlTripInfoEditButtonClick
          OnKeyDown = ValueListKeyDown
          OnStringsChange = VlTripInfoStringsChange
          ColWidths = (
            150
            208)
        end
        object PnlVlTripInfoTop: TPanel
          Left = 1
          Top = 1
          Width = 364
          Height = 26
          Align = alTop
          TabOrder = 1
          object BtnSaveTripValues: TButton
            Left = 1
            Top = 1
            Width = 144
            Height = 24
            Align = alLeft
            Caption = 'Save Trip File (From Values)'
            Enabled = False
            TabOrder = 0
            OnClick = BtnSaveTripValuesClick
          end
          object BtnTripEditor: TButton
            Left = 145
            Top = 1
            Width = 75
            Height = 24
            Align = alLeft
            Caption = 'Trip Editor'
            TabOrder = 1
            OnMouseUp = BtnTripEditorMouseUp
          end
        end
      end
      object SbPostProcess: TStatusBar
        Left = 0
        Top = 359
        Width = 612
        Height = 19
        Panels = <
          item
            Width = 100
          end
          item
            Width = 50
          end>
      end
    end
  end
  object ActionMainMenuBar: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1264
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
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
    object DeleteFiles: TMenuItem
      Caption = 'Delete selected files'
      GroupIndex = 1
      OnClick = DeleteFilesClick
    end
    object Rename1: TMenuItem
      Caption = 'Rename file'
      GroupIndex = 1
      OnClick = RenameFile
    end
    object N9: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object DeleteDirs: TMenuItem
      Caption = 'Delete selected folders (incl. sub folders)'
      GroupIndex = 1
      OnClick = DeleteDirsClick
    end
    object NewDirectory: TMenuItem
      Caption = 'New folder'
      GroupIndex = 1
      OnClick = NewDirectoryClick
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
  object TripGpiTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = TripGpiTimerTimer
    Left = 214
    Top = 66
  end
  object MapTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = MapTimerTimer
    Left = 207
    Top = 202
  end
  object OpenTrip: TOpenDialog
    DefaultExt = 'trip'
    Filter = '*.trip|*.trip'
    Left = 456
    Top = 394
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = Action1
                Caption = '&About'
              end
              item
                Caption = '-'
              end
              item
                Action = Action2
                Caption = '&Online documentation'
              end>
            Caption = '&Help'
          end
          item
            Items = <
              item
                Action = Action3
                Caption = '&Settings'
              end>
            Caption = '&Advanced'
          end>
        ActionBar = ActionMainMenuBar
      end>
    Left = 313
    Top = 65
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'Help'
      Caption = 'About'
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Category = 'Help'
      Caption = 'Online documentation'
      OnExecute = Action2Execute
    end
    object Action3: TAction
      Category = 'Advanced'
      Caption = 'Settings'
      OnExecute = Action3Execute
    end
  end
  object PopupTripInfo: TPopupMenu
    OnPopup = PopupTripInfoPopup
    Left = 378
    Top = 393
    object CopyValueFromTrip: TMenuItem
      Caption = 'Copy value from trip file'
      OnClick = CopyValueFromTripClick
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object SaveCSV1: TMenuItem
      Caption = 'Save CSV'
      OnClick = SaveCSV1Click
    end
    object SaveGPX1: TMenuItem
      Caption = 'Save GPX'
      OnClick = SaveGPX1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object CompareTriptoGPX1: TMenuItem
      Caption = 'Compare Trip to GPX'
      object MnuCompareGpxTrack: TMenuItem
        Tag = 10
        Caption = 'By Point Location (Track or Route)'
        ShortCut = 49219
        OnClick = CompareWithGpx
      end
      object MnuCompareGpxRoute: TMenuItem
        Tag = 20
        Caption = 'By Point Location and Road Id (BC Calculated Route)'
        ShortCut = 49218
        OnClick = CompareWithGpx
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object MnuNextDiff: TMenuItem
        Caption = 'Next Difference'
        ShortCut = 16452
        OnClick = MnuNextDiffClick
      end
      object MnuPrevDiff: TMenuItem
        Caption = 'Previous difference'
        ShortCut = 16469
        OnClick = MnuPrevDiffClick
      end
    end
  end
  object SaveTrip: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 522
    Top = 393
  end
  object PopupTripEdit: TPopupMenu
    OnPopup = PopupTripEditPopup
    Left = 283
    Top = 394
    object MnuTripNewMTP: TMenuItem
      Caption = 'New trip (MTP device)'
      Enabled = False
      OnClick = MnuTripNewMTPClick
    end
    object NewtripWindows1: TMenuItem
      Caption = 'New trip (Windows)'
      OnClick = NewtripWindows1Click
    end
    object MnuTripEdit: TMenuItem
      Caption = 'Edit'
      Enabled = False
      OnClick = MnuTripEditClick
    end
  end
  object StatusTimer: TTimer
    Interval = 5000
    OnTimer = StatusTimerTimer
    Left = 209
    Top = 130
  end
end
