{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.kde;
in {
  options.my.home.kde = with lib; {
    enable = mkEnableOption "KDE configuration";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
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
    }
    (lib.mkIf config.my.home.xdg.enable {
      xdg.portal = {
        enable = true;
        configPackages = [pkgs.kdePackages.xdg-desktop-portal-kde];
        extraPortals = [
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
      };
    })
  ]);
}
