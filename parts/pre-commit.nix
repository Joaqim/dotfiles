{
  pre-commit = {
    check.enable = true;

    settings.hooks = let
      # Define shared settings
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
      statix = {
        enable = true;
      };
    };
  };
}
