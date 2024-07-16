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
