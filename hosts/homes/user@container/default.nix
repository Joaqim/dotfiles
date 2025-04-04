{
  home = rec {
    username = "user";
    homeDirectory = "/home/${username}";
  };

  targets.genericLinux.enable = true;

  my.home = {
    git.enable = true;
    # TODO: gpg-agent doesn't work in github environment
    gpg.enable = false;
    # We don't want to use secrets in containers
    secrets.enable = false;
  };
}
