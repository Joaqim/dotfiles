{lib, ...}: {
  imports = [
    ./boot.nix
    ./hardware-config.nix
    ./kernel-optimization.nix
    ./networking.nix
    ./ssh.nix
  ];
  # Switch off screen after 5 minutes of inactivity
  boot.kernelParams = [
    "consoleblank=300"
  ];
  # Don't turn off laptop when lid is closed while connected to external power
  services.logind.lidSwitchExternalPower = "ignore";

  sops.gnupg.home = lib.mkForce "/var/lib/sops";

  i18n.defaultLocale = lib.mkForce "sv_SE.UTF-8";

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  system.stateVersion = lib.mkForce "24.05";
}
