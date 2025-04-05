{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.pre-commit-hooks-nix.flakeModule
  ];

  perSystem = {pkgs, ...}: {
    pre-commit = {
      check.enable = true;
      settings.hooks = let
        # Exclude generated _sources by nvfetcher
        excludes = ["_sources"];
      in {
        alejandra = {
          enable = true;
          inherit excludes;
        };
        commitizen = {
          enable = true;
        };
        deadnix = {
          enable = true;
          inherit excludes;
        };
        flake-checker = {
          enable = true;
        };
        gitleaks = {
          enable = true;
          entry = "''${lib.getExe pkgs.gitleaks} git . --redact=100";
          name = "GitLeaks";
          package = pkgs.gitleaks;
          pass_filenames = false;
        };
        statix = {
          enable = true;
        };
      };
    };
  };
}
