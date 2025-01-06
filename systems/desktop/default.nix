{lib, ...}: {
  imports = [
    ./boot.nix
    ./filesystem.nix
    ./graphics.nix
    ./hardware.nix
    ./liquidctl.nix
    ./networking.nix
    ./ssh.nix
    ./impermanence.nix
    ./kernel-optimization.nix
  ];
  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  system.stateVersion = lib.mkForce "24.11";
}
