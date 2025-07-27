{ lib, ... }:
{
  networking = {
    hostName = "deck";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
    };
  };
}
