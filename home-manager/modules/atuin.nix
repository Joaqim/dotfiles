{
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    flags = ["--disable-up-arrow"];
    settings = {
      sync_address = "http://desktop.joaqim.com:8888";
    };
  };
}
