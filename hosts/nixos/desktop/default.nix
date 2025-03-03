{
  inputs,
  lib,
  self,
  ...
}: {
  imports = [
    # Old Configurations
    ## User
    #inputs.home-manager.nixosModules.home-manager
    #"${self}/users/profiles/user0"
    ## Desktop:
    "${self}/nixos/modules/atuin.nix"
    "${self}/nixos/modules/fcitx5.nix"
    "${self}/nixos/modules/gamemode.nix"
    "${self}/nixos/modules/jellyfin.nix"
    "${self}/nixos/modules/lutris.nix"
    #"${self}/nixos/modules/sops.nix"
    "${self}/nixos/modules/syncthing.nix"
    "${self}/nixos/modules/zram.nix"
    ## Shared:
    "${self}/nixos/modules/accounts.nix"
    "${self}/nixos/modules/android.nix"
    "${self}/nixos/modules/audio.nix"
    "${self}/nixos/modules/bluetooth.nix"
    "${self}/nixos/modules/corectrl.nix"
    "${self}/nixos/modules/dconf.nix"
    "${self}/nixos/modules/disks.nix"
    "${self}/nixos/modules/doas.nix"
    "${self}/nixos/modules/docker.nix"
    "${self}/nixos/modules/environment.nix"
    "${self}/nixos/modules/firejail.nix"
    "${self}/nixos/modules/gvfs.nix"
    #"${self}/nixos/modules/home-manager.nix"
    #"${self}/nixos/modules/locale.nix"
    #"${self}/nixos/modules/nix.nix"
    "${self}/nixos/modules/oom.nix"
    "${self}/nixos/modules/plasma.nix"
    "${self}/nixos/modules/printing.nix"
    "${self}/nixos/modules/steam"
    "${self}/nixos/modules/sysstat.nix"
    "${self}/nixos/modules/system.nix"
    "${self}/nixos/modules/tailscale.nix"
    "${self}/nixos/modules/thunar.nix"
    "${self}/nixos/modules/tumbler.nix"
    "${self}/nixos/modules/virtualisation.nix"
    "${self}/nixos/modules/xserver.nix"

    inputs.disko.nixosModules.disko
    ./boot.nix
    ./disko-config.nix
    ./hardware.nix
    ./networking.nix
    ./profiles.nix
    ./programs.nix
    ./services.nix
    ./system.nix
  ];

  time.timeZone = "Europe/Stockholm";

  system.stateVersion = lib.mkForce "24.11";
}
