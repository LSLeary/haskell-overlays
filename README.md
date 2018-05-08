# haskell-overlays
By default, overlays targeting packages in haskellPackages are forced to replace the whole haskell ecosystem in a way that does not compose, and is not modular.
This repository describes and demonstrates two approaches to writing modular, composable overlays for haskell packages, both of which should also apply equally well to other such ecosystems.

The core of both approaches is the idea of manually doing for haskellPackages what the overlay system does for top-level packages.

## As Sub-overlays
_Example hoverlay upgrading xmonad to use more recent source from git_
```nix
# sub-level/overlays/haskell/xmonad-hoverlay.nix
self: super: hself: hsuper: {
  xmonad = hsuper.xmonad.overrideAttrs (oa: {
    src = super.fetchFromGitHub {
      owner = "xmonad";
      repo = "xmonad";
      rev = "ecf1a0ca0d094c76a18c2c1b77ac7c1dcac10f5e";
      sha256 = "1pwzjf1xix2jcn8j276nfnn7arh680lf0z25qfb5ziaafjcwym8k";
    };
  });
}
```
A haskell sub-overlay or hoverlay is similar to a regular overlay, but takes two additional arguments and addresses haskell packages directly.
  - `self` is the final state of `pkgs` after applying all overlays. Used to access non-haskell packages.
  - `super` is the state of `pkgs` prior to applying any hoverlays. Used for utility functions.
  - `hself` is the final state of `haskellPackages` after applying all hoverlays. Used to access haskell packages not being overridden by the hoverlay.
  - `hsuper` is the state of `haskellPackages` prior to applying the current hoverlay. Used to access haskell packages being overridden by the hoverlay.

The hoverlays are kept in a `haskell/` subdirectory with a `default.nix` which is a regular overlay.
```nix
# sub-level/overlays/haskell/default.nix
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
```
Note the construction of the overlay performed by application of `./performOverlay.nix self super` to the list of hoverlay files. The source is a left-fold with `extend`; accumulating net updates to haskellPackages.
```nix
# sub-level/overlays/haskell/performOverlay.nix
self: super: hoverlayfiles: hself: hsuper:
  let extend = lhs: rhs: lhs // rhs lhs;
  in  super.lib.foldl extend hsuper (
        map (hol: hol self super hself) (map import hoverlayfiles))
```

## As Top-Level Overlays
_Example overlay appending to `haskellOverlays` with the eventual effect of upgrading xmonad to use more recent source from git_
```nix
# top-level/overlays/50-xmonad-overlay.nix
self: super:
let hol = hself: hsuper: {
  xmonad = hsuper.xmonad.overrideAttrs (oa: {
    src = super.fetchFromGitHub {
      owner = "xmonad";
      repo = "xmonad";
      rev = "ecf1a0ca0d094c76a18c2c1b77ac7c1dcac10f5e";
      sha256 = "1pwzjf1xix2jcn8j276nfnn7arh680lf0z25qfb5ziaafjcwym8k";
    };
  });
};
in { haskellOverlays = super.haskellOverlays ++ [ hol ]; }
```
This method is largely similar to the sub-overlay strategy, except that the files themselves are regular overlays which append sub-overlay-like functions to the top level attribute `haskellOverlays`.
These functions could be exactly the same as the sub-overlays of the previous section, but the `self` and `super` values are already provided by the regular overlay, hence what we append is equivalent to an hoverlay that has had the two arguments applied in advance.
In and of itself the overlay above does nothing to the xmonad package; the framework required for it to take effect is provided by these two overlays.
```nix
# top-level/overlays/10-haskellOverlays.nix
self: super: { haskellOverlays = []; }
```
```nix
# top-level/overlays/90-haskellPackages-overlay.nix
self: super: {
  haskellPackages = super.haskellPackages.override {
    overrides = import ../performOverlay.nix self super self.haskellOverlays;
  };
}
```
The former sets up the haskellOverlays attribute so that later overlays can append to it without needing to worry about it possibly not being present yet, the latter does the job that `default.nix` did in the previous section, except in this case
there are a few changes to `performOverlay.nix`:
```nix
# top-level/performOverlay.nix
self: super: hoverlays: hself: hsuper:
  let extend = lhs: rhs: lhs // rhs lhs;
  in  super.lib.foldl extend hsuper (map (hol: hol hself) hoverlays)
```
Note that without a default.nix, the files need to be named in such a way that they will be used in the intended order, and `performOverlay.nix` must be placed somewhere out of the way.
The naming strategy used for modular configuration of varying priority in `*.conf.d/` directories is thus adopted for use here.

## Disclaimer & Feedback
I, the author, am relatively new to NixOS and nix.
This repository is the product of wanting to solve the practical problem in front of me, and wanting more experience writing nix.
There may already be good, well known solutions to this problem that I am simply not aware of.
I welcome any suggestions for improving the overlays and techniques discussed above.
