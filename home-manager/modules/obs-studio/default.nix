{
  programs = {
    obs-studio = {
      enable = true;
    };
  };
  xdg.configFile."obs-studio/themes".source = ./themes;
}
