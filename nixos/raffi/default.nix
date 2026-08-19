{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fuzzel
    raffi
  ];

  xdg.configFile = {
    "raffi/noctalia.yml".source = ./noctalia.yml;
    "raffi/tuis.yml".source = ./tuis.yml;
    "raffi/layouts.yml".source = ./layouts.yml;
  };
}
