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
    nur.url = "github:nix-community/NUR";
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/x86_64-linux";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    deadnix.url = "github:astro/deadnix";
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
          #inherit self;
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

        checks.x86_64-linux = import ./checks {
          inherit (inputs.nixpkgs) lib;
          pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
          flake-inputs = inputs;
        };

        devShells.x86_64-linux.default =
          let
            inherit (inputs.sops-nix.packages.x86_64-linux) sops-init-gpg-key sops-import-keys-hook;
            inherit (inputs.self.packages.x86_64-linux) commit-nvfetcher;
            inherit (inputs.nixpkgs.legacyPackages.x86_64-linux) nvchecker age alejandra just nil sops ssh-to-age;
            home-manager-bin = inputs.home-manager.packages.x86_64-linux.default;
          in
          inputs.nixpkgs.legacyPackages.x86_64-linux.mkShell {
            packages = [
              inputs.nvfetcher.packages.x86_64-linux.default
              nvchecker
              commit-nvfetcher
              home-manager-bin
              sops-init-gpg-key
              age
              alejandra
              just
              nil
              sops
              ssh-to-age
            ];

            sopsPGPKeyDirs = [
              "./keys/hosts/"
              "./keys/users/"
            ];
            nativeBuildInputs = [ sops-import-keys-hook ];
            shellHook = "${config.pre-commit.installationScript}";
          };

        nixosConfigurations = {
          desktop = inputs.self.lib.mkLinuxSystem [
            ./systems/desktop
            ./users/profiles/user0
            config.nixosModules.shared
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nur.nixosModules.nur
          ];
          laptop = inputs.self.lib.mkLinuxSystem [
            ./systems/laptop
            ./users/profiles/user0
            #./users/profiles/user1
            config.nixosModules.shared
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nur.nixosModules.nur
          ];
          server = inputs.self.lib.mkLinuxSystem [
            ./systems/server
            ./users/profiles/user0
            config.nixosModules.server
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nur.nixosModules.nur
          ];
          nas = inputs.self.lib.mkLinuxSystem [
            ./systems/nas
            ./users/profiles/user0
            config.nixosModules.nas
            inputs.sops-nix.nixosModules.sops
            inputs.home-manager.nixosModules.home-manager
            inputs.nur.nixosModules.nur
          ];
        };
      };

      systems = import inputs.systems;
    };
}
