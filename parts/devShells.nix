{ pkgs, inputs, config, ... }:

let
  inherit (inputs.sops-nix.packages) sops-init-gpg-key sops-import-keys-hook;
  inherit (inputs.self.packages) commit-nvfetcher;
  #inherit (inputs.nixpkgs.legacyPackages) nvchecker age alejandra just nil sops ssh-to-age;
  home-manager-bin = inputs.home-manager.packages.default;
in
{
  devShells.default = pkgs.mkShell {
    packages = [
      inputs.nvfetcher.packages.default
      nvchecker
      commit-nvfetcher
      home-manager-bin
      sops-init-gpg-key

      pkgs.age
      pkgs.alejandra
      pkgs.just
      pkgs.nil
      pkgs.sops
      pkgs.ssh-to-age
    ];

    sopsPGPKeyDirs = [
      "./keys/hosts/"
      "./keys/users/"
    ];
    nativeBuildInputs = [ sops-import-keys-hook ];
    shellHook = "${config.pre-commit.installationScript}";
  };
}