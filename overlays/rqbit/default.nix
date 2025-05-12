_self: prev: {
  rqbit = prev.rqbit.overrideAttrs {
    patches = [./seed-read-only.patch];
  };
}
