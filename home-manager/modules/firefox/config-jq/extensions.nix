{
  nur,
  pkgs,
  ...
}: let
  customAddons = pkgs.callPackage ./addons.nix {
    inherit (nur.repos.rycee.firefox-addons) buildFirefoxXpiAddon;
  };
in
  builtins.attrValues {
    inherit
      (nur.repos.rycee.firefox-addons)
      bitwarden
      clearurls
      cookie-autodelete
      darkreader
      greasemonkey
      plasma-integration
      reddit-enhancement-suite
      sponsorblock
      tabliss
      tree-style-tab
      ublock-origin
      umatrix
      unpaywall
      ff2mpv
      vimium-c
      ;
    inherit (customAddons) chronotube;
  }
# https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix

