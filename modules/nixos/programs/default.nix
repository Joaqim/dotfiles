# Program-related modules
{ lib, ... }:
# Automatically import all program modules in the directory
let
  files = builtins.readDir ./.;
  modules = builtins.removeAttrs files [ "default.nix" ];
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) modules;
}
