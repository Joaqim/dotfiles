{ lib, ... }:
{
  imports = [
    ./development.nix
    ./system.nix
  ];

  home = rec {
    file."./justfile".source = lib.mkDefault ./justfile;
    username = "jq";
    homeDirectory = "/home/${username}";
  };
}
