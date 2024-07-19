{pkgs, ...}: {
  programs.regreet = {
    enable = true;
    package = pkgs.greetd.regreet;
    settings = {
      GTK = {
        application_prefer_dark_theme = true;
        font_name = "Open Sans 10";
        cursor_theme_name = "Catppuccin-Macchiato-Dark-Cursors";
        icon_theme_name = "Papirus-Dark";
        theme_name = "catppuccin-macchiato-mauve-standard";
      };
    };
  };
}
