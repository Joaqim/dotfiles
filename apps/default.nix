{
  inputs',
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (self.lib.my) mapModules;
  callPackage =
    pkgs.lib.callPackageWith (pkgs
      // {inherit inputs' lib self;});
in
  mapModules ./. (
    app: {
      type = "app";
      program = lib.getExe (callPackage app {});
    }
  )
