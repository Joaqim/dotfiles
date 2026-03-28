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
    applications = {
      calibre.enable = true;
      discord.enable = true;
      firefox.enable = true;
      obs-studio.enable = true;
      qbittorrent.enable = true;
    };

    desktop = {
      gtk.enable = true;
      kde.enable = true;
    };

    development = {
      nix.cache.extraSubstituters = false;
      nvf = {
        enable = true;
        # TODO: This does'n seem to work
        claudeCode.command = "i"; # Use our AI Agent Iris
      };
      vscode.enable = true;
    };

    gaming = {
      boilr.enable = true;
      bundle.enable = true;
    };

    media = {
      mpv.enable = true;
      yt-dlp.enable = true;
      zathura.enable = true;
    };

    services = {
      vira.enable = true;
    };

    shell = {
      nushell.enable = true;
      starship.enable = true;
      terminal.program = "kitty";
      zoxide.enable = true;
    };

    system = {
      documentation.enable = true;
      packages.additionalPackages = builtins.attrValues {
        inherit (pkgs)
          fluent-reader
          headsetcontrol
          jellyfin-mpv-shim
          nh
          rqbit
          cataclysm-dda
          lm_sensors
          wl-clipboard
          cavasik # Simple audio visualizer
          ;
        inherit (pkgs.my)
          mpv-history-launcher
          ;
      };
    };

    utilities = {
      nm-applet.enable = false;
    };
  };
}
