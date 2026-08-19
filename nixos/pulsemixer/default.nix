{ pkgs, ... }:
{
  home.packages = with pkgs; [ pulsemixer ];
  xdg.configFile."pulsemixer.cfg".source = ./pulsemixer.cfg;
}
