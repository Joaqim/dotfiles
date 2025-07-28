{ pkgs, ... }:
{
  home = rec {
    username = "wilton";
    homeDirectory = "/home/${username}";
  };

  my.home = {
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
    atuin.enable = false;
    boilr.enable = false;
    bottom.enable = false;
    direnv.enable = false;
    documentation.enable = false;
    fzf.enable = false;
    git.enable = false;
    jq.enable = false;
    nix.cache.selfHosted = true;
    nushell.enable = false;
    pager.enable = false;
    starship.enable = false;
    vscode.enable = false;
  };
}
