{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.calibre
    self.homeModules.cataclysm-dda
    self.homeModules.commandLine
    #self.homeModules.desktopGames
    #self.homeModules.entertainment
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
    self.homeModules.syncthing
    self.homeModules.themes
  ];

  # Misc Packages
  home.packages = builtins.attrValues {
    inherit (flake.inputs.self.packages."x86_64-linux") undertaker141 mpv-history-launcher;
  };
}
