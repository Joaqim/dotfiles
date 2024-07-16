{pkgs, ...}: {
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    package = pkgs.zoxide;
    options = [
    ];
  };
}
