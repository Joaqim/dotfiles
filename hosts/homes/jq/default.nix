{lib, ...}: {
  home.file = {
    "./justfile".source = lib.mkDefault ./justfile;
  };

  my = {
    home = {
      mpv.enable = true;
      git = {
        enable = true;
        userName = "Joaqim Planstedt";
        userEmail = "mail@joaqim.xyz";
      };
    };
  };
}
