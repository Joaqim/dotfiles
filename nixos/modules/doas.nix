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
      wheelNeedsPassword = false;

      extraRules = let
        users = [flake.config.people.user0];
      in [
        {
          inherit users;
          keepEnv = true;
          noPass = false;
          persist = true;
        }
        {
          inherit users;
          noPass = true;
          cmd = "systemctl";
        }
        {
          inherit users;
          noPass = true;
          cmd = "journalctl";
        }
        {
          inherit users;
          noPass = true;
          cmd = "nixos-rebuild";
        }
      ];
    };
  };
}
