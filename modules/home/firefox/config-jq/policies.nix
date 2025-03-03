{lib, ...}: {
  ExtensionUpdate = false;
  "3rdparty".Extensions = {
    # # https://github.com/libredirect/browser_extension/blob/b3457faf1bdcca0b17872e30b379a7ae55bc8fd0/src/config.json
    # "7esoorv3@alefvanoon.anonaddy.me" = {
    # 	# FIXME-UPSTREAM(Krey): This doesn't work, implementation tracked in https://github.com/libredirect/browser_extension/issues/905
    # 	services.youtube.options.enabled = true;
    # };
    # https://github.com/gorhill/uBlock/blob/master/platform/common/managed_storage.json
    "ublock-origin".adminSettings = {
      userSettings = rec {
        uiTheme = "dark";
        uiAccentCustom = true;
        uiAccentCustom0 = "#8300ff";
        cloudStorageEnabled = lib.mkForce false; # Security liability?
        importedLists = [
          "https://filters.adtidy.org/extension/ublock/filters/3.txt"
          "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
        ];
        externalLists = lib.concatStringsSep "\n" importedLists;
      };
      selectedFilterLists = [
        "CZE-0"
        "adguard-generic"
        "adguard-annoyance"
        "adguard-social"
        "adguard-spyware-url"
        "easylist"
        "easyprivacy"
        "https://github.com/DandelionSprout/adfilt/raw/master/LegitimateURLShortener.txt"
        "plowe-0"
        "ublock-abuse"
        "ublock-badware"
        "ublock-filters"
        "ublock-privacy"
        "ublock-quick-fixes"
        "ublock-unbreak"
        "urlhaus-1"
      ];
    };
  };
}
