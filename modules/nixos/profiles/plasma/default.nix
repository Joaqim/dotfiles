{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.plasma;
in {
  options.my.profiles.plasma = with lib; {
    enable = mkEnableOption "Plasma Window Manager with SDDM login manager and some opinionated configurations";
  };
  # TODO: Split this configuration into modules in modules/nixos:
  # my.services.xserver
  # my.services.desktopManager
  # my.services.displayManager
  # my.programs.kdeconnect
  # my.services.kwallet
  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
      };
      desktopManager.plasma6.enable = true;
      displayManager = {
        defaultSession = "plasma";
        sddm = {
          enable = true;
          wayland.enable = true;
          autoNumlock = true;
        };
      };
    };

    programs.kdeconnect.enable = true;

    security.pam.services.kwallet = {
      name = "kwallet";
      enableKwallet = true;
    };

    # Personal configuration to exclude some plasma utilities and apps
    environment = {
      # Disable baloo indexer
      etc."xdg/baloofilerc".source = (pkgs.formats.ini {}).generate "baloorc" {
        "Basic Settings" = {
          "Indexing-Enabled" = false;
        };
      };
      plasma6.excludePackages = with pkgs.libsForQt5; [
        baloo
        gwenview
        khelpcenter
        konsole
        oxygen
        spectacle
      ];
    };
  };
}
