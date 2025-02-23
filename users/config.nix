let
  user0 = "jq";
  user1 = "deck";
in {
  inherit
    user0
    user1
    ;
  users = {
    mutableUsers = false;
    "${user0}" = {
      name = "Joaqim Planstedt";
      email = "mail@joaqim.xyz";
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK58SYMpYN5W9x8tt7gBoGT8bSOFVagSWxJsD4wPU5Z1 mail@joaqim.xyz"
      ];
    };
    "${user1}" = {
      name = "Steam Deck User";
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK58SYMpYN5W9x8tt7gBoGT8bSOFVagSWxJsD4wPU5Z1 mail@joaqim.xyz"
      ];
    };
  };
}
