{
  lib,
  pkgs,
  ...
}:
{
  my.programs = {
    gamemode = {
      enable = true;
      enableRenice = true;
      enableGpuOptimisations = true;
    };
    steam = {
      enable = true;
      #dataDir = "$XDG_DATA_HOME/steamlib";
    };
  };
  # TODO: Create my.programs.gamemode. profiles for different settings depending on my.profiles.devices.useLiquidCtl & my.hardware.graphics.coreCtrl.enable
  programs.gamemode.settings = {
    custom =
      let
        notify = lib.getExe pkgs.libnotify;
        liquidctl = lib.getExe pkgs.liquidctl;
        corectrl = lib.getExe' pkgs.corectrl "corectrl";
      in
      {
        start = "${notify} 'GameMode started' ; ${corectrl} -m Gamemode ; ${liquidctl} --match Hydro set fan speed 100";
        end = "${notify} 'GameMode ended' ; ${corectrl} -m Gamemode ; ${liquidctl} --match Hydro set fan speed 20 50 34 80 90 100";
      };
  };
}
