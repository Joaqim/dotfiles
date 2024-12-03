{lib, ...}: {
  imports = [
    ./boot.nix
    ./filesystem.nix
    ./graphics.nix
    ./hardware.nix
    ./impermanence.nix
    ./networking.nix
    ./ssh.nix
  ];
  nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
  system.stateVersion = lib.mkForce "24.05";
  networking.hostName = lib.mkForce "node";
  networking.hostId = lib.mkForce "deadbeef";

  # When booting into emergency or rescue targets, do not require the password
  # of the root user to start a root shell.  I am ok with the security
  # consequences, for this host.  Do not blindly copy this without
  # understanding.  Note that SYSTEMD_SULOGIN_FORCE is considered semi-unstable
  systemd.services = {
    emergency.environment.SYSTEMD_SULOGIN_FORCE = "1";
    rescue.environment.SYSTEMD_SULOGIN_FORCE = "1";
  };
}
