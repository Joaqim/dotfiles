let
  # Folders
  steam = import ./modules/steam;
  # Files
  accounts = import ./modules/accounts.nix;
  android = import ./modules/android.nix;
  atuin = import ./modules/atuin.nix;
  audio = import ./modules/audio.nix;
  bluetooth = import ./modules/bluetooth.nix;
  cockpit = import ./modules/cockpit.nix;
  corectrl = import ./modules/corectrl.nix;
  dconf = import ./modules/dconf.nix;
  disks = import ./modules/disks.nix;
  distributed-builder = import ./modules/distributed-builder.nix;
  doas = import ./modules/doas.nix;
  docker = import ./modules/docker.nix;
  environment = import ./modules/environment.nix;
  fcitx5 = import ./modules/fcitx5.nix;
  firefox-syncserver = import ./modules/firefox-syncserver.nix;
  firejail = import ./modules/firejail.nix;
  flatpak = import ./modules/flatpak.nix;
  gamemode = import ./modules/gamemode.nix;
  geoclue2 = import ./modules/geoclue2.nix;
  gnome = import ./modules/gnome.nix;
  godot = import ./modules/godot.nix;
  greetd = import ./modules/greetd.nix;
  gvfs = import ./modules/gvfs.nix;
  home-manager = import ./modules/home-manager.nix;
  hyprland = import ./modules/hyprland.nix;
  jellyfin = import ./modules/jellyfin.nix;
  lutris = import ./modules/lutris.nix;
  minecraft-server-1 = import ./modules/minecraft-servers/better-minecraft-modpack.nix;
  #minecraft-server-1 = import ./modules/minecraft-servers/joaqim-s-minecraft-modpack.nix;
  minecraft-server = import ./modules/minecraft-servers/minecraft-server.nix;
  laptop-extras = import ./modules/laptop.nix;
  locale = import ./modules/locale.nix;
  network = import ./modules/network.nix;
  nix = import ./modules/nix.nix;
  oom = import ./modules/oom.nix;
  plasma = import ./modules/plasma.nix;
  printing = import ./modules/printing.nix;
  qbittorrent-nox = import ./modules/qbittorrent-nox.nix;
  regreet = import ./modules/regreet.nix;
  sleep-at-night = import ./modules/sleep-at-night.nix;
  sops = import ./modules/sops.nix;
  sunshine = import ./modules/sunshine.nix;
  syncthing = import ./modules/syncthing.nix;
  sysstat = import ./modules/sysstat.nix;
  system = import ./modules/system.nix;
  tailscale = import ./modules/tailscale.nix;
  thunar = import ./modules/thunar.nix;
  touchegg = import ./modules/touchegg.nix;
  tumbler = import ./modules/tumbler.nix;
  virtualisation = import ./modules/virtualisation.nix;
  xserver = import ./modules/xserver.nix;
  zram = import ./modules/zram.nix;
in {
  flake = {
    nixosModules = {
      inherit
        accounts
        android
        atuin
        audio
        bluetooth
        cockpit
        corectrl
        dconf
        disks
        distributed-builder
        doas
        environment
        firefox-syncserver
        firejail
        flatpak
        gamemode
        geoclue2
        gnome
        godot
        greetd
        gvfs
        home-manager
        hyprland
        jellyfin
        laptop-extras
        locale
        lutris
        minecraft-server-1
        network
        nix
        oom
        plasma
        printing
        regreet
        sops
        steam
        syncthing
        sysstat
        system
        tailscale
        thunar
        touchegg
        tumbler
        virtualisation
        xserver
        zram
        ;
      deck = {
        imports = [
          accounts
          #audio
          bluetooth
          doas
          distributed-builder
          fcitx5
          gamemode
          home-manager
          locale
          lutris
          nix
          oom
          sops
          #steam
          syncthing
          system
          qbittorrent-nox
          # Mostly for xkb layout
          xserver

          # Already assigned by jovian
          #zram
        ];
      };
      desktop = {
        imports = [
          atuin
          fcitx5
          firefox-syncserver
          gamemode
          godot
          jellyfin
          lutris
          minecraft-server-1
          sops
          sunshine
          syncthing
          zram
        ];
      };
      work = {
        imports = [
          sops
          zram
        ];
      };
      server = {
        imports = [
          accounts
          doas
          environment
          gvfs
          home-manager
          locale
          network
          nix
          sops
          system
        ];
      };
      thinkpad = {
        imports = [
          accounts
          disks
          distributed-builder
          doas
          docker
          environment
          fcitx5
          gvfs
          home-manager
          laptop-extras
          locale

          nix
          sleep-at-night
          sops
          tailscale
          zram
        ];
      };
      dell = {
        imports = [
          accounts
          disks
          distributed-builder
          doas
          docker
          environment
          fcitx5
          gvfs
          home-manager
          laptop-extras
          locale
          nix
          sleep-at-night
          sops
          tailscale
          zram
        ];
      };
      node = {
        imports = [
          distributed-builder
          fcitx5
          gvfs
          lutris
          minecraft-server
          sleep-at-night
          sops
          sunshine
          syncthing
          zram
        ];
      };
      shared = {
        imports = [
          accounts
          android
          audio
          bluetooth
          corectrl
          dconf
          disks
          doas
          docker
          environment
          firejail
          gvfs
          home-manager
          locale
          nix
          oom
          plasma
          printing
          steam
          sysstat
          system
          tailscale
          thunar
          tumbler
          virtualisation
          xserver
        ];
      };
    };
  };
}
