self: super: hself: hsuper: {
  xmonad-contrib = hsuper.xmonad-contrib.overrideAttrs (oa: {
    src = super.fetchFromGitHub {
      owner  = "LSLeary";
      repo   = "xmonad-contrib";
      rev    = "b730b098c4008575d8682a12936bb070e0f65475"; # Gridfix
      sha256 = "123482ma6zywy4w75a93gqxhipaxczpmlpf5p8b5gjd2qjvwbsyy";
    # rev    = "919d1fb75dec44b2c942889f27fba669fdb31063"; # quadrant latest
    # sha256 = "1p2shn68dkr05qvdh79bhmla88gs7k34a3m6mrxidssw9szi413l";
    # rev    = "ff06b1bbb2dc8dd079443d41917fa877dfe445ee"; # statefull latest
    # sha256 = "16gdamgr2m0f1a658h9y3ib0z5xx710ik4rl90h1zn9ivzj1zdnf";
    };
  });
}
