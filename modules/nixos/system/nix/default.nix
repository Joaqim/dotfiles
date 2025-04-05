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
  selfHostedAddress = "http://desktop:5000";
  selfHostedPublicKey = "cache.desktop.org-1:q7OuFth/hRz1k/+PK3Uh3SByMWB3Xh8zDAUXF1pRv4Q=";
in {
  options.my.system.nix = with lib; {
    enable = my.mkDisableOption "nix configuration";

    gc = {
      enable = my.mkDisableOption "nix GC configuration";
    };

    cache = {
      selfHosted = mkEnableOption "self-hosted cache";
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
          auto-optimise-store = true;
          always-allow-substitutes = true;

          extra-substituters = [
            "https://cache.flakehub.com"
          ];
          extra-trusted-public-keys = [
            "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
            "cache.flakehub.com-4:Asi8qIv291s0aYLyH6IOnr5Kf6+OF14WVjkE6t3xMio="
            "cache.flakehub.com-5:zB96CRlL7tiPtzA9/WKyPkp3A2vqxqgdgyTVNGShPDU="
            "cache.flakehub.com-6:W4EGFwAGgBj3he7c5fNh9NkOXw0PUVaxygCVKeuvaqU="
            "cache.flakehub.com-7:mvxJ2DZVHn/kRxlIaxYNMuDG1OvMckZu32um1TadOR8="
            "cache.flakehub.com-8:moO+OVS0mnTjBTcOUh2kYLQEd59ExzyoW1QgQ8XAARQ="
            "cache.flakehub.com-9:wChaSeTI6TeCuV/Sg2513ZIM9i0qJaYsF+lZCXg0J6o="
            "cache.flakehub.com-10:2GqeNlIp6AKp4EF2MVbE1kBOp9iBSyo0UPR9KoR0o1Y="
          ];
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
            selfHostedAddress
          ];

          trusted-public-keys = [
            selfHostedPublicKey
          ];
        };
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
