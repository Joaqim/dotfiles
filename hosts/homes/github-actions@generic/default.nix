{
  home = rec {
    username = "runner";
    homeDirectory = "/home/${username}";
  };

  targets.genericLinux.enable = true;

  my.home = {
    git.enable = true;
    # TODO: gpg-agent doesn't work in github environment
    gpg.enable = false;
    # Important to reduce home manager archive size created in github workflow: `ci-home`:
    nix.enable = false;
    # For now, we don't use sops in github environment
    secrets.enable = false;
  };
}
