{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.home.applications.qbittorrent;
in
{
  options.my.home.applications.qbittorrent = with lib; {
    enable = mkEnableOption "qbittorrent configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.qbittorrent ];
  };
}
