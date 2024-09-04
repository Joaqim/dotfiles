{lib, ...}: {
  time.timeZone = lib.mkDefault "Europe/Stockholm";

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";

    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "sv_SE.UTF-8/UTF-8"
    ];

    inputMethod = {
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

    extraLocaleSettings = lib.mkDefault {
      LC_ADDRESS = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
