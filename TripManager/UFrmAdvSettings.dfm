object FrmAdvSettings: TFrmAdvSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Advanced settings'
  ClientHeight = 558
  ClientWidth = 529
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
    Top = 527
    Width = 529
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      529
      31)
    object BtnOK: TButton
      Left = 365
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
      Left = 452
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
    Width = 529
    Height = 527
    ActivePage = TabGeoCode
    Align = alClient
    TabOrder = 1
    object TabXT2: TTabSheet
      Caption = 'XT2 settings'
      object VlXT2Settings: TValueListEditor
        Left = 0
        Top = 0
        Width = 521
        Height = 497
        Align = alClient
        TabOrder = 0
        ColWidths = (
          176
          339)
      end
    end
    object TabGeoCode: TTabSheet
      Caption = 'GeoCode settings'
      ImageIndex = 1
      object Splitter1: TSplitter
        Left = 0
        Top = 194
        Width = 521
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = -9
        ExplicitWidth = 519
      end
      object VlGeoCodeSettings: TValueListEditor
        Left = 0
        Top = 0
        Width = 521
        Height = 194
        Align = alClient
        TabOrder = 0
        OnStringsChange = VlGeoCodeSettingsStringsChange
        ColWidths = (
          176
          339)
      end
      object PnlAddressFormat: TPanel
        Left = 0
        Top = 197
        Width = 521
        Height = 300
        Align = alBottom
        TabOrder = 1
        object MemoAddressFormat: TMemo
          Left = 1
          Top = 36
          Width = 519
          Height = 93
          Align = alTop
          Lines.Strings = (
            'MemoAddressFormat')
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = MemoAddressFormatChange
        end
        object PnlResult: TPanel
          Left = 1
          Top = 129
          Width = 519
          Height = 35
          Align = alTop
          Caption = 'Result'
          TabOrder = 1
          object BtnClearCoordCache: TButton
            Left = 8
            Top = 4
            Width = 137
            Height = 25
            Caption = 'Clear GeoCode cache'
            TabOrder = 0
            OnClick = BtnClearCoordCacheClick
          end
        end
        object MemoResult: TMemo
          Left = 1
          Top = 164
          Width = 519
          Height = 135
          Align = alClient
          Lines.Strings = (
            'MemoAddressFormat')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 3
        end
        object PnlAddressFormatTop: TPanel
          Left = 1
          Top = 1
          Width = 519
          Height = 35
          Align = alTop
          Caption = 'Address format'
          TabOrder = 2
        end
      end
    end
  end
end
