{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.development.nix-index;
in
{
  options.my.home.development.nix-index = with lib; {
    enable = my.mkDisableOption "nix-index configuration";
  };

  config.programs.nix-index = lib.mkIf cfg.enable {
    enable = true;
  };
}
