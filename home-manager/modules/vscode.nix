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

        ### Custom Dictionary
        "cSpell.customDictionaries" = {
          "custom-dictionary-user" = {
            "name" = "custom-dictionary-user";
            "path" = "~/.cspell/custom-dictionary-user.txt";
            "addWords" = true;
            "scope" = "user";
          };
        };
      };
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        eamodio.gitlens
        esbenp.prettier-vscode
        github.vscode-github-actions
        james-yu.latex-workshop
        jnoortheen.nix-ide
        kamadorueda.alejandra
        marp-team.marp-vscode
        mattn.lisp
        mkhl.direnv
        myriad-dreamin.tinymist
        nvarner.typst-lsp
        pkief.material-icon-theme
        pkief.material-product-icons
        signageos.signageos-vscode-sops
        signageos.signageos-vscode-sops
        streetsidesoftware.code-spell-checker
        tamasfe.even-better-toml
        thenuprojectcontributors.vscode-nushell-lang
        wakatime.vscode-wakatime
        yzhang.markdown-all-in-one
      ];
      userSettings = {
      };
    };
  };
}
