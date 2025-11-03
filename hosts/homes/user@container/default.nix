{
  home = rec {
    username = "user";
    homeDirectory = "/home/${username}";
  };

  targets.genericLinux.enable = true;

  my.home = {
    atuin.enable = false;
    git = {
      enable = true;
      userEmail = "dummy@mail.com";
    };
    # TODO: gpg-agent doesn't work in github environment
    gpg.enable = false;
    nix.enable = true;
    # We don't expect to use unfree packages in this container
    packages.allowUnfree = false;

    # We don't want to use secrets in containers
    # As a safety measure, we also run `gitleaks`
    # on built container before uploading to ghcr.io
    secrets.enable = false;
  };
}
