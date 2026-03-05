{
  inputs',
  lib,
  pkgs,
  self,
  ...
}:
let
  inherit (self.lib.my) mapModules;
  callPackage = pkgs.lib.callPackageWith (
    pkgs
    // {
      inherit
        inputs'
        lib
        self
        ;
    }
  );
in
mapModules ./. (appPath: {
  type = "app";
  program = lib.getExe (callPackage appPath { });
})
