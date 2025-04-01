{
  inputs',
  pkgs,
  ...
}: let
  inherit (pkgs) writeShellApplication git mktemp;
in
  writeShellApplication {
    name = "commit-nvfetcher";

    runtimeInputs = [
      inputs'.nvfetcher.packages.default
      git
      mktemp
    ];

    text = builtins.readFile ./commit-nvfetcher.sh;
  }
