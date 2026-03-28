{ ... }:
{
  imports = [
    ./development.nix
    ./system.nix
  ];

  home = rec {
    username = "runner";
    homeDirectory = "/home/${username}";
  };

  targets.genericLinux.enable = true;
}
