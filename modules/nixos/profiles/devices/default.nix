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
    my = {
      hardware = {
        ckb-next.enable = true;

        liquidctl.enable = true;
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
