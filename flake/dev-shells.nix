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
          go-task # See ../Taskfile.yml
          inputs'.nvfetcher.packages.default
          inputs'.sops-nix.packages.sops-import-keys-hook
          just
          nixpkgs-fmt
          sops
          ssh-to-age
        ];

        buildInputs = with pkgs; [
          gitleaks
        ];

        sopsPGPKeyDirs = ["./secrets/hosts/" "./secrets/users/"];

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
  };
}
