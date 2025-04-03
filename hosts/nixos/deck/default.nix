{lib, ...}: {
  imports = [
    ./boot.nix
    ./hardware-config.nix
    ./networking.nix
    ./profiles.nix
  ];

  my = {
    secrets = {
      enable = true;
      sopsDirectory = "/var/lib/sops";
    };
    user = {
      name = "deck";
      fullName = "Steam Deck User";
    };
  };

  i18n.defaultLocale = lib.mkForce "sv_SE.UTF-8";

  system.stateVersion = lib.mkForce "24.11";
}
