{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraPackages = [pkgs.curl];
    };
    java.enable = true;
  };
  hardware.steam-hardware.enable = true;
}
