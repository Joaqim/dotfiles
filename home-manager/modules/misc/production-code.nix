{pkgs, ...}: {
  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      ghex
      dconf2nix
      tokei
      typstfmt
      yamlfmt
      dotenv-cli
      ;
    inherit
      (pkgs.nodePackages_latest)
      forever
      nodejs
      ;
    inherit
      (pkgs.python312Packages)
      pyppeteer
      ;
  };
}
