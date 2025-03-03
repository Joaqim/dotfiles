{
  config,
  self,
  inputs,
  lib,
  ...
}: let
  defaultModules = [
    {
      # Let 'nixos-version --json' know about the Git revision
      system.configurationRevision = self.rev or "dirty";
    }
    {
      nixpkgs.overlays =
        (lib.attrValues self.overlays)
        ++ [
          inputs.nur.overlays.default
        ];
    }
    # Include generic settings
    "${self}/modules/nixos"
  ];

  buildHost = name: system:
    lib.nixosSystem {
      inherit system;
      modules =
        defaultModules
        ++ [
          #"${self}/hosts/nixos/${name}"

          ( # TODO: Remove self, inputs
            import "${self}/hosts/nixos/${name}"
            {
              inherit lib self inputs;
            }
          )
          #"${self}/systems/${name}"
        ];
      specialArgs = {
        # Use my extended lib in NixOS configuration
        inherit (self) lib;
        # Inject inputs to use them in global registry
        inherit inputs;

        flake = {
          inherit config inputs self;
        };
      };
    };
in {
  flake.nixosConfigurations = lib.mapAttrs buildHost {
    desktop = "x86_64-linux";
  };
}
