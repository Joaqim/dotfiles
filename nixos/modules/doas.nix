{flake, ...}: {
  security = {
    doas = {
      enable = true;
      extraRules = [
        {
          keepEnv = true;
          noPass = true;
          users = [flake.config.people.user0];
        }
      ];
    };
    # sudo.enable = false;
  };
}
