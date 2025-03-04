{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.kde;
in {
  options.my.home.gtk = with lib; {
    enable = mkEnableOption "KDE configuration";
  };

  config = lib.mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };
    # TODO: Should these be included here?
    home.packages = builtins.attrValues {
      inherit
        (pkgs.kdePackages)
        partitionmanager
        kolourpaint
        ;
    };
  };
}
