{
  flake-inputs,
  inputs',
  lib,
  pkgs,
  self,
}: let
  inherit (flake-inputs.flake-utils.lib) mkApp;
  inherit (self.lib.my) mapModules;
in
  mapModules ./. (app:
    mkApp {
      drv =
        import "${app}"
        (pkgs
          // {inherit inputs' lib self;});
    })
