{
  config,
  lib,
  ...
}:
let
  cfg = config.my.system.zram;
in
{
  options.my.system.zram = with lib; {
    enable = mkEnableOption "zram swap configuration";
    kernelSysctl = mkEnableOption "zram swap kernel sysctl configuration";
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        zramSwap = {
          enable = true;
          memoryPercent = lib.mkDefault 150;
        };
      }
      (lib.mkIf cfg.kernelSysctl {
        boot.kernel.sysctl = {
          "vm.swappiness" = lib.mkForce 200;
          "vm.watermark_boost_factor" = 0;
          "vm.watermark_scale_factor" = 125;
          "vm.page-cluster" = 0;
        };
      })
    ]
  );
}
