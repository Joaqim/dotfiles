# System-related modules
{ lib, ... }:
# Automatically import all system modules in the directory
let
  files = builtins.readDir ./.;
  modules = builtins.removeAttrs files [ "default.nix" ];
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) modules;
}
