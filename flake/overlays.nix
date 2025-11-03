{
  inputs,
  self,
  lib,
  ...
}:
let
  default-overlays = import "${self}/overlays";

  additional-overlays = {
    # Expose my expanded library
    lib = _final: _prev: { inherit (self) lib; };

    # Expose my custom packages
    pkgs = _final: prev: {
      jqpkgs = lib.recurseIntoAttrs (
        import "${self}/pkgs" {
          inherit self;
          pkgs = prev;
          flake-inputs = inputs;
        }
      );
      /*
        https://github.com/nix-community/nur-combined/blob/fb903d2993b7cd6961b7d64b97c9d3938badc5ca/repos/aasg/lib/attrsets.nix#L53
        recurseIntoAttrs :: set -> set

        Polyfill of pkgs.recurseIntoAttrs for when it's accessed from lib
      */
      recurseIntoAttrs = lib.recurseIntoAttrs or (attrs: attrs // { recurseForDerivations = true; });
    };
  };
in
{
  flake.overlays = default-overlays // additional-overlays;
}
