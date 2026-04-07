{
  networking = {
    hostId = "fce78f04";
    hostName = "desktop";

    domain = "joaqim.com";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    firewall.enable = true;

    # Connect to VPS peer
    extraHosts = ''
      10.242.37.1 openclaw.zt
      10.242.37.1 matrix.zt
      10.242.37.1 node.zt
       galaxy.zt
      10.242.37.1 www.openclaw.zt
      10.242.37.1 www.matrix.zt
      10.242.37.1 www.node.zt
    '';
  };

  my.hardware.networking = {
    # Which interface is used to connect to the internet
    externalInterface = "enp5s0";

    # Enable WiFi integration
    wireless.enable = true;
  };
}
