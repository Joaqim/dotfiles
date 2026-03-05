{
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.jqpkgs.nixosModules.default
    ./boot.nix
    ./disko-config.nix
    ./hardware.nix
    ./home.nix
    ./networking.nix
    ./profiles.nix
    ./programs.nix
    ./services.nix
    ./system.nix
  ];
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  jqpkgs.cache.enable = true;

  # Disable auto-suspend, TODO: Wait for better solution: https://github.com/NixOS/nixpkgs/issues/100390

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.login1.suspend" ||
            action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
            action.id == "org.freedesktop.login1.hibernate" ||
            action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
        {
            return polkit.Result.NO;
        }
    });
  '';

  services.displayManager.gdm.autoSuspend = false;

  # For now, nixos modules that expects name, full name or email will always use this user
  # This is different from home-manager modules which can be different users
  # TODO: Have hardcoded `user0` and optional`user1` which we can assign username, full name and, optionally, email
  my.user = {
    name = "jq";
    fullName = "Joaqim Planstedt";
    email = "mail@joaqim.xyz";
  };

  time.timeZone = "Europe/Stockholm";
  system.stateVersion = lib.mkForce "24.11";
}
