{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
        color_scheme = "Catppuccin Macchiato",
        font_size = 10,
        enable_tab_bar = false,
        window_close_confirmation = 'NeverPrompt',
        term = 'wezterm',
        enable_wayland = true,
      }
    '';
  };
}
