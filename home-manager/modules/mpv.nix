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
    };
  };

  programs.yt-dlp = {
    enable = true;
    # https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#sponsorblock-options
    extraConfig = "--cookies-from-browser=firefox";
  };
}
