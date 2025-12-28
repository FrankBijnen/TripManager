object FrmShowLog: TFrmShowLog
  Left = 0
  Top = 0
  ActiveControl = LbLog
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
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
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
    object BtnFixTrip: TButton
      Left = 10
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Fix Trip'
      TabOrder = 1
      OnMouseUp = BtnFixTripMouseUp
    end
    object BtnClose: TBitBtn
      Left = 538
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
  object LbLog: TCheckListBox
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
    ItemHeight = 15
    ParentFont = False
    PopupMenu = PopupListBox
    Style = lbOwnerDrawVariable
    TabOrder = 1
    OnClick = LbLogClick
    OnDrawItem = LbLogDrawItem
  end
  object SaveTrip: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 394
    Top = 161
  end
  object PopupListBox: TPopupMenu
    OnPopup = PopupListBoxPopup
    Left = 216
    Top = 160
    object PreferTrip: TMenuItem
      Caption = 'Prefer Trip'
      ShortCut = 16468
      OnClick = PreferTripClick
    end
    object PreferGpx: TMenuItem
      Caption = 'Prefer Gpx'
      ShortCut = 16455
      OnClick = PreferGpxClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object OpenFixedTrip: TMenuItem
      Caption = 'Open fixed trip'
      ShortCut = 16463
      OnClick = OpenFixedTripClick
    end
    object SavefixedGPX: TMenuItem
      Caption = 'Save fixed GPX'
      ShortCut = 16467
      OnClick = SavefixedGPXClick
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object NextSegment: TMenuItem
      Caption = 'Next Segment'
      ShortCut = 16452
      OnClick = NextSegmentClick
    end
    object PreviousSegment: TMenuItem
      Caption = 'Previous Segment'
      ShortCut = 16469
      OnClick = PreviousSegmentClick
    end
  end
end
