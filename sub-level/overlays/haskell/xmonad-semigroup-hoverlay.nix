self: super: hself: hsuper:
let addSGD = p: super.haskell.lib.addBuildDepend p hself.semigroups;
in  { xmonad         = addSGD hsuper.xmonad;
      xmonad-contrib = addSGD hsuper.xmonad-contrib; }
