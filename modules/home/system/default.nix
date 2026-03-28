{ lib, ... }:
# Auto-import all system configuration and core modules
let
  files = builtins.readDir ./.;
  modules = builtins.removeAttrs files [ "default.nix" ];
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) modules;
}
