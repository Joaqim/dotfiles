# Nix related settings
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.home.nix;

  channels = lib.my.merge [
    {
      inherit (inputs)
        # Allow me to use my custom package using `nix run self#pkg`
        self
        # Add NUR to run some packages that are only present there
        nur
        ;
      # Use pinned nixpkgs when using `nix run pkgs#<whatever>`
      pkgs = inputs.nixpkgs;
    }
    (lib.optionalAttrs cfg.inputs.overrideNixpkgs {
      # ... And with `nix run nixpkgs#<whatever>`
      inherit (inputs) nixpkgs;
    })
  ];
  selfHostedAddress = "http://desktop:8189";
  selfHostedPublicKey = "cache.desktop.org-1:q7OuFth/hRz1k/+PK3Uh3SByMWB3Xh8zDAUXF1pRv4Q=";
in
{
  options.my.home.nix = with lib; {
    enable = my.mkDisableOption "nix configuration";

    gc = {
      enable = my.mkDisableOption "nix GC configuration";
    };

    cache = {
      selfHosted = mkEnableOption "self-hosted cache";
      nixGaming = mkEnableOption "nix-gaming cache";
      extraSubstituters = my.mkDisableOption "nix-community cache";
    };

    inputs = {
      link = my.mkDisableOption "link inputs to `$XDG_CONFIG_HOME/nix/inputs/`";

      addToRegistry = my.mkDisableOption "add inputs and self to registry";

      addToNixPath = my.mkDisableOption "add inputs and self to nix path";

      overrideNixpkgs = my.mkDisableOption "point nixpkgs to pinned system version when using `nix run nixpkgs#<whatever>`";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            assertion = cfg.inputs.addToNixPath -> cfg.inputs.link;
            message = ''
              enabling `my.home.nix.addToNixPath` needs to have
              `my.home.nix.linkInputs = true`
            '';
          }
        ];
      }

      {
        nix = {
          package = lib.mkDefault pkgs.nix; # NixOS module sets it unconditionally

          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
          };
        };
      }

      (lib.mkIf cfg.gc.enable {
        nix.gc = {
          automatic = true;

          # Every week, with some wiggle room
          frequency = "weekly";
          randomizedDelaySec = "10min";

          # Use a persistent timer for e.g: laptops
          persistent = true;

          # Delete old profiles automatically after 15 days
          options = "--delete-older-than 15d";
        };
      })

      (lib.mkIf cfg.cache.selfHosted {
        nix = {
          settings = {
            extra-substituters = [
              selfHostedAddress
            ];

            extra-trusted-public-keys = [
              selfHostedPublicKey
            ];
          };
        };
      })

      (lib.mkIf cfg.cache.extraSubstituters {
        nix = {
          settings = {
            extra-substituters = [
              "https://cache.nixos.org/"
              "https://nix-community.cachix.org"
              "https://nixpkgs-unfree.cachix.org"
              "https://numtide.cachix.org"
              "https://catppuccin.cachix.org"
              "https://cache.garnix.io"
            ];

            extra-trusted-public-keys = [
              "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
              "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
              "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
              "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
            ];
          };
        };
      })

      (lib.mkIf cfg.cache.nixGaming {
        nix.settings = {
          extra-substituters = [ "https://nix-gaming.cachix.org" ];
          extra-trusted-public-keys = [
            "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          ];
        };
      })

      (lib.mkIf cfg.inputs.addToRegistry {
        nix.registry =
          let
            makeEntry = v: { flake = v; };
            makeEntries = lib.mapAttrs (lib.const makeEntry);
          in
          makeEntries channels;
      })

      (lib.mkIf cfg.inputs.link {
        xdg.configFile =
          let
            makeLink = n: v: {
              name = "nix/inputs/${n}";
              value = {
                source = v.outPath;
              };
            };
            makeLinks = lib.mapAttrs' makeLink;
          in
          makeLinks channels;
      })

      (lib.mkIf cfg.inputs.addToNixPath {
        nix.nixPath = [ "${config.xdg.configHome}/nix/inputs" ];
      })
    ]
  );
}
