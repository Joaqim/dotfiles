{lib, ...}: {
  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # let you SSH in over the public internet
        25565
      ];
    };
    interfaces.enp0s31f6.wakeOnLan.enable = true;
  };
}
