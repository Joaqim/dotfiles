{
  lib,
  pkgs,
  ...
}:
{
  home = rec {
    file."./justfile".source = lib.mkDefault ./justfile;
    username = "jq";
    homeDirectory = "/home/${username}";
  };

  my.home = {
    development.git = {
      enable = true;
      userName = "Joaqim Planstedt";
      userEmail = "mail@joaqim.xyz";
    };

    system.packages.additionalPackages = with pkgs; [
      just
    ];
  };
}
