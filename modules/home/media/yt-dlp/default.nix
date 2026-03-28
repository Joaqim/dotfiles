{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.media.yt-dlp;
in
{
  options.my.home.media.yt-dlp = with lib; {
    enable = mkEnableOption "yt-dlp";
  };

  config = lib.mkIf cfg.enable {
    programs.yt-dlp = {
      enable = true;
      package = lib.mkDefault pkgs.yt-dlp;
      settings = {
        no-part = true; # Do not use .part files - write directly into output file
      };
    };
  };
}
