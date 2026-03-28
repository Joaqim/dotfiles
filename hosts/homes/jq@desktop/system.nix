{ pkgs, ... }:
{
  my.home.system = {
    documentation.enable = true;
    packages.additionalPackages = builtins.attrValues {
      inherit (pkgs)
        fluent-reader
        headsetcontrol
        jellyfin-mpv-shim
        nh
        rqbit
        cataclysm-dda
        lm_sensors
        wl-clipboard
        cavasik # Simple audio visualizer
        ;
      inherit (pkgs.my)
        mpv-history-launcher
        ;
    };
  };
}
