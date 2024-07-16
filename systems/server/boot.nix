{
  pkgs,
  config,
  ...
}: {
  boot = {
    extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback.out
    ];
    supportedFilesystems = ["ntfs"];
    initrd = {
      availableKernelModules = ["nvme" "ahci" "xhci_pci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
    };

    kernelModules = ["kvm-amd" "vfio-pci" "v4l2loopback"];

    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot.enable = true;
    };
  };
}
