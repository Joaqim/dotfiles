let
  user0 = "jq";
in {
  inherit
    user0
    ;
  users = {
    mutableUsers = false;
    "${user0}" = {
      name = "Joaqim";
      email = "mail@joaqim.xyz";
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK58SYMpYN5W9x8tt7gBoGT8bSOFVagSWxJsD4wPU5Z1 mail@joaqim.xyz"
      ];
    };
  };
}
