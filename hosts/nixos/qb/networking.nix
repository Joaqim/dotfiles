{
  networking = {
    hostId = "685ac7de";
    hostName = "qb";

    domain = "qb.joaqim.com";
    # Allow ddev instance to use XDebug
    # Allow Xdebug to use port 9003.
    firewall.allowedTCPPorts = [ 9003 ];

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behavior.
    useDHCP = false;

    firewall.enable = true;
  };

  # Make it possible for ddev to modify the /etc/hosts file.
  # Otherwise you'll have to manually change the
  # hosts configuration after creating a new ddev project.
  environment.etc.hosts.mode = "0644";

  my.hardware.networking = {
    # Which interface is used to connect to the internet
    #externalInterface = "enp5s0";

    # Enable WiFi integration
    wireless.enable = true;
  };
}
