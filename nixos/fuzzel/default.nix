{ pkgs, ... }:
{
  home.packages = with pkgs; [
    fuzzel
  ];

  xdg.configFile."fuzzel".source = ./conf;
}
