{
  home = rec {
    username = "user";
    homeDirectory = "/home/${username}";
  };

  targets.genericLinux.enable = true;

  my.home = {
    atuin.enable = false;
    git.enable = true;
    # TODO: gpg-agent doesn't work in github environment
    gpg.enable = false;
    # Since we are using an ubuntu based container we use:
    # /etc/nix/nix.conf created by `DeterminateSystems/nix-installer`
    nix.enable = false;
    packages = {
      allowUnfree = false;
    };
    # We don't want to use secrets in containers
    secrets.enable = false;
  };
}
