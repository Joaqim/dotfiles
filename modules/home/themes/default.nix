{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.theme;
in {
  options.my.home.theme = with lib; {
    enable = my.mkDisableOption "enable theme";
  };
  config = lib.mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        catppuccin-gtk
        catppuccin
        ;
    };
  };
}
