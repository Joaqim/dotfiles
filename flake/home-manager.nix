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
        #../home-manager/modules/calibre.nix
        ## Commandline
        #../home-manager/modules/atuin.nix
        #../home-manager/modules/bat
        #../home-manager/modules/bottom.nix
        #../home-manager/modules/calibre.nix

        ../home-manager/modules/games/cataclysm-dda.nix
        #../home-manager/modules/gpg.nix
        #../home-manager/modules/git.nix
        #../home-manager/modules/home-manager.nix
        ../home-manager/modules/kitty.nix
        ../home-manager/modules/lazygit.nix
        ../home-manager/modules/misc/android.nix
        ../home-manager/modules/misc/command-line.nix
        ../home-manager/modules/misc/virtualisation.nix
        ../home-manager/modules/misc/yazi.nix
        ../home-manager/modules/nushell.nix
        ../home-manager/modules/playerctl.nix
        ../home-manager/modules/pulse.nix
        ../home-manager/modules/starship.nix
        ../home-manager/modules/syncthing.nix
        ../home-manager/modules/wezterm.nix
        ../home-manager/modules/yazi.nix
        ../home-manager/modules/zathura.nix
        ../home-manager/modules/zellij.nix
        ../home-manager/modules/zoxide.nix

        # Entertainment
        ../home-manager/modules/misc/gaming.nix
        ../home-manager/modules/misc/media.nix
        #../home-manager/modules/mpv.nix

        # Extras
        ../home-manager/modules/misc/gnome-extras.nix
        ../home-manager/modules/misc/kde-extras.nix

        # File Management
        ../home-manager/modules/misc/file-management.nix

        # Firefox
        ../home-manager/modules/firefox

        # Internet
        ../home-manager/modules/misc/internet.nix
        ../home-manager/modules/network.nix
        ../home-manager/modules/misc/jellyfin.nix
        ../home-manager/modules/qbittorrent

        # Code
        #../home-manager/modules/direnv.nix
        ../home-manager/modules/misc/production-code.nix
        ../home-manager/modules/vscode.nix

        # Art
        ../home-manager/modules/misc/production-art.nix

        # Themes
        ../home-manager/modules/cursor.nix
        ../home-manager/modules/gtk.nix
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

  homes = {
    /*
    "jq@desktop" = "x86_64-linux";
    "jq@deck" = "x86_64-linux";
    "deck@deck" = "x86_64-linux";
    */
  };
in {
  perSystem = {system, ...}: {
    # Work-around for https://github.com/nix-community/home-manager/issues/3075
    legacyPackages.homeConfigurations = let
      filteredHomes = lib.filterAttrs (_: v: v == system) homes;
      allHomes =
        filteredHomes
        // {
          # Default configuration
          jq = system;
        };
    in
      lib.mapAttrs mkHome allHomes;
  };
}
