{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.my.home.gaming;
in {
  options.my.home.gaming = with lib; {
    enable = mkEnableOption "gaming configuration";
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home = {
        packages = builtins.attrValues {
          inherit
            (pkgs)
            bottles
            bubblewrap
            dwarfs
            fuse-overlayfs
            heroic
            mangohud
            prismlauncher
            protonup-qt
            psmisc # for `fuser`
            vulkan-loader
            vulkan-tools
            winetricks
            ;
        };
      };
    }
    {
      my.home.nix.cache.nixGaming = lib.mkDefault true;
    }
    # Steam executable is provided by module my.programs.steam
    # TODO: Make this work:
    #(lib.mkIf config.my.programs.steam.enable {
    {
      home =
        /*
            let
          # TODO: Make sure pathing works correctly with `dataDir` override
          STEAM_DATA_HOME = config.my.programs.steam.dataDir;
        in
        */
        {
          file.".local/share/Steam/steam_dev.cfg".text = ''
            @nClientDownloadEnableHTTP2PlatformLinux 0
            @fDownloadRateImprovementToAddAnotherConnection 1.0
          '';
          packages = builtins.attrValues {
            inherit
              (pkgs)
              steamtinkerlaunch
              ;
          };
        };
    }
  ]);
}
