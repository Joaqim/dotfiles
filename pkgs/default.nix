{
  flake-inputs,
  pkgs,
  self,
}: let
  inherit (self.lib.my) mapModules;
  sources = pkgs.callPackage ./sources.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // {inherit self sources flake-inputs;});
in
  pkgs.lib.makeScope pkgs.newScope (_:
    mapModules ./. (file: callPackage file {}))
