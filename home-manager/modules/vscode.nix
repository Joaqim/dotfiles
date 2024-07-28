{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Nix Language
    alejandra

    material-icons
    material-design-icons

    # https://mynixos.com/nixpkgs/package/codeium
    codeium
  ];

  programs = {
    vscode = {
      enable = true;
      userSettings = {
        ##### VsCode Settings #####
        ## Commonly Used
        "files.autoSave" = "onFocusChange";
        "editor.fontSize" = 14;
        "editor.tabSize" = 4;
        "editor.renderWhitespace" = "selection";
        "editor.cursorStyle" = "line";
        "editor.multiCursorModifier" = "alt";
        "editor.insertSpaces" = true;
        "editor.wordWrap" = "off";
        "files.exclude" = {
          "**/.git" = true;
          "**/.svn" = true;
          "**/.hg" = true;
          "**/CVS" = true;
          "**/.DS_Store" = true;
          "**/Thumbs.db" = true;
        };
        "files.associations" = {};

        # Accept linux keymapping
        "keyboard.dispatch" = "keyCode";

        # Git
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;

        ## Workbench
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.editor.enablePreview" = true;

        ## Window
        "window.autoDetectColorScheme" = false;
        "window.menuBarVisibility" = "toggle";

        ## Features
        #### Explorer
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "explorer.enableDragAndDrop" = false;

        ## Application
        #### Update
        "update.mode" = "none";
        "update.showReleaseNotes" = false;

        ## Extensions
        #### Material Icon Theme
        "material-icon-theme.activeIconPack" = "react";
        "material-icon-theme.files.associations" = {
          "*.ts" = "typescript";
          "**.json" = "json";
          "filename.tsx" = "react";
          "fileName.ts" = "typescript";
          "justfile" = "template";
        };
        "material-icon-theme.folders.associations" = {
          ".direnv" = "Generator";
          "applications" = "App";
          "home-manager" = "Home";
          "hyprland" = "Theme";
          "laptop" = "Desktop";
          "MinecraftModpack" = "Minecraft";
          "nas" = "Context";
          "nixos" = "Project";
          "parts" = "Components";
          "profiles" = "Content";
          "steam" = "Console";
          "systems" = "Decorators";
          "user0" = "Guard";
          "user0/configs" = "Client";
          "user1" = "Private";
          "user1/configs" = "Client";
          "user2" = "Private";
          "user2/configs" = "Client";
          "users" = "Global";
          "work" = "Desktop";
        };

        ### Nix Language
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nil;
        "nix.formatterPath" = lib.getExe pkgs.alejandra;

        ### GitLens
        "gitlens.telemetry.enabled" = false;
        "gitlens.ai.experimental.model" = "openai:gpt-3.5-turbo";
        "gitlens.experimental.generateCommitMessagePrompt" = "Generate a commit message using the Conventional Commits format. Examples: ['feat: Add new feature to the project', 'fix: Fix a bug in the project', 'chore: Update build configuration or task', 'docs: Update project documentation', 'style: Update code formatting or style', 'refactor: Refactor existing code', 'test: Add or update tests', 'perf: Improve performance of the project', 'ci: Update continuous integration configuration', 'build: Make changes related to the build process', 'revert: Revert a previous commit']";

        ### Custom Dictionary
        "cSpell.customDictionaries" = {
          "custom-dictionary-user" = {
            "name" = "custom-dictionary-user";
            "path" = "~/.cspell/custom-dictionary-user.txt";
            "addWords" = true;
            "scope" = "user";
          };
        };

        ### Codeium
        "codeium.enableConfig" = {
          "*" = true;
          "nix" = true;
        };

        ### VSCode Helix Emulation
        "extensions.experimental.affinity" = {
          "jasew.vscode-helix-emulation" = 1;
        };
      };
      extensions = with pkgs.vscode-extensions;
        [
          catppuccin.catppuccin-vsc
          #codeium.codeium
          eamodio.gitlens
          esbenp.prettier-vscode
          github.vscode-github-actions
          james-yu.latex-workshop
          jnoortheen.nix-ide
          kamadorueda.alejandra
          marp-team.marp-vscode
          mattn.lisp
          mkhl.direnv
          ms-azuretools.vscode-docker
          myriad-dreamin.tinymist
          nvarner.typst-lsp
          pkief.material-icon-theme
          pkief.material-product-icons
          signageos.signageos-vscode-sops
          streetsidesoftware.code-spell-checker
          tamasfe.even-better-toml
          thenuprojectcontributors.vscode-nushell-lang
          wakatime.vscode-wakatime
          yzhang.markdown-all-in-one
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "codeium";
            publisher = "Codeium";
            version = "1.9.86";
            sha256 = "sha256-1r6lUD7mM12NGb3l279HzSNRi7VLVe/zrQdBVAJtPyw=";
          }
          {
            name = "vscode-tailscale";
            publisher = "Tailscale";
            version = "1.0.0";
            sha256 = "sha256-MKiCZ4Vu+0HS2Kl5+60cWnOtb3udyEriwc+qb/7qgUg=";
          }
          {
            name = "vscode-helix-emulation";
            publisher = "jasew";
            version = "0.6.2";
            sha256 = "sha256-V/7Tu1Ze/CYRmtxwU2+cQLOxLwH7YRYYeHSUGbGTb5I=";
          }
        ];
      userSettings = {
      };
    };
  };
}
