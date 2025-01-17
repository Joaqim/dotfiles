{
  pkgs,
  flake,
  lib,
  ...
}: let
  inherit (flake.inputs.self.packages.${pkgs.system}) yt-dlp mpv-org-history mpv-skipsilence;
in {
  programs.mpv = {
    enable = true;
    scripts =
      (builtins.attrValues {
        inherit
          (pkgs.mpvScripts)
          mpris
          sponsorblock
          autocrop
          modernx
          quality-menu
          thumbfast
          memo
          mpv-playlistmanager
          blacklistExtensions
          autodeint
          mpv-cheatsheet
          webtorrent-mpv-hook
          reload
          # https://github.com/Eisa01/mpv-scripts#smartskip
          smartskip
          ;
      })
      ++ [mpv-org-history mpv-skipsilence];
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
      # NOTE: Needed to make sure that mpv uses the correct yt-dlp
      # TODO: We should only have one 'correct' yt-dlp executable available.
      script-opts = "ytdl_hook-ytdl_path=${lib.getExe yt-dlp}";
    };
    scriptOpts = {
      reload.reload_eof_enabled = "yes";
    };
  };

  programs.yt-dlp = {
    enable = true;
    package = yt-dlp;

    # https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#sponsorblock-options
    extraConfig = "--cookies-from-browser=firefox";
  };

  xdg.mimeApps.defaultApplications."x-scheme-handler/mpv" = "mpv.desktop";
}
