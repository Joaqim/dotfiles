{
  home = rec {
    username = "runner";
    homeDirectory = "/home/${username}";
  };

  targets.genericLinux.enable = true;

  my.home = {
    git.enable = false;
  };
}
