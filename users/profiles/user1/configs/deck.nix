{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.homeModules.internet
    self.homeModules.misc-gaming
    self.homeModules.themes
  ];
}
