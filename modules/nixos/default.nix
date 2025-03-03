# Common modules
{lib, ...}: {
  imports = [
    ./hardware
    ./home
    #./profiles
    #./programs
    ./secrets
    ./services
    ./system
  ];
  time.timeZone = lib.mkDefault "Europe/Stockholm";

  options.my = with lib; {
    user = {
      name = mkOption {
        type = types.str;
        default = "jq";
        example = "alice";
        description = "account username";
      };

      fullName = mkOption {
        type = types.str;
        example = "Alice Cooper";
        description = "descriptive name used by account";
      };

      email = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "mail@example.org";
        description = "email used for git module";
      };

      home = {
        enable = my.mkDisableOption "home-manager configuration";
      };
    };
  };
}
