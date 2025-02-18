{
  config,
  flake,
  lib,
  ...
}: let
  user = config.home.username;
  userConfig = flake.config.people.users.${user};
in {
  programs.git = {
    enable = true;
    userName = userConfig.name;
    userEmail = userConfig.email;
    signing = {
      key = lib.mkDefault null;
      signByDefault = true;
      format = "ssh";
    };
    ignores = [
      ".envrc"
      ".direnv/"
    ];
    extraConfig = {
      branch.autoSetupRebase = "always";
      checkout.defaultRemote = "origin";

      # Sign all commits using ssh key
      commit.gpgsign = true;
      user.signingkey = "~/.ssh/id_ed25519.pub";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";

      pull.rebase = true;
      pull.ff = "only";
      push.default = "current";

      init.defaultBranch = "main";
      submodule.recurse = "true";

      url."ssh://git@".pushInsteadOf = "https://";
    };
  };
}
