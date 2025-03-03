# Docker related settings
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.system.docker;
in {
  options.my.system.docker = with lib; {
    enable = mkEnableOption "docker configuration";

    withDockerCompose = my.mkDisableOption "with docker-compose";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      extraPackages = lib.mkIf cfg.withDockerCompose [pkgs.docker-compose];

      # Remove unused data on a weekly basis
      autoPrune = {
        enable = true;

        dates = "weekly";

        flags = [
          "--all"
        ];
      };
    };
  };
}
