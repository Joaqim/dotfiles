{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.hardware.graphics;
in {
  options.my.hardware.graphics = with lib; {
    enable = mkEnableOption "graphics configuration";

    gpuFlavor = mkOption {
      type = with types; nullOr (enum ["amd" "intel" "nvidia"]);
      default = null;
      example = "intel";
      description = "Which kind of GPU to install driver for";
    };

    amd = {
      enableKernelModule = mkEnableOption "Kernel driver module";

      amdvlk = lib.mkEnableOption "Use AMDVLK instead of Mesa RADV driver";
    };

    intel = {
      enableKernelModule = mkEnableOption "Kernel driver module";
    };

    nvidia = {
      enableKernelModule = mkEnableOption "Kernel driver module";
      # TODO: This might not be correct: https://nixos.wiki/wiki/Nvidia
      package = mkPackageOption pkgs.nvidiaPackages "nvidia" {
        default = "stable";
      };
    };

    coreCtrl = {
      enable = mkEnableOption "Enable corectrl";
      gpuOverclock = mkEnableOption "Enable GPU overclocking";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      hardware.graphics = {
        enable = true;
      };
    }

    # AMD GPU
    (lib.mkIf (cfg.gpuFlavor == "amd") {
      hardware.amdgpu = {
        initrd.enable = cfg.amd.enableKernelModule;
        # Vulkan
        amdvlk = lib.mkIf cfg.amd.amdvlk {
          enable = true;
          support32Bit = {
            enable = true;
          };
        };
      };

      hardware.graphics = {
        extraPackages = with pkgs; [
          # OpenCL
          rocmPackages.clr
          rocmPackages.clr.icd
        ];
        extraPackages32 = lib.mkIf cfg.amd.amdvlk [
          pkgs.driversi686Linux.amdvlk
        ];
      };
    })

    # Core Ctrl can be used for both CPU & GPU
    # TODO: Move to my.programs.corectrl
    (lib.mkIf cfg.coreCtrl.enable {
      programs.corectrl = {
        enable = true;
        gpuOverclock = lib.mkIf cfg.coreCtrl.gpuOverclock {
          enable = true;
          # TODO: Is this only for amd?
          ppfeaturemask = lib.optionalString (cfg.gpuFlavor == "amd") "0xffffffff";
        };
      };
      # Allows running corectrl as group @wheel
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
            if ((action.id == "org.corectrl.helper.init" ||
                action.id == "org.corectrl.helperkiller.init") &&
                subject.local == true &&
                subject.active == true &&
                subject.isInGroup("wheel")) {
                    return polkit.Result.YES;
            }
        });
      '';
      # Start corectrl at startup
      environment.systemPackages = [
        (pkgs.makeAutostartItem rec {
          name = "corectrl";
          package = pkgs.makeDesktopItem {
            inherit name;
            desktopName = "CoreCtrl";
            exec = "corectrl --minimize-systray";
            icon = "corectrl";
          };
        })
      ];
    })

    # Intel GPU
    (lib.mkIf (cfg.gpuFlavor == "intel") {
      boot.initrd.kernelModules = lib.mkIf cfg.intel.enableKernelModule ["i915"];

      environment.variables = {
        VDPAU_DRIVER = "va_gl";
      };

      hardware.graphics = {
        extraPackages = with pkgs; [
          # Open CL
          intel-compute-runtime

          # VA API
          intel-media-driver
          intel-vaapi-driver
          libvdpau-va-gl
        ];

        extraPackages32 = with pkgs.driversi686Linux; [
          # VA API
          intel-media-driver
          intel-vaapi-driver
          libvdpau-va-gl
        ];
      };
    })

    # Nvidia GPU
    (lib.mkIf (cfg.gpuFlavor == "nvidia") {
      hardware.nvidia = {
        inherit (cfg.nvidia) package;

        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = false;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer).
        powerManagement.finegrained = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        open = false;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;
      };
    })
  ]);
}
