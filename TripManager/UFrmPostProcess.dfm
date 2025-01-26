object FrmPostProcess: TFrmPostProcess
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Post processing parameters'
  ClientHeight = 422
  ClientWidth = 565
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object PnlBot: TPanel
    Left = 0
    Top = 389
    Width = 565
    Height = 33
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      565
      33)
    object BtnCancel: TBitBtn
      Left = 484
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 398
      Top = 5
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
    Top = 272
    Width = 565
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
        Align = alClient
        Caption = 'Process Begin points'
        TabOrder = 0
      end
    end
    object PnlBeginData: TPanel
      Left = 161
      Top = 1
      Width = 403
      Height = 26
      Align = alClient
      TabOrder = 1
      object EdBeginStr: TEdit
        Left = 1
        Top = 1
        Width = 120
        Height = 24
        Align = alLeft
        TabOrder = 0
        Text = 'EdBeginStr'
        ExplicitHeight = 23
      end
      object CmbBeginSymbol: TComboBoxEx
        Left = 121
        Top = 1
        Width = 281
        Height = 24
        Align = alClient
        ItemsEx = <>
        TabOrder = 1
        Text = 'CmbBeginSymbol'
        Images = ImgListSymbols
      end
    end
  end
  object PnlEnd: TPanel
    Left = 0
    Top = 300
    Width = 565
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
        Align = alClient
        Caption = 'Process End points'
        TabOrder = 0
      end
    end
    object PnlEndData: TPanel
      Left = 161
      Top = 1
      Width = 403
      Height = 26
      Align = alClient
      TabOrder = 1
      object EdEndStr: TEdit
        Left = 1
        Top = 1
        Width = 120
        Height = 24
        Align = alLeft
        TabOrder = 0
        Text = 'EdEndStr'
        ExplicitHeight = 23
      end
      object CmbEndSymbol: TComboBoxEx
        Left = 121
        Top = 1
        Width = 281
        Height = 24
        Align = alClient
        ItemsEx = <>
        TabOrder = 1
        Text = 'CmbEndSymbol'
        Images = ImgListSymbols
      end
    end
  end
  object PnlWaypt: TPanel
    Left = 0
    Top = 328
    Width = 565
    Height = 28
    Align = alTop
    TabOrder = 5
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
        Align = alClient
        Caption = 'Process Way points'
        TabOrder = 0
      end
    end
    object PnlWayptData: TPanel
      Left = 161
      Top = 1
      Width = 403
      Height = 26
      Align = alClient
      TabOrder = 1
      object CmbWayPtCat: TComboBox
        Left = 121
        Top = 1
        Width = 281
        Height = 23
        Align = alClient
        TabOrder = 0
        Text = 'CmbWayPtCat'
        Items.Strings = (
          '-')
      end
      object EdWptStr: TEdit
        Left = 1
        Top = 1
        Width = 120
        Height = 24
        Align = alLeft
        ReadOnly = True
        TabOrder = 1
        Text = 'Not renamed'
        ExplicitHeight = 23
      end
    end
  end
  object PnlShape: TPanel
    Left = 0
    Top = 356
    Width = 565
    Height = 28
    Align = alTop
    TabOrder = 3
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
        Align = alClient
        Caption = 'Process Shaping points'
        TabOrder = 0
      end
    end
    object PnlShapeData: TPanel
      Left = 161
      Top = 1
      Width = 403
      Height = 26
      Align = alClient
      TabOrder = 1
      object CmbShapingName: TComboBox
        Left = 1
        Top = 1
        Width = 120
        Height = 23
        Align = alLeft
        TabOrder = 0
        Text = 'CmbShapingName'
        Items.Strings = (
          'Unchanged'
          'Route_Sequence'
          'Route_Distance'
          'Sequence_Route'
          'Distance_Route ')
      end
      object CmbDistanceUnit: TComboBox
        Left = 121
        Top = 1
        Width = 281
        Height = 23
        Align = alClient
        TabOrder = 1
        Text = 'CmbDistanceUnit'
        Items.Strings = (
          'Km'
          'Mile')
      end
    end
  end
  object MemoPostProcess: TMemo
    Left = 0
    Top = 0
    Width = 565
    Height = 272
    Align = alTop
    Lines.Strings = (
      'Post processing a gpx file does this.'
      ''
      'with Routes:'
      
        '- It clears the subclass field for Via and Shaping points. Preve' +
        'nts renaming on the XT'
      '- It puts the Shaping points on the road. AKA unglitching'
      ''
      'Optionally:'
      '- It renames the Begin and End points and assigns symbols.'
      
        '- It renames Shaping points to route name + Seq or route + Dista' +
        'nce'
      ''
      'with Way points:'
      'Optionally:'
      
        '- It assigns categories based on the GPX filename and the symbol' +
        ' used. '
      '  Waypoints are listed by category on the XT'
      ''
      'with Tracks:'
      
        '- It leaves them untouched. Tripmanager wil create tracks automa' +
        'tically when transferred to the XT.')
    ReadOnly = True
    TabOrder = 4
  end
  object ImgListSymbols: TImageList
    DrawingStyle = dsTransparent
    Masked = False
    Left = 409
    Top = 177
  end
end
