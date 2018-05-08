self: super:
let addBD = super.haskell.lib.addBuildDepend;
    hol = hself: hsuper: {
      xmonad         = addBD hsuper.xmonad         hself.semigroups;
      xmonad-contrib = addBD hsuper.xmonad-contrib hself.semigroups;
    };
in  { haskellOverlays = super.haskellOverlays ++ [ hol ]; }
