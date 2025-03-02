{config, ...}: {
  # Many of these are enabled by default, use modules/nixos/profiles to import per `user@system`
  imports = [
    ./atuin
    ./bat
    ./bottom
  ];

  home.stateVersion = config.system.stateVersion;
}
