object FrmSelectGPX: TFrmSelectGPX
  Left = 0
  Top = 0
  Caption = 'Select from GPX'
  ClientHeight = 307
  ClientWidth = 489
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
    Top = 61
    Width = 489
    Height = 217
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Route/Track name'
        Width = 255
      end
      item
        Caption = 'Rte/Trk'
        Width = 55
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
    PopupMenu = PopupMenu1
    ShowWorkAreas = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object PnlTop: TPanel
    Left = 0
    Top = 0
    Width = 489
    Height = 29
    Align = alTop
    Caption = 'Select Routes/Tracks'
    TabOrder = 1
  end
  object PnlBot: TPanel
    Left = 0
    Top = 278
    Width = 489
    Height = 29
    Align = alBottom
    TabOrder = 2
    DesignSize = (
      489
      29)
    object BitBtnOK: TBitBtn
      Left = 296
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtnCan: TBitBtn
      Left = 377
      Top = 2
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object PnlClear: TPanel
    Left = 0
    Top = 29
    Width = 489
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
  object PopupMenu1: TPopupMenu
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
end
