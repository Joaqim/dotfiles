{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.services.github-runner;
in
{
  imports = [
    inputs.github-nix-ci.nixosModules.default
    inputs.agenix.nixosModules.default
  ];

  options.my.services.github-runner = with lib; {
    enable = mkEnableOption "GitHub runner";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.hostPlatform.system = "x86_64-linux";
    services.github-nix-ci = {
      personalRunners = {
        "Joaqim/pkgs" = {
          num = 1;
          tokenFile = config.sops.secrets."github_token/github-runner-desktop".path;
        };
      };
    };
  };
}
