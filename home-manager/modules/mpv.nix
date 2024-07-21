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
        simple-mpv-webui
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
      ytdl-format = "bestvideo+bestaudio";
    };
  };

  programs.yt-dlp = {
    enable = true;
    extraConfig = "--cookies-from-browser=firefox";
  };
}
