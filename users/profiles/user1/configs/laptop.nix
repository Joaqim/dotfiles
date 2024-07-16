{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.commandLine
    self.homeModules.entertainment
    self.homeModules.extras
    self.homeModules.firefoxHM
    self.homeModules.internet
    self.homeModules.privacy
    self.homeModules.productionWriting
    self.homeModules.themes
  ];
}
