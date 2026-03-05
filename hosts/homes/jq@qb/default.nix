{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ../jq
    inputs.jqpkgs.homeModules.default
  ];

  jqpkgs.cache.enable = true;

  my.home = {
    discord.enable = true;
    documentation.enable = true;
    firefox.enable = true;
    flameshot.enable = true;
    gtk.enable = true;
    kde.enable = true;
    terminal.program = "kitty";
    mpv.enable = true;
    nushell.enable = true;
    obs-studio.enable = false;
    packages.additionalPackages = builtins.attrValues {
      inherit (pkgs)
        nh
        lm_sensors
        wl-clipboard
        ;
    };
    starship.enable = true;
    vscode.enable = true;
    yt-dlp.enable = true;
    zathura.enable = true;
    zoxide.enable = true;
  };
}
