{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    flags = ["--disable-up-arrow"];
    daemon.enable = true;
    settings = {
      sync_address = "http://desktop:8888";
    };
  };
}
