self: super: {
  haskellPackages = super.haskellPackages.override {
    overrides = import ../performOverlay.nix self super self.haskellOverlays;
  };
}
