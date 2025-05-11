object FrmAdvSettings: TFrmAdvSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Advanced settings'
  ClientHeight = 424
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object PnlBottom: TPanel
    Left = 0
    Top = 393
    Width = 441
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      441
      31)
    object BtnOK: TButton
      Left = 277
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object BtnCancel: TButton
      Left = 364
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object PctMain: TPageControl
    Left = 0
    Top = 0
    Width = 441
    Height = 393
    ActivePage = TabXT2
    Align = alClient
    TabOrder = 1
    object TabXT2: TTabSheet
      Caption = 'XT2 settings'
      object VlXT2Settings: TValueListEditor
        Left = 0
        Top = 0
        Width = 433
        Height = 363
        Align = alClient
        TabOrder = 0
        ColWidths = (
          176
          251)
      end
    end
    object TabGeoCode: TTabSheet
      Caption = 'GeoCode settings'
      ImageIndex = 1
      object VlGeoCodeSettings: TValueListEditor
        Left = 0
        Top = 0
        Width = 433
        Height = 239
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 441
        ExplicitHeight = 387
        ColWidths = (
          176
          251)
      end
      object MemoAddressFormat: TMemo
        Left = 0
        Top = 274
        Width = 433
        Height = 89
        Align = alBottom
        Lines.Strings = (
          'MemoAddressFormat')
        TabOrder = 1
      end
      object PnlAddressFormat: TPanel
        Left = 0
        Top = 239
        Width = 433
        Height = 35
        Align = alBottom
        Caption = 'Address format'
        TabOrder = 2
        ExplicitTop = 233
      end
    end
  end
end
