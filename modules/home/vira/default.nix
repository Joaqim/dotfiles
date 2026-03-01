{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.home.vira;
  inherit (inputs) vira;
in
{
  imports = [
    vira.homeManagerModules.vira
  ];

  options.my.home.vira = with lib; {
    enable = mkEnableOption "Vira Web Portal";
  };
  ## TODO: Add assertion for Lingering to be enabled: users.users.<username>.linger = true;
  # On Linux, you must enable “lingering” for your user to allow the Vira service to run as a daemon.
  # Lingering enables systemd user services to start at boot and continue running without requiring an active login session.

  config = lib.mkIf cfg.enable {
    services.vira = {
      enable = true;
      hostname = "0.0.0.0";
      port = 8087;
      https = false;
      package = vira.packages."x86_64-linux".default;

      # Initial state configuration with repositories and settings
      initialState.repositories = {
        jqpkgs = "https://github.com/Joaqim/pkgs.git";
      };
    };
  };
}
