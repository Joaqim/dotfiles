# Common modules
{ lib, ... }:
# Automatically import all top-level module directories
let
  files = builtins.readDir ./.;
  modules = builtins.removeAttrs files [ "default.nix" ];
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) modules;

  # TODO: Move this when we have fixed declarative use of `user0` and `user1` for
  # nixos modules which will use `user0` as the primary user
  options.my = with lib; {
    user = {
      name = mkOption {
        type = types.str;
        default = "jq";
        example = "alice";
        description = "account username";
      };

      fullName = mkOption {
        type = types.nullOr types.str;
        example = "Alice Cooper";
        description = "descriptive name used by account";
      };

      email = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "mail@example.org";
        description = "email used for git module";
      };

      home = {
        enable = my.mkDisableOption "home-manager configuration";
      };
    };
  };
}
