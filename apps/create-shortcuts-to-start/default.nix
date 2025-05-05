{
  steamtinkerlaunch,
  writeShellApplication,
  ...
}:
writeShellApplication rec {
  name = "create-shortcuts-to-start";
  text = builtins.readFile ./${name}.sh;

  runtimeInputs = [steamtinkerlaunch];

  runtimeEnv = {
    # Allows running 'steamtinkerlaunch' from cli without desktop
    # Only works with my own patched 'steamtinkerlaunch'
    ONSTEAMDECK = 1;
  };

  meta = {
    description = "";
    platforms = ["x86_64-linux"];
  };
}
