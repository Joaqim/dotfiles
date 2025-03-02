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
  config = lib.mkIf cfg.enable {
    programs.atuin = {
      enable = true;
      inherit (cfg) enableBashIntegration enableNushellIntegration;
      flags = ["--disable-up-arrow"];
      daemon.enable = true;
      settings = {
        sync_address = "http://desktop:8888";
        # The package is managed by Nix
        update_check = false;
        # Compact Style
        style = "compact";
        # Get closer to fzf's fuzzy search
        search_mode = "skim";
        # Show long command lines at the bottom
        show_preview = true;
        # Allow for editing commands before executing
        enter_accept = false;
      };
    };
  };
}
