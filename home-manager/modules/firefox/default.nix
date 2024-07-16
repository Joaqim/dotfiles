{
  pkgs,
  config,
  nur,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles = let
      user = config.home.username;
    in {
      ${user} = {
        isDefault = true;
        search = import ./config-${user}/search.nix;
        bookmarks = import ./config-${user}/bookmarks.nix;
        settings = import ./config-${user}/settings.nix;
        extensions = import ./config-${user}/extensions.nix {inherit nur;};
        userChrome = builtins.readFile ./config-${user}/userChrome.css;
      };
    };
  };
}
