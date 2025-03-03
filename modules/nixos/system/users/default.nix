# User setup
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.sops) secrets;
  inherit (config.my.user) fullName name;
  cfg = config.my.system.users;
  groupExists = grp: builtins.hasAttr grp config.users.groups;
  groupsIfExist = builtins.filter groupExists;
in {
  options.my.system.users = with lib; {
    enable = my.mkDisableOption "user configuration";
  };

  config = lib.mkIf cfg.enable {
    users = {
      mutableUsers = false;

      users = {
        root = {
          hashedPasswordFile = secrets."user_hashed_password/jq".path;
        };

        "${name}" = {
          hashedPasswordFile = secrets."user_hashed_password/${name}".path;
          description = fullName;
          isNormalUser = true;
          shell = pkgs.nushell;
          extraGroups = groupsIfExist [
            "audio" # sound control
            "docker" # usage of `docker` socket
            "keys" # access to sops keys at /var/lib/sops
            "media" # access to media files
            "networkmanager" # wireless configuration
            "podman" # usage of `podman` socket
            "video" # screen control
            "wheel" # `sudo` for the user.
          ];
          openssh.authorizedKeys.keys = with builtins; let
            keyDir = ./ssh;
            contents = readDir keyDir;
            names = attrNames contents;
            files = filter (name: contents.${name} == "regular") names;
            keys = map (basename: readFile (keyDir + "/${basename}")) files;
          in
            keys;
        };
      };
    };
  };
}
