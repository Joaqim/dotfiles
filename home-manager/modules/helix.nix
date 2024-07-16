{
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = pkgs.helix;
    languages = {
      language = [
        {
          auto-format = true;
          formatter.command = "alejandra";
          name = "nix";
        }
        {
          auto-format = true;
          formatter.command = "haskell";
          name = "haskell";
        }
        {
          auto-format = true;
          formatter.command = "cssfmt";
          name = "css";
        }
        {
          auto-format = true;
          formatter.command = "yuck";
          name = "yuck";
        }
        {
          auto-format = true;
          formatter.command = "yamlfmt";
          name = "yaml";
        }
      ];
    };
    settings = {
      editor = {
        mouse = true;
        auto-format = true;
        auto-save = true;
        line-number = "relative";
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
      };
      keys = {
        normal = {
          space = {
            f = ":format";
            q = ":q";
            w = ":w";
          };
        };
      };
      theme = "catppuccin_macchiato";
    };
  };
}
