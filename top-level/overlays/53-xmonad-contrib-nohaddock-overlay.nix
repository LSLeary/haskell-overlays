self: super:
let hol = hself: hsuper: {
  xmonad-contrib = super.haskell.lib.dontHaddock hsuper.xmonad-contrib;
};
in { haskellOverlays = super.haskellOverlays ++ [ hol ]; }
