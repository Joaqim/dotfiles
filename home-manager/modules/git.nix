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
    ignores = [
      ".envrc"
      ".direnv/"
    ];
    extraConfig = {
      branch.autoSetupRebase = "always";
      checkout.defaultRemote = "origin";

      pull.rebase = true;
      pull.ff = "only";
      push.default = "current";

      init.defaultBranch = "main";
      submodule.recurse = "true";

      url."ssh://git@".pushInsteadOf = "https://";
    };
  };
}
