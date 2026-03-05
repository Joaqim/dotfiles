{
  self,
  inputs,
  lib,
  ...
}:
let
  defaultModules = [
    # Include generic settings
    "${self}/modules/home"
    {
      # Basic user information defaults
      home.username = lib.mkDefault "jq";
      home.homeDirectory = lib.mkDefault "/home/jq";

      # Make it a Linux installation by default
      targets.genericLinux.enable = lib.mkDefault true;

      # Enable home-manager
      programs.home-manager.enable = true;

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";
    }
  ];

  mkHome =
    name: system:
    inputs.home-manager.lib.homeManagerConfiguration {
      # Work-around for home-manager
      # * not letting me set `lib` as an extraSpecialArgs
      # * not respecting `nixpkgs.overlays` [1]
      # [1]: https://github.com/nix-community/home-manager/issues/2954
      pkgs = import inputs.nixpkgs {
        inherit system;

        overlays = (lib.attrValues self.overlays) ++ [
          inputs.nur.overlays.default
        ];
      };

      modules = defaultModules ++ [
        "${self}/hosts/homes/${name}"
      ];

      extraSpecialArgs = {
        # Inject inputs to use them in global registry
        inherit inputs;
      };
    };

  # Specify your Home Manager profiles by compatible system.
  # Home Manager will by default match first `$USER@$(hostname)`.
  # If not found, it will then default to `$USER`.
  homes = {
    "deck@deck" = "x86_64-linux";
    "github-actions@generic" = "x86_64-linux";
    "jq@desktop" = "x86_64-linux";
    "jq@generic" = "x86_64-linux";
    "jq@qb" = "x86_64-linux";
    "user@container" = "x86_64-linux";
    "wilton@raket" = "x86_64-linux";
  };
in
{
  perSystem =
    { system, ... }:
    {
      # Work-around for https://github.com/nix-community/home-manager/issues/3075
      legacyPackages.homeConfigurations =
        let
          filteredHomes = lib.filterAttrs (_: hostSystem: hostSystem == system) homes;

          allHomes = filteredHomes // {
            # Default configuration
            "jq" = system;
          };
        in
        lib.mapAttrs mkHome allHomes;
    };
}
