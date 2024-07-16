{
  config,
  lib,
  pkgs,
  ...
}: {
  hardware = {
    firmware = [pkgs.rtl8761b-firmware];
    enableAllFirmware = true;
    ledger.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
