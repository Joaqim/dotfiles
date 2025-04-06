{
  config,
  lib,
  ...
}: let
  cfg = config.my.profiles.language;
in {
  options.my.profiles.language = with lib; {
    enable = my.mkDisableOption "language profile";
    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      example = "sv_SE.UTF-8";
      description = "Which locale to use for the system";
    };
    supportedLocales = mkOption {
      type = types.listOf types.str;
      default = [
        "C.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];
      example = ["C.UTF-8/UTF-8" "en_US.UTF-8" "se_SV.UTF-8"];
      description = "List of locales supported by the system";
    };
    useEuropeanEnglish = mkEnableOption "Override english locale to use metric units, dates and european currency and paper formats in the system";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      assertions = [
        {
          assertion =
            cfg.useEuropeanEnglish -> (builtins.substring 0 2 cfg.locale) == "en";

          message = ''
            enabling `my.profiles.language.useEuropeanEnglish` needs to have
            `my.profiles.language.locale = "en_US.UTF-8"` or any other english locale e.g. "en_IE.UTF-8"`
          '';
        }
      ];
    }
    {
      my.system.language = {
        enable = true;
        inherit (cfg) locale supportedLocales;
        useA4Paper = cfg.useEuropeanEnglish;
        useEuropeanCurrency = cfg.useEuropeanEnglish;
        useISODate = cfg.useEuropeanEnglish;
        useMetric = cfg.useEuropeanEnglish;
      };
    }
  ]);
}
