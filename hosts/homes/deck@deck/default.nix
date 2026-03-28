{
  home = rec {
    username = "deck";
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
      boilr.enable = true;
      bundle.enable = true;
    };

    shell = {
      atuin.enable = false;
      command-line.enable = false;
      fzf.enable = false;
      nushell.enable = false;
      pager.enable = false;
      starship.enable = false;
    };

    system = {
      documentation.enable = false;
      jq.enable = false;
      secrets = {
        enable = true;
        sopsDirectory = "/var/lib/sops";
      };
    };

    utilities = {
      bottom.enable = false;
    };
  };
}
