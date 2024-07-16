{
  config,
  flake,
  pkgs,
  ...
}: let
  hostname = config.networking.hostName;
  inherit
    (flake.config.people)
    user0
    ;
in {
  users = {
    users.${flake.config.people.user0} = {
      description = flake.config.people.users.${flake.config.people.user0}.name;
      isNormalUser = true;
      initialPassword = "";
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
    ${flake.config.people.user0} = {
      home = {
        username = user0;
        homeDirectory = "/home/${user0}";
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
