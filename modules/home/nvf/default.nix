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
            programmingWordlist.enable = true;
          };
        };
      };
    };
  };
}
