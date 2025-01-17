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

  # Extensions to existing Applications
  mpv-skipsilence = callPackage ./applications/mpv-skipsilence.nix {};
  mpv-org-history = callPackage ./applications/mpv-org-history/mpv-org-history.nix {};

  # Proper packages
  undertaker141 = callPackage ./applications/undertaker141/undertaker141.nix {};

  # Packages that override existing packages in `nixpkgs`
  yt-dlp = callPackage ./applications/yt-dlp.nix {inherit pkgs;};
}
