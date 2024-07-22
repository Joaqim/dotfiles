{
  pkgs,
  config,
  inputs',
  ...
}: {
  devShells = {
    default = pkgs.mkShell {
      packages = builtins.attrValues {
        inherit (pkgs) age alejandra just nil sops ssh-to-age ripgrep mkpasswd;
      };
      sopsPGPKeyDirs = ["./secrets/hosts/" "./secrets/users/"];

      nativeBuildInputs = [inputs'.sops-nix.packages.sops-import-keys-hook];
      shellHook = "${config.pre-commit.installationScript}";
    };
  };
}
