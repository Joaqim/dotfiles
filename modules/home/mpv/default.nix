{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.mpv;
  inherit (pkgs.jqpkgs) yt-dlp-git;
in
{
  options.my.home.mpv = with lib; {
    enable = mkEnableOption "mpv configuration";

    screenshotDirectory = mkOption {
      type = with types; nullOr str;
      description = "mpv screenshot directory relative to home";
      default = "Pictures/mpv-screenshots";
    };
    screenshotTemplate = mkOption {
      type = with types; nullOr str;
      description = "mpv screenshot template";
      default = "%F - [%P] (%#01n)";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      file."${cfg.screenshotDirectory}/.keep" = {
        enable = cfg.screenshotDirectory != null;
        text = "";
      };
      packages = [
        pkgs.noto-fonts-color-emoji
      ];
    };
    programs = {
      mpv = {
        enable = true;
        scripts =
          with pkgs;
          builtins.attrValues {
            inherit (mpvScripts)
              mpris
              sponsorblock
              modernx
              mpv-playlistmanager
              webtorrent-mpv-hook
              reload
              ;
            inherit (mpvScripts.builtins)
              autocrop
              autodeint
              ;
            inherit (mpvScripts.eisa01) smartskip; # https://github.com/Eisa01/mpv-scripts#smartskip
            inherit (mpvScripts.occivink) blacklistExtensions;
            inherit (jqpkgs)
              mpv-org-history
              mpv-skipsilence
              ;
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
          screenshot-dir = "~/${cfg.screenshotDirectory}";
          screenshot-template = cfg.screenshotTemplate;
          ytdl-raw-options = lib.concatStringsSep "," [
            "sub-lang=en"
            "write-sub="
            "write-auto-sub="
          ];
          sub-font = "Noto Color Emoji";
          vo = "gpu-next";
          watch-later-options = lib.concatStringsSep "," [
            "start"
            "volume"
            "mute"
            "playlist"
            "speed"
          ];
        };
        scriptOpts = {
          # For restarting playback when a Live Twitch VOD reaches current end
          reload.reload_eof_enabled = "yes";
          ytdl_hook.ytdl_path = "${lib.getExe yt-dlp-git}";
        };
      };
    };

    xdg.mimeApps.defaultApplications."x-scheme-handler/mpv" = "mpv.desktop";
  };
}
