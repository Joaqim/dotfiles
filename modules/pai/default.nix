# Common modules
{
  self',
  lib,
  ...
}:
# Automatically import all top-level module directories
let
  files = builtins.readDir ./.;
  modules = removeAttrs files [ "default.nix" ];
in
{
  imports = lib.mapAttrsToList (name: _: ./${name}) modules;

  # TODO: Automatically alias personal assistant with configured name
  # see lib.toLower (lib.strings.sanitizeDerivationName pai.assistantName)
  packages.iris = self'.packages.pai;
}
