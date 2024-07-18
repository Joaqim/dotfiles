{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
    };
    # desktopManager.plasma6.enable = true;
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
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
        plasma-browser-integration
        konsole
        oxygen
        dolphin
        kate
        gwenview
        spectacle
        kdeconnect-kde
        khelpcenter
        baloo
      ];
  };
  # qt = {
  #   enable = true;
  #   platformTheme = "gnome";
  #   style = "adwaita-dark";
  # };
}
