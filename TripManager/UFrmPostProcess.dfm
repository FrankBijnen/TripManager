object FrmPostProcess: TFrmPostProcess
  Left = 0
  Top = 0
  ActiveControl = BtnOK
  BorderStyle = bsDialog
  Caption = 'Post processing parameters'
  ClientHeight = 516
  ClientWidth = 646
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
  object PnlBot: TPanel
    Left = 0
    Top = 483
    Width = 646
    Height = 33
    Align = alBottom
    TabOrder = 6
    DesignSize = (
      646
      33)
    object BtnCancel: TBitBtn
      Left = 552
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BtnOK: TBitBtn
      Left = 471
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PnlBegin: TPanel
    Left = 0
    Top = 335
    Width = 646
    Height = 28
    Align = alTop
    TabOrder = 1
    object PnlBeginCaption: TPanel
      Left = 1
      Top = 1
      Width = 160
      Height = 26
      Align = alLeft
      TabOrder = 0
      object ChkProcessBegin: TCheckBox
        Left = 1
        Top = 1
        Width = 158
        Height = 24
        TabStop = False
        Align = alClient
        Caption = 'Process Begin points'
        TabOrder = 0
      end
    end
    object PnlBeginData: TPanel
      Left = 161
      Top = 1
      Width = 484
      Height = 26
      Align = alClient
      TabOrder = 1
      object EdBeginStr: TEdit
        Left = 1
        Top = 1
        Width = 120
        Height = 24
        TabStop = False
        Align = alLeft
        TabOrder = 0
        Text = 'EdBeginStr'
        ExplicitHeight = 23
      end
      object CmbBeginSymbol: TComboBoxEx
        Left = 121
        Top = 1
        Width = 248
        Height = 24
        Align = alClient
        ItemsEx = <>
        TabOrder = 1
        TabStop = False
        Text = 'CmbBeginSymbol'
        Images = ImgListSymbols
      end
      object ChkBeginAddress: TCheckBox
        Left = 369
        Top = 1
        Width = 114
        Height = 24
        TabStop = False
        Align = alRight
        Caption = 'Lookup Address'
        TabOrder = 2
      end
    end
  end
  object PnlEnd: TPanel
    Left = 0
    Top = 363
    Width = 646
    Height = 28
    Align = alTop
    TabOrder = 2
    object PnlEndCaption: TPanel
      Left = 1
      Top = 1
      Width = 160
      Height = 26
      Align = alLeft
      TabOrder = 0
      object ChkProcessEnd: TCheckBox
        Left = 1
        Top = 1
        Width = 158
        Height = 24
        TabStop = False
        Align = alClient
        Caption = 'Process End points'
        TabOrder = 0
      end
    end
    object PnlEndData: TPanel
      Left = 161
      Top = 1
      Width = 484
      Height = 26
      Align = alClient
      TabOrder = 1
      object EdEndStr: TEdit
        Left = 1
        Top = 1
        Width = 120
        Height = 24
        TabStop = False
        Align = alLeft
        TabOrder = 0
        Text = 'EdEndStr'
        ExplicitHeight = 23
      end
      object CmbEndSymbol: TComboBoxEx
        Left = 121
        Top = 1
        Width = 248
        Height = 24
        Align = alClient
        ItemsEx = <>
        TabOrder = 1
        TabStop = False
        Text = 'CmbEndSymbol'
        Images = ImgListSymbols
      end
      object ChkEndAddress: TCheckBox
        Left = 369
        Top = 1
        Width = 114
        Height = 24
        TabStop = False
        Align = alRight
        Caption = 'Lookup Address'
        TabOrder = 2
      end
    end
  end
  object PnlWaypt: TPanel
    Left = 0
    Top = 391
    Width = 646
    Height = 28
    Align = alTop
    TabOrder = 3
    object PnlWayptCaption: TPanel
      Left = 1
      Top = 1
      Width = 160
      Height = 26
      Align = alLeft
      TabOrder = 0
      object ChkProcessWpt: TCheckBox
        Left = 1
        Top = 1
        Width = 158
        Height = 24
        TabStop = False
        Align = alClient
        Caption = 'Process Way points'
        TabOrder = 0
      end
    end
    object PnlWayptData: TPanel
      Left = 161
      Top = 1
      Width = 484
      Height = 26
      Align = alClient
      TabOrder = 1
      object CmbWayPtCat: TComboBoxEx
        Left = 121
        Top = 1
        Width = 248
        Height = 24
        Align = alClient
        ItemsEx = <>
        TabOrder = 0
        TabStop = False
        Text = 'CmbWayPtCat'
      end
      object EdWptStr: TEdit
        Left = 1
        Top = 1
        Width = 120
        Height = 24
        TabStop = False
        Align = alLeft
        Enabled = False
        ReadOnly = True
        TabOrder = 1
        Text = 'Not renamed'
        ExplicitHeight = 23
      end
      object ChkWayPtAddress: TCheckBox
        Left = 369
        Top = 1
        Width = 114
        Height = 24
        TabStop = False
        Align = alRight
        Caption = 'Lookup Address'
        TabOrder = 2
      end
    end
  end
  object PnlVia: TPanel
    Left = 0
    Top = 419
    Width = 646
    Height = 28
    Align = alTop
    TabOrder = 4
    object PnlViaCaption: TPanel
      Left = 1
      Top = 1
      Width = 160
      Height = 26
      Align = alLeft
      TabOrder = 0
      object ChkProcessVia: TCheckBox
        Left = 1
        Top = 1
        Width = 158
        Height = 24
        TabStop = False
        Align = alClient
        Caption = 'Process Via points'
        TabOrder = 0
      end
    end
    object PnlViaData: TPanel
      Left = 161
      Top = 1
      Width = 484
      Height = 26
      Align = alClient
      TabOrder = 1
      object EdViaPtStr: TEdit
        Left = 1
        Top = 1
        Width = 120
        Height = 24
        TabStop = False
        Align = alLeft
        Enabled = False
        TabOrder = 0
        Text = 'Not renamed'
        ExplicitHeight = 23
      end
      object EdViaPtChanged: TEdit
        Left = 121
        Top = 1
        Width = 248
        Height = 24
        TabStop = False
        Align = alClient
        Enabled = False
        TabOrder = 1
        Text = 'Not changed'
        ExplicitHeight = 23
      end
      object ChkViaAddress: TCheckBox
        Left = 369
        Top = 1
        Width = 114
        Height = 24
        TabStop = False
        Align = alRight
        Caption = 'Lookup Address'
        TabOrder = 2
      end
    end
  end
  object PnlShape: TPanel
    Left = 0
    Top = 447
    Width = 646
    Height = 28
    Align = alTop
    TabOrder = 5
    object PnlShapeCaption: TPanel
      Left = 1
      Top = 1
      Width = 160
      Height = 26
      Align = alLeft
      TabOrder = 0
      object ChkProcessShape: TCheckBox
        Left = 1
        Top = 1
        Width = 158
        Height = 24
        TabStop = False
        Align = alClient
        Caption = 'Process Shaping points'
        TabOrder = 0
      end
    end
    object PnlShapeData: TPanel
      Left = 161
      Top = 1
      Width = 484
      Height = 26
      Align = alClient
      TabOrder = 1
      object CmbShapingName: TComboBoxEx
        Left = 1
        Top = 1
        Width = 120
        Height = 24
        Align = alLeft
        ItemsEx = <>
        TabOrder = 0
        TabStop = False
        Text = 'CmbShapingName'
      end
      object CmbDistanceUnit: TComboBoxEx
        Left = 121
        Top = 1
        Width = 248
        Height = 24
        Align = alClient
        ItemsEx = <>
        TabOrder = 1
        TabStop = False
        Text = 'CmbDistanceUnit'
      end
      object ChkShapeAddress: TCheckBox
        Left = 369
        Top = 1
        Width = 114
        Height = 24
        TabStop = False
        Align = alRight
        Caption = 'Lookup Address'
        TabOrder = 2
      end
    end
  end
  object MemoPostProcess: TMemo
    Left = 0
    Top = 0
    Width = 646
    Height = 335
    TabStop = False
    Align = alTop
    Lines.Strings = (
      'Post processing a gpx file does this.'
      ''
      'With routes:'
      
        '- It clears the subclass field for Via and Shaping points. Preve' +
        'nts renaming on the XT(2)'
      '- It puts the Shaping points on the road. AKA unglitching'
      ''
      'Optionally:'
      '- It renames the Begin and End points and assigns symbols.'
      
        '- It renames Shaping points to route name + Seq or route + Dista' +
        'nce'
      
        '- Looks up the address of Begin, End, Via and Shaping points and' +
        '  saves it in <cmt>.'
      ''
      'with Way points:'
      'Optionally:'
      
        '- It assigns categories based on the GPX filename and the symbol' +
        ' used. '
      '  Waypoints are listed by category on the XT'
      '- Lookup the address and save it in <cmt> and <address>'
      ''
      'with Tracks:'
      
        '- It leaves them untouched. Tripmanager wil create tracks automa' +
        'tically when transferred to the XT.'
      ''
      'It saves the GPX '#39'in place'#39'.')
    ReadOnly = True
    TabOrder = 0
  end
  object ImgListSymbols: TImageList
    DrawingStyle = dsTransparent
    Masked = False
    Left = 409
    Top = 177
  end
end
