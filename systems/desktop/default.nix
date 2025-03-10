{lib, ...}: {
  imports = [
    ./boot.nix
    ./disko-config.nix
    ./filesystem.nix
    ./graphics.nix
    ./hardware.nix
    ./liquidctl.nix
    ./networking.nix
    ./ssh.nix
    #./impermanence.nix
    ./kernel-optimization.nix
  ];
  networking = {
    hostId = "fce78f04";
    hostName = "desktop";
  };
  services.syncthing-dirs.enable = true;

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  system.stateVersion = lib.mkForce "24.11";
}
