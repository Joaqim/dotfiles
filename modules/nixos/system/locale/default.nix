# Language settings
{
  config,
  lib,
  ...
}: let
  cfg = config.my.system.language;
in {
  options.my.system.language = with lib; {
    enable = my.mkDisableOption "language configuration";

    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      example = "fr_FR.UTF-8";
      description = "Which locale to use for the system";
    };

    supportedLocales = mkOption {
      type = types.listOf types.str;
      default = ["C.UTF-8/UTF-8" "en_US.UTF-8"];
      example = ["C.UTF-8/UTF-8" "en_US.UTF-8" "fr_FR.UTF-8"];
      description = "List of locales supported by the system";
    };

    useMetric = mkEnableOption "Use metric units in the system";
    useEuropeanCurrency = mkEnableOption "Use European currency in the system";
    useA4Paper = mkEnableOption "Use A4 paper in the system";
    useISODate = mkEnableOption "Use ISO date format in the system";
  };

  config = lib.mkIf cfg.enable {
    # Select internationalization properties.
    i18n = {
      defaultLocale = cfg.locale;
      inherit (cfg) supportedLocales;
      extraLocaleSettings = lib.mkDefault rec {
        LANGUAGE = cfg.locale;
        LC_ADDRESS = LANGUAGE;
        LC_ALL = LANGUAGE;
        LC_COLLATE = LANGUAGE;
        LC_CTYPE = LANGUAGE;
        LC_IDENTIFICATION = LANGUAGE;
        # Use Irish Locale as European English: https://unix.stackexchange.com/a/62317
        LC_MEASUREMENT =
          if cfg.useMetric
          then "en_IE.UTF-8"
          else LANGUAGE;
        LC_MESSAGES = LANGUAGE;
        LC_MONETARY =
          if cfg.useEuropeanCurrency
          then "en_IE.UTF-8"
          else LANGUAGE;
        LC_NAME = LANGUAGE;
        LC_NUMERIC = LANGUAGE;
        LC_PAPER =
          if cfg.useA4Paper
          then "en_US.UTF-8"
          else LANGUAGE;
        LC_TELEPHONE = LANGUAGE;
        LC_TIME =
          if cfg.useISODate
          then "en_DK.utf8"
          else LANGUAGE;
      };
    };
  };
}
