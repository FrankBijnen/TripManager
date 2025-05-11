object FrmNewTrip: TFrmNewTrip
  Left = 0
  Top = 0
  ActiveControl = EdNewTrip
  BorderStyle = bsDialog
  Caption = 'New trip'
  ClientHeight = 158
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 0
    Top = 28
    Width = 59
    Height = 15
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Trip name'
  end
  object PnlBot: TPanel
    Left = 0
    Top = 125
    Width = 562
    Height = 33
    Align = alBottom
    TabOrder = 0
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
    object btnOk: TBitBtn
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
  object ChkDevice: TCheckBox
    Left = 0
    Top = 53
    Width = 86
    Height = 17
    Alignment = taLeftJustify
    Caption = 'On device'
    TabOrder = 1
    OnClick = ChkDeviceClick
  end
  object EdNewTrip: TEdit
    Left = 72
    Top = 24
    Width = 460
    Height = 23
    TabOrder = 2
    TextHint = 'Type a name for the trip'
    OnChange = EdNewTripChange
  end
  object EdResultFile: TEdit
    Left = 0
    Top = 102
    Width = 562
    Height = 23
    Align = alBottom
    ReadOnly = True
    TabOrder = 3
    Text = 'EdResultFile'
  end
end
