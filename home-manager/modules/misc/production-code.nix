{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      ghex
      dconf2nix
      tokei
      typstfmt
      yamlfmt
      ;
    inherit
      (pkgs.nodePackages_latest)
      dotenv-cli
      forever
      nodejs
      ;
    inherit
      (pkgs.python312Packages)
      pyppeteer
      ;
  };
}
