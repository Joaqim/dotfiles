{lib, ...}: {
  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
    };
    interfaces.enp5s0.wakeOnLan.enable = true;
  };
}
