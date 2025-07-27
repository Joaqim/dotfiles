{ pkgs, ... }:
{
  imports = [ ../jq ];

  my.home = {
    boilr.enable = true;
    calibre.enable = true;
    discord.enable = true;
    documentation.enable = true;
    firefox.enable = true;
    flameshot.enable = true;
    gaming.enable = true;
    gtk.enable = true;
    kde.enable = true;
    terminal.program = "kitty";
    mpv.enable = true;
    nm-applet.enable = true;
    nushell.enable = true;
    packages.additionalPackages = builtins.attrValues {
      inherit (pkgs)
        fluent-reader
        headsetcontrol
        jellyfin-mpv-shim
        nh
        ;
      inherit (pkgs.jqpkgs)
        mpv-history-launcher
        ;
      inherit (pkgs.nur.repos.nltch)
        spotify-adblock
        ;
    };
    qbittorrent.enable = true;
    starship.enable = true;
    vscode.enable = true;
    yt-dlp.enable = true;
    zathura.enable = true;
    zoxide.enable = true;
  };
}
