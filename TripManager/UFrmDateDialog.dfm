object FrmDateDialog: TFrmDateDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select a date and time'
  ClientHeight = 94
  ClientWidth = 212
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  Scaled = False
  TextHeight = 15
  object PnlBot: TPanel
    Left = 0
    Top = 61
    Width = 212
    Height = 33
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      212
      33)
    object BtnCancel: TBitBtn
      Left = 126
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
    end
    object BitBtn2: TBitBtn
      Left = 43
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object DtPicker: TDateTimePicker
    Left = 5
    Top = 12
    Width = 200
    Height = 23
    Date = 45632.000000000000000000
    Time = 0.820355601848859800
    Kind = dtkDateTime
    TabOrder = 1
  end
  object ChkIncrement: TCheckBox
    Left = 5
    Top = 40
    Width = 200
    Height = 17
    Caption = 'Add 1 day for subsequent files.'
    TabOrder = 2
    Visible = False
  end
end
