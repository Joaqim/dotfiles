{
  pkgs,
  config,
  ...
}: {
  boot = {
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback.out
    ];
    supportedFilesystems = ["zfs"];
    initrd = {
      network.openvpn.enable = true;
      availableKernelModules = ["nvme" "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };

    kernelModules = ["kvm-amd" "vfio-pci" "v4l2loopback"];

    kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;

    zfs = {
      extraPools = ["zpool"];
      forceImportAll = true;
      forceImportRoot = true;
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
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
        theme = pkgs.sleek-grub-theme.override {
          withBanner = "Grub Bootloader";
          withStyle = "bigSur";
        };
      };
    };
  };
}
