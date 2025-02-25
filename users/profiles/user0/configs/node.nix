{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.commandLine
    self.homeModules.internet
    self.homeModules.minecraft-server-toggle
    self.homeModules.misc-gaming
    self.homeModules.themes
    self.homeModules.syncthing
  ];
}
