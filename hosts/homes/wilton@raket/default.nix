{ ... }:
{
  imports = [
    ./development.nix
    ./gaming.nix
    ./shell.nix
    ./system.nix
    ./utilities.nix
  ];

  home = rec {
    username = "wilton";
    homeDirectory = "/home/${username}";
  };
}
