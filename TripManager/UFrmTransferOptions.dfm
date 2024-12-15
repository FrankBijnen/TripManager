object FrmTransferOptions: TFrmTransferOptions
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Transfer options'
  ClientHeight = 334
  ClientWidth = 530
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object PnlBot: TPanel
    Left = 0
    Top = 301
    Width = 530
    Height = 33
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 297
    ExplicitWidth = 528
    DesignSize = (
      530
      33)
    object BtnCancel: TBitBtn
      Left = 440
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 0
      ExplicitLeft = 438
    end
    object BitBtn2: TBitBtn
      Left = 354
      Top = 5
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      ExplicitLeft = 352
    end
  end
  object MemoTransfer: TMemo
    Left = 0
    Top = 0
    Width = 530
    Height = 81
    Align = alTop
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      'Transfer selected GPX files to your device.'
      ''
      
        'The GPX files should contain one or more valid routes. or Way po' +
        'ints.'
      'Tracks will be created automatically if  required.')
    ParentFont = False
    ReadOnly = True
    TabOrder = 1
    ExplicitWidth = 528
  end
  object LvSelections: TListView
    Left = 0
    Top = 169
    Width = 530
    Height = 132
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Select file types to send'
        Width = 525
      end>
    Items.ItemData = {
      05540200000500000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000
      004954007200690070002000660069006C0065007300200028004E006F002000
      69006D0070006F00720074002000720065007100750069007200650064002C00
      20006200750074002000770069006C006C00200072006500630061006C006300
      75006C006100740065002E002000530065006C00650063007400650064002000
      6D006F00640065006C003A00200025007300290000000000FFFFFFFFFFFFFFFF
      00000000FFFFFFFF000000001D54007200610063006B0073002000280049006E
      0063006C007500640069006E0067002000570061007900200070006F0069006E
      0074007300290000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF0000000026
      53007400720069007000700065006400200072006F0075007400650073002000
      280046006F007200630065007300200072006500630061006C00630075006C00
      6100740069006F006E00290000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF
      000000002943006F006D0070006C00650074006500200072006F007500740065
      007300200028004E006F00200072006500630061006C00630075006C00610074
      0069006F006E00200066006F007200630065006400290000000000FFFFFFFFFF
      FFFFFF00000000FFFFFFFF000000003450004F004900200028002E0067007000
      690029002000660069006C00650073002000280050006F0069006E0074007300
      20004F006600200049006E0074006500720065007300740029002E0020005300
      65006C0065006300740069006F006E003A00200025007300}
    TabOrder = 2
    ViewStyle = vsReport
    ExplicitWidth = 528
    ExplicitHeight = 128
  end
  object MemoDestinations: TMemo
    Left = 0
    Top = 81
    Width = 530
    Height = 88
    Align = alTop
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Lines.Strings = (
      'MemoDestinations')
    ParentFont = False
    ReadOnly = True
    TabOrder = 3
    ExplicitWidth = 528
  end
end
