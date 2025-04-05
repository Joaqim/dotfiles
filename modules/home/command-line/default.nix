{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.command-line;
in {
  options.my.home.command-line = with lib; {
    enable = my.mkDisableOption "enable command line utilities";

    androidTools = mkEnableOption "enable android tools";
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      home.packages = builtins.attrValues {
        inherit
          (pkgs)
          dtrx # Do The Right Extraction
          file
          flac
          gvfs
          hardinfo
          ncdu
          neofetch
          neovim
          p7zip
          pciutils
          pinentry-all
          ripgrep
          systemctl-tui
          tomb
          trash-cli
          unzip
          usbutils
          zip
          ;
      };
    }
    (lib.mkIf config.my.home.command-line.androidTools {
      home.packages = builtins.attrValues {
        inherit
          (pkgs)
          android-file-transfer
          android-tools
          scrcpy
          ;
      };
    })
  ]);
}
