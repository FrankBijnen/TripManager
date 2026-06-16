object FrmVehProfiles: TFrmVehProfiles
  Left = 0
  Top = 0
  ActiveControl = GrdVehProfile
  BorderStyle = bsSizeToolWin
  Caption = 'Vehicle profiles'
  ClientHeight = 761
  ClientWidth = 849
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnMouseWheel = FormMouseWheel
  OnResize = FormResize
  OnShow = FormShow
  TextHeight = 15
  object PnlBottom: TPanel
    Left = 0
    Top = 730
    Width = 849
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      849
      31)
    object BtnOK: TButton
      Left = 661
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
    end
    object BtnCancel: TButton
      Left = 748
      Top = 3
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      Default = True
      ModalResult = 2
      TabOrder = 1
    end
    object BtnUnitTest: TButton
      Left = 167
      Top = 2
      Width = 75
      Height = 25
      Caption = 'Unit test'
      TabOrder = 2
      OnClick = BtnUnitTestClick
    end
    object BtnLookupHash: TButton
      Left = 8
      Top = 2
      Width = 153
      Height = 25
      Caption = 'Lookup Hash from trips'
      TabOrder = 3
      OnClick = BtnLookupHashClick
    end
  end
  object PCTMain: TPageControl
    Left = 0
    Top = 0
    Width = 849
    Height = 730
    ActivePage = TabAllProfiles
    Align = alClient
    TabOrder = 0
    object TabAllProfiles: TTabSheet
      Caption = 'All Profiles'
      object SpltGridDetail: TSplitter
        Left = 0
        Top = 139
        Width = 841
        Height = 5
        Cursor = crVSplit
        Align = alTop
      end
      object GrdVehProfile: TDBGrid
        Left = 0
        Top = 0
        Width = 841
        Height = 139
        Align = alTop
        DataSource = DsVehProfile
        Options = [dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        OnDblClick = GrdVehProfileDblClick
        OnTitleClick = GrdVehProfileTitleClick
        Columns = <
          item
            Expanded = False
            FieldName = 'Status'
            Width = 96
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Vehicle_Id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Name'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Guid'
            Width = 250
            Visible = True
          end
          item
            Alignment = taRightJustify
            Expanded = False
            FieldName = 'Proposed_Hash'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'Truck_type'
            Visible = True
          end>
      end
      object PctDetails: TPageControl
        Left = 0
        Top = 144
        Width = 841
        Height = 556
        ActivePage = TabHashList
        Align = alClient
        TabOrder = 1
        OnChange = PctDetailsChange
        object TabTripFiles: TTabSheet
          Caption = 'Trip file items'
          object GridProfile: TStringGrid
            Left = 0
            Top = 0
            Width = 833
            Height = 526
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
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goFixedRowDefAlign]
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
            Width = 833
            Height = 526
            VertScrollBar.Tracking = True
            Align = alClient
            TabOrder = 0
            object PnlAllFields: TPanel
              Left = 0
              Top = 0
              Width = 829
              Height = 313
              Align = alTop
              TabOrder = 0
              OnMouseEnter = PnlAllFieldsMouseEnter
              OnMouseLeave = PnlAllFieldsMouseLeave
            end
          end
        end
        object TabHashList: TTabSheet
          Caption = 'Trip file Hashes'
          ImageIndex = 2
          object GridHashList: TStringGrid
            Left = 0
            Top = 33
            Width = 833
            Height = 493
            Align = alClient
            ColCount = 4
            DefaultColWidth = 230
            DrawingStyle = gdsGradient
            FixedCols = 2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            GradientEndColor = clMoneyGreen
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor, goFixedRowDefAlign]
            ParentFont = False
            TabOrder = 0
            StyleElements = []
            OnSelectCell = GridHashListSelectCell
            RowHeights = (
              24
              24
              24
              23
              24)
          end
          object PnlHashFunc: TPanel
            Left = 0
            Top = 0
            Width = 833
            Height = 33
            Align = alTop
            TabOrder = 1
            object BtnDeleteHashList: TButton
              AlignWithMargins = True
              Left = 103
              Top = 4
              Width = 75
              Height = 25
              Align = alLeft
              Caption = 'Delete'
              TabOrder = 0
              OnClick = BtnDeleteHashListClick
            end
            object BtnSaveHash: TButton
              AlignWithMargins = True
              Left = 184
              Top = 4
              Width = 75
              Height = 25
              Align = alLeft
              Caption = 'Save'
              TabOrder = 1
              OnClick = BtnSaveHashClick
            end
            object BtnCleanUp: TButton
              AlignWithMargins = True
              Left = 4
              Top = 4
              Width = 93
              Height = 25
              Align = alLeft
              Caption = 'Clean up'
              TabOrder = 2
              OnClick = BtnCleanUpClick
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
    BeforePost = CDSVehProfileBeforePost
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
  object SaveUnitTestDialog: TSaveDialog
    DefaultExt = 'txt'
    Filter = '*.txt|*.txt'
    Left = 308
    Top = 162
  end
end
