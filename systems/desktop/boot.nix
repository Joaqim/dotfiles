{
  pkgs,
  config,
  flake,
  ...
}: let
  inherit (flake.config) people;
  userName = people.users.${people.user0}.name;
in {
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

    kernelModules = ["kvm-amd" "v4l2loopback"];

    zfs = {
      extraPools = ["zpool"];
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
          withBanner = "Welcome, ${userName}!";
          withStyle = "bigSur";
        };
      };
    };
  };
}
