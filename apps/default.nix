{
  flake-inputs,
  inputs',
  lib,
  pkgs,
}: let
  inherit (flake-inputs.flake-utils.lib) mkApp;
  # Automatically import all apps in the directory
  files = builtins.readDir ./.;
  # Exclude this file and docs
  apps = builtins.removeAttrs files ["default.nix" "apps.md"];
in
  builtins.mapAttrs (
    name: _: (mkApp {
      drv =
        import "${./.}/${name}"
        (pkgs
          // {inherit inputs' lib;});
    })
  )
  apps
