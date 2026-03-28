{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.firefox;
  user = config.home.username;
in
{
  options.my.home.firefox = with lib; {
    enable = mkEnableOption "firefox configuration";
  };

  config = lib.mkIf cfg.enable {
    # https://abishekmuthian.com/play-youtube-video-from-firefox-on-mpv/
    home.packages = [
      # https://github.com/NixOS/nixpkgs/blob/62e0f05ede1da0d54515d4ea8ce9c733f12d9f08/pkgs/by-name/mp/mpv-handler/package.nix#L33
      (pkgs.mpv-handler.override {
        # Don't wrap mpv & yt-dlp, use binaries from PATH instead
        # These derivations are only used in makeBinPath,
        # so we can replace them with empty paths
        mpv = "";
        yt-dlp = "";
      })
    ];

    programs.firefox = {
      enable = true;
      languagePacks = lib.mkDefault [
        "en-US"
        "sv-SE"
      ];
      nativeMessagingHosts = [
        pkgs.ff2mpv
      ];
      profiles = {
        ${user} = lib.mkIf (lib.pathExists ./config-${user}) {
          isDefault = true;
          search = import ./config-${user}/search.nix;
          bookmarks = import ./config-${user}/bookmarks.nix;
          settings = import ./config-${user}/settings.nix;
          extensions.packages = import ./config-${user}/extensions.nix { inherit pkgs; };
          userChrome = builtins.readFile ./config-${user}/userChrome.css;

          # Darker background for new tabs (to not blast eyes with blinding white).
          userContent = ''
            .tab:not(:hover) .closebox {
              display: none;
            }
          '';
        };
      };
    };

    xdg.mimeApps = {
      enable = lib.mkDefault true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };
  };
}
