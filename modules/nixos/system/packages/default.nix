# Common packages
{
  config,
  lib,
  ...
}: let
  cfg = config.my.system.packages;
in {
  options.my.system.packages = with lib; {
    enable = my.mkDisableOption "packages configuration";

    allowAliases = mkEnableOption "allow package aliases";

    allowUnfree = my.mkDisableOption "allow unfree packages";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
      };
    };

    nixpkgs.config = {
      inherit (cfg) allowAliases allowUnfree;
    };
    environment.pathsToLink = lib.mkIf config.my.home.xdg.enable ["/share/xdg-desktop-portal" "/share/applications"];
  };
}
