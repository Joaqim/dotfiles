{
  config,
  lib,
  ...
}:
let
  cfg = config.my.home.utilities.bluetooth;
in
{
  options.my.home.utilities.bluetooth = with lib; {
    enable = mkEnableOption "bluetooth configuration";
  };

  config = lib.mkIf cfg.enable {
    services.mpris-proxy = {
      enable = true;
    };
  };
}
