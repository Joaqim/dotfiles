{pkgs, ...}: {
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
        ;
    };
    config = {
      profile = "gpu-hq";
      display-fps-override = 100;
      #ytdl-format = "bestvideo+bestaudio";
      demuxer-cache-duration = "600";
      resume-playback = "yes";
      save-position-on-quit = "yes";
      image-display-duration = "5";
    };
  };

  programs.yt-dlp = {
    enable = true;
    # https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#sponsorblock-options
    extraConfig = "--cookies-from-browser=firefox";
  };
}
