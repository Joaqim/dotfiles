{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.utilities.udiskie;
in
{
  options.my.home.utilities.udiskie = with lib; {
    enable = mkEnableOption "udiskie configuration";
  };

  config.services.udiskie = lib.mkIf cfg.enable {
    enable = true;
  };
}
