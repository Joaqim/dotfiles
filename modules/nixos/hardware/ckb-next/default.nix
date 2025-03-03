# CKB Next keyboard/mouse driver
{
  config,
  lib,
  ...
}: let
  cfg = config.my.hardware.ckb-next;
in {
  options.my.hardware.ckb-next = with lib; {
    enable = mkEnableOption "CKB Next keyboard/mouse drivers and user configuration";
  };

  config = lib.mkIf cfg.enable {
    hardware.ckb-next.enable = true;
  };
}
