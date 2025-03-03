{
  self,
  pkgs,
  flake-inputs,
}: let
  sources = pkgs.callPackage ./sources.nix {};
  callPackage = pkgs.lib.callPackageWith (pkgs // {inherit self sources flake-inputs;});
in
  pkgs.lib.makeScope pkgs.newScope (_: {
    # "Packages" that just contain utility scripts
    commit-nvfetcher = callPackage ./commit-nvfetcher {};
    mpv-history-launcher = callPackage ./mpv-history-launcher {};

    # Extensions to existing Applications
    mpv-skipsilence = callPackage ./mpv-skipsilence {};
    mpv-org-history = callPackage ./mpv-org-history {};

    # Plasmoids
    twitchindicator = callPackage ./twitchindicator {};

    # Proper packages
    undertaker141 = callPackage ./undertaker141 {};

    # Packages that override existing packages in `nixpkgs`
    yt-dlp = callPackage ./yt-dlp {};
  })
