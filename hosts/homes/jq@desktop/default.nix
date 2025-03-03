{lib, ...}: {
  home.file = {
    "./justfile".source = lib.mkDefault ./justfile;
  };

  my.home = {
    mpv.enable = true;
  };
}
