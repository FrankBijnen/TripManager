object FrmSendTo: TFrmSendTo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Send to'
  ClientHeight = 603
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
    end
  end
  object GrpSelDestination: TGroupBox
    Left = 0
    Top = 89
    Width = 592
    Height = 105
    Align = alTop
    Caption = 'Choose destination'
    TabOrder = 1
    object PCTDestination: TPageControl
      Left = 2
      Top = 17
      Width = 588
      Height = 86
      ActivePage = TabFolder
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
          Height = 56
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
        end
      end
      object TabFolder: TTabSheet
        Caption = 'Send to folder'
        ImageIndex = 1
        object MemoAdditional: TMemo
          Left = 0
          Top = 0
          Width = 580
          Height = 56
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
    Top = 194
    Width = 592
    Height = 34
    Align = alTop
    Caption = 'Destination device and folder(s)'
    TabOrder = 3
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
    Top = 228
    Width = 592
    Height = 38
    Align = alTop
    Caption = 'Model used for creating .trip files'
    TabOrder = 2
    object LblModel: TLabel
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
  object TvSelections: TTreeView
    Left = 0
    Top = 266
    Width = 592
    Height = 285
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
    Items.NodeData = {
      070900000009540054007200650065004E006F00640065003900000000000000
      00000000FFFFFFFFFFFFFFFF00000000010000000000000000010D5400720069
      0070007300200028002E00740072006900700029000000390000000000000000
      000000FFFFFFFFFFFFFFFF00000000010000000000000000010D540072006100
      63006B007300200028002E00670070007800290000004B000000000000000000
      0000FFFFFFFFFFFFFFFF00000000010000000000000000011643006F006D0070
      006C00650074006500200072006F007500740065007300200028002E00670070
      007800290000004B0000000000000000000000FFFFFFFFFFFFFFFF0000000001
      0000000000000000011653007400720069007000700065006400200072006F00
      7500740065007300200028002E00670070007800290000004100000000000000
      00000000FFFFFFFFFFFFFFFF0000000001000000000300000001115700610079
      00200070006F0069006E0074007300200028002E00670070007800290000004D
      0000000000000000000000FFFFFFFFFFFFFFFF00000000010000000000000000
      011741006400640020006F0072006900670069006E0061006C00200057006100
      7900200070006F0069006E007400730000005D0000000000000000000000FFFF
      FFFFFFFFFFFF00000000010000000000000000011F4100640064002000570061
      007900200070006F0069006E00740073002000660072006F006D002000560069
      006100200070006F0069006E0074007300200000006300000000000000000000
      00FFFFFFFFFFFFFFFF0000000001000000000000000001224100640064002000
      570061007900200070006F0069006E00740073002000660072006F006D002000
      530068006100700069006E006700200070006F0069006E007400730000005100
      00000000000000000000FFFFFFFFFFFFFFFF0000000001000000000300000001
      1950006F0069006E007400730020004F006600200049006E0074006500720065
      0073007400200028002E00670070006900290000003B00000000000000000000
      00FFFFFFFFFFFFFFFF00000000010000000000000000010E4100640064002000
      570061007900200070006F0069006E007400730000003B000000000000000000
      0000FFFFFFFFFFFFFFFF00000000010000000000000000010E41006400640020
      00560069006100200070006F0069006E00740073000000430000000000000000
      000000FFFFFFFFFFFFFFFF000000000100000000000000000112410064006400
      2000530068006100700069006E006700200070006F0069006E00740073000000
      450000000000000000000000FFFFFFFFFFFFFFFF000000000100000000000000
      00011347006F006F0067006C006500200045006100720074006800200028002E
      006B006D006C00290000003F0000000000000000000000FFFFFFFFFFFFFFFF00
      00000001000000000000000001104F0053004D0020006D006100700073002000
      28002E0068006D0074006C00290000003B0000000000000000000000FFFFFFFF
      FFFFFFFF00000000010000000000000000010E43006F00750072007300650073
      00200028002E006600690074002900}
  end
  object PnlBot: TPanel
    Left = 0
    Top = 570
    Width = 592
    Height = 33
    Align = alBottom
    TabOrder = 6
    DesignSize = (
      592
      33)
    object BtnCancel: TBitBtn
      Left = 509
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object BtnOk: TBitBtn
      Left = 428
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
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
    Top = 551
    Width = 592
    Height = 19
    Panels = <>
    SimplePanel = True
  end
end
