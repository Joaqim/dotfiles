# User setup
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.my.user) fullName name;
  cfg = config.my.system.users;
  groupExists = grp: builtins.hasAttr grp config.users.groups;
  groupsIfExist = builtins.filter groupExists;
in {
  options.my.system.users = with lib; {
    enable = my.mkDisableOption "user configuration";

    defaultPasswordFile = mkOption {
      type = with types; nullOr str;
      default = null;
    };

    enableRootAccount = mkEnableOption "enable root account";
    rootPasswordFile = mkOption {
      type = with types; nullOr str;
      default = null;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enableRootAccount -> cfg.rootPasswordFile != null;
          message = ''
            `config.my.system.users.enableRootAccount` requires
            `config.my.system.users.rootPasswordFile` to be set.
          '';
        }
      ];
    }
    (lib.mkIf cfg.enableRootAccount {
      users.users.root.hashedPasswordFile = cfg.rootPasswordFile;
    })
    {
      users = {
        mutableUsers = false;

        users = {
          "${name}" = {
            hashedPasswordFile = cfg.defaultPasswordFile;
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
              "dialout" # arduino
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
    }
  ]);
}
