{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.disko
    ./boot.nix
    ./disko-config.nix
    ./hardware.nix
    ./home.nix
    ./impermanence.nix
    ./networking.nix
    ./profiles.nix
    ./programs.nix
    ./services.nix
    ./system.nix
  ];

  # For now, nixos modules that expects name, full name or email will always use this user
  # This is different from home-manager modules which can be different users
  # TODO: Have hardcoded `user0` and optional`user1` which we can assign username, full name and, optionally, email
  my.user = {
    name = "wilton";
    fullName = "Wilton";
  };

  time.timeZone = "Europe/Stockholm";
  system.stateVersion = lib.mkForce "24.11";
}
