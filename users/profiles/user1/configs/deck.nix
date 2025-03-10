{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.commandLine
    self.homeModules.fileManagement
    self.homeModules.firefoxHM
    self.homeModules.internet
    self.homeModules.misc-gaming
    self.homeModules.syncthing
    self.homeModules.themes
    ({pkgs, ...}: {
      home.packages = builtins.attrValues {
        inherit (pkgs) boilr cemu;
      };
    })
  ];
}
