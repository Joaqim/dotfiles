{
  inputs',
  lib,
  self',
  ...
}: let
  inherit (inputs'.nixpkgs.legacyPackages) writeShellScript;
  commit-nvfetcher = lib.getExe self'.packages.commit-nvfetcher;
in
  toString (
    writeShellScript "commit-nvfetcher" ''
      ${commit-nvfetcher} -k /tmp/github-key.toml
    ''
  )
