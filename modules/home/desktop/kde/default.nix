{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.desktop.kde;
in
{
  options.my.home.desktop.kde = with lib; {
    enable = mkEnableOption "KDE configuration";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.kdeconnect = {
          enable = true;
          # Indicator is already available when using Plasma KDE
          # TODO: Depend on setting of `my.profile.plasma.enable` in `modules/nixos/profiles/plasma/default.nix`
          indicator = false;
        };
        # TODO: Should these be included here?
        home.packages = builtins.attrValues {
          inherit (pkgs.kdePackages)
            partitionmanager
            kolourpaint
            polkit-kde-agent-1
            ;
        };
      }
      (lib.mkIf config.my.home.desktop.xdg.enable {
        xdg.portal = {
          enable = true;
          configPackages = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
          extraPortals = [
            pkgs.kdePackages.xdg-desktop-portal-kde
          ];
        };
      })
    ]
  );
}
