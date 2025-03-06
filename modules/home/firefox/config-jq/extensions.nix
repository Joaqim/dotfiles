{pkgs, ...}:
builtins.attrValues {
  inherit
    (pkgs.nur.repos.rycee.firefox-addons)
    bitwarden
    clearurls
    consent-o-matic
    cookie-autodelete
    darkreader
    ff2mpv
    form-history-control
    greasemonkey
    plasma-integration
    reddit-comment-collapser
    reddit-enhancement-suite
    refined-github
    sponsorblock
    tabliss
    tree-style-tab
    ublock-origin
    umatrix
    unpaywall
    vimium-c
    ;
  inherit (pkgs.jqp) chronotube;
}
# https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/generated-firefox-addons.nix

