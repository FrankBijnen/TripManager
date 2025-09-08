object FrmEditRoutePref: TFrmEditRoutePref
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Route Preferences'
  ClientHeight = 432
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 15
  object PnlBot: TPanel
    Left = 0
    Top = 399
    Width = 512
    Height = 33
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      512
      33)
    object BtnCancel: TBitBtn
      Left = 426
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BtnOK: TBitBtn
      Left = 343
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object VlRoutePrefs: TValueListEditor
    Left = 0
    Top = 0
    Width = 512
    Height = 399
    Align = alClient
    TabOrder = 1
    TitleCaptions.Strings = (
      'Location'
      'Route Preference')
    OnGetPickList = VlRoutePrefsGetPickList
    OnStringsChange = VlRoutePrefsStringsChange
    ColWidths = (
      150
      356)
  end
end
