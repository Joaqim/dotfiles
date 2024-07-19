{
  flake,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.doas-sudo-shim];
  security = {
    sudo.enable = false;
    doas = {
      enable = true;

      extraConfig = ''
        permit nopass :wheel as root cmd /usr/bin/liquidctl
      '';

      extraRules = [
        {
          keepEnv = true;
          noPass = true;
          users = [flake.config.people.user0];
          persist = true;
        }
      ];
    };
  };
}
