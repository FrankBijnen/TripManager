object FrmAdvSettings: TFrmAdvSettings
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Advanced settings'
  ClientHeight = 557
  ClientWidth = 587
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
    Top = 526
    Width = 587
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 556
    DesignSize = (
      587
      31)
    object BtnOK: TButton
      Left = 423
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      ExplicitLeft = 392
    end
    object BtnCancel: TButton
      Left = 510
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      ExplicitLeft = 479
    end
  end
  object PctMain: TPageControl
    Left = 0
    Top = 0
    Width = 587
    Height = 526
    ActivePage = TabGeneral
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 556
    object TabGeneral: TTabSheet
      Caption = 'General'
      object GridGeneralSettings: TStringGrid
        Left = 0
        Top = 0
        Width = 579
        Height = 496
        Align = alClient
        ColCount = 3
        DefaultColWidth = 230
        DrawingStyle = gdsGradient
        FixedCols = 2
        GradientEndColor = clMoneyGreen
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goColMoving, goEditing, goAlwaysShowEditor, goFixedRowDefAlign]
        TabOrder = 0
        StyleElements = []
        ExplicitWidth = 548
        RowHeights = (
          24
          24
          24
          24
          24)
      end
    end
    object TabTransferDevice: TTabSheet
      Caption = 'Transfer to Device'
      object GridTransferDevice: TStringGrid
        Left = 0
        Top = 0
        Width = 579
        Height = 496
        Align = alClient
        ColCount = 3
        DefaultColWidth = 230
        DrawingStyle = gdsGradient
        FixedCols = 2
        GradientEndColor = clMoneyGreen
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goColMoving, goEditing, goAlwaysShowEditor, goFixedRowDefAlign]
        TabOrder = 0
        StyleElements = []
        ExplicitWidth = 548
        RowHeights = (
          24
          24
          24
          24
          24)
      end
    end
    object TabXT2: TTabSheet
      Caption = 'XT2 settings'
      object GridXT2Settings: TStringGrid
        Left = 0
        Top = 0
        Width = 579
        Height = 496
        Align = alClient
        ColCount = 3
        DefaultColWidth = 230
        DrawingStyle = gdsGradient
        FixedCols = 2
        GradientEndColor = clMoneyGreen
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goColMoving, goEditing, goAlwaysShowEditor, goFixedRowDefAlign]
        TabOrder = 0
        StyleElements = []
        ExplicitWidth = 548
        RowHeights = (
          24
          24
          24
          23
          24)
      end
    end
    object TabGeoCode: TTabSheet
      Caption = 'GeoCode settings'
      object Splitter1: TSplitter
        Left = 0
        Top = 193
        Width = 579
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        ExplicitTop = -9
        ExplicitWidth = 519
      end
      object PnlAddressFormat: TPanel
        Left = 0
        Top = 196
        Width = 579
        Height = 300
        Align = alBottom
        TabOrder = 0
        ExplicitWidth = 548
        object MemoAddressFormat: TMemo
          Left = 1
          Top = 36
          Width = 577
          Height = 93
          Align = alTop
          Lines.Strings = (
            'MemoAddressFormat')
          ScrollBars = ssVertical
          TabOrder = 0
          OnChange = MemoAddressFormatChange
          ExplicitWidth = 546
        end
        object PnlResult: TPanel
          Left = 1
          Top = 129
          Width = 577
          Height = 35
          Align = alTop
          Caption = 'Result'
          TabOrder = 1
          ExplicitWidth = 546
        end
        object MemoResult: TMemo
          Left = 1
          Top = 164
          Width = 577
          Height = 135
          Align = alClient
          Lines.Strings = (
            'MemoAddressFormat')
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 3
          ExplicitWidth = 546
        end
        object PnlAddressFormatTop: TPanel
          Left = 1
          Top = 1
          Width = 577
          Height = 35
          Align = alTop
          Caption = 'Address format'
          TabOrder = 2
          ExplicitWidth = 546
          object BtnBuilder: TButton
            Left = 4
            Top = 4
            Width = 75
            Height = 25
            Caption = 'Builder'
            TabOrder = 0
            OnMouseUp = BtnBuilderMouseUp
          end
        end
      end
      object GridGeoCodeSettings: TStringGrid
        Left = 0
        Top = 33
        Width = 579
        Height = 160
        Align = alClient
        ColCount = 3
        DefaultColWidth = 230
        DrawingStyle = gdsGradient
        FixedCols = 2
        GradientEndColor = clMoneyGreen
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goColMoving, goEditing, goAlwaysShowEditor, goFixedRowDefAlign]
        TabOrder = 1
        StyleElements = []
        ExplicitWidth = 548
        RowHeights = (
          24
          24
          24
          24
          24)
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 579
        Height = 33
        Align = alTop
        TabOrder = 2
        ExplicitWidth = 548
        object BtnValidate: TButton
          Left = 4
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Validate'
          TabOrder = 0
          OnClick = BtnValidateClick
        end
        object BtnClearCoordCache: TButton
          Left = 86
          Top = 3
          Width = 137
          Height = 25
          Caption = 'Clear GeoCode cache'
          TabOrder = 1
          OnClick = BtnClearCoordCacheClick
        end
      end
    end
  end
  object PopupBuilder: TPopupMenu
    Left = 52
    Top = 279
    object Clear1: TMenuItem
      Caption = 'Clear'
      OnClick = Clear1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object StatePlaceRoadnr1: TMenuItem
      Caption = 'State, Place, Road + House_number'
      OnClick = StatePlaceRoadnr1Click
    end
    object NrRoadPlaceState1: TMenuItem
      Caption = 'House_number + Road, Place, State'
      OnClick = NrRoadPlaceState1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Smallestplace1: TMenuItem
      Caption = 'Smallest place'
      OnClick = Smallestplace1Click
    end
    object Largestplace1: TMenuItem
      Caption = 'Largest place'
      OnClick = Largestplace1Click
    end
    object N5: TMenuItem
      Break = mbBarBreak
      Caption = '-'
    end
    object Housenbr1: TMenuItem
      Caption = 'House_number'
      OnClick = AddTag
    end
    object Road1: TMenuItem
      Caption = 'Road'
      OnClick = AddTag
    end
    object State1: TMenuItem
      Caption = 'State'
      OnClick = AddTag
    end
    object Countrycode1: TMenuItem
      Caption = 'Country_Code'
      OnClick = AddTag
    end
    object Countrycode2: TMenuItem
      Caption = 'Country'
      OnClick = AddTag
    end
    object postalcode1: TMenuItem
      Caption = 'PostCode'
      OnClick = AddTag
    end
    object N3: TMenuItem
      Break = mbBarBreak
      Caption = '-'
    end
    object Hamlet1: TMenuItem
      Caption = 'Hamlet'
      OnClick = AddTag
    end
    object Village1: TMenuItem
      Caption = 'Village'
      OnClick = AddTag
    end
    object City1: TMenuItem
      Caption = 'Town'
      OnClick = AddTag
    end
    object City2: TMenuItem
      Caption = 'City'
      OnClick = AddTag
    end
    object municipality1: TMenuItem
      Caption = 'Municipality'
      OnClick = AddTag
    end
    object N4: TMenuItem
      Break = mbBarBreak
      Caption = '-'
    end
    object Coords1: TMenuItem
      Caption = 'Coords'
      OnClick = AddTag
    end
    object Debug1: TMenuItem
      Caption = 'Debug'
      OnClick = AddTag
    end
  end
end
