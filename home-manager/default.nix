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
  bottom = import ./modules/bottom.nix;
  cursor = import ./modules/cursor.nix;
  direnv = import ./modules/direnv.nix;
  git = import ./modules/git.nix;
  gtk = import ./modules/gtk.nix;
  helix = import ./modules/helix.nix;
  home-manager = import ./modules/home-manager.nix;
  kitty = import ./modules/kitty.nix;
  lazygit = import ./modules/lazygit.nix;
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
  misc-privacy = import ./modules/misc/privacy.nix;
  misc-productionArt = import ./modules/misc/production-art.nix;
  misc-productionAudio = import ./modules/misc/production-audio.nix;
  misc-productionCode = import ./modules/misc/production-code.nix;
  misc-productionVideo = import ./modules/misc/production-video.nix;
  misc-productionWriting = import ./modules/misc/production-writing.nix;
  misc-themes = import ./modules/misc/themes.nix;
  misc-virtualization = import ./modules/misc/virtualization.nix;
  misc-yazi = import ./modules/misc/yazi.nix;
  mpv = import ./modules/mpv.nix;
  network = import ./modules/network.nix;
  nextcloud = import ./modules/nextcloud.nix;
  nushell = import ./modules/nushell.nix;
  playerctl = import ./modules/playerctl.nix;
  pulse = import ./modules/pulse.nix;
  starship = import ./modules/starship.nix;
  vscode = import ./modules/vscode.nix;
  wezterm = import ./modules/wezterm.nix;
  yazi = import ./modules/yazi.nix;
  zathura = import ./modules/zathura.nix;
  zellij = import ./modules/zellij.nix;
  zoxide = import ./modules/zoxide.nix;
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
      
      bottom
      cursor
      direnv
      gammastep
      git
      gtk
      helix
      home-manager
      kitty
      lazygit
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
      misc-privacy
      misc-productionArt
      misc-productionAudio
      misc-productionCode
      misc-productionVideo
      misc-productionWriting
      misc-themes
      misc-virtualization
      misc-yazi
      mpv
      network
      nextcloud
      nushell
      playerctl
      pulse
      starship
      vscode
      wezterm
      yazi
      zathura
      zellij
      zoxide
      ;
    commandLine = {
      imports = [
        bat
        bottom
        git
        home-manager
        kitty
        lazygit
        misc-android
        misc-commandLine
        misc-virtualization
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
    privacy = {
      imports = [
        misc-privacy
      ];
    };
    productionArt = {
      imports = [
        misc-productionArt
      ];
    };
    productionAudio = {
      imports = [
        misc-productionAudio
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
        misc-productionVideo
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
