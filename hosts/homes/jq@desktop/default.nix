{ inputs, ... }:
{
  imports = [
    ../jq
    inputs.jqpkgs.homeModules.default
    ./applications.nix
    ./desktop.nix
    ./development.nix
    ./gaming.nix
    ./media.nix
    ./services.nix
    ./shell.nix
    ./system.nix
    ./utilities.nix
  ];

  jqpkgs.cache.enable = true;
}
