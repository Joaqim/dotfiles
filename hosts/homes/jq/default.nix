{lib, ...}: {
  home = rec {
    file."./justfile".source = lib.mkDefault ./justfile;
    username = "deck";
    homeDirectory = "/home/${username}";
  };

  my.home.git = {
    enable = true;
    userName = "Joaqim Planstedt";
    userEmail = "mail@joaqim.xyz";
  };
}
