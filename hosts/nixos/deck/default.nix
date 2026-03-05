{ lib, ... }:
{
  imports = [
    ./boot.nix
    ./hardware-config.nix
    ./networking.nix
    ./profiles.nix
  ];

  services.flatpak.enable = true;
  users.groups.jq = { };
  users.users."jq" = {
    group = "jq";
    extraGroups = [
      "wheel"
      "deck"
    ];
    initialPassword = lib.mkDefault "a";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK58SYMpYN5W9x8tt7gBoGT8bSOFVagSWxJsD4wPU5Z1 jq@desktop"
    ];
  };
  # cmd: flatpak run --branch=stable --arch=x86_64 --command=sober
  # icon: org.vinegarhq.Sober

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

  time.timeZone = "Europe/Stockholm";
  system.stateVersion = lib.mkForce "24.11";
}
