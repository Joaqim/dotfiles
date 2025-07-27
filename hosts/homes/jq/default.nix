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
    packages.additionalPackages = [
      pkgs.just
    ];
    git = {
      enable = true;
      userName = "Joaqim Planstedt";
      userEmail = "mail@joaqim.xyz";
    };
  };
}
