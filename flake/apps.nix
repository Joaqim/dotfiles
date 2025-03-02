{inputs, ...}: {
  perSystem = {self', ...}: {
    apps = {
      commit-nvfetcher = {
        type = "app";
        program = toString (
          inputs.nixpkgs.legacyPackages.x86_64-linux.writeShellScript "commit-nvfetcher" ''
            ${inputs.self.packages.x86_64-linux.commit-nvfetcher}/bin/commit-nvfetcher -k /tmp/github-key.toml
          ''
        );
      };
      default = self'.apps.commit-nvfetcher;
    };
  };
}
