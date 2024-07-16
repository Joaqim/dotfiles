{
  hardware.printers = {
    ensurePrinters = [
      {
        name = "Canon-TR7620a";
        location = "Downstairs";
        deviceUri = "https://10.0.0.234";
        model = "drv:///sample.drv/generic.ppd";
        ppdOptions = {
          PageSize = "Letter";
        };
      }
      {
        name = "Brother-HL-2170W";
        location = "Upstairs";
        deviceUri = "https://10.0.0.97";
        model = "drv:///sample.drv/generic.ppd";
        ppdOptions = {
          PageSize = "Letter";
        };
      }
    ];
    ensureDefaultPrinter = "Canon-TR7620a";
  };
}
