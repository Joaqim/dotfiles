{
  programs.bat = {
    enable = true;
    config.theme = "catppuccin-macchiato";
  };
  xdg.configFile."bat/themes/catppuccin-mocha.tmTheme".source = ./catppuccin-macchiato.tmTheme;
}
