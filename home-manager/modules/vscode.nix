{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Nix Language
    alejandra
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
        "material-icon-theme.files.associations" = {
          "*.ts" = "typescript";
          "**.json" = "json";
          "filename.tsx" = "react";
          "fileName.ts" = "typescript";
        };
        "material-icon-theme.folders.associations" = {
          "applications" = "folder-apps";
          "home-manager" = "folder-home";
          "laptop" = "folder-desktop";
          "MinecraftModpack" = "Minecraft";
          "nas" = "Context";
          "nixos" = "Projects";
          "parts" = "folder-components";
          "systems" = "Decorators";
          "user0" = "Guard";
          "user1" = "Private";
          "user2" = "Private";
          "work" = "folder-desktop";
        };

        ### Nix Language
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nil;
        "nix.formatterPath" = lib.getExe pkgs.alejandra;
      };
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        codeium.codeium
        eamodio.gitlens
        esbenp.prettier-vscode
        evolution-gaming.evolution-gaming--vscode-eslint # ESLint 'autoFixOnSave'
        james-yu.latex-workshop
        jnoortheen.nix-ide
        kamadorueda.alejandra
        marp-team.marp-vscode
        mattn.lisp
        mkhl.direnv
        myriad-dreamin.tinymist
        nvarner.typst-lsp
        oavbls.pretty-ts-errors
        pkief.material-icon-theme
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
