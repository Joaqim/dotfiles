{
  description = "My NixOS Configurations";

  inputs = {
    AI-opencode-backend-skill = {
      url = "https://github.com/mayanklau/backend-skill";
      flake = false;
    };
    AI-opencode-frontend-skill = {
      url = "https://github.com/mayanklau/frontend-coding";
      flake = false;
    };
    ccc = {
      url = "github:Joaqim/ccc-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        systems.follows = "systems";
      };
    };
    steam-shortcuts = {
      url = "github:Joaqim/json2steamshortcut";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    deadnix.url = "github:astro/deadnix";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    erosanix = {
      url = "github:emmanuelrosa/erosanix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    github-nix-ci.url = "github:Joaqim/github-nix-ci";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    jellyfin-plugins.url = "github:Joaqim/jellyfin-plugins-nix";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    json2steamshortcut.url = "github:ChrisOboe/json2steamshortcut";
    jqpkgs = {
      url = "github:Joaqim/pkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-agent-wire.url = "github:srid/nix-agent-wire";
    nix-gaming.url = "github:fufexan/nix-gaming";
    timvim = {
      url = "github:timlinux/nix-vim";
      flake = false;
    };
    nvim-plugin-claude-code = {
      url = "github:coder/claudecode.nvim";
      flake = false;
    };
    nvim-plugin-octo = {
      url = "github:pwntester/octo.nvim";
      flake = false;
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";

      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };
    nvfetcher = {
      url = "github:berberman/nvfetcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks-nix = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    selfup = {
      url = "github:kachick/selfup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    systems.url = "github:nix-systems/default";
    ucodenix.url = "github:e-tho/ucodenix";
    vira.url = "github:juspay/vira";
  };
  outputs = inputs: import ./flake inputs;
}
