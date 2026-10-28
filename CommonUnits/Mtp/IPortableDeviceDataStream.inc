type

// *********************************************************************//
// Interface: IPortableDeviceDataStream
// Flags:     (0)
// GUID:      {88e04db3-1012-4d64-9996-f703a950d3f4}
// *********************************************************************//
  IPortableDeviceDataStream = interface(IStream)
    ['{88e04db3-1012-4d64-9996-f703a950d3f4}']
    function GetObjectID(var ppszObjectID : PWideChar): HResult; stdcall;
    function Cancel: HResult; stdcall;
  end;
