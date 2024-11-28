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
    users.${user0} = {
      description = flake.config.people.users.${user0}.name;
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets."user_hashed_password/${user0}".path;
      shell = pkgs.nushell;
      extraGroups = [
        "adbusers"
        "disk"
        "keys"
        "libvirtd"
        "netdev"
        "networkmanager"
        "vboxusers"
        "wheel"
      ];
    };
  };
  home-manager.users = {
    ${user0} = {
      home = {
        username = user0;
        homeDirectory = "/home/${user0}";
        file = {
          "./justfile".source = ./justfile;
          "./.local/share/Steam/steam_dev.cfg".source = ../../../nixos/modules/steam/steam_dev.cfg;
        };

        sessionVariables = {};
      };
      imports = [
        {home.stateVersion = config.system.stateVersion;}
        (import ./configs/${hostname}.nix {inherit flake;})
      ];
    };
  };
}
