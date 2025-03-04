{
  networking = {
    hostId = "2bb7bd3f";
    hostName = "raket";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;

    firewall.enable = true;
  };

  my.hardware.networking = {
    # Which interface is used to connect to the internet
    #externalInterface = "enp5s0";

    # Enable WiFi integration
    wireless.enable = true;
  };
}
