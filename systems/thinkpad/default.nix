{lib, ...}: {
  imports = [
    ./boot.nix
    ./hardware-config.nix
    ./kernel-optimization.nix
    ./networking.nix
    ./ssh.nix
  ];
  sops.gnupg.home = lib.mkForce "/var/lib/sops";

  i18n.defaultLocale = lib.mkForce "sv_SE.UTF-8";

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  system.stateVersion = lib.mkForce "24.05";
}
