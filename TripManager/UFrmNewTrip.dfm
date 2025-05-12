object FrmNewTrip: TFrmNewTrip
  Left = 0
  Top = 0
  ActiveControl = EdNewTrip
  BorderStyle = bsDialog
  Caption = 'New trip'
  ClientHeight = 134
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 0
    Top = 22
    Width = 59
    Height = 15
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Trip name'
  end
  object Label2: TLabel
    Left = 0
    Top = 63
    Width = 562
    Height = 15
    Align = alBottom
    AutoSize = False
    Caption = 'Trip will be saved  as:'
    ExplicitTop = 80
    ExplicitWidth = 109
  end
  object PnlBot: TPanel
    Left = 0
    Top = 101
    Width = 562
    Height = 33
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 125
    DesignSize = (
      562
      33)
    object BtnCancel: TBitBtn
      Left = 476
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BtnOk: TBitBtn
      Left = 395
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Enabled = False
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object EdNewTrip: TEdit
    Left = 72
    Top = 18
    Width = 460
    Height = 23
    TabOrder = 1
    TextHint = 'Type a name for the trip'
    OnChange = EdNewTripChange
  end
  object EdResultFile: TEdit
    Left = 0
    Top = 78
    Width = 562
    Height = 23
    Align = alBottom
    ReadOnly = True
    TabOrder = 2
    Text = 'EdResultFile'
    ExplicitTop = 101
  end
end
