{
  flake-parts,
  systems,
  ...
} @ inputs: let
  mySystems = import systems;
in
  flake-parts.lib.mkFlake {inherit inputs;} {
    systems = mySystems;

    imports = [
      inputs.home-manager.flakeModules.home-manager
      ./apps.nix
      ./dev-shells.nix
      ./home-manager.nix
      ./lib.nix
      ./nixos.nix
      ./overlays.nix
      ./packages.nix
      ./pre-commit.nix
    ];
  }
