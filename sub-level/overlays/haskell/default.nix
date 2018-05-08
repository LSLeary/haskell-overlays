self: super: {
  haskellPackages = super.haskellPackages.override {
    overrides = import ./performOverlay.nix self super [
      ./xmonad-hoverlay.nix
      ./xmonad-contrib-hoverlay.nix
      ./xmonad-semigroup-hoverlay.nix
      ./xmonad-contrib-nohaddock-hoverlay.nix
    ];
  };
}
