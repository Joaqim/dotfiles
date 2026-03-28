{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my.home.command-line;
in
{
  options.my.home.command-line = with lib; {
    enable = my.mkDisableOption "enable command line utilities";

    androidTools = mkEnableOption "enable android tools";
  };

  imports = [
    inputs.nix-index-database.homeModules.nix-index
  ];

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs = {
          nix-index = {
            enable = true;
            enableNushellIntegration = true;
          };
          nix-index-database.comma.enable = true;
          pay-respects = {
            enable = true;
            enableNushellIntegration = true;
            options = [
              "--alias"
              "f"
            ];
          };
        };
        home.packages = builtins.attrValues {
          inherit (pkgs)
            dtrx # Do The Right Extraction
            file
            flac
            gh
            gvfs
            hardinfo2
            ncdu
            fastfetch
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

            # Useful for Nix development
            omnix
            nixpkgs-fmt
            just
            watchexec
            fswatch
            ;
        };
      }
      (lib.mkIf config.my.home.command-line.androidTools {
        home.packages = builtins.attrValues {
          inherit (pkgs)
            android-file-transfer
            android-tools
            scrcpy
            ;
        };
      })
    ]
  );
}
