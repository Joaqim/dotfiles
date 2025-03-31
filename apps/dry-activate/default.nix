{inputs', ...}: let
  inherit (inputs'.nixpkgs.legacyPackages) writeShellScript;
in
  toString (writeShellScript "dry-activate" (builtins.readFile ./dry-activate.sh))
