{inputs', ...}: let
  inherit (inputs'.nixpkgs.legacyPackages) writeShellScript;
in
  toString (
    writeShellScript "update-flake-inputs" ''
      nix flake update --commit-lock-file --option commit-lockfile-summary "chore(deps): Update flake inputs"
    ''
  )
