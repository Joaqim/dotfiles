let
  # Folders
  steam = import ./modules/steam;
  # Files
  accounts = import ./modules/accounts.nix;
  android = import ./modules/android.nix;
  audio = import ./modules/audio.nix;
  bluetooth = import ./modules/bluetooth.nix;
  cockpit = import ./modules/cockpit.nix;
  corectrl = import ./modules/corectrl.nix;
  dconf = import ./modules/dconf.nix;
  disks = import ./modules/disks.nix;
  doas = import ./modules/doas.nix;
  docker = import ./modules/docker.nix;
  environment = import ./modules/environment.nix;
  firejail = import ./modules/firejail.nix;
  flatpak = import ./modules/flatpak.nix;
  geoclue2 = import ./modules/geoclue2.nix;
  gnome = import ./modules/gnome.nix;
  greetd = import ./modules/greetd.nix;
  gvfs = import ./modules/gvfs.nix;
  home-manager = import ./modules/home-manager.nix;
  hyprland = import ./modules/hyprland.nix;
  jellyfin = import ./modules/jellyfin.nix;
  minecraft-server-1 = import ./modules/minecraft-servers/better-minecraft-modpack.nix;
  laptop-extras = import ./modules/laptop.nix;
  locale = import ./modules/locale.nix;
  network = import ./modules/network.nix;
  nix = import ./modules/nix.nix;
  oom = import ./modules/oom.nix;
  plasma = import ./modules/plasma.nix;
  printing = import ./modules/printing.nix;
  regreet = import ./modules/regreet.nix;
  sops = import ./modules/sops.nix;
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
        audio
        bluetooth
        cockpit
        corectrl
        dconf
        disks
        doas
        environment
        firejail
        flatpak
        geoclue2
        gnome
        greetd
        gvfs
        home-manager
        hyprland
        jellyfin
        laptop-extras
        locale
        minecraft-server-1
        network
        nix
        oom
        plasma
        printing
        regreet
        sops
        steam
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
      nas = {
        imports = [
          accounts
          disks
          doas
          environment
          gvfs
          home-manager
          jellyfin
          locale
          network
          nix
          plasma
          sops
          system
          xserver
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
          sops
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
