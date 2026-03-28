{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.utilities.nm-applet;
in
{
  options.my.home.utilities.nm-applet = with lib; {
    enable = mkEnableOption "network-manager-applet configuration";
  };

  config.services.network-manager-applet = lib.mkIf cfg.enable {
    enable = true;
  };
}
