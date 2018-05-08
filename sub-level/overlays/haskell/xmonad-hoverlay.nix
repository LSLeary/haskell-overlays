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
