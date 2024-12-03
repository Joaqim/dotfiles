{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      desktopManager = {
        plasma5.enable = true;
      };
    };
    # desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "plasmawayland";
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
    plasma5.excludePackages = with pkgs.libsForQt5;
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

  #qt = {
  #  enable = true;
  #  platformTheme = "qt5ct";
  #  style = "kvantum"; # See ./home-manager/modules/misc/kvantum.nix
  #};
}
