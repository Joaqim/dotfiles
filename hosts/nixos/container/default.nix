{lib, ...}: {
  my = {
    user = {
      name = "user";
      fullName = "Default User";
    };
    secrets.enable = false;
  };

  networking.hostName = lib.mkDefault "container";
  boot.isContainer = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = "Europe/Stockholm";
  system.stateVersion = lib.mkForce "24.11";
}
