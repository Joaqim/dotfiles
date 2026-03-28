{ inputs, ... }:
{
  imports = [
    ../jq
    inputs.jqpkgs.homeModules.default
    ./applications.nix
    ./desktop.nix
    ./development.nix
    ./media.nix
    ./shell.nix
    ./system.nix
  ];

  jqpkgs.cache.enable = true;
}
