_: {
  my.home.development = {
    nix.cache.extraSubstituters = false;
    nvf = {
      enable = true;
      # TODO: This does'n seem to work
      claudeCode.command = "i"; # Use our AI Agent Iris
    };
    vscode.enable = true;
  };
}
