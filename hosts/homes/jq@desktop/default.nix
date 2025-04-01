{pkgs, ...}: {
  imports = [../jq];

  my.home = {
    boilr.enable = true;
    calibre.enable = true;
    discord.enable = true;
    firefox.enable = true;
    flameshot.enable = false;
    gaming.enable = true;
    kde.enable = true;
    terminal.program = "kitty";
    mpv.enable = true;
    nm-applet.enable = true;
    nushell.enable = true;
    packages.additionalPackages = builtins.attrValues {
      inherit
        (pkgs)
        fluent-reader
        headsetcontrol
        jellyfin-mpv-shim
        nh
        ;
      inherit
        (pkgs.jqp)
        mpv-history-launcher
        yt-dlp
        ;
      inherit
        (pkgs.nur.repos.nltch)
        spotify-adblock
        ;
    };
    qbittorrent.enable = true;
    starship.enable = true;
    vscode.enable = true;
    zathura.enable = true;
  };
}
