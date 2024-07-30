{config, ...}: let
  user = config.home.username;
in {
  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      #sync_address = "http://0.0.0.0:8888";
      #key_path = config.sops.secrets."atuin_key/${user}".path;
    };
  };
}
