{ pkgs, ... }: {
  programs.desktoppr = {
    enable = true;
    settings = {
      picture = ./coa.png;
      scale = "fill";
      setOnlyOnce = true;
    };
  };
}
