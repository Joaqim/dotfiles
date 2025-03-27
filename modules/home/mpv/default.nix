{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.mpv;
  inherit (pkgs.jqp) yt-dlp;
in {
  options.my.home.mpv = with lib; {
    enable = mkEnableOption "mpv configuration";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      mpv = {
        enable = true;
        scripts = builtins.attrValues {
          inherit
            (pkgs.mpvScripts)
            mpris
            sponsorblock
            modernx
            quality-menu
            thumbfast
            mpv-playlistmanager
            mpv-cheatsheet
            webtorrent-mpv-hook
            reload
            ;
          inherit (pkgs.mpvScripts.builtins) autocrop autodeint;
          inherit (pkgs.mpvScripts.eisa01) smartskip; # https://github.com/Eisa01/mpv-scripts#smartskip
          inherit (pkgs.mpvScripts.occivink) blacklistExtensions;
          inherit (pkgs.jqp) mpv-org-history mpv-skipsilence;
        };
        config = {
          profile = "gpu-hq";
          display-fps-override = 100;
          demuxer-max-bytes = "512MiB";
          demuxer-readahead-secs = 600;
          resume-playback = "yes";
          save-position-on-quit = "yes";
          image-display-duration = 5;
          # https://github.com/ferreum/mpv-skipsilence/tree/master?tab=readme-ov-file#fix-clicking-soundsgaps-when-switching-to-and-from-1x-speed
          af-add = "scaletempo2";
          screenshot-dir = "~/Pictures/mpv-screenshots"; # TODO: Make sure directory exists
          screenshot-template = "%F - [%P] (%#01n)";
          ytdl-raw-options = "sub-lang=\"en\",write-sub=,write-auto-sub=";
          sub-font = "Noto Color Emoji";
          vo = "gpu-next";
          # NOTE: Needed to make sure that mpv uses the correct yt-dlp
          script-opts = "ytdl_hook-ytdl_path=${lib.getExe yt-dlp}";
          watch-later-options = "start,volume,mute,fullscreen,sub-file,playlist,user-data/skipsilence/enabled,user-data/skipsilence/enabled,user-data/skipsilence/base_speed,speed";
        };
        scriptOpts = {
          # For restarting playback when a Live Twitch VOD reaches current end
          reload.reload_eof_enabled = "yes";
        };
      };

      yt-dlp = {
        enable = true;
        package = yt-dlp;

        # https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#sponsorblock-options
        extraConfig = "--cookies-from-browser=firefox";
      };
    };

    xdg.mimeApps.defaultApplications."x-scheme-handler/mpv" = "mpv.desktop";
  };
}
