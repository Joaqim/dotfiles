{
  description = "My NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/x86_64-linux";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deadnix.url = "github:astro/deadnix";

    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";

    nix-gaming.url = "github:fufexan/nix-gaming";

    json2steamshortcut.url = "github:ChrisOboe/json2steamshortcut";
    jellyfin-plugins.url = "github:Joaqim/jellyfin-plugins-nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.pre-commit-hooks-nix.flakeModule
        ./home-manager
        ./lib
        ./nixos
        ./parts
        ./users
      ];

      flake = {config, ...}: {
        packages.x86_64-linux = import ./pkgs {
          inherit (inputs) self;
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          flake-inputs = inputs;
        };

        apps.x86_64-linux.commit-nvfetcher = {
          type = "app";
          program = toString (
            inputs.nixpkgs.legacyPackages.x86_64-linux.writeShellScript "commit-nvfetcher" ''
              ${inputs.self.packages.x86_64-linux.commit-nvfetcher}/bin/commit-nvfetcher -k /tmp/github-key.toml
            ''
          );
        };

        # NixOS home configuration setup lives in
        # ./home-manager/modules` as individual `homeModules`
        homeConfigurations = {};

        nixosConfigurations = {
          desktop = inputs.self.lib.mkLinuxSystem [
            ./systems/desktop
            ./users/profiles/user0
            inputs.disko.nixosModules.disko
            inputs.jellyfin-plugins.nixosModules.jellyfin-plugins
            config.nixosModules.shared
            config.nixosModules.desktop
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nur.modules.nixos.default
          ];
          work = inputs.self.lib.mkLinuxSystem [
            ./systems/work
            ./users/profiles/user0
            config.nixosModules.shared
            config.nixosModules.work
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.impermanence.nixosModules.impermanence
            inputs.nur.modules.nixos.default
          ];
          deck = inputs.self.lib.mkLinuxSystem [
            ./systems/deck
            ./users/profiles/user0
            ./users/profiles/user1
            config.nixosModules.deck
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.jovian.nixosModules.jovian
          ];
          node = inputs.self.lib.mkLinuxSystem [
            ./systems/node
            ./users/profiles/user0
            config.nixosModules.shared
            config.nixosModules.node
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.impermanence.nixosModules.impermanence
            inputs.nur.modules.nixos.default
          ];
          dell = inputs.self.lib.mkLinuxSystem [
            ./systems/dell
            ./users/profiles/user0
            config.nixosModules.dell
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
          ];
          thinkpad = inputs.self.lib.mkLinuxSystem [
            ./systems/thinkpad
            ./users/profiles/user0
            config.nixosModules.thinkpad
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
          ];
          server = inputs.self.lib.mkLinuxSystem [
            ./systems/server
            ./users/profiles/user0
            config.nixosModules.server
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nur.modules.nixos.default
          ];
        };
      };

      systems = import inputs.systems;
    };
}
