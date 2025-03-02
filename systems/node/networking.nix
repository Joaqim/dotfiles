{lib, ...}: {
  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
    };
    interfaces.enp0s31f6.wakeOnLan.enable = true;
  };
}
