{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      ignoreUserConfig = false;
      settings = {
        globalOptions = builtins.fromTOML (builtins.readFile ./fcitx5-options.toml);
        inputMethod = {
          "Groups/0" = {
            "Name" = "Default";
            "Default Layout" = "us";
            "DefaultIM" = "keyboard-us";
          };
          "Groups/0/Items/0" = {
            "Name" = "keyboard-us-dvp";
            "Layout" = "";
          };
          "Groups/0/Items/1" = {
            "Name" = "keyboard-us";
            "Layout" = "";
          };
          "GroupOrder" = {
            "0" = "Default";
          };
        };
      };
    };
  };
}
