{
  perSystem = {
    config,
    pkgs,
    inputs',
    ...
  }: {
    devShells = {
      default = pkgs.mkShellNoCC {
        name = "NixOS-config";

        nativeBuildInputs = with pkgs; [
          age
          deadnix
          inputs'.nvfetcher.packages.default
          inputs'.sops-nix.packages.sops-import-keys-hook
          just
          nixpkgs-fmt
          sops
          ssh-to-age
        ];

        sopsPGPKeyDirs = ["./secrets/hosts/" "./secrets/users/"];

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
  };
}
