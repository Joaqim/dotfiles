{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.profiles.hyprland;
in
{
  options.my.profiles.hyprland = with lib; {
    enable = mkEnableOption "hyprland configuration";
  };
  # TODO: Split this configuration into modules in modules/nixos:
  # my.services.xserver
  # my.services.desktopManager
  # my.services.displayManager
  config = lib.mkIf cfg.enable {
    services = {
      xserver.enable = true;
      desktopManager.plasma6.enable = lib.mkForce false;
      displayManager = {
        defaultSession = "hyprland";
        sddm = {
          enable = true;
          wayland.enable = true;
          autoNumlock = true;
        };
      };
    };
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    environment = {
      systemPackages = [
        pkgs.kitty # required for the default Hyprland config
      ];

      # Optional, hint Electron apps to use Wayland:
      sessionVariables.NIXOS_OZONE_WL = "1";
    };
  };
}
