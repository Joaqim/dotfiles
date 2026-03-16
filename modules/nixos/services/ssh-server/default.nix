# An SSH server, using 'mosh'
{
  config,
  lib,
  ...
}:
let
  cfg = config.my.services.ssh-server;
in
{
  options.my.services.ssh-server = {
    enable = lib.mkEnableOption "SSH Server using 'mosh'";
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      # Enable the OpenSSH daemon.
      enable = true;

      settings = {
        # Be more secure
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    programs = {
      # Opens the relevant UDP ports.
      mosh.enable = true;

      ssh.knownHosts = {
        "github.com".publicKey =
          "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
      };
    };
  };
}
