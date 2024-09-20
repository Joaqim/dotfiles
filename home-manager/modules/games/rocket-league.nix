{
  pkgs,
  flake,
  ...
}: {
  home.packages = let
    gamePkgs = flake.inputs.nix-gaming.packages.${pkgs.system};
  in
    builtins.attrValues {
      inherit
        (pkgs)
        legendary-gl # Login to Epic Store using: `legendary auth`
        ;
      rocket-league = gamePkgs.rocket-league.override {
        enableBakkesmod = true;
      };
    };
}
