{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.home.gpg;
in {
  options.my.home.gpg = with lib; {
    enable = my.mkDisableOption "gpg configuration";

    pinentry = mkPackageOption pkgs "pinentry" {default = ["pinentry-gtk2"];};
  };

  config = lib.mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      defaultCacheTtl = 86400;
      maxCacheTtl = 2592000;
      pinentry.package = cfg.pinentry;
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };
    programs.gpg = {
      enable = true;
      settings = {
        fixed-list-mode = true;
        keyid-format = "0xlong";
        personal-digest-preferences = builtins.concatStringsSep " " [
          "SHA512"
          "SHA384"
          "SHA256"
        ];
        personal-cipher-preferences = builtins.concatStringsSep " " [
          "AES256"
          "AES192"
          "AES"
        ];
        default-preference-list = builtins.concatStringsSep " " [
          "SHA512"
          "SHA384"
          "SHA256"
          "AES256"
          "AES192"
          "AES"
          "ZLIB"
          "BZIP2"
          "ZIP"
          "Uncompressed"
        ];
        use-agent = true;
        verify-options = "show-uid-validity";
        list-options = "show-uid-validity";
        cert-digest-algo = "SHA512";
        throw-keyids = false;
        no-emit-version = true;
      };

      scdaemonSettings.disable-ccid = true;
    };
  };
}
