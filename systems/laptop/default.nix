{lib, ...}: {
  imports = [
    ./boot.nix
    ./filesystem.nix
    ./graphics.nix
    ./hardware.nix
    ./networking.nix
    ./ssh.nix
  ];
  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  system.stateVersion = lib.mkForce "24.05";
}
