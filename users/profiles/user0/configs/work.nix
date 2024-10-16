{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.commandLine
    self.homeModules.extras
    self.homeModules.fileManagement
    self.homeModules.firefoxHM
    self.homeModules.gpg
    self.homeModules.internet
    self.homeModules.mpv
    self.homeModules.productionCode
    self.homeModules.productionWriting
    self.homeModules.syncthing
    self.homeModules.themes
  ];
}
