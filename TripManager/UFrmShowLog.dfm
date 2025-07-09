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
  KeyPreview = True
  OnKeyPress = FormKeyPress
  TextHeight = 15
  object PnlBot: TPanel
    Left = 0
    Top = 408
    Width = 624
    Height = 33
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      624
      33)
    object BtnClose: TBitBtn
      Left = 530
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Close'
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnCloseClick
    end
  end
  object LbLog: TListBox
    Left = 0
    Top = 0
    Width = 624
    Height = 408
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Consolas'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 1
    OnClick = LbLogClick
  end
end
