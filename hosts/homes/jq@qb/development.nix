_: {
  my.home.development = {
    nix.cache.extraSubstituters = false;
    nvf = {
      enable = true;
      claudeCode.command = "i"; # Use our AI Agent Iris
    };
    vscode.enable = true;
  };
}
