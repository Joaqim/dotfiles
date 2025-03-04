{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.terminal;
in {
  config = lib.mkIf (cfg.program == "alacritty") {
    programs.alacritty = {
      enable = true;

      settings = {
        font = {
          size = 5.5;
        };

        colors = {
          primary = {
            inherit (cfg.colors) background;
            inherit (cfg.colors) foreground;

            bright_foreground = cfg.colors.foregroundBold;
          };

          cursor = {
            inherit (cfg.colors) cursor;
          };

          normal = {
            inherit (cfg.colors) black;
            inherit (cfg.colors) red;
            inherit (cfg.colors) green;
            inherit (cfg.colors) yellow;
            inherit (cfg.colors) blue;
            inherit (cfg.colors) magenta;
            inherit (cfg.colors) cyan;
            inherit (cfg.colors) white;
          };

          bright = {
            black = cfg.colors.blackBold;
            red = cfg.colors.redBold;
            green = cfg.colors.greenBold;
            yellow = cfg.colors.yellowBold;
            blue = cfg.colors.blueBold;
            magenta = cfg.colors.magentaBold;
            cyan = cfg.colors.cyanBold;
            white = cfg.colors.whiteBold;
          };
        };
      };
    };
  };
}
