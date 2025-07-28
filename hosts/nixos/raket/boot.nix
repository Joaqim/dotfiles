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
      config.boot.kernelPackages.nvidiaPackages.legacy_470
    ];
    supportedFilesystems = [ "zfs" ];
    initrd = {
      network.openvpn.enable = true;
      availableKernelModules = [
        "nvme"
        "ahci"
        "xhci_pci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
    };

    zfs = {
      extraPools = [ "zpool-${hostName}" ];
      # https://discourse.nixos.org/t/21-05-zfs-root-install-cant-import-pool-on-boot/13652/7
      #devNodes = "/dev/disk/by-uuid";
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
        efiInstallAsRemovable = true;

        theme = pkgs.sleek-grub-theme.override {
          withBanner = "Welcome, Wilton!";
          withStyle = "bigSur";
        };
      };
    };
  };
}
