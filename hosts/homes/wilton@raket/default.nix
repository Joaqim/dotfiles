{
  pkgs,
  ...
}:
{
  home = rec {
    username = "wilton";
    homeDirectory = "/home/${username}";
  };

  my.home = {
    development = {
      direnv.enable = false;
      git.enable = false;
      nix.cache.selfHosted = true;
      vscode.enable = false;
    };

    gaming = {
      boilr.enable = false;
    };

    shell = {
      atuin.enable = false;
      fzf.enable = false;
      nushell.enable = false;
      pager.enable = false;
      starship.enable = false;
    };

    system = {
      documentation.enable = false;
      jq.enable = false;
      packages.additionalPackages = builtins.attrValues {
        inherit (pkgs)
          # TODO: Is this still needed?
          # KDE complains, even if nvidia doesn't seem to provide power profiles ?
          power-profiles-daemon
          discord
          ;
        inherit (pkgs.nur.repos.nltch)
          spotify-adblock
          ;
      };
      secrets.enable = false; # Disable for now
    };

    utilities = {
      bottom.enable = false;
    };
  };
}
