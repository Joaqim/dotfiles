{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.gamemode;
in {
  options.my.profiles.gamemode = with lib; {
    enable = mkEnableOption "gamemode profile";

    enableRenice = mkEnableOption "enable renice";

    enableGpuOptimisations = mkEnableOption "enable gpu optimisations";
  };

  config = lib.mkIf cfg.enable {
    programs.gamemode = {
      inherit (cfg) enableRenice;
      enable = true;

      # Warning: GPU optimisations have the potential to damage hardware
      settings.gpu = {
        gpu_device = 0;
        amd_performance_level =
          lib.optional
          (config.my.hardware.graphics.gpuFlavor == "amd") "high";
      };
    };
  };
}
