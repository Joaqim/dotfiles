{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware.networking;
in {
  options.my.hardware.networking = with lib; {
    externalInterface = mkOption {
      wireless = {
        enable = mkEnableOption "wireless configuration";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.wireless.enable {
      networking.networkmanager.enable = true;
    })
  ];
}
