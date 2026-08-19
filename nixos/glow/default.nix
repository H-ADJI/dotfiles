{ pkgs, ... }:
{
  home.packages = with pkgs; [
    glow
  ];

  xdg.configFile."glow/glow.yml".source = ./glow.yml;
}
