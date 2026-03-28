{ lib, ... }:
# Auto-import all user service modules
let
  files = builtins.readDir ./.;
  modules = builtins.removeAttrs files [ "default.nix" ];
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) modules;
}
