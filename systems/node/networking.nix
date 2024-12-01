{lib, ...}: {
  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # let you SSH in over the public internet
      ];
    };
    nat = {
      enable = true;
      internalInterfaces = ["ve-+" "ve-+"];
      externalInterface = "wlp3s0";
      # Lazy IPv6 connectivity for the container
      enableIPv6 = true;
    };
  };
  services = {
    sshd.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        X11Forwarding = true;
      };
    };
  };
}
