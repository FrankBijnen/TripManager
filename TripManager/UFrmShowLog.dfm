object FrmShowLog: TFrmShowLog
  Left = 0
  Top = 0
  Caption = 'View Log'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object PnlBot: TPanel
    Left = 0
    Top = 408
    Width = 624
    Height = 33
    Align = alBottom
    TabOrder = 0
    ExplicitLeft = -22
    ExplicitWidth = 646
    DesignSize = (
      624
      33)
    object BtnClose: TBitBtn
      Left = 530
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkClose
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnCloseClick
    end
  end
  object MemoLog: TMemo
    Left = 0
    Top = 0
    Width = 624
    Height = 408
    Align = alClient
    Lines.Strings = (
      'MemoLog')
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
    ExplicitLeft = 56
    ExplicitTop = 80
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
end
