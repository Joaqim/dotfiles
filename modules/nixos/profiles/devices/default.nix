{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.devices;
in {
  options.my.profiles.devices = with lib; {
    enable = mkEnableOption "devices profile";
  };

  config = lib.mkIf cfg.enable {
    my.hardware.ckb-next.enable = true;

    #  Automatically mount external drives configured in fstab
    services.udiskie2.enable = true;
  };
}
