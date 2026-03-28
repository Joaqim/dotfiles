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
    username = "deck";
    homeDirectory = "/home/${username}";
  };
}
