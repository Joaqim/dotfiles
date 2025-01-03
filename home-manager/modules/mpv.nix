{
  pkgs,
  flake,
  ...
}: {
  programs.mpv = {
    enable = true;
    scripts = builtins.attrValues {
      inherit
        (pkgs.mpvScripts)
        mpris
        autoload
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
        ;
      inherit (flake.inputs.self.packages.${pkgs.system}) mpv-org-history;
    };
    config = {
      profile = "gpu-hq";
      display-fps-override = 100;
      demuxer-max-bytes = "512MiB";
      demuxer-readahead-secs = 600;
      resume-playback = "yes";
      save-position-on-quit = "yes";
      image-display-duration = 5;
    };
    scriptOpts = {
      reload.reload_eof_enabled = "yes";
    };
  };

  programs.yt-dlp = {
    enable = true;
    # https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#sponsorblock-options
    extraConfig = "--cookies-from-browser=firefox";
  };
}
