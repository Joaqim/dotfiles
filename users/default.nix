{lib, ...}: let
  peopleSubmodule = lib.types.submodule {
    options = {
      user0 = lib.mkOption {
        type = lib.types.str;
      };
      user1 = lib.mkOption {
        type = lib.types.str;
      };
      user2 = lib.mkOption {
        type = lib.types.str;
      };
      users = lib.mkOption {
        type = lib.types.attrsOf userSubmodule;
      };
    };
  };
  userSubmodule = lib.types.submodule {
    options = {
      email = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      name = lib.mkOption {
        type = lib.types.str;
      };
      sshKeys = lib.mkOption {
        type = lib.types.listOf lib.types.str;
      };
    };
  };
in {
  options.people = lib.mkOption {
    type = peopleSubmodule;
  };

  config.people = import ./config.nix;
}
