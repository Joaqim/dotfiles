{
  config,
  lib,
  ...
}: {
  hardware = {
    # TODO(jq): Check compatible hardware for firmware
    #firmware = [pkgs.rtl8761b-firmware];
    enableAllFirmware = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    # Corsair Keyboard/Mouse driver
    ckb-next.enable = true;
  };
}
