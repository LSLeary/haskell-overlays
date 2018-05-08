self: super: {
  ncmpcpp = super.ncmpcpp.override {
    visualizerSupport = true;
    fftw = self.fftw;
  };
}
