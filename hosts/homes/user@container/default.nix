{ ... }:
{
  imports = [
    ./development.nix
    ./shell.nix
    ./system.nix
  ];

  home = rec {
    username = "user";
    homeDirectory = "/home/${username}";
  };

  targets.genericLinux.enable = true;
}
