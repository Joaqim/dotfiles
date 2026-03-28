_: {
  my.home.development = {
    git = {
      enable = true;
      userName = "runner";
      userEmail = "dummy@mail.com";
    };
    # Important to reduce home manager archive size created in github workflow: `ci-home`:
    nix.enable = false;
  };
}
