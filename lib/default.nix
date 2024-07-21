{
  config,
  inputs,
  self,
  ...
}: {
  flake.lib = {
    mkHome = modules: system:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
        };
        inherit modules;
      };
    mkLinuxSystem = modules:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          flake = {
            inherit config inputs self;
          };
        };
        inherit modules;
      };
  };
}
