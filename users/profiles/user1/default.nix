{
  config,
  flake,
  pkgs,
  ...
}: let
  hostname = config.networking.hostName;
  inherit
    (flake.config.people)
    user1
    ;
in {
  users = {
    users.${flake.config.people.user1} = {
      description = flake.config.people.users.${flake.config.people.user1}.name;
      isNormalUser = true;
      shell = pkgs.nushell;
      extraGroups = [
        "libvirtd"
        "disk"
        "networkmanager"
        "vboxusers"
        "wheel"
        "adbusers"
        "netdev"
      ];
    };
  };
  home-manager.users = {
    ${flake.config.people.user1} = {
      home = {
        username = user1;
        homeDirectory = "/home/${user1}";
        file = {
          "./justfile".source = ./justfile;
          "./.steam/steam/steam_dev.cfg".source = ../../../nixos/modules/steam/steam_dev.cfg;
        };
        sessionVariables = {};
      };
      imports = [
        {home.stateVersion = config.system.stateVersion;}
        (import ./configs/${hostname}.nix {flake = flake;})
      ];
    };
  };
}
