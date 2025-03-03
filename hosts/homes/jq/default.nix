{lib, ...}: {
  home.file = {
    "./justfile".source = lib.mkDefault ./justfile;
  };

  my = {
    home = {
      calibre.enable = true;
      discord.enable = true;
      firefox.enable = true;
      flameshot.enable = true;
      git = {
        enable = true;
        userName = "Joaqim Planstedt";
        userEmail = "mail@joaqim.xyz";
      };
      mpv.enable = true;
      nm-applet.enable = true;
      zathura.enable = true;
    };
  };
}
