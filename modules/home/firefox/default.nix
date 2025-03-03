{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.firefox;
  user = config.home.username;
in {
  options.my.home.firefox = with lib; {
    enable = mkEnableOption "firefox configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      languagePacks = lib.mkDefault ["en-US" "sv-SE"];
      nativeMessagingHosts = [
        pkgs.ff2mpv
      ];
      profiles = {
        ${user} = lib.mkIf (lib.pathExists ./config-${user}) {
          isDefault = true;
          search = import ./config-${user}/search.nix;
          bookmarks = import ./config-${user}/bookmarks.nix;
          settings = import ./config-${user}/settings.nix;
          extensions.packages = import ./config-${user}/extensions.nix {inherit pkgs;};
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
