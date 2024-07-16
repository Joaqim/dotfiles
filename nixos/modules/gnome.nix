{pkgs, ...}: {
  services = {
    xserver = {
      enable = true;
      displayManager = {
        gdm.enable = true;
        gdm.wayland = true;
      };
      desktopManager.gnome = {
        enable = true;
      };
    };
    gnome = {
      games.enable = false;
      gnome-online-accounts.enable = true;
    };
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
  };
  environment = {
    variables = {
      WEBKIT_FORCE_SANDBOX = "0";
      WEBKIT_DISABLE_COMPOSITING_MODE = "1";
    };
    gnome.excludePackages =
      (with pkgs; [
        gnome-photos
        gnome-tour
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        epiphany # web browser
        geary # email reader
        evince # document viewer
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # help viewer
        gnome-clocks
        gnome-weather
        gnome-maps
        gnome-contacts
        gnome-calendar
        gnome-characters
      ]);
  };
}
