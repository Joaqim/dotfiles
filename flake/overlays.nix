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
        # TODO: Overlays not working ?
        inputs.nix-minecraft.overlays.default
        inputs.steam-shortcuts.overlays.default
      ];

      # Provide scoped `pkgs.jqpkgs`
      jqpkgs = lib.recurseIntoAttrs (
        inputs.jqpkgs.overlays.default null # _final remains unused
          prev
      );

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
