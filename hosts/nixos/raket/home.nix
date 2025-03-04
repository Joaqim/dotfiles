{pkgs, ...}: {
  my.home = {
    boilr.enable = false;
    calibre.enable = false;
    discord.enable = true;
    firefox.enable = true;
    flameshot.enable = false;
    gaming.enable = true;
    kde.enable = true;
    terminal.program = "kitty";
    mpv.enable = false;
    nm-applet.enable = true;
    nushell.enable = true;
    packages.additionalPackages = builtins.attrValues {
      inherit
        (pkgs.nur.repos.nltch)
        spotify-adblock
        ;
    };
    qbittorrent.enable = false;
    starship.enable = false;
    vscode.enable = false;
    zathura.enable = false;
  };
}
