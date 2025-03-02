{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.bat;
in {
  options.my.home.bat = with lib; {
    enable = my.mkDisableOption "bat configuration";
    useTheme = my.mkDisableOption "bat theme configuration";
  };

  programs.bat = lib.mkIf cfg.enable {
    enable = true;
    config.theme = lib.optional cfg.useTheme "Catppuccin-Macchiato";
  };

  xdg.configFile = lib.mkIf cfg.useTheme {
    "bat/themes/catppuccin-macchiato.tmTheme".source = ./catppuccin-macchiato.tmTheme;
  };
}
