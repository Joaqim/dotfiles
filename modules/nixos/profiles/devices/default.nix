{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.profiles.devices;
in {
  options.my.profiles.devices = with lib; {
    enable = mkEnableOption "devices profile";

    useCkbNext = mkEnableOption "use ckb-next";
    useLiquidCtl = mkEnableOption "use liquidctl";
  };

  config = lib.mkIf cfg.enable {
    my = {
      hardware = {
        ckb-next.enable = cfg.useCkbNext;

        liquidctl.enable = cfg.useLiquidCtl;
      };
      #  Automatically mount external drives configured in fstab
      home.udiskie.enable = true;
    };
    environment.systemPackages = with pkgs; [
      # Support for external ntfs drives
      ntfsprogs
    ];
  };
}
