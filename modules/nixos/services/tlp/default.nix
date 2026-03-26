{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.tlp;
in
{
  options.my.services.tlp = {
    enable = lib.mkEnableOption "TLP power management";
  };

  config = lib.mkIf cfg.enable {
    services.tlp.enable = true;
  };
}
