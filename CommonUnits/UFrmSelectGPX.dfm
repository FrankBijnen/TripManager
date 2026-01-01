object FrmSelectGPX: TFrmSelectGPX
  Left = 0
  Top = 0
  Caption = 'Select from GPX'
  ClientHeight = 307
  ClientWidth = 515
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  TextHeight = 13
  object LvTracks: TListView
    Left = 0
    Top = 83
    Width = 515
    Height = 195
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Route/Track name'
        Width = 255
      end
      item
        Caption = 'Wpt/Rte/Trk'
        Width = 75
      end
      item
        Caption = 'Color'
        Width = 100
      end
      item
        Caption = 'Points'
        Width = 55
      end>
    GridLines = True
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu
    ShowWorkAreas = True
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = LvTracksClick
  end
  object PnlTop: TPanel
    Left = 0
    Top = 0
    Width = 515
    Height = 29
    Align = alTop
    Caption = 'Select Routes/Tracks'
    TabOrder = 1
  end
  object PnlBot: TPanel
    Left = 0
    Top = 278
    Width = 515
    Height = 29
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      515
      29)
    object BitBtnOK: TBitBtn
      Left = 322
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtnCan: TBitBtn
      Left = 403
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PnlColor: TPanel
    Left = 0
    Top = 29
    Width = 515
    Height = 32
    Align = alTop
    TabOrder = 3
    object lblChangeColor: TLabel
      Left = 12
      Top = 8
      Width = 63
      Height = 13
      Caption = 'Change color'
    end
    object CmbOverruleColor: TComboBox
      Left = 94
      Top = 4
      Width = 197
      Height = 21
      TabOrder = 0
      Text = 'CmbOverruleColor'
      OnClick = CmbOverruleColorClick
      Items.Strings = (
        'No Change'
        'Black'
        'Blue'
        'Cyan'
        'DarkBlue'
        'DarkCyan'
        'DarkGray'
        'DarkGreen'
        'DarkMagenta'
        'DarkRed'
        'DarkYellow'
        'Green'
        'LightGray'
        'Magenta'
        'Red'
        'Transparent'
        'White'
        'Yellow')
    end
  end
  object PnlPreview: TPanel
    Left = 0
    Top = 61
    Width = 515
    Height = 22
    Align = alTop
    TabOrder = 4
    object LblPreview: TLabel
      Left = 173
      Top = 1
      Width = 341
      Height = 20
      Align = alClient
      Alignment = taCenter
      Caption = 'LblPreview'
      Layout = tlCenter
      WordWrap = True
      ExplicitWidth = 51
      ExplicitHeight = 13
    end
    object LblPercent: TLabel
      Left = 1
      Top = 1
      Width = 112
      Height = 20
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = 'exportPercent ('#8240') '
      Layout = tlCenter
    end
    object SpinPercent: TSpinEdit
      Left = 113
      Top = 1
      Width = 60
      Height = 22
      Align = alLeft
      AutoSize = False
      MaxValue = 1000
      MinValue = 1
      TabOrder = 0
      Value = 1
      OnChange = SpinPercentChange
      OnKeyUp = SpinPercentKeyUp
    end
  end
  object PopupMenu: TPopupMenu
    Left = 32
    Top = 112
    object CheckAll1: TMenuItem
      Caption = 'Check All'
      OnClick = CheckAll1Click
    end
    object CheckNone1: TMenuItem
      Caption = 'Check None'
      OnClick = CheckNone1Click
    end
  end
  object PercTimer: TTimer
    Interval = 250
    OnTimer = PercTimerTimer
    Left = 120
    Top = 120
  end
end
