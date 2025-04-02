{
  self,
  inputs,
  lib,
  ...
}: let
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
    }
    {
      imports = [
        # Old Configurations

        ## Commandline
        ../home-manager/modules/misc/android.nix
        ../home-manager/modules/misc/command-line.nix
        ../home-manager/modules/misc/virtualisation.nix
        ../home-manager/modules/misc/yazi.nix

        ../home-manager/modules/playerctl.nix

        ../home-manager/modules/syncthing.nix
        ../home-manager/modules/wezterm.nix
        ../home-manager/modules/yazi.nix

        ../home-manager/modules/zellij.nix
        ../home-manager/modules/zoxide.nix

        # Extras
        ../home-manager/modules/misc/gnome-extras.nix

        # File Management
        ../home-manager/modules/misc/file-management.nix

        # Themes
        ../home-manager/modules/cursor.nix
        ../home-manager/modules/misc/themes.nix
      ];
    }
  ];

  mkHome = name: system:
    inputs.home-manager.lib.homeManagerConfiguration {
      # Work-around for home-manager
      # * not letting me set `lib` as an extraSpecialArgs
      # * not respecting `nixpkgs.overlays` [1]
      # [1]: https://github.com/nix-community/home-manager/issues/2954
      pkgs = import inputs.nixpkgs {
        inherit system;

        overlays =
          (lib.attrValues self.overlays)
          ++ [
            inputs.nur.overlays.default
          ];
      };

      modules =
        defaultModules
        ++ [
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
    "jq@desktop" = "x86_64-linux";
    "wilton@raket" = "x86_64-linux";
    "github-actions@generic" = "x86_64-linux";
  };
in {
  perSystem = {system, ...}: {
    # Work-around for https://github.com/nix-community/home-manager/issues/3075
    legacyPackages.homeConfigurations = let
      filteredHomes = lib.filterAttrs (_: hostSystem:
        hostSystem == system)
      homes;

      allHomes =
        filteredHomes
        // {
          # Default configuration
          "jq" = system;
        };
    in
      lib.mapAttrs mkHome allHomes;
  };
}
