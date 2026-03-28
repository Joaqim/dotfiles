{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.home.gaming.bundle;
in
{
  options.my.home.gaming.bundle = with lib; {
    enable = mkEnableOption "gaming configuration";
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home = {
          packages = builtins.attrValues {
            inherit (pkgs)
              bottles
              bubblewrap
              fuse-overlayfs
              heroic
              mangohud
              prismlauncher
              protonup-qt
              vulkan-loader
              vulkan-tools
              winetricks
              ;
          };
        };

        my.home.development.nix.cache.nixGaming = lib.mkDefault true;
      }
      # Steam executable is provided by module my.programs.steam
      # TODO: Make this work:
      #(lib.mkIf config.my.programs.steam.enable {
      {
        /*
          # TODO: Make sure pathing works correctly with `dataDir` override
          STEAM_DATA_HOME = config.my.programs.steam.dataDir;
        */
        home.file.".local/share/Steam/steam_dev.cfg".text = ''
          @nClientDownloadEnableHTTP2PlatformLinux 0
          @fDownloadRateImprovementToAddAnotherConnection 1.0
        '';
        home.packages = builtins.attrValues {
          inherit (pkgs)
            steamtinkerlaunch
            ;
        };
      }
    ]
  );
}
