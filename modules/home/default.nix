{lib, ...}:
# Automatically import all modules in the directory
# Many of these are enabled by default, use modules/nixos/profiles to selectively disable per `user` and/or `system`
let
  files = builtins.readDir ./.;
  modules = builtins.removeAttrs files ["default.nix"];
in {
  imports =
    lib.mapAttrsToList (
      name: _: ./${name}
    )
    modules;
  home.stateVersion = lib.mkForce "24.11";
}
