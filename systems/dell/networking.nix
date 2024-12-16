{lib, ...}: {
  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # let you SSH in over the public internet
        4326 # rcon web UI
        4327 # rcon websocket access from UI
        8080 # misc
        25565 # local minecraft server
      ];
    };
    interfaces.enp5s0.wakeOnLan.enable = true;
  };
}
