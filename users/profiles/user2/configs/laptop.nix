{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.commandLine
    self.homeModules.entertainment
    self.homeModules.extras
    self.homeModules.firefoxNix
    self.homeModules.internet
    self.homeModules.productionCode
    self.homeModules.productionWriting
    self.homeModules.themes
  ];
}
