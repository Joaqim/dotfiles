{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.commandLine
  ];
}
