object DmRoutePoints: TDmRoutePoints
  OnCreate = DataModuleCreate
  Height = 181
  Width = 313
  object DsRoutePoints: TDataSource
    DataSet = CdsRoutePoints
    Left = 169
    Top = 104
  end
  object CdsRoutePoints: TClientDataSet
    Aggregates = <>
    AutoCalcFields = False
    Params = <>
    BeforeInsert = CdsRoutePointsBeforeInsert
    AfterInsert = CdsRoutePointsAfterInsert
    BeforePost = CdsRoutePointsBeforePost
    AfterPost = CdsRoutePointsAfterPost
    BeforeDelete = CdsRoutePointsBeforeDelete
    AfterDelete = CdsRoutePointsAfterDelete
    AfterScroll = CdsRoutePointsAfterScroll
    OnCalcFields = CdsRoutePointsCalcFields
    Left = 50
    Top = 108
    object CdsRoutePointsId: TIntegerField
      FieldName = 'Id'
      Visible = False
    end
    object CdsRoutePointsName: TWideStringField
      DisplayLabel = 'Name_'
      DisplayWidth = 25
      FieldName = 'Name'
      Size = 64
    end
    object CdsRoutePointsViaPoint: TBooleanField
      FieldName = 'ViaPoint'
      OnGetText = CdsRoutePointsViaPointGetText
      OnSetText = CdsRoutePointsViaPointSetText
    end
    object CdsRoutePointsLat: TStringField
      FieldName = 'Lat'
    end
    object CdsRoutePointsLon: TStringField
      FieldName = 'Lon'
    end
    object CdsRoutePointsAddress: TStringField
      DisplayWidth = 64
      FieldName = 'Address'
      Size = 255
    end
    object CdsRoutePointsCoords: TStringField
      FieldKind = fkCalculated
      FieldName = 'Coords'
      Calculated = True
    end
  end
  object CdsRoute: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 50
    Top = 28
    object CdsRouteTripName: TStringField
      FieldName = 'TripName'
      Size = 128
    end
    object CdsRouteRoutePreference: TStringField
      FieldName = 'RoutePreference'
    end
    object CdsRouteTransportationMode: TStringField
      FieldName = 'TransportationMode'
    end
    object CdsRouteDepartureDate: TDateTimeField
      FieldName = 'DepartureDate'
    end
  end
  object DsRoute: TDataSource
    DataSet = CdsRoute
    Left = 169
    Top = 32
  end
end
