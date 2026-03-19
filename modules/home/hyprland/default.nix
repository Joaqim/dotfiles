{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.hyprland;
in
{
  options.my.home.hyprland = with lib; {
    enable = mkEnableOption "hyprland configuration";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        wayland.windowManager.hyprland = {
          enable = true;
          # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
          package = null;
          portalPackage = null;
          systemd.variables = [ "--all" ];
        };
        xdg.configFile."uwsm/env".source =
          "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
        gtk = {
          enable = true;

          theme = {
            package = pkgs.flat-remix-gtk;
            name = "Flat-Remix-GTK-Grey-Darkest";
          };

          iconTheme = {
            package = pkgs.adwaita-icon-theme;
            name = "Adwaita";
          };

          /*
            font = {
              name = "Sans";
              size = 11;
            };
          */
        };
        services.kdeconnect = {
          enable = true;
          indicator = true;
        };
        home.packages = builtins.attrValues {
          inherit (pkgs.kdePackages)
            partitionmanager
            kolourpaint
            polkit-kde-agent-1
            ;
        };
      }
      (lib.mkIf config.my.home.xdg.enable {
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
