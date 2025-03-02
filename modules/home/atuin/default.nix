{
  config,
  lib,
  ...
}: let
  cfg = config.my.home.atuin;
in {
  options.my.home.atuin = with lib; {
    enable = my.mkDisableOption "atuin configuration";
    enableBashIntegration = my.mkDisableOption "atuin bash integration";
    enableNushellIntegration = my.mkDisableOption "atuin nushell integration";
  };
  programs.atuin = {
    enable = true;
    inherit (cfg) enableBashIntegration;
    inherit (cfg) enableNushellIntegration;
    flags = ["--disable-up-arrow"];
    daemon.enable = true;
    settings = {
      sync_address = "http://desktop:8888";
    };
  };
}
