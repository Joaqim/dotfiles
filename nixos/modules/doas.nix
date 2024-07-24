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
        permit nopass :wheel as root cmd /usr/bin/nixos-rebuild
      '';

      extraRules = [
        {
          keepEnv = true;
          noPass = false;
          users = [flake.config.people.user0];
          persist = true;
        }
      ];
    };
  };
}
