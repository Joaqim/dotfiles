{
  lib,
  pkgs,
  ...
}: {
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };

      # Warning: GPU optimisations have the potential to damage hardware
      gpu = {
        gpu_device = 0;
        amd_performance_level = "high";
      };

      custom = let
        notify = lib.getExe pkgs.libnotify;
        liquidctl = lib.getExe pkgs.liquidctl;
        corectrl = lib.getExe pkgs.corectrl;
      in {
        start = "${notify} 'GameMode started' ; ${corectrl} -m Gamemode ; ${liquidctl} --match Hydro set fan speed 100";
        end = "${notify} 'GameMode ended' ; ${corectrl} -m Gamemode ; ${liquidctl} --match Hydro set fan speed 20 50 34 80 90 100";
      };
    };
  };
}
