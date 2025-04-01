{
  home = rec {
    username = "deck";
    homeDirectory = "/home/${username}";
  };
  my.home = {
    git.disable = true;
  };
}
