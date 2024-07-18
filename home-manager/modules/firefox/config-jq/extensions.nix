{nur, ...}:
builtins.attrValues {
  inherit
    (nur.repos.rycee.firefox-addons)
    bitwarden
    clearurls
    cookie-autodelete
    darkreader
    english-dictionary
    greasemonkey
    reddit-enhancement-suite
    sponsorblock
    swedish-dictionary
    tabliss
    tree-style-tab
    ublock-origin
    umatrix
    unpaywall
    ;
}
# https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix

