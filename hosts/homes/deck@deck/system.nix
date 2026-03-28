_: {
  my.home.system = {
    documentation.enable = false;
    jq.enable = false;
    secrets = {
      enable = true;
      sopsDirectory = "/var/lib/sops";
    };
  };
}
