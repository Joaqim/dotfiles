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
      discord.enable = true;
      firefox.enable = true;
      obs-studio.enable = false;
    };

    desktop = {
      gtk.enable = true;
      kde.enable = true;
    };

    development = {
      nix.cache.extraSubstituters = false;
      nvf = {
        enable = true;
        claudeCode.command = "i"; # Use our AI Agent Iris
      };
      vscode.enable = true;
    };

    media = {
      mpv.enable = true;
      yt-dlp.enable = true;
      zathura.enable = true;
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
          nh
          lm_sensors
          wl-clipboard
          ;
      };
      secrets.enable = true;
    };
  };
}
