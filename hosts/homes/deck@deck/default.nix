{
  home = rec {
    username = "deck";
    homeDirectory = "/home/${username}";
  };
  my.home = {
    atuin.enable = false;
    bat.enable = false;
    boilr.enable = true;
    command-line.enable = false;
    gaming.enable = true;
    nix.cache.selfHosted = true;
    secrets = {
      enable = true;
      sopsDirectory = "/var/lib/sops";
    };
  };
}
