{ pkgs, ... }: {
  programs.desktoppr = {
    enable = true;
    settings = {
      picture = ./assets/coa_macos.png;
      scale = "fill";
      setOnlyOnce = true;
    };
  };
}
