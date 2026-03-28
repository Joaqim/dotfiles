{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.development.cursor;
in
{
  options.my.home.development.cursor = with lib; {
    enable = my.mkDisableOption "enable themed cursor";
  };
  config = lib.mkIf cfg.enable {
    home.pointerCursor = {
      name = "catppuccin-macchiato-dark-cursors";
      package = pkgs.catppuccin-cursors.macchiatoDark;
    };
  };
}
