{
  config,
  nur,
  pkgs,
  lib,
  ...
}: let
  user = config.home.username;
in {
  programs.firefox = {
    enable = true;
    # TODO: Couldn't get policies to work here:
    #policies = import ./config-${user}/policies.nix;
    profiles = {
      ${user} = {
        isDefault = true;
        search = import ./config-${user}/search.nix;
        bookmarks = import ./config-${user}/bookmarks.nix;
        settings = import ./config-${user}/settings.nix;
        extensions = import ./config-${user}/extensions.nix {inherit nur pkgs;};
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
}
