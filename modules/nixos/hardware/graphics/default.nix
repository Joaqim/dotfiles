{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.hardware.graphics;
in
{
  options.my.hardware.graphics = with lib; {
    enable = mkEnableOption "graphics configuration";

    gpuFlavor = mkOption {
      type =
        with types;
        nullOr (enum [
          "amd"
          "intel"
          "nvidia"
        ]);
      default = null;
      example = "amd";
      description = "Which kind of GPU to install driver for";
    };

    amd = {
      enableKernelModule = my.mkDisableOption "Kernel driver module";

      amdvlk = lib.mkEnableOption "Use AMDVLK instead of Mesa RADV driver";

      overdrive = {
        enable = mkEnableOption "Overdrive";
        ppfeaturemask = mkOption {
          type = types.str;
          default = "0xffffffff";
          description = "Overdrive ppfeaturemask";
        };
      };
    };

    intel = {
      enableKernelModule = my.mkDisableOption "Kernel driver module";
    };

    nvidia = {
      # TODO: This might not be correct: https://nixos.wiki/wiki/Nvidia
      package = mkPackageOption pkgs.nvidiaPackages "nvidia" {
        default = "stable";
      };

      coolercontrol = my.mkDisableOption "Whether to enable CoolerControl GUI & its background services";
    };

    coreCtrl.enable = my.mkDisableOption "";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            # TODO: Should CoreCtrl be implicitly enabled when using `amd.overdrive`?
            assertion = cfg.amd.overdrive.enable -> cfg.coreCtrl.enable;
            message = ''
              You probably want to enable option `my.graphics.corectrl` when enabling `my.graphics.amd.overdrive` for overclocking AMD GPU.
            '';
          }
        ];
      }
      {
        hardware.graphics.enable = true;
      }

      # AMD GPU
      (lib.mkIf (cfg.gpuFlavor == "amd") {
        services.xserver.videoDrivers = [
          "amdgpu"
        ];

        hardware.amdgpu = {
          initrd.enable = cfg.amd.enableKernelModule;
          overdrive = {
            enable = lib.mkForce cfg.amd.overdrive.enable;
            inherit (cfg.amd.overdrive) ppfeaturemask;
          };
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
            libva
            libva-utils
            vdpauinfo
          ];
          extraPackages32 = lib.mkIf cfg.amd.amdvlk [
            pkgs.driversi686Linux.amdvlk
          ];
        };

        systemd.tmpfiles.rules = [
          "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
        ];
      })

      # Core Ctrl can be used for both CPU & GPU
      # TODO: Move to my.programs.corectrl
      (lib.mkIf cfg.coreCtrl.enable {
        programs.corectrl.enable = true;
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
        boot.initrd.kernelModules = lib.mkIf cfg.intel.enableKernelModule [ "i915" ];

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
        # Load nvidia driver for Xorg and Wayland
        services.xserver.videoDrivers = [ "nvidia" ];

        # https://github.com/hlissner/dotfiles/blob/254aea2230e1350409a7ae7b6566bcd98f5b5360/modules/profiles/hardware/gpu/nvidia.nix#L42C5-L60C7
        environment = {
          systemPackages =
            with pkgs;
            builtins.map lib.hiPrio [
              # Respect XDG conventions, damn it!
              (pkgs.writeShellScriptBin "nvidia-settings" ''
                mkdir -p "$XDG_CONFIG_HOME/nvidia"
                ${lib.getExe' cfg.nvidia.package.settings "nvidia-settings"} --config="$XDG_CONFIG_HOME/nvidia/rc.conf" "$@"
              '')
              libva
            ];
          sessionVariables = {
            LIBVA_DRIVER_NAME = "nvidia";
            WLR_NO_HARDWARE_CURSORS = "1";

            # May cause Firefox crashes
            GBM_BACKEND = "nvidia-drm";
          };
        };

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

        nixpkgs.config = {
          allowUnfreePredicate =
            pkg:
            builtins.elem (lib.getName pkg) [
              "nvidia-x11"
              "nvidia-settings"
              "nvidia-persistenced"
            ];
          nvidia.acceptLicense = true;
        };
        # TODO: Maybe put somewhere else
        virtualisation.docker.enableNvidia = true;

        programs.coolercontrol = lib.mkIf cfg.nvidia.coolercontrol {
          enable = true;
          nvidiaSupport = true;
        };
      })
    ]
  );
}
