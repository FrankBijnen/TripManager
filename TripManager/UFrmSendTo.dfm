object FrmSendTo: TFrmSendTo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Send to'
  ClientHeight = 607
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object GrpTasks: TGroupBox
    Left = 0
    Top = 0
    Width = 592
    Height = 89
    Align = alTop
    Caption = 'How to use'
    TabOrder = 0
    ExplicitWidth = 590
    object MemoTasks: TMemo
      Left = 2
      Top = 17
      Width = 588
      Height = 70
      TabStop = False
      Align = alClient
      Color = clInfoBk
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = []
      Lines.Strings = (
        '- Choose destination.'
        
          '- Verify the destination device and folders(s). (If required cor' +
          'rect on the main screen.)'
        
          '- Verify the model used for creating .trip files, if applicable.' +
          ' (If required correct on the main screen.)'
        '- Check the file types to send and click OK.')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
      StyleElements = [seFont, seBorder]
      ExplicitWidth = 586
    end
  end
  object GrpSelDestination: TGroupBox
    Left = 0
    Top = 89
    Width = 592
    Height = 108
    Align = alTop
    Caption = 'Choose destination'
    TabOrder = 1
    ExplicitWidth = 590
    object PCTDestination: TPageControl
      Left = 2
      Top = 17
      Width = 588
      Height = 89
      ActivePage = TabDevice
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      MultiLine = True
      ParentFont = False
      RaggedRight = True
      TabHeight = 20
      TabOrder = 0
      TabStop = False
      OnChange = PCTDestinationChange
      OnChanging = PCTDestinationChanging
      ExplicitWidth = 586
      object TabDevice: TTabSheet
        Caption = 'Send to device'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
        object MemoTransfer: TMemo
          Left = 0
          Top = 0
          Width = 580
          Height = 59
          TabStop = False
          Align = alClient
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          Lines.Strings = (
            
              #39'Send to device'#39' takes the selected GPX files, containing valid ' +
              'routes, or Way points, and stores them on the '
            
              'device in the Destination folders converted to the desired forma' +
              't. Conversion to .trip and .gpi format will be '
            
              'done automatically. Creation of tracks, stripped routes and wayp' +
              'oints is supported for the .gpx format.')
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          StyleElements = [seFont, seBorder]
          ExplicitWidth = 578
        end
      end
      object TabFolder: TTabSheet
        Caption = 'Send to folder'
        ImageIndex = 1
        object MemoAdditional: TMemo
          Left = 0
          Top = 0
          Width = 580
          Height = 59
          Align = alClient
          Color = clInfoBk
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          Lines.Strings = (
            
              'Use '#39'Send to folder'#39' to save the files to a folder. This can be ' +
              'used as a backup, or to share.'
            ''
            
              'In addition the .kml and .html formats can be selected for use i' +
              'n other software.')
          ParentFont = False
          ReadOnly = True
          TabOrder = 0
          StyleElements = [seFont, seBorder]
        end
      end
    end
  end
  object GrpDestination: TGroupBox
    Left = 0
    Top = 197
    Width = 592
    Height = 40
    Align = alTop
    Caption = 'Destination device and folder(s)'
    TabOrder = 2
    ExplicitWidth = 590
    object LblDestinations: TLabel
      AlignWithMargins = True
      Left = 7
      Top = 19
      Width = 578
      Height = 15
      Margins.Left = 5
      Margins.Top = 2
      Margins.Right = 5
      Margins.Bottom = 2
      Align = alTop
      Color = clWindow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Transparent = False
      Layout = tlCenter
      WordWrap = True
      StyleElements = [seBorder]
      ExplicitWidth = 3
    end
  end
  object GrpModel: TGroupBox
    Left = 0
    Top = 237
    Width = 592
    Height = 40
    Align = alTop
    Caption = 'Model used for creating .trip files'
    TabOrder = 3
    ExplicitWidth = 590
    object PnlModel: TPanel
      Left = 2
      Top = 17
      Width = 588
      Height = 21
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 586
      object LblModel: TLabel
        AlignWithMargins = True
        Left = 6
        Top = 5
        Width = 189
        Height = 13
        Margins.Left = 5
        Margins.Top = 4
        Margins.Right = 5
        Margins.Bottom = 2
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        Transparent = False
        Layout = tlCenter
        StyleElements = [seBorder]
        ExplicitLeft = 4
        ExplicitTop = 4
        ExplicitWidth = 193
        ExplicitHeight = 20
      end
      object CmbTripOption: TComboBox
        Left = 200
        Top = 1
        Width = 387
        Height = 23
        Align = alRight
        Style = csDropDownList
        TabOrder = 0
        TabStop = False
        Items.Strings = (
          'Recalculation forced'
          'No recalculation forced (BC only)'
          'Preserve route to track (BC only)'
          'Preserve route to track + locations (BC only)'
          
            'Preserve route to track + locations + route prefs (BC, XT2/Tread' +
            ' 2 only)')
        ExplicitLeft = 198
      end
    end
  end
  object TvSelections: TTreeView
    Left = 0
    Top = 277
    Width = 592
    Height = 278
    Align = alClient
    AutoExpand = True
    CheckBoxes = True
    Indent = 19
    ParentShowHint = False
    ShowHint = False
    TabOrder = 4
    OnCheckStateChanged = TvSelectionsCheckStateChanged
    OnCheckStateChanging = TvSelectionsCheckStateChanging
    OnCollapsing = TvSelectionsCollapsing
    OnHint = TvSelectionsHint
    ExplicitWidth = 590
    ExplicitHeight = 274
  end
  object PnlBot: TPanel
    Left = 0
    Top = 574
    Width = 592
    Height = 33
    Align = alBottom
    TabOrder = 5
    ExplicitTop = 570
    ExplicitWidth = 590
    DesignSize = (
      592
      33)
    object BtnCancel: TBitBtn
      Left = 507
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      ExplicitLeft = 505
    end
    object BtnOk: TBitBtn
      Left = 426
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 424
    end
    object BtnHelp: TBitBtn
      Left = 6
      Top = 4
      Width = 100
      Height = 25
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 2
      OnClick = BtnHelpClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 555
    Width = 592
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitTop = 551
    ExplicitWidth = 590
  end
end
