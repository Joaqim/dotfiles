# Docker related settings
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.system.docker;
in
{
  options.my.system.docker = with lib; {
    enable = mkEnableOption "docker configuration";

    withDockerCompose = my.mkDisableOption "with docker-compose";
    withContainers = my.mkDisableOption "with containers";
    enableInsecureContainerPolicy = my.mkDisableOption "enable insecure container policy";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (lib.mkIf cfg.withContainers {
        virtualisation.containers = {
          enable = true;
          policy = lib.mkIf cfg.enableInsecureContainerPolicy {
            default = [ { type = "insecureAcceptAnything"; } ];
            transports = {
              docker-daemon = {
                "" = [ { type = "insecureAcceptAnything"; } ];
              };
            };
          };
        };
      })
      {
        virtualisation = {
          docker = {
            enable = true;
            extraPackages = lib.mkIf cfg.withDockerCompose [ pkgs.docker-compose ];

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
    ]
  );
}
