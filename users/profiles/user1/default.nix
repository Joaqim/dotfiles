{
  config,
  flake,
  lib,
  ...
}: let
  hostname = config.networking.hostName;
  inherit
    (flake.config.people)
    user1
    ;
in {
  users = {
    users."${user1}" = {
      description = flake.config.people.users."${user1}".name;
      isNormalUser = true;
      extraGroups = [
        "input"
        "keys"
        "networkmanager"
        "wheel"
      ];
    };
  };
  sops.secrets = {
    "private_key/jq-${user1}" = lib.mkForce {
      path = "/home/${user1}/.ssh/id_ed25519";
      owner = user1;
    };
    "public_key/jq-${user1}" = lib.mkForce {
      path = "/home/${user1}/.ssh/id_ed25519.pub";
      owner = user1;
    };
  };
  home-manager.users = {
    "${user1}" = {
      home = {
        username = user1;
        homeDirectory = "/home/${user1}";
        sessionVariables = {};
      };
      imports = [
        {home.stateVersion = config.system.stateVersion;}
        (import ./configs/${hostname}.nix {inherit flake;})
      ];
    };
  };
}
