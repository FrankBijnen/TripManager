object FrmEditRoutePref: TFrmEditRoutePref
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Route Preferences'
  ClientHeight = 465
  ClientWidth = 518
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
    Top = 432
    Width = 518
    Height = 33
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 428
    ExplicitWidth = 516
    DesignSize = (
      518
      33)
    object BtnCancel: TBitBtn
      Left = 428
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 426
    end
    object BtnOK: TBitBtn
      Left = 345
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      ExplicitLeft = 343
    end
  end
  object VlRoutePrefs: TValueListEditor
    Left = 0
    Top = 89
    Width = 518
    Height = 343
    Align = alClient
    TabOrder = 1
    TitleCaptions.Strings = (
      'Location'
      'Route Preference')
    OnGetPickList = VlRoutePrefsGetPickList
    OnStringsChange = VlRoutePrefsStringsChange
    ExplicitWidth = 516
    ExplicitHeight = 339
    ColWidths = (
      150
      362)
  end
  object PnlIncludeRoads: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 89
    Align = alTop
    TabOrder = 2
    ExplicitWidth = 516
    object GrpIncludeRoads: TGroupBox
      Left = 1
      Top = 1
      Width = 516
      Height = 87
      Align = alClient
      Caption = 'Find Routes Including'
      TabOrder = 0
      ExplicitWidth = 514
      object ChkInclHills: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 66
        Width = 484
        Height = 17
        Margins.Right = 25
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'Hills and Curves'
        TabOrder = 0
        OnClick = ChkInclRoadsClick
        ExplicitWidth = 482
      end
      object ChkInclScenic: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 43
        Width = 484
        Height = 17
        Margins.Right = 25
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'MICHELIN Scenic Roads'
        TabOrder = 1
        OnClick = ChkInclRoadsClick
        ExplicitWidth = 482
      end
      object ChkInclPopular: TCheckBox
        AlignWithMargins = True
        Left = 5
        Top = 20
        Width = 484
        Height = 17
        Margins.Right = 25
        Align = alTop
        Alignment = taLeftJustify
        Caption = 'Popular Paths (Moto)'
        TabOrder = 2
        OnClick = ChkInclRoadsClick
        ExplicitWidth = 482
      end
    end
  end
end
