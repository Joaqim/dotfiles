{
  pre-commit = {
    # For now, don't run check on `nix flake check`,
    # will activate this after formatting previously
    # submitted code
    check.enable = true;
    settings.hooks = {
      alejandra.enable = true;
      commitizen.enable = true;
      deadnix.enable = true;
      statix.enable = true;
    };
  };
}
