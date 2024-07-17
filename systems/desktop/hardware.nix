{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware = {
    # TODO(jq): Check compatible hardware for firmware
    #firmware = [pkgs.rtl8761b-firmware];
    enableAllFirmware = true;
    ledger.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
