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
          just
          sops
          ssh-to-age
          gitAndTools.pre-commit
          nixpkgs-fmt
          inputs'.sops-nix.packages.sops-import-keys-hook
        ];

        sopsPGPKeyDirs = ["./secrets/hosts/" "./secrets/users/"];

        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
  };
}
