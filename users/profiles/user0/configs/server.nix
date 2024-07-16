{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.commandLine
    self.homeModules.extras
    self.homeModules.internet
    self.homeModules.productionCode
  ];
}
