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

  # For Claudo Code AI configuration
  home.sessionVariables = {
    ANTHROPIC_BASE_URL = "http://desktop:11434";
    ANTHROPIC_AUTH_TOKEN = "ollama";
    ANTHROPIC_MODEL = "qwen2.5-coder:latest";
  };
  my.home = {
    boilr.enable = true;
    calibre.enable = true;
    claude-code = {
      enable = true;
      autoWireDirs = with inputs; [
        AI-opencode-backend-skill
        AI-opencode-frontend-skill
      ];
    };
    discord.enable = true;
    documentation.enable = true;
    firefox.enable = true;
    gaming.enable = true;
    gtk.enable = true;
    kde.enable = true;
    terminal.program = "kitty";
    mpv.enable = true;
    nm-applet.enable = false;
    nushell.enable = true;
    nvf.enable = true;
    obs-studio.enable = true;
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
    qbittorrent.enable = true;
    starship.enable = true;
    vira.enable = true;
    vscode.enable = true;
    yt-dlp.enable = true;
    zathura.enable = true;
    zoxide.enable = true;
  };
}
