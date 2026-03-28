{
  lib,
  self,
  ...
}:
{
  perSystem =
    { system, ... }:
    let
      machinesPerSystem = {
        x86_64-linux = [
          "container"
          "deck"
          "desktop"
          "generic"
          "raket"
          "qb"
        ];
      };
      nixosMachines = lib.mapAttrs' (n: lib.nameValuePair "nixos-${n}") (
        lib.genAttrs (machinesPerSystem.${system} or [ ]) (
          name: self.nixosConfigurations.${name}.config.system.build.toplevel
        )
      );
      blacklistPackages = [ ];
      packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") (
        lib.filterAttrs (n: _v: !(builtins.elem n blacklistPackages)) self.packages."${system}"
      );
      devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self.devShells."${system}";
      blacklistHomeConfigurations = [
        "wilton@raket" # spotify-adblock missing xorg dependency
      ];
      homeConfigurations =
        lib.mapAttrs' (name: config: lib.nameValuePair "home-manager-${name}" config.activation-script)
          (
            lib.filterAttrs (n: _v: !(builtins.elem n blacklistHomeConfigurations)) (
              self.legacyPackages."${system}".homeConfigurations or { }
            )
          );
    in
    {
      checks = nixosMachines // packages // devShells // homeConfigurations;
    };
}
