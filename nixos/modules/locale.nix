{lib, ...}: {
  time.timeZone = lib.mkDefault "Europe/Stockholm";

  i18n = rec {
    defaultLocale = lib.mkDefault "en_US.UTF-8";

    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "sv_SE.UTF-8/UTF-8"
    ];

    extraLocaleSettings = lib.mkDefault rec {
      LANGUAGE = defaultLocale;
      LC_ADDRESS = LANGUAGE;
      LC_ALL = LANGUAGE;
      LC_COLLATE = LANGUAGE;
      LC_CTYPE = LANGUAGE;
      LC_IDENTIFICATION = LANGUAGE;
      LC_MEASUREMENT = LANGUAGE;
      LC_MESSAGES = LANGUAGE;
      LC_MONETARY = LANGUAGE;
      LC_NAME = LANGUAGE;
      LC_NUMERIC = LANGUAGE;
      LC_PAPER = LANGUAGE;
      LC_TELEPHONE = LANGUAGE;
      LC_TIME = LANGUAGE;
    };
  };
}
