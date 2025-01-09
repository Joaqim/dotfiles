{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.inputs.sops-nix.homeManagerModules.sops
    self.homeModules.calibre
    self.homeModules.cataclysm-dda
    self.homeModules.commandLine
    self.homeModules.desktopGames
    self.homeModules.entertainment
    self.homeModules.extras
    self.homeModules.fileManagement
    self.homeModules.firefoxHM
    self.homeModules.gpg
    self.homeModules.internet
    self.homeModules.jellyfin
    self.homeModules.productionArt
    self.homeModules.productionCode
    self.homeModules.productionVideo
    self.homeModules.productionWriting
    self.homeModules.sops
    self.homeModules.syncthing
    self.homeModules.themes
  ];
}
