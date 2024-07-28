{
  config,
  flake,
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
        "networkmanager"
        "wheel"
      ];
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
