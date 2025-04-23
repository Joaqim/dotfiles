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
    useExternalDrives = my.mkDisableOption "use udiskie to mount external drives";
  };

  config = lib.mkIf cfg.enable {
    my = {
      hardware = {
        ckb-next.enable = cfg.useCkbNext;

        liquidctl.enable = cfg.useLiquidCtl;
      };
      #  Automatically mount external drives configured in fstab
      home.udiskie.enable = cfg.useExternalDrives;
    };
    environment.systemPackages = with pkgs; [
      # Support for external ntfs drives
      ntfsprogs
    ];
    # TODO: Move to my.profile.devices ?
    programs.gamemode.settings = lib.mkIf cfg.useLiquidCtl {
      custom = let
        notify = lib.getExe pkgs.libnotify;
        liquidctl = lib.getExe pkgs.liquidctl;
        corectrl = lib.getExe' pkgs.corectrl "corectrl";
      in {
        start = "${notify} 'GameMode started' ; ${corectrl} -m Gamemode ; ${liquidctl} --match Hydro set fan speed 100";
        end = "${notify} 'GameMode ended' ; ${corectrl} -m Gamemode ; ${liquidctl} --match Hydro set fan speed 20 50 34 80 90 100";
      };
    };
  };
}
