{lib, ...}: {
  my = {
    user = {
      name = "user";
      fullName = "Default User";
    };
    secrets.enable = false;
  };

  networking.hostName = lib.mkDefault "container";

  boot.loader.systemd-boot = {
    enable = true;
    # https://discourse.nixos.org/t/no-space-left-on-boot/24019/20
    configurationLimit = 10;
  };

  # Pseudo values to pass flake check validations
  # You should override in your hardware-configuration.nix
  fileSystems."/" = lib.mkDefault {
    device = "/dev/sda1";
    fsType = "ext4";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = "Europe/Stockholm";
  system.stateVersion = lib.mkForce "24.11";
}
