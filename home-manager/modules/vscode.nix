{
  pkgs,
  lib,
  ...
}: {
  programs = {
    vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        eamodio.gitlens
        myriad-dreamin.tinymist
        nvarner.typst-lsp
        catppuccin.catppuccin-vsc
        james-yu.latex-workshop
        jnoortheen.nix-ide
        kamadorueda.alejandra
        mkhl.direnv
        pkief.material-icon-theme
        streetsidesoftware.code-spell-checker
        tamasfe.even-better-toml
        esbenp.prettier-vscode
        mattn.lisp
      ];
      userSettings = {
        "git.confirmSync" = false;
        "editor.insertSpaces" = false;
        "files.autoSave" = "afterDelay";
        "git.enableSmartCommit" = true;
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = lib.getExe pkgs.nil;
        "nix.formatterPath" = lib.getExe pkgs.alejandra;
        "window.menuBarVisibility" = "toggle";
        "workbench.iconTheme" = "material-icon-theme";
        "workbench.startupEditor" = "none";
        "workbench.colorTheme" = "Catppuccin Mocha";
      };
    };
  };
}
