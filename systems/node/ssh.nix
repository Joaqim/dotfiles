{flake, ...}: let
  inherit
    (flake.config.people)
    user0
    ;
in {
  users.users.${user0} = {
    openssh.authorizedKeys.keys = flake.config.people.users.${user0}.sshKeys;
  };
  services = {
    sshd.enable = true;
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "prohibit-password";
        X11Forwarding = true;
      };
    };
  };
}
