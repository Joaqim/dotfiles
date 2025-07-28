{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.home.qbittorrent;
in
{
  options.my.home.qbittorrent = with lib; {
    enable = mkEnableOption "qbittorrent configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.qbittorrent ];
  };
}
