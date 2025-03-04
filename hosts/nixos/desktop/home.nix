{pkgs, ...}: {
  my.home = {
    boilr.enable = false;
    calibre.enable = true;
    discord.enable = true;
    firefox.enable = true;
    flameshot.enable = false;
    gaming.enable = true;
    mpv.enable = true;
    nm-applet.enable = true;
    zathura.enable = true;
    packages.additionalPackages = builtins.attrValues {
      inherit
        (pkgs)
        calibre
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
  };
}
