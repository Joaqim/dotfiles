{lib, ...}: {
  networking = {
    hostName = "thinkpad";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
    };
    #interfaces.enp0s25.wakeOnLan.enable = true;
  };
  services = {
    sshd.enable = true;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };
}
