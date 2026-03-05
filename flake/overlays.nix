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
    pkgs = _final: prev: {

      imports = [
        inputs.steam-shortcuts.overlays.default
        inputs.jqpkgs.overlays.default
      ];
      # Expose my custom packages
      my = lib.recurseIntoAttrs (
        import "${self}/pkgs" {
          inherit self;
          pkgs = prev;
          flake-inputs = inputs;
        }
      );
      # Polyfill pkgs.recurseIntoAttrs for when it's not accessed from lib
      inherit (lib) recurseIntoAttrs;
    };
  };
in
{
  flake.overlays = default-overlays // additional-overlays;
}
