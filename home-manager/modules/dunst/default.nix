{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        allow_markup = true;
        font = "Open Sans 10";
        corner_radius = 28;
        fade_in_duration = 400;
        frame = 10000;
        frame_width = 2;
        icon_corner_radius = 7;
        monitor = 1;
        offset = "20x20";
        origin = "bottom-right";
        progress_bar_corner_radius = 7;
        timeout = 10;
        transparecncy = true;
        # Colours
        background = "#24273a";
        foreground = "#8b7daa";
        frame_color = "#b072d1";
        action = "/home/$USER/dotfiles/home-manager/modules/dunst/notifications.sh";
      };
      shortcuts = {
        context = "ctrl+shift+period";
        open = "super+o";
      };
    };
  };
}
