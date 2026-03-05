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
    ./services.nix
    ./system.nix
  ];

  my.user = {
    name = "jq";
    fullName = "Joaqim Planstedt";
    email = "mail@joaqim.xyz";
  };

  time.timeZone = "Europe/Stockholm";
  system.stateVersion = lib.mkForce "24.11";
}
