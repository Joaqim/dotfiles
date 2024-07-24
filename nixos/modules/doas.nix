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
        permit nopass :wheel as root cmd /run/current-system/sw/bin/nixos-rebuild
        permit nopass :wheel as root cmd /etc/profiles/per-user/jq/bin/systemctl
        permit nopass :wheel as root cmd /etc/profiles/per-user/jq/bin/journalctl
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
