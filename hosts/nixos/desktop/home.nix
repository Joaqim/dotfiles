{pkgs, ...}: {
  my.home = {
    boilr.enable = false;
    calibre.enable = true;
    discord.enable = true;
    firefox.enable = true;
    flameshot.enable = false;
    gaming.enable = true;
    terminal.program = "kitty";
    mpv.enable = true;
    nm-applet.enable = true;
    packages.additionalPackages = builtins.attrValues {
      inherit
        (pkgs)
        calibre
        fluent-reader
        nexusmods-app
        nh
        ;
      inherit
        (pkgs.jqp)
        undertaker141
        mpv-history-launcher
        ;
      inherit
        (pkgs.nur.repos.nltch)
        spotify-adblock
        ;
    };
    qbittorrent.enable = true;
    vscode.enable = true;
    zathura.enable = true;
  };
}
