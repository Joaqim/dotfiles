{
  home = rec {
    username = "deck";
    homeDirectory = "/home/${username}";
  };
  my.home = {
    atuin.enable = false;
    boilr.enable = true;
    command-line.enable = false;
    gaming.enable = true;
    nix.cache.selfHosted = true;
    bottom.enable = false;
    direnv.enable = false;
    documentation.enable = false;
    fzf.enable = false;
    git.enable = false;
    jq.enable = false;
    nushell.enable = false;
    pager.enable = false;
    starship.enable = false;
    vscode.enable = false;
    secrets = {
      enable = true;
      sopsDirectory = "/var/lib/sops";
    };
  };
}
