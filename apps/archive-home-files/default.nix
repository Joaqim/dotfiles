{pkgs, ...}:
pkgs.writeShellApplication rec {
  name = "archive-home-files";
  text = builtins.readFile ./${name}.bash;
  runtimeInputs = with pkgs; [
    gnutar
    ripgrep
    coreutils
  ];
  meta = {
    description = "Take a snapshot of current home-manager files in home";
  };
}
