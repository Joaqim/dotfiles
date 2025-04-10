{writeShellApplication, ...}:
writeShellApplication rec {
  name = "dry-activate";
  text = builtins.readFile ./${name}.sh;
  meta.description = "Dry-activate NixOS and home-manager configuration";
}
