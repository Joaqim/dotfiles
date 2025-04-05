{lib, ...}: {
  my = {
    user = {
      name = lib.mkDefault "user";
      fullName = lib.mkDefault "Default User";
    };
    secrets.enable = false;
    system = {
      impermanence.enable = false;
      # Since we are using an ubuntu based container we use:
      # /etc/nix/nix.conf created by `DeterminateSystems/nix-installer`
      nix.enable = false;
    };
  };

  networking.hostName = lib.mkDefault "container";
  boot.isContainer = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = lib.mkDefault "Europe/Stockholm";
  system.stateVersion = lib.mkForce "24.11";
}
