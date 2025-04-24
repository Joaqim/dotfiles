{
  my.profiles = {
    # Bluetooth configuration and mpris service
    bluetooth.enable = true;
    # External devices configuration
    devices = {
      enable = true;
      useCkbNext = true;
      useLiquidCtl = true;
    };
    # My custom fcitx5 configuration
    fcitx5.enable = true;
    gamemode.enable = true;
    language = {
      supportedLocales = [
        "C.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
        "sv_SE.UTF-8/UTF-8"
      ];
      useEuropeanEnglish = true;
    };
    minecraft-server.enable = true;
    # Plasma Window Manager
    plasma.enable = true;
    xkb = {
      enable = true;
      layout = "dvp";
      secondaryLayout = "se";
    };
  };
}
