{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.commandLine
    self.homeModules.entertainment
    self.homeModules.extras
    self.homeModules.fileManagement
    self.homeModules.firefoxHM
    self.homeModules.gpg
    self.homeModules.internet
    self.homeModules.jellyfin
    self.homeModules.privacy
    self.homeModules.productionArt
    self.homeModules.productionAudio
    self.homeModules.productionCode
    self.homeModules.productionVideo
    self.homeModules.productionWriting
    self.homeModules.themes
  ];
}
