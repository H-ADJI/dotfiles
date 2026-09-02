{ pkgs, ... }: {
  programs.desktoppr = {
    enable = true;
    settings = {
      picture = ./coa_macos.png;
      scale = "fill";
      setOnlyOnce = true;
    };
  };
}
