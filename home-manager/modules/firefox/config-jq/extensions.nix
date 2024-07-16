{nur, ...}:
builtins.attrValues {
  inherit
    (nur.repos.rycee.firefox-addons)
    bitwarden
    sponsorblock
    ublock-origin
    unpaywall
    proton-vpn
    ;
}
# https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix

