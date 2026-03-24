{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.my.home.nvf;

  claude-code-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "claudecode.nvim";
    src = inputs.nvim-plugin-claude-code;
  };

  octo-plugin = pkgs.vimUtils.buildVimPlugin {
    name = "octo.nvim";
    src = inputs.nvim-plugin-octo;
    doCheck = false; # Disable require check - plugin has runtime dependencies
  };

  # Convert a bool to a Lua boolean string
  toLua = b: if b then "true" else "false";

  t = cfg.toggles;

  timvimConf = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    extraSpecialArgs = {
      inherit claude-code-plugin octo-plugin;
    };
    modules = [
      "${inputs.timvim}/config"
      {
        vim = {
          viAlias = false;
          vimAlias = true;
          # TODO: Maybe consider auto configuring API key using sops secrets
          utility.vim-wakatime.enable = true;

          binds.hardtime-nvim.setupOpts.enabled = lib.mkForce t.hardtime;
          #binds.terminal-vim.setupOpts.enabled = lib.mkForce t.terminal;
          visuals.indent-blankline.setupOpts.enabled = lib.mkForce t.indentGuides;
          minimap.codewindow.enable = lib.mkForce t.codeOutline;
          treesitter.context.setupOpts.enable = lib.mkForce t.treesitterContext;
          utility.motion.precognition.setupOpts.startVisible = lib.mkForce t.precognition;

          luaConfigRC.whichkey_toggle_icons = lib.mkForce ''
            -- Dynamic toggle icons: gray off icon when disabled, colored on icon when enabled
            -- Toggle state tracking table
            _G.toggle_states = _G.toggle_states or {}

            -- Highlight groups for toggle states
            vim.api.nvim_set_hl(0, "WhichKeyToggleOff", { fg = "#666666" })
            vim.api.nvim_set_hl(0, "WhichKeyToggleOn", { fg = "#89b4fa" })

            -- Helper to update which-key toggle descriptions
            _G.update_toggle_desc = function(key, name, enabled)
              local ok, wk = pcall(require, "which-key")
              if not ok then return end
              local icon = enabled and "󰔡" or "󰨚"
              local hl = enabled and "WhichKeyToggleOn" or "WhichKeyToggleOff"
              local state = enabled and "ON" or "OFF"
              wk.add({
                { key, desc = name .. " [" .. state .. "]", icon = { icon = icon, hl = hl } },
              })
            end

            -- Initialize toggle descriptions from Nix-configured defaults
            vim.defer_fn(function()
              _G.update_toggle_desc("<leader>tt", "Terminal",              ${toLua t.terminal})
              _G.update_toggle_desc("<leader>th", "HardTime",             ${toLua t.hardtime})
              _G.update_toggle_desc("<leader>tc", "Treesitter Context",   ${toLua t.treesitterContext})
              _G.update_toggle_desc("<leader>ti", "Indent Guides",        ${toLua t.indentGuides})
              _G.update_toggle_desc("<leader>to", "Code Outline",         ${toLua t.codeOutline})
              _G.update_toggle_desc("<leader>tw", "CursorHold Diagnostics", ${toLua t.cursorHoldDiagnostics})
              _G.update_toggle_desc("<leader>tv", "Virtual Text Diagnostics", ${toLua t.virtualTextDiagnostics})
              _G.update_toggle_desc("<leader>tp", "Precognition",         ${toLua t.precognition})
              _G.update_toggle_desc("<leader>tg", "Harper Grammar",       ${toLua t.harperGrammar})
              _G.update_toggle_desc("<leader>tz", "Spell Autopopup",      ${toLua t.spellAutopopup})
              _G.update_toggle_desc("<leader>tu", "Undo Tree",            ${toLua t.undoTree})
              _G.update_toggle_desc("<leader>tT", "Typing Tutor",         ${toLua t.typingTutor})
            end, 100)
          '';

          languages = {
            go.enable = lib.mkForce false;
            java.enable = lib.mkForce false;
          };
          spellcheck = {
            enable = true;
            languages = [
              "en"
              "sv"
            ];
            #programmingWordlist.enable = true;
          };
        };
      }
    ];
  };

in
{

  options.my.home.nvf = with lib; {
    enable = mkEnableOption "nvf configuration";

    toggles = {
      terminal = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the Terminal toggle (<leader>tt).";
        internal = true;
      };
      hardtime = mkOption {
        type = types.bool;
        default = true;
        description = "Default state for the HardTime toggle (<leader>th).";
      };
      treesitterContext = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the Treesitter Context toggle (<leader>tc).";
      };
      indentGuides = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the Indent Guides toggle (<leader>ti).";
      };
      codeOutline = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the Code Outline toggle (<leader>to).";
        internal = true;
      };
      cursorHoldDiagnostics = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the CursorHold Diagnostics toggle (<leader>tw).";
        internal = true;
      };
      virtualTextDiagnostics = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the Virtual Text Diagnostics toggle (<leader>tv).";
        internal = true;
      };
      precognition = mkOption {
        type = types.bool;
        default = true;
        description = "Default state for the Precognition toggle (<leader>tp).";
      };
      harperGrammar = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the Harper Grammar toggle (<leader>tg).";
        internal = true;
      };
      spellAutopopup = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the Spell Autopopup toggle (<leader>tz).";
        internal = true;
      };
      undoTree = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the Undo Tree toggle (<leader>tu).";
        internal = true;
      };
      typingTutor = mkOption {
        type = types.bool;
        default = false;
        description = "Default state for the Typing Tutor toggle (<leader>tT).";
        internal = true;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      yazi # Terminal File/Directory Browser
      timvimConf.neovim
      # Formatters
      black # python
      nixfmt # nix
      stylua # lua
      shfmt # bash/sh
      prettier # markdown/mdx etc
      rustfmt # rust
    ];
    /*
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
    */
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
