object FrmSendTo: TFrmSendTo
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Send to'
  ClientHeight = 530
  ClientWidth = 603
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
  object PnlTop: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 0
    Width = 593
    Height = 34
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = 'Choose destination'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object PCTDestination: TPageControl
    Left = 0
    Top = 34
    Width = 603
    Height = 102
    ActivePage = TabDevice
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    MultiLine = True
    ParentFont = False
    RaggedRight = True
    TabHeight = 35
    TabOrder = 1
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
        Width = 595
        Height = 57
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
        ExplicitHeight = 53
      end
    end
    object TabFolder: TTabSheet
      Caption = 'Send to folder'
      ImageIndex = 1
      object MemoAdditional: TMemo
        Left = 0
        Top = 0
        Width = 595
        Height = 57
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
          
            'In addtion the .kml and .html formats can be selected for use in' +
            ' other software.')
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        StyleElements = [seFont, seBorder]
        ExplicitHeight = 53
      end
    end
  end
  object GrpDestination: TGroupBox
    Left = 0
    Top = 174
    Width = 603
    Height = 34
    Align = alTop
    Caption = 'Destination folders'
    TabOrder = 3
    object LblDestinations: TLabel
      AlignWithMargins = True
      Left = 7
      Top = 19
      Width = 589
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
      ExplicitTop = 18
      ExplicitWidth = 3
    end
  end
  object GrpModel: TGroupBox
    Left = 0
    Top = 136
    Width = 603
    Height = 38
    Align = alTop
    Caption = 'Model used for creating .trip files'
    TabOrder = 2
    ExplicitTop = 132
    object LblModel: TLabel
      AlignWithMargins = True
      Left = 7
      Top = 19
      Width = 589
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
      ExplicitTop = 18
      ExplicitWidth = 3
    end
  end
  object TvSelections: TTreeView
    Left = 0
    Top = 208
    Width = 603
    Height = 270
    Align = alClient
    AutoExpand = True
    CheckBoxes = True
    Indent = 19
    ParentShowHint = False
    ShowHint = False
    TabOrder = 4
    OnCheckStateChanging = TvSelectionsCheckStateChanging
    OnCollapsing = TvSelectionsCollapsing
    OnHint = TvSelectionsHint
    Items.NodeData = {
      070800000009540054007200650065004E006F00640065003900000000000000
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
      28002E0068006D0074006C002900}
    ExplicitTop = 282
    ExplicitHeight = 220
  end
  object PnlBot: TPanel
    Left = 0
    Top = 497
    Width = 603
    Height = 33
    Align = alBottom
    TabOrder = 6
    ExplicitTop = 521
    DesignSize = (
      603
      33)
    object BtnCancel: TBitBtn
      Left = 513
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
    object BtnOk: TBitBtn
      Left = 432
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 478
    Width = 603
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitTop = 502
  end
end
