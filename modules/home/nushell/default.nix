{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.nushell;
in {
  options.my.home.nushell = with lib; {
    enable = my.mkDisableOption "nushell configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      environmentVariables = lib.mkIf config.my.home.packages.enable {
        PATH = lib.hm.nushell.mkNushellInline ''
          ($env.PATH |
            split row (char esep) |
            append ($env.HOME | path join .nix-profile/bin)
          )
        '';
      };
      plugins = with pkgs.nushellPlugins; [
        query
      ];
      settings = {
        show_banner = false;
        completions = {
          case_sensitive = false; # case-sensitive completions
          quick = true; # set to false to prevent auto-selecting completions
          partial = true; # set to false to prevent partial filling of the prompt
          algorithm = "fuzzy"; # prefix or fuzzy
          external = {
            # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable = true;
            # set to lower can improve completion performance at the cost of omitting some options
            max_results = 100;
          };
        };
      };
    };
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
