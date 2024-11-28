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

  # Not using valve index or steam controller
  hardware.steam-hardware.enable = false;

  services.power-profiles-daemon.enable = true;

  # following configuration is added only when building VM with build-vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
    };
  };

  sops.gnupg.home = lib.mkForce "/var/lib/sops";

  i18n.defaultLocale = lib.mkForce "sv_SE.UTF-8";

  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  system.stateVersion = lib.mkForce "24.05";
}
