{
  pkgs,
  lib,
  flake-inputs,
}: let
  inherit (lib) callPackageWith;

  generatedFiles = [
    "pkgs/_sources"
  ];

  mkTest = test:
    pkgs.stdenv.mkDerivation (
      {
        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;
        dontInstall = true;
        doCheck = true;
      }
      // test
    );

  callPackage = callPackageWith (
    pkgs
    // {
      inherit flake-inputs mkTest generatedFiles;
      # Work around `self` technically being a store path when
      # evaluated as a flake - `builtins.filter` can otherwise not be
      # called on it.
      self = builtins.path {
        name = "dotfiles";
        path = flake-inputs.self;
      };
    }
  );
in {
  # Linters and formatters
  deadnix = callPackage ./deadnix.nix {};
  statix = callPackage ./statix.nix {};
}
