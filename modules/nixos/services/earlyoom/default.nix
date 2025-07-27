{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.earlyoom;
in
{
  options.my.services.earlyoom = with lib; {
    enable = mkEnableOption "Enable earlyoom to manage memory better and prevent freezes";
  };

  config = lib.mkIf cfg.enable {
    services.earlyoom = {
      enable = true;
      freeMemThreshold = 15;
    };
    systemd.oomd.enable = false;
    # Harden earlyoom
    systemd.services.earlyoom = {
      enable = true;
      serviceConfig = {
        PrivateNetwork = true;
        MemoryDenyWriteExecute = true;
        InaccessiblePaths = lib.mkDefault "/persist";
        ProtectHome = true;
      };
    };
  };
}
