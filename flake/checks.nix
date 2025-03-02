{inputs, ...}: {
  imports = [
    inputs.pre-commit-hooks-nix.flakeModule
  ];

  perSystem = _: {
    pre-commit = {
      check.enable = true;
      settings.hooks = let
        # Exclude generated _sources by nvfetcher
        excludes = ["_sources"];
      in {
        alejandra = {
          enable = true;
          inherit excludes;
        };
        commitizen = {
          enable = true;
        };
        deadnix = {
          enable = true;
          inherit excludes;
        };
        flake-checker = {
          enable = true;
        };
        statix = {
          enable = true;
        };
      };
    };
  };
}
