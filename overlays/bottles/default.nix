_self: prev: {
  bottles = prev.bottles.override {
    removeWarningPopup = true;
  };
}
