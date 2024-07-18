{
  config,
  flake,
  ...
}: let
  user = config.home.username;
  userConfig = flake.config.people.users.${user};
in {
  programs.git = {
    enable = true;
    userName = userConfig.name;
    userEmail = userConfig.email;
  };
  programs.keychain = {
    enable = true;
    keys = ["id_ed25519"];
  };
}
