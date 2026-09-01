object FrmSelectGPX: TFrmSelectGPX
  Left = 0
  Top = 0
  Caption = 'Select from GPX'
  ClientHeight = 307
  ClientWidth = 524
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  Constraints.MinWidth = 531
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
    Top = 73
    Width = 524
    Height = 205
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
    Width = 524
    Height = 23
    Align = alTop
    Caption = 'Use the Checkboxes to select Routes/Tracks'
    TabOrder = 1
  end
  object PnlBot: TPanel
    Left = 0
    Top = 278
    Width = 524
    Height = 29
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      524
      29)
    object BitBtnOK: TBitBtn
      Left = 358
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtnCan: TBitBtn
      Left = 439
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
    Top = 23
    Width = 524
    Height = 27
    Align = alTop
    TabOrder = 3
    object lblChangeColor: TLabel
      Left = 12
      Top = 8
      Width = 63
      Height = 13
      Caption = 'Change color'
    end
    object LblMinTrackDist: TLabel
      Left = 306
      Top = 1
      Width = 157
      Height = 25
      Align = alRight
      Alignment = taCenter
      AutoSize = False
      Caption = 'Min distance track points (mtr)'
      Layout = tlCenter
      ExplicitLeft = 297
      ExplicitHeight = 30
    end
    object CmbOverruleColor: TComboBox
      Left = 94
      Top = 4
      Width = 197
      Height = 21
      TabOrder = 0
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
    object SpinMinTrackPtDist: TSpinEdit
      AlignWithMargins = True
      Left = 466
      Top = 4
      Width = 54
      Height = 19
      Hint = 'Can be used to filter the number of trackpoints'
      Align = alRight
      AutoSize = False
      MaxValue = 2500
      MinValue = 0
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Value = 1
      OnChange = SpinMinTrackPtDistChange
      OnKeyUp = SpinKeyUp
      ExplicitHeight = 22
    end
  end
  object PnlPreview: TPanel
    Left = 0
    Top = 50
    Width = 524
    Height = 23
    Align = alTop
    TabOrder = 4
    object LblPreview: TLabel
      Left = 173
      Top = 1
      Width = 51
      Height = 13
      Align = alClient
      Alignment = taCenter
      Caption = 'LblPreview'
      Layout = tlCenter
      WordWrap = True
    end
    object LblPercent: TLabel
      Left = 1
      Top = 1
      Width = 112
      Height = 21
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = 'exportPercent ('#8240') '
      Layout = tlCenter
      ExplicitHeight = 20
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
      OnKeyUp = SpinKeyUp
    end
  end
  object PopupMenu: TPopupMenu
    Left = 32
    Top = 112
    object CheckAll1: TMenuItem
      Caption = 'Check All'
      ShortCut = 16449
      OnClick = CheckAll1Click
    end
    object CheckNone1: TMenuItem
      Caption = 'Check None'
      ShortCut = 49217
      OnClick = CheckNone1Click
    end
  end
  object PercTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = PercTimerTimer
    Left = 120
    Top = 112
  end
  object TrackDistTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TrackDistTimerTimer
    Left = 208
    Top = 112
  end
end
