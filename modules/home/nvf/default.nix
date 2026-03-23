{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.home.nvf;
in
{
  imports = [ inputs.nvf.homeManagerModules.default ];

  options.my.home.nvf = with lib; {
    enable = mkEnableOption "nvf configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          languages.markdown.extensions.markview-nvim.enable = true;
          viAlias = false;
          vimAlias = true;
          lsp.enable = true;
          spellcheck = {
            enable = true;
            languages = [
              "en"
              "sv"
            ];
            #programmingWordlist.enable = true;
          };
        };
      };
    };
    xdg.configFile = {
      # https://neovim.io/doc/user/plugins.html#spellfile.lua
      # TODO: Consider using a unified spell root directory and adding to additionalRuntimePaths:  https://nvf.notashelf.dev/options.html#option-vim-additionalRuntimePaths
      "nvf/spell/en.utf-8.spl".source = builtins.fetchurl {
        url = "https://github.com/vim/vim/raw/refs/heads/master/runtime/spell/en.utf-8.spl";
        sha256 = "0w1h9lw2c52is553r8yh5qzyc9dbbraa57w9q0r9v8xn974vvjpy";
      };
      # Might require nix-prefetch-url ?
      "nvf/spell/sv.utf-8.spl".source = builtins.fetchurl {
        url = "ftp://ftp.fu-berlin.de/unix/editors/vim/runtime/spell/sv.utf-8.spl";
        sha256 = "0lmbfb6cw38dzic388m9gc5ajx30j9npdz48acfs4v3nl52jivbk";
      };
    };
  };
}
