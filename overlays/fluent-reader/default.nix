self: _prev: {
  fluent-reader = self.pkgs.jqpkgs.fluent-reader-from-src.overrideAttrs {
    patches = [ ./open-magnet-links.patch ];
  };
}
