{
  pkgs,
  config,
  ...
}:
let
  inherit (config.networking) hostName;
in
{
  boot = {
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback.out
    ];
    supportedFilesystems = [ "zfs" ];
    initrd = {
      network.openvpn.enable = true;
      availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "thunderbolt"
        "uas"
        "usb_storage"
        "usbhid"
        "xhci_pci"
      ];
      kernelModules = [ "amdgpu" ];
    };

    kernelParams = [
      #"video=card1-DP-3:3440x1440@100"
      # Disable Kernel microcode checksum verification for use with ucodenix
      "microcode.amd_sha_check=off"
    ];
    kernelModules = [
      "kvm-amd"
      "v4l2loopback"
    ];

    zfs = {
      extraPools = [ "zpool-${hostName}" ];
    };

    loader = {
      efi = {
        canTouchEfiVariables = false;
        efiSysMountPoint = "/boot";
      };
      generationsDir = {
        copyKernels = true;
      };
      grub = {
        enable = true;
        copyKernels = true;
        device = "nodev";
        efiSupport = true;
        zfsSupport = true;

        # Enable while transferring systems between different machines, also toggle `efi.canTouchEfiVariables` to false
        # https://mynixos.com/nixpkgs/option/boot.loader.grub.efiInstallAsRemovable
        efiInstallAsRemovable = false;

        theme = pkgs.sleek-grub-theme.override {
          withBanner = "Welcome, Joaqim!";
          withStyle = "bigSur";
        };
      };
    };
  };
}
