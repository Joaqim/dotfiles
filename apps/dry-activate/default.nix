{writeShellApplication, ...}:
writeShellApplication {
  name = "dry-activate";
  text = builtins.readFile ./dry-activate.sh;
}
