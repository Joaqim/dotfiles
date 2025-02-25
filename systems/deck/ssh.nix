{flake, ...}: let
  inherit
    (flake.config.people)
    user0
    user1
    ;
in {
  users.users = {
    ${user0} = {
      openssh.authorizedKeys.keys = flake.config.people.users.${user0}.sshKeys;
    };
    ${user1} = {
      openssh.authorizedKeys.keys =
        flake.config.people.users.${user0}.sshKeys
        ++ flake.config.people.users.${user1}.sshKeys;
    };
  };
}
