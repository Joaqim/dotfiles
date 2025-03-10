let
  # Folders
  bat = import ./modules/bat;
  dunst = import ./modules/dunst;
  eww = import ./modules/eww;
  firefox = import ./modules/firefox;
  gammastep = import ./modules/gammastep;
  hyprland = import ./modules/hyprland;
  obs-studio = import ./modules/obs-studio;
  qbittorrent = import ./modules/qbittorrent;
  tofi = import ./modules/tofi;
  # Files
  atuin = import ./modules/atuin.nix;
  bottom = import ./modules/bottom.nix;
  calibre = import ./modules/calibre.nix;
  cataclysm-dda = import ./modules/games/cataclysm-dda.nix;
  cursor = import ./modules/cursor.nix;
  direnv = import ./modules/direnv.nix;
  git = import ./modules/git.nix;
  gpg = import ./modules/gpg.nix;
  gtk = import ./modules/gtk.nix;
  helix = import ./modules/helix.nix;
  home-manager = import ./modules/home-manager.nix;
  kitty = import ./modules/kitty.nix;
  lazygit = import ./modules/lazygit.nix;
  minecraft-server-toggle = import ./modules/plasmoids/minecraft-server-toggle.nix;
  misc-android = import ./modules/misc/android.nix;
  misc-commandLine = import ./modules/misc/command-line.nix;
  misc-fileManagement = import ./modules/misc/file-management.nix;
  misc-firefox = import ./modules/misc/firefox.nix;
  misc-gaming = import ./modules/misc/gaming.nix;
  misc-gnomeExtras = import ./modules/misc/gnome-extras.nix;
  misc-hyprland = import ./modules/misc/hyprland.nix;
  misc-internet = import ./modules/misc/internet.nix;
  misc-jellyfin = import ./modules/misc/jellyfin.nix;
  misc-kdeExtras = import ./modules/misc/kde-extras.nix;
  misc-media = import ./modules/misc/media.nix;
  misc-productionArt = import ./modules/misc/production-art.nix;
  misc-productionCode = import ./modules/misc/production-code.nix;
  misc-productionWriting = import ./modules/misc/production-writing.nix;
  misc-themes = import ./modules/misc/themes.nix;
  misc-virtualisation = import ./modules/misc/virtualisation.nix;
  misc-yazi = import ./modules/misc/yazi.nix;
  mpv = import ./modules/mpv.nix;
  network = import ./modules/network.nix;
  nextcloud = import ./modules/nextcloud.nix;
  nushell = import ./modules/nushell.nix;
  playerctl = import ./modules/playerctl.nix;
  pulse = import ./modules/pulse.nix;
  starship = import ./modules/starship.nix;
  syncthing = import ./modules/syncthing.nix;
  vscode = import ./modules/vscode.nix;
  wezterm = import ./modules/wezterm.nix;
  yazi = import ./modules/yazi.nix;
  zathura = import ./modules/zathura.nix;
  zellij = import ./modules/zellij.nix;
  zoxide = import ./modules/zoxide.nix;

  # Games
  rocket-league = import ./modules/games/rocket-league.nix;
in {
  flake.homeModules = {
    inherit
      # Folders
      bat
      dunst
      eww
      firefox
      hyprland
      obs-studio
      qbittorrent
      tofi
      # Files
      atuin
      bottom
      calibre
      cataclysm-dda
      cursor
      direnv
      gammastep
      git
      gpg
      gtk
      helix
      home-manager
      kitty
      lazygit
      minecraft-server-toggle
      misc-android
      misc-commandLine
      misc-fileManagement
      misc-firefox
      misc-gaming
      misc-gnomeExtras
      misc-hyprland
      misc-internet
      misc-jellyfin
      misc-kdeExtras
      misc-media
      misc-productionArt
      misc-productionCode
      misc-productionWriting
      misc-themes
      misc-virtualisation
      misc-yazi
      mpv
      network
      nextcloud
      nushell
      playerctl
      pulse
      starship
      syncthing
      vscode
      wezterm
      yazi
      zathura
      zellij
      zoxide
      # Games
      rocket-league
      ;
    commandLine = {
      imports = [
        atuin
        bat
        bottom
        git
        home-manager
        kitty
        lazygit
        misc-android
        misc-commandLine
        misc-virtualisation
        misc-yazi
        nushell
        playerctl
        pulse
        starship
        wezterm
        yazi
        zathura
        zellij
        zoxide
      ];
    };
    desktopGames = {
      imports = [
        rocket-league
      ];
    };
    entertainment = {
      imports = [
        misc-gaming
        misc-media
        mpv
      ];
    };
    extras = {
      imports = [
        misc-gnomeExtras
        misc-kdeExtras
      ];
    };
    fileManagement = {
      imports = [
        misc-fileManagement
      ];
    };
    firefoxHM = {
      imports = [
        firefox
      ];
    };
    firefoxNix = {
      imports = [
        misc-firefox
      ];
    };
    hyprDesktop = {
      imports = [
        dunst
        eww
        gammastep
        hyprland
        misc-hyprland
        tofi
      ];
    };
    internet = {
      imports = [
        misc-internet
        network
        qbittorrent
      ];
    };
    jellyfin = {
      imports = [
        misc-jellyfin
      ];
    };
    productionArt = {
      imports = [
        misc-productionArt
      ];
    };
    productionCode = {
      imports = [
        direnv
        helix
        misc-productionCode
        vscode
      ];
    };
    productionVideo = {
      imports = [
        obs-studio
      ];
    };
    productionWriting = {
      imports = [
        misc-productionWriting
      ];
    };
    themes = {
      imports = [
        cursor
        gtk
        misc-themes
      ];
    };
  };
}
