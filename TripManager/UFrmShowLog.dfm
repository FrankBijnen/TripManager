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
    object BtnTrip: TButton
      Left = 0
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Prefer Trip'
      TabOrder = 1
      OnClick = BtnTripClick
    end
    object BtnGpx: TButton
      Left = 77
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Prefer Gpx'
      TabOrder = 2
      OnClick = BtnGpxClick
    end
    object BtnFixedTrip: TButton
      Left = 176
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Fixed Trip'
      TabOrder = 3
      OnClick = BtnFixedTripClick
    end
    object BtnFixedGpx: TButton
      Left = 257
      Top = 3
      Width = 75
      Height = 25
      Caption = 'Fixed Gpx'
      TabOrder = 4
      OnClick = BtnFixedGpxClick
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
    Style = lbOwnerDrawVariable
    TabOrder = 1
    OnClick = LbLogClick
    OnDrawItem = LbLogDrawItem
  end
  object SaveTrip: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 370
    Top = 401
  end
end
