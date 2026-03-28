{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.system.documentation;
in
{
  options.my.home.system.documentation = with lib; {
    enable = mkEnableOption "documentation integration";
  };

  # Add documentation for user packages
  config.programs.man = {
    inherit (cfg) enable;
    generateCaches = true; # Enables the use of `apropos` etc...
  };

  config.programs.info.enable = cfg.enable;
}
