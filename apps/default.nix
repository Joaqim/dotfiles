{
  inputs',
  lib,
  pkgs,
}: let
  mkApp = program: {
    inherit program;
    type = "app";
  };
  # Automatically import all apps in the directory
  files = builtins.readDir ./.;
  # Exclude this file and docs
  apps = builtins.removeAttrs files ["default.nix" "apps.md"];
in
  builtins.mapAttrs (
    name: _:
      mkApp (
        import "${./.}/${name}"
        (pkgs
          // {inherit inputs' lib;})
      )
  )
  apps
