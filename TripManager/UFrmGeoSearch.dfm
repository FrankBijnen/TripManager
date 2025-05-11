object FGeoSearch: TFGeoSearch
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Search place'
  ClientHeight = 436
  ClientWidth = 522
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object PctMain: TPageControl
    Left = 0
    Top = 0
    Width = 522
    Height = 404
    ActivePage = TabFreeSearch
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 500
    ExplicitHeight = 388
    object TabFreeSearch: TTabSheet
      Caption = 'Free search'
      ImageIndex = 1
      object EdSearchFree: TLabeledEdit
        Left = 8
        Top = 19
        Width = 470
        Height = 21
        EditLabel.Width = 114
        EditLabel.Height = 13
        EditLabel.Caption = 'Enter search parameter'
        TabOrder = 0
        Text = ''
      end
      object MemoFreeSearch: TMemo
        Left = 3
        Top = 255
        Width = 470
        Height = 113
        Lines.Strings = (
          
            'To "free form" search for an address, you can pass the address s' +
            'tring using the q parameter to '
          'the /search endpoint, e.g.:'
          ''
          '555+5th+Ave+New+York+NY+10017+US')
        ReadOnly = True
        TabOrder = 1
      end
    end
    object TabFormattedSearch: TTabSheet
      Caption = 'Formatted'
      ImageIndex = 1
      object MemoFormatted: TMemo
        Left = 3
        Top = 259
        Width = 475
        Height = 109
        Lines.Strings = (
          'street=<housenumber> <streetname>'
          'city=<city>'
          'county=<county>'
          'state=<state>'
          'country=<country>'
          'postalcode=<postalcode>')
        ReadOnly = True
        TabOrder = 6
      end
      object EdStreet: TLabeledEdit
        Left = 3
        Top = 21
        Width = 475
        Height = 21
        EditLabel.Width = 30
        EditLabel.Height = 13
        EditLabel.Caption = 'Street'
        TabOrder = 0
        Text = ''
      end
      object EdCity: TLabeledEdit
        Left = 3
        Top = 61
        Width = 475
        Height = 21
        EditLabel.Width = 19
        EditLabel.Height = 13
        EditLabel.Caption = 'City'
        TabOrder = 1
        Text = ''
      end
      object EdCounty: TLabeledEdit
        Left = 3
        Top = 101
        Width = 475
        Height = 21
        EditLabel.Width = 35
        EditLabel.Height = 13
        EditLabel.Caption = 'County'
        TabOrder = 2
        Text = ''
      end
      object EdState: TLabeledEdit
        Left = 3
        Top = 141
        Width = 475
        Height = 21
        EditLabel.Width = 26
        EditLabel.Height = 13
        EditLabel.Caption = 'State'
        TabOrder = 3
        Text = ''
      end
      object EdCountry: TLabeledEdit
        Left = 3
        Top = 177
        Width = 475
        Height = 21
        EditLabel.Width = 39
        EditLabel.Height = 13
        EditLabel.Caption = 'Country'
        TabOrder = 4
        Text = ''
      end
      object EdPostalCode: TLabeledEdit
        Left = 3
        Top = 217
        Width = 475
        Height = 21
        EditLabel.Width = 52
        EditLabel.Height = 13
        EditLabel.Caption = 'Postalcode'
        TabOrder = 5
        Text = ''
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 404
    Width = 522
    Height = 32
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 417
    object BtnOk: TBitBtn
      Left = 321
      Top = 2
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BtnCancel: TBitBtn
      Left = 402
      Top = 2
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
end
