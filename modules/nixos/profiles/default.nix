# Configuration that spans across system and home, or are collections of modules
{ lib, ... }:
# Automatically import all profile modules in the directory
let
  files = builtins.readDir ./.;
  modules = builtins.removeAttrs files [ "default.nix" ];
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) modules;
}
