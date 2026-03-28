{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.flameshot;
in
{
  options.my.home.flameshot = with lib; {
    enable = mkEnableOption "flameshot configuration";
  };

  config.services.flameshot = lib.mkIf cfg.enable {
    enable = true;
    package = pkgs.flameshot.override { enableWlrSupport = true; };
    settings.General = {
      disabledTrayIcon = true;
      showStartupLaunchMessage = false;
    };
  };
}
