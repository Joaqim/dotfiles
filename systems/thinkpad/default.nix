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
  services = {
    # Don't turn off laptop when lid is closed while connected to external power
    logind.lidSwitchExternalPower = "ignore";

    power-profiles-daemon.enable = true;

    sleep-at-night = {
      enable = true;
      shutdown = {
        hour = 01;
        minute = 00;
      };
      wakeup = "09:00:00";
    };
  };

  # Not using valve index or steam controller
  hardware.steam-hardware.enable = false;

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
