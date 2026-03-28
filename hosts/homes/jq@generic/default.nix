{
  home = rec {
    username = "jq";
    homeDirectory = "/home/${username}";
  };

  my.home.development.git = {
    enable = true;
    userName = "Joaqim Planstedt";
    userEmail = "mail@joaqim.xyz";
  };
}
