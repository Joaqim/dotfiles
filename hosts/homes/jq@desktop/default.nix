{pkgs, ...}: {
  imports = [../jq];

  my.home = {
    boilr.enable = true;
    calibre.enable = true;
    discord.enable = true;
    firefox.enable = true;
    flameshot.enable = true;
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
    starship.enable = true;
    vscode.enable = true;
    zathura.enable = true;
  };
}
