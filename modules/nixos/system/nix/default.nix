# Nix related settings
{
  config,
  inputs,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.my.system.nix;

  channels = lib.my.merge [
    {
      inherit
        (inputs)
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
in {
  options.my.system.nix = with lib; {
    enable = my.mkDisableOption "nix configuration";

    gc = {
      enable = my.mkDisableOption "nix GC configuration";
    };

    cache = {
      selfHosted = mkEnableOption "self-hosted cache";
      nixGaming = my.mkDisableOption "nix-gaming cache";
    };

    inputs = {
      link = my.mkDisableOption "link inputs to `/etc/nix/inputs/`";

      addToRegistry = my.mkDisableOption "add inputs and self to registry";

      addToNixPath = my.mkDisableOption "add inputs and self to nix path";

      overrideNixpkgs = my.mkDisableOption "point nixpkgs to pinned system version";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.inputs.addToNixPath -> cfg.inputs.link;
          message = ''
            enabling `my.system.nix.inputs.addToNixPath` needs to have
            `my.system.nix.inputs.link = true`
          '';
        }
      ];
    }

    {
      nix = {
        package = pkgs.nix;

        settings = {
          experimental-features = ["nix-command" "flakes"];
          # Trusted users are equivalent to root, and might as well allow wheel
          trusted-users = ["root" "@wheel"];
        };
      };
    }

    {
      nixpkgs = {
        config = {
          allowUnfree = true;
          allowUnfreePredicate = pkg:
            builtins.elem (lib.getName pkg) [
              # Misc
              "unrar"
              # Visual Studio code
              "vscode"
              "codeium"
              # Jellyfin
              "soulseekqt"
            ];
          permittedInsecurePackages = [
            "electron"
          ];
        };
      };
    }

    {programs.nix-ld.enable = true;}

    (lib.mkIf cfg.gc.enable {
      nix.gc = {
        automatic = true;

        # Every week, with some wiggle room
        dates = "weekly";
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
          # The NixOS module adds the official Hydra cache by default
          # No need to use `extra-*` options.
          substituters = [
            # TODO:
          ];

          trusted-public-keys = [
            # TODO:
          ];
        };
      };
    })

    (lib.mkIf cfg.cache.nixGaming {
      nix.settings = {
        substituters = ["https://nix-gaming.cachix.org"];
        trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
      };
    })

    (lib.mkIf cfg.inputs.addToRegistry {
      nix.registry = let
        makeEntry = v: {flake = v;};
        makeEntries = lib.mapAttrs (lib.const makeEntry);
      in
        makeEntries channels;
    })

    (lib.mkIf cfg.inputs.link {
      environment.etc = let
        makeLink = n: v: {
          name = "nix/inputs/${n}";
          value = {source = v.outPath;};
        };
        makeLinks = lib.mapAttrs' makeLink;
      in
        makeLinks channels;
    })

    (lib.mkIf cfg.inputs.addToNixPath {
      nix.nixPath =
        [
          "/etc/nix/inputs"
        ]
        ++ options.nix.nixPath.default;
    })
  ]);
}
