{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.yt-dlp;
  inherit (pkgs.jqpkgs) yt-dlp-git;
in
{
  options.my.home.yt-dlp = with lib; {
    enable = mkEnableOption "yt-dlp";
  };

  config = lib.mkIf cfg.enable {
    programs.yt-dlp = {
      enable = true;
      package = yt-dlp-git;
      settings = {
        no-part = true; # Do not use .part files - write directly into output file
      };
    };
  };
}
