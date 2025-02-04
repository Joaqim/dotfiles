{lib, ...}: {
  imports = [
    ./boot.nix
    ./hardware-config.nix
    ./networking.nix
    ./ssh.nix
  ];

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  hardware.xpadneo.enable = true;

  jovian = {
    devices.steamdeck.enable = true;
    steam = {
      enable = true;
      autoStart = true;

      user = "deck";
      desktopSession = "plasma";
    };
    decky-loader.enable = true;
  };

  environment.variables = {
    NIXPKGS_ALLOW_INSECURE = "1";
    # Allow Discord ( vesktop )
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  i18n.defaultLocale = lib.mkForce "sv_SE.UTF-8";

  system.stateVersion = lib.mkForce "24.05";
}
