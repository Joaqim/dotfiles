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

    environment = {
      # Disable baloo indexer
      etc."xdg/baloofilerc".source = (pkgs.formats.ini {}).generate "baloorc" {
        "Basic Settings" = {
          "Indexing-Enabled" = false;
        };
      };
      plasma6.excludePackages = with pkgs.libsForQt5;
      # with pkgs.kdePackages;
        [
          #plasma-browser-integration
          konsole
          oxygen
          gwenview
          spectacle
          khelpcenter
          baloo
        ];
    };
  };
}
