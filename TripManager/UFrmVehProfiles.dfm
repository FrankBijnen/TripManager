object FrmVehProfiles: TFrmVehProfiles
  Left = 0
  Top = 0
  ActiveControl = GrdVehProfile
  BorderStyle = bsSizeToolWin
  Caption = 'Vehicle profiles'
  ClientHeight = 695
  ClientWidth = 740
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object PnlBottom: TPanel
    Left = 0
    Top = 664
    Width = 740
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      740
      31)
    object BtnOK: TButton
      Left = 571
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
      Left = 658
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
  object PCTMain: TPageControl
    Left = 0
    Top = 0
    Width = 740
    Height = 664
    ActivePage = TabAllProfiles
    Align = alClient
    TabOrder = 0
    object TabAllProfiles: TTabSheet
      Caption = 'All Profiles'
      object GrdVehProfile: TDBGrid
        Left = 0
        Top = 0
        Width = 732
        Height = 139
        Align = alTop
        DataSource = DsVehProfile
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnDblClick = GrdVehProfileDblClick
      end
      object PctDetails: TPageControl
        Left = 0
        Top = 139
        Width = 732
        Height = 495
        ActivePage = TabTripFiles
        Align = alClient
        TabOrder = 1
        object TabTripFiles: TTabSheet
          Caption = 'Trip file items'
          object GridProfile: TStringGrid
            Left = 0
            Top = 0
            Width = 724
            Height = 465
            Align = alClient
            ColCount = 3
            DefaultColWidth = 230
            DrawingStyle = gdsGradient
            FixedCols = 2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            GradientEndColor = clMoneyGreen
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect, goFixedRowDefAlign]
            ParentFont = False
            TabOrder = 0
            StyleElements = []
            RowHeights = (
              24
              24
              24
              23
              24)
          end
        end
        object TabAllFields: TTabSheet
          Caption = 'All Fields'
          ImageIndex = 1
          object ScrllAllFields: TScrollBox
            Left = 0
            Top = 0
            Width = 724
            Height = 465
            VertScrollBar.Tracking = True
            Align = alClient
            TabOrder = 0
            object PnlAllFields: TPanel
              Left = 0
              Top = 0
              Width = 720
              Height = 313
              Align = alTop
              TabOrder = 0
              OnMouseEnter = PnlAllFieldsMouseEnter
              OnMouseLeave = PnlAllFieldsMouseLeave
            end
          end
        end
      end
    end
  end
  object CDSVehProfile: TClientDataSet
    Aggregates = <>
    Params = <>
    ReadOnly = True
    AfterScroll = CDSVehProfileAfterScroll
    Left = 464
    Top = 80
  end
  object DsVehProfile: TDataSource
    AutoEdit = False
    DataSet = CDSVehProfile
    Left = 568
    Top = 80
  end
end
