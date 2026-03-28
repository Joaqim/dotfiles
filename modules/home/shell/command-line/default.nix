{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.my.home.shell.command-line;
in
{
  options.my.home.shell.command-line = with lib; {
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
            # TODO: Define in nixos module
            # Use Ollama LLM as fallback
            /*
              aiIntegration = {
                locale = "en";
                model = "llama3";
                url = "http://desktop:11434/v1/chat/completions";
              };
            */
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
      (lib.mkIf config.my.home.shell.command-line.androidTools {
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
