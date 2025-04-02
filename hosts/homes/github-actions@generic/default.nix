{
  home = rec {
    username = "runner";
    homeDirectory = "/home/${username}";
  };

  my.home = {
    git.disable = true;
  };
}
