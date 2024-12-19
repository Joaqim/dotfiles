{
  self,
  pkgs,
  flake-inputs,
}: let
  sources = pkgs.callPackage ./sources.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // {inherit self sources flake-inputs;});
in {
  # "Packages" that just contain utility scripts
  commit-nvfetcher = callPackage ./scripts/commit-nvfetcher {};

  # Proper packages
  gauth = callPackage ./applications/gauth.nix {};
  gcs = callPackage ./applications/gcs.nix {};

  mpv-org-history = callPackage ./applications/mpv-org-history/mpv-org-history.nix {};
}
