{flake, ...}: let
  inherit (flake) self;
in {
  imports = [
    self.inputs.sops-nix.homeManagerModules.sops
    self.homeModules.commandLine
    self.homeModules.internet
    self.homeModules.minecraft-server-toggle
    self.homeModules.misc-gaming
    self.homeModules.themes
    self.homeModules.syncthing
    self.homeModules.sops
  ];
}
